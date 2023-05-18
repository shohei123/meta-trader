//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "../RunEA.mq5"


//+------------------------------------------------------------------+
//| 建玉に対するトレーリングストップの適用
//+------------------------------------------------------------------+
void Trailing(const double stop_level) {

    /*
         Buying is done at the Ask price               |  Selling is done at the Bid price
       ------------------------------------------------|----------------------------------
       TakeProfit        >= Bid                        |  TakeProfit        <= Ask
       StopLoss          <= Bid                        |  StopLoss          >= Ask
       TakeProfit - Bid  >= SYMBOL_TRADE_STOPS_LEVEL   |  Ask - TakeProfit  >= SYMBOL_TRADE_STOPS_LEVEL
       Bid - StopLoss    >= SYMBOL_TRADE_STOPS_LEVEL   |  StopLoss - Ask    >= SYMBOL_TRADE_STOPS_LEVEL
    */

//--- トレーリングストップを使わない場合
    if(input_trailing_stop == 0)
        return;

//--- トレーリングストップがストップレベルよりも小さい場合
    if(adjusted_trailing_stop < stop_level)
        return;

//--- トレーリングストップを使う場合
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(ins_position.SelectByIndex(i)) {
            if(ins_position.GetSymbol() == ins_symbol.GetName() && ins_position.GetMagicNumber() == input_magic_number) {
                //--- 買い建玉の場合
                if(ins_position.GetPositionType() == POSITION_TYPE_BUY) {
                    //--- トレーリングストップを実行する場合
                    if(ins_position.GetPriceCurrent() - ins_position.GetStopLoss() > adjusted_trailing_stop + adjusted_trailing_step) {
                        //--- 約定注文の修正
                        if(!ins_trading.PositionModifyByTicket(ins_position.GetTicket(), ins_symbol.NormalizePrice(ins_position.GetPriceCurrent() - adjusted_trailing_stop), ins_position.GetTakeProfit())) {
                            //--- 修正失敗時のエラー出力
                            if(input_print_log) {
                                Print(
                                    "修正対象のチケット：", ins_position.GetTicket(),
                                    "　リターンコード：", ins_trading.GetResultRetCode(),
                                    "　リターンコードの説明：", ins_trading.GetResultRetCodeDescription()
                                );
                            }
                            //---
                            else {
                                return;
                            }
                        }

                        //--- 修正成功時の出力
                        else {
                            RefreshRates();
                            ins_position.SelectByIndex(i);
                            if(input_print_log)
                                PrintResultModify();
                            continue;

                        }
                    }
                } //--- ins_position.GetPositionType() == POSITION_TYPE_BUY

                //--- 売り建玉の場合
                else {
                    //--- トレーリングストップを実行する場合
                    if(ins_position.GetStopLoss() - ins_position.GetPriceCurrent() > adjusted_trailing_stop + adjusted_trailing_step) {
                        //--- 約定注文の修正
                        if(!ins_trading.PositionModifyByTicket(ins_position.GetTicket(), ins_symbol.NormalizePrice(ins_position.GetPriceCurrent() + adjusted_trailing_stop), ins_position.GetTakeProfit())) {
                        //--- 修正失敗時のエラー出力
                        if(input_print_log) {
                                Print(
                                    "修正対象のチケット：", ins_position.GetTicket(),
                                    "　リターンコード：", ins_trading.GetResultRetCode(),
                                    "　リターンコードの説明：", ins_trading.GetResultRetCodeDescription()
                                );
                            }
                            //---
                            else {
                                return;
                            }
                        }

                        //--- 修正成功時の出力
                        else {
                            RefreshRates();
                            ins_position.SelectByIndex(i);
                            if(input_print_log)
                                PrintResultModify();
                        }
                    }
                }
            } //--- ins_position.GetSymbol() == ins_symbol.GetName() && ins_position.GetMagicNumber() == input_magic_number
        } //--- ins_position.SelectByIndex(i)
    } //--- for
} //---Trailing

//+------------------------------------------------------------------+
