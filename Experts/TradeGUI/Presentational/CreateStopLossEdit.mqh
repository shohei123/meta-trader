//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+

#include "../Program.mqh"

//+------------------------------------------------------------------+
//| CProgram::CreateFrameメソッドの定義
//+------------------------------------------------------------------+

bool CProgram::CreateStopLossEdit(CWindow &window,
                           CTextEdit  &text_edit,
                           const int x_size,
                           const int y_size,
                           const int x_gap,
                           const int y_gap,
                           string init_text,
                           int w_number)
{

   // メインコントロールに対して参照を登録
   text_edit.MainPointer(window);

   text_edit.XSize(x_size);
   text_edit.YSize(y_size);
   text_edit.Font(m_base_font_name);
   text_edit.FontSize(m_base_font_size);
   text_edit.MaxValue(9999);
   text_edit.StepValue(1);
   text_edit.MinValue(0);
   text_edit.SpinEditMode(true);
   text_edit.GetTextBoxPointer().XGap(1);
   text_edit.GetTextBoxPointer().XSize(x_size);

   // 上記に基づいて、テキストエディットの作成
   if (!text_edit.CreateTextEdit("", x_gap, window.CaptionHeight() + y_gap))
      return (false);
   text_edit.SetValue(string(init_text));

   // コンテナー側の要素配列に、フレームを追加
   // w_numberは、テキストラベルに紐づけるウィンドウのインデックスを意味する
   CWndContainer::AddToElementsArray(w_number, text_edit);

   return (true);
}
