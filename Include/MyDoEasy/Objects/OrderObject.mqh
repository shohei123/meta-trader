//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <Object.mqh>


//+------------------------------------------------------------------+
//| Class COrderObject
//+------------------------------------------------------------------+
class COrderObject : public CObject
   {
protected:
    ulong                        m_ticket;
    ENUM_ORDER_TYPE              m_type;
    ENUM_ORDER_STATE             m_state;
    datetime                     m_expiration;
    double                       m_volume_curr;
    double                       m_price_open;
    double                       m_stop_loss;
    double                       m_take_profit;


public:
                     COrderObject(void);
                    ~COrderObject(void);
    ulong                        GetTicket(void) const { return(m_ticket); }
    datetime                     GetTimeSetup(void) const;
    ulong                        GetTimeSetupMsc(void) const;
    datetime                     GetTimeDone(void) const;
    ulong                        GetTimeDoneMsc(void) const;
    ENUM_ORDER_TYPE              GetOrderType(void) const;
    string                       GetTypeDescription(void) const;
    ENUM_ORDER_STATE             GetState(void) const;
    string                       GetStateDescription(void) const;
    datetime                     GetTimeExpiration(void) const;
    ENUM_ORDER_TYPE_FILLING      GetTypeFilling(void) const;
    string                       GetTypeFillingDescription(void) const;
    ENUM_ORDER_TYPE_TIME         GetTypeTime(void) const;
    string                       GetTypeTimeDescription(void) const;
    long                         GetMagicNumber(void) const;
    long                         GetPositionId(void) const;
    long                         GetPositionById(void) const;
    double                       GetVolumeInitial(void) const;
    double                       GetVolumeCurrent(void) const;
    double                       GetPriceOpen(void) const;
    double                       GetStopLoss(void) const;
    double                       GetTakeProfit(void) const;
    double                       GetPriceCurrent(void) const;
    double                       GetPriceStopLimit(void) const;
    string                       GetSymbol(void) const;
    string                       GetComment(void) const;
    string                       GetExternalId(void) const;
    bool                         InfoInteger(const ENUM_ORDER_PROPERTY_INTEGER prop_id, long &var) const;
    bool                         InfoDouble(const ENUM_ORDER_PROPERTY_DOUBLE prop_id, double &var) const;
    bool                         InfoString(const ENUM_ORDER_PROPERTY_STRING prop_id, string &var) const;
    string                       FormatType(string &str, const uint type) const;
    string                       FormatStatus(string &str, const uint status) const;
    string                       FormatTypeFilling(string &str, const uint type) const;
    string                       FormatTypeTime(string &str, const uint type) const;
    string                       FormatOrder(string &str) const;
    string                       FormatPrice(string &str, const double price_order, const double price_trigger, const uint digits) const;
    bool                         Select(void);
    bool                         SelectByTicket(const ulong ticket);
    bool                         SelectByIndex(const int index);
    void                         RefreshState(void);
    bool                         CheckUpdatedState(void);
   };


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
COrderObject::COrderObject(void) :
    m_ticket(ULONG_MAX),
    m_type(WRONG_VALUE),
    m_state(WRONG_VALUE),
    m_expiration(0),
    m_volume_curr(0.0),
    m_price_open(0.0),
    m_stop_loss(0.0),
    m_take_profit(0.0)
   {
   }


//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
COrderObject::~COrderObject(void)
   {
   }


//+------------------------------------------------------------------+
//| 注文が作成された日時を取得
//+------------------------------------------------------------------+
datetime COrderObject::GetTimeSetup(void) const
   {
    return((datetime)OrderGetInteger(ORDER_TIME_SETUP));
   }


//+------------------------------------------------------------------+
//| 注文が作成された日時のUNIX時間（ミリ秒）を取得
//+------------------------------------------------------------------+
ulong COrderObject::GetTimeSetupMsc(void) const
   {
    return(OrderGetInteger(ORDER_TIME_SETUP_MSC));
   }


//+------------------------------------------------------------------+
//| 注文が実行された日時を取得
//+------------------------------------------------------------------+
datetime COrderObject::GetTimeDone(void) const
   {
    return((datetime)OrderGetInteger(ORDER_TIME_DONE));
   }


//+------------------------------------------------------------------+
//| 注文が実行された日時のUNIX時間（ミリ秒）を取得
//+------------------------------------------------------------------+
ulong COrderObject::GetTimeDoneMsc(void) const
   {
    return(OrderGetInteger(ORDER_TIME_DONE_MSC));
   }


//+------------------------------------------------------------------+
//| 注文の種類（成行・指値・逆指値と売買方向）を取得
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE COrderObject::GetOrderType(void) const
   {
    return((ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE));
   }


//+------------------------------------------------------------------+
//| 注文の種類（成行・指値・逆指値と売買方向）を説明文として取得
//+------------------------------------------------------------------+
string COrderObject::GetTypeDescription(void) const
   {
    string str;
    return(FormatType(str, GetOrderType()));
   }


