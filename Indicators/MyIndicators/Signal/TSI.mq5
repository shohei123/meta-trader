//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// TSI（トゥルー・ストレンシジ・インデックス）


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_TSI_first_len     = 30;   // 1回目の平滑化の期間（長）
input   int input_TSI_second_len    = 10;   // 2回目の平滑化の期間（短）
input   int input_TSI_signal_len    = 10;   // シグナルの平滑化の期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_buy_signal[];
double  buffer_sell_signal[];
double  buffer_TSI_base[];
double  buffer_TSI_signal[];

int     handle_TSI;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         4
#property indicator_plots           2
#property indicator_chart_window

#property indicator_label1          "TSI Buy"
#property indicator_type1           DRAW_ARROW
#property indicator_color1          clrGreen
#property indicator_width1          2

#property indicator_label2          "TSI Sell"
#property indicator_type2           DRAW_ARROW
#property indicator_color2          clrRed
#property indicator_width2          2


//+------------------------------------------------------------------+
//| TSI indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 入力値の例外処理
    if(input_TSI_second_len > input_TSI_first_len) {
        Print("移動平均線の期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_buy_signal, true);
    ArraySetAsSeries(buffer_sell_signal, true);
    ArraySetAsSeries(buffer_TSI_base, true);
    ArraySetAsSeries(buffer_TSI_signal, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_buy_signal, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_sell_signal, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_TSI_base, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_TSI_signal, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_TSI_second_len - 1);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_TSI_second_len - 1);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// シグナルのプロパティの設定
    PlotIndexSetInteger(0, PLOT_ARROW, 233);
    PlotIndexSetInteger(1, PLOT_ARROW, 234);
    PlotIndexSetInteger(0, PLOT_ARROW_SHIFT, 50);
    PlotIndexSetInteger(1, PLOT_ARROW_SHIFT, -50);


// ハンドルの取得
    handle_TSI = iCustom(
                     _Symbol,
                     PERIOD_CURRENT,
                     "Myindicators/Base/TSI.ex5",
                     input_TSI_first_len,
                     input_TSI_second_len,
                     input_TSI_signal_len
                 );

    if(handle_TSI == INVALID_HANDLE)
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
    if(rates_total < MathMax(input_TSI_first_len, 5))
        return (0);

// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_TSI);
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
    CopyBuffer(handle_TSI, 0, start_pos, end_pos, buffer_TSI_base);
    CopyBuffer(handle_TSI, 1, start_pos, end_pos, buffer_TSI_signal);

// 売買シグナルの生成
    for(int i = start_pos; i < end_pos; i++) {
        buffer_buy_signal[i] = EMPTY_VALUE;
        buffer_sell_signal[i] = EMPTY_VALUE;

        if(buffer_TSI_base[i + 1] > buffer_TSI_signal[i + 1])
            buffer_buy_signal[i] = low[i];

        else if(buffer_TSI_base[i + 1] < buffer_TSI_signal[i + 1])
            buffer_sell_signal[i] = high[i];
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
