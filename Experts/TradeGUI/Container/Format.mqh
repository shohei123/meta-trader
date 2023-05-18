//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "../Program.mqh"


//+------------------------------------------------------------------+
//| 注文を出す時に表示するダイアログの文言用
//+------------------------------------------------------------------+
string CProgram::FormatOrderDialogText(const string order_type, const string symbol, const double price, const double lot, const double sl, const double tp) {
    string formated_text = StringFormat(
                               "以下の内容で注文します。よろしいですか？" +
                               "\n\n" +
                               "注文種別：%s" +
                               "\n" +
                               "銘柄：%s" +
                               "\n" +
                               "価格：%.3f" +
                               "\n" +
                               "数量：%.2f" +
                               "\n" +
                               "損切り：%.3f" +
                               "\n" +
                               "利食い：%.3f",
                               order_type, symbol, price, lot, sl, tp
                           );

    return(formated_text);
}
//+------------------------------------------------------------------+
