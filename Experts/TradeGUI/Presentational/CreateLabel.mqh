//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+

#include "../Program.mqh"

//+------------------------------------------------------------------+
//| CProgram::CreateFrameメソッドの定義
//+------------------------------------------------------------------+

bool CProgram::CreateLabel(CWindow &window,
                           CTextLabel &text_label,
                           const int x_size,
                           const int x_gap,
                           const int y_gap,
                           string label_text,
                           int w_number)
{

   // メインコントロールに対して参照を登録
   text_label.MainPointer(window);

   text_label.Font(m_base_font_name);
   text_label.FontSize(m_base_font_size);
   text_label.XSize(x_size);
   text_label.BackColor(m_background_color);
   text_label.IsCenterText(true);

   // 上記に基づいて、テキストラベルの作成
   if (!text_label.CreateTextLabel(label_text, x_gap, window.CaptionHeight() + y_gap))
      return (false);

   // コンテナー側の要素配列に、フレームを追加
   // w_numberは、テキストラベルに紐づけるウィンドウのインデックスを意味する
   CWndContainer::AddToElementsArray(w_number, text_label);

   return (true);
}
