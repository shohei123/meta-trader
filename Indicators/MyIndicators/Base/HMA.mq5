//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// HMA（ハル移動平均線）


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int                   input_HMA_len           = 20;           // HMA移動平均線の期間
input ENUM_APPLIED_PRICE    input_HMA_price_type    = PRICE_CLOSE;  // 移動平均線の計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_HMA[];
double  buffer_WMA_full[];
double  buffer_WMA_half[];

int     handle_WMA_full;
int     handle_WMA_half;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         3
#property indicator_plots           1
#property indicator_chart_window

#property indicator_label1          "HMA"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_HMA, true);
    ArraySetAsSeries(buffer_WMA_full, true);
    ArraySetAsSeries(buffer_WMA_half, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_HMA, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_WMA_full, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, buffer_WMA_half, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_HMA_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_WMA_full = iMA(_Symbol, PERIOD_CURRENT, input_HMA_len, 0, MODE_LWMA, input_HMA_price_type);
    handle_WMA_half = iMA(_Symbol, PERIOD_CURRENT, (int)MathCeil(input_HMA_len / 2), 0, MODE_LWMA, input_HMA_price_type);

    if(handle_WMA_full == INVALID_HANDLE || handle_WMA_half == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(INDICATOR_SHORTNAME, StringFormat("HMA(%d)", input_HMA_len));

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
    if(rates_total < MathMax(input_HMA_len, 5))
        return (0);


// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_WMA_full);
    ResetLastError();

    if(calculated < rates_total) {
        Print(
            "必要な期間数が指標の計算に使われていません。（", calculated, " バー)。",
            "\n",
            "エラー：", GetLastError()
        );
        return(0);
    }

    calculated = BarsCalculated(handle_WMA_half);
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

// 動的配列にバッファを複製
    CopyBuffer(handle_WMA_full, 0, start_pos, end_pos, buffer_WMA_full);
    CopyBuffer(handle_WMA_half, 0, start_pos, end_pos, buffer_WMA_half);

    for(int i = start_pos; i < end_pos; i++) {
        buffer_HMA[i] = buffer_WMA_half[i] * 2 - buffer_WMA_full[i];
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
