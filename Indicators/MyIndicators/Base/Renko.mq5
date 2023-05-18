//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// Renko（練行足）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_Renko_ATR_len         = 15;   // ATRの計算期間
input   int input_Renko_ATR_mult        = 1;    // ATRの乗算値


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_Renko_upper[];
double  buffer_Renko_lower[];
double  buffer_Renko_base[];
double  buffer_Renko_ATR[];

int     handle_Renko_ATR;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers             4
#property indicator_plots               2
#property indicator_chart_window

#property indicator_label1              "Renko upper"
#property indicator_type1               DRAW_LINE
#property indicator_color1              clrYellow
#property indicator_style1              STYLE_SOLID
#property indicator_width1              1

#property indicator_label2              "Renko lower"
#property indicator_type2               DRAW_LINE
#property indicator_color2              clrYellow
#property indicator_style2              STYLE_SOLID
#property indicator_width2              1


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_Renko_upper, true);
    ArraySetAsSeries(buffer_Renko_lower, true);
    ArraySetAsSeries(buffer_Renko_base, true);
    ArraySetAsSeries(buffer_Renko_ATR, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_Renko_upper, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_Renko_lower, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_Renko_base, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_Renko_ATR, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_Renko_ATR_len + 2);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_Renko_ATR_len + 2);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_Renko_ATR = iCustom(_Symbol, PERIOD_CURRENT, "Myindicators/Base/ATR.ex5", input_Renko_ATR_len);

    if(handle_Renko_ATR == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("Renko(%d, %d)", input_Renko_ATR_len, input_Renko_ATR_mult)
    );

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
    if(rates_total < input_Renko_ATR_len + 2)
        return (0);

// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_Renko_ATR);
    ResetLastError();

    if(calculated < rates_total) {
        Print(
            "必要な期間数が指標の計算に使われていません。（", calculated, " バー)。",
            "\n",
            "エラー：", GetLastError()
        );
        return(0);
    }

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(close, true);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - input_Renko_ATR_len - 2;

// 動的配列にバッファを複製
    CopyBuffer(handle_Renko_ATR, 0, start_pos, rates_total - 1, buffer_Renko_ATR);

    for(int i = end_pos ; i >= start_pos; i--) {
        buffer_Renko_base[i] = 0.0;
        buffer_Renko_upper[i] = 0.0;
        buffer_Renko_lower[i] = 0.0;

        if(
            CheckArrayBounds(buffer_Renko_base, i + 1)      &&
            CheckArrayBounds(buffer_Renko_upper, i + 1)     &&
            CheckArrayBounds(buffer_Renko_lower, i + 1)     &&
            MathIsValidNumber(buffer_Renko_base[i + 1])     &&
            MathIsValidNumber(buffer_Renko_upper[i + 1])    &&
            MathIsValidNumber(buffer_Renko_lower[i + 1])
        ) {
            buffer_Renko_base[i] = buffer_Renko_base[i + 1];
            buffer_Renko_upper[i] = buffer_Renko_upper[i + 1];
            buffer_Renko_lower[i] = buffer_Renko_lower[i + 1];
        }

        // 練行足の動作必要の判定
        int direction = 0;

        if(close[i] > buffer_Renko_upper[i])
            direction = 1;
        if(close[i] < buffer_Renko_lower[i])
            direction = -1;

        // upperとlowerの再計算
        if (buffer_Renko_base[i] == 0.0 || direction != 0) {
            buffer_Renko_base[i] = close[i];
            buffer_Renko_upper[i] = buffer_Renko_base[i] + buffer_Renko_ATR[i] * input_Renko_ATR_mult;
            buffer_Renko_lower[i] = buffer_Renko_base[i] - buffer_Renko_ATR[i] * input_Renko_ATR_mult;
        }
    }


//---
    return(rates_total);
}


//+------------------------------------------------------------------+
