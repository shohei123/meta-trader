//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <Object.mqh>


//+------------------------------------------------------------------+
//| Class CAccountObject.
//+------------------------------------------------------------------+
class CAccountObject : public CObject {
  public:
                     CAccountObject(void);
                    ~CAccountObject(void);
    long                        GetLogin(void) const;
    ENUM_ACCOUNT_TRADE_MODE     GetTradeMode(void) const;
    string                      GetTradeModeDescription(void) const;
    long                        GetLeverage(void) const;
    ENUM_ACCOUNT_STOPOUT_MODE   GetStopOutMode(void) const;
    string                      GetStopOutModeDescription(void) const;
    ENUM_ACCOUNT_MARGIN_MODE    GetMarginMode(void) const;
    string                      GetMarginModeDescription(void) const;
    bool                        GetTradeAllowed(void) const;
    bool                        GetTradeExpert(void) const;
    int                         GetLimitOrders(void) const;
    double                      GetBalance(void) const;
    double                      GetCredit(void) const;
    double                      GetProfit(void) const;
    double                      GetEquity(void) const;
    double                      GetMargin(void) const;
    double                      GetFreeMargin(void) const;
    double                      GetMarginLevel(void) const;
    double                      GetMarginCall(void) const;
    double                      GetMarginStopOut(void) const;
    string                      GetAccountName(void) const;
    string                      GetServerName(void) const;
    string                      GetCurrencyName(void) const;
    string                      GetCompanyName(void) const;
    long                        InfoInteger(const ENUM_ACCOUNT_INFO_INTEGER prop_id) const;
    double                      InfoDouble(const ENUM_ACCOUNT_INFO_DOUBLE prop_id) const;
    string                      InfoString(const ENUM_ACCOUNT_INFO_STRING prop_id) const;
    double                      CalcOrderProfit(const string symbol, const ENUM_ORDER_TYPE trade_operation, const double volume, const double price_open, const double price_close) const;
    double                      CalcMargin(const string symbol, const ENUM_ORDER_TYPE trade_operation, const double volume, const double price) const;
    double                      CalcFreeMargin(const string symbol, const ENUM_ORDER_TYPE trade_operation, const double volume, const double price) const;
    double                      CalcMaxLotByPercent(const string symbol, const ENUM_ORDER_TYPE trade_operation, const double price, const double percent = 100) const;
};


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CAccountObject::CAccountObject(void) {
}


//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CAccountObject::~CAccountObject(void) {
}


//+------------------------------------------------------------------+
//| アカウントの口座番号を取得
//+------------------------------------------------------------------+
long CAccountObject::GetLogin(void) const {
    return(AccountInfoInteger(ACCOUNT_LOGIN));
}


//+------------------------------------------------------------------+
//| アカウントの取引状態を取得
//+------------------------------------------------------------------+
ENUM_ACCOUNT_TRADE_MODE CAccountObject::GetTradeMode(void) const {
//--- ACCOUNT_TRADE_MODE_DEMO or ACCOUNT_TRADE_MODE_CONTEST or ACCOUNT_TRADE_MODE_REAL
    return((ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE));
}


//+------------------------------------------------------------------+
//| アカウントの取引状態を表す文字列を取得
//+------------------------------------------------------------------+
string CAccountObject::GetTradeModeDescription(void) const {
    string str;

    switch(GetTradeMode()) {
    case ACCOUNT_TRADE_MODE_DEMO:
        str = "模擬取引用のアカウント";
        break;
    case ACCOUNT_TRADE_MODE_CONTEST:
        str = "コンテスト用のアカウント";
        break;
    case ACCOUNT_TRADE_MODE_REAL:
        str = "実取引用のアカウント";
        break;
    default:
        str = "不明なアカウント";
    }

//---
    return(str);
}


//+------------------------------------------------------------------+
//| アカウントのレバレッジ設定値を取得
//+------------------------------------------------------------------+
long CAccountObject::GetLeverage(void) const {
    return(AccountInfoInteger(ACCOUNT_LEVERAGE));
}


//+------------------------------------------------------------------+
//| アカウントでストップアウト（オープンポジションの強制決済）を起こす際の発生基準を取得
//| 百分率なのか、固定値（通貨単位）なのか
//+------------------------------------------------------------------+
ENUM_ACCOUNT_STOPOUT_MODE CAccountObject::GetStopOutMode(void) const {
    return((ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE));
}


