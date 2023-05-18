//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// PL（サイコロジカル）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_PL_len    = 10;   // サイコロジカルの平均期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_PL[];


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         1
#property indicator_plots           1
#property indicator_minimum         0
#property indicator_maximum         100
#property indicator_level1          30
#property indicator_level2          70
#property indicator_separate_window

#property indicator_label1          "PL"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_PL, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_PL, INDICATOR_DATA);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_PL_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);


// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("PL(%d)", input_PL_len)
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
    if(rates_total < MathMax(input_PL_len, 5))
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(open, true);
    ArraySetAsSeries(close, true);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total -1 ;

    for(int i = end_pos; i >= start_pos; i--) {
        int PL_num = 0;

        for(int j = i; j < i + input_PL_len; j++) {
            if(CheckArrayBounds(open, j + 1) && CheckArrayBounds(close, j + 1)) {
                if(close[j + 1] - open[j + 1] > 0)
                    PL_num += 1;
            }
        }

        buffer_PL[i] =  PL_num * 100 / input_PL_len;
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
