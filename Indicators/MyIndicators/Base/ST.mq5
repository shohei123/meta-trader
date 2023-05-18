//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// ST（スーパートレンド）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int       input_ST_ATR_len    = 20;   // ATRの計算期間
input double    input_ST_ATR_mult   = 2.0;  // ATRの乗算値


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_ST_main[];
double  buffer_ST_upper[];
double  buffer_ST_lower[];
double  buffer_ST_ATR[];

int     handle_ST_ATR;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         4
#property indicator_plots           1
#property indicator_chart_window

#property indicator_label1          "ST"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          3


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_ST_main, true);
    ArraySetAsSeries(buffer_ST_upper, true);
    ArraySetAsSeries(buffer_ST_lower, true);
    ArraySetAsSeries(buffer_ST_ATR, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_ST_main, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_ST_upper, INDICATOR_CALCULATIONS);
    SetIndexBuffer(2, buffer_ST_lower, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_ST_ATR, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_ST_ATR_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_ST_ATR = iATR(_Symbol, PERIOD_CURRENT, input_ST_ATR_len);

    if(handle_ST_ATR == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(INDICATOR_SHORTNAME, StringFormat("ST(%d, %f)", input_ST_ATR_len, input_ST_ATR_mult));

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
    if(rates_total < MathMax(input_ST_ATR_len, 5))
        return (0);


// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_ST_ATR);
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
    ArraySetAsSeries(close, true);

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    CopyBuffer(handle_ST_ATR, 0, start_pos, end_pos, buffer_ST_ATR);

    for(int i = end_pos; i >= start_pos; i--) {
        double source = (high[i] + low[i]) / 2;
        buffer_ST_upper[i] = source + buffer_ST_ATR[i] * input_ST_ATR_mult;
        buffer_ST_lower[i] = source - buffer_ST_ATR[i] * input_ST_ATR_mult;
        int direction = 0.0;

        if(CheckArrayBounds(buffer_ST_upper, i + 1) && CheckArrayBounds(buffer_ST_lower, i + 1) && CheckArrayBounds(buffer_ST_ATR, i + 1)) {
            // アッパーバンドは、基本的に下げ続ける(前期間の方が値が低いなら、前期間を採用)
            if(buffer_ST_upper[i] > buffer_ST_upper[i + 1] && close[i] < buffer_ST_upper[i + 1])
                buffer_ST_upper[i] = buffer_ST_upper[i + 1];

            // ロワーバンドは、基本的に上げ続ける(前期間の方が値が高いなら、前期間を採用)
            if(buffer_ST_lower[i] < buffer_ST_lower[i + 1] && close[i] > buffer_ST_lower[i + 1])
                buffer_ST_lower[i] = buffer_ST_lower[i + 1];

            // 初回実行は、1.0を代入
            if(!MathIsValidNumber(buffer_ST_ATR[i + 1]))
                direction = 1.0;

            // 1期間前のST_mainは、アッパーバンドを適用した場合
            else if(buffer_ST_main[i + 1] == buffer_ST_upper[i + 1]) {
                // 現在の終値は、1期間前のアッパーバンドを下回っている（下降トレンドの継続）
                if(close[i] < buffer_ST_upper[i + 1])
                    direction = -1.0;
                else
                    direction = 1.0;
            }

            // 1期間前のST_mainは、ロワーバンドを適用した場合
            else {
                // 現在の終値は、1期間前のロワーバンドを上回っている（上昇トレンドの継続）
                if(close[i] > buffer_ST_lower[i + 1])
                    direction = 1.0;
                else
                    direction = -1.0;
            }

            // 上昇トレンドの場合
            if(direction == 1.0)
                buffer_ST_main[i] = buffer_ST_lower[i];
            // 下降トレンドの場合
            else
                buffer_ST_main[i] = buffer_ST_upper[i];
        }
        //---
        else {
            buffer_ST_upper[i] = 0.0;
            buffer_ST_lower[i] = 0.0;
        }


    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
