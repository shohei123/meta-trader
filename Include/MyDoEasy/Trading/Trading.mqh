//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
// #include <MyDoEasy/Objects/Account.mqh>
// #include <MyDoEasy/Objects/CBaseObject.mqh>
// #include <MyDoEasy/Objects/Deal.mqh>
// #include <MyDoEasy/Objects/History.mqh>
// #include <MyDoEasy/Objects/Order.mqh>
// #include <MyDoEasy/Objects/Position.mqh>
#include <Object.mqh>


//+------------------------------------------------------------------+
//| Define
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Enum
//+------------------------------------------------------------------+
enum ENUM_LOG_LEVELS
   {
    LOG_LEVEL_NO        = 0,
    LOG_LEVEL_ERRORS    = 1,
    LOG_LEVEL_ALL       = 2
   };


//+------------------------------------------------------------------+
//| Class
//+------------------------------------------------------------------+
class CTrading: public CObject
   {
protected:
    MqlTradeRequest                 m_request;
    MqlTradeResult                  m_result;
    MqlTradeCheckResult             m_check_result;
    bool                            m_is_async_mode;        //--- 発注の非同期処理の有無
    ulong                           m_magic_number;         //--- EAのマジックナンバー
    ulong                           m_deviation;            //--- スリッページ
    ENUM_ORDER_TYPE_FILLING         m_type_filling;         //--- 注文のフィルモード（取引所によって異なるので、適切な種類を設定）
    ENUM_ACCOUNT_MARGIN_MODE        m_margin_mode;          //--- 主にネッティングorヘッジング
    ENUM_LOG_LEVELS                 m_log_level;            //--- ログ出力の詳細度


public:
                     CTrading(void);
                    ~CTrading(void);

    //--- request構造体の操作
    void                            CopyRequest(MqlTradeRequest &request)               const;
    void                            PrintRequest(void) const;
    ENUM_TRADE_REQUEST_ACTIONS      GetRequestAction(void)                              const {return(m_request.action);} // deal, pending, sltp, modify, remove, close
    string                          GetRequestActionDescription(void)                   const;
    ulong                           GetRequestMagicNumber(void)                         const {return(m_request.magic);}
    ulong                           GetRequestOrder(void)                               const {return(m_request.order);}
    ulong                           GetRequestPosition(void)                            const {return(m_request.position);}
    ulong                           GetRequestPositionBy(void)                          const {return(m_request.position_by);}
    string                          GetRequestSymbol(void)                              const {return(m_request.symbol);}
    double                          GetRequestVolume(void)                              const {return(m_request.volume);}
    double                          GetRequestPrice(void)                               const {return(m_request.price);}
    double                          GetRequestStopLimit(void)                           const {return(m_request.stoplimit);}
    double                          GetRequestStopLoss(void)                            const {return(m_request.sl);}
    double                          GetRequestTakeProfit(void)                          const {return(m_request.tp);}
    ulong                           GetRequestDeviation(void)                           const {return(m_request.deviation);}
    ENUM_ORDER_TYPE                 GetRequestType(void)                                const {return(m_request.type);} // buy, sell, buy limit, sell limit, buy stop, sell stop, buy stop limit, sell stop limit, close by
    string                          GetRequestTypeDescription(void)                     const;
    ENUM_ORDER_TYPE_FILLING         GetRequestTypeFilling(void)                         const {return(m_request.type_filling);}
    string                          GetRequestTypeFillingDescription(void)              const;
    ENUM_ORDER_TYPE_TIME            GetRequestTypeTime(void)                            const {return(m_request.type_time);} // gtc, day, specified, specified day
    string                          GetRequestTypeTimeDescription(void)                 const;
    datetime                        GetRequestExpiration(void)                          const {return(m_request.expiration);}
    string                          GetRequestComment(void)                             const {return(m_request.comment);}

    //--- result構造体の操作
    void                            CopyResult(MqlTradeResult &result)                  const;
    void                            PrintResult(void) const;
    uint                            GetResultRetCode(void)                              const {return(m_result.retcode);}
    string                          GetResultRetCodeDescription(void)                   const;
    int                             GetResultRetCodeExternal(void)                      const {return(m_result.retcode_external);}
    ulong                           GetResultDeal(void)                                 const {return(m_result.deal);}
    ulong                           GetResultOrder(void)                                const {return(m_result.order);}
    double                          GetResultVolume(void)                               const {return(m_result.volume);}
    double                          GetResultPrice(void)                                const {return(m_result.price);}
    double                          GetResultBid(void)                                  const {return(m_result.bid);}
    double                          GetResultAsk(void)                                  const {return(m_result.ask);}
    string                          GetResultComment(void)                              const {return(m_result.comment);}

    //--- check_result構造体の操作
    void                            CopyCheckResult(MqlTradeCheckResult &check_result)  const;
    uint                            GetCheckResultRetcode(void)                         const {return(m_check_result.retcode);} // 返信コード
    string                          GetCheckResultRetcodeDescription(void)              const;
    double                          GetCheckResultBalance(void)                         const {return(m_check_result.balance);} // 約定実行後の残高
    double                          GetCheckResultEquity(void)                          const {return(m_check_result.equity);} // 口座残高 + 含み損益 + 未決済注文の必要証拠金
    double                          GetCheckResultProfit(void)                          const {return(m_check_result.profit);} // 含み損益
    double                          GetCheckResultMargin(void)                          const {return(m_check_result.margin);} // 必要証拠金
    double                          GetCheckResultMarginFree(void)                      const {return(m_check_result.margin_free);} // 余剰証拠金
    double                          GetCheckResultMarginLevel(void)                     const {return(m_check_result.margin_level);} // 証拠金維持率
    string                          GetCheckResultComment(void)                         const {return(m_check_result.comment);}

    //--- 取引用のメンバの更新
    void                            SetAsyncMode(const bool mode);
    void                            SetExpertMagicNumber(const ulong magic_number);
    void                            SetDeviationInPoints(const ulong deviation);
    void                            SetTypeFilling(const ENUM_ORDER_TYPE_FILLING filling);
    bool                            SetTypeFillingBySymbol(const string symbol);
    void                            SetMarginMode(void);

    //--- オープンポジションの操作
    bool                            PositionOpen(const string symbol, const ENUM_ORDER_TYPE order_type, const double volume, const double price, const double sl, const double tp, const string comment = "");
    bool                            PositionModify(const string symbol, const double sl, const double tp);
    bool                            PositionModifyByTicket(const ulong ticket, const double sl, const double tp);
    bool                            PositionClose(const string symbol, const ulong deviation = ULONG_MAX);
    bool                            PositionCloseByTicket(const ulong ticket, const ulong deviation = ULONG_MAX);
    bool                            PositionCloseByTicketAndAnotherOne(const ulong ticket, const ulong ticket_by);
    void                            PositionCloseAllByType(const ENUM_POSITION_TYPE pos_type);
    bool                            PositionClosePartialBySymbol(const string symbol, const double volume, const ulong deviation = ULONG_MAX);
    bool                            PositionClosePartialByTicket(const ulong ticket, const double volume, const ulong deviation = ULONG_MAX);

    //--- 指値注文の操作
    bool                            PendingOrderOpen(const string symbol, const ENUM_ORDER_TYPE order_type, const double volume, const double stop_limit, const double price, const double sl, const double tp, ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC, const datetime expiration = 0, const string comment = "");
    bool                            PendingOrderModifyByTicket(const ulong ticket, const double price, const double sl, const double tp, const ENUM_ORDER_TYPE_TIME type_time, const datetime expiration, const double stoplimit = 0.0);
    bool                            PendingOrderDeleteByTicket(const ulong ticket);
    bool                            PendingOrderAllDelete(void);
    bool                            PendingOrderAllDeleteBySymbol(const string symbol);

    //--- 簡易化した注文
    bool                            Buy(const double volume, const string symbol = NULL, double price = 0.0, const double sl = 0.0, const double tp = 0.0, const string comment = "");
    bool                            Sell(const double volume, const string symbol = NULL, double price = 0.0, const double sl = 0.0, const double tp = 0.0, const string comment = "");
    bool                            BuyLimit(const double volume, const double price, const string symbol = NULL, const double sl = 0.0, const double tp = 0.0, const ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC, const datetime expiration = 0, const string comment = "");
    bool                            BuyStop(const double volume, const double price, const string symbol = NULL, const double sl = 0.0, const double tp = 0.0, const ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC, const datetime expiration = 0, const string comment = "");
    bool                            SellLimit(const double volume, const double price, const string symbol = NULL, const double sl = 0.0, const double tp = 0.0, const ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC, const datetime expiration = 0, const string comment = "");
    bool                            SellStop(const double volume, const double price, const string symbol = NULL, const double sl = 0.0, const double tp = 0.0, const ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC, const datetime expiration = 0, const string comment = "");


    //--- 非同期対応版の注文送信
    bool                            OrderSendWithAsyncSupport(const MqlTradeRequest &request, MqlTradeResult &result);

    //--- 検証
    virtual double                  CheckVolume(const string symbol, double volume, double price, ENUM_ORDER_TYPE order_type);
    virtual bool                    OrderCheck(const MqlTradeRequest &request, MqlTradeCheckResult &check_result);

    //--- 整形
    string                          FormatPositionType(string &str, const uint type) const;
    string                          FormatOrderType(string &str, const uint type) const;
    string                          FormatOrderTypeFilling(string &str, const uint type) const;
    string                          FormatOrderTypeTime(string &str, const uint type) const;
    string                          FormatOrderPrice(string &str, const double price_order, const double price_trigger, const uint digits) const;
    string                          FormatRequest(string &str, const MqlTradeRequest &request) const;
    string                          FormatRequestResult(string &str, const MqlTradeRequest &request, const MqlTradeResult &result) const;

protected:
    bool                            FillingCheck(const string symbol);
    bool                            ExpirationCheck(const string symbol);
    bool                            OrderTypeCheck(const string symbol);
    void                            ClearStructures(void);
    bool                            IsStopped(const string function);
    bool                            IsHedging(void) const {return(m_margin_mode == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING);}
    bool                            SelectPosition(const string symbol);
   };


