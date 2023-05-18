//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <Object.mqh>


//+------------------------------------------------------------------+
//| Class CDealObject
//+------------------------------------------------------------------+
class CDealObject : public CObject
   {
protected:
    ulong             m_ticket;

public:
                     CDealObject(void);
                    ~CDealObject(void);
    void              SetTicket(const ulong ticket)         {m_ticket = ticket;}
    ulong             GetTicket(void)const                  {return(m_ticket);}
    long              GetOrder(void) const;
    datetime          GetTime(void) const;
    ulong             GetTimeMsc(void) const;
    ENUM_DEAL_TYPE    GetDealType(void) const;
    string            GetTypeDescription(void) const;
    ENUM_DEAL_ENTRY   GetEntry(void) const;
    string            GetEntryDescription(void) const;
    long              GetMagicNumber(void) const;
    long              GetPositionId(void) const;
    double            GetVolume(void) const;
    double            GetPrice(void) const;
    double            GetCommission(void) const;
    double            GetSwap(void) const;
    double            GetProfit(void) const;
    string            GetSymbol(void) const;
    string            GetComment(void) const;
    string            GetExternalId(void) const;

    bool              InfoInteger(ENUM_DEAL_PROPERTY_INTEGER prop_id, long &var) const;
    bool              InfoDouble(ENUM_DEAL_PROPERTY_DOUBLE prop_id, double &var) const;
    bool              InfoString(ENUM_DEAL_PROPERTY_STRING prop_id, string &var) const;

    string            FormatAction(string &str, const uint action) const;
    string            FormatEntry(string &str, const uint entry) const;
    string            FormatDeal(string &str) const;

    bool              SelectByIndex(const int index);
   };


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CDealObject::CDealObject(void)
   {
   }


//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CDealObject::~CDealObject(void)
   {
   }


//+------------------------------------------------------------------+
//| 約定注文のチケットIDを取得
//+------------------------------------------------------------------+
long CDealObject::GetOrder(void) const
   {
    return(HistoryDealGetInteger(m_ticket, DEAL_ORDER));
   }


//+------------------------------------------------------------------+
//| 約定注文の約定日時を取得
//+------------------------------------------------------------------+
datetime CDealObject::GetTime(void) const
   {
    return((datetime)HistoryDealGetInteger(m_ticket, DEAL_TIME));
   }


//+------------------------------------------------------------------+
//| 約定注文の約定日時をUNIX時間（ミリ秒）を取得
//+------------------------------------------------------------------+
ulong CDealObject::GetTimeMsc(void) const
   {
    return(HistoryDealGetInteger(m_ticket, DEAL_TIME_MSC));
   }


//+------------------------------------------------------------------+
//| 約定注文の種類を取得
//+------------------------------------------------------------------+
ENUM_DEAL_TYPE CDealObject::GetDealType(void) const
   {
    return((ENUM_DEAL_TYPE)HistoryDealGetInteger(m_ticket, DEAL_TYPE));
   }


