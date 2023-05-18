//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// MA_T（3本の移動平均線の比較）


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int                   input_MA_T_fast_len     = 10;           // 速い移動平均線の期間
input int                   input_MA_T_medium_len   = 20;           // 中速の移動平均線の期間
input int                   input_MA_T_slow_len     = 30;           // 遅い移動平均線の期間
input ENUM_MA_METHOD        input_MA_T_type         = MODE_SMA;     // 移動平均線の種別
input ENUM_APPLIED_PRICE    input_MA_T_price_type   = PRICE_CLOSE;  // 移動平均線の計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_MA_T_fast[];
double  buffer_MA_T_medium[];
double  buffer_MA_T_slow[];

int     hundle_MA_T_fast;
int     hundle_MA_T_medium;
int     hundle_MA_T_slow;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         3
#property indicator_plots           3
#property indicator_chart_window

#property indicator_label1          "MA_fast"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2

#property indicator_label2          "MA_medium"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrGreen
#property indicator_style2          STYLE_SOLID
#property indicator_width2          2

#property indicator_label3          "MA_slow"
#property indicator_type3           DRAW_LINE
#property indicator_color3          clrDeepSkyBlue
#property indicator_style3          STYLE_SOLID
#property indicator_width3          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 入力値の例外処理
    if(input_MA_T_fast_len > input_MA_T_slow_len || input_MA_T_medium_len > input_MA_T_slow_len || input_MA_T_fast_len > input_MA_T_medium_len) {
        Print("移動平均線の期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_MA_T_fast, true);
    ArraySetAsSeries(buffer_MA_T_medium, true);
    ArraySetAsSeries(buffer_MA_T_slow, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_MA_T_fast, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_MA_T_medium, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_MA_T_slow, INDICATOR_DATA);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_MA_T_fast_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_MA_T_medium_len);
    PlotIndexSetInteger(2, PLOT_DRAW_BEGIN, input_MA_T_slow_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(2, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    hundle_MA_T_fast = iMA(_Symbol, PERIOD_CURRENT, input_MA_T_fast_len, 0, input_MA_T_type, input_MA_T_price_type);
    hundle_MA_T_medium = iMA(_Symbol, PERIOD_CURRENT, input_MA_T_medium_len, 0, input_MA_T_type, input_MA_T_price_type);
    hundle_MA_T_slow = iMA(_Symbol, PERIOD_CURRENT, input_MA_T_slow_len, 0, input_MA_T_type, input_MA_T_price_type);

    if(hundle_MA_T_fast == INVALID_HANDLE)
        return(INIT_FAILED);
        
    if(hundle_MA_T_medium == INVALID_HANDLE)
        return(INIT_FAILED);
        
    if(hundle_MA_T_slow == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat(
            "MA(%d, %d, %d)",
            input_MA_T_fast_len, input_MA_T_medium_len, input_MA_T_slow_len
        )
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
    if(rates_total < MathMax(input_MA_T_slow_len, 5))
        return (0);


// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(hundle_MA_T_fast);
    ResetLastError();

    if(calculated < rates_total) {
        Print(
            "必要な期間数が指標の計算に使われていません。（", calculated, " バー)。",
            "\n",
            "エラー：", GetLastError()
        );
        return(0);
    }

    calculated = BarsCalculated(hundle_MA_T_medium);
    ResetLastError();

    if(calculated < rates_total) {
        Print(
            "必要な期間数が指標の計算に使われていません。（", calculated, " バー)。",
            "\n",
            "エラー：", GetLastError()
        );
        return(0);
    }

    calculated = BarsCalculated(hundle_MA_T_slow);
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
    CopyBuffer(hundle_MA_T_fast, 0, start_pos, end_pos, buffer_MA_T_fast);
    CopyBuffer(hundle_MA_T_medium, 0, start_pos, end_pos, buffer_MA_T_medium);
    CopyBuffer(hundle_MA_T_slow, 0, start_pos, end_pos, buffer_MA_T_slow);

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