//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+
CTrading::CTrading(void) :
    m_is_async_mode(false),
    m_magic_number(0),
    m_deviation(10),
    m_type_filling(ORDER_FILLING_FOK),
    m_log_level(LOG_LEVEL_ERRORS)
   {

// 取引口座のマージンモードを取得
    this.SetMarginMode();

// 構造体3種の初期化
    this.ClearStructures();

// 動作環境に応じて、ログレベルを調整
    if(MQLInfoInteger(MQL_TESTER))
        m_log_level = LOG_LEVEL_ALL;

    if(MQLInfoInteger(MQL_OPTIMIZATION))
        m_log_level = LOG_LEVEL_NO;
   }


//+------------------------------------------------------------------+
//| Destructor
//+------------------------------------------------------------------+
CTrading::~CTrading(void)
   {

   }


//+------------------------------------------------------------------+
//| CopyRequest
//+------------------------------------------------------------------+
void CTrading::CopyRequest(MqlTradeRequest &request) const
   {
       {
        request.action      = m_request.action;
        request.magic       = m_request.magic;
        request.order       = m_request.order;
        request.symbol      = m_request.symbol;
        request.volume      = m_request.volume;
        request.price       = m_request.price;
        request.stoplimit   = m_request.stoplimit;
        request.sl          = m_request.sl;
        request.tp          = m_request.tp;
        request.deviation   = m_request.deviation;
        request.type        = m_request.type;
        request.type_filling = m_request.type_filling;
        request.type_time   = m_request.type_time;
        request.expiration  = m_request.expiration;
        request.comment     = m_request.comment;
        request.position    = m_request.position;
        request.position_by = m_request.position_by;
       }
   }


//+------------------------------------------------------------------+
//| PrintRequest
//+------------------------------------------------------------------+
void CTrading::PrintRequest(void) const
   {
    if(m_log_level < LOG_LEVEL_ALL)
        return;
    string str;
    PrintFormat("%s", FormatRequest(str, m_request));
   }


//+------------------------------------------------------------------+
//| CopyResult
//+------------------------------------------------------------------+
void CTrading::CopyResult(MqlTradeResult &result) const
   {
    result.retcode   = m_result.retcode;
    result.deal      = m_result.deal;
    result.order     = m_result.order;
    result.volume    = m_result.volume;
    result.price     = m_result.price;
    result.bid       = m_result.bid;
    result.ask       = m_result.ask;
    result.comment   = m_result.comment;
    result.request_id = m_result.request_id;
    result.retcode_external = m_result.retcode_external;
   }


//+------------------------------------------------------------------+
//| PrintResult
//+------------------------------------------------------------------+
void CTrading::PrintResult(void) const
   {
    if(m_log_level < LOG_LEVEL_ALL)
        return;
    string str;
    PrintFormat("%s", FormatRequestResult(str, m_request, m_result));
   }


//+------------------------------------------------------------------+
//| Get the retcode value as string                                  |
//+------------------------------------------------------------------+
string CTrading::GetResultRetCodeDescription(void) const
  {
   string str;
   FormatRequestResult(str,m_request,m_result);
   
//---
   return(str);
  }


//+------------------------------------------------------------------+
//| CopyCheckResult
//+------------------------------------------------------------------+
void CTrading::CopyCheckResult(MqlTradeCheckResult &check_result) const
   {
       {
        check_result.retcode     = m_check_result.retcode;
        check_result.balance     = m_check_result.balance;
        check_result.equity      = m_check_result.equity;
        check_result.profit      = m_check_result.profit;
        check_result.margin      = m_check_result.margin;
        check_result.margin_free = m_check_result.margin_free;
        check_result.margin_level = m_check_result.margin_level;
        check_result.comment     = m_check_result.comment;
       }

   }

//+------------------------------------------------------------------+
//| SetAsyncMode
//+------------------------------------------------------------------+
void CTrading::SetAsyncMode(const bool mode)
   {
    m_is_async_mode = mode;
   }


//+------------------------------------------------------------------+
//| SetExpertMagicNumber
//+------------------------------------------------------------------+
void CTrading::SetExpertMagicNumber(const ulong magic_number)
   {
    m_magic_number = magic_number;
   }


//+------------------------------------------------------------------+
//| SetDeviationInPoints
//+------------------------------------------------------------------+
void CTrading::SetDeviationInPoints(const ulong deviation)
   {
    m_deviation = deviation;
   }


//+------------------------------------------------------------------+
//| SetTypeFilling
//+------------------------------------------------------------------+
void CTrading::SetTypeFilling(const ENUM_ORDER_TYPE_FILLING filling)
   {
    m_type_filling = filling;
   }


