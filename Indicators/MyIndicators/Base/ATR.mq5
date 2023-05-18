//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// ATR


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+-------------------------------------------------------h-----------+
//| Input
//+------------------------------------------------------------------+
input   int                   input_ATR_len                 = 15;       // 平均化の期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_ATR[];
double  buffer_TR[];

//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         2
#property indicator_plots           1
#property indicator_separate_window

#property indicator_label1          "ATR"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_ATR, true);
    ArraySetAsSeries(buffer_TR, true);


// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_ATR, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_TR, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_ATR_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("ATR(%d)", input_ATR_len)
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
    if(rates_total < MathMax(input_ATR_len, 5))
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
        if(
            CheckArrayBounds(high, i + 1)   &&
            CheckArrayBounds(low, i + 1)    &&
            CheckArrayBounds(close, i + 1)
        ) {
            double hl = high[i] - low[i];
            double hc = MathAbs(high[i] - close[i + 1]);
            double cl = MathAbs(close[i] - low[i + 1]);
            double max = MathMax(hl, hc);
            buffer_TR[i] = MathMax(max, cl);
        }
        //---
        else {
            buffer_TR[i] = high[i] - low[i];
        }
    }

    // 修正移動平均線でATRを算出
    for(int i = end_pos; i >= start_pos; i--) {
        buffer_ATR[i] = 0.0;

        if(
            CheckArrayBounds(buffer_ATR, i + 1) &&
            MathIsValidNumber(buffer_ATR[i + 1])
        ) {
            buffer_ATR[i] =  (buffer_TR[i] + (input_ATR_len - 1 ) * buffer_ATR[i + 1]) / input_ATR_len;
        }
        //---
        else {
            double sum = 0.0;

            for(int j = 0; j <= input_ATR_len; j++) {
                if(CheckArrayBounds(buffer_TR, i + j)) {
                    sum += buffer_TR[i + j];
                }
            }
            buffer_ATR[i] = sum / input_ATR_len;
        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
