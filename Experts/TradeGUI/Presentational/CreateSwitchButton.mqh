//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+

#include "../Program.mqh"

//+------------------------------------------------------------------+
//| CProgram::CreateButtonメソッドの定義
//+------------------------------------------------------------------+

bool CProgram::CreateSwitchButton(CWindow &window,
                            CButton &button,
                            string text,
                            const int font_base_size,
                            const string font_base_name,
                            color base_color,
                            color pressed_color,
                            const int x_size,
                            const int y_size,
                            int x_gap,
                            int y_gap,
                            int w_number)
{
   // ボタン要素に対してウィンドウ参照を登録
   button.MainPointer(window);

   //--- Set properties before creation
   button.XSize(x_size);
   button.YSize(y_size);
   button.FontSize(font_base_size);
   button.Font(font_base_name);
   button.BackColor(base_color);
   button.BackColorHover(base_color);
   button.BackColorPressed(pressed_color);
   button.BorderColor(base_color);
   button.BorderColorHover(base_color);
   button.BorderColorPressed(pressed_color);
   button.LabelColor(clrWhite);
   button.LabelColorPressed(clrWhite);
   button.LabelColorHover(clrWhite);
   button.IsCenterText(true);
   button.TwoState(true);

   // 上記に基づいてボタン要素を作成
   // ラベルテキストと座標を渡す
   if (!button.CreateButton(text, x_gap, window.CaptionHeight() + y_gap))
      return (false);

   // コンテナーにボタン要素のポインタを追加
   CWndContainer::AddToElementsArray(w_number, button);
   return (true);
}