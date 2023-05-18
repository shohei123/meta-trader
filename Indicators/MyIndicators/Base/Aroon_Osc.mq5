//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// Aroon Oscアルーン・オシレーター


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_Aroon_Osc_len = 14;   // アルーン・オシレーターの計測期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_Aroon_Osc[];
double  buffer_Aroon_Osc_upper[];
double  buffer_Aroon_Osc_lower[];


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         3
#property indicator_plots           1
#property indicator_level1          80
#property indicator_level2          -80
#property indicator_separate_window

#property indicator_label1          "Aroon_Osc"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrGreen
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2

#property indicator_label2          "Aroon_Osc"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrCrimson
#property indicator_style2          STYLE_SOLID
#property indicator_width2          2

#property indicator_label3          "Aroon_Osc"
#property indicator_type3           DRAW_LINE
#property indicator_color3          clrDeepSkyBlue
#property indicator_style3          STYLE_SOLID
#property indicator_width3          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_Aroon_Osc, true);
    ArraySetAsSeries(buffer_Aroon_Osc_upper, true);
    ArraySetAsSeries(buffer_Aroon_Osc_lower, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_Aroon_Osc, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_Aroon_Osc_upper, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, buffer_Aroon_Osc_lower, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_Aroon_Osc_len + 1);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("Arron Oscillator(%d)", input_Aroon_Osc_len)
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
    if(rates_total < MathMax(input_Aroon_Osc_len + 1, 5))
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);


// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(high, i + input_Aroon_Osc_len + 1) && CheckArrayBounds(low, i + input_Aroon_Osc_len + 1)) {
            int highest_index_offset = iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, input_Aroon_Osc_len + 1, i) * -1;
            int lowest_index_offset = iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, input_Aroon_Osc_len + 1, i) * -1;

            buffer_Aroon_Osc_upper[i] = 100 * (highest_index_offset + input_Aroon_Osc_len) / input_Aroon_Osc_len;
            buffer_Aroon_Osc_lower[i] = 100 * (lowest_index_offset + input_Aroon_Osc_len) / input_Aroon_Osc_len;
            buffer_Aroon_Osc[i] = buffer_Aroon_Osc_upper[i] - buffer_Aroon_Osc_lower[i];
        }
        //---
        else {
            buffer_Aroon_Osc_upper[i] = 0.0;
            buffer_Aroon_Osc_lower[i] = 0.0;
            buffer_Aroon_Osc[i] = 0.0;
        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
