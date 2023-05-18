//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// MOM（モメンタム）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int   input_MOM_len   =  20;  // モメンタムの比較期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_MOM[];


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         1
#property indicator_plots           1
#property indicator_separate_window

#property indicator_label1          "MOM"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_MOM, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_MOM, INDICATOR_DATA);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_MOM_len);

// nullになる可能性のあるバッファの対策
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(INDICATOR_SHORTNAME, StringFormat("MOM(%d)", input_MOM_len));

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
    if(rates_total < MathMax(input_MOM_len, 5))
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(close, true);

// 指標ハンドル内の時系列配列において、最新のインデックスを0とした場合に
// 何期間前（end_pos）までの指標値を遡って複製するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 初回または誤動作（prev_calculatedが大きすぎる）なので、全期間を複製対象にする
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 売買シグナルの生成
    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(close, i + input_MOM_len))
            buffer_MOM[i] = close[i] - close[i + input_MOM_len];
        else
            buffer_MOM[i] = 0.0;
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
