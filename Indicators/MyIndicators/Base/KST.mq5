//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// KST（ノウ・シュア・シング）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int   input_KST_ROC1_len     = 10;       // ROC1の算出期間
input int   input_KST_ROC2_len     = 15;       // ROC2の算出期間
input int   input_KST_ROC3_len     = 20;       // ROC3の算出期間
input int   input_KST_ROC4_len     = 30;       // ROC4の算出期間
input int   input_KST_MA1_len      = 10;       // ROC1～3の平滑化の期間
input int   input_KST_MA2_len      = 15;       // ROC4の平滑化の期間
input int   input_KST_signal_len   = 10;       // シグナルラインの平滑化の期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_KST_main[];
double  buffer_KST_signal[];

double  buffer_KST_ROC1[];
double  buffer_KST_ROC2[];
double  buffer_KST_ROC3[];
double  buffer_KST_ROC4[];

double  buffer_KST_ROC1_MA[];
double  buffer_KST_ROC2_MA[];
double  buffer_KST_ROC3_MA[];
double  buffer_KST_ROC4_MA[];

int     handle_KST_ROC1;
int     handle_KST_ROC2;
int     handle_KST_ROC3;
int     handle_KST_ROC4;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         10
#property indicator_plots           2
#property indicator_separate_window

#property indicator_label1          "KST main"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2

#property indicator_label2          "KST signal"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrDeepSkyBlue
#property indicator_style2          STYLE_SOLID
#property indicator_width2          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_KST_main, true);
    ArraySetAsSeries(buffer_KST_signal, true);
    ArraySetAsSeries(buffer_KST_ROC1, true);
    ArraySetAsSeries(buffer_KST_ROC2, true);
    ArraySetAsSeries(buffer_KST_ROC3, true);
    ArraySetAsSeries(buffer_KST_ROC4, true);
    ArraySetAsSeries(buffer_KST_ROC1_MA, true);
    ArraySetAsSeries(buffer_KST_ROC2_MA, true);
    ArraySetAsSeries(buffer_KST_ROC3_MA, true);
    ArraySetAsSeries(buffer_KST_ROC4_MA, true);


// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_KST_main, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_KST_signal, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_KST_ROC1, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_KST_ROC2, INDICATOR_CALCULATIONS);
    SetIndexBuffer(4, buffer_KST_ROC3, INDICATOR_CALCULATIONS);
    SetIndexBuffer(5, buffer_KST_ROC4, INDICATOR_CALCULATIONS);
    SetIndexBuffer(6, buffer_KST_ROC1_MA, INDICATOR_CALCULATIONS);
    SetIndexBuffer(7, buffer_KST_ROC2_MA, INDICATOR_CALCULATIONS);
    SetIndexBuffer(8, buffer_KST_ROC3_MA, INDICATOR_CALCULATIONS);
    SetIndexBuffer(9, buffer_KST_ROC4_MA, INDICATOR_CALCULATIONS);


// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_KST_ROC4_len + input_KST_MA2_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_KST_ROC4_len + input_KST_MA2_len + input_KST_signal_len);

// nullになる可能性のあるバッファの対策
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(INDICATOR_SHORTNAME, "KST");

// ハンドルの取得
    handle_KST_ROC1 = iCustom(
                          _Symbol,
                          PERIOD_CURRENT,
                          "MyIndicators/Base/ROC.ex5",
                          input_KST_ROC1_len
                      );

    handle_KST_ROC2 = iCustom(
                          _Symbol,
                          PERIOD_CURRENT,
                          "MyIndicators/Base/ROC.ex5",
                          input_KST_ROC2_len
                      );

    handle_KST_ROC3 = iCustom(
                          _Symbol,
                          PERIOD_CURRENT,
                          "MyIndicators/Base/ROC.ex5",
                          input_KST_ROC3_len
                      );

    handle_KST_ROC4 = iCustom(
                          _Symbol,
                          PERIOD_CURRENT,
                          "MyIndicators/Base/ROC.ex5",
                          input_KST_ROC4_len
                      );

    if(
        handle_KST_ROC1 == INVALID_HANDLE ||
        handle_KST_ROC2 == INVALID_HANDLE ||
        handle_KST_ROC3 == INVALID_HANDLE ||
        handle_KST_ROC4 == INVALID_HANDLE
    )
        return(INIT_FAILED);


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
    if(rates_total < MathMax(input_KST_ROC4_len + input_KST_MA2_len, 5))
        return (0);

// 指標ハンドル内の時系列配列において、最新のインデックスを0とした場合に
// 何期間前（end_pos）までの指標値を遡って複製するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 初回または誤動作（prev_calculatedが大きすぎる）なので、全期間を複製対象にする
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 売買シグナルの生成に使うバッファを取得
    CopyBuffer(handle_KST_ROC1, 0, start_pos, end_pos, buffer_KST_ROC1);
    CopyBuffer(handle_KST_ROC2, 0, start_pos, end_pos, buffer_KST_ROC2);
    CopyBuffer(handle_KST_ROC3, 0, start_pos, end_pos, buffer_KST_ROC3);
    CopyBuffer(handle_KST_ROC4, 0, start_pos, end_pos, buffer_KST_ROC4);



    for(int i = end_pos; i >= start_pos; i--) {
        double sum = 0.0;

        for(int j = 0; j < input_KST_MA1_len; j++)
            if(CheckArrayBounds(buffer_KST_ROC1, i + j))
                sum += buffer_KST_ROC1[i + j];

        buffer_KST_ROC1_MA[i] = sum / input_KST_MA1_len;
    }

    for(int i = end_pos; i >= start_pos; i--) {
        double sum = 0.0;

        for(int j = 0; j < input_KST_MA1_len; j++)
            if(CheckArrayBounds(buffer_KST_ROC2, i + j))
                sum += buffer_KST_ROC2[i + j];

        buffer_KST_ROC2_MA[i] = sum / input_KST_MA1_len;
    }

    for(int i = end_pos; i >= start_pos; i--) {
        double sum = 0.0;

        for(int j = 0; j < input_KST_MA1_len; j++)
            if(CheckArrayBounds(buffer_KST_ROC3, i + j))
                sum += buffer_KST_ROC3[i + j];

        buffer_KST_ROC3_MA[i] = sum / input_KST_MA1_len;
    }

    for(int i = end_pos; i >= start_pos; i--) {
        double sum = 0.0;

        for(int j = 0; j < input_KST_MA2_len; j++)
            if(CheckArrayBounds(buffer_KST_ROC4, i + j))
                sum += buffer_KST_ROC4[i + j];

        buffer_KST_ROC4_MA[i] = sum / input_KST_MA2_len;
    }


    for(int i = end_pos; i >= start_pos; i--) {
        buffer_KST_main[i] = buffer_KST_ROC1_MA[i] + buffer_KST_ROC2_MA[i] * 2 + buffer_KST_ROC3_MA[i] * 3 + buffer_KST_ROC4_MA[i] * 4;
    }

    for(int i = end_pos; i >= start_pos; i--) {
        double sum = 0.0;

        for(int j = 0; j < input_KST_signal_len; j++)
            if(CheckArrayBounds(buffer_KST_main, i + j))
                sum += buffer_KST_main[i + j];

        buffer_KST_signal[i] = sum / input_KST_signal_len;
    }


//---
    return(rates_total);
}


//+------------------------------------------------------------------+
