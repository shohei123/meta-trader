//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <Object.mqh>


//+------------------------------------------------------------------+
//| Class CPositionObject
//+------------------------------------------------------------------+
class CPositionObject : public CObject
   {
protected:
    ENUM_POSITION_TYPE      m_type;
    double                  m_volume;
    double                  m_price;
    double                  m_stop_loss;
    double                  m_take_profit;

public:
                     CPositionObject(void);
                    ~CPositionObject(void);
    ulong                   GetTicket(void) const;
    datetime                GetTime(void) const;
    ulong                   GetTimeMsc(void) const;
    datetime                GetTimeUpdate(void) const;
    ulong                   GetTimeUpdateMsc(void) const;
    ENUM_POSITION_TYPE      GetPositionType(void) const;
    string                  GetTypeDescription(void) const;
    long                    GetMagicNumber(void) const;
    long                    GetIdentifier(void) const;
    double                  GetVolume(void) const;
    double                  GetPriceOpen(void) const;
    double                  GetStopLoss(void) const;
    double                  GetTakeProfit(void) const;
    double                  GetPriceCurrent(void) const;
    double                  GetCommission(void) const;
    double                  GetSwap(void) const;
    double                  GetProfit(void) const;
    string                  GetSymbol(void) const;
    string                  GetComment(void) const;
    bool                    InfoInteger(const ENUM_POSITION_PROPERTY_INTEGER prop_id, long &var) const;
    bool                    InfoDouble(const ENUM_POSITION_PROPERTY_DOUBLE prop_id, double &var) const;
    bool                    InfoString(const ENUM_POSITION_PROPERTY_STRING prop_id, string &var) const;
    string                  FormatType(string &str, const uint type) const;
    string                  FormatPosition(string &str) const;
    bool                    Select(const string symbol);
    bool                    SelectByMagicNumber(const string symbol, const ulong magic);
    bool                    SelectByTicket(const ulong ticket);
    bool                    SelectByIndex(const int index);
    void                    RefreshState(void);
    bool                    CheckUpdatedState(void);
   };


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPositionObject::CPositionObject(void) :
    m_type(WRONG_VALUE),
    m_volume(0.0),
    m_price(0.0),
    m_stop_loss(0.0),
    m_take_profit(0.0)
   {
   }


//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPositionObject::~CPositionObject(void)
   {
   }


//+------------------------------------------------------------------+
//| オープンポジションのチケットIDを取得
//+------------------------------------------------------------------+
ulong CPositionObject::GetTicket(void) const
   {
    return((ulong)PositionGetInteger(POSITION_TICKET));
   }


//+------------------------------------------------------------------+
//| オープンポジションが注文された日時を取得
//+------------------------------------------------------------------+
datetime CPositionObject::GetTime(void) const
   {
    return((datetime)PositionGetInteger(POSITION_TIME));
   }


//+------------------------------------------------------------------+
//| オープンポジションが注文された日時のUNIX時間（ミリ秒）を取得
//+------------------------------------------------------------------+
ulong CPositionObject::GetTimeMsc(void) const
   {
    return((ulong)PositionGetInteger(POSITION_TIME_MSC));
   }


//+------------------------------------------------------------------+
//| オープンポジションが更新された日時を取得
//+------------------------------------------------------------------+
datetime CPositionObject::GetTimeUpdate(void) const
   {
    return((datetime)PositionGetInteger(POSITION_TIME_UPDATE));
   }


//+------------------------------------------------------------------+
//| オープンポジションが更新された日時のUNIX時間（ミリ秒）を取得
//+------------------------------------------------------------------+
ulong CPositionObject::GetTimeUpdateMsc(void) const
   {
    return((ulong)PositionGetInteger(POSITION_TIME_UPDATE_MSC));
   }


//+------------------------------------------------------------------+
//| オープンポジションの売買方向を取得
//+------------------------------------------------------------------+
ENUM_POSITION_TYPE CPositionObject::GetPositionType(void) const
   {
//--- POSITION_TYPE_BUY or POSITION_TYPE_SELL
    return((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE));
   }


