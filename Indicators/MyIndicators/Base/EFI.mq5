//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// EFI（エルダー・フォース・インデックス）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MovingAverages.mqh>
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int   input_EFI_len   = 20;   // EFIの算出に使う期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double      buffer_EFI[];
double      buffer_source[];


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property   indicator_separate_window
#property   indicator_buffers           2
#property   indicator_plots             1

#property   indicator_label1          "EFI"
#property   indicator_type1           DRAW_LINE
#property   indicator_color1          clrCrimson
#property   indicator_style1          STYLE_SOLID
#property   indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_EFI, true);
    ArraySetAsSeries(buffer_source, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_EFI, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_source, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_EFI_len);

// nullになる可能性のあるバッファの対策
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("EFI(%d)", input_EFI_len)
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
    if(rates_total < MathMax(input_EFI_len, 5))
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(close, true);
    ArraySetAsSeries(tick_volume, true);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(close, i + 1)) {
            buffer_source[i] = (close[i] - close[i + 1]) * tick_volume[i];
        } else {
            buffer_source[i] = 0.0;
        }
    }

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        input_EFI_len,
        buffer_source,
        buffer_EFI
    );


//---
    return(rates_total);
}


//+------------------------------------------------------------------+
