//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// VI（ボルテックス・インジケーター）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_VI_len    = 15;   // 計算期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_VI_plus[];
double  buffer_VI_minus[];
double  buffer_VI_ATR[];
double  buffer_VI_hl[];
double  buffer_VI_lh[];

int     handle_VI_ATR;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         5
#property indicator_plots           2
#property indicator_separate_window

#property indicator_label1          "VI+"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2

#property indicator_label2          "VI-"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrDeepSkyBlue
#property indicator_style2          STYLE_SOLID
#property indicator_width2          2


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {


// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_VI_plus, true);
    ArraySetAsSeries(buffer_VI_minus, true);
    ArraySetAsSeries(buffer_VI_ATR, true);
    ArraySetAsSeries(buffer_VI_hl, true);
    ArraySetAsSeries(buffer_VI_lh, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_VI_plus, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_VI_minus, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_VI_ATR, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_VI_hl, INDICATOR_CALCULATIONS);
    SetIndexBuffer(4, buffer_VI_lh, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_VI_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_VI_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_VI_ATR = iATR(_Symbol, PERIOD_CURRENT, 1);

    if(handle_VI_ATR == INVALID_HANDLE)
        return(INIT_FAILED);


// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME, StringFormat("VI(%d)", input_VI_len)
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
    if(rates_total < MathMax(input_VI_len, 5))
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low, true);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    CopyBuffer(handle_VI_ATR, 0, start_pos, end_pos, buffer_VI_ATR);

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(high, i + 1) && CheckArrayBounds(low, i + 1)) {
            buffer_VI_hl[i] = MathAbs(high[i] - low[i + 1]);
            buffer_VI_lh[i] = MathAbs(low[i] - high[i + 1]);

            double ATR_sum = 0.0;
            double hl_sum = 0.0;
            double lh_sum = 0.0;

            for(int j = i; j < i + input_VI_len; j++) {
                if(CheckArrayBounds(buffer_VI_hl, j)) {
                    ATR_sum += buffer_VI_ATR[j];
                    hl_sum += buffer_VI_hl[j];
                    lh_sum += buffer_VI_lh[j];
                }
            }

            if(ATR_sum != 0.0) {
                buffer_VI_plus[i] = hl_sum / ATR_sum;
                buffer_VI_minus[i] = lh_sum / ATR_sum;
            }

            //---
            else {
                buffer_VI_plus[i] = 0.0;
                buffer_VI_minus[i] = 0.0;
            }
        }

        //---
        else {
            buffer_VI_hl[i] = 0.0;
            buffer_VI_lh[i] = 0.0;
            buffer_VI_plus[i] = 0.0;
            buffer_VI_minus[i] = 0.0;
        }
    }


//---
    return(rates_total);
}


//+------------------------------------------------------------------+