//+------------------------------------------------------------------+
//| 注文の処理段階を表す状態を取得
//+------------------------------------------------------------------+
ENUM_ORDER_STATE COrderObject::GetState(void) const
   {
    return((ENUM_ORDER_STATE)OrderGetInteger(ORDER_STATE));
   }


//+------------------------------------------------------------------+
//| 注文の処理段階を表す状態の説明文を取得
//+------------------------------------------------------------------+
string COrderObject::GetStateDescription(void) const
   {
    string str;
    return(FormatStatus(str, GetState()));
   }


//+------------------------------------------------------------------+
//| 注文の有効期限を取得
//+------------------------------------------------------------------+
datetime COrderObject::GetTimeExpiration(void) const
   {
    return((datetime)OrderGetInteger(ORDER_TIME_EXPIRATION));
   }


//+------------------------------------------------------------------+
//| 注文の充填方法を取得
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE_FILLING COrderObject::GetTypeFilling(void) const
   {
    return((ENUM_ORDER_TYPE_FILLING)OrderGetInteger(ORDER_TYPE_FILLING));
   }


//+------------------------------------------------------------------+
//| 注文の充填方法についての説明文を取得
//+------------------------------------------------------------------+
string COrderObject::GetTypeFillingDescription(void) const
   {
    string str;
    return(FormatTypeFilling(str, GetTypeFilling()));
   }


//+------------------------------------------------------------------+
//| 注文の有効期限の基準を取得
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE_TIME COrderObject::GetTypeTime(void) const
   {
    return((ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME));
   }


//+------------------------------------------------------------------+
//| 注文の有効期限の基準を説明文として取得
//+------------------------------------------------------------------+
string COrderObject::GetTypeTimeDescription(void) const
   {
    string str;
    return(FormatTypeTime(str, GetTypeFilling()));
   }


//+------------------------------------------------------------------+
//| 注文のマジックナンバーを取得
//+------------------------------------------------------------------+
long COrderObject::GetMagicNumber(void) const
   {
    return(OrderGetInteger(ORDER_MAGIC));
   }


//+------------------------------------------------------------------+
//| 注文のポジションID（約定時に発行される）を取得
//+------------------------------------------------------------------+
long COrderObject::GetPositionId(void) const
   {
    return(OrderGetInteger(ORDER_POSITION_ID));
   }


//+------------------------------------------------------------------+
//| 注文の反対ポジションIDを取得
//+------------------------------------------------------------------+
long COrderObject::GetPositionById(void) const
   {
    return(OrderGetInteger(ORDER_POSITION_BY_ID));
   }


//+------------------------------------------------------------------+
//| 注文の初期の取引量を取得
//+------------------------------------------------------------------+
double COrderObject::GetVolumeInitial(void) const
   {
    return(OrderGetDouble(ORDER_VOLUME_INITIAL));
   }


//+------------------------------------------------------------------+
//| 注文の現在の取引量を取得
//+------------------------------------------------------------------+
double COrderObject::GetVolumeCurrent(void) const
   {
    return(OrderGetDouble(ORDER_VOLUME_CURRENT));
   }


//+------------------------------------------------------------------+
//| 注文の指定価格を取得
//+------------------------------------------------------------------+
double COrderObject::GetPriceOpen(void) const
   {
    return(OrderGetDouble(ORDER_PRICE_OPEN));
   }


//+------------------------------------------------------------------+
//| 注文の損切り価格を取得
//+------------------------------------------------------------------+
double COrderObject::GetStopLoss(void) const
   {
    return(OrderGetDouble(ORDER_SL));
   }


//+------------------------------------------------------------------+
//| 注文の利食い価格を取得
//+------------------------------------------------------------------+
double COrderObject::GetTakeProfit(void) const
   {
    return(OrderGetDouble(ORDER_TP));
   }


//+------------------------------------------------------------------+
//| 注文に対応する銘柄の現在の価格を取得
//+------------------------------------------------------------------+
double COrderObject::GetPriceCurrent(void) const
   {
    return(OrderGetDouble(ORDER_PRICE_CURRENT));
   }


//+------------------------------------------------------------------+
//| ストップリミット注文の場合は、指値注文価格（limit設定値）を取得
//+------------------------------------------------------------------+
double COrderObject::GetPriceStopLimit(void) const
   {
    return(OrderGetDouble(ORDER_PRICE_STOPLIMIT));
   }


//+------------------------------------------------------------------+
//| 注文に対応する銘柄を取得
//+------------------------------------------------------------------+
string COrderObject::GetSymbol(void) const
   {
    return(OrderGetString(ORDER_SYMBOL));
   }


//+------------------------------------------------------------------+
//| 注文のコメントを取得
//+------------------------------------------------------------------+
string COrderObject::GetComment(void) const
   {
    return(OrderGetString(ORDER_COMMENT));
   }