//+------------------------------------------------------------------+
//| アカウントでストップアウトの状態を説明する文字列を取得
//+------------------------------------------------------------------+
string CAccountObject::GetStopOutModeDescription(void) const {
    string str;

    switch(GetStopOutMode()) {
    case ACCOUNT_STOPOUT_MODE_PERCENT:
        str = "百分率における指定値";
        break;
    case ACCOUNT_STOPOUT_MODE_MONEY:
        str = "通貨による指定値";
        break;
    default:
        str = "不明なストップアウトモード";
    }

//---
    return(str);
}


//+------------------------------------------------------------------+
//| アカウントのマージンモードを取得
//+------------------------------------------------------------------+
ENUM_ACCOUNT_MARGIN_MODE CAccountObject::GetMarginMode(void) const {
    return((ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE));
}


//+------------------------------------------------------------------+
//| カウントのマージンモードを説明する文字列を取得
//+------------------------------------------------------------------+
string CAccountObject::GetMarginModeDescription(void) const {
    string str;

    switch(GetMarginMode()) {
    case ACCOUNT_MARGIN_MODE_RETAIL_NETTING:
        str = "Netting";
        break;
    case ACCOUNT_MARGIN_MODE_EXCHANGE:
        str = "Exchange";
        break;
    case ACCOUNT_MARGIN_MODE_RETAIL_HEDGING:
        str = "Hedging";
        break;
    default:
        str = "不明なマージンモード";
    }

//---
    return(str);
}


//+------------------------------------------------------------------+
//| アカウントの取引許可の状態を取得
//+------------------------------------------------------------------+
bool CAccountObject::GetTradeAllowed(void) const {
    return((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED));
}


//+------------------------------------------------------------------+
//| アカウントのEA使用許可の状態を取得
//+------------------------------------------------------------------+
bool CAccountObject::GetTradeExpert(void) const {
    return((bool)AccountInfoInteger(ACCOUNT_TRADE_EXPERT));
}


//+------------------------------------------------------------------+
//| アカウントのオープンポジションの保有上限数を取得
//+------------------------------------------------------------------+
int CAccountObject::GetLimitOrders(void) const {
    return((int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS));
}


//+------------------------------------------------------------------+
//| アカウントの口座残高を取得
//+------------------------------------------------------------------+
double CAccountObject::GetBalance(void) const {
    return(AccountInfoDouble(ACCOUNT_BALANCE));
}


//+------------------------------------------------------------------+
//| アカウントのクレジット残高を取得
//+------------------------------------------------------------------+
double CAccountObject::GetCredit(void) const {
    return(AccountInfoDouble(ACCOUNT_CREDIT));
}


//+------------------------------------------------------------------+
//| アカウントの現在の損益を取得
//+------------------------------------------------------------------+
double CAccountObject::GetProfit(void) const {
    return(AccountInfoDouble(ACCOUNT_PROFIT));
}


//+------------------------------------------------------------------+
//| アカウントの有効証拠金を取得
//+------------------------------------------------------------------+
double CAccountObject::GetEquity(void) const {
    return(AccountInfoDouble(ACCOUNT_EQUITY));
}


//+------------------------------------------------------------------+
//| アカウントの必要証拠金を取得
//+------------------------------------------------------------------+
double CAccountObject::GetMargin(void) const {
    return(AccountInfoDouble(ACCOUNT_MARGIN));
}


//+------------------------------------------------------------------+
//| アカウントの余剰証拠金を取得
//+------------------------------------------------------------------+
double CAccountObject::GetFreeMargin(void) const {
    return(AccountInfoDouble(ACCOUNT_MARGIN_FREE));
}


//+------------------------------------------------------------------+
//| アカウントの証拠金維持率（％）を取得
//+------------------------------------------------------------------+
double CAccountObject::GetMarginLevel(void) const {
    return(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));
}


//+------------------------------------------------------------------+
//| アカウントの証拠金コールレベル（追加の入金を求める警告）を取得
//+------------------------------------------------------------------+
double CAccountObject::GetMarginCall(void) const {
    return(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL));
}


