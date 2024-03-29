//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+

#include "../Program.mqh"

//+------------------------------------------------------------------+
//| スイッチボタンのテキストの更新
//+------------------------------------------------------------------+
void CProgram::SwitchButtonText(CButton &button, string state1, string state2) {
    if (!button.IsPressed())
        SetButtonParam(button, state1);
    else
        SetButtonParam(button, state2);
}
//+------------------------------------------------------------------+
