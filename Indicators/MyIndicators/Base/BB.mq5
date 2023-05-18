//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// BB_Break（ボリンジャーバンドの順張り戦略）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int                   input_BB_len      = 20;           // 移動平均線・ATRの期間
input   int                   input_BB_mult     = 2;            // ATRの乗算値
input   ENUM_APPLIED_PRICE    input_BB_price_type  = PRICE_CLOSE;  // 計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_BB_base[];
double  buffer_BB_upper[];
double  buffer_BB_lower[];

int     handle_BB;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         3
#property indicator_plots           3
#property indicator_chart_window

#property indicator_label1          "BB_base"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrLime
#property indicator_style1          STYLE_DASH
#property indicator_width1          2

#property indicator_label2          "BB_base"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrGreenYellow
#property indicator_style2          STYLE_SOLID
#property indicator_width2          1

#property indicator_label3          "BB_base"
#property indicator_type3           DRAW_LINE
#property indicator_color3          clrGreenYellow
#property indicator_style3          STYLE_SOLID
#property indicator_width3          1


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_BB_base, true);
    ArraySetAsSeries(buffer_BB_upper, true);
    ArraySetAsSeries(buffer_BB_lower, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_BB_base, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_BB_upper, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_BB_lower, INDICATOR_DATA);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_BB_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_BB = iBands(_Symbol, PERIOD_CURRENT, input_BB_len, 0, input_BB_mult, input_BB_price_type);

    if(handle_BB == INVALID_HANDLE)
        return(INIT_FAILED);
        
// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("BB(%d, %d, %d)", input_BB_len, input_BB_mult)
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
    if(rates_total < MathMax(input_BB_len, 5))
        return (0);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    CopyBuffer(handle_BB, 0, start_pos, end_pos, buffer_BB_base);
    CopyBuffer(handle_BB, 1, start_pos, end_pos, buffer_BB_upper);
    CopyBuffer(handle_BB, 2, start_pos, end_pos, buffer_BB_lower);

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