//+------------------------------------------------------------------+
//| オープンポジションの売買方向を表す文字列を取得
//+------------------------------------------------------------------+
string CPositionObject::GetTypeDescription(void) const
   {
    string str;
    return(FormatType(str, GetPositionType()));
   }


//+------------------------------------------------------------------+
//| オープンポジションのマジックナンバーを取得
//+------------------------------------------------------------------+
long CPositionObject::GetMagicNumber(void) const
   {
    return(PositionGetInteger(POSITION_MAGIC));
   }


//+------------------------------------------------------------------+
//| オープンポジションのIDを取得
//+------------------------------------------------------------------+
long CPositionObject::GetIdentifier(void) const
   {
    return(PositionGetInteger(POSITION_IDENTIFIER));
   }


//+------------------------------------------------------------------+
//| オープンポジションの取引量を取得
//+------------------------------------------------------------------+
double CPositionObject::GetVolume(void) const
   {
    return(PositionGetDouble(POSITION_VOLUME));
   }


//+------------------------------------------------------------------+
//| オープンポジションの約定価格を取得
//+------------------------------------------------------------------+
double CPositionObject::GetPriceOpen(void) const
   {
    return(PositionGetDouble(POSITION_PRICE_OPEN));
   }


//+------------------------------------------------------------------+
//| オープンポジションの損切り価格を取得
//+------------------------------------------------------------------+
double CPositionObject::GetStopLoss(void) const
   {
    return(PositionGetDouble(POSITION_SL));
   }


//+------------------------------------------------------------------+
//| オープンポジションの利食い価格を取得
//+------------------------------------------------------------------+
double CPositionObject::GetTakeProfit(void) const
   {
    return(PositionGetDouble(POSITION_TP));
   }


//+------------------------------------------------------------------+
//| オープンポジションに対応する銘柄の現在の価格を取得
//+------------------------------------------------------------------+
double CPositionObject::GetPriceCurrent(void) const
   {
    return(PositionGetDouble(POSITION_PRICE_CURRENT));
   }


//+------------------------------------------------------------------+
//| オープンポジションの取引手数料を取得
//+------------------------------------------------------------------+
double CPositionObject::GetCommission(void) const
   {
    return(PositionGetDouble(POSITION_COMMISSION));
   }


//+------------------------------------------------------------------+
//| オープンポジションのスワップ値を取得
//+------------------------------------------------------------------+
double CPositionObject::GetSwap(void) const
   {
    return(PositionGetDouble(POSITION_SWAP));
   }


//+------------------------------------------------------------------+
//| オープンポジションの含み損益を取得
//+------------------------------------------------------------------+
double CPositionObject::GetProfit(void) const
   {
    return(PositionGetDouble(POSITION_PROFIT));
   }


//+------------------------------------------------------------------+
//| オープンポジションに対応する銘柄を取得
//+------------------------------------------------------------------+
string CPositionObject::GetSymbol(void) const
   {
    return(PositionGetString(POSITION_SYMBOL));
   }


//+------------------------------------------------------------------+
//| オープンポジションに設定されたコメントを取得
//+------------------------------------------------------------------+
string CPositionObject::GetComment(void) const
   {
    return(PositionGetString(POSITION_COMMENT));
   }