//+------------------------------------------------------------------+
//| SetTypeFillingBySymbol
//+------------------------------------------------------------------+
bool CTrading::SetTypeFillingBySymbol(const string symbol)
   {
    uint filling = (uint)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);
    if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
       {
        m_type_filling = ORDER_FILLING_FOK;
        return(true);
       }
    if((filling & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
       {
        m_type_filling = ORDER_FILLING_IOC;
        return(true);
       }
    return(false);
   }


//+------------------------------------------------------------------+
//| SetMarginMode
//+------------------------------------------------------------------+
void  CTrading::SetMarginMode(void)
   {
    m_margin_mode = (ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   }


//+------------------------------------------------------------------+
//| 成行注文を出す
//+------------------------------------------------------------------+
bool CTrading::PositionOpen(const string symbol, const ENUM_ORDER_TYPE order_type, const double volume, const double price, const double sl, const double tp, const string comment = "")
   {
// 強制シャットダウン状態なのか確認
    if(IsStopped(__FUNCTION__))
        return(false);

//--- 構造体3種の初期化
    ClearStructures();

//--- 指値注文の場合は失敗させる
    if(order_type != ORDER_TYPE_BUY && order_type != ORDER_TYPE_SELL)
       {
        m_result.retcode = TRADE_RETCODE_INVALID;
        m_result.comment = "無効な注文方法です";
        return(false);
       }

//--- request構造体に成行注文用の値を設定
    m_request.action   = TRADE_ACTION_DEAL;
    m_request.symbol   = symbol;
    m_request.magic    = m_magic_number;
    m_request.volume   = volume;
    m_request.type     = order_type;
    m_request.price    = price;
    m_request.sl       = sl;
    m_request.tp       = tp;
    m_request.deviation = m_deviation;

//--- その銘柄で利用可能な注文方法（m_request.action）なのか確認
    if(!OrderTypeCheck(symbol))
        return(false);

//--- cその銘柄で利用可能な充填方法なのか確認
    if(!FillingCheck(symbol))
        return(false);

    m_request.comment = comment;

//--- 新規注文の実行

    return(OrderSendWithAsyncSupport(m_request, m_result));
   }


//+------------------------------------------------------------------+
//| オープンポジションの利食い・損切りの価格を修正（最初に検索ヒットしたポジションが対象）
//+------------------------------------------------------------------+
bool CTrading::PositionModify(const string symbol, const double sl, const double tp)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

//--- オープンポジションを選択（銘柄・マジックナンバーの一致する最初のポジション）
    if(!SelectPosition(symbol))
        return(false);

    ClearStructures();

    m_request.action  = TRADE_ACTION_SLTP;
    m_request.magic   = m_magic_number;
    m_request.symbol  = symbol;
    m_request.sl      = sl;
    m_request.tp      = tp;
    m_request.position = PositionGetInteger(POSITION_TICKET);

    return(OrderSendWithAsyncSupport(m_request, m_result));
   }


//+------------------------------------------------------------------+
//| オープンポジションの利食い・損切りの価格を修正（対象はチケットで指定）
//+------------------------------------------------------------------+
bool CTrading::PositionModifyByTicket(const ulong ticket, const double sl, const double tp)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

    if(!PositionSelectByTicket(ticket))
        return(false);

    ClearStructures();

    m_request.action  = TRADE_ACTION_SLTP;
    m_request.magic   = m_magic_number;
    m_request.symbol  = PositionGetString(POSITION_SYMBOL);
    m_request.sl      = sl;
    m_request.tp      = tp;
    m_request.position = ticket;

    return(OrderSendWithAsyncSupport(m_request, m_result));
   }


//+------------------------------------------------------------------+
//| オープンポジションの決済（最初に検索ヒットしたポジションが対象）
//+------------------------------------------------------------------+
bool CTrading::PositionClose(const string symbol, const ulong deviation = ULONG_MAX)
   {
    bool partial_close = false;
    int  retry_count  = 10;
    uint retcode      = TRADE_RETCODE_REJECT;

    if(IsStopped(__FUNCTION__))
        return(false);

    ClearStructures();

    if(!FillingCheck(symbol))
        return(false);

    do
       {
        //--- 決済対象のポジションを選択（銘柄・マジックナンバーの一致する最初のポジション）
        if(SelectPosition(symbol))
           {
            //--- ロングポジションを決済する場合（売り方向の成行注文の準備）
            if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
               {
                m_request.type = ORDER_TYPE_SELL;
                m_request.price = SymbolInfoDouble(symbol, SYMBOL_BID);
               }

            //--- ショートポジションを決済する場合（買い方向の成行注文の準備）
            else
               {
                m_request.type = ORDER_TYPE_BUY;
                m_request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
               }
           }

        //--- 決済対象のオープンポジションが存在しないので、エラーを発生
        else
           {
            m_result.retcode = retcode;
            return(false);
           }

        m_request.action   = TRADE_ACTION_DEAL;
        m_request.symbol   = symbol;
        m_request.volume   = PositionGetDouble(POSITION_VOLUME);
        m_request.magic    = m_magic_number;
        m_request.deviation = (deviation == ULONG_MAX) ? m_deviation : deviation;
        m_request.position = PositionGetInteger(POSITION_TICKET);

        //--- その銘柄における最大取引数量を取得して、適宜調整
        double max_volume = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);

        //--- 全決済できない場合は、部分決済を有効化
        //--- ネットアカウントは、同方向のポジションが加算されるため、最大取引数量を超過する場合がある
        if(m_request.volume > max_volume)
           {
            m_request.volume = max_volume;
            partial_close = true;
           }
        else
            partial_close = false;

        //--- ヘッジアカウントの場合は、1度だけ決済処理して終了
        //--- 1ポジション単位で決済される都合により、最大取引数量を超過しないから
        if(IsHedging())
            return(OrderSendWithAsyncSupport(m_request, m_result));

        //--- ネットアカウントの場合は、決済処理の終了後に、再処理回数の上限判定をおこなう
        if(!OrderSendWithAsyncSupport(m_request, m_result))
           {
            if(--retry_count != 0)
                continue;
            if(retcode == TRADE_RETCODE_DONE_PARTIAL)
                m_result.retcode = retcode;
            return(false);
           }

        //--- 非同期処理かつ部分決済する場合は、決済処理の安全性を考慮して、1度だけ決済処理して終了させる
        if(m_is_async_mode)
            break;
        retcode = TRADE_RETCODE_DONE_PARTIAL;

        //--- 部分決済の場合は、次の決済処理をおこなう前に、1秒だけ待機
        if(partial_close)
            Sleep(1000);
       }
    while(partial_close);


    return(true);
   }


//+------------------------------------------------------------------+
//| オープンポジションの決済（対象はチケットで指定）
//+------------------------------------------------------------------+
bool CTrading::PositionCloseByTicket(const ulong ticket, const ulong deviation = ULONG_MAX)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

//--- チケットIDによってポジション選択をおこない、売買対象の銘柄情報も取得
    if(!PositionSelectByTicket(ticket))
        return(false);
    string symbol = PositionGetString(POSITION_SYMBOL);

    ClearStructures();

    if(!FillingCheck(symbol))
        return(false);

    if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
       {
        m_request.type = ORDER_TYPE_SELL;
        m_request.price = SymbolInfoDouble(symbol, SYMBOL_BID);
       }
    else
       {
        m_request.type = ORDER_TYPE_BUY;
        m_request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
       }

    m_request.action   = TRADE_ACTION_DEAL;
    m_request.position = ticket;
    m_request.symbol   = symbol;
    m_request.volume   = PositionGetDouble(POSITION_VOLUME);
    m_request.magic    = m_magic_number;
    m_request.deviation = (deviation == ULONG_MAX) ? m_deviation : deviation;

    return(OrderSendWithAsyncSupport(m_request, m_result));
   }



//+------------------------------------------------------------------+
//| オープンポジションの決済（対象はチケットで指定して、かつ反対決済に別チケットを指定）
//+------------------------------------------------------------------+
bool CTrading::PositionCloseByTicketAndAnotherOne(const ulong ticket, const ulong ticket_by)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

//--- ポジション同士をぶつける決済なので、ヘッジアカウントのみ実行させる
    if(!IsHedging())
        return(false);

