//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+

#include "../Program.mqh"
#include "./CreateWindow.mqh"

//+------------------------------------------------------------------+
//| CreateGUIメソッドの定義
//+------------------------------------------------------------------+
bool CProgram::CreateGUI(void)
   {
// メインウィンドウの作成
    if(!CProgram::CreateMainWindow())
        return (false);

// 成行注文用のダイアログウィンドウの作成
    if(!CProgram::CreateMarketOrdersWindow())
        return (false);

// 指値のダイアログウィンドウの作成
    if(!CProgram::CreateLimitOrdersWindow())
        return (false);

// 逆指値のダイアログウィンドウの作成
    if(!CProgram::CreateStopOrdersWindow())
        return (false);

// GUI作成の実行についての処理
    CWndEvents::CompletedGUI();

    return (true);
   }
//+------------------------------------------------------------------+