//+------------------------------------------------------------------+
//| Access functions PositionGetInteger(...)                         |
//+------------------------------------------------------------------+
bool CPositionObject::InfoInteger(const ENUM_POSITION_PROPERTY_INTEGER prop_id, long &var) const
   {
    return(PositionGetInteger(prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions PositionGetDouble(...)                          |
//+------------------------------------------------------------------+
bool CPositionObject::InfoDouble(const ENUM_POSITION_PROPERTY_DOUBLE prop_id, double &var) const
   {
    return(PositionGetDouble(prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions PositionGetString(...)                          |
//+------------------------------------------------------------------+
bool CPositionObject::InfoString(const ENUM_POSITION_PROPERTY_STRING prop_id, string &var) const
   {
    return(PositionGetString(prop_id, var));
   }


//+------------------------------------------------------------------+
//| オープンポジションの売買方向を表す文字列を返却
//+------------------------------------------------------------------+
string CPositionObject::FormatType(string &str, const uint type) const
   {
    switch(type)
       {
        case POSITION_TYPE_BUY:
            str = "buy";
            break;
        case POSITION_TYPE_SELL:
            str = "sell";
            break;
        default:
            str = "unknown position type " + (string)type;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| オープンポジションの各種の設定値を文字列に変換して返却
//+------------------------------------------------------------------+
string CPositionObject::FormatPosition(string &str) const
   {
    string tmp, type;
    long   tmp_long;
    ENUM_ACCOUNT_MARGIN_MODE margin_mode = (ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
    string symbol_name = this.GetSymbol();

    int    digits = _Digits;
    if(SymbolInfoInteger(symbol_name, SYMBOL_DIGITS, tmp_long))
        digits = (int)tmp_long;

//--- ヘッジアカウントの場合
    if(margin_mode == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
        str = StringFormat("#%I64u %s %s %s %s",
                           GetTicket(),
                           FormatType(type, GetPositionType()),
                           DoubleToString(GetVolume(), 2),
                           symbol_name,
                           DoubleToString(GetPriceOpen(), digits + 3)
                          );

//--- ネットアカウントの場合
    else
        str = StringFormat("%s %s %s %s",
                           FormatType(type, GetPositionType()),
                           DoubleToString(GetVolume(), 2),
                           symbol_name,
                           DoubleToString(GetPriceOpen(), digits + 3)
                          );

//--- 利食い・損切りが設定されている場合
    double sl = GetStopLoss();
    double tp = GetTakeProfit();

    if(sl != 0.0)
       {
        tmp = StringFormat(" sl: %s", DoubleToString(sl, digits));
        str += tmp;
       }

    if(tp != 0.0)
       {
        tmp = StringFormat(" tp: %s", DoubleToString(tp, digits));
        str += tmp;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| PositionSelectのラッパーであり、銘柄が一致するオープンポジションを1つ選択する
//| チケットIDが最小（つまり、約定日時が最も古い）なオープンポジションが選ばれる
//+------------------------------------------------------------------+
bool CPositionObject::Select(const string symbol)
   {
    return(PositionSelect(symbol));
   }


//+------------------------------------------------------------------+
//| マジックナンバーの一致するオープンポジションを1つ選択する
//+------------------------------------------------------------------+
bool CPositionObject::SelectByMagicNumber(const string symbol, const ulong magic)
   {
    bool res = false;
    uint total = PositionsTotal();

    for(uint i = 0; i < total; i++)
       {
        string position_symbol = PositionGetSymbol(i);
        if(position_symbol == symbol && magic == PositionGetInteger(POSITION_MAGIC))
           {
            res = true;
            break;
           }
       }

//---
    return(res);
   }


//+------------------------------------------------------------------+
//| PositionSelectByTicketのラッパー
//+------------------------------------------------------------------+
bool CPositionObject::SelectByTicket(const ulong ticket)
   {
    return(PositionSelectByTicket(ticket));
   }


//+------------------------------------------------------------------+
//| オープンポジションをインデックスで指定して選択状態にする
//+------------------------------------------------------------------+
bool CPositionObject::SelectByIndex(const int index)
   {
    ulong ticket = PositionGetTicket(index);

//--- 返り値は、ポジションのチケットID。失敗したら0が返却される。
    return(ticket > 0);
   }


//+------------------------------------------------------------------+
//| オープンポジションの各種メンバを最新値で更新
//+------------------------------------------------------------------+
void CPositionObject::RefreshState(void)
   {
    m_type       = GetPositionType();
    m_volume     = GetVolume();
    m_price      = GetPriceOpen();
    m_stop_loss  = GetStopLoss();
    m_take_profit = GetTakeProfit();
   }


//+------------------------------------------------------------------+
//| 各種メンバと最新値を比較して、変更を検知
//+------------------------------------------------------------------+
bool CPositionObject::CheckUpdatedState(void)
   {
    if(m_type == GetPositionType()  &&
       m_volume == GetVolume()      &&
       m_price == GetPriceOpen()    &&
       m_stop_loss == GetStopLoss() &&
       m_take_profit == GetTakeProfit())
        return(false);

//---
    return(true);
   }


//+------------------------------------------------------------------+
