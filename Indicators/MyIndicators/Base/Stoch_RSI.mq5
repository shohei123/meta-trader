//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// Stoch_RSI（ストキャスティクス相対力指数）
// RSIの過去n期間における最高値と最安値のうち、現在の終値の位置の推移を表示


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>
#include <MovingAverages.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input   int input_RSI_len = 15;         // RSIの計算期間
input   int input_Stoch_len = 15;       // ストキャスティクスの計算期間
input   int input_MA_base_len = 3;      // 基本線の平滑化の期間
input   int input_MA_signal_len = 3;    // シグナルラインの平滑化の期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_RSI[];
double  buffer_Stoch[];
double  buffer_Stoch_RSI_base[];
double  buffer_Stoch_RSI_signal[];

int     handle_RSI;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         4
#property indicator_plots           2
#property indicator_separate_window

#property indicator_label1          "Stoch RSI base"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrCrimson
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2

#property indicator_label2          "Stoch RSI signal"
#property indicator_type2           DRAW_LINE
#property indicator_color2          clrDeepSkyBlue
#property indicator_style2          STYLE_SOLID
#property indicator_width2          2

#property indicator_level1 30
#property indicator_level2 70


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_Stoch_RSI_base, true);
    ArraySetAsSeries(buffer_Stoch_RSI_signal, true);
    ArraySetAsSeries(buffer_RSI, true);
    ArraySetAsSeries(buffer_Stoch, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_Stoch_RSI_base, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_Stoch_RSI_signal, INDICATOR_DATA);
    SetIndexBuffer(2, buffer_RSI, INDICATOR_CALCULATIONS);
    SetIndexBuffer(3, buffer_Stoch, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_RSI_len + input_Stoch_len + input_MA_base_len);
    PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, input_RSI_len + input_Stoch_len + input_MA_base_len + input_MA_signal_len);

// NULLの場合の初期値
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
    PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_RSI = iRSI(_Symbol, PERIOD_CURRENT, input_RSI_len, PRICE_CLOSE);

    if(handle_RSI == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat(
            "Stoch RSI(%d, %d, %d, %d)",
            input_RSI_len,
            input_Stoch_len,
            input_MA_base_len,
            input_MA_signal_len
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
    if(rates_total < input_RSI_len + input_Stoch_len + input_MA_base_len)
        return (0);

// 指標において、指標の計算に全バーが使われているのか確認
    int calculated = BarsCalculated(handle_RSI);
    ResetLastError();

    if(calculated < rates_total) {
        Print(
            "必要な期間数が指標の計算に使われていません。（", calculated, " バー)。",
            "\n",
            "エラー：", GetLastError()
        );
        return(0);
    }

// 最新バーのインデックスを0とした場合に、何期間前までバッファ複製・再描画するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// バッファを取得
    CopyBuffer(handle_RSI, 0, start_pos, end_pos, buffer_RSI);

    // 例外処理（全期間を処理対象にする）
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

// 動的配列にバッファを複製
    for(int i = end_pos; i >= start_pos; i--) {
        if(CheckArrayBounds(buffer_RSI, i)) {
            // RSIの過去n期間の最高値・最安値の取得
            double RSI_highest = buffer_RSI[i];
            double RSI_lowest = buffer_RSI[i];

            for(int j = i; j < i + input_Stoch_len; j++) {
                if(CheckArrayBounds(buffer_RSI, j)) {
                    if(RSI_highest < buffer_RSI[j])
                        RSI_highest = buffer_RSI[j];

                    if(RSI_lowest > buffer_RSI[j])
                        RSI_lowest = buffer_RSI[j];
                }
            }

            if(RSI_highest - RSI_lowest != 0.0) {
                buffer_Stoch[i] = (buffer_RSI[i] - RSI_lowest) / (RSI_highest - RSI_lowest) * 100;
            }
            //---
            else {
                buffer_Stoch[i] =  0.0;
            }

            if(CheckArrayBounds(buffer_Stoch, i + input_MA_base_len)) {
                double result = 0.0;

                for(int j = i; j < i + input_MA_base_len; j++)
                    result += buffer_Stoch[j];
                result /= input_MA_base_len;

                buffer_Stoch_RSI_base[i] = result;
            }
            //---
            else {
                buffer_Stoch_RSI_base[i] = 0.0;
            }

            if(CheckArrayBounds(buffer_Stoch_RSI_base, i + input_MA_signal_len)) {
                double result = 0.0;

                for(int j = i; j < i + input_MA_base_len; j++)
                    result += buffer_Stoch_RSI_base[j];
                result /= input_MA_base_len;

                buffer_Stoch_RSI_signal[i] = result;
            }
            //---
            else {
                buffer_Stoch_RSI_signal[i] = 0.0;
            }
        }
        //---
        else {
            buffer_Stoch_RSI_base[i] = 0.0;
            buffer_Stoch_RSI_signal[i] = 0.0;
        }
    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+
