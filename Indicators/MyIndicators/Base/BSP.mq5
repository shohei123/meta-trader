//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// BSP（売買圧力）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>
#include <MovingAverages.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int   input_BSP_len  =  15;      // 平滑化の期間数


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  BSP_buy_pressure[];
double  BSP_sell_pressure[];
double  buffer_BSP_cl[];
double  buffer_BSP_hc[];


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         4
#property indicator_plots           2
#property indicator_separate_window

#property indicator_label1          "BSP Buy Preesure"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2

#property indicator_label2          "BSP Sell Preesure"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrBlue
#property indicator_style2          STYLE_SOLID
#property indicator_width2          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(BSP_buy_pressure, true);
    ArraySetAsSeries(BSP_sell_pressure, true);
    ArraySetAsSeries(buffer_BSP_cl, true);
    ArraySetAsSeries(buffer_BSP_hc, true);


// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, BSP_buy_pressure, INDICATOR_DATA);
    SetIndexBuffer(1, BSP_sell_pressure, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_BSP_cl, INDICATOR_DATA);
    SetIndexBuffer(3, buffer_BSP_hc, INDICATOR_CALCULATIONS);
  

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_BSP_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_BSP_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("BBSP(%d)", input_BSP_len)
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
    if(rates_total < MathMax(input_BSP_len, 5))
        return (0);

// 指標ハンドル内の時系列配列において、最新のインデックスを0とした場合に
// 何期間前（end_pos）までの指標値を遡って複製するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 初回または誤動作（prev_calculatedが大きすぎる）なので、全期間を複製対象にする
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);
    ArraySetAsSeries(close, true);


    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(high, i + 1) && CheckArrayBounds(low, i + 1)) {
            buffer_BSP_cl[i] = close[i] - low[i + 1];
            buffer_BSP_hc[i] = high[i + 1] - close[i];
        }
        //---
        else {
            buffer_BSP_cl[i] = 0.0;
            buffer_BSP_hc[i] = 0.0;
        }
    }


    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        input_BSP_len,
        buffer_BSP_cl,
        BSP_buy_pressure
    );

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        input_BSP_len,
        buffer_BSP_hc,
        BSP_sell_pressure

    );


//---
    return(rates_total);
}


//+------------------------------------------------------------------+
