//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// MACD（基準線とシグナルラインの交差）


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int                   input_MACD_fast_len          = 10;               // 速い移動平均線の期間
input int                   input_MACD_slow_len          = 30;               // 遅い移動平均線の種別
input int                   input_MACD_signal_len        = 10;               // シグナルラインの平均化の期間
input ENUM_APPLIED_PRICE    input_MACD_price_type        = PRICE_CLOSE;      // 移動平均線の計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_buy_signal[];
double  buffer_sell_signal[];
double  buffer_MACD_base[];
double  buffer_MACD_signal[];

int     handle_MACD;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         4
#property indicator_plots           2
#property indicator_chart_window

#property indicator_label1          "MACD Buy"
#property indicator_type1           DRAW_ARROW
#property indicator_color1          clrGreen
#property indicator_width1          2

#property indicator_label2          "MACD Sell"
#property indicator_type2           DRAW_ARROW
#property indicator_color2          clrRed
#property indicator_width2          2


//+------------------------------------------------------------------+
//| MACD indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 入力値の例外処理
    if(input_MACD_fast_len > input_MACD_slow_len) {
        Print("移動平均線の期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_buy_signal, true);
    ArraySetAsSeries(buffer_sell_signal, true);
    ArraySetAsSeries(buffer_MACD_base, true);
    ArraySetAsSeries(buffer_MACD_signal, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_buy_signal, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_sell_signal, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_MACD_base, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_MACD_signal, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_MACD_signal_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_MACD_signal_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// シグナルのプロパティの設定
    PlotIndexSetInteger(0, PLOT_ARROW, 233);
    PlotIndexSetInteger(1, PLOT_ARROW, 234);
    PlotIndexSetInteger(0, PLOT_ARROW_SHIFT, 50);
    PlotIndexSetInteger(1, PLOT_ARROW_SHIFT, -50);


// ハンドルの取得
    handle_MACD = iMACD(
                      _Symbol,
                      PERIOD_CURRENT,
                      input_MACD_fast_len,
                      input_MACD_slow_len,
                      input_MACD_signal_len,
                      input_MACD_price_type
                  );

    if(handle_MACD == INVALID_HANDLE)
        return(INIT_FAILED);

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
    if(rates_total < MathMax(input_MACD_slow_len, 5))
        return (0);

// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_MACD);
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

// 指標ハンドル内の時系列配列において、最新のインデックスを0とした場合に
// 何期間前（end_pos）までの指標値を遡って複製するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 初回または誤動作（prev_calculatedが大きすぎる）なので、全期間を複製対象にする
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 売買シグナルの生成に使うバッファを取得
    CopyBuffer(handle_MACD, 0, start_pos, end_pos, buffer_MACD_base);
    CopyBuffer(handle_MACD, 1, start_pos, end_pos, buffer_MACD_signal);

// 売買シグナルの生成
    for(int i = start_pos; i < end_pos; i++) {
        buffer_buy_signal[i] = EMPTY_VALUE;
        buffer_sell_signal[i] = EMPTY_VALUE;

        if(buffer_MACD_base[i + 2] < buffer_MACD_signal[i + 2] && buffer_MACD_base[i + 1] > buffer_MACD_signal[i + 1])
            buffer_buy_signal[i] = low[i];

        else if(buffer_MACD_base[i + 2] > buffer_MACD_signal[i + 2] && buffer_MACD_base[i + 1] < buffer_MACD_signal[i + 1])
            buffer_sell_signal[i] = high[i];
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
