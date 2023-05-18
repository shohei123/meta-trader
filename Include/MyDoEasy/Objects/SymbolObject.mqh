//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <Object.mqh>


//+------------------------------------------------------------------+
//| Class CSymbolObject.                                               |                     |
//+------------------------------------------------------------------+
class CSymbolObject: public CObject
   {
protected:
    string                          m_name;                         // 銘柄の名前
    MqlTick                         m_tick;                         // tick構造体;
    double                          m_point;                        // 銘柄のポイントサイズ（価格の最小単位）
    double                          m_tick_value;                   //
    double                          m_tick_value_profit;            //
    double                          m_tick_value_loss;              //
    double                          m_tick_size;                    // 1ティックあたりの価格
    double                          m_contract_size;                // 1ロットあたりの取引量
    double                          m_lots_min;                     // 約定可能な最小ロット数
    double                          m_lots_max;                     // 約定可能な最大ロット数
    double                          m_lots_step;                    // 約定可能なロット数の刻み幅
    double                          m_lots_limit;                   // 片側方向の「約定ずみ・未決注文の合計取引量」の許容値
    double                          m_swap_long;                    // 長期のスワップ値
    double                          m_swap_short;                   // 短期のスワップ値
    int                             m_digits;                       // 銘柄の小数点の桁数
    int                             m_order_mode;                   // 注文可能な取引方法を示すフラグ
    ENUM_SYMBOL_TRADE_EXECUTION     m_trade_execution;              // 取引の執行方法（リクエスト・即時・マーケット・エクスチェンジ）
    ENUM_SYMBOL_CALC_MODE           m_trade_calcmode;               // 取引の価格計算の方法（Forex・Futures・CFD）
    ENUM_SYMBOL_TRADE_MODE          m_trade_mode;                   // 利用できる取引方法の種別（不可・買いのみ・売りのみ・決済のみ・制限なし）
    ENUM_SYMBOL_SWAP_MODE           m_swap_mode;                    // スワップの計算方法
    ENUM_DAY_OF_WEEK                m_swap3;                        // 市場閉鎖期間を考慮したトリプルスワップが加算される曜日
    double                          m_margin_initial;               // 1ロットの注文を出すために必要な証拠金
    double                          m_margin_maintenance;           // オープンポジションを維持するために必要な証拠金。
    bool                            m_margin_hedged_use_leg;        // ヘッジポジションの場合は、より取引量の多いポジションに対して、証拠金を計算
    double                          m_margin_hedged;                // ヘッジポジションがある場合の合計取引量の計算方法
    int                             m_trade_time_flags;             // 注文の有効期限を表すフラグ
    int                             m_trade_fill_flags;             // 充填モードを表すフラグ

public:
                     CSymbolObject(void);
                    ~CSymbolObject(void);
    string                          GetName(void)                           const {return(m_name);}
    bool                            SetName(const string name);
    bool                            Refresh(void);
    bool                            RefreshRates(void);
    bool                            IsSelected(void)                        const;
    bool                            Select(const bool select);
    bool                            IsSynchronized(void)                    const;
    ulong                           GetVolume(void)                         const {return(m_tick.volume);}
    ulong                           GetVolumeHigh(void)                     const;
    ulong                           GetVolumeLow(void)                      const;
    datetime                        GetTime(void)                           const {return(m_tick.time);}
    int                             GetSpread(void)                         const;
    bool                            GetSpreadFloat(void)                    const;
    int                             GetTicksBookDepth(void)                 const;
    int                             GetStopsLevel(void)                     const;
    int                             GetFreezeLevel(void)                    const;
    double                          GetBid(void)                            const {return(m_tick.bid);}
    double                          GetBidHigh(void)                        const;
    double                          GetBidLow(void)                         const;
    double                          GetAsk(void)                            const {return(m_tick.ask);}
    double                          GetAskHigh(void)                        const;
    double                          GetAskLow(void)                         const;
    double                          GetLast(void)                           const {return(m_tick.last);}
    double                          GetLastHigh(void)                       const;
    double                          GetLastLow(void)                        const;
    int                             GetOrderMode(void)                      const {return(m_order_mode);}
    ENUM_SYMBOL_CALC_MODE           GetTradeCalcMode(void)                  const {return(m_trade_calcmode);}
    string                          GetTradeCalcModeDescription(void)       const;
    ENUM_SYMBOL_TRADE_MODE          GetTradeMode(void)                      const {return(m_trade_mode);}
    string                          GetTradeModeDescription(void)           const;
    ENUM_SYMBOL_TRADE_EXECUTION     GetTradeExecution(void)                 const {return(m_trade_execution);}
    string                          GetTradeExecutionDescription(void)      const;
    ENUM_SYMBOL_SWAP_MODE           GetSwapMode(void)                       const {return(m_swap_mode);}
    string                          GetSwapModeDescription(void)            const;
    ENUM_DAY_OF_WEEK                GetSwapRollover3days(void)              const {return(m_swap3);}
    string                          GetSwapRollover3daysDescription(void)   const;
    datetime                        GetStartTime(void)                      const;
    datetime                        GetExpirationTime(void)                 const;
    double                          GetMarginInitial(void)                  const {return(m_margin_initial);}
    double                          GetMarginMaintenance(void)              const {return(m_margin_maintenance);}
    bool                            GetMarginHedgedUseLeg(void)             const {return(m_margin_hedged_use_leg);}
    double                          GetMarginHedged(void)                   const {return(m_margin_hedged);}
    double                          GetMarginLong(void)                     const {return(0.0);}
    double                          GetMarginShort(void)                    const {return(0.0);}
    double                          GetMarginLimit(void)                    const {return(0.0);}
    double                          GetMarginStop(void)                     const {return(0.0);}
    double                          GetMarginStopLimit(void)                const {return(0.0);}
    int                             GetTradeTimeFlags(void)                 const {return(m_trade_time_flags);}
    int                             GetTradeFillFlags(void)                 const {return(m_trade_fill_flags);}
    int                             GetDigits(void)                         const {return(m_digits);}
    double                          GetPoint(void)                          const {return(m_point);}
    double                          GetTickValue(void)                      const {return(m_tick_value);}
    double                          GetTickValueProfit(void)                const {return(m_tick_value_profit);}
    double                          GetTickValueLoss(void)                  const {return(m_tick_value_loss);}
    double                          GetTickSize(void)                       const {return(m_tick_size);}
    double                          GetContractSize(void)                   const {return(m_contract_size);}
    double                          GetLotsMin(void)                        const {return(m_lots_min);}
    double                          GetLotsMax(void)                        const {return(m_lots_max);}
    double                          GetLotsStep(void)                       const {return(m_lots_step);}
    double                          GetLotsLimit(void)                      const {return(m_lots_limit);}
    double                          GetSwapLong(void)                       const {return(m_swap_long);}
    double                          GetSwapShort(void)                      const {return(m_swap_short);}
    string                          GetCurrencyBase(void)                   const;
    string                          GetCurrencyProfit(void)                 const;
    string                          GetCurrencyMargin(void)                 const;
    string                          GetBank(void)                           const;
    string                          GetDescription(void)                    const;
    string                          GetPath(void)                           const;
    long                            GetSessionDeals(void)                   const;
    long                            GetSessionBuyOrders(void)               const;
    long                            GetSessionSellOrders(void)              const;
    double                          GetSessionTurnover(void)                const;
    double                          GetSessionInterest(void)                const;
    double                          GetSessionBuyOrdersVolume(void)         const;
    double                          GetSessionSellOrdersVolume(void)        const;
    double                          GetSessionOpen(void)                    const;
    double                          GetSessionClose(void)                   const;
    double                          GetSessionAW(void)                      const;
    double                          GetSessionPriceSettlement(void)         const;
    double                          GetSessionPriceLimitMin(void)           const;
    double                          GetSessionPriceLimitMax(void)           const;
    bool                            InfoInteger(const ENUM_SYMBOL_INFO_INTEGER prop_id, long& var) const;
    bool                            InfoDouble(const ENUM_SYMBOL_INFO_DOUBLE prop_id, double& var) const;
    bool                            InfoString(const ENUM_SYMBOL_INFO_STRING prop_id, string& var) const;
    bool                            InfoMarginRate(const ENUM_ORDER_TYPE order_type, double& initial_margin_rate, double& maintenance_margin_rate) const;
    double                          NormalizePrice(const double price)  const;
    bool                            CheckMarketWatch(void);
   };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSymbolObject::CSymbolObject(void) :
    m_name(NULL),
    m_point(0.0),
    m_tick_value(0.0),
    m_tick_value_profit(0.0),
    m_tick_value_loss(0.0),
    m_tick_size(0.0),
    m_contract_size(0.0),
    m_lots_min(0.0),
    m_lots_max(0.0),
    m_lots_step(0.0),
    m_swap_long(0.0),
    m_swap_short(0.0),
    m_digits(0),
    m_order_mode(0),
    m_trade_execution(0),
    m_trade_calcmode(0),
    m_trade_mode(0),
    m_swap_mode(0),
    m_swap3(0),
    m_margin_initial(0.0),
    m_margin_maintenance(0.0),
    m_margin_hedged_use_leg(false),
    m_margin_hedged(0.0),
    m_trade_time_flags(0),
    m_trade_fill_flags(0)
   {
   }