//--- 決済対象のポジションを選択して、銘柄と売買方向を取得
    if(!PositionSelectByTicket(ticket))
        return(false);
    string symbol = PositionGetString(POSITION_SYMBOL);
    ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

//--- 反対決済に使うポジションを選択して、銘柄と売買方向を取得
    if(!PositionSelectByTicket(ticket_by))
        return(false);
    string symbol_by = PositionGetString(POSITION_SYMBOL);
    ENUM_POSITION_TYPE type_by = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

//--- 例外処理（異なるチケットIDを利用しており、かつ銘柄が同じか確認）
    if(type == type_by)
        return(false);
    if(symbol != symbol_by)
        return(false);

    ClearStructures();

    if(!FillingCheck(symbol))
        return(false);

    m_request.action     = TRADE_ACTION_CLOSE_BY;
    m_request.position   = ticket;
    m_request.position_by = ticket_by;
    m_request.magic      = m_magic_number;


    return(OrderSendWithAsyncSupport(m_request, m_result));
   }


//+------------------------------------------------------------------+
//|PoitionCloseAllByDirection
//+------------------------------------------------------------------+
void CTrading::PositionCloseAllByType(const ENUM_POSITION_TYPE pos_type)
   {
    int total =  PositionsTotal();
    for(int index = total - 1; index >= 0; index--)
       {
        ulong ticket = PositionGetTicket(index);
        if(PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == m_magic_number)
            if(PositionGetInteger(POSITION_TYPE) == pos_type)
                this.PositionCloseByTicket(ticket);
       }
   }


//+------------------------------------------------------------------+
//| オープンポジションの部分決済（最初に検索ヒットしたポジションが対象）
//+------------------------------------------------------------------+
bool CTrading::PositionClosePartialBySymbol(const string symbol, const double volume, const ulong deviation = ULONG_MAX)
   {
    uint retcode = TRADE_RETCODE_REJECT;

    if(IsStopped(__FUNCTION__))
        return(false);

//--- ネットアカウントでは部分決済ができないので、ヘッジアカウントのみ実行させる
//--- ネットアカウントは反対ポジションを持てないので、全決済するか、ドテンするしかない
    if(!IsHedging())
        return(false);

    ClearStructures();

    if(!FillingCheck(symbol))
        return(false);

    if(SelectPosition(symbol))
       {
        if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
           {
            m_request.type = ORDER_TYPE_SELL;
            m_request.price = SymbolInfoDouble(symbol, SYMBOL_BID);
           }
        else
           {
            m_request.type = ORDER_TYPE_BUY;
            m_request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
           }
       }
    else
       {
        m_result.retcode = retcode;
        return(false);
       }

//--- 決済対象のポジションの取引数量を超過した場合は、調整
    double position_volume = PositionGetDouble(POSITION_VOLUME);
    if(position_volume > volume)
        position_volume = volume;

    m_request.action   = TRADE_ACTION_DEAL;
    m_request.symbol   = symbol;
    m_request.volume   = position_volume;
    m_request.magic    = m_magic_number;
    m_request.deviation = (deviation == ULONG_MAX) ? m_deviation : deviation;
    m_request.position = PositionGetInteger(POSITION_TICKET);

    return(OrderSendWithAsyncSupport(m_request, m_result));
   }


//+------------------------------------------------------------------+
//| オープンポジションの部分決済（対象はチケットで指定）
//+------------------------------------------------------------------+
bool CTrading::PositionClosePartialByTicket(const ulong ticket, const double volume, const ulong deviation = ULONG_MAX)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

    if(!IsHedging())
        return(false);

    if(!PositionSelectByTicket(ticket))
        return(false);
    string symbol = PositionGetString(POSITION_SYMBOL);

    ClearStructures();

    if(!FillingCheck(symbol))
        return(false);

    if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
       {
        m_request.type = ORDER_TYPE_SELL;
        m_request.price = SymbolInfoDouble(symbol, SYMBOL_BID);
       }
    else
       {
        m_request.type = ORDER_TYPE_BUY;
        m_request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
       }

    double position_volume = PositionGetDouble(POSITION_VOLUME);
    if(position_volume > volume)
        position_volume = volume;

    m_request.action   = TRADE_ACTION_DEAL;
    m_request.position = ticket;
    m_request.symbol   = symbol;
    m_request.volume   = position_volume;
    m_request.magic    = m_magic_number;
    m_request.deviation = (deviation == ULONG_MAX) ? m_deviation : deviation;

    return(OrderSendWithAsyncSupport(m_request, m_result));
   }


//+------------------------------------------------------------------+
//| 新規の指値注文
//+------------------------------------------------------------------+
bool CTrading::PendingOrderOpen(const string symbol, const ENUM_ORDER_TYPE order_type, const double volume, const double stop_limit, const double price, const double sl, const double tp, ENUM_ORDER_TYPE_TIME type_time, const datetime expiration, const string comment)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

    ClearStructures();

    if(!FillingCheck(symbol))
        return(false);

//--- 成行売買に関するORDER_TYPEの場合は、エラーを発生させる
    if(order_type == ORDER_TYPE_BUY || order_type == ORDER_TYPE_SELL)
       {
        m_result.retcode = TRADE_RETCODE_INVALID;
        m_result.comment = "Invalid order type";
        return(false);
       }

//--- 期限の種類がGTC（キャンセルするまで有効）の場合
    if(type_time == ORDER_TIME_GTC && expiration == 0)
       {
        int exp = (int)SymbolInfoInteger(symbol, SYMBOL_EXPIRATION_MODE);

        //--- その銘柄でGTCが利用できない場合
        if((exp & SYMBOL_EXPIRATION_GTC) != SYMBOL_EXPIRATION_GTC)
           {
            //--- その銘柄にて、DAY（当日まで有効）も利用できないなら、エラーを発生
            //--- DAYを利用できるなら、ひとまず期限にDAYを設定しておく
            if((exp & SYMBOL_EXPIRATION_DAY) != SYMBOL_EXPIRATION_DAY)
               {
                Print(__FUNCTION__, ": Error: Unable to place order without explicitly specified expiration time");
                m_result.retcode = TRADE_RETCODE_INVALID_EXPIRATION;
                m_result.comment = "Invalid expiration type";
                return(false);
               }
            type_time = ORDER_TIME_DAY;
           }
       }

    m_request.action      = TRADE_ACTION_PENDING;
    m_request.magic       = m_magic_number;
    m_request.symbol      = symbol;
    m_request.volume      = volume;
    m_request.price       = price;
    m_request.stoplimit   = stop_limit;
    m_request.sl          = sl;
    m_request.tp          = tp;
    m_request.type        = order_type;
    m_request.type_time   = type_time;
    m_request.expiration  = expiration;


    if(!OrderTypeCheck(symbol))
        return(false);


    if(!FillingCheck(symbol))
       {
        m_result.retcode = TRADE_RETCODE_INVALID_FILL;
        Print(__FUNCTION__ + ": 無効な充填方法");
        return(false);
       }

    if(!ExpirationCheck(symbol))
       {
        m_result.retcode = TRADE_RETCODE_INVALID_EXPIRATION;
        Print(__FUNCTION__ + ": 無効な種類の期限");
        return(false);
       }

    m_request.comment = comment;

    return(OrderSendWithAsyncSupport(m_request, m_result));
   }


