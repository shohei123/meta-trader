//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// BBP（ブルベアパワー）


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int                   input_BBP_MA_len        =  20;          // 移動平均線の期間数
input ENUM_MA_METHOD        input_BBP_MA_type       = MODE_EMA;     // 移動平均線の種別
input ENUM_APPLIED_PRICE    input_BBP_price_type    = PRICE_CLOSE;      // 移動平均線の計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_bull_power[];
double  buffer_bear_power[];
double  buffer_balance[];
double  buffer_MA[];

int     handle_MA;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         4
#property indicator_plots           3
#property indicator_separate_window

#property indicator_label1          "Bull Power"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2

#property indicator_label2          "Bear Power"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrBlue
#property indicator_style2          STYLE_SOLID
#property indicator_width2          2

#property indicator_label3          "Balance"
#property indicator_type3           DRAW_LINE
#property indicator_color3          clrGreen
#property indicator_style3          STYLE_SOLID
#property indicator_width3          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_bull_power, true);
    ArraySetAsSeries(buffer_bear_power, true);
    ArraySetAsSeries(buffer_balance, true);
    ArraySetAsSeries(buffer_MA, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_bull_power, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_bear_power, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_balance, INDICATOR_DATA);
    SetIndexBuffer(3, buffer_MA, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_BBP_MA_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_BBP_MA_len);
    PlotIndexSetInteger(2, PLOT_DRAW_BEGIN, input_BBP_MA_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(3, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_MA = iMA(_Symbol, PERIOD_CURRENT, input_BBP_MA_len, 0, input_BBP_MA_type, input_BBP_price_type);

    if(handle_MA == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(INDICATOR_SHORTNAME, StringFormat("ブルベアパワー(%d)", input_BBP_MA_len));


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
    if(rates_total < MathMax(input_BBP_MA_len, 5))
        return (0);

// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_MA);
    ResetLastError();

    if(calculated < rates_total) {
        Print(
            "必要な期間数が指標の計算に使われていません。（", calculated, " バー)。",
            "\n",
            "エラー：", GetLastError()
        );
        return(0);
    }

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

// 移動平均線の値を動的配列に複製
    CopyBuffer(handle_MA, 0, start_pos, end_pos, buffer_MA);

    for(int i = 0; i < end_pos; i++) {
        buffer_bull_power[i] = high[i] - buffer_MA[i];
        buffer_bear_power[i] = low[i] - buffer_MA[i];
        buffer_balance[i] = buffer_bull_power[i] + buffer_bear_power[i];
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
