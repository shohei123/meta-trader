//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include <EasyAndFastGUI\WndCreate.mqh>
#include <MyDoEasy/Trading/Trading.mqh>


//+------------------------------------------------------------------+
//| CProgramクラスの定義
//+------------------------------------------------------------------+
class CProgram : public CWndCreate {
  private:
    //--- 入力値
    color               m_caption_color;
    color               m_background_color;
    int                 m_base_font_size;
    int                 m_m_edit_index;
    int                 m_p_edit_index;
    ulong               m_magic_number;
    string              m_base_font_name;

    //--- メインウィンドウのメンバ
    CWindow             m_main_window;
    CButton             m_main_window_market_order_button;
    CButton             m_main_window_limit_order_button;
    CButton             m_main_window_stop_order_button;
    CButton             m_main_window_stop_limit_order_button;
    CButton             m_main_window_profit_all_settlement_button;
    CButton             m_main_window_loss_all_settlement_button;
    CButton             m_main_window_unsettled_remove_button;


    //--- 成行注文ウィンドウのメンバ
    CWindow             m_market_order_window;
    CFrame              m_market_order_buy_frame;
    CFrame              m_market_order_sell_frame;
    CButton             m_market_order_switch_buttons[6];
    CButton             m_market_order_buy_button;
    CButton             m_market_order_sell_button;
    CTextLabel          m_market_order_labels[6];
    CTextEdit           m_market_order_lot_edits[2];
    CTextEdit           m_market_order_tp_edits[2];
    CTextEdit           m_market_order_sl_edits[2];
    CTextEdit           m_market_order_price_edits[2];

    //--- 指値注文ウィンドウのメンバ
    CWindow             m_limit_order_window;
    CFrame              m_limit_order_buy_frame;
    CFrame              m_limit_order_sell_frame;
    CButton             m_limit_order_switch_buttons[6];
    CButton             m_limit_order_buy_button;
    CButton             m_limit_order_sell_button;
    CTextLabel          m_limit_order_labels[8];
    CTextEdit           m_limit_order_lot_edits[2];
    CTextEdit           m_limit_order_tp_edits[2];
    CTextEdit           m_limit_order_sl_edits[2];
    CTextEdit           m_limit_order_price_edits[2];

    //--- 逆指値注文ウィンドウのメンバ
    CWindow             m_stop_order_window;
    CFrame              m_stop_order_buy_frame;
    CFrame              m_stop_order_sell_frame;
    CButton             m_stop_order_switch_buttons[6];
    CButton             m_stop_order_buy_button;
    CButton             m_stop_order_sell_button;
    CTextLabel          m_stop_order_labels[8];
    CTextEdit           m_stop_order_lot_edits[2];
    CTextEdit           m_stop_order_tp_edits[2];
    CTextEdit           m_stop_order_sl_edits[2];
    CTextEdit           m_stop_order_price_edits[2];

    //--- ストップリミット注文ウィンドウのメンバ
    CWindow             m_stop_limit_order_window;
    CFrame              m_stop_limit_order_buy_frame;
    CFrame              m_stop_limit_order_sell_frame;
    CButton             m_stop_limit_order_switch_buttons[6];
    CButton             m_stop_limit_order_buy_button;
    CButton             m_stop_limit_order_sell_button;
    CTextLabel          m_stop_limit_order_labels[8];
    CTextEdit           m_stop_limit_order_lot_edits[2];
    CTextEdit           m_stop_limit_order_tp_edits[2];
    CTextEdit           m_stop_limit_order_sl_edits[2];
    CTextEdit           m_stop_limit_order_price_edits[2];

    //--- 全決済（含み益）ウィンドウのメンバ
    CWindow             m_profit_all_settlement_window;

    //--- 全決済（含み損）ウィンドウのメンバ
    CWindow             m_loss_all_settlement_window;

    //--- 全取り消し（未約定）ウィンドウのメンバ
    CWindow             m_unsettled_remove_window;

    //--- 取引・決済の機能を取りまとめたメンバ
    CTrading            m_trading;


  public:
    CProgram(void);
    ~CProgram(void);

    //--- Initialization / deinitialization
    void                OnInitEvent(void);
    void                OnDeinitEvent(const int reason);

    //--- Timer
    void                OnTimerEvent(void);

