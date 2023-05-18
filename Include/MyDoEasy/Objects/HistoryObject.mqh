//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <Object.mqh>


//+------------------------------------------------------------------+
//| Class CDealObject
//+------------------------------------------------------------------+
class CHistoryObject : public CObject
   {
protected:
    ulong             m_ticket;


public:
                     CHistoryObject(void);
                    ~CHistoryObject(void);
    void                        SetTicket(const ulong ticket)       { m_ticket = ticket;  }
    ulong                       GetTicket(void) const                  { return(m_ticket); }
    datetime                    GetTimeSetup(void) const;
    ulong                       GetTimeSetupMsc(void) const;
    datetime                    GetTimeDone(void) const;
    ulong                       GetTimeDoneMsc(void) const;
    ENUM_ORDER_TYPE             GetOrderType(void) const;
    string                      GetTypeDescription(void) const;
    ENUM_ORDER_STATE            GetState(void) const;
    string                      GetStateDescription(void) const;
    datetime                    GetTimeExpiration(void) const;
    ENUM_ORDER_TYPE_FILLING     GetTypeFilling(void) const;
    string                      GetTypeFillingDescription(void) const;
    ENUM_ORDER_TYPE_TIME        GetTypeTime(void) const;
    string                      GetTypeTimeDescription(void) const;
    long                        GetMagicNumber(void) const;
    long                        GetPositionId(void) const;
    long                        GetPositionById(void) const;
    double                      GetVolumeInitial(void) const;
    double                      GetVolumeCurrent(void) const;
    double                      GetPriceOpen(void) const;
    double                      GetStopLoss(void) const;
    double                      GetTakeProfit(void) const;
    double                      GetPriceCurrent(void) const;
    double                      GetPriceStopLimit(void) const;
    string                      GetSymbol(void) const;
    string                      GetComment(void) const;
    string                      GetExternalId(void) const;
    bool                        InfoInteger(const ENUM_ORDER_PROPERTY_INTEGER prop_id, long &var) const;
    bool                        InfoDouble(const ENUM_ORDER_PROPERTY_DOUBLE prop_id, double &var) const;
    bool                        InfoString(const ENUM_ORDER_PROPERTY_STRING prop_id, string &var) const;
    string                      FormatType(string &str, const uint type) const;
    string                      FormatStatus(string &str, const uint status) const;
    string                      FormatTypeFilling(string &str, const uint type) const;
    string                      FormatTypeTime(string &str, const uint type) const;
    string                      FormatOrder(string &str) const;
    string                      FormatPrice(string &str, const double price_order, const double price_trigger, const uint digits) const;
    bool                        SelectByIndex(const int index);
   };


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CHistoryObject::CHistoryObject(void) : m_ticket(0)
   {
   }


