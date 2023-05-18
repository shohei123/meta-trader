//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// Aroon Oscアルーン・オシレーター


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_Aroon_Osc_len = 14;   // アルーン・オシレーターの計測期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_buy_signal[];
double  buffer_sell_signal[];
double  buffer_Aroon_Osc[];

int     handle_Aroon_Osc;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         3
#property indicator_plots           2
#property indicator_chart_window

#property indicator_label1          "Aroon Osc Buy"
#property indicator_type1           DRAW_ARROW
#property indicator_color1          clrGreen
#property indicator_width1          2

#property indicator_label2          "Aroon Osc Sell"
#property indicator_type2           DRAW_ARROW
#property indicator_color2          clrRed
#property indicator_width2          2


//+------------------------------------------------------------------+
//| Aroon Oscillatorindicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_buy_signal, true);
    ArraySetAsSeries(buffer_sell_signal, true);
    ArraySetAsSeries(buffer_Aroon_Osc, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_buy_signal, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_sell_signal, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_Aroon_Osc, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_Aroon_Osc_len + 1);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_Aroon_Osc_len + 1);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// シグナルのプロパティの設定
    PlotIndexSetInteger(0, PLOT_ARROW, 233);
    PlotIndexSetInteger(1, PLOT_ARROW, 234);
    PlotIndexSetInteger(0, PLOT_ARROW_SHIFT, 50);
    PlotIndexSetInteger(1, PLOT_ARROW_SHIFT, -50);

// ハンドルの取得
    handle_Aroon_Osc = iCustom(
                           _Symbol,
                           PERIOD_CURRENT,
                           "MyIndicators/Base/Aroon_Osc.ex5",
                           input_Aroon_Osc_len
                       );

    if(handle_Aroon_Osc == INVALID_HANDLE)
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
    if(rates_total < MathMax(input_Aroon_Osc_len + 1, 5))
        return (0);

// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_Aroon_Osc);
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
    CopyBuffer(handle_Aroon_Osc, 0, start_pos, end_pos, buffer_Aroon_Osc);

// 売買シグナルの生成
    for(int i = start_pos; i < end_pos; i++) {
        buffer_buy_signal[i] = EMPTY_VALUE;
        buffer_sell_signal[i] = EMPTY_VALUE;

        if(buffer_Aroon_Osc[i + 1] < -80) {
            buffer_buy_signal[i] = low[i];
        }

        //---
        else if(buffer_Aroon_Osc[i + 1] > 80) {
            buffer_sell_signal[i] = high[i];
        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
