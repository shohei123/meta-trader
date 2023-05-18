//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// AO（オーサム・オシレーター）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+-------------------------------------------------------h-----------+
//| Input
//+------------------------------------------------------------------+
input   int                   input_AO_MA_fast_len          = 5;              // 速い移動平均線の期間
input   int                   input_AO_MA_slow_len          = 30;             // 遅い移動平均線の期間
input   int                   input_AO_diff                 = 1;              // AOの比較対象の過去期間
input   ENUM_MA_METHOD        input_AO_MA_type              = MODE_SMA;       // 移動平均線の種別
input   ENUM_APPLIED_PRICE    input_AO_price_type           = PRICE_MEDIAN;   // 移動平均線の計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_AO[];
double  buffer_AO_diff[];
double  buffer_AO_MA_fast[];
double  buffer_AO_MA_slow[];

int     handle_AO_MA_fast;
int     handle_AO_MA_slow;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         4
#property indicator_plots           1
#property indicator_separate_window

#property indicator_label1          "AO"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {


// 入力値の例外処理
    if(input_AO_MA_fast_len > input_AO_MA_slow_len) {
        Print("移動平均線の期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_AO, true);
    ArraySetAsSeries(buffer_AO_diff, true);
    ArraySetAsSeries(buffer_AO_MA_fast, true);
    ArraySetAsSeries(buffer_AO_MA_slow, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_AO, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_AO_diff, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, buffer_AO_MA_fast, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_AO_MA_slow, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_AO_MA_slow_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_AO_MA_fast = iMA(_Symbol, PERIOD_CURRENT, input_AO_MA_fast_len, 0, input_AO_MA_type, input_AO_price_type);
    handle_AO_MA_slow = iMA(_Symbol, PERIOD_CURRENT, input_AO_MA_slow_len, 0, input_AO_MA_type, input_AO_price_type);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("AO(%d, %d, %d)", input_AO_MA_fast_len, input_AO_MA_slow_len, input_AO_diff)
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
    if(rates_total < MathMax(input_AO_MA_slow_len, 5))
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
    CopyBuffer(handle_AO_MA_fast, 0, start_pos, end_pos, buffer_AO_MA_fast);
    CopyBuffer(handle_AO_MA_slow, 0, start_pos, end_pos, buffer_AO_MA_slow);

    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(buffer_AO, i + 1)) {
            buffer_AO[i] = buffer_AO_MA_fast[i] - buffer_AO_MA_slow[i];
            buffer_AO_diff[i] = buffer_AO[i] - buffer_AO[i + 1];
        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
