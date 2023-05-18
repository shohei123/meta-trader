//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// RVI（相対活力指数）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>
#include <MovingAverages.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int   input_RVI_len  = 20;      // RVIの平均期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double buffer_RVI_main[];
double buffer_RVI_signal[];
double buffer_RVI_SWMA_co[];
double buffer_RVI_SWMA_hl[];
double buffer_RVI_smooth_SWMA_co[];
double buffer_RVI_smooth_SWMA_hl[];


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers     6
#property indicator_plots       2
#property indicator_separate_window

#property indicator_label1      "RVI main"
#property indicator_type1       DRAW_LINE
#property indicator_color1      clrCrimson
#property indicator_style1      STYLE_SOLID
#property indicator_width1      2

#property indicator_label2      "RVI signal"
#property indicator_type2       DRAW_LINE
#property indicator_color2      clrDeepSkyBlue
#property indicator_style2      STYLE_SOLID
#property indicator_width2      2


//+------------------------------------------------------------------+
//| Custom indicator initialization function
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_RVI_main, true);
    ArraySetAsSeries(buffer_RVI_signal, true);
    ArraySetAsSeries(buffer_RVI_SWMA_co, true);
    ArraySetAsSeries(buffer_RVI_SWMA_hl, true);
    ArraySetAsSeries(buffer_RVI_smooth_SWMA_co, true);
    ArraySetAsSeries(buffer_RVI_smooth_SWMA_hl, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_RVI_main, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_RVI_signal, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_RVI_SWMA_co, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_RVI_SWMA_hl, INDICATOR_CALCULATIONS);
    SetIndexBuffer(4, buffer_RVI_smooth_SWMA_co, INDICATOR_CALCULATIONS);
    SetIndexBuffer(5, buffer_RVI_smooth_SWMA_hl, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_RVI_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_RVI_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(INDICATOR_SHORTNAME, StringFormat("RVI(%d)", input_RVI_len));

//---
    return(INIT_SUCCEEDED);
}



//+------------------------------------------------------------------+
//| Custom indicator iteration function
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
    if(rates_total < input_RVI_len)
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(open, true);
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);
    ArraySetAsSeries(close, true);

// 指標ハンドル内の時系列配列において、最新のインデックスを0とした場合に
// 何期間前（end_pos）までの指標値を遡って複製するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 初回または誤動作（prev_calculatedが大きすぎる）なので、全期間を複製対象にする
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

    for(int i = end_pos; i >= start_pos; i--) {
        if (CheckArrayBounds(open, i + 3) && CheckArrayBounds(close, i + 3) && CheckArrayBounds(high, i + 3) && CheckArrayBounds(low, i + 3)) {
            buffer_RVI_SWMA_co[i] = (close[i] - open[i]) / 6 + (close[i + 1] - open[i + 1]) / 3 + (close[i + 2] - open[i + 2]) / 3 + (close[i + 3] - open[i + 3]) / 6;
            buffer_RVI_SWMA_hl[i] = (high[i] - low[i]) / 6 + (high[i + 1] - low[i + 1]) / 3 + (high[i + 2] - low[i + 2]) / 3 + (high[i + 3] - low[i + 3]) / 6;
        }
        //---
        else {
            buffer_RVI_SWMA_co[i] = close[i] - open[i];
            buffer_RVI_SWMA_hl[i] = high[i] - low[i];
        }
    }

    ExponentialMAOnBuffer(rates_total, prev_calculated, start_pos, input_RVI_len, buffer_RVI_SWMA_co, buffer_RVI_smooth_SWMA_co);
    ExponentialMAOnBuffer(rates_total, prev_calculated, start_pos, input_RVI_len, buffer_RVI_SWMA_hl, buffer_RVI_smooth_SWMA_hl);

    for(int i = end_pos; i >= start_pos; i--) {
        if (buffer_RVI_smooth_SWMA_hl[i] != 0.0)
            buffer_RVI_main[i] = buffer_RVI_smooth_SWMA_co[i] / buffer_RVI_smooth_SWMA_hl[i];
        else
            buffer_RVI_main[i] = 0.0;

        if (CheckArrayBounds(buffer_RVI_main, i + 3) && CheckArrayBounds(buffer_RVI_signal, i + 3))
            buffer_RVI_signal[i] = buffer_RVI_main[i] * 1 / 6 + buffer_RVI_main[i + 1] * 2 / 6 + buffer_RVI_main[i + 2] * 2 / 6 + buffer_RVI_main[i + 3] * 1 / 6;
        else
            buffer_RVI_signal[i] = 0.0;
    }

//---
    return(rates_total);
}



//+------------------------------------------------------------------+