//+------------------------------------------------------------------+
//| アカウントのストップアウトレベルを取得
//+------------------------------------------------------------------+
double CAccountObject::GetMarginStopOut(void) const {
    return(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
}


//+------------------------------------------------------------------+
//| アカウント名を取得
//+------------------------------------------------------------------+
string CAccountObject::GetAccountName(void) const {
    return(AccountInfoString(ACCOUNT_NAME));
}


//+------------------------------------------------------------------+
//| アカウントの取引サーバー名を取得
//+------------------------------------------------------------------+
string CAccountObject::GetServerName(void) const {
    return(AccountInfoString(ACCOUNT_SERVER));
}


//+------------------------------------------------------------------+
//| アカウントの口座通貨名を取得
//+------------------------------------------------------------------+
string CAccountObject::GetCurrencyName(void) const {
    return(AccountInfoString(ACCOUNT_CURRENCY));
}


//+------------------------------------------------------------------+
//| アカウントを提供する会社名を取得
//+------------------------------------------------------------------+
string CAccountObject::GetCompanyName(void) const {
    return(AccountInfoString(ACCOUNT_COMPANY));
}


//+------------------------------------------------------------------+
//| Access functions AccountInfoInteger(...)                         |
//+------------------------------------------------------------------+
long CAccountObject::InfoInteger(const ENUM_ACCOUNT_INFO_INTEGER prop_id) const {
    return(AccountInfoInteger(prop_id));
}


//+------------------------------------------------------------------+
//| Access functions AccountInfoDouble(...)                          |
//+------------------------------------------------------------------+
double CAccountObject::InfoDouble(const ENUM_ACCOUNT_INFO_DOUBLE prop_id) const {
    return(AccountInfoDouble(prop_id));
}


//+------------------------------------------------------------------+
//| Access functions AccountInfoString(...)                          |
//+------------------------------------------------------------------+
string CAccountObject::InfoString(const ENUM_ACCOUNT_INFO_STRING prop_id) const {
    return(AccountInfoString(prop_id));
}


//+------------------------------------------------------------------+
//| 指定した銘柄・売買方向・取引量・始値・終値で取引した場合の損益を計算して返却
//+------------------------------------------------------------------+
double CAccountObject::CalcOrderProfit(
    const string symbol, const ENUM_ORDER_TYPE trade_operation,
    const double volume, const double price_open, const double price_close
) const {
    double profit = EMPTY_VALUE;

    if(!OrderCalcProfit(trade_operation, symbol, volume, price_open, price_close, profit))
        return(EMPTY_VALUE);

//---
    return(profit);
}


//+------------------------------------------------------------------+
//| 指定した銘柄・売買方向・取引量・始値で約定するために必要な証拠金額を計算して返却
//+------------------------------------------------------------------+
double CAccountObject::CalcMargin(
    const string symbol, const ENUM_ORDER_TYPE trade_operation,
    const double volume, const double price
) const {
    double margin = EMPTY_VALUE;

    if(!OrderCalcMargin(trade_operation, symbol, volume, price, margin))
        return(EMPTY_VALUE);

//---
    return(margin);
}


//+------------------------------------------------------------------+
//+ 指定した銘柄・売買方向・取引量・始値で約定した場合の残りの余剰証拠金を計算して返却
//+------------------------------------------------------------------+
double CAccountObject::CalcFreeMargin(
    const string symbol,
    const ENUM_ORDER_TYPE trade_operation,
    const double volume,
    const double price
) const {
    return(GetFreeMargin() - CalcMargin(symbol, trade_operation, volume, price));
}


//+------------------------------------------------------------------+
//| Access functions OrderCalcMargin(...).                           |
//| INPUT:  name            - symbol name,                           |
//|         trade_operation - trade operation,                       |
//|         price           - price of the opening position,         |
//|         percent         - percent of available margin [1-100%].   |
//+------------------------------------------------------------------+
double CAccountObject::CalcMaxLotByPercent(
    const string symbol,
    const ENUM_ORDER_TYPE trade_operation,
    const double price,
    const double percent
) const {
    double margin = 0.0;

//--- 引数についての例外処理
    if(symbol == "" || price <= 0.0 || percent < 1 || percent > 100) {
        Print("CAccountObject::CalcMaxLotByPercent invalid parameters");
        return(0.0);
    }


//--- 1ロットを約定するために必要な証拠金についての例外処理
    if(!OrderCalcMargin(trade_operation, symbol, 1.0, price, margin) || margin < 0.0) {
        Print("CAccountObject::CalcMaxLotByPercent margin calculation failed");
        return(0.0);
    }

//--- 例外処理に必要（指値注文のためらしい）
    if(margin == 0.0)
        return(SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX));

//--- 余剰証拠金に基づいて、注文可能な最大取引量を取得
    double volume = NormalizeDouble(GetFreeMargin() * percent / 100.0 / margin, 2);

//--- 最大取引量が刻み幅に適合するように調整
    double stepvol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
    if(stepvol > 0.0)
        volume = stepvol * MathFloor(volume / stepvol);

//--- 最大取引量の上限・下限の範囲内に収まるように調整
    double minvol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    if(volume < minvol)
        volume = 0.0;
    double maxvol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
    if(volume > maxvol)
        volume = maxvol;

//---
    return(volume);
}


//+------------------------------------------------------------------+