//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSymbolObject::~CSymbolObject(void)
   {
   }


//+------------------------------------------------------------------+
//| 銘柄名の設定
//+------------------------------------------------------------------+
bool CSymbolObject::SetName(const string name)
   {
    string symbol_name = StringLen(name) > 0 ? name : _Symbol;

//--- 前回と異なる銘柄が設定される場合
    if(m_name != symbol_name)
       {
        m_name = symbol_name;

        //--- この銘柄が気配値表示欄に表示されているのか
        if(!CheckMarketWatch())
            return(false);

        //--- 銘柄に関する各種情報を最新版に更新
        if(!Refresh())
           {
            m_name = "";
            Print(__FUNCTION__ + ": invalid data of symbol '" + symbol_name + "'");
            return(false);
           }
       }


//---
    return(true);
   }


//+------------------------------------------------------------------+
//| SymbolInfoメソッドによって、各種メンバを最新値に更新
//+------------------------------------------------------------------+
bool CSymbolObject::Refresh(void)
   {
    long tmp_long = 0;

    if(!SymbolInfoDouble(m_name, SYMBOL_POINT, m_point))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_TRADE_TICK_VALUE, m_tick_value))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_TRADE_TICK_VALUE_PROFIT, m_tick_value_profit))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_TRADE_TICK_VALUE_LOSS, m_tick_value_loss))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_TRADE_TICK_SIZE, m_tick_size))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_TRADE_CONTRACT_SIZE, m_contract_size))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_VOLUME_MIN, m_lots_min))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_VOLUME_MAX, m_lots_max))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_VOLUME_STEP, m_lots_step))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_VOLUME_LIMIT, m_lots_limit))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_SWAP_LONG, m_swap_long))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_SWAP_SHORT, m_swap_short))
        return(false);
    if(!SymbolInfoInteger(m_name, SYMBOL_DIGITS, tmp_long))
        return(false);
    m_digits = (int)tmp_long;
    if(!SymbolInfoInteger(m_name, SYMBOL_ORDER_MODE, tmp_long))
        return(false);
    m_order_mode = (int)tmp_long;
    if(!SymbolInfoInteger(m_name, SYMBOL_TRADE_EXEMODE, tmp_long))
        return(false);
    m_trade_execution = (ENUM_SYMBOL_TRADE_EXECUTION)tmp_long;
    if(!SymbolInfoInteger(m_name, SYMBOL_TRADE_CALC_MODE, tmp_long))
        return(false);
    m_trade_calcmode = (ENUM_SYMBOL_CALC_MODE)tmp_long;
    if(!SymbolInfoInteger(m_name, SYMBOL_TRADE_MODE, tmp_long))
        return(false);
    m_trade_mode = (ENUM_SYMBOL_TRADE_MODE)tmp_long;
    if(!SymbolInfoInteger(m_name, SYMBOL_SWAP_MODE, tmp_long))
        return(false);
    m_swap_mode = (ENUM_SYMBOL_SWAP_MODE)tmp_long;
    if(!SymbolInfoInteger(m_name, SYMBOL_SWAP_ROLLOVER3DAYS, tmp_long))
        return(false);
    m_swap3 = (ENUM_DAY_OF_WEEK)tmp_long;
    if(!SymbolInfoDouble(m_name, SYMBOL_MARGIN_INITIAL, m_margin_initial))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_MARGIN_MAINTENANCE, m_margin_maintenance))
        return(false);
    if(!SymbolInfoDouble(m_name, SYMBOL_MARGIN_HEDGED, m_margin_hedged))
        return(false);
    if(!SymbolInfoInteger(m_name, SYMBOL_MARGIN_HEDGED_USE_LEG, tmp_long))
        return(false);
    m_margin_hedged_use_leg = (bool)tmp_long;
    if(!SymbolInfoInteger(m_name, SYMBOL_EXPIRATION_MODE, tmp_long))
        return(false);
    m_trade_time_flags = (int)tmp_long;
    if(!SymbolInfoInteger(m_name, SYMBOL_FILLING_MODE, tmp_long))
        return(false);
    m_trade_fill_flags = (int)tmp_long;


