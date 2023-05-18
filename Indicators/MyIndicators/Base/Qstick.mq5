//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// Qstick


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MovingAverages.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_Qstick_MA_len = 15;   // 移動平均線の期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_Qstick[];
double  buffer_Qstick_co[];
double  buffer_Qstick_MA_co[];



//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers             3
#property indicator_plots               1
#property indicator_separate_window

#property indicator_label1              "Qstick"
#property indicator_type1               DRAW_LINE
#property indicator_color1              clrCrimson
#property indicator_style1              STYLE_SOLID
#property indicator_width1              2

#property indicator_level1              0


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_Qstick, true);
    ArraySetAsSeries(buffer_Qstick_co, true);
    ArraySetAsSeries(buffer_Qstick_MA_co, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_Qstick, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_Qstick_co, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, buffer_Qstick_MA_co, INDICATOR_CALCULATIONS);


// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_Qstick_MA_len + 5);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("Qstick(%d)", input_Qstick_MA_len)
    );

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
    if(rates_total < MathMax(input_Qstick_MA_len, 5))
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(open, true);
    ArraySetAsSeries(close, true);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

    for(int i = end_pos; i >= start_pos; i--) {
        buffer_Qstick_co[i] = close[i] - open[i];
    }

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        input_Qstick_MA_len,
        buffer_Qstick_co,
        buffer_Qstick_MA_co
    );

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        5,
        buffer_Qstick_MA_co,
        buffer_Qstick
    );


//---
    return(rates_total);
}


//+------------------------------------------------------------------+