    //--- Chart event handler
    virtual void        OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);

    //--- GUIの作成
    bool                CreateGUI(void);
    bool                CreateMainWindow(void);
    bool                CreateMarketOrdersWindow(void);
    bool                CreateLimitOrdersWindow(void);
    bool                CreateStopOrdersWindow(void);
    bool                CreateButton(CWindow &window, CButton &button, string text, const int font_base_size, const string font_base_name, color button_color, const int x_size, const int y_size, int x_gap, int y_gap, int w_number);
    bool                CreateSwitchButton(CWindow &window, CButton &button, string text, const int font_base_size, const string font_base_name, color base_color, color pressed_color, const int x_size, const int y_size, int x_gap, int y_gap, int w_number);
    bool                CreateFrame(CWindow &window, CFrame &frame, string caption, color color_main, const int frame_offset, const int frame_height, const int frame_label_width, const int frame_label_height, const int x_gap, const int y_gap, int w_number);
    bool                CreateLabel(CWindow &window, CTextLabel &text_label, const int x_size, const int x_gap, const int y_gap, string label_text, int w_number);
    bool                CreatePriceEdit(CWindow &window, CTextEdit &text_edit, const int x_size, const int y_size, const int x_gap, const int y_gap, string init_text, int w_number);
    bool                CreateLotEdit(CWindow &window, CTextEdit &text_edit, const int x_size, const int y_size, const int x_gap, const int y_gap, string init_text, int w_number);
    bool                CreateTakeProfitEdit(CWindow &window, CTextEdit &text_edit, const int x_size, const int y_size, const int x_gap, const int y_gap, string init_text, int w_number);
    bool                CreateStopLossEdit(CWindow &window, CTextEdit &text_edit, const int x_size, const int y_size, const int x_gap, const int y_gap, string init_text, int w_number);

    //--- Setter系の関数
    void                SetFontSize(const int font_size);
    void                SetFontName(const string font_name);
    void                SetCaptionBackgroundColor(const color clr);
    void                SetBackgroundColor(const color clr);
    void                SetMagicNumber(ulong magic_number);
    void                SetButtonParam(CButton &button, string text);

    //--- 要素のプロパティの切り替え系の関数
    void                SwitchButtonText(CButton &button, string state1, string state2);
    void                SwitchLotEditBox(CButton &button, CTextEdit &edit);
    void                SwitchStopLossEditBox(CButton &button, CTextEdit &edit);
    void                SwitchTakeProfitEditBox(CButton &button, CTextEdit &edit);


    //--- 注文についての関数
    void                OnInitTrading(void);
    void                SetBuyOrder(void);
    void                SetBuyLimitOrder(void);
    void                SetBuyStopOrder(void);
    void                SetSellOrder(void);
    void                SetSellLimitOrder(void);
    void                SetSellStopOrder(void);
    void                CloseAllMarketProfit(void);
    void                CloseAllMarketLoss(void);
    void                RemoveAllPosition(void);
    double              LotPercent(string symbol, ENUM_ORDER_TYPE trade_type, double price, double percent);
    double              NormalizeLot(string symbol,  double volume);


    //--- 表示用の整形
    string              FormatOrderDialogText(const string order_type, const string symbol, const double price, const double lot, const double sl, const double tp);
};


//+------------------------------------------------------------------+
//| CProgramの追加メソッドを定義したファイルのinclude宣言
//+------------------------------------------------------------------+
#include "./Container/Format.mqh"
#include "./Container/SendOrder.mqh"
#include "./Container/SetMenber.mqh"
#include "./Container/SetButtonParam.mqh"
#include "./Container/SwitchButtonText.mqh"
#include "./Container/SwitchEditBox.mqh"
#include "./Presentational/CreateGUI.mqh"


//+------------------------------------------------------------------+
//| コンストラクター
//+------------------------------------------------------------------+
void CProgram::CProgram(void) {
    OnInitTrading();
}


//+------------------------------------------------------------------+
//| デストラクター
//+------------------------------------------------------------------+
void CProgram::~CProgram(void) {
}


//+------------------------------------------------------------------+
//| 初期化
//+------------------------------------------------------------------+
void CProgram::OnInitEvent(void) {
}


//+------------------------------------------------------------------+
//| 非初期化
//+------------------------------------------------------------------+
void CProgram::OnDeinitEvent(const int reason) {
//---インターフェースの削除
    CWndEvents::Destroy();
}


//+------------------------------------------------------------------+
//| タイマー
//+------------------------------------------------------------------+
void CProgram::OnTimerEvent(void) {
    CWndEvents::OnTimerEvent();
}