//---
    return(true);
   }


//+------------------------------------------------------------------+
//| Refresh cached data                                              |
//+------------------------------------------------------------------+
bool CSymbolObject::RefreshRates(void)
   {
    return(SymbolInfoTick(m_name, m_tick));
   }


//+------------------------------------------------------------------+
//| 銘柄が気配値表示欄に表示されているかどうか
//+------------------------------------------------------------------+
bool CSymbolObject::IsSelected(void) const
   {
    return((bool)SymbolInfoInteger(m_name, SYMBOL_SELECT));
   }


//+------------------------------------------------------------------+
//| 銘柄を気配値表示欄に対して追加or削除
//+------------------------------------------------------------------+
bool CSymbolObject::Select(const bool select)
   {
    return(SymbolSelect(m_name, select));
   }


//+------------------------------------------------------------------+
//| 銘柄の情報がトレードサーバーと同期しているかどうか確認（各種情報が最新版であることを担保）
//+------------------------------------------------------------------+
bool CSymbolObject::IsSynchronized(void) const
   {
    return(SymbolIsSynchronized(m_name));
   }


//+------------------------------------------------------------------+
//| 銘柄の1日の最大取引量を取得
//+------------------------------------------------------------------+
ulong CSymbolObject::GetVolumeHigh(void) const
   {
    return(SymbolInfoInteger(m_name, SYMBOL_VOLUMEHIGH));
   }


