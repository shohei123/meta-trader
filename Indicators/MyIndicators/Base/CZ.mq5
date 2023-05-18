//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// CZ（チョップゾーン）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int                   input_CZ_HL_len        =  30;          // 最高値・最安値の検索期間数
input ENUM_MA_METHOD        input_CZ_MA_type       = MODE_EMA;     // 移動平均線の種別
input ENUM_APPLIED_PRICE    input_CZ_price_type    = PRICE_CLOSE;  // 移動平均線の計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_CZ_EMA_angle[];

double  buffer_MA[];
int     hundle_MA;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         2
#property indicator_plots           1
#property indicator_separate_window

#property indicator_label1          "Chop Zone"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_CZ_EMA_angle, true);
    ArraySetAsSeries(buffer_MA, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_CZ_EMA_angle, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_MA, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, 34);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    hundle_MA = iMA(_Symbol, PERIOD_CURRENT, 34, 0, input_CZ_MA_type, input_CZ_price_type);

    if(hundle_MA == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("チョップゾーン(%d, %d)", 34, input_CZ_HL_len)
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
    if(rates_total < MathMax(input_CZ_HL_len, 34))
        return (0);


// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(hundle_MA);
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
    CopyBuffer(hundle_MA, 0, start_pos, end_pos, buffer_MA);

    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(high, i + input_CZ_HL_len) && CheckArrayBounds(low, i + input_CZ_HL_len) && CheckArrayBounds(buffer_MA, i + 1)) {
            double hlc3 = (close[i] + high[i] + low[i]) / 3;
            int highest_index = iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, input_CZ_HL_len, i);
            double CZ_highest = iHigh(_Symbol, PERIOD_CURRENT, highest_index);
            int lowest_index = iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, input_CZ_HL_len, i);

            double CZ_lowest = iLow(_Symbol, PERIOD_CURRENT, lowest_index);
            double CZ_span = 25 / (CZ_highest - CZ_lowest) * CZ_lowest;
            double CZ_pi = MathArctan(1) * 4;
            double CZ_EMA_34_x1 = 0.0;
            double CZ_EMA_34_x2 = 1.0;
            double CZ_EMA_34_y1 = 0.0;
            double CZ_EMA_34_y2 = (buffer_MA[i + 1] - buffer_MA[i]) / hlc3 * CZ_span;
            double CZ_EMA_34_c = MathSqrt((CZ_EMA_34_x2 - CZ_EMA_34_x1) * (CZ_EMA_34_x2 - CZ_EMA_34_x1) + (CZ_EMA_34_y2 - CZ_EMA_34_y1) * (CZ_EMA_34_y2 - CZ_EMA_34_y1));
            double CZ_EMA_angle_temp = MathRound(180 * MathArccos((CZ_EMA_34_x2 - CZ_EMA_34_x1) / CZ_EMA_34_c) / CZ_pi);

            buffer_CZ_EMA_angle[i] = CZ_EMA_34_y2 > 0 ? CZ_EMA_angle_temp * -1 : CZ_EMA_angle_temp;
        }
        //---
        else {
            buffer_CZ_EMA_angle[i] = 0.0;

        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
