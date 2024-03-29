//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// Stoch（ストキャスティクス）
// 過去n期間における最高値と最安値のうち、現在の終値の位置の推移を表示


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_Stoch_len = 15;    // ストキャスティクスの計算期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_Stoch[];

//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         1
#property indicator_plots           1
#property indicator_level1 30
#property indicator_level2 70
#property indicator_separate_window

#property indicator_label1          "Stoch"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_Stoch, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_Stoch, INDICATOR_DATA);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_Stoch_len - 1);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("Stoch(%d)", input_Stoch_len)
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
    if(rates_total < MathMax(input_Stoch_len, 5))
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);
    ArraySetAsSeries(close, true);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(close, i + 1)) {
            int highest_index = iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, input_Stoch_len, i);
            int lowest_index = iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, input_Stoch_len, i);

            double highest = iHigh(_Symbol, PERIOD_CURRENT, highest_index);
            double lowest = iLow(_Symbol, PERIOD_CURRENT, lowest_index);

            if(highest - lowest != 0.0)
                buffer_Stoch[i] = (close[i] - lowest) / (highest - lowest) * 100;
        }
        //---
        else {
            buffer_Stoch[i] = 0.0;
        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