//+------------------------------------------------------------------+
//| 銘柄の1日の最小取引量を取得
//+------------------------------------------------------------------+
ulong CSymbolObject::GetVolumeLow(void) const
   {
    return(SymbolInfoInteger(m_name, SYMBOL_VOLUMELOW));
   }


//+------------------------------------------------------------------+
//| 銘柄のスプレッド値を取得
//+------------------------------------------------------------------+
int CSymbolObject::GetSpread(void) const
   {
    return((int)SymbolInfoInteger(m_name, SYMBOL_SPREAD));
   }


//+------------------------------------------------------------------+
//| 銘柄が浮動スプレッド（時間経過によってスプレッド値が変わる）を採用しているかどうかを取得                    |
//+------------------------------------------------------------------+
bool CSymbolObject::GetSpreadFloat(void) const
   {
    return((bool)SymbolInfoInteger(m_name, SYMBOL_SPREAD_FLOAT));
   }


//+------------------------------------------------------------------+
//| 板情報で表示されるリクエストの最高数を取得
//+------------------------------------------------------------------+
int CSymbolObject::GetTicksBookDepth(void) const
   {
    return((int)SymbolInfoInteger(m_name, SYMBOL_TICKS_BOOKDEPTH));
   }


//+------------------------------------------------------------------+
//| 注文価格を基準にして、利食い・損切りの価格を置くために必要な最低距離（ポイント）を取得
//+------------------------------------------------------------------+
int CSymbolObject::GetStopsLevel(void) const
   {
    return((int)SymbolInfoInteger(m_name, SYMBOL_TRADE_STOPS_LEVEL));
   }


//+------------------------------------------------------------------+
//| 市場価格を基準にして、指値・逆指値注文の操作の凍結が起きる最小距離（ポイント）を取得
//| 凍結が起きると、注文の変更や削除が出来なくなる
//+------------------------------------------------------------------+
int CSymbolObject::GetFreezeLevel(void) const
   {
    return((int)SymbolInfoInteger(m_name, SYMBOL_TRADE_FREEZE_LEVEL));
   }


//+------------------------------------------------------------------+
//| 銘柄の1日の最高売値
//+------------------------------------------------------------------+
double CSymbolObject::GetBidHigh(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_BIDHIGH));
   }


