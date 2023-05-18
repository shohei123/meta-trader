//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// PO（プライス・オシレーター）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int                   input_PO_fast_len       = 10;           // POの速い移動平均線の期間
input int                   input_PO_slow_len       = 20;           // POの遅い移動平均線の期間
input int                   input_PO_diff           = 3;            // POの移動平均線の比較期間
input ENUM_MA_METHOD        input_PO_MA_type        = MODE_SMA;     // 移動平均線の種別
input ENUM_APPLIED_PRICE    input_PO_price_type     = PRICE_CLOSE;  // 移動平均線の計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_PO[];
double  buffer_PO_diff[];
double  buffer_PO_MA_fast[];
double  buffer_PO_MA_slow[];


int     handle_PO_MA_fast;
int     handle_PO_MA_slow;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         4
#property indicator_plots           1
#property indicator_separate_window

#property indicator_label1          "PO"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
// 入力値の例外処理
    if(input_PO_fast_len > input_PO_slow_len) {
        Print("移動平均線の期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_PO, true);
    ArraySetAsSeries(buffer_PO_diff, true);
    ArraySetAsSeries(buffer_PO_MA_fast, true);
    ArraySetAsSeries(buffer_PO_MA_slow, true);


// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_PO, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_PO_diff, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, buffer_PO_MA_fast, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_PO_MA_slow, INDICATOR_CALCULATIONS);


// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_PO_slow_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_PO_MA_fast = iMA(_Symbol, PERIOD_CURRENT, input_PO_fast_len, 0, input_PO_MA_type, input_PO_price_type);
    handle_PO_MA_slow = iMA(_Symbol, PERIOD_CURRENT, input_PO_slow_len, 0, input_PO_MA_type, input_PO_price_type);

    if(handle_PO_MA_fast == INVALID_HANDLE)
        return(INIT_FAILED);
    if(handle_PO_MA_slow == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(INDICATOR_SHORTNAME, StringFormat("PO(%d, %d)", input_PO_fast_len, input_PO_slow_len));

//---
    return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(
    const int rates_total,
    const int prev_calculated,
    const datetime &time[],
    const double &open[],
    const double &high[],
    const double &low[],
    const double &close[],
    const long &tick_volume[],
    const long &volume[],
    const int &spread[]
) {

// 充分なバー数になるまで、即時返却
    if(rates_total < MathMax(input_PO_slow_len, 5))
        return (0);


// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_PO_MA_fast);
    ResetLastError();

    if(calculated < rates_total) {
        Print(
            "必要な期間数が指標の計算に使われていません。（", calculated, " バー)。",
            "\n",
            "エラー：", GetLastError()
        );
        return(0);
    }

    calculated = BarsCalculated(handle_PO_MA_slow);
    ResetLastError();

    if(calculated < rates_total) {
        Print(
            "必要な期間数が指標の計算に使われていません。（", calculated, " バー)。",
            "\n",
            "エラー：", GetLastError()
        );
        return(0);
    }


// 指標ハンドル内の時系列配列において、最新のインデックスを0とした場合に
// 何期間前（end_pos）までの指標値を遡って複製するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 初回または誤動作（prev_calculatedが大きすぎる）なので、全期間を複製対象にする
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    CopyBuffer(handle_PO_MA_fast, 0, start_pos, end_pos, buffer_PO_MA_fast);
    CopyBuffer(handle_PO_MA_slow, 0, start_pos, end_pos, buffer_PO_MA_slow);

    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(buffer_PO, i + 3)) {
            buffer_PO[i] = (buffer_PO_MA_fast[i] - buffer_PO_MA_slow[i]) / buffer_PO_MA_slow[i] * 100;
            buffer_PO_diff[i] = buffer_PO[i] - buffer_PO[i + 3];
        }
        //---
        else {
            buffer_PO[i] = 0.0;
            buffer_PO_diff[i] = 0.0;
        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