//+------------------------------------------------------------------+
//| 注文に対して取引除から割り当てられるIDを取得
//+------------------------------------------------------------------+
string COrderObject::GetExternalId(void) const
   {
    return(OrderGetString(ORDER_EXTERNAL_ID));
   }


//+------------------------------------------------------------------+
//| Access functions OrderGetInteger(...)                            |
//+------------------------------------------------------------------+
bool COrderObject::InfoInteger(const ENUM_ORDER_PROPERTY_INTEGER prop_id, long &var) const
   {
    return(OrderGetInteger(prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions OrderGetDouble(...)                             |
//+------------------------------------------------------------------+
bool COrderObject::InfoDouble(const ENUM_ORDER_PROPERTY_DOUBLE prop_id, double &var) const
   {
    return(OrderGetDouble(prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions OrderGetString(...)                             |
//+------------------------------------------------------------------+
bool COrderObject::InfoString(const ENUM_ORDER_PROPERTY_STRING prop_id, string &var) const
   {
    return(OrderGetString(prop_id, var));
   }


//+------------------------------------------------------------------+
//| 注文のORDER＿TYPEを説明文として返却
//+------------------------------------------------------------------+
string COrderObject::FormatType(string &str, const uint type) const
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
        default :
            str = "unknown order type " + (string)type;
       }


//--
    return(str);
   }


//+------------------------------------------------------------------+
//| 注文の処理段階を説明文として返却
//+------------------------------------------------------------------+
string COrderObject::FormatStatus(string &str, const uint status) const
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
        case ORDER_STATE_REQUEST_ADD:
            str = "request adding";
            break;
        case ORDER_STATE_REQUEST_MODIFY:
            str = "request modifying";
            break;
        case ORDER_STATE_REQUEST_CANCEL:
            str = "request cancelling";
            break;
        default :
            str = "unknown order status " + (string)status;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 注文の充填方法を説明文として返却
//+------------------------------------------------------------------+
string COrderObject::FormatTypeFilling(string &str, const uint type) const
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
//| 注文の有効期限の基準を説明文として返却
//+------------------------------------------------------------------+
string COrderObject::FormatTypeTime(string &str, const uint type) const
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
//| 注文の各種の設定値を整形して返却
//+------------------------------------------------------------------+
string COrderObject::FormatOrder(string &str) const
   {
    string type, price;
    long   tmp_long;
    string symbol_name = this.GetSymbol();

    int digits = _Digits;
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

//--
    return(str);
   }


//+------------------------------------------------------------------+
//| 注文の価格情報を文字列に変換して整形（price_triggerは、ストップリミット注文のlimit）
//+------------------------------------------------------------------+
string COrderObject::FormatPrice(string &str, const double price_order, const double price_trigger, const uint digits) const
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
//| メンバのチケットIDに一致する注文を選択状態にする
//+------------------------------------------------------------------+
bool COrderObject::Select(void)
   {
    return(OrderSelect(m_ticket));
   }


//+------------------------------------------------------------------+
//| チケットIDが一致する注文を選択状態にｓるう
//+------------------------------------------------------------------+
bool COrderObject::SelectByTicket(const ulong ticket)
   {
    if(OrderSelect(ticket))
       {
        m_ticket = ticket;
        return(true);
       }
    m_ticket = ULONG_MAX;

//---
    return(false);
   }


//+------------------------------------------------------------------+
//| インデックスが一致する注文を選択状態にする
//+------------------------------------------------------------------+
bool COrderObject::SelectByIndex(const int index)
   {
    ulong ticket = OrderGetTicket(index);
    if(ticket == 0)
       {
        m_ticket = ULONG_MAX;
        return(false);
       }
    m_ticket = ticket;

//---
    return(true);
   }


//+------------------------------------------------------------------+
//|各種のメンバを最新値で更新
//+------------------------------------------------------------------+
void COrderObject::RefreshState(void)
   {
    m_type       = GetOrderType();
    m_state      = GetState();
    m_expiration = GetTimeExpiration();
    m_volume_curr = GetVolumeCurrent();
    m_price_open = GetPriceOpen();
    m_stop_loss  = GetStopLoss();
    m_take_profit = GetTakeProfit();
   }


//+------------------------------------------------------------------+
//| 各種メンバと最新値を比較して、変更を検知
//+------------------------------------------------------------------+
bool COrderObject::CheckUpdatedState(void)
   {
    if(m_type == GetOrderType()            &&
       m_state == GetState()               &&
       m_expiration == GetTimeExpiration() &&
       m_volume_curr == GetVolumeCurrent() &&
       m_price_open == GetPriceOpen()      &&
       m_stop_loss == GetStopLoss()        &&
       m_take_profit == GetTakeProfit())
        return(false);

//---
    return(true);
   }


//+------------------------------------------------------------------+
