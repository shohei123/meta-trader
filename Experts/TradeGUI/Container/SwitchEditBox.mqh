//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+

#include "../Program.mqh"


//+------------------------------------------------------------------+
//| 数量の編集欄の更新
//+------------------------------------------------------------------+
void CProgram::SwitchLotEditBox(CButton &button, CTextEdit &edit) {
    if(button.IsPressed()) {
        edit.SetDigits(0);
        edit.StepValue(1);
        edit.MaxValue(100);
        edit.MinValue(1);
        edit.SetValue(string(2));
        edit.GetTextBoxPointer().Update(true);
    } else {
        edit.SetDigits(2);
        edit.StepValue(SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP));
        edit.MinValue(SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN));
        edit.MaxValue(SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX));
        edit.SetValue(string(1));
        edit.GetTextBoxPointer().Update(true);
    }
}


//+------------------------------------------------------------------+
//| 損切りの編集欄の更新
//+------------------------------------------------------------------+
void CProgram::SwitchStopLossEditBox(CButton &button, CTextEdit &edit) {
// 「Price」の場合（絶対指定）
    if(button.IsPressed()) {
        // SymbolInfoTick関数に銘柄とtick構造体を渡す
        // tick構造体に正しくtick情報が格納されたら、trueが返却される
        MqlTick tick;
        if(SymbolInfoTick(Symbol(), tick)) {
            edit.SetDigits(_Digits);
            edit.StepValue(_Point);
            edit.SetValue(string(tick.ask));
            edit.GetTextBoxPointer().Update(true);
        }
    }
// 「Pips」の場合（相対指定）
    else {
        edit.SetDigits(0);
        edit.StepValue(1);
        edit.SetValue("100");
        edit.GetTextBoxPointer().Update(true);
    }
}



//+------------------------------------------------------------------+
//| 利食いの編集欄の更新
//+------------------------------------------------------------------+
void CProgram::SwitchTakeProfitEditBox(CButton &button, CTextEdit &edit) {
// 「Price」の場合（絶対指定）
    if(button.IsPressed()) {
        // SymbolInfoTick関数に銘柄とtick構造体を渡す
        // tick構造体に正しくtick情報が格納されたら、trueが返却される
        MqlTick tick;
        if(SymbolInfoTick(Symbol(), tick)) {
            edit.SetDigits(_Digits);
            edit.StepValue(_Point);
            edit.SetValue(string(tick.ask));
            edit.GetTextBoxPointer().Update(true);
        }
    }
// 「Pips」の場合（相対指定）
    else {
        edit.SetDigits(0);
        edit.StepValue(1);
        edit.SetValue("100");
        edit.GetTextBoxPointer().Update(true);
    }
}

//+------------------------------------------------------------------+