//+------------------------------------------------------------------+
//| 既存の指値注文（未約定）の修正
//+------------------------------------------------------------------+
bool CTrading::PendingOrderModifyByTicket(const ulong ticket, const double price, const double sl, const double tp, const ENUM_ORDER_TYPE_TIME type_time, const datetime expiration, const double stoplimit)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

    if(!OrderSelect(ticket))
        return(false);

    ClearStructures();

    m_request.symbol      = OrderGetString(ORDER_SYMBOL);
    m_request.action      = TRADE_ACTION_MODIFY;
    m_request.magic       = m_magic_number;
    m_request.order       = ticket;
    m_request.price       = price;
    m_request.stoplimit   = stoplimit;
    m_request.sl          = sl;
    m_request.tp          = tp;
    m_request.type_time   = type_time;
    m_request.expiration  = expiration;

    return(OrderSendWithAsyncSupport(m_request, m_result));
   }


//+------------------------------------------------------------------+
//| 既存の未約定注文をチケット指定で削除
//+------------------------------------------------------------------+
bool CTrading::PendingOrderDeleteByTicket(const ulong ticket)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

    ClearStructures();

    m_request.action    = TRADE_ACTION_REMOVE;
    m_request.magic     = m_magic_number;
    m_request.order     = ticket;

    return(OrderSendWithAsyncSupport(m_request, m_result));
   }


//+------------------------------------------------------------------+
//| 未約定注文を全削除
//+------------------------------------------------------------------+
bool CTrading::PendingOrderAllDelete(void)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

    int total = OrdersTotal();

    for(int i = total - 1; i >= 0; i--)
       {
        ClearStructures();

        ulong  order_ticket = OrderGetTicket(i);
        ulong  order_magic_number = OrderGetInteger(ORDER_MAGIC);

        if(order_magic_number == m_magic_number)
           {
            ZeroMemory(m_request);
            ZeroMemory(m_request);

            m_request.action    = TRADE_ACTION_REMOVE;
            m_request.magic     = order_magic_number;
            m_request.order     = order_ticket;

            if(!OrderSendWithAsyncSupport(m_request, m_result))
               {
                PrintFormat("未約定注文の全削除に失敗しました。エラー： %d", GetLastError());
                return false;
               }
           }
       }

    return(true);
   }



//+------------------------------------------------------------------+
//| 特定の銘柄に関する未約定注文の全削除
//+------------------------------------------------------------------+
bool CTrading::PendingOrderAllDeleteBySymbol(const string symbol)
   {
    if(IsStopped(__FUNCTION__))
        return(false);

    int total = OrdersTotal();

    for(int i = total - 1; i >= 0; i--)
       {
        ClearStructures();

        ulong  order_ticket = OrderGetTicket(i);
        ulong  order_magic_number = OrderGetInteger(ORDER_MAGIC);
        string order_symbol = OrderGetString(ORDER_SYMBOL);

        if(order_magic_number == m_magic_number && order_symbol == symbol)
           {
            ZeroMemory(m_request);
            ZeroMemory(m_request);

            m_request.action    = TRADE_ACTION_REMOVE;
            m_request.magic     = order_magic_number;
            m_request.order     = order_ticket;

            if(!OrderSendWithAsyncSupport(m_request, m_result))
               {
                PrintFormat("%sの未約定注文の全削除に失敗しました。エラー： %d", symbol, GetLastError());
                return(false);
               }
           }
       }

    return(true);
   }


