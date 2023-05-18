//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// MA_S（移動平均線と価格の比較）


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int                   input_MA_S_len          = 10;           // 移動平均線の期間
input ENUM_MA_METHOD        input_MA_type           = MODE_SMA;     // 移動平均線の種別
input ENUM_APPLIED_PRICE    input_price_type        = PRICE_CLOSE;  // 移動平均線の計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_MA[];

int     hundle_MA;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         1
#property indicator_plots           1
#property indicator_chart_window

#property indicator_label1          "MA"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_MA, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_MA, INDICATOR_DATA);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_MA_S_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    hundle_MA = iMA(_Symbol, PERIOD_CURRENT, input_MA_S_len, 0, input_MA_type, input_price_type);

// 指標名
    IndicatorSetString(INDICATOR_SHORTNAME, StringFormat("MA(%d)", input_MA_S_len));

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
    if(rates_total < MathMax(input_MA_S_len, 5))
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

// 指標ハンドル内の時系列配列において、最新のインデックスを0とした場合に
// 何期間前（end_pos）までの指標値を遡って複製するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 初回または誤動作（prev_calculatedが大きすぎる）なので、全期間を複製対象にする
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    CopyBuffer(hundle_MA, 0, start_pos, end_pos, buffer_MA);

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