//+------------------------------------------------------------------+
//|  銘柄の1日の最安売り値
//+------------------------------------------------------------------+
double CSymbolObject::GetBidLow(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_BIDLOW));
   }


//+------------------------------------------------------------------+
//| 銘柄の1日の最高買い値
//+------------------------------------------------------------------+
double CSymbolObject::GetAskHigh(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_ASKHIGH));
   }
//+------------------------------------------------------------------+
//| 銘柄の1日の最安買い値
//+------------------------------------------------------------------+
double CSymbolObject::GetAskLow(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_ASKLOW));
   }


//+------------------------------------------------------------------+
//| 銘柄における1日の最高値（1日足の高値？）
//+------------------------------------------------------------------+
double CSymbolObject::GetLastHigh(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_LASTHIGH));
   }


//+------------------------------------------------------------------+
//| 銘柄における1日の最安値（1日足の安値？）
//+------------------------------------------------------------------+
double CSymbolObject::GetLastLow(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_LASTLOW));
   }


//+------------------------------------------------------------------+
//| 「SYMBOL_CALC_MODE」のそれぞれの説明文を返却
//+------------------------------------------------------------------+
string CSymbolObject::GetTradeCalcModeDescription(void) const
   {
    string str;

    switch(m_trade_calcmode)
       {
        case SYMBOL_CALC_MODE_FOREX:
            str = "Calculation of profit and margin for Forex";
            break;
        case SYMBOL_CALC_MODE_CFD:
            str = "Calculation of collateral and earnings for CFD";
            break;
        case SYMBOL_CALC_MODE_FUTURES:
            str = "Calculation of collateral and profits for futures";
            break;
        case SYMBOL_CALC_MODE_CFDINDEX:
            str = "Calculation of collateral and earnings for CFD on indices";
            break;
        case SYMBOL_CALC_MODE_CFDLEVERAGE:
            str = "Calculation of collateral and earnings for the CFD when trading with leverage";
            break;
        case SYMBOL_CALC_MODE_EXCH_STOCKS:
            str = "Calculation for exchange stocks";
            break;
        case SYMBOL_CALC_MODE_EXCH_FUTURES:
            str = "Calculation for exchange futures";
            break;
        case SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS:
            str = "Calculation for FORTS futures";
            break;
        default:
            str = "Unknown calculation mode";
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 「SYMBOL_TRADE_MODE」のそれぞれの説明文を返却
//+------------------------------------------------------------------+
string CSymbolObject::GetTradeModeDescription(void) const
   {
    string str;

    switch(m_trade_mode)
       {
        case SYMBOL_TRADE_MODE_DISABLED:
            str = "Disabled";
            break;
        case SYMBOL_TRADE_MODE_LONGONLY:
            str = "Long only";
            break;
        case SYMBOL_TRADE_MODE_SHORTONLY:
            str = "Short only";
            break;
        case SYMBOL_TRADE_MODE_CLOSEONLY:
            str = "Close only";
            break;
        case SYMBOL_TRADE_MODE_FULL:
            str = "Full access";
            break;
        default:
            str = "Unknown trade mode";
       }

//---
    return(str);
   }



//+------------------------------------------------------------------+
//| 「SYMBOL_TRADE_EXEMODE」のそれぞれの説明を返却
//+------------------------------------------------------------------+
string CSymbolObject::GetTradeExecutionDescription(void) const
   {
    string str;

    switch(m_trade_execution)
       {
        case SYMBOL_TRADE_EXECUTION_REQUEST:
            str = "Trading on request";
            break;
        case SYMBOL_TRADE_EXECUTION_INSTANT:
            str = "Trading on live streaming prices";
            break;
        case SYMBOL_TRADE_EXECUTION_MARKET:
            str = "Execution of orders on the market";
            break;
        case SYMBOL_TRADE_EXECUTION_EXCHANGE:
            str = "Exchange execution";
            break;
        default:
            str = "Unknown trade execution";
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 「SYMBOL_SWAP_MODE」のそれぞれの説明を返却
//+------------------------------------------------------------------+
string CSymbolObject::GetSwapModeDescription(void) const
   {
    string str;

    switch(m_swap_mode)
       {
        case SYMBOL_SWAP_MODE_DISABLED:
            str = "No swaps";
            break;
        case SYMBOL_SWAP_MODE_POINTS:
            str = "Swaps are calculated in points";
            break;
        case SYMBOL_SWAP_MODE_CURRENCY_SYMBOL:
            str = "Swaps are calculated in base currency";
            break;
        case SYMBOL_SWAP_MODE_CURRENCY_MARGIN:
            str = "Swaps are calculated in margin currency";
            break;
        case SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT:
            str = "Swaps are calculated in deposit currency";
            break;
        case SYMBOL_SWAP_MODE_INTEREST_CURRENT:
            str = "Swaps are calculated as annual interest using the current price";
            break;
        case SYMBOL_SWAP_MODE_INTEREST_OPEN:
            str = "Swaps are calculated as annual interest using the open price";
            break;
        case SYMBOL_SWAP_MODE_REOPEN_CURRENT:
            str = "Swaps are charged by reopening positions at the close price";
            break;
        case SYMBOL_SWAP_MODE_REOPEN_BID:
            str = "Swaps are charged by reopening positions at the Bid price";
            break;
        default:
            str = "Unknown swap mode";
       }

//--- result
    return(str);
   }


//+------------------------------------------------------------------+
//| 「SYMBOL_SWAP_ROLLOVER3DAYS」の該当曜日を返却
//+------------------------------------------------------------------+
string CSymbolObject::GetSwapRollover3daysDescription(void) const
   {
    string str;

    switch(m_swap3)
       {
        case SUNDAY:
            str = "Sunday";
            break;
        case MONDAY:
            str = "Monday";
            break;
        case TUESDAY:
            str = "Tuesday";
            break;
        case WEDNESDAY:
            str = "Wednesday";
            break;
        case THURSDAY:
            str = "Thursday";
            break;
        case FRIDAY:
            str = "Friday";
            break;
        case SATURDAY:
            str = "Saturday";
            break;
        default:
            str = "Unknown";
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 銘柄が取引可能になった年月日時刻
//+------------------------------------------------------------------+
datetime CSymbolObject::GetStartTime(void) const
   {
    return((datetime)SymbolInfoInteger(m_name, SYMBOL_START_TIME));
   }


//+------------------------------------------------------------------+
//| 銘柄が取引不可になった年月日時刻
//+------------------------------------------------------------------+
datetime CSymbolObject::GetExpirationTime(void) const
   {
    return((datetime)SymbolInfoInteger(m_name, SYMBOL_EXPIRATION_TIME));
   }


//+------------------------------------------------------------------+
//| 銘柄の基準通貨を取得（USD/JPYなら、USDは基準通貨、JPYはクォート通貨）
//+------------------------------------------------------------------+
string CSymbolObject::GetCurrencyBase(void) const
   {
    return(SymbolInfoString(m_name, SYMBOL_CURRENCY_BASE));
   }


//+------------------------------------------------------------------+
//| 銘柄の利益算出に使われる通貨を取得
//+------------------------------------------------------------------+
string CSymbolObject::GetCurrencyProfit(void) const
   {
    return(SymbolInfoString(m_name, SYMBOL_CURRENCY_PROFIT));
   }


//+------------------------------------------------------------------+
//| 銘柄の証拠金の計算に使われる通貨を取得
//+------------------------------------------------------------------+
string CSymbolObject::GetCurrencyMargin(void) const
   {
    return(SymbolInfoString(m_name, SYMBOL_CURRENCY_MARGIN));
   }


//+------------------------------------------------------------------+
//| 銘柄の供給者（プロバイダー）の名前を取得
//+------------------------------------------------------------------+
string CSymbolObject::GetBank(void) const
   {
    return(SymbolInfoString(m_name, SYMBOL_BANK));
   }


//+------------------------------------------------------------------+
//| 銘柄の説明文を取得
//+------------------------------------------------------------------+
string CSymbolObject::GetDescription(void) const
   {
    return(SymbolInfoString(m_name, SYMBOL_DESCRIPTION));
   }


//+------------------------------------------------------------------+
//| 銘柄のパス（分類/銘柄名）を取得
//+------------------------------------------------------------------+
string CSymbolObject::GetPath(void) const
   {
    return(SymbolInfoString(m_name, SYMBOL_PATH));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における約定数を取得
//+------------------------------------------------------------------+
long CSymbolObject::GetSessionDeals(void) const
   {
    return(SymbolInfoInteger(m_name, SYMBOL_SESSION_DEALS));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における市場全体の買い注文数（内訳不明）を取得
//+------------------------------------------------------------------+
long CSymbolObject::GetSessionBuyOrders(void) const
   {
    return(SymbolInfoInteger(m_name, SYMBOL_SESSION_BUY_ORDERS));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における市場全体の売り注文数（内訳不明）を取得
//+------------------------------------------------------------------+
long CSymbolObject::GetSessionSellOrders(void) const
   {
    return(SymbolInfoInteger(m_name, SYMBOL_SESSION_SELL_ORDERS));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における市場全体の取引高を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionTurnover(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_TURNOVER));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における市場全体の建玉数（オープンポジション数）を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionInterest(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_INTEREST));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における市場全体の買い注文の取引量を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionBuyOrdersVolume(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_BUY_ORDERS_VOLUME));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における市場全体の売り注文の取引量を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionSellOrdersVolume(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_SELL_ORDERS_VOLUME));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における始値を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionOpen(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_OPEN));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における終値を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionClose(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_CLOSE));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における加重平均価格を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionAW(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_AW));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における生産価格（値洗いや証拠金計算の際などに使用）を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionPriceSettlement(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_PRICE_SETTLEMENT));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における最安値を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionPriceLimitMin(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_PRICE_LIMIT_MIN));
   }