//+------------------------------------------------------------------+
//| 成行の買い注文
//+------------------------------------------------------------------+
bool CTrading::Buy(const double volume, const string symbol = NULL, double price = 0.0, const double sl = 0.0, const double tp = 0.0, const string comment = "")
   {
    if(volume <= 0.0)
       {
        m_result.retcode = TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

    string symbol_name = (symbol == NULL) ? _Symbol : symbol;

    if(price == 0.0)
        price = SymbolInfoDouble(symbol_name, SYMBOL_ASK);

    return(PositionOpen(symbol_name, ORDER_TYPE_BUY, volume, price, sl, tp, comment));
   }


//+------------------------------------------------------------------+
//| 成行の売り注文
//+------------------------------------------------------------------+
bool CTrading::Sell(const double volume, const string symbol = NULL, double price = 0.0, const double sl = 0.0, const double tp = 0.0, const string comment = "")
   {
    if(volume <= 0.0)
       {
        m_result.retcode = TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

    string symbol_name = (symbol == NULL) ? _Symbol : symbol;

    if(price == 0.0)
        price = SymbolInfoDouble(symbol_name, SYMBOL_BID);

    return(PositionOpen(symbol_name, ORDER_TYPE_SELL, volume, price, sl, tp, comment));
   }


//+------------------------------------------------------------------+
//| 指値の買い注文
//+------------------------------------------------------------------+
bool CTrading::BuyLimit(const double volume, const double price, const string symbol = NULL, const double sl = 0.0, const double tp = 0.0, const ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC, const datetime expiration = 0, const string comment = "")
   {
    string symbol_name;

    if(volume <= 0.0)
       {
        m_result.retcode = TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

    symbol_name = (symbol == NULL) ? Symbol() : symbol;

    return(PendingOrderOpen(symbol_name, ORDER_TYPE_BUY_LIMIT, volume, 0.0, price, sl, tp, type_time, expiration, comment));
   }


//+------------------------------------------------------------------+
//| 逆指値の買い注文
//+------------------------------------------------------------------+
bool CTrading::BuyStop(const double volume, const double price, const string symbol = NULL, const double sl = 0.0, const double tp = 0.0, const ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC, const datetime expiration = 0, const string comment = "")
   {
    string symbol_name;

    if(volume <= 0.0)
       {
        m_result.retcode = TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

    symbol_name = (symbol == NULL) ? Symbol() : symbol;

    return(PendingOrderOpen(symbol_name, ORDER_TYPE_BUY_STOP, volume, 0.0, price, sl, tp, type_time, expiration, comment));
   }


//+------------------------------------------------------------------+
//| 指値の売り注文
//+------------------------------------------------------------------+
bool CTrading::SellLimit(const double volume, const double price, const string symbol = NULL, const double sl = 0.0, const double tp = 0.0, const ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC, const datetime expiration = 0, const string comment = "")
   {
    string symbol_name;

    if(volume <= 0.0)
       {
        m_result.retcode = TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

    symbol_name = (symbol == NULL) ? Symbol() : symbol;

    return(PendingOrderOpen(symbol_name, ORDER_TYPE_SELL_LIMIT, volume, 0.0, price, sl, tp, type_time, expiration, comment));
   }


//+------------------------------------------------------------------+
//| 逆指値の売り注文
//+------------------------------------------------------------------+
bool CTrading::SellStop(const double volume, const double price, const string symbol = NULL, const double sl = 0.0, const double tp = 0.0, const ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC, const datetime expiration = 0, const string comment = "")
   {
    string symbol_name;

    if(volume <= 0.0)
       {
        m_result.retcode = TRADE_RETCODE_INVALID_VOLUME;
        return(false);
       }

    symbol_name = (symbol == NULL) ? Symbol() : symbol;

    return(PendingOrderOpen(symbol_name, ORDER_TYPE_SELL_STOP, volume, 0.0, price, sl, tp, type_time, expiration, comment));
   }


//+------------------------------------------------------------------+
//| 非同期選択つきの注文送信
//+------------------------------------------------------------------+
bool CTrading::OrderSendWithAsyncSupport(const MqlTradeRequest & request, MqlTradeResult & result)
   {
    bool   res;
    string action = "";
    string fmt   = "";

//--- 非同期処理を使うかどうかによって、利用するシステムメソッドを分岐
    if(m_is_async_mode)
        res =::OrderSendAsync(request, result);
    else
        res =::OrderSend(request, result);

    if(res)
       {
        if(m_log_level > LOG_LEVEL_ERRORS)
            PrintFormat(__FUNCTION__ + ": %s [%s]", FormatRequest(action, request), FormatRequestResult(fmt, request, result));
       }
    else
       {
        if(m_log_level > LOG_LEVEL_NO)
            PrintFormat(__FUNCTION__ + ": %s [%s]", FormatRequest(action, request), FormatRequestResult(fmt, request, result));
       }
    return(res);
   }


//+------------------------------------------------------------------+
//| POSITION_TYPE列挙型を文字列に変換
//+------------------------------------------------------------------+
string CTrading::FormatPositionType(string & str, const uint type) const
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

    return(str);
   }


//+------------------------------------------------------------------+
//| ORDER_TYPE列挙型を文字列に変換
//+------------------------------------------------------------------+
string CTrading::FormatOrderType(string & str, const uint type) const
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
        default:
            str = "unknown order type " + (string)type;
       }

    return(str);
   }


//+------------------------------------------------------------------+
//| ORDER_FILLING列挙型を文字列に変換
//+------------------------------------------------------------------+
string CTrading::FormatOrderTypeFilling(string & str, const uint type) const
   {
    switch(type)
       {
        case ORDER_FILLING_RETURN:
            str = "return remainder";
            break;
        case ORDER_FILLING_IOC:
            str = "Immediate or Cancel";
            break;
        case ORDER_FILLING_FOK:
            str = "fill or kill";
            break;
        default:
            str = "unknown type filling " + (string)type;
            break;
       }

    return(str);
   }


//+------------------------------------------------------------------+
//| ORDER_TIME列挙型を文字列に変換
//+------------------------------------------------------------------+
string CTrading::FormatOrderTypeTime(string & str, const uint type) const
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

    return(str);
   }


//+------------------------------------------------------------------+
//| double型の価格を文字列に変換（triggerは、stop limit）
//+------------------------------------------------------------------+
string CTrading::FormatOrderPrice(string & str, const double price_order, const double price_trigger, const uint digits) const
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

    return(str);
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CTrading::FormatRequest(string & str, const MqlTradeRequest & request) const
   {
    string type, price, price_new;
    string tmp_string;
    long   tmp_long;

    str = "";

    string symbol_name = (request.symbol == NULL) ? _Symbol : request.symbol;
    int    digits = _Digits;
    ENUM_SYMBOL_TRADE_EXECUTION trade_execution = 0;
    if(SymbolInfoInteger(symbol_name, SYMBOL_DIGITS, tmp_long))
        digits = (int)tmp_long;
    if(SymbolInfoInteger(symbol_name, SYMBOL_TRADE_EXEMODE, tmp_long))
        trade_execution = (ENUM_SYMBOL_TRADE_EXECUTION)tmp_long;

    switch(request.action)
       {
        case TRADE_ACTION_DEAL:
            switch(trade_execution)
               {
                case SYMBOL_TRADE_EXECUTION_REQUEST:
                    if(IsHedging() && request.position != 0)
                        str = StringFormat("request %s %s position #%I64u %s at %s",
                                           FormatOrderType(type, request.type),
                                           DoubleToString(request.volume, 2),
                                           request.position,
                                           request.symbol,
                                           DoubleToString(request.price, digits));
                    else
                        str = StringFormat("request %s %s %s at %s",
                                           FormatOrderType(type, request.type),
                                           DoubleToString(request.volume, 2),
                                           request.symbol,
                                           DoubleToString(request.price, digits));

                    if(request.sl != 0.0)
                       {
                        tmp_string = StringFormat(" sl: %s", DoubleToString(request.sl, digits));
                        str += tmp_string;
                       }
                    if(request.tp != 0.0)
                       {
                        tmp_string = StringFormat(" tp: %s", DoubleToString(request.tp, digits));
                        str += tmp_string;
                       }
                    break;

                case SYMBOL_TRADE_EXECUTION_INSTANT:
                    if(IsHedging() && request.position != 0)
                        str = StringFormat("instant %s %s position #%I64u %s at %s",
                                           FormatOrderType(type, request.type),
                                           DoubleToString(request.volume, 2),
                                           request.position,
                                           request.symbol,
                                           DoubleToString(request.price, digits));
                    else
                        str = StringFormat("instant %s %s %s at %s",
                                           FormatOrderType(type, request.type),
                                           DoubleToString(request.volume, 2),
                                           request.symbol,
                                           DoubleToString(request.price, digits));

                    if(request.sl != 0.0)
                       {
                        tmp_string = StringFormat(" sl: %s", DoubleToString(request.sl, digits));
                        str += tmp_string;
                       }
                    if(request.tp != 0.0)
                       {
                        tmp_string = StringFormat(" tp: %s", DoubleToString(request.tp, digits));
                        str += tmp_string;
                       }
                    break;

                case SYMBOL_TRADE_EXECUTION_MARKET:
                    if(IsHedging() && request.position != 0)
                        str = StringFormat("market %s %s position #%I64u %s",
                                           FormatOrderType(type, request.type),
                                           DoubleToString(request.volume, 2),
                                           request.position,
                                           request.symbol);
                    else
                        str = StringFormat("market %s %s %s",
                                           FormatOrderType(type, request.type),
                                           DoubleToString(request.volume, 2),
                                           request.symbol);

                    if(request.sl != 0.0)
                       {
                        tmp_string = StringFormat(" sl: %s", DoubleToString(request.sl, digits));
                        str += tmp_string;
                       }
                    if(request.tp != 0.0)
                       {
                        tmp_string = StringFormat(" tp: %s", DoubleToString(request.tp, digits));
                        str += tmp_string;
                       }
                    break;

                case SYMBOL_TRADE_EXECUTION_EXCHANGE:
                    if(IsHedging() && request.position != 0)
                        str = StringFormat("exchange %s %s position #%I64u %s",
                                           FormatOrderType(type, request.type),
                                           DoubleToString(request.volume, 2),
                                           request.position,
                                           request.symbol);
                    else
                        str = StringFormat("exchange %s %s %s",
                                           FormatOrderType(type, request.type),
                                           DoubleToString(request.volume, 2),
                                           request.symbol);

                    if(request.sl != 0.0)
                       {
                        tmp_string = StringFormat(" sl: %s", DoubleToString(request.sl, digits));
                        str += tmp_string;
                       }
                    if(request.tp != 0.0)
                       {
                        tmp_string = StringFormat(" tp: %s", DoubleToString(request.tp, digits));
                        str += tmp_string;
                       }
                    break;
               }
            break;

        case TRADE_ACTION_PENDING:
            str = StringFormat("%s %s %s at %s",
                               FormatOrderType(type, request.type),
                               DoubleToString(request.volume, 2),
                               request.symbol,
                               FormatOrderPrice(price, request.price, request.stoplimit, digits));

            if(request.sl != 0.0)
               {
                tmp_string = StringFormat(" sl: %s", DoubleToString(request.sl, digits));
                str += tmp_string;
               }
            if(request.tp != 0.0)
               {
                tmp_string = StringFormat(" tp: %s", DoubleToString(request.tp, digits));
                str += tmp_string;
               }
            break;

        case TRADE_ACTION_SLTP:
            if(IsHedging() && request.position != 0)
                str = StringFormat("modify position #%I64u %s (sl: %s, tp: %s)",
                                   request.position,
                                   request.symbol,
                                   DoubleToString(request.sl, digits),
                                   DoubleToString(request.tp, digits));
            else
                str = StringFormat("modify %s (sl: %s, tp: %s)",
                                   request.symbol,
                                   DoubleToString(request.sl, digits),
                                   DoubleToString(request.tp, digits));
            break;

        case TRADE_ACTION_MODIFY:
            str = StringFormat("modify #%I64u at %s (sl: %s tp: %s)",
                               request.order,
                               FormatOrderPrice(price_new, request.price, request.stoplimit, digits),
                               DoubleToString(request.sl, digits),
                               DoubleToString(request.tp, digits));
            break;

        case TRADE_ACTION_REMOVE:
            str = StringFormat("cancel #%I64u", request.order);
            break;

        case TRADE_ACTION_CLOSE_BY:
            if(IsHedging() && request.position != 0)
                str = StringFormat("close position #%I64u by #%I64u", request.position, request.position_by);
            else
                str = StringFormat("wrong action close by (#%I64u by #%I64u)", request.position, request.position_by);
            break;

        default:
            str = "unknown action " + (string)request.action;
            break;
       }

    return(str);
   }


//+------------------------------------------------------------------+
//| result構造体のretcodeに格納された列挙型をに基づく情報に変換
//+------------------------------------------------------------------+
string CTrading::FormatRequestResult(string & str, const MqlTradeRequest & request, const MqlTradeResult & result) const
   {
    string symbol_name = (request.symbol == NULL) ? _Symbol : request.symbol;
    int    digits = _Digits;
    long   tmp_long;
    ENUM_SYMBOL_TRADE_EXECUTION trade_execution = 0;
    if(SymbolInfoInteger(symbol_name, SYMBOL_DIGITS, tmp_long))
        digits = (int)tmp_long;
    if(SymbolInfoInteger(symbol_name, SYMBOL_TRADE_EXEMODE, tmp_long))
        trade_execution = (ENUM_SYMBOL_TRADE_EXECUTION)tmp_long;

    switch(result.retcode)
       {
        case TRADE_RETCODE_REQUOTE:
            str = StringFormat("requote (%s/%s)",
                               DoubleToString(result.bid, digits),
                               DoubleToString(result.ask, digits));
            break;

        case TRADE_RETCODE_DONE:
            if(request.action == TRADE_ACTION_DEAL &&
               (trade_execution == SYMBOL_TRADE_EXECUTION_REQUEST ||
                trade_execution == SYMBOL_TRADE_EXECUTION_INSTANT ||
                trade_execution == SYMBOL_TRADE_EXECUTION_MARKET))
                str = StringFormat("done at %s", DoubleToString(result.price, digits));
            else
                str = "done";
            break;

        case TRADE_RETCODE_DONE_PARTIAL:
            if(request.action == TRADE_ACTION_DEAL &&
               (trade_execution == SYMBOL_TRADE_EXECUTION_REQUEST ||
                trade_execution == SYMBOL_TRADE_EXECUTION_INSTANT ||
                trade_execution == SYMBOL_TRADE_EXECUTION_MARKET))
                str = StringFormat("done partially %s at %s",
                                   DoubleToString(result.volume, 2),
                                   DoubleToString(result.price, digits));
            else
                str = StringFormat("done partially %s",
                                   DoubleToString(result.volume, 2));
            break;

        case TRADE_RETCODE_REJECT:
            str = "rejected";
            break;
        case TRADE_RETCODE_CANCEL:
            str = "canceled";
            break;
        case TRADE_RETCODE_PLACED:
            str = "placed";
            break;
        case TRADE_RETCODE_ERROR:
            str = "common error";
            break;
        case TRADE_RETCODE_TIMEOUT:
            str = "timeout";
            break;
        case TRADE_RETCODE_INVALID:
            str = "invalid request";
            break;
        case TRADE_RETCODE_INVALID_VOLUME:
            str = "invalid volume";
            break;
        case TRADE_RETCODE_INVALID_PRICE:
            str = "invalid price";
            break;
        case TRADE_RETCODE_INVALID_STOPS:
            str = "invalid stops";
            break;
        case TRADE_RETCODE_TRADE_DISABLED:
            str = "trade disabled";
            break;
        case TRADE_RETCODE_MARKET_CLOSED:
            str = "market closed";
            break;
        case TRADE_RETCODE_NO_MONEY:
            str = "not enough money";
            break;
        case TRADE_RETCODE_PRICE_CHANGED:
            str = "price changed";
            break;
        case TRADE_RETCODE_PRICE_OFF:
            str = "off quotes";
            break;
        case TRADE_RETCODE_INVALID_EXPIRATION:
            str = "invalid expiration";
            break;
        case TRADE_RETCODE_ORDER_CHANGED:
            str = "order changed";
            break;
        case TRADE_RETCODE_TOO_MANY_REQUESTS:
            str = "too many requests";
            break;
        case TRADE_RETCODE_NO_CHANGES:
            str = "no changes";
            break;
        case TRADE_RETCODE_SERVER_DISABLES_AT:
            str = "auto trading disabled by server";
            break;
        case TRADE_RETCODE_CLIENT_DISABLES_AT:
            str = "auto trading disabled by client";
            break;
        case TRADE_RETCODE_LOCKED:
            str = "locked";
            break;
        case TRADE_RETCODE_FROZEN:
            str = "frozen";
            break;
        case TRADE_RETCODE_INVALID_FILL:
            str = "invalid fill";
            break;
        case TRADE_RETCODE_CONNECTION:
            str = "no connection";
            break;
        case TRADE_RETCODE_ONLY_REAL:
            str = "only real";
            break;
        case TRADE_RETCODE_LIMIT_ORDERS:
            str = "limit orders";
            break;
        case TRADE_RETCODE_LIMIT_VOLUME:
            str = "limit volume";
            break;
        case TRADE_RETCODE_POSITION_CLOSED:
            str = "position closed";
            break;
        case TRADE_RETCODE_INVALID_ORDER:
            str = "invalid order";
            break;
        case TRADE_RETCODE_CLOSE_ORDER_EXIST:
            str = "close order already exists";
            break;
        case TRADE_RETCODE_LIMIT_POSITIONS:
            str = "limit positions";
            break;
        default:
            str = "unknown retcode " + (string)result.retcode;
       }

    return(str);
   }


//+------------------------------------------------------------------+
//| 正しい充填方法を使っているのかどうかの確認
//+------------------------------------------------------------------+
bool CTrading::FillingCheck(const string symbol)
   {
//--- その銘柄における約定の執行方法を取得
//--- REQUEST：基本的には使われない。「ブローカーに価格の提示を要請」→「ブローカーが応答」→「提示された価格で了承するかどうか決める」という3段階方式。
//--- INSTANT：諸々の情報を指定して注文を出す。もしもスリッページ値を超えてしまった場合は、価格の再提示（リクオート）がおこなわれる。
//--- MARKET：基本的に使われる。ある程度の流動性があれば、現在の価格で約定できる。価格の再提示は起こらない。
//--- EXCHANGE：NDD（ECN）。MARKET方式と似ている。現在の価格で約定できる。価格の再提示は起こらない。
    ENUM_SYMBOL_TRADE_EXECUTION exec = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(symbol, SYMBOL_TRADE_EXEMODE);

//--- REQUESTとINSTANTについては、注文方法によって、充填方法が固定される
//--- 成行注文ならFOK、指値注文ならRETURN（有効な数量を約定させて、残りはサーバー側で待機。最新の市場価格にて、随時 約定させていく）
    if(exec == SYMBOL_TRADE_EXECUTION_REQUEST || exec == SYMBOL_TRADE_EXECUTION_INSTANT)
       {
        return(true);
       }

//--- その銘柄で利用できる充填方法を取得
    uint filling = (uint)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);

//--- MARKET方式の場合
    if(exec == SYMBOL_TRADE_EXECUTION_MARKET)
       {
        if(m_request.action != TRADE_ACTION_PENDING)
           {
            //--- Fill or Kill（全数量の約定か、あるいは全棄却）
            if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
               {
                m_type_filling = ORDER_FILLING_FOK;
                m_request.type_filling = m_type_filling;
                return(true);
               }

            //--- Immediate or Cancel（有効な数量だけ約定させて、残りは棄却）
            if((filling & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
               {
                m_type_filling = ORDER_FILLING_IOC;
                m_request.type_filling = m_type_filling;
                return(true);
               }

            //--- 充填方法が想定外なので、エラーを発生
            m_result.retcode = TRADE_RETCODE_INVALID_FILL;
            return(false);
           }

        return(true);
       }

//--- EXCHANGE方式の場合
    switch(m_type_filling)
       {
        case ORDER_FILLING_FOK:
            if(m_request.action == TRADE_ACTION_PENDING)
               {
                //--- 指値の期限設定でエラーが生じたので、ひとまず「当日まで」を設定
                if(!ExpirationCheck(symbol))
                    m_request.type_time = ORDER_TIME_DAY;

                //--- 指値・逆指値の注文の場合は、充填方法はRETURNにする
                //--- 指値系は、即座に執行されることを期待しないので
                if(m_request.type == ORDER_TYPE_BUY_STOP || m_request.type == ORDER_TYPE_SELL_STOP ||
                   m_request.type == ORDER_TYPE_BUY_LIMIT || m_request.type == ORDER_TYPE_SELL_LIMIT)
                   {
                    m_request.type_filling = ORDER_FILLING_RETURN;
                    return(true);
                   }
               }

            //--- その銘柄にて、FOK方式が使えるなら、request構造体にfOKを設定
            if((filling & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
               {
                m_request.type_filling = m_type_filling;
                return(true);
               }

            //--- その銘柄では取り扱えない充填方式の場合は、エラーを発生
            m_result.retcode = TRADE_RETCODE_INVALID_FILL;
            return(false);

        case ORDER_FILLING_IOC:
            if(m_request.action == TRADE_ACTION_PENDING)
               {
                if(!ExpirationCheck(symbol))
                    m_request.type_time = ORDER_TIME_DAY;
                if(m_request.type == ORDER_TYPE_BUY_STOP || m_request.type == ORDER_TYPE_SELL_STOP ||
                   m_request.type == ORDER_TYPE_BUY_LIMIT || m_request.type == ORDER_TYPE_SELL_LIMIT)
                   {
                    m_request.type_filling = ORDER_FILLING_RETURN;
                    return(true);
                   }
               }

            if((filling & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
               {
                m_request.type_filling = m_type_filling;
                return(true);
               }

            m_result.retcode = TRADE_RETCODE_INVALID_FILL;
            return(false);

        case ORDER_FILLING_RETURN:
            m_request.type_filling = m_type_filling;
            return(true);
       }

//--- 未知の充填方法が設定されているんどえ、エラーを発生
    m_result.retcode = TRADE_RETCODE_ERROR;
    return(false);
   }




//+------------------------------------------------------------------+
//| その銘柄で設定できる期限種別を確認
//+------------------------------------------------------------------+
bool CTrading::ExpirationCheck(const string symbol)
   {
    string symbol_name = (symbol == NULL) ? _Symbol : symbol;

//--- その銘柄で利用できる期限種別を表すフラグ（2進数）を得る
    long tmp_long;
    int  flags = 0;
    if(SymbolInfoInteger(symbol_name, SYMBOL_EXPIRATION_MODE, tmp_long))
        flags = (int)tmp_long;

//--- request構造体のtype_timeが利用できるのか確認
    switch(m_request.type_time)
       {
        case ORDER_TIME_GTC:
            if((flags & SYMBOL_EXPIRATION_GTC) != 0)
                return(true);
            break;
        case ORDER_TIME_DAY:
            if((flags & SYMBOL_EXPIRATION_DAY) != 0)
                return(true);
            break;
        case ORDER_TIME_SPECIFIED:
            if((flags & SYMBOL_EXPIRATION_SPECIFIED) != 0)
                return(true);
            break;
        case ORDER_TIME_SPECIFIED_DAY:
            if((flags & SYMBOL_EXPIRATION_SPECIFIED_DAY) != 0)
                return(true);
            break;
        default:
            Print(__FUNCTION__ + ": 未知の期限種別");
       }

    return(false);
   }


//+------------------------------------------------------------------+
//| 構造体3種が保持する要素をゼロ値で初期化
//+------------------------------------------------------------------+
void CTrading::ClearStructures(void)
   {
    ZeroMemory(m_request);
    ZeroMemory(m_result);
    ZeroMemory(m_check_result);
   }


//+------------------------------------------------------------------+
//| IsStopped
//+------------------------------------------------------------------+
bool CTrading::IsStopped(const string function)
   {
    if(!::IsStopped())
        return(false);

    PrintFormat("%s: MQL5プログラムは停止しています。取引はおこなえません。", function);
    m_result.retcode = TRADE_RETCODE_CLIENT_DISABLES_AT;
    return(true);
   }

//+------------------------------------------------------------------+
//| その銘柄で利用可能な注文方法なのか確認する
//+------------------------------------------------------------------+
bool CTrading::OrderTypeCheck(const string symbol)
   {
    bool res = false;
    string symbol_name = (symbol == NULL) ? _Symbol : symbol;

//--- その銘柄で注文できる方法を表すフラグ（2進数）を得る
    long tmp_long;
    int  flags = 0;
    if(SymbolInfoInteger(symbol_name, SYMBOL_ORDER_MODE, tmp_long))
        flags = (int)tmp_long;

//--- 「フラグ」と「注文可能な種類を表す整数値」をビット比較
    switch(m_request.type)
       {
        case ORDER_TYPE_BUY:
        case ORDER_TYPE_SELL:
            res = ((flags & SYMBOL_ORDER_MARKET) != 0);
            break;
        case ORDER_TYPE_BUY_LIMIT:
        case ORDER_TYPE_SELL_LIMIT:
            res = ((flags & SYMBOL_ORDER_LIMIT) != 0);
            break;
        case ORDER_TYPE_BUY_STOP:
        case ORDER_TYPE_SELL_STOP:
            res = ((flags & SYMBOL_ORDER_STOP) != 0);
            break;
        case ORDER_TYPE_BUY_STOP_LIMIT:
        case ORDER_TYPE_SELL_STOP_LIMIT:
            res = ((flags & SYMBOL_ORDER_STOP_LIMIT) != 0);
            break;
       }

//--- 「注文方法」と「銘柄で利用できる注文方法」が一致する場合
    if(res)
       {
        //--- 損切り・利食いの値が0以外の場合は、その銘柄で損切り・利食いが利用可能か確認
        if(m_request.sl != 0.0 || m_request.tp != 0.0)
           {
            if((flags & SYMBOL_ORDER_SL) == 0)
                m_request.sl = 0.0;
            if((flags & SYMBOL_ORDER_TP) == 0)
                m_request.tp = 0.0;
           }
       }

//--- その銘柄に対して不適切な注文方法の場合は、エラー発生
    else
       {
        m_result.retcode = TRADE_RETCODE_INVALID_ORDER;
        Print(__FUNCTION__ + ": 無効な注文方法");
       }

    return(res);
   }




//+------------------------------------------------------------------+
//| オープンポジションを選択状態にする（売買方向は問わない）
//+------------------------------------------------------------------+
bool CTrading::SelectPosition(const string symbol)
   {
    bool res = false;

//--- ヘッジアカウントの場合は、銘柄・マジックナンバーの一致するポジションを選択
    if(IsHedging())
       {
        uint total = PositionsTotal();
        for(uint i = 0; i < total; i++)
           {
            string position_symbol = PositionGetSymbol(i);
            if(position_symbol == symbol && m_magic_number == PositionGetInteger(POSITION_MAGIC))
               {
                res = true;
                break;
               }
           }
       }
    else
        res = PositionSelect(symbol);

    return(res);
   }


//+------------------------------------------------------------------+
