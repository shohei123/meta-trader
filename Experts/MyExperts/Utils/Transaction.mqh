//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "../RunEA.mq5"


//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
bool CheckTransaction(
    const MqlTradeTransaction &trans,
    const MqlTradeRequest &request,
    const MqlTradeResult &result
) {
//--- get transaction type as enumeration value
    ENUM_TRADE_TRANSACTION_TYPE type = trans.type;
//--- if transaction is result of addition of the transaction in history
    if(type == TRADE_TRANSACTION_DEAL_ADD) {
        long     deal_ticket       = 0;
        long     deal_order        = 0;
        long     deal_time         = 0;
        long     deal_time_msc     = 0;
        long     deal_type         = -1;
        long     deal_entry        = -1;
        long     deal_magic        = 0;
        long     deal_reason       = -1;
        long     deal_position_id  = 0;
        double   deal_volume       = 0.0;
        double   deal_price        = 0.0;
        double   deal_commission   = 0.0;
        double   deal_swap         = 0.0;
        double   deal_profit       = 0.0;
        string   deal_symbol       = "";
        string   deal_comment      = "";
        string   deal_external_id  = "";
        if(HistoryDealSelect(trans.deal)) {
            deal_ticket       = HistoryDealGetInteger(trans.deal, DEAL_TICKET);
            deal_order        = HistoryDealGetInteger(trans.deal, DEAL_ORDER);
            deal_time         = HistoryDealGetInteger(trans.deal, DEAL_TIME);
            deal_time_msc     = HistoryDealGetInteger(trans.deal, DEAL_TIME_MSC);
            deal_type         = HistoryDealGetInteger(trans.deal, DEAL_TYPE);
            deal_entry        = HistoryDealGetInteger(trans.deal, DEAL_ENTRY);
            deal_magic        = HistoryDealGetInteger(trans.deal, DEAL_MAGIC);
            deal_reason       = HistoryDealGetInteger(trans.deal, DEAL_REASON);
            deal_position_id  = HistoryDealGetInteger(trans.deal, DEAL_POSITION_ID);

            deal_volume       = HistoryDealGetDouble(trans.deal, DEAL_VOLUME);
            deal_price        = HistoryDealGetDouble(trans.deal, DEAL_PRICE);
            deal_commission   = HistoryDealGetDouble(trans.deal, DEAL_COMMISSION);
            deal_swap         = HistoryDealGetDouble(trans.deal, DEAL_SWAP);
            deal_profit       = HistoryDealGetDouble(trans.deal, DEAL_PROFIT);

            deal_symbol       = HistoryDealGetString(trans.deal, DEAL_SYMBOL);
            deal_comment      = HistoryDealGetString(trans.deal, DEAL_COMMENT);
            deal_external_id  = HistoryDealGetString(trans.deal, DEAL_EXTERNAL_ID);
        } else
            return;

        if(deal_symbol == m_symbol.Name() && deal_magic == m_magic)
            if(deal_entry == DEAL_ENTRY_IN)
                if(deal_type == DEAL_TYPE_BUY || deal_type == DEAL_TYPE_SELL) {
                    if(m_waiting_transaction)
                        if(m_waiting_order_ticket == deal_order) {
                            Print(__FUNCTION__, " Transaction confirmed");
                            m_transaction_confirmed = true;
                        }
                }
    }
}
//+------------------------------------------------------------------+
