//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// TSI（トゥルー・ストレンシジ・インデックス）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>
#include <MovingAverages.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_TSI_first_len     = 30;   // 1回目の平滑化の期間（長）
input   int input_TSI_second_len    = 10;   // 2回目の平滑化の期間（短）
input   int input_TSI_signal_len    = 10;   // シグナルの平滑化の期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_TSI_base[];
double  buffer_TSI_signal[];
double  buffer_TSI_cc[];
double  buffer_TSI_cc_abs[];
double  buffer_TSI_EMA1_cc[];
double  buffer_TSI_EMA1_cc_abs[];
double  buffer_TSI_EMA2_cc[];
double  buffer_TSI_EMA2_cc_abs[];


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers             8
#property indicator_plots               2
#property indicator_separate_window

#property indicator_label1              "TSI main"
#property indicator_type1               DRAW_LINE
#property indicator_color1              clrCrimson
#property indicator_style1              STYLE_SOLID
#property indicator_width1              2

#property indicator_label2              "TSI signal"
#property indicator_type2               DRAW_LINE
#property indicator_color2              clrDeepSkyBlue
#property indicator_style2              STYLE_SOLID
#property indicator_width2              2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {


// 入力値の例外処理
    if(input_TSI_second_len > input_TSI_first_len) {
        Print("移動平均線の期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_TSI_base, true);
    ArraySetAsSeries(buffer_TSI_signal, true);
    ArraySetAsSeries(buffer_TSI_cc, true);
    ArraySetAsSeries(buffer_TSI_cc_abs, true);
    ArraySetAsSeries(buffer_TSI_EMA1_cc, true);
    ArraySetAsSeries(buffer_TSI_EMA1_cc_abs, true);
    ArraySetAsSeries(buffer_TSI_EMA2_cc, true);
    ArraySetAsSeries(buffer_TSI_EMA2_cc_abs, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_TSI_base, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_TSI_signal, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_TSI_cc, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_TSI_cc_abs, INDICATOR_CALCULATIONS);
    SetIndexBuffer(4, buffer_TSI_EMA1_cc, INDICATOR_CALCULATIONS);
    SetIndexBuffer(5, buffer_TSI_EMA1_cc_abs, INDICATOR_CALCULATIONS);
    SetIndexBuffer(6, buffer_TSI_EMA2_cc, INDICATOR_CALCULATIONS);
    SetIndexBuffer(7, buffer_TSI_EMA2_cc_abs, INDICATOR_CALCULATIONS);


// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_TSI_second_len + input_TSI_signal_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_TSI_second_len + input_TSI_signal_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("TSI(%d, %d, %d)", input_TSI_first_len, input_TSI_second_len, input_TSI_signal_len)
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
    if(rates_total < input_TSI_second_len + input_TSI_signal_len)
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(close, true);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(close, i + 1)) {
            buffer_TSI_cc[i] = close[i] - close[i + 1];
            buffer_TSI_cc_abs[i] = MathAbs(buffer_TSI_cc[i]);
        }
        //---
        else {
            buffer_TSI_cc[i] = 0.0;
            buffer_TSI_cc_abs[i] = 0.0;
        }
    }

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        input_TSI_first_len,
        buffer_TSI_cc,
        buffer_TSI_EMA1_cc
    );

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        input_TSI_first_len,
        buffer_TSI_cc_abs,
        buffer_TSI_EMA1_cc_abs
    );

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        input_TSI_second_len,
        buffer_TSI_EMA1_cc,
        buffer_TSI_EMA2_cc
    );

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        input_TSI_second_len,
        buffer_TSI_EMA1_cc_abs,
        buffer_TSI_EMA2_cc_abs
    );

    for(int i = end_pos; i >= start_pos; i--) {
        if(buffer_TSI_EMA2_cc_abs[i] != 0.0) {
            buffer_TSI_base[i] = 100 * buffer_TSI_EMA2_cc[i] / buffer_TSI_EMA2_cc_abs[i];
        } else {
            buffer_TSI_base[i] = 0.0;
        }
    }

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        input_TSI_signal_len,
        buffer_TSI_base,
        buffer_TSI_signal
    );

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
