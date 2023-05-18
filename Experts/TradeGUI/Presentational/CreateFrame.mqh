//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+

#include "../Program.mqh"

//+------------------------------------------------------------------+
//| CProgram::CreateFrameメソッドの定義
//+------------------------------------------------------------------+
bool CProgram::CreateFrame(CWindow &window,
                           CFrame &frame,
                           string caption,
                           color color_main,
                           const int frame_offset,
                           const int frame_height,
                           const int frane_label_width,
                           const int frame_label_height,
                           const int x_gap,
                           const int y_gap,
                           int w_number)
   {

// メインコントロールに対して参照を登録


    frame.MainPointer(window);
    frame.YSize(frame_height);
    frame.BorderColor(color_main);
    frame.BackColor(m_background_color);
    frame.Font(m_base_font_name);
    frame.FontSize(m_base_font_size);
    frame.AutoXResizeMode(true);
    frame.AutoXResizeRightOffset(frame_offset);

    frame.GetTextLabelPointer().LabelColor(color_main);
    frame.GetTextLabelPointer().BackColor(m_background_color);
    frame.GetTextLabelPointer().XSize(frane_label_width);
    frame.GetTextLabelPointer().YSize(frame_label_height);
    
// 上記に基づいて、フレームの作成
    if(!frame.CreateFrame(caption, x_gap, window.CaptionHeight() + y_gap))
        return (false);

// コンテナー側の要素配列に、フレームを追加
// w_numberは、フレームに紐づけるウィンドウのインデックスを意味する
    CWndContainer::AddToElementsArray(w_number, frame);
    return (true);
   }
//+------------------------------------------------------------------+
