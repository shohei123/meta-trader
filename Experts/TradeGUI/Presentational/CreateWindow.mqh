//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "../Program.mqh"
#include "./CreateButton.mqh"
#include "./CreateSwitchButton.mqh"
#include "./CreateFrame.mqh"
#include "./CreateLabel.mqh"
#include "./CreatePriceEdit.mqh"
#include "./CreateLotEdit.mqh"
#include "./CreateTakeProfitEdit.mqh"
#include "./CreateStopLossEdit.mqh"


//+------------------------------------------------------------------+
//| グローバル変数
//+------------------------------------------------------------------+
int caption_height = 32;
int window_pad = 20;
int frame_pad = 20;
int frame_margin_bottom = 40;
int label_height = 30;
int switch_btn_height = 30;
int edit_box_height = 30;
int action_box_width = 150;
int action_box_gap_x = 20;
int action_box_gap_y = 10;
int action_box_height = label_height + switch_btn_height + edit_box_height + (action_box_gap_y * 2);
int order_btn_width = 200;
int order_btn_height = 60;
int order_btn_margin_left = 40;


//+------------------------------------------------------------------+
//| CProgram::CreateWindowメソッドの定義
//+------------------------------------------------------------------+
bool CProgram::CreateMainWindow() {
// 変数の定義
    int button_width = 300;
    int button_height = 60;
    int button_gap = 20;

    int btn_market_order_x_pos = window_pad;
    int btn_market_order_y_pos = window_pad;
    int btn_limit_order_x_pos = btn_market_order_x_pos + button_width + button_gap;
    int btn_limit_order_y_pos = btn_market_order_x_pos;
    int btn_profit_all_settlement_x_pos = btn_market_order_x_pos;
    int btn_profit_all_settlement_y_pos = btn_market_order_y_pos + button_height + button_gap;
    int btn_stop_order_x_pos = btn_limit_order_x_pos;
    int btn_stop_order_y_pos = btn_profit_all_settlement_y_pos;
    int btn_loss_all_settlement_x_pos = btn_market_order_x_pos;
    int btn_loss_all_settlement_y_pos = btn_stop_order_y_pos + button_height + button_gap;
    int btn_unsettled_all_remove_x_pos = btn_limit_order_x_pos;
    int btn_unsettled_all_remove_y_pos = btn_loss_all_settlement_y_pos;

    int window_width = (window_pad * 2) + (button_width * 2) + button_gap;
    int window_height = caption_height + (window_pad * 2) + (button_height * 3) + (button_gap * 2);
    int x_pos = 5;
    int y_pos = 20;

// コンテナー側にあるウィンドウ配列にウィンドウ参照を追加
    CWndContainer::AddWindow(m_main_window);

// ウィンドウに座標
    int _x_pos = (m_main_window.X() > x_pos) ? m_main_window.X() : x_pos;
    int _y_pos = (m_main_window.Y() > y_pos) ? m_main_window.Y() : y_pos;

// ウィンドウの大きさ
    m_main_window.XSize(window_width);
    m_main_window.YSize(window_height);

// ウィンドウの文字の大きさ
    m_main_window.FontSize(m_base_font_size);

// ウィンドウの文字の書体
    m_main_window.Font(m_base_font_name);

// 見出し（caption）の高さ
    m_main_window.CaptionHeight(caption_height);

// 見出し（caption）の色
    m_main_window.CaptionColor(m_caption_color);
    m_main_window.CaptionColorLocked(m_caption_color);
    m_main_window.CaptionColorHover(m_caption_color);

// ウィンドウの移動許可
    m_main_window.IsMovable(true);

// ヘッダーのボタン
    m_main_window.CloseButtonIsUsed(true);
    m_main_window.CollapseButtonIsUsed(true);
    m_main_window.TooltipsButtonIsUsed(true);
    m_main_window.FullscreenButtonIsUsed(true);
    m_main_window.TransparentOnlyCaption(false);

// ツールチップの定義
    m_main_window.GetCloseButtonPointer().Tooltip("閉じる");
    m_main_window.GetTooltipButtonPointer().Tooltip("ツールチップ");
    m_main_window.GetFullscreenButtonPointer().Tooltip("フルスクリーン化");
    m_main_window.GetCollapseButtonPointer().Tooltip("折りたたみ/展開");

// 上記に基づいて、ウィンドウの作成
// 「m_chart_id」と「m_subwin」は、「CWndEventsクラス」で定義されているメンバ
    if(!m_main_window.CreateWindow(m_chart_id, m_subwin, "Main Window", _x_pos, _y_pos))
        return (false);

    if(!CreateButton(m_main_window, m_main_window_market_order_button, "成行の注文 [M]", m_base_font_size, m_base_font_name, clrRoyalBlue, button_width, button_height, btn_market_order_x_pos, btn_market_order_y_pos, 0))
        return (false);
    if(!CreateButton(m_main_window, m_main_window_limit_order_button, "指値の注文 [L]", m_base_font_size, m_base_font_name, clrForestGreen, button_width, button_height, btn_limit_order_x_pos, btn_limit_order_y_pos, 0))
        return (false);
    if(!CreateButton(m_main_window, m_main_window_profit_all_settlement_button, "約定注文(含み益)の全決済 [P]", m_base_font_size, m_base_font_name, clrRoyalBlue, button_width, button_height, btn_profit_all_settlement_x_pos, btn_profit_all_settlement_y_pos, 0))
        return (false);
    if(!CreateButton(m_main_window, m_main_window_stop_order_button, "逆指値の注文 [S]", m_base_font_size, m_base_font_name, clrForestGreen, button_width, button_height, btn_stop_order_x_pos, btn_stop_order_y_pos, 0))
        return (false);
    if(!CreateButton(m_main_window, m_main_window_loss_all_settlement_button, "約定注文(含み損)の全決済 [D]", m_base_font_size, m_base_font_name, clrRoyalBlue, button_width, button_height, btn_loss_all_settlement_x_pos, btn_loss_all_settlement_y_pos, 0))
        return (false);
    if(!CreateButton(m_main_window, m_main_window_unsettled_remove_button, "未約定注文の全取消 [R]", m_base_font_size, m_base_font_name, clrForestGreen, button_width, button_height, btn_unsettled_all_remove_x_pos, btn_unsettled_all_remove_y_pos, 0))
        return (false);

    return (true);
}


