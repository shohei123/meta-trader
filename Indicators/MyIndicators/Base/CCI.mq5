//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// CCI（商品チャネル指数）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int       input_CCI_MA_len    = 20;       // 速い移動平均線の期間
input double    input_CCI_coeff     = 0.015;    // 標準偏差に乗算する係数


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_CCI[];
double  buffer_dev[];
double  buffer_MA[];

int     handle_dev;
int     handle_MA;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         3
#property indicator_plots           1
#property indicator_separate_window

#property indicator_label1          "CCI"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_CCI, true);
    ArraySetAsSeries(buffer_dev, true);
    ArraySetAsSeries(buffer_MA, true);


// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_CCI, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_dev, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, buffer_MA, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_CCI_MA_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_dev = iStdDev(_Symbol, PERIOD_CURRENT, input_CCI_MA_len, 0, MODE_SMA, PRICE_TYPICAL);
    handle_MA = iMA(_Symbol, PERIOD_CURRENT, input_CCI_MA_len, 0, MODE_SMA, PRICE_TYPICAL);

    if(handle_dev == INVALID_HANDLE)
        return(INIT_FAILED);
    if(handle_MA == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("CCI(%d, %, %d)", input_CCI_MA_len, input_CCI_coeff)
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
    if(rates_total < MathMax(input_CCI_MA_len, 5))
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);
    ArraySetAsSeries(close, true);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    CopyBuffer(handle_dev, 0, start_pos, end_pos, buffer_dev);
    CopyBuffer(handle_MA, 0, start_pos, end_pos, buffer_MA);

    for(int i = start_pos; i < end_pos; i++) {
        double hlc3 = (high[i] + low[i] + close[i]) / 3;
        buffer_CCI[i] = (hlc3 - buffer_MA[i]) / (input_CCI_coeff * buffer_dev[i]);
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