//+------------------------------------------------------------------+
//| チャートイベントの制御
//+------------------------------------------------------------------+
void CProgram::OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {

//---　何かしらのボタンがクリックされた場合に実行
    if(id == CHARTEVENT_CUSTOM + ON_CLICK_BUTTON) {
        //--- クリックされたボタンのIDをチェックして、連携先のウィンドウを展開

        //--- 各種ウィンドウの展開
        if(lparam == m_main_window_market_order_button.Id())
            m_market_order_window.OpenWindow();
        else if(lparam == m_main_window_limit_order_button.Id())
            m_limit_order_window.OpenWindow();
        else if(lparam == m_main_window_stop_order_button.Id())
            m_stop_order_window.OpenWindow();
        else if(lparam == m_main_window_stop_limit_order_button.Id())
            m_stop_limit_order_window.OpenWindow();

        //--- スイッチボタン・編集欄の文言の切り替え（成行注文）
        else if(lparam == m_market_order_switch_buttons[0].Id()) {
            SwitchButtonText(m_market_order_switch_buttons[0], "Lot", "% Deposit");
            SwitchLotEditBox(m_market_order_switch_buttons[0], m_market_order_lot_edits[0]);
        } else if(lparam == m_market_order_switch_buttons[1].Id()) {
            SwitchButtonText(m_market_order_switch_buttons[1], "Points", "Price");
            SwitchTakeProfitEditBox(m_market_order_switch_buttons[1], m_market_order_tp_edits[0]);
        } else if(lparam == m_market_order_switch_buttons[2].Id()) {
            SwitchButtonText(m_market_order_switch_buttons[2], "Points", "Price");
            SwitchStopLossEditBox(m_market_order_switch_buttons[2], m_market_order_sl_edits[0]);
        } else if(lparam == m_market_order_switch_buttons[3].Id()) {
            SwitchButtonText(m_market_order_switch_buttons[3], "Lot", "% Deposit");
            SwitchLotEditBox(m_market_order_switch_buttons[3], m_market_order_lot_edits[1]);
        } else if(lparam == m_market_order_switch_buttons[4].Id()) {
            SwitchButtonText(m_market_order_switch_buttons[4], "Points", "Price");
            SwitchTakeProfitEditBox(m_market_order_switch_buttons[4], m_market_order_tp_edits[1]);
        } else if(lparam == m_market_order_switch_buttons[5].Id()) {
            SwitchButtonText(m_market_order_switch_buttons[5], "Points", "Price");
            SwitchStopLossEditBox(m_market_order_switch_buttons[5], m_market_order_sl_edits[1]);
        }

        //--- スイッチボタン・編集欄の文言の切り替え（指値注文）
        else if(lparam == m_limit_order_switch_buttons[0].Id()) {
            SwitchButtonText(m_limit_order_switch_buttons[0], "Lot", "% Deposit");
            SwitchLotEditBox(m_limit_order_switch_buttons[0], m_limit_order_lot_edits[0]);
        } else if(lparam == m_limit_order_switch_buttons[1].Id()) {
            SwitchButtonText(m_limit_order_switch_buttons[1], "Points", "Price");
            SwitchTakeProfitEditBox(m_limit_order_switch_buttons[1], m_limit_order_tp_edits[0]);
        } else if(lparam == m_limit_order_switch_buttons[2].Id()) {
            SwitchButtonText(m_limit_order_switch_buttons[2], "Points", "Price");
            SwitchStopLossEditBox(m_limit_order_switch_buttons[2], m_limit_order_sl_edits[0]);
        } else if(lparam == m_limit_order_switch_buttons[3].Id()) {
            SwitchButtonText(m_limit_order_switch_buttons[3], "Lot", "% Deposit");
            SwitchLotEditBox(m_limit_order_switch_buttons[3], m_limit_order_lot_edits[1]);
        } else if(lparam == m_limit_order_switch_buttons[4].Id()) {
            SwitchButtonText(m_limit_order_switch_buttons[4], "Points", "Price");
            SwitchTakeProfitEditBox(m_limit_order_switch_buttons[4], m_limit_order_tp_edits[1]);
        } else if(lparam == m_limit_order_switch_buttons[5].Id()) {
            SwitchButtonText(m_limit_order_switch_buttons[5], "Points", "Price");
            SwitchStopLossEditBox(m_limit_order_switch_buttons[5], m_limit_order_sl_edits[1]);
        }

        //--- スイッチボタン・編集欄の文言の切り替え（逆指値注文）
        else if(lparam == m_stop_order_switch_buttons[0].Id()) {
            SwitchButtonText(m_stop_order_switch_buttons[0], "Lot", "% Deposit");
            SwitchLotEditBox(m_stop_order_switch_buttons[0], m_stop_order_lot_edits[0]);
        } else if(lparam == m_stop_order_switch_buttons[1].Id()) {
            SwitchButtonText(m_stop_order_switch_buttons[1], "Points", "Price");
            SwitchTakeProfitEditBox(m_stop_order_switch_buttons[1], m_stop_order_tp_edits[0]);
        } else if(lparam == m_stop_order_switch_buttons[2].Id()) {
            SwitchButtonText(m_stop_order_switch_buttons[2], "Points", "Price");
            SwitchStopLossEditBox(m_stop_order_switch_buttons[2], m_stop_order_sl_edits[0]);
        } else if(lparam == m_stop_order_switch_buttons[3].Id()) {
            SwitchButtonText(m_stop_order_switch_buttons[3], "Lot", "% Deposit");
            SwitchLotEditBox(m_stop_order_switch_buttons[3], m_stop_order_lot_edits[1]);
        } else if(lparam == m_stop_order_switch_buttons[4].Id()) {
            SwitchButtonText(m_stop_order_switch_buttons[4], "Points", "Price");
            SwitchTakeProfitEditBox(m_stop_order_switch_buttons[4], m_stop_order_tp_edits[1]);
        } else if(lparam == m_stop_order_switch_buttons[5].Id()) {
            SwitchButtonText(m_stop_order_switch_buttons[5], "Points", "Price");
            SwitchStopLossEditBox(m_stop_order_switch_buttons[5], m_stop_order_sl_edits[1]);
        }


        //--- 含み益の約定注文の全決済
        else if (lparam == m_main_window_profit_all_settlement_button.Id())
            CloseAllMarketProfit();

        //--- 含み損の約定注文の全決済
        else if (lparam == m_main_window_loss_all_settlement_button.Id())
            CloseAllMarketLoss();

        //--- 未約定注文の全削除
        else if (lparam == m_main_window_unsettled_remove_button.Id())
            RemoveAllPosition();

        //--- 成行注文の実行
        else if (lparam == m_market_order_buy_button.Id())
            SetBuyOrder();
        else if (lparam == m_market_order_sell_button.Id())
            SetSellOrder();

        //--- 指値注文の実行
        else if (lparam == m_limit_order_buy_button.Id())
            SetBuyLimitOrder();
        else if (lparam == m_limit_order_sell_button.Id())
            SetSellLimitOrder();

        //--- 逆指値注文の実行
        else if (lparam == m_stop_order_buy_button.Id())
            SetBuyStopOrder();
        else if (lparam == m_stop_order_sell_button.Id())
            SetSellStopOrder();
    }

//---チャート上におけるキー押下によるイベント発火
    if(id == CHARTEVENT_KEYDOWN) {

        if(lparam == KEY_M) {
            if(!m_market_order_window.IsVisible())
                m_market_order_window.OpenWindow();
        }

        else if(lparam == KEY_L) {
            if(!m_limit_order_window.IsVisible())
                m_limit_order_window.OpenWindow();
        }

        else if(lparam == KEY_P)
            CloseAllMarketProfit();

        else if(lparam == KEY_D)
            CloseAllMarketLoss();

        else if(lparam == KEY_R)
            RemoveAllPosition();

        else if(lparam == KEY_S) {
            if(!m_stop_order_window.IsVisible())
                m_stop_order_window.OpenWindow();
        }

        else if(lparam == KEY_ESC) {
            if(m_market_order_window.IsVisible())
                m_market_order_window.CloseDialogBox();
            else if(m_limit_order_window.IsVisible())
                m_limit_order_window.CloseDialogBox();
            else if(m_stop_order_window.IsVisible())
                m_stop_order_window.CloseDialogBox();
        }
    }


//--- GUIの作成後に実行
    if(id == CHARTEVENT_CUSTOM + ON_END_CREATE_GUI) {
        //---スイッチボタンのテキストの更新
        SetButtonParam(m_market_order_switch_buttons[0], "Lot");
        SetButtonParam(m_market_order_switch_buttons[1], "Points");
        SetButtonParam(m_market_order_switch_buttons[2], "Points");
        SetButtonParam(m_market_order_switch_buttons[3], "Lot");
        SetButtonParam(m_market_order_switch_buttons[4], "Points");
        SetButtonParam(m_market_order_switch_buttons[5], "Points");
        SetButtonParam(m_limit_order_switch_buttons[0], "Lot");
        SetButtonParam(m_limit_order_switch_buttons[1], "Points");
        SetButtonParam(m_limit_order_switch_buttons[2], "Points");
        SetButtonParam(m_limit_order_switch_buttons[3], "Lot");
        SetButtonParam(m_limit_order_switch_buttons[4], "Points");
        SetButtonParam(m_limit_order_switch_buttons[5], "Points");
        SetButtonParam(m_stop_order_switch_buttons[0], "Lot");
        SetButtonParam(m_stop_order_switch_buttons[1], "Points");
        SetButtonParam(m_stop_order_switch_buttons[2], "Points");
        SetButtonParam(m_stop_order_switch_buttons[3], "Lot");
        SetButtonParam(m_stop_order_switch_buttons[4], "Points");
        SetButtonParam(m_stop_order_switch_buttons[5], "Points");
    }
}


//+------------------------------------------------------------------+