//+------------------------------------------------------------------+
//| 成行注文のダイアログウィンドウの作成
//+------------------------------------------------------------------+
bool CProgram::CreateMarketOrdersWindow() {
// 変数の定義
    int frame_label_width = 100;
    int frame_label_height = 40;
    int frame_buy_x_pos = window_pad;
    int frame_buy_y_pos = window_pad;


    int label_buy_lot_x_pos = frame_buy_x_pos + frame_pad;
    int label_buy_lot_y_pos = frame_buy_y_pos + frame_pad;

    int label_buy_tp_x_pos = label_buy_lot_x_pos + action_box_width + action_box_gap_x;
    int label_buy_tp_y_pos = label_buy_lot_y_pos;
    int label_buy_sl_x_pos = label_buy_tp_x_pos + action_box_width + action_box_gap_x;
    int label_buy_sl_y_pos = label_buy_lot_y_pos;

    int switch_btn_buy_lot_x_pos = label_buy_lot_x_pos;
    int switch_btn_buy_lot_y_pos = label_buy_lot_y_pos + label_height + action_box_gap_y;
    int switch_btn_buy_tp_x_pos = switch_btn_buy_lot_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_buy_tp_y_pos = switch_btn_buy_lot_y_pos;
    int switch_btn_buy_sl_x_pos = switch_btn_buy_tp_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_buy_sl_y_pos = switch_btn_buy_lot_y_pos;

    int edit_box_buy_lot_x_pos = label_buy_lot_x_pos;
    int edit_box_buy_lot_y_pos = switch_btn_buy_lot_y_pos + switch_btn_height + action_box_gap_y;
    int edit_box_buy_tp_x_pos = edit_box_buy_lot_x_pos + action_box_width + action_box_gap_x;
    int edit_box_buy_tp_y_pos = edit_box_buy_lot_y_pos;
    int edit_box_buy_sl_x_pos = edit_box_buy_tp_x_pos + action_box_width + action_box_gap_x;
    int edit_box_buy_sl_y_pos = edit_box_buy_lot_y_pos;

    int order_btn_buy_x_pos = label_buy_sl_x_pos + action_box_width + order_btn_margin_left;
    int order_btn_buy_y_pos = label_buy_sl_y_pos + label_height + action_box_gap_y;

    int frame_width = (action_box_width * 3) + (action_box_gap_x * 2) + order_btn_margin_left + order_btn_width + (frame_pad * 2);
    int frame_height = action_box_height + (frame_pad * 2);
    int frame_sell_x_pos = window_pad;
    int frame_sell_y_pos = frame_buy_y_pos + frame_height + frame_margin_bottom;

    int label_sell_lot_x_pos = frame_sell_x_pos + frame_pad;
    int label_sell_lot_y_pos = frame_sell_y_pos + frame_pad;
    int label_sell_tp_x_pos = label_sell_lot_x_pos + action_box_width + action_box_gap_x;
    int label_sell_tp_y_pos = label_sell_lot_y_pos;
    int label_sell_sl_x_pos = label_sell_tp_x_pos + action_box_width + action_box_gap_x;
    int label_sell_sl_y_pos = label_sell_lot_y_pos;

    int switch_btn_sell_lot_x_pos = label_sell_lot_x_pos;
    int switch_btn_sell_lot_y_pos = label_sell_lot_y_pos + label_height + action_box_gap_y;
    int switch_btn_sell_tp_x_pos = switch_btn_sell_lot_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_sell_tp_y_pos = switch_btn_sell_lot_y_pos;
    int switch_btn_sell_sl_x_pos = switch_btn_sell_tp_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_sell_sl_y_pos = switch_btn_sell_lot_y_pos;

    int edit_box_sell_lot_x_pos = label_sell_lot_x_pos;
    int edit_box_sell_lot_y_pos = switch_btn_sell_lot_y_pos + switch_btn_height + action_box_gap_y;
    int edit_box_sell_tp_x_pos = edit_box_sell_lot_x_pos + action_box_width + action_box_gap_x;
    int edit_box_sell_tp_y_pos = edit_box_sell_lot_y_pos;
    int edit_box_sell_sl_x_pos = edit_box_sell_tp_x_pos + action_box_width + action_box_gap_x;
    int edit_box_sell_sl_y_pos = edit_box_sell_lot_y_pos;

    int order_btn_sell_x_pos = label_sell_sl_x_pos + action_box_width + order_btn_margin_left;
    int order_btn_sell_y_pos = label_sell_sl_y_pos + label_height + action_box_gap_y;

    int window_width = frame_width + (window_pad * 2);
    int window_height = caption_height + (window_pad * 2) + (frame_height * 2) + frame_margin_bottom;
    int x_pos = m_main_window_market_order_button.XGap() + 50;
    int y_pos = m_main_window_market_order_button.YGap() + 50;

// コンテナー側にあるウィンドウ配列にウィンドウ参照を追加
    CWndContainer::AddWindow(m_market_order_window);

// ウィンドウに座標
    int _x_pos = (m_market_order_window.X() > x_pos) ? m_market_order_window.X() : x_pos;
    int _y_pos = (m_market_order_window.Y() > y_pos) ? m_market_order_window.Y() : y_pos;

// ウィンドウの大きさ
    m_market_order_window.XSize(window_width);
    m_market_order_window.YSize(window_height);

// ウィンドウの色
    m_market_order_window.BackColor(m_background_color);
    m_market_order_window.BorderColor(clrRoyalBlue);

// ウィンドウの文字の大きさ
    m_market_order_window.FontSize(m_base_font_size);

// ウィンドウの文字の書体
    m_market_order_window.Font(m_base_font_name);

// ウィンドウの移動許可
    m_market_order_window.IsMovable(true);

// ウィンドウの種類
    m_market_order_window.WindowType(W_DIALOG);

// 見出し（caption）の高さ
    m_market_order_window.CaptionHeight(caption_height);

// 見出し（caption）の色
    m_market_order_window.CaptionColor(clrRoyalBlue);
    m_market_order_window.CaptionColorLocked(clrRoyalBlue);
    m_market_order_window.CaptionColorHover(clrRoyalBlue);

// ヘッダーのボタン
    m_market_order_window.CloseButtonIsUsed(true);
    m_market_order_window.CollapseButtonIsUsed(true);
    m_market_order_window.TooltipsButtonIsUsed(true);
    m_market_order_window.FullscreenButtonIsUsed(true);
    m_market_order_window.TransparentOnlyCaption(false);

// ツールチップの定義
    m_market_order_window.GetCloseButtonPointer().Tooltip("閉じる");
    m_market_order_window.GetTooltipButtonPointer().Tooltip("ツールチップ");
    m_market_order_window.GetFullscreenButtonPointer().Tooltip("フルスクリーン化");
    m_market_order_window.GetCollapseButtonPointer().Tooltip("折りたたみ/展開");

// 上記に基づいて、ウィンドウの作成
// 「m_chart_id」と「m_subwin」は、「CWndEventsクラス」で定義されているメンバ
    if(!m_market_order_window.CreateWindow(m_chart_id, m_subwin, "成行注文", _x_pos, _y_pos))
        return (false);

// 買い注文用のフレームを作成
    if(!CreateFrame(m_market_order_window, m_market_order_buy_frame, "Buy Order", clrForestGreen, window_pad, frame_height, frame_label_width, frame_label_height, frame_buy_x_pos, frame_buy_y_pos, 1))
        return (false);

// 買い注文用のラベルテキストの作成
    if(!CreateLabel(m_market_order_window, m_market_order_labels[0], action_box_width, label_buy_lot_x_pos, label_buy_lot_y_pos, "Lot", 1))
        return (false);

    if(!CreateLabel(m_market_order_window, m_market_order_labels[1], action_box_width, label_buy_tp_x_pos, label_buy_tp_y_pos, "Take Profit", 1))
        return (false);

    if(!CreateLabel(m_market_order_window, m_market_order_labels[2], action_box_width, label_buy_sl_x_pos, label_buy_sl_y_pos, "Stop Loss", 1))
        return (false);

// 買い注文用のトグルボタンの作成
    if(!CreateSwitchButton(m_market_order_window, m_market_order_switch_buttons[0], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_buy_lot_x_pos, switch_btn_buy_lot_y_pos, 1))
        return (false);

    if(!CreateSwitchButton(m_market_order_window, m_market_order_switch_buttons[1], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_buy_tp_x_pos, switch_btn_buy_tp_y_pos, 1))
        return (false);

    if(!CreateSwitchButton(m_market_order_window, m_market_order_switch_buttons[2], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_buy_sl_x_pos, switch_btn_buy_sl_y_pos, 1))
        return (false);

// 入力欄
    if(!CreateLotEdit(m_market_order_window, m_market_order_lot_edits[0], action_box_width, edit_box_height, edit_box_buy_lot_x_pos, edit_box_buy_lot_y_pos, "1.0", 1))
        return (false);

    if(!CreateTakeProfitEdit(m_market_order_window, m_market_order_tp_edits[0], action_box_width, edit_box_height, edit_box_buy_tp_x_pos, edit_box_buy_tp_y_pos, "100", 1))
        return (false);

    if(!CreateStopLossEdit(m_market_order_window, m_market_order_sl_edits[0], action_box_width, edit_box_height, edit_box_buy_sl_x_pos, edit_box_buy_sl_y_pos, "100", 1))
        return (false);

// 買い注文のボタン
    if(!CreateButton(m_market_order_window, m_market_order_buy_button, "Buy Order", m_base_font_size, m_base_font_name, clrForestGreen, order_btn_width, order_btn_height, order_btn_buy_x_pos, order_btn_buy_y_pos, 1))
        return (false);

// 売り注文用のフレームを作成
    if(!CreateFrame(m_market_order_window, m_market_order_sell_frame, "Sell Order", clrOrangeRed, window_pad, frame_height, frame_label_width, frame_label_height, frame_sell_x_pos, frame_sell_y_pos, 1))
        return (false);

// 売り注文用のラベルテキストの作成
    if(!CreateLabel(m_market_order_window, m_market_order_labels[3], action_box_width, label_sell_lot_x_pos, label_sell_lot_y_pos, "Lot", 1))
        return (false);

    if(!CreateLabel(m_market_order_window, m_market_order_labels[4], action_box_width, label_sell_tp_x_pos, label_sell_tp_y_pos, "Take Profit", 1))
        return (false);

    if(!CreateLabel(m_market_order_window, m_market_order_labels[5], action_box_width, label_sell_sl_x_pos, label_sell_sl_y_pos, "Stop Loss", 1))
        return (false);

// 売り注文用のトグルボタンの作成
    if(!CreateSwitchButton(m_market_order_window, m_market_order_switch_buttons[3], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_sell_lot_x_pos, switch_btn_sell_lot_y_pos, 1))
        return (false);

    if(!CreateSwitchButton(m_market_order_window, m_market_order_switch_buttons[4], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_sell_tp_x_pos, switch_btn_sell_tp_y_pos, 1))
        return (false);

    if(!CreateSwitchButton(m_market_order_window, m_market_order_switch_buttons[5], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_sell_sl_x_pos, switch_btn_sell_sl_y_pos, 1))
        return (false);

// 入力欄
    if(!CreateLotEdit(m_market_order_window, m_market_order_lot_edits[1], action_box_width, edit_box_height, edit_box_sell_lot_x_pos, edit_box_sell_lot_y_pos, "1.0", 1))
        return (false);

    if(!CreateTakeProfitEdit(m_market_order_window, m_market_order_tp_edits[1], action_box_width, edit_box_height, edit_box_sell_tp_x_pos, edit_box_sell_tp_y_pos, "100", 1))
        return (false);

    if(!CreateStopLossEdit(m_market_order_window, m_market_order_sl_edits[1], action_box_width, edit_box_height, edit_box_sell_sl_x_pos, edit_box_sell_sl_y_pos, "100", 1))
        return (false);

// 売り注文のボタン
    if(!CreateButton(m_market_order_window, m_market_order_sell_button, "Sell Order", m_base_font_size, m_base_font_name, clrOrangeRed, order_btn_width, order_btn_height, order_btn_sell_x_pos, order_btn_sell_y_pos, 1))
        return (false);

    return (true);
}

