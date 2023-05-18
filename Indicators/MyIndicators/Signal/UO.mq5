//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// UO（アルティメット・オシレーター）


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int   input_UO_avg_short_len      = 7;    // BP/TRの平均化の期間（短期）
input int   input_UO_avg_medium_len     = 14;   // BP/TRの平均化の期間（中期）
input int   input_UO_avg_long_len       = 28;   // BP/TRの平均化の期間（長期）


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_buy_signal[];
double  buffer_sell_signal[];
double  buffer_UO[];

int     handle_UO;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         3
#property indicator_plots           2
#property indicator_chart_window

#property indicator_label1          "UO Buy"
#property indicator_type1           DRAW_ARROW
#property indicator_color1          clrGreen
#property indicator_width1          2

#property indicator_label2          "UO Sell"
#property indicator_type2           DRAW_ARROW
#property indicator_color2          clrRed
#property indicator_width2          2


//+------------------------------------------------------------------+
//| UO indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 入力値の例外処理
    if(input_UO_avg_short_len > input_UO_avg_long_len || input_UO_avg_medium_len > input_UO_avg_long_len || input_UO_avg_short_len > input_UO_avg_medium_len) {
        Print("平均化の期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_buy_signal, true);
    ArraySetAsSeries(buffer_sell_signal, true);
    ArraySetAsSeries(buffer_UO, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_buy_signal, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_sell_signal, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_UO, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_UO_avg_long_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_UO_avg_long_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// シグナルのプロパティの設定
    PlotIndexSetInteger(0, PLOT_ARROW, 233);
    PlotIndexSetInteger(1, PLOT_ARROW, 234);
    PlotIndexSetInteger(0, PLOT_ARROW_SHIFT, 50);
    PlotIndexSetInteger(1, PLOT_ARROW_SHIFT, -50);

// ハンドルの取得
    handle_UO = iCustom(
                    _Symbol,
                    PERIOD_CURRENT,
                    "MyIndicators/Base/UO.ex5",
                    input_UO_avg_short_len,
                    input_UO_avg_medium_len,
                    input_UO_avg_long_len
                );

    if(handle_UO == INVALID_HANDLE)
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
    if(rates_total < MathMax(input_UO_avg_long_len, 5))
        return (0);

// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_UO);
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
    CopyBuffer(handle_UO, 0, start_pos, end_pos, buffer_UO);

// 売買シグナルの生成
    for(int i = start_pos; i < end_pos; i++) {
        buffer_buy_signal[i] = EMPTY_VALUE;
        buffer_sell_signal[i] = EMPTY_VALUE;

        if(buffer_UO[i + 1] > 50) {
            buffer_buy_signal[i] = low[i];
        }

        //---
        else if(buffer_UO[i + 1] < 50) {
            buffer_sell_signal[i] = high[i];
        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
