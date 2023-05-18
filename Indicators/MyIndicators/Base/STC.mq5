//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// STC（シャフ・トレンド・サイクル）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>
#include <MovingAverages.mqh>

//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int     input_STC_MACD_fast_len     = 25;   // MACDの移動平均線の期間（速）
input   int     input_STC_MACD_slow_len     = 50;   // MACDの移動平均線の期間（遅）
input   int     input_STC_cycle_len         = 10;   // 平滑化の期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_STC[];
double  buffer_STC_MACD[];
double  buffer_STC_k[];
double  buffer_STC_d[];
double  buffer_STC_kd[];

int     handle_STC_MACD;

//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers     5
#property indicator_plots       1
#property indicator_separate_window

#property indicator_label1      "STC"
#property indicator_type1       DRAW_LINE
#property indicator_color1      clrCrimson
#property indicator_style1      STYLE_SOLID
#property indicator_width1      2

#property indicator_level1      80
#property indicator_level2      20


//+------------------------------------------------------------------+
//| Custom indicator initialization function             |
//+------------------------------------------------------------------+
int OnInit() {

// 入力値の例外処理
    if(input_STC_MACD_fast_len > input_STC_MACD_slow_len) {
        Print("移動平均線の期間の大小関係に誤りがあります。");
        return(INIT_FAILED);
    }

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_STC, true);
    ArraySetAsSeries(buffer_STC_MACD, true);
    ArraySetAsSeries(buffer_STC_k, true);
    ArraySetAsSeries(buffer_STC_d, true);
    ArraySetAsSeries(buffer_STC_kd, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_STC, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_STC_MACD, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_STC_k, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_STC_d, INDICATOR_CALCULATIONS);
    SetIndexBuffer(4, buffer_STC_kd, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_STC_MACD_slow_len + input_STC_cycle_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat(
            "STC(%d, %d, %d)",
            input_STC_MACD_fast_len, input_STC_MACD_slow_len, input_STC_cycle_len
        )
    );


// ハンドルの取得
    handle_STC_MACD = iMACD(_Symbol, PERIOD_CURRENT, input_STC_MACD_fast_len, input_STC_MACD_slow_len, input_STC_cycle_len, MODE_CLOSE);

    if(handle_STC_MACD == INVALID_HANDLE)
        return(INIT_FAILED);


//---
    return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+
//| Custom indicator iteration function               |
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
    if(rates_total < input_STC_MACD_slow_len + input_STC_cycle_len)
        return (0);

// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_STC_MACD);
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
    CopyBuffer(handle_STC_MACD, 0, start_pos, end_pos, buffer_STC_MACD);

    for(int i = end_pos; i >= start_pos; i--) {
        double MACD_highest = buffer_STC_MACD[i];
        double MACD_lowest = buffer_STC_MACD[i];

        for(int j = i; j < i + input_STC_cycle_len; j++) {
            if(CheckArrayBounds(buffer_STC_MACD, j)) {
                if(MACD_highest < buffer_STC_MACD[j])
                    MACD_highest = buffer_STC_MACD[j];

                if(MACD_lowest > buffer_STC_MACD[j])
                    MACD_lowest = buffer_STC_MACD[j];
            }

            if(MACD_highest - MACD_lowest != 0.0)
                buffer_STC_k[i] = (buffer_STC_MACD[i] - MACD_lowest) / (MACD_highest - MACD_lowest) * 100;
            else
                buffer_STC_k[i] =  0.0;

        }
    }

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        3,
        buffer_STC_k,
        buffer_STC_d
    );

    for(int i = end_pos; i >= start_pos; i--) {
        double STC_d_highest = buffer_STC_d[i];
        double STC_d_lowest = buffer_STC_d[i];

        for(int j = i; j < i + input_STC_cycle_len; j++) {
            if(CheckArrayBounds(buffer_STC_d, j)) {
                if(STC_d_highest < buffer_STC_d[j])
                    STC_d_highest = buffer_STC_d[j];

                if(STC_d_lowest > buffer_STC_d[j])
                    STC_d_lowest = buffer_STC_d[j];
            }

            if(STC_d_highest - STC_d_lowest != 0.0) {
                buffer_STC_kd[i] = (buffer_STC_d[i] - STC_d_lowest) / (STC_d_highest - STC_d_lowest) * 100;
            }
            //---
            else {
                buffer_STC_kd[i] =  0.0;
            }
        }
    }

    ExponentialMAOnBuffer(
        rates_total,
        prev_calculated,
        start_pos,
        3,
        buffer_STC_kd,
        buffer_STC
    );



//---
    return(rates_total);
}


//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