//+------------------------------------------------------------------+
//| 指値注文のダイアログウィンドウの作成
//+------------------------------------------------------------------+
bool CProgram::CreateLimitOrdersWindow() {
// 共通の変数
    int frame_label_width = 150;
    int frame_label_height = 40;

//--- 買い指値注文に関する変数
    int frame_buy_limit_x_pos = window_pad;
    int frame_buy_limit_y_pos = window_pad;

    int label_buy_limit_lot_x_pos = frame_buy_limit_x_pos + frame_pad + action_box_width + action_box_gap_x;
    int label_buy_limit_lot_y_pos = frame_buy_limit_y_pos + frame_pad;
    int label_buy_limit_tp_x_pos = label_buy_limit_lot_x_pos + action_box_width + action_box_gap_x;
    int label_buy_limit_tp_y_pos = label_buy_limit_lot_y_pos;
    int label_buy_limit_sl_x_pos = label_buy_limit_tp_x_pos + action_box_width + action_box_gap_x;
    int label_buy_limit_sl_y_pos = label_buy_limit_lot_y_pos;
    int label_buy_limit_price_x_pos = frame_buy_limit_x_pos + frame_pad;
    int label_buy_limit_price_y_pos = label_buy_limit_lot_y_pos + label_height + action_box_gap_y;

    int switch_btn_buy_limit_lot_x_pos = label_buy_limit_lot_x_pos;
    int switch_btn_buy_limit_lot_y_pos = label_buy_limit_price_y_pos;
    int switch_btn_buy_limit_tp_x_pos = switch_btn_buy_limit_lot_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_buy_limit_tp_y_pos = label_buy_limit_price_y_pos;
    int switch_btn_buy_limit_sl_x_pos = switch_btn_buy_limit_tp_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_buy_limit_sl_y_pos = label_buy_limit_price_y_pos;

    int edit_box_buy_limit_price_x_pos = label_buy_limit_price_x_pos;
    int edit_box_buy_limit_price_y_pos = label_buy_limit_price_y_pos + switch_btn_height + action_box_gap_y;
    int edit_box_buy_limit_lot_x_pos = edit_box_buy_limit_price_x_pos + action_box_width + action_box_gap_x;
    int edit_box_buy_limit_lot_y_pos = edit_box_buy_limit_price_y_pos;
    int edit_box_buy_limit_tp_x_pos = edit_box_buy_limit_lot_x_pos  + action_box_width + action_box_gap_x;
    int edit_box_buy_limit_tp_y_pos = edit_box_buy_limit_price_y_pos;
    int edit_box_buy_limit_sl_x_pos = edit_box_buy_limit_tp_x_pos + action_box_width + action_box_gap_x;
    int edit_box_buy_limit_sl_y_pos = edit_box_buy_limit_price_y_pos;

    int orer_btn_buy_limit_x_pos = label_buy_limit_sl_x_pos + action_box_width + order_btn_margin_left;
    int orer_btn_buy_limit_y_pos = label_buy_limit_sl_y_pos + label_height + action_box_gap_y;

    int frame_width = (action_box_width * 4) + (action_box_gap_x * 3) + order_btn_margin_left + order_btn_width + (frame_pad * 2);
    int frame_height = action_box_height + (frame_pad * 2);


//--- 売り指値注文に関する変数
    int frame_sell_limit_x_pos = window_pad;
    int frame_sell_limit_y_pos = frame_buy_limit_y_pos + frame_height + frame_margin_bottom;;

    int label_sell_limit_lot_x_pos = frame_sell_limit_x_pos + frame_pad + action_box_width + action_box_gap_x;
    int label_sell_limit_lot_y_pos = frame_sell_limit_y_pos + frame_pad;
    int label_sell_limit_tp_x_pos = label_sell_limit_lot_x_pos + action_box_width + action_box_gap_x;
    int label_sell_limit_tp_y_pos = label_sell_limit_lot_y_pos;
    int label_sell_limit_sl_x_pos = label_sell_limit_tp_x_pos + action_box_width + action_box_gap_x;
    int label_sell_limit_sl_y_pos = label_sell_limit_lot_y_pos;
    int label_sell_limit_price_x_pos = frame_sell_limit_x_pos + frame_pad;
    int label_sell_limit_price_y_pos = label_sell_limit_lot_y_pos + label_height + action_box_gap_y;

    int switch_btn_sell_limit_lot_x_pos = label_sell_limit_lot_x_pos;
    int switch_btn_sell_limit_lot_y_pos = label_sell_limit_price_y_pos;
    int switch_btn_sell_limit_tp_x_pos = switch_btn_sell_limit_lot_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_sell_limit_tp_y_pos = label_sell_limit_price_y_pos;
    int switch_btn_sell_limit_sl_x_pos = switch_btn_sell_limit_tp_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_sell_limit_sl_y_pos = label_sell_limit_price_y_pos;

    int edit_box_sell_limit_price_x_pos = label_sell_limit_price_x_pos;
    int edit_box_sell_limit_price_y_pos = label_sell_limit_price_y_pos + switch_btn_height + action_box_gap_y;
    int edit_box_sell_limit_lot_x_pos = edit_box_sell_limit_price_x_pos + action_box_width + action_box_gap_x;
    int edit_box_sell_limit_lot_y_pos = edit_box_sell_limit_price_y_pos;
    int edit_box_sell_limit_tp_x_pos = edit_box_sell_limit_lot_x_pos  + action_box_width + action_box_gap_x;
    int edit_box_sell_limit_tp_y_pos = edit_box_sell_limit_price_y_pos;
    int edit_box_sell_limit_sl_x_pos = edit_box_sell_limit_tp_x_pos + action_box_width + action_box_gap_x;
    int edit_box_sell_limit_sl_y_pos = edit_box_sell_limit_price_y_pos;

    int orer_btn_sell_limit_x_pos = label_sell_limit_sl_x_pos + action_box_width + order_btn_margin_left;
    int orer_btn_sell_limit_y_pos = label_sell_limit_sl_y_pos + label_height + action_box_gap_y;

    int window_width = frame_width + (window_pad * 2);
    int window_height = caption_height + (window_pad * 2) + (frame_height * 2) + (frame_margin_bottom * 1);
    int x_pos = m_main_window_market_order_button.XGap() + 50;
    int y_pos = m_main_window_market_order_button.YGap() + 50;

// コンテナー側にあるウィンドウ配列にウィンドウ参照を追加
    CWndContainer::AddWindow(m_limit_order_window);

// ウィンドウに座標
    int _x_pos = (m_limit_order_window.X() > x_pos) ? m_limit_order_window.X() : x_pos;
    int _y_pos = (m_limit_order_window.Y() > y_pos) ? m_limit_order_window.Y() : y_pos;

// ダイアログウィンドウのサイズを変更
    m_limit_order_window.XSize(window_width);
    m_limit_order_window.YSize(window_height);

// ウィンドウの色
    m_limit_order_window.BackColor(m_background_color);
    m_limit_order_window.BorderColor(clrRoyalBlue);

// ウィンドウの文字の大きさ
    m_limit_order_window.FontSize(m_base_font_size);

// ウィンドウの文字の書体
    m_limit_order_window.Font(m_base_font_name);

// ウィンドウの移動許可
    m_limit_order_window.IsMovable(true);

// ウィンドウの種類
    m_limit_order_window.WindowType(W_DIALOG);

// 見出し（caption）の高さ
    m_limit_order_window.CaptionHeight(caption_height);

// 見出し（caption）の色
    m_limit_order_window.CaptionColor(clrRoyalBlue);
    m_limit_order_window.CaptionColorLocked(clrRoyalBlue);
    m_limit_order_window.CaptionColorHover(clrRoyalBlue);

// ウィンドウの移動許可
    m_limit_order_window.IsMovable(true);

// ヘッダーのボタン
    m_limit_order_window.CloseButtonIsUsed(true);
    m_limit_order_window.CollapseButtonIsUsed(true);
    m_limit_order_window.TooltipsButtonIsUsed(true);
    m_limit_order_window.FullscreenButtonIsUsed(true);
    m_limit_order_window.TransparentOnlyCaption(false);

// ツールチップの定義
    m_limit_order_window.GetCloseButtonPointer().Tooltip("閉じる");
    m_limit_order_window.GetTooltipButtonPointer().Tooltip("ツールチップ");
    m_limit_order_window.GetFullscreenButtonPointer().Tooltip("フルスクリーン化");
    m_limit_order_window.GetCollapseButtonPointer().Tooltip("折りたたみ/展開");

// 上記に基づいて、ウィンドウの作成
// 「m_chart_id」と「m_subwin」は、「CWndEventsクラス」で定義されているメンバ
    if(!m_limit_order_window.CreateWindow(m_chart_id, m_subwin, "指値の注文", _x_pos, _y_pos))
        return (false);


// 買い指値注文用のフレームを作成
    if(!CreateFrame(m_limit_order_window, m_limit_order_buy_frame, "Buy Limit Order", clrForestGreen, window_pad, frame_height, frame_label_width, frame_label_height, frame_buy_limit_x_pos, frame_buy_limit_y_pos, 2))
        return (false);

// 買い指値注文用のラベルテキストの作成
    if(!CreateLabel(m_limit_order_window, m_limit_order_labels[0], action_box_width, label_buy_limit_price_x_pos, label_buy_limit_price_y_pos, "Price", 2))
        return (false);

    if(!CreateLabel(m_limit_order_window, m_limit_order_labels[1], action_box_width, label_buy_limit_lot_x_pos, label_buy_limit_lot_y_pos, "Lot", 2))
        return (false);

    if(!CreateLabel(m_limit_order_window, m_limit_order_labels[2], action_box_width, label_buy_limit_tp_x_pos, label_buy_limit_tp_y_pos, "Take Profit", 2))
        return (false);

    if(!CreateLabel(m_limit_order_window, m_limit_order_labels[3], action_box_width, label_buy_limit_sl_x_pos, label_buy_limit_sl_y_pos, "Stop Loss", 2))
        return (false);

// 買い指値注文用のトグルボタンの作成
    if(!CreateSwitchButton(m_limit_order_window, m_limit_order_switch_buttons[0], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_buy_limit_lot_x_pos, switch_btn_buy_limit_lot_y_pos, 2))
        return (false);

    if(!CreateSwitchButton(m_limit_order_window, m_limit_order_switch_buttons[1], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_buy_limit_tp_x_pos, switch_btn_buy_limit_tp_y_pos, 2))
        return (false);

    if(!CreateSwitchButton(m_limit_order_window, m_limit_order_switch_buttons[2], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_buy_limit_sl_x_pos, switch_btn_buy_limit_sl_y_pos, 2))
        return (false);

// 買い指値注文用の入力欄
    if(!CreatePriceEdit(m_limit_order_window, m_limit_order_price_edits[0], action_box_width, edit_box_height, edit_box_buy_limit_price_x_pos, edit_box_buy_limit_price_y_pos, "", 2))
        return (false);

    if(!CreateLotEdit(m_limit_order_window, m_limit_order_lot_edits[0], action_box_width, edit_box_height, edit_box_buy_limit_lot_x_pos, edit_box_buy_limit_lot_y_pos, "1.0", 2))
        return (false);

    if(!CreateTakeProfitEdit(m_limit_order_window, m_limit_order_tp_edits[0], action_box_width, edit_box_height, edit_box_buy_limit_tp_x_pos, edit_box_buy_limit_tp_y_pos, "100", 2))
        return (false);

    if(!CreateStopLossEdit(m_limit_order_window, m_limit_order_sl_edits[0], action_box_width, edit_box_height, edit_box_buy_limit_sl_x_pos, edit_box_buy_limit_sl_y_pos, "100", 2))
        return (false);

// 買い指値注文用のボタン
    if(!CreateButton(m_limit_order_window, m_limit_order_buy_button, "Buy Limit", m_base_font_size, m_base_font_name, clrForestGreen, order_btn_width, order_btn_height, orer_btn_buy_limit_x_pos, orer_btn_buy_limit_y_pos, 2))
        return (false);

// 売り指値注文用のフレームを作成
    if(!CreateFrame(m_limit_order_window, m_limit_order_sell_frame, "Sell Limit Order", clrOrangeRed, window_pad, frame_height, frame_label_width, frame_label_height, frame_sell_limit_x_pos, frame_sell_limit_y_pos, 2))
        return (false);

// 売り指値注文用のラベルテキストの作成
    if(!CreateLabel(m_limit_order_window, m_limit_order_labels[4], action_box_width, label_sell_limit_price_x_pos, label_sell_limit_price_y_pos, "Price", 2))
        return (false);

    if(!CreateLabel(m_limit_order_window, m_limit_order_labels[5], action_box_width, label_sell_limit_lot_x_pos, label_sell_limit_lot_y_pos, "Lot", 2))
        return (false);

    if(!CreateLabel(m_limit_order_window, m_limit_order_labels[6], action_box_width, label_sell_limit_tp_x_pos, label_sell_limit_tp_y_pos, "Take Profit", 2))
        return (false);

    if(!CreateLabel(m_limit_order_window, m_limit_order_labels[7], action_box_width, label_sell_limit_sl_x_pos, label_sell_limit_sl_y_pos, "Stop Loss", 2))
        return (false);

// 売り指値注文用のトグルボタンの作成
    if(!CreateSwitchButton(m_limit_order_window, m_limit_order_switch_buttons[3], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_sell_limit_lot_x_pos, switch_btn_sell_limit_lot_y_pos, 2))
        return (false);

    if(!CreateSwitchButton(m_limit_order_window, m_limit_order_switch_buttons[4], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_sell_limit_tp_x_pos, switch_btn_sell_limit_tp_y_pos, 2))
        return (false);

    if(!CreateSwitchButton(m_limit_order_window, m_limit_order_switch_buttons[5], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_sell_limit_sl_x_pos, switch_btn_sell_limit_sl_y_pos, 2))
        return (false);

// 売り指値注文用の入力欄
    if(!CreatePriceEdit(m_limit_order_window, m_limit_order_price_edits[1], action_box_width, edit_box_height, edit_box_sell_limit_price_x_pos, edit_box_sell_limit_price_y_pos, "", 2))
        return (false);

    if(!CreateLotEdit(m_limit_order_window, m_limit_order_lot_edits[1], action_box_width, edit_box_height, edit_box_sell_limit_lot_x_pos, edit_box_sell_limit_lot_y_pos, "1.0", 2))
        return (false);

    if(!CreateTakeProfitEdit(m_limit_order_window, m_limit_order_tp_edits[1], action_box_width, edit_box_height, edit_box_sell_limit_tp_x_pos, edit_box_sell_limit_tp_y_pos, "100", 2))
        return (false);

    if(!CreateStopLossEdit(m_limit_order_window, m_limit_order_sl_edits[1], action_box_width, edit_box_height, edit_box_sell_limit_sl_x_pos, edit_box_sell_limit_sl_y_pos, "100", 2))
        return (false);

// 売り指値注文用のボタン
    if(!CreateButton(m_limit_order_window, m_limit_order_sell_button, "Sell Limit", m_base_font_size, m_base_font_name, clrOrangeRed, order_btn_width, order_btn_height, orer_btn_sell_limit_x_pos, orer_btn_sell_limit_y_pos, 2))
        return (false);

    return (true);
}


