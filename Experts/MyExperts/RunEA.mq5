//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Trading/Trading.mqh>
#include <MyDoEasy/Objects/AccountObject.mqh>
#include <MyDoEasy/Objects/DealObject.mqh>
#include <MyDoEasy/Objects/OrderObject.mqh>
#include <MyDoEasy/Objects/PositionObject.mqh>
#include <MyDoEasy/Objects/SymbolObject.mqh>


//+------------------------------------------------------------------+
//| Define
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Enum
//+------------------------------------------------------------------+

//--- 注文の取引量の決定方法
enum ENUM_LOT_CALC_TYPE
   {
    fixed,      // 固定値
    percent,    // 残高に対する百分率
    risk       // 残高に対する損失許容額の百分率
   };


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input ulong                 input_magic_number          = 12345;    // マジックナンバー

input ENUM_LOT_CALC_TYPE    input_lot_calc_type         = fixed;    // ロットの算出基準
input double                input_lot_value             = 0.1;      // ロットの指定値

input ushort                input_stop_loss             = 0;        // 損切りのpips
input ushort                input_take_profit           = 0;        // 利食いのpips
input ulong                 input_slippage              = 5;        // スリッページ
input bool                  input_use_trailing_stop     = false;    // トレーリングストップの利用
input ushort                input_trailing_stop         = 0;        // トレーリングストップの乖離値
input ushort                input_trailing_step         = 0;        // トレーリングストップの刻み幅
input bool                  input_print_log             = true;    // ログ出力の有無


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
int                     num_position                    = 0;
double                  adjusted_point;
double                  adjusted_stop_loss              = 0.0;
double                  adjusted_take_profit            = 0.0;
double                  adjusted_trailing_stop          = 0.0;
double                  adjusted_trailing_step          = 0.0;
bool                    is_transaction_waiting          = false;    // 次の取引までの待機状態
bool                    is_transaction_confirmed        = false;    // 取引の完了状態
ulong                   order_ticket_waiting            = 0;        // 待機注文のチケットID


CTrading                ins_trading;
CAccountObject          ins_account;
CDealObject             ins_deal;
COrderObject            ins_order;
CPositionObject         ins_position;
CSymbolObject           ins_symbol;


//+------------------------------------------------------------------+
//| 外部ファイルに切り出した関数の読み込み
//+------------------------------------------------------------------+
#include "./Utils/Order.mqh"
#include "./Utils/Position.mqh"
#include "./Utils/Print.mqh"
#include "./Utils/Signal.mqh"
#include "./Utils/Trailing.mqh"
// #include "./Utils/Transaction.mqh"
#include "./Utils/Util.mqh"


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
   {

//--- バックテストまたはデモ口座の環境で実行させるための処理
    ENUM_ACCOUNT_TRADE_MODE account_type = (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
    if(!MQLInfoInteger(MQL_TESTER) && ACCOUNT_TRADE_MODE_REAL == account_type)
       {
        Print("バックテストまたはデモ口座の環境を前提にしています。本番環境では実行しないでください。");
        return(INIT_FAILED);
       }
    if(MQLInfoInteger(MQL_TESTER))
        Print("バックテストの環境で実行します。");
    if(ACCOUNT_TRADE_MODE_DEMO == account_type)
        Print("デモ口座の環境で実行します。");

//--- 取引用インスタンスを初期化
    ins_trading.SetExpertMagicNumber(input_magic_number);
    ins_trading.SetMarginMode();
    ins_trading.SetTypeFillingBySymbol(_Symbol);

//--- 銘柄インスタンスに銘柄名を設定(ついでに、気配値表示に銘柄が存在しなければ追加)
    if(!ins_symbol.SetName(_Symbol))
        return(INIT_FAILED);

//--- 小数点以下の桁数によって、pipsとポイントのズレを補正
//--- 小数点以下が2桁または4桁の場合は、1ポイントは1pipsと同義
//--- 小数点以下が3桁または5桁の場合は、10ポイントで1pipsを意味する
    int digits_adjust = 1;
    if(ins_symbol.GetDigits() == 3 || ins_symbol.GetDigits() == 5)
        digits_adjust = 10;
    adjusted_point = ins_symbol.GetPoint() * digits_adjust;

//--- トレーリング用の変数の調整
    adjusted_trailing_stop = input_trailing_stop * adjusted_point;
    adjusted_trailing_step = input_trailing_step * adjusted_point;

//--- シグナルに関する初期化
    InitSignal();

//--- ハンドルの取得が失敗している場合の例外処理
    if(is_invalid)
       {
        return(INIT_FAILED);
       }

//---
    return(INIT_SUCCEEDED);
   }


//+------------------------------------------------------------------+
//| Expert tick function
//+------------------------------------------------------------------+
void OnTick(void)
   {

//--- 新しいローソク足が出現した後の最初のティックのみ、以下を実行
    static datetime prev_bar_time = 0;

//--- 最新のローソク足が発生した日時を取得
    datetime time_0 = iTime(ins_symbol.GetName(), PERIOD_CURRENT, 0);

//--- すでに実行済みなので、即座に終了
    if(time_0 == prev_bar_time)
        return;

    prev_bar_time = time_0;
    if(!RefreshRates())
        prev_bar_time = 0;

//--- シグナルの更新
    UpdateSingal();

    /*
    //--- 取引は待機状態となっているが、完了が確認できている場合
    //--- 取引の待機状態を解除する
        if(is_transaction_waiting)
            if(is_transaction_confirmed) {
                is_transaction_waiting = false;
                order_ticket_waiting = 0;
                is_transaction_confirmed = false;
                Print(__FUNCTION__, "取引の完了");

            }
    */

//--- 売買信号が出ている場合
    if((is_go_long || is_go_short) && !(is_go_long && is_go_short))
       {
        //--- 現在の売買ポジションの個数（取引量は不問）を取得
        int num_long = 0, num_short = 0;
        CalcAllPositions(num_long, num_short);



        //--- 買い信号の場合
        if(is_go_long)
           {
            //--- すでに売り建玉があれば全決済
            if(num_short != 0)
               {
                ins_trading.PositionCloseAllByType(POSITION_TYPE_SELL);
               }


            // 待機中の取引が無ければ、空買いする
            if(num_long == 0)
                // if(!is_transaction_waiting)
                if(RefreshRates())
                   {
                    OpenPositionByType(POSITION_TYPE_BUY);
                   }

           }

        //--- 売り信号の場合
        if(is_go_short)
           {
            //--- すでに買い建玉があれば全決済
            if(num_long != 0)
               {
                ins_trading.PositionCloseAllByType(POSITION_TYPE_BUY);
               }


            // 待機中の取引が無ければ、空売りする
            if(num_short == 0)
                //  if(!is_transaction_waiting)
                if(RefreshRates())
                   {
                    OpenPositionByType(POSITION_TYPE_SELL);
                   }

           }
       }


//--- 補正したストップレベルを加味して、トレーリングストップを実行
    if(input_use_trailing_stop)
       {
        double level;
        if(IsPositionExists())
            if(!GetFreezeStopsLevels(level))
                Trailing(level);
       }
   }


//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction & trans,
                        const MqlTradeRequest & request,
                        const MqlTradeResult & result)
   {
//---

   }

//+------------------------------------------------------------------+