//+------------------------------------------------------------------+
//| 銘柄の取引時間帯（セッション）における最高値を取得
//+------------------------------------------------------------------+
double CSymbolObject::GetSessionPriceLimitMax(void) const
   {
    return(SymbolInfoDouble(m_name, SYMBOL_SESSION_PRICE_LIMIT_MAX));
   }


//+------------------------------------------------------------------+
//| Access functions SymbolInfoInteger(...)                          |
//+------------------------------------------------------------------+
bool CSymbolObject::InfoInteger(const ENUM_SYMBOL_INFO_INTEGER prop_id, long &var) const
   {
    return(SymbolInfoInteger(m_name, prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions SymbolInfoDouble(...)                           |
//+------------------------------------------------------------------+
bool CSymbolObject::InfoDouble(const ENUM_SYMBOL_INFO_DOUBLE prop_id, double &var) const
   {
    return(SymbolInfoDouble(m_name, prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions SymbolInfoString(...)                           |
//+------------------------------------------------------------------+
bool CSymbolObject::InfoString(const ENUM_SYMBOL_INFO_STRING prop_id, string &var) const
   {
    return(SymbolInfoString(m_name, prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions SymbolInfoMarginRate(...)                           |
//+------------------------------------------------------------------+
bool CSymbolObject::InfoMarginRate(const ENUM_ORDER_TYPE order_type, double& initial_margin_rate, double& maintenance_margin_rate) const
   {
    return(SymbolInfoMarginRate(m_name, order_type, initial_margin_rate, maintenance_margin_rate));
   }


//+------------------------------------------------------------------+
//| 価格の正規化（1ティックあたりの価格の倍数にしつつ、有効な小数点桁数にそろえる）
//+------------------------------------------------------------------+
double CSymbolObject::NormalizePrice(const double price) const
   {
    if(m_tick_size != 0)
        return(NormalizeDouble(MathRound(price / m_tick_size) * m_tick_size, m_digits));

//---
    return(NormalizeDouble(price, m_digits));
   }


//+------------------------------------------------------------------+
//| 銘柄が気配値表示欄に存在するのか確認して、存在しなければ追加
//+------------------------------------------------------------------+
bool CSymbolObject::CheckMarketWatch(void)
   {
//--- まだ銘柄が気配値表示欄に存在しない場合
    if(!IsSelected())
       {
        //--- 無効な銘柄の場合
        if(GetLastError() == ERR_MARKET_UNKNOWN_SYMBOL)
           {
            printf(__FUNCTION__ + ": Unknown symbol '%s'", m_name);
            return(false);
           }
        //--- 気配値表示欄に銘柄を追加
        //--- 追加に失敗した場合は、エラーを発生させる
        if(!Select(true))
           {
            printf(__FUNCTION__ + ": Error adding symbol %d", GetLastError());
            return(false);
           }
       }

//---
    return(true);
   }


//+------------------------------------------------------------------+
