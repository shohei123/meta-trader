//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "../RunEA.mq5"


//+------------------------------------------------------------------+
//| Trading側の発注イベントの出力
//+------------------------------------------------------------------+
void PrintResultTrade(void) {
    Print("ファイル：", __FILE__, ", 銘柄： ", ins_symbol.GetName());
    Print("リターンコード：" + IntegerToString(ins_trading.GetResultRetCode()));
    Print("リターンコードの説明:" + ins_trading.GetResultRetCodeDescription());
    Print("約定チケット：" + IntegerToString(ins_trading.GetResultDeal()));
    Print("注文チケット：" + IntegerToString(ins_trading.GetResultOrder()));
    Print("取引量：" + DoubleToString(ins_trading.GetResultVolume(), 2));
    Print("ブロ―カーによる注文価格：" + DoubleToString(ins_trading.GetResultPrice(), ins_symbol.GetDigits()));
    Print("現在のBid：" + DoubleToString(ins_symbol.GetBid(), ins_symbol.GetDigits()) + " (the requote)：" + DoubleToString(ins_trading.GetResultBid(), ins_symbol.GetDigits()));
    Print("現在のAsk：" + DoubleToString(ins_symbol.GetAsk(), ins_symbol.GetDigits()) + " (the requote)：" + DoubleToString(ins_trading.GetResultAsk(), ins_symbol.GetDigits()));
    Print("ブロ―カーによるコメント：" + ins_trading.GetResultComment());
    Print("フリーズレベル：" + DoubleToString(ins_symbol.GetFreezeLevel(), 0), ", ストップレベル：" + DoubleToString(ins_symbol.GetStopsLevel(), 0));
}


//+------------------------------------------------------------------+
//| Trading側の修正イベントの出力
//+------------------------------------------------------------------+
void PrintResultModify(void) {
    Print("ファイル：", __FILE__, ", 銘柄： ", ins_symbol.GetName());
    Print("リターンコード：" + IntegerToString(ins_trading.GetResultRetCode()));
    Print("リターンコードの説明:" + ins_trading.GetResultRetCodeDescription());
    Print("約定チケット：" + IntegerToString(ins_trading.GetResultDeal()));
    Print("注文チケット：" + IntegerToString(ins_trading.GetResultOrder()));
    Print("取引量：" + DoubleToString(ins_trading.GetResultVolume(), 2));
    Print("ブロ―カーによる注文価格：" + DoubleToString(ins_trading.GetResultPrice(), ins_symbol.GetDigits()));
    Print("現在のBid：" + DoubleToString(ins_symbol.GetBid(), ins_symbol.GetDigits()) + " (the requote)：" + DoubleToString(ins_trading.GetResultBid(), ins_symbol.GetDigits()));
    Print("現在のAsk：" + DoubleToString(ins_symbol.GetAsk(), ins_symbol.GetDigits()) + " (the requote)：" + DoubleToString(ins_trading.GetResultAsk(), ins_symbol.GetDigits()));
    Print("ブロ―カーによるコメント：" + ins_trading.GetResultComment());
    Print("フリーズレベル：" + DoubleToString(ins_symbol.GetFreezeLevel(), 0), ", ストップレベル：" + DoubleToString(ins_symbol.GetStopsLevel(), 0));
    Print("ポジションの約定価格：" + DoubleToString(ins_position.GetPriceOpen(), ins_symbol.GetDigits()));
    Print("ポジションの損切り価格：" + DoubleToString(ins_position.GetStopLoss(), ins_symbol.GetDigits()));
    Print("ポジションの利食い価格：" + DoubleToString(ins_position.GetTakeProfit(), ins_symbol.GetDigits()));
    Print("ポジションの銘柄の現在価格：" + DoubleToString(ins_position.GetPriceCurrent(), ins_symbol.GetDigits()));
}


//+------------------------------------------------------------------+