//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CHistoryObject::~CHistoryObject(void)
   {
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の作成日時」を取得
//+------------------------------------------------------------------+
datetime CHistoryObject::GetTimeSetup(void) const
   {
    return((datetime)HistoryOrderGetInteger(m_ticket, ORDER_TIME_SETUP));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文が作成された日時のUNIX時間（ミリ秒）」を取得
//+------------------------------------------------------------------+
ulong CHistoryObject::GetTimeSetupMsc(void) const
   {
    return(HistoryOrderGetInteger(m_ticket, ORDER_TIME_SETUP_MSC));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文が実行された日時」を取得
//+------------------------------------------------------------------+
datetime CHistoryObject::GetTimeDone(void) const
   {
    return((datetime)HistoryOrderGetInteger(m_ticket, ORDER_TIME_DONE));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文が実行された日時のUNIX時間（ミリ秒）」を取得
//+------------------------------------------------------------------+
ulong CHistoryObject::GetTimeDoneMsc(void) const
   {
    return(HistoryOrderGetInteger(m_ticket, ORDER_TIME_DONE_MSC));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の種類（成行・指値・逆指値と売買方向）」を取得
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE CHistoryObject::GetOrderType(void) const
   {
    return((ENUM_ORDER_TYPE)HistoryOrderGetInteger(m_ticket, ORDER_TYPE));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の種類（成行・指値・逆指値と売買方向）」を説明文として取得
//+------------------------------------------------------------------+
string CHistoryObject::GetTypeDescription(void) const
   {
    string str;
    return(FormatType(str, GetOrderType()));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の処理段階を表す状態」を取得
//+------------------------------------------------------------------+
ENUM_ORDER_STATE CHistoryObject::GetState(void) const
   {
    return((ENUM_ORDER_STATE)HistoryOrderGetInteger(m_ticket, ORDER_STATE));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の処理段階を表す状態」を説明文として取得
//+------------------------------------------------------------------+
string CHistoryObject::GetStateDescription(void) const
   {
    string str;
    return(FormatStatus(str, GetState()));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の有効期限」を取得
//+------------------------------------------------------------------+
datetime CHistoryObject::GetTimeExpiration(void) const
   {
    return((datetime)HistoryOrderGetInteger(m_ticket, ORDER_TIME_EXPIRATION));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の充填方法」を取得
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE_FILLING CHistoryObject::GetTypeFilling(void) const
   {
    return((ENUM_ORDER_TYPE_FILLING)HistoryOrderGetInteger(m_ticket, ORDER_TYPE_FILLING));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の充填方法」を説明文として取得
//+------------------------------------------------------------------+
string CHistoryObject::GetTypeFillingDescription(void) const
   {
    string str;
//---
    return(FormatTypeFilling(str, GetTypeFilling()));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の有効期限の基準」を取得
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE_TIME CHistoryObject::GetTypeTime(void) const
   {
    return((ENUM_ORDER_TYPE_TIME)HistoryOrderGetInteger(m_ticket, ORDER_TYPE_TIME));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の有効期限の基準」を説明文として取得
//+------------------------------------------------------------------+
string CHistoryObject::GetTypeTimeDescription(void) const
   {
    string str;
    return(FormatTypeTime(str, GetTypeTime()));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文のマジックナンバー」を取得
//+------------------------------------------------------------------+
long CHistoryObject::GetMagicNumber(void) const
   {
    return(HistoryOrderGetInteger(m_ticket, ORDER_MAGIC));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文のポジションID（約定時に発行される）」を取得
//+------------------------------------------------------------------+
long CHistoryObject::GetPositionId(void) const
   {
    return(HistoryOrderGetInteger(m_ticket, ORDER_POSITION_ID));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の反対ポジションID」を取得
//+------------------------------------------------------------------+
long CHistoryObject::GetPositionById(void) const
   {
    return(HistoryOrderGetInteger(m_ticket, ORDER_POSITION_BY_ID));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の初期の取引量」を取得
//+------------------------------------------------------------------+
double CHistoryObject::GetVolumeInitial(void) const
   {
    return(HistoryOrderGetDouble(m_ticket, ORDER_VOLUME_INITIAL));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の現在の取引量」を取得
//+------------------------------------------------------------------+
double CHistoryObject::GetVolumeCurrent(void) const
   {
    return(HistoryOrderGetDouble(m_ticket, ORDER_VOLUME_CURRENT));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の指定価格の取引量」を取得
//+------------------------------------------------------------------+
double CHistoryObject::GetPriceOpen(void) const
   {
    return(HistoryOrderGetDouble(m_ticket, ORDER_PRICE_OPEN));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の損切り価格」を取得
//+------------------------------------------------------------------+
double CHistoryObject::GetStopLoss(void) const
   {
    return(HistoryOrderGetDouble(m_ticket, ORDER_SL));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の利食い価格」を取得
//+------------------------------------------------------------------+
double CHistoryObject::GetTakeProfit(void) const
   {
    return(HistoryOrderGetDouble(m_ticket, ORDER_TP));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文に対応する銘柄の現在の価格」を取得
//+------------------------------------------------------------------+
double CHistoryObject::GetPriceCurrent(void) const
   {
    return(HistoryOrderGetDouble(m_ticket, ORDER_PRICE_CURRENT));
   }


//+------------------------------------------------------------------+
//| 履歴の「ストップリミット注文の場合は、指値注文価格（limit設定値）」を取得
//+------------------------------------------------------------------+
double CHistoryObject::GetPriceStopLimit(void) const
   {
    return(HistoryOrderGetDouble(m_ticket, ORDER_PRICE_STOPLIMIT));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文に対応する銘柄」を取得
//+------------------------------------------------------------------+
string CHistoryObject::GetSymbol(void) const
   {
    return(HistoryOrderGetString(m_ticket, ORDER_SYMBOL));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文のコメント」を取得
//+------------------------------------------------------------------+
string CHistoryObject::GetComment(void) const
   {
    return(HistoryOrderGetString(m_ticket, ORDER_COMMENT));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文に対して取引除から割り当てられるID」を取得
//+------------------------------------------------------------------+
string CHistoryObject::GetExternalId(void) const
   {
    return(HistoryOrderGetString(m_ticket, ORDER_EXTERNAL_ID));
   }


//+------------------------------------------------------------------+
//| Access functions OrderGetInteger(...)                            |
//+------------------------------------------------------------------+
bool CHistoryObject::InfoInteger(const ENUM_ORDER_PROPERTY_INTEGER prop_id, long &var) const
   {
    return(HistoryOrderGetInteger(m_ticket, prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions OrderGetDouble(...)                             |
//+------------------------------------------------------------------+
bool CHistoryObject::InfoDouble(const ENUM_ORDER_PROPERTY_DOUBLE prop_id, double &var) const
   {
    return(HistoryOrderGetDouble(m_ticket, prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions OrderGetString(...)                             |
//+------------------------------------------------------------------+
bool CHistoryObject::InfoString(const ENUM_ORDER_PROPERTY_STRING prop_id, string &var) const
   {
    return(HistoryOrderGetString(m_ticket, prop_id, var));
   }


//+------------------------------------------------------------------+
//| 履歴の「注文のORDER＿TYPE」を説明文として返却
//+------------------------------------------------------------------+
string CHistoryObject::FormatType(string &str, const uint type) const
   {
    switch(type)
       {
        case ORDER_TYPE_BUY:
            str = "buy";
            break;
        case ORDER_TYPE_SELL:
            str = "sell";
            break;
        case ORDER_TYPE_BUY_LIMIT:
            str = "buy limit";
            break;
        case ORDER_TYPE_SELL_LIMIT:
            str = "sell limit";
            break;
        case ORDER_TYPE_BUY_STOP:
            str = "buy stop";
            break;
        case ORDER_TYPE_SELL_STOP:
            str = "sell stop";
            break;
        case ORDER_TYPE_BUY_STOP_LIMIT:
            str = "buy stop limit";
            break;
        case ORDER_TYPE_SELL_STOP_LIMIT:
            str = "sell stop limit";
            break;
        case ORDER_TYPE_CLOSE_BY:
            str = "close by";
            break;
        default:
            str = "unknown order type " + (string)type;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の処理段階」を説明文として返却
//+------------------------------------------------------------------+
string CHistoryObject::FormatStatus(string &str, const uint status) const
   {
    switch(status)
       {
        case ORDER_STATE_STARTED:
            str = "started";
            break;
        case ORDER_STATE_PLACED:
            str = "placed";
            break;
        case ORDER_STATE_CANCELED:
            str = "canceled";
            break;
        case ORDER_STATE_PARTIAL:
            str = "partial";
            break;
        case ORDER_STATE_FILLED:
            str = "filled";
            break;
        case ORDER_STATE_REJECTED:
            str = "rejected";
            break;
        case ORDER_STATE_EXPIRED:
            str = "expired";
            break;
        default:
            str = "unknown order status " + (string)status;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の充填方法」を説明文として返却
//+------------------------------------------------------------------+
string CHistoryObject::FormatTypeFilling(string &str, const uint type) const
   {
    switch(type)
       {
        case ORDER_FILLING_RETURN:
            str = "return remainder";
            break;
        case ORDER_FILLING_IOC:
            str = "cancel remainder";
            break;
        case ORDER_FILLING_FOK:
            str = "fill or kill";
            break;
        default:
            str = "unknown type filling " + (string)type;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の有効期限の基準」を説明文として返却
//+------------------------------------------------------------------+
string CHistoryObject::FormatTypeTime(string &str, const uint type) const
   {
    switch(type)
       {
        case ORDER_TIME_GTC:
            str = "gtc";
            break;
        case ORDER_TIME_DAY:
            str = "day";
            break;
        case ORDER_TIME_SPECIFIED:
            str = "specified";
            break;
        case ORDER_TIME_SPECIFIED_DAY:
            str = "specified day";
            break;
        default:
            str = "unknown type time " + (string)type;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の各種の設定値」を整形して返却
//+------------------------------------------------------------------+
string CHistoryObject::FormatOrder(string &str) const
   {
    string type, price;
    long   tmp_long;
    string symbol_name = this.GetSymbol();

    int    digits = _Digits;
    if(SymbolInfoInteger(symbol_name, SYMBOL_DIGITS, tmp_long))
        digits = (int)tmp_long;


    str = StringFormat(
              "#%I64u %s %s %s",
              GetTicket(),
              FormatType(type, GetOrderType()),
              DoubleToString(GetVolumeInitial(), 2),
              symbol_name
          );

    FormatPrice(price, GetPriceOpen(), GetPriceStopLimit(), digits);

    if(price != "")
       {
        str += " at ";
        str += price;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 履歴の「注文の価格情報」を文字列に変換して整形（price_triggerは、ストップリミット注文のlimit）
//+------------------------------------------------------------------+
string CHistoryObject::FormatPrice(string &str, const double price_order, const double price_trigger, const uint digits) const
   {
    string price, trigger;

    if(price_trigger)
       {
        price  = DoubleToString(price_order, digits);
        trigger = DoubleToString(price_trigger, digits);
        str    = StringFormat("%s (%s)", price, trigger);
       }
    else
        str = DoubleToString(price_order, digits);

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| インデックスが一致する履歴を選択状態にする
//+------------------------------------------------------------------+
bool CHistoryObject::SelectByIndex(const int index)
   {
    ulong ticket = HistoryOrderGetTicket(index);
    if(ticket == 0)
        return(false);
        
    SetTicket(ticket);

//---
    return(true);
   }


//+------------------------------------------------------------------+