//+------------------------------------------------------------------+
//| 約定注文の種類を説明文として取得
//+------------------------------------------------------------------+
string CDealObject::GetTypeDescription(void) const
   {
    string str;

    switch(GetDealType())
       {
        case DEAL_TYPE_BUY:
            str = "Buy type";
            break;
        case DEAL_TYPE_SELL:
            str = "Sell type";
            break;
        case DEAL_TYPE_BALANCE:
            str = "Balance type";
            break;
        case DEAL_TYPE_CREDIT:
            str = "Credit type";
            break;
        case DEAL_TYPE_CHARGE:
            str = "Charge type";
            break;
        case DEAL_TYPE_CORRECTION:
            str = "Correction type";
            break;
        case DEAL_TYPE_BONUS:
            str = "Bonus type";
            break;
        case DEAL_TYPE_COMMISSION:
            str = "Commission type";
            break;
        case DEAL_TYPE_COMMISSION_DAILY:
            str = "Daily Commission type";
            break;
        case DEAL_TYPE_COMMISSION_MONTHLY:
            str = "Monthly Commission type";
            break;
        case DEAL_TYPE_COMMISSION_AGENT_DAILY:
            str = "Daily Agent Commission type";
            break;
        case DEAL_TYPE_COMMISSION_AGENT_MONTHLY:
            str = "Monthly Agent Commission type";
            break;
        case DEAL_TYPE_INTEREST:
            str = "Interest Rate type";
            break;
        case DEAL_TYPE_BUY_CANCELED:
            str = "Canceled Buy type";
            break;
        case DEAL_TYPE_SELL_CANCELED:
            str = "Canceled Sell type";
            break;
        default:
            str = "Unknown type";
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 約定注文の「約定の仕方」を取得
//+------------------------------------------------------------------+
ENUM_DEAL_ENTRY CDealObject::GetEntry(void) const
   {
//--- In or OUt or INOUT or OUT_BY
    return((ENUM_DEAL_ENTRY)HistoryDealGetInteger(m_ticket, DEAL_ENTRY));
   }


//+------------------------------------------------------------------+
//| 約定注文の「約定の仕方」を説明文として取得
//+------------------------------------------------------------------+
string CDealObject::GetEntryDescription(void) const
   {
    string str;

    switch(CDealObject::GetEntry())
       {
        case DEAL_ENTRY_IN:
            str = "In entry";
            break;
        case DEAL_ENTRY_OUT:
            str = "Out entry";
            break;
        case DEAL_ENTRY_INOUT:
            str = "InOut entry";
            break;
        case DEAL_ENTRY_STATE:
            str = "Status record";
            break;
        case DEAL_ENTRY_OUT_BY:
            str = "Out By entry";
            break;
        default:
            str = "Unknown entry";
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 約定注文のマジックナンバーを取得
//+------------------------------------------------------------------+
long CDealObject::GetMagicNumber(void) const
   {
    return(HistoryDealGetInteger(m_ticket, DEAL_MAGIC));
   }


//+------------------------------------------------------------------+
//| 約定注文の識別用のIDを取得
//+------------------------------------------------------------------+
long CDealObject::GetPositionId(void) const
   {
    return(HistoryDealGetInteger(m_ticket, DEAL_POSITION_ID));
   }


//+------------------------------------------------------------------+
//| 約定注文の取引量を取得
//+------------------------------------------------------------------+
double CDealObject::GetVolume(void) const
   {
    return(HistoryDealGetDouble(m_ticket, DEAL_VOLUME));
   }


//+------------------------------------------------------------------+
//| 約定注文の価格を取得
//+------------------------------------------------------------------+
double CDealObject::GetPrice(void) const
   {
    return(HistoryDealGetDouble(m_ticket, DEAL_PRICE));
   }


//+------------------------------------------------------------------+
//| 約定注文の手数料を取得
//+------------------------------------------------------------------+
double CDealObject::GetCommission(void) const
   {
    return(HistoryDealGetDouble(m_ticket, DEAL_COMMISSION));
   }


//+------------------------------------------------------------------+
//| 約定注文のスワップ値を取得
//+------------------------------------------------------------------+
double CDealObject::GetSwap(void) const
   {
    return(HistoryDealGetDouble(m_ticket, DEAL_SWAP));
   }


//+------------------------------------------------------------------+
//| 約定注文の損益を取得
//+------------------------------------------------------------------+
double CDealObject::GetProfit(void) const
   {
    return(HistoryDealGetDouble(m_ticket, DEAL_PROFIT));
   }


//+------------------------------------------------------------------+
//| 約定注文の銘柄を取得
//+------------------------------------------------------------------+
string CDealObject::GetSymbol(void) const
   {
    return(HistoryDealGetString(m_ticket, DEAL_SYMBOL));
   }


//+------------------------------------------------------------------+
//| 約定注文のコメントを取得
//+------------------------------------------------------------------+
string CDealObject::GetComment(void) const
   {
    return(HistoryDealGetString(m_ticket, DEAL_COMMENT));
   }


//+------------------------------------------------------------------+
//| 約定注文の「取引所で割り当てられたID」を取得
//+------------------------------------------------------------------+
string CDealObject::GetExternalId(void) const
   {
    return(HistoryDealGetString(m_ticket, DEAL_EXTERNAL_ID));
   }


//+------------------------------------------------------------------+
//| Access functions HistoryDealGetInteger(...)                      |
//+------------------------------------------------------------------+
bool CDealObject::InfoInteger(ENUM_DEAL_PROPERTY_INTEGER prop_id, long &var) const
   {
    return(HistoryDealGetInteger(m_ticket, prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions HistoryDealGetDouble(...)                       |
//+------------------------------------------------------------------+
bool CDealObject::InfoDouble(ENUM_DEAL_PROPERTY_DOUBLE prop_id, double &var) const
   {
    return(HistoryDealGetDouble(m_ticket, prop_id, var));
   }


//+------------------------------------------------------------------+
//| Access functions HistoryDealGetString(...)                       |
//+------------------------------------------------------------------+
bool CDealObject::InfoString(ENUM_DEAL_PROPERTY_STRING prop_id, string &var) const
   {
    return(HistoryDealGetString(m_ticket, prop_id, var));
   }


//+------------------------------------------------------------------+
//| 約定注文のDEAL_TYPEを説明文として返却
//+------------------------------------------------------------------+
string CDealObject::FormatAction(string &str, const uint action) const
   {
//--- see the type
    switch(action)
       {
        case DEAL_TYPE_BUY:
            str = "buy";
            break;
        case DEAL_TYPE_SELL:
            str = "sell";
            break;
        case DEAL_TYPE_BALANCE:
            str = "balance";
            break;
        case DEAL_TYPE_CREDIT:
            str = "credit";
            break;
        case DEAL_TYPE_CHARGE:
            str = "charge";
            break;
        case DEAL_TYPE_CORRECTION:
            str = "correction";
            break;
        case DEAL_TYPE_BONUS:
            str = "bonus";
            break;
        case DEAL_TYPE_COMMISSION:
            str = "commission";
            break;
        case DEAL_TYPE_COMMISSION_DAILY:
            str = "daily commission";
            break;
        case DEAL_TYPE_COMMISSION_MONTHLY:
            str = "monthly commission";
            break;
        case DEAL_TYPE_COMMISSION_AGENT_DAILY:
            str = "daily agent commission";
            break;
        case DEAL_TYPE_COMMISSION_AGENT_MONTHLY:
            str = "monthly agent commission";
            break;
        case DEAL_TYPE_INTEREST:
            str = "interest rate";
            break;
        case DEAL_TYPE_BUY_CANCELED:
            str = "canceled buy";
            break;
        case DEAL_TYPE_SELL_CANCELED:
            str = "canceled sell";
            break;
        default:
            str = "unknown deal type " + (string)action;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 約定注文のENTRY_TYPEを説明文として返却
//+------------------------------------------------------------------+
string CDealObject::FormatEntry(string &str, const uint entry) const
   {
    switch(entry)
       {
        case DEAL_ENTRY_IN:
            str = "in";
            break;
        case DEAL_ENTRY_OUT:
            str = "out";
            break;
        case DEAL_ENTRY_INOUT:
            str = "in/out";
            break;
        case DEAL_ENTRY_OUT_BY:
            str = "out by";
            break;
        default:
            str = "unknown deal entry " + (string)entry;
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 約定注文のDEAL_TYPEごとに、各種の情報を整形して返却
//+------------------------------------------------------------------+
string CDealObject::FormatDeal(string &str) const
   {
    string type;
    long   tmp_long;
    string symbol_name = this.GetSymbol();

    int digits = _Digits;
    if(SymbolInfoInteger(symbol_name, SYMBOL_DIGITS, tmp_long))
        digits = (int)tmp_long;

//--- form the description of the deal
    switch(GetDealType())
       {
        case DEAL_TYPE_BUY:
        case DEAL_TYPE_SELL:
            str = StringFormat("#%I64u %s %s %s at %s",
                               GetTicket(),
                               FormatAction(type, GetDealType()),
                               DoubleToString(GetVolume(), 2),
                               symbol_name,
                               DoubleToString(GetPrice(), digits));
            break;

        case DEAL_TYPE_BALANCE:
        case DEAL_TYPE_CREDIT:
        case DEAL_TYPE_CHARGE:
        case DEAL_TYPE_CORRECTION:
        case DEAL_TYPE_BONUS:
        case DEAL_TYPE_COMMISSION:
        case DEAL_TYPE_COMMISSION_DAILY:
        case DEAL_TYPE_COMMISSION_MONTHLY:
        case DEAL_TYPE_COMMISSION_AGENT_DAILY:
        case DEAL_TYPE_COMMISSION_AGENT_MONTHLY:
        case DEAL_TYPE_INTEREST:
            str = StringFormat("#%I64u %s %s [%s]",
                               GetTicket(),
                               FormatAction(type, GetDealType()),
                               DoubleToString(GetProfit(), 2),
                               this.GetComment());
            break;

        default:
            str = "unknown deal type " + (string)GetDealType();
       }

//---
    return(str);
   }


//+------------------------------------------------------------------+
//| 約定注文をインデックス指定によって選択状態にする
//| また、チケットIDをメンバに設定する
//+------------------------------------------------------------------+
bool CDealObject::SelectByIndex(const int index)
   {
    ulong ticket = HistoryDealGetTicket(index);

    if(ticket == 0)
        return(false);

    SetTicket(ticket);

//---
    return(true);
   }


//+------------------------------------------------------------------+