//+------------------------------------------------------------------+
//| 逆指値のダイアログウィンドウの作成
//+------------------------------------------------------------------+
bool CProgram::CreateStopOrdersWindow() {
// 共通の変数
    int frame_label_width = 150;
    int frame_label_height = 40;

//--- 買い逆指値注文に関する変数
    int frame_buy_stop_x_pos = window_pad;
    int frame_buy_stop_y_pos = window_pad;

    int label_buy_stop_lot_x_pos = frame_buy_stop_x_pos + frame_pad + action_box_width + action_box_gap_x;
    int label_buy_stop_lot_y_pos = frame_buy_stop_y_pos + frame_pad;
    int label_buy_stop_tp_x_pos = label_buy_stop_lot_x_pos + action_box_width + action_box_gap_x;
    int label_buy_stop_tp_y_pos = label_buy_stop_lot_y_pos;
    int label_buy_stop_sl_x_pos = label_buy_stop_tp_x_pos + action_box_width + action_box_gap_x;
    int label_buy_stop_sl_y_pos = label_buy_stop_lot_y_pos;
    int label_buy_stop_price_x_pos = frame_buy_stop_x_pos + frame_pad;
    int label_buy_stop_price_y_pos = label_buy_stop_lot_y_pos + label_height + action_box_gap_y;

    int switch_btn_buy_stop_lot_x_pos = label_buy_stop_lot_x_pos;
    int switch_btn_buy_stop_lot_y_pos = label_buy_stop_price_y_pos;
    int switch_btn_buy_stop_tp_x_pos = switch_btn_buy_stop_lot_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_buy_stop_tp_y_pos = label_buy_stop_price_y_pos;
    int switch_btn_buy_stop_sl_x_pos = switch_btn_buy_stop_tp_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_buy_stop_sl_y_pos = label_buy_stop_price_y_pos;

    int edit_box_buy_stop_price_x_pos = label_buy_stop_price_x_pos;
    int edit_box_buy_stop_price_y_pos = label_buy_stop_price_y_pos + switch_btn_height + action_box_gap_y;
    int edit_box_buy_stop_lot_x_pos = edit_box_buy_stop_price_x_pos + action_box_width + action_box_gap_x;
    int edit_box_buy_stop_lot_y_pos = edit_box_buy_stop_price_y_pos;
    int edit_box_buy_stop_tp_x_pos = edit_box_buy_stop_lot_x_pos  + action_box_width + action_box_gap_x;
    int edit_box_buy_stop_tp_y_pos = edit_box_buy_stop_price_y_pos;
    int edit_box_buy_stop_sl_x_pos = edit_box_buy_stop_tp_x_pos + action_box_width + action_box_gap_x;
    int edit_box_buy_stop_sl_y_pos = edit_box_buy_stop_price_y_pos;

    int orer_btn_buy_stop_x_pos = label_buy_stop_sl_x_pos + action_box_width + order_btn_margin_left;
    int orer_btn_buy_stop_y_pos = label_buy_stop_sl_y_pos + label_height + action_box_gap_y;

    int frame_width = (action_box_width * 4) + (action_box_gap_x * 3) + order_btn_margin_left + order_btn_width + (frame_pad * 2);
    int frame_height = action_box_height + (frame_pad * 2);

//--- 売り逆指値注文に関する変数
    int frame_sell_stop_x_pos = window_pad;
    int frame_sell_stop_y_pos = frame_buy_stop_y_pos + frame_height + frame_margin_bottom;;

    int label_sell_stop_lot_x_pos = frame_sell_stop_x_pos + frame_pad + action_box_width + action_box_gap_x;
    int label_sell_stop_lot_y_pos = frame_sell_stop_y_pos + frame_pad;
    int label_sell_stop_tp_x_pos = label_sell_stop_lot_x_pos + action_box_width + action_box_gap_x;
    int label_sell_stop_tp_y_pos = label_sell_stop_lot_y_pos;
    int label_sell_stop_sl_x_pos = label_sell_stop_tp_x_pos + action_box_width + action_box_gap_x;
    int label_sell_stop_sl_y_pos = label_sell_stop_lot_y_pos;
    int label_sell_stop_price_x_pos = frame_sell_stop_x_pos + frame_pad;
    int label_sell_stop_price_y_pos = label_sell_stop_lot_y_pos + label_height + action_box_gap_y;

    int switch_btn_sell_stop_lot_x_pos = label_sell_stop_lot_x_pos;
    int switch_btn_sell_stop_lot_y_pos = label_sell_stop_price_y_pos;
    int switch_btn_sell_stop_tp_x_pos = switch_btn_sell_stop_lot_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_sell_stop_tp_y_pos = label_sell_stop_price_y_pos;
    int switch_btn_sell_stop_sl_x_pos = switch_btn_sell_stop_tp_x_pos + action_box_width + action_box_gap_x;
    int switch_btn_sell_stop_sl_y_pos = label_sell_stop_price_y_pos;

    int edit_box_sell_stop_price_x_pos = label_sell_stop_price_x_pos;
    int edit_box_sell_stop_price_y_pos = label_sell_stop_price_y_pos + switch_btn_height + action_box_gap_y;
    int edit_box_sell_stop_lot_x_pos = edit_box_sell_stop_price_x_pos + action_box_width + action_box_gap_x;
    int edit_box_sell_stop_lot_y_pos = edit_box_sell_stop_price_y_pos;
    int edit_box_sell_stop_tp_x_pos = edit_box_sell_stop_lot_x_pos  + action_box_width + action_box_gap_x;
    int edit_box_sell_stop_tp_y_pos = edit_box_sell_stop_price_y_pos;
    int edit_box_sell_stop_sl_x_pos = edit_box_sell_stop_tp_x_pos + action_box_width + action_box_gap_x;
    int edit_box_sell_stop_sl_y_pos = edit_box_sell_stop_price_y_pos;

    int orer_btn_sell_stop_x_pos = label_sell_stop_sl_x_pos + action_box_width + order_btn_margin_left;
    int orer_btn_sell_stop_y_pos = label_sell_stop_sl_y_pos + label_height + action_box_gap_y;

    int window_width = frame_width + (window_pad * 2);
    int window_height = caption_height + (window_pad * 2) + (frame_height * 2) + (frame_margin_bottom * 1);
    int x_pos = m_main_window_market_order_button.XGap() + 50;
    int y_pos = m_main_window_market_order_button.YGap() + 50;

// コンテナー側にあるウィンドウ配列にウィンドウ参照を追加
    CWndContainer::AddWindow(m_stop_order_window);

// ウィンドウに座標
    int _x_pos = (m_stop_order_window.X() > x_pos) ? m_stop_order_window.X() : x_pos;
    int _y_pos = (m_stop_order_window.Y() > y_pos) ? m_stop_order_window.Y() : y_pos;

// ダイアログウィンドウのサイズを変更
    m_stop_order_window.XSize(window_width);
    m_stop_order_window.YSize(window_height);

// ウィンドウの色
    m_stop_order_window.BackColor(m_background_color);
    m_stop_order_window.BorderColor(clrRoyalBlue);

// ウィンドウの文字の大きさ
    m_stop_order_window.FontSize(m_base_font_size);

// ウィンドウの文字の書体
    m_stop_order_window.Font(m_base_font_name);

// ウィンドウの移動許可
    m_stop_order_window.IsMovable(true);

// ウィンドウの種類
    m_stop_order_window.WindowType(W_DIALOG);

// 見出し（caption）の高さ
    m_stop_order_window.CaptionHeight(caption_height);

// 見出し（caption）の色
    m_stop_order_window.CaptionColor(clrRoyalBlue);
    m_stop_order_window.CaptionColorLocked(clrRoyalBlue);
    m_stop_order_window.CaptionColorHover(clrRoyalBlue);

// ウィンドウの移動許可
    m_stop_order_window.IsMovable(true);

// ヘッダーのボタン
    m_stop_order_window.CloseButtonIsUsed(true);
    m_stop_order_window.CollapseButtonIsUsed(true);
    m_stop_order_window.TooltipsButtonIsUsed(true);
    m_stop_order_window.FullscreenButtonIsUsed(true);
    m_stop_order_window.TransparentOnlyCaption(false);

// ツールチップの定義
    m_stop_order_window.GetCloseButtonPointer().Tooltip("閉じる");
    m_stop_order_window.GetTooltipButtonPointer().Tooltip("ツールチップ");
    m_stop_order_window.GetFullscreenButtonPointer().Tooltip("フルスクリーン化");
    m_stop_order_window.GetCollapseButtonPointer().Tooltip("折りたたみ/展開");

// 上記に基づいて、ウィンドウの作成
// 「m_chart_id」と「m_subwin」は、「CWndEventsクラス」で定義されているメンバ
    if(!m_stop_order_window.CreateWindow(m_chart_id, m_subwin, "逆指値の注文", _x_pos, _y_pos))
        return (false);

// 買い逆指値注文用のフレームを作成
    if(!CreateFrame(m_stop_order_window, m_stop_order_buy_frame, "Buy Stop Order", clrForestGreen, window_pad, frame_height, frame_label_width, frame_label_height, frame_buy_stop_x_pos, frame_buy_stop_y_pos, 3))
        return (false);

// 買い逆指値注文用のラベルテキストの作成
    if(!CreateLabel(m_stop_order_window, m_stop_order_labels[0], action_box_width, label_buy_stop_price_x_pos, label_buy_stop_price_y_pos, "Price", 3))
        return (false);

    if(!CreateLabel(m_stop_order_window, m_stop_order_labels[1], action_box_width, label_buy_stop_lot_x_pos, label_buy_stop_lot_y_pos, "Lot", 3))
        return (false);

    if(!CreateLabel(m_stop_order_window, m_stop_order_labels[2], action_box_width, label_buy_stop_tp_x_pos, label_buy_stop_tp_y_pos, "Take Profit", 3))
        return (false);

    if(!CreateLabel(m_stop_order_window, m_stop_order_labels[3], action_box_width, label_buy_stop_sl_x_pos, label_buy_stop_sl_y_pos, "Stop Loss", 3))
        return (false);

// 買い逆指値注文用のトグルボタンの作成
    if(!CreateSwitchButton(m_stop_order_window, m_stop_order_switch_buttons[0], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_buy_stop_lot_x_pos, switch_btn_buy_stop_lot_y_pos, 3))
        return (false);

    if(!CreateSwitchButton(m_stop_order_window, m_stop_order_switch_buttons[1], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_buy_stop_tp_x_pos, switch_btn_buy_stop_tp_y_pos, 3))
        return (false);

    if(!CreateSwitchButton(m_stop_order_window, m_stop_order_switch_buttons[2], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_buy_stop_sl_x_pos, switch_btn_buy_stop_sl_y_pos, 3))
        return (false);

// 買い逆指値注文用の入力欄
    if(!CreatePriceEdit(m_stop_order_window, m_stop_order_price_edits[0], action_box_width, edit_box_height, edit_box_buy_stop_price_x_pos, edit_box_buy_stop_price_y_pos, "", 3))
        return (false);

    if(!CreateLotEdit(m_stop_order_window, m_stop_order_lot_edits[0], action_box_width, edit_box_height, edit_box_buy_stop_lot_x_pos, edit_box_buy_stop_lot_y_pos, "1.0", 3))
        return (false);

    if(!CreateTakeProfitEdit(m_stop_order_window, m_stop_order_tp_edits[0], action_box_width, edit_box_height, edit_box_buy_stop_tp_x_pos, edit_box_buy_stop_tp_y_pos, "100", 3))
        return (false);

    if(!CreateStopLossEdit(m_stop_order_window, m_stop_order_sl_edits[0], action_box_width, edit_box_height, edit_box_buy_stop_sl_x_pos, edit_box_buy_stop_sl_y_pos, "100", 3))
        return (false);

// 買い逆指値注文用のボタン
    if(!CreateButton(m_stop_order_window, m_stop_order_buy_button, "Buy Stop", m_base_font_size, m_base_font_name, clrForestGreen, order_btn_width, order_btn_height, orer_btn_buy_stop_x_pos, orer_btn_buy_stop_y_pos, 3))
        return (false);

// 売り逆指値注文用のフレームを作成
    if(!CreateFrame(m_stop_order_window, m_stop_order_sell_frame, "Sell Stop Order", clrOrangeRed, window_pad, frame_height, frame_label_width, frame_label_height, frame_sell_stop_x_pos, frame_sell_stop_y_pos, 3))
        return (false);

// 売り逆指値注文用のラベルテキストの作成
    if(!CreateLabel(m_stop_order_window, m_stop_order_labels[4], action_box_width, label_sell_stop_price_x_pos, label_sell_stop_price_y_pos, "Price", 3))
        return (false);

    if(!CreateLabel(m_stop_order_window, m_stop_order_labels[5], action_box_width, label_sell_stop_lot_x_pos, label_sell_stop_lot_y_pos, "Lot", 3))
        return (false);

    if(!CreateLabel(m_stop_order_window, m_stop_order_labels[6], action_box_width, label_sell_stop_tp_x_pos, label_sell_stop_tp_y_pos, "Take Profit", 3))
        return (false);

    if(!CreateLabel(m_stop_order_window, m_stop_order_labels[7], action_box_width, label_sell_stop_sl_x_pos, label_sell_stop_sl_y_pos, "Stop Loss", 3))
        return (false);

// 売り逆指値注文用のトグルボタンの作成
    if(!CreateSwitchButton(m_stop_order_window, m_stop_order_switch_buttons[3], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_sell_stop_lot_x_pos, switch_btn_sell_stop_lot_y_pos, 3))
        return (false);

    if(!CreateSwitchButton(m_stop_order_window, m_stop_order_switch_buttons[4], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_sell_stop_tp_x_pos, switch_btn_sell_stop_tp_y_pos, 3))
        return (false);

    if(!CreateSwitchButton(m_stop_order_window, m_stop_order_switch_buttons[5], "-", m_base_font_size, m_base_font_name, clrViolet, clrMediumOrchid, action_box_width, switch_btn_height, switch_btn_sell_stop_sl_x_pos, switch_btn_sell_stop_sl_y_pos, 3))
        return (false);

// 売り逆指値注文用の入力欄
    if(!CreatePriceEdit(m_stop_order_window, m_stop_order_price_edits[1], action_box_width, edit_box_height, edit_box_sell_stop_price_x_pos, edit_box_sell_stop_price_y_pos, "", 3))
        return (false);

    if(!CreateLotEdit(m_stop_order_window, m_stop_order_lot_edits[1], action_box_width, edit_box_height, edit_box_sell_stop_lot_x_pos, edit_box_sell_stop_lot_y_pos, "1.0", 3))
        return (false);

    if(!CreateTakeProfitEdit(m_stop_order_window, m_stop_order_tp_edits[1], action_box_width, edit_box_height, edit_box_sell_stop_tp_x_pos, edit_box_sell_stop_tp_y_pos, "100", 3))
        return (false);

    if(!CreateStopLossEdit(m_stop_order_window, m_stop_order_sl_edits[1], action_box_width, edit_box_height, edit_box_sell_stop_sl_x_pos, edit_box_sell_stop_sl_y_pos, "100", 3))
        return (false);

// 売り逆指値注文用のボタン
    if(!CreateButton(m_stop_order_window, m_stop_order_sell_button, "Sell stop", m_base_font_size, m_base_font_name, clrOrangeRed, order_btn_width, order_btn_height, orer_btn_sell_stop_x_pos, orer_btn_sell_stop_y_pos, 3))
        return (false);

    return (true);
}

//+------------------------------------------------------------------+
