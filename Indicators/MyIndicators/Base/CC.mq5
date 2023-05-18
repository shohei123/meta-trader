//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// CC（コポック・カーブ）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>
#include <MovingAverages.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_CC_ROC_fast_len   = 10;   // ROCの期間（長）
input   int input_CC_ROC_slow_len   = 15;   // ROCの期間（短）
input   int input_CC_WMA_len        = 10;   // 加重移動平均の期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_CC[];
double  buffer_CC_ROC_fast[];
double  buffer_CC_ROC_slow[];
double  buffer_CC_ROC_sum[];

int     handle_CC_ROC_fast;
int     handle_CC_ROC_slow;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers             4
#property indicator_plots               1
#property indicator_separate_window

#property indicator_label1              "CC"
#property indicator_type1               DRAW_LINE
#property indicator_color1              clrCrimson
#property indicator_style1              STYLE_SOLID
#property indicator_width1              2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {


// 入力値の例外処理
    if(input_CC_ROC_fast_len > input_CC_ROC_slow_len) {
        Print("ROCの期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_CC, true);
    ArraySetAsSeries(buffer_CC_ROC_fast, true);
    ArraySetAsSeries(buffer_CC_ROC_slow, true);
    ArraySetAsSeries(buffer_CC_ROC_sum, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_CC, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_CC_ROC_fast, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, buffer_CC_ROC_slow, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_CC_ROC_sum, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_CC_ROC_slow_len + input_CC_WMA_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_CC_ROC_fast_len);
    PlotIndexSetInteger(2, PLOT_DRAW_BEGIN, input_CC_ROC_slow_len);
    PlotIndexSetInteger(3, PLOT_DRAW_BEGIN, input_CC_ROC_slow_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(3, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("CC(%d, %d, %d)", input_CC_ROC_fast_len, input_CC_ROC_slow_len, input_CC_WMA_len)
    );

// ハンドルの取得
    handle_CC_ROC_fast = iCustom(
                             _Symbol,
                             PERIOD_CURRENT,
                             "MyIndicators/Base/ROC.ex5",
                             input_CC_ROC_fast_len
                         );

    handle_CC_ROC_slow = iCustom(
                             _Symbol,
                             PERIOD_CURRENT,
                             "MyIndicators/Base/ROC.ex5",
                             input_CC_ROC_slow_len
                         );

    if(handle_CC_ROC_fast == INVALID_HANDLE || handle_CC_ROC_slow == INVALID_HANDLE) {
        Print("ハンドルの取得に失敗しました。");
        return(INIT_FAILED);
    }


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
    if(rates_total < MathMax(input_CC_ROC_fast_len, 5))
        return (0);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 売買シグナルの生成に使うバッファを取得
    CopyBuffer(handle_CC_ROC_fast, 0, start_pos, end_pos, buffer_CC_ROC_fast);
    CopyBuffer(handle_CC_ROC_slow, 0, start_pos, end_pos, buffer_CC_ROC_slow);

    for(int i = end_pos; i >= start_pos; i--) {
        if(MathIsValidNumber(buffer_CC_ROC_fast[i]) && MathIsValidNumber(buffer_CC_ROC_slow[i]))
            buffer_CC_ROC_sum[i] = buffer_CC_ROC_fast[i] + buffer_CC_ROC_slow[i];
        else
            buffer_CC_ROC_sum[i] = 0.0;

        double sum_value = 0.0;
        int sum_weight = 0;

        for(int j = input_CC_WMA_len; j >= 0; j--) {
            if(CheckArrayBounds(buffer_CC_ROC_sum, i + j) && MathIsValidNumber(buffer_CC_ROC_sum[i + j])) {
                sum_value += buffer_CC_ROC_sum[i + j] * (input_CC_WMA_len - j);
                sum_weight += input_CC_WMA_len - j;
            }
        }

        if(sum_weight != 0) {
            buffer_CC[i] = sum_value / sum_weight;
        }
        //---
        else {
            buffer_CC[i] = 0.0;
        }
    }


//---
    return(rates_total);
}


//+------------------------------------------------------------------+
