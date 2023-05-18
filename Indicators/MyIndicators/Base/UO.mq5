//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// UO（アルティメット・オシレーター）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int   input_UO_avg_short_len      = 7;    // BP/TRの平均化の期間（短期）
input int   input_UO_avg_medium_len     = 14;   // BP/TRの平均化の期間（中期）
input int   input_UO_avg_long_len       = 28;   // BP/TRの平均化の期間（長期）


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_UO_main[];
double  buffer_UO_bp[];
double  buffer_UO_tr[];


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         3
#property indicator_plots           1
#property indicator_level1          50
#property indicator_separate_window

#property indicator_label1          "UO"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| UO_average
//+------------------------------------------------------------------+
double UO_average(double & bp[], double & tr[], int length, int start_index) {
    double bp_sum = 0.0;
    double tr_sum = 0.0;

    for(int i = start_index; i < start_index + length && i < ArraySize(bp) && i < ArraySize(tr); i++) {
        bp_sum += bp[i];
        tr_sum += tr[i];
    }

//---
    return(bp_sum / tr_sum);

}


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {


// 入力値の例外処理
    if(input_UO_avg_short_len > input_UO_avg_long_len || input_UO_avg_medium_len > input_UO_avg_long_len || input_UO_avg_short_len > input_UO_avg_medium_len) {
        Print("平均化の期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_UO_main, true);
    ArraySetAsSeries(buffer_UO_bp, true);
    ArraySetAsSeries(buffer_UO_tr, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_UO_main, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_UO_bp, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, buffer_UO_tr, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_UO_avg_long_len - 1);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat(
            "UO(%d, %d, %d,)",
            input_UO_avg_short_len, input_UO_avg_medium_len, input_UO_avg_long_len
        )
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
    if(rates_total < MathMax(input_UO_avg_long_len, 5))
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

    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(close, i + 1)) {
            buffer_UO_bp[i] = close[i] - MathMin(low[i], close[i + 1]);
            buffer_UO_tr[i] = MathMax(high[i], close[i + 1]) - MathMin(low[i], close[i + 1]);

            buffer_UO_main[i] = 100 * (4 * UO_average(buffer_UO_bp, buffer_UO_tr, input_UO_avg_short_len, i) +
                                       2 * UO_average(buffer_UO_bp, buffer_UO_tr, input_UO_avg_medium_len, i) +
                                       UO_average(buffer_UO_bp, buffer_UO_tr, input_UO_avg_long_len, i)) / 7;
        }
        //---
        else {
            buffer_UO_bp[i] = 0.0;
            buffer_UO_tr[i] = 0.0;
            buffer_UO_main[i]  = 0.0;
        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
