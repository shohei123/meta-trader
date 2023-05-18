//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// KC（ケルトナー。チャネル）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MovingAverages.mqh>
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int                 input_KC_len            = 20;           // 移動平均線・ATRの期間
input   int                 input_KC_mult           = 2;            // ATRの乗算値
input   ENUM_APPLIED_PRICE  input_KC_price_type     = PRICE_CLOSE;  // 計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_KC_base[];
double  buffer_KC_upper[];
double  buffer_KC_lower[];
double  buffer_KC_TR[];
double  buffer_KC_ATR[];

int     handle_KC_EMA;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         5
#property indicator_plots           3
#property indicator_chart_window

#property indicator_label1          "KC_base"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrLime
#property indicator_style1          STYLE_DASH
#property indicator_width1          2

#property indicator_label2          "KC_upper"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrGreenYellow
#property indicator_style2          STYLE_SOLID
#property indicator_width2          1

#property indicator_label3          "KC_lower"
#property indicator_type3           DRAW_LINE
#property indicator_color3          clrGreenYellow
#property indicator_style3          STYLE_SOLID
#property indicator_width3          1



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_KC_base, true);
    ArraySetAsSeries(buffer_KC_upper, true);
    ArraySetAsSeries(buffer_KC_lower, true);
    ArraySetAsSeries(buffer_KC_TR, true);
    ArraySetAsSeries(buffer_KC_ATR, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_KC_base, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_KC_upper, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_KC_lower, INDICATOR_DATA);
    SetIndexBuffer(3, buffer_KC_TR, INDICATOR_CALCULATIONS);
    SetIndexBuffer(4, buffer_KC_ATR, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_KC_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_KC_len);
    PlotIndexSetInteger(2, PLOT_DRAW_BEGIN, input_KC_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_KC_EMA = iMA(_Symbol, PERIOD_CURRENT, input_KC_len, 0, MODE_EMA, input_KC_price_type);

    if(handle_KC_EMA == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("KK(%d, %d)", input_KC_len, input_KC_mult)
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
    if(rates_total < MathMax(input_KC_len, 5))
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);
    ArraySetAsSeries(close, true);

// 指標ハンドル内の時系列配列において、最新のインデックスを0とした場合に
// 何期間前（end_pos）までの指標値を遡って複製するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 初回または誤動作（prev_calculatedが大きすぎる）なので、全期間を複製対象にする
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    CopyBuffer(handle_KC_EMA, 0, start_pos, end_pos, buffer_KC_base);

    for(int i = end_pos; i  >= start_pos; i--) {
        if(CheckArrayBounds(close, i + 1)) {
            double temp1 = high[i] - close[i + 1];
            double temp2 = high[i] - low[i];
            double temp3 = close[i + 1] - low[i];

            double temp_max = MathMax(temp1, temp2);
            buffer_KC_TR[i] = MathMax(temp_max, temp3);

        }
        //---
        else {
            buffer_KC_TR[i] = 0.0;
        }

    }

// EMA仕様のATRの作成
    ExponentialMAOnBuffer(rates_total, prev_calculated, start_pos, input_KC_len, buffer_KC_TR, buffer_KC_ATR);


    for(int i = end_pos; i >= start_pos; i--) {
        buffer_KC_upper[i] = buffer_KC_base[i] + input_KC_mult * buffer_KC_ATR[i];
        buffer_KC_lower[i] = buffer_KC_base[i] - input_KC_mult * buffer_KC_ATR[i];
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
