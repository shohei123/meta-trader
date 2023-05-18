//+------------------------------------------------------------------+
//| Indicator
//+------------------------------------------------------------------+
// CMO（シャンデ・モメンタム・オシレーター）


//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <MyDoEasy/Utils/Util.mqh>


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int   input_CMO_MOM_diff_len  =   1;      // モメンタムの比較期間
input int   input_CMO_MOM_sum_len   =   10;     // モメンタムの合計期間


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
double  buffer_CMO[];
double  buffer_CMO_MOM[];

int     handle_CMO_MOM;


//+------------------------------------------------------------------+
//| Property
//+------------------------------------------------------------------+
#property indicator_buffers         2
#property indicator_plots           1
#property indicator_separate_window

#property indicator_label1          "CMO"
#property indicator_type1           DRAW_LINE
#property indicator_color1          clrRed
#property indicator_style1          STYLE_SOLID
#property indicator_width1          2

#property indicator_level1          70
#property indicator_level2          -70


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

// 動的配列を時系列配列に変更
    ArraySetAsSeries(buffer_CMO, true);
    ArraySetAsSeries(buffer_CMO_MOM, true);

// 動的配列と内部バッファの紐づけ
    SetIndexBuffer(0, buffer_CMO, INDICATOR_DATA);
    SetIndexBuffer(1, buffer_CMO_MOM, INDICATOR_CALCULATIONS);

// 指標の描写開始位置の調整（計算の都合により、初期は描画できない場合など）
    PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, input_CMO_MOM_diff_len + input_CMO_MOM_sum_len);

// nullになる可能性のあるバッファの対策
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);

// ハンドルの取得
    handle_CMO_MOM = iCustom(
                         _Symbol,
                         PERIOD_CURRENT,
                         "MyIndicators/Base/MOM.ex5",
                         input_CMO_MOM_diff_len
                     );

    if(handle_CMO_MOM == INVALID_HANDLE)
        return(INIT_FAILED);

// 指標名
    IndicatorSetString(
        INDICATOR_SHORTNAME,
        StringFormat("CMO(%d, %d)", input_CMO_MOM_diff_len, input_CMO_MOM_sum_len)
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
    if(rates_total < input_CMO_MOM_sum_len)
        return (0);

// 引数の配列を時系列形式に変更
    ArraySetAsSeries(close, true);

// 指標ハンドル内の時系列配列において、最新のインデックスを0とした場合に
// 何期間前（end_pos）までの指標値を遡って複製するのか
    int start_pos = 0;
    int end_pos = rates_total - prev_calculated + 1;

// 初回または誤動作（prev_calculatedが大きすぎる）なので、全期間を複製対象にする
    if(prev_calculated > rates_total || prev_calculated <= 0)
        end_pos = rates_total - 1;

    CopyBuffer(handle_CMO_MOM, 0, start_pos, end_pos, buffer_CMO_MOM);

// 売買シグナルの生成
    for(int i = start_pos; i < end_pos; i++) {
        double MOM_sum_plus = 0.0;
        double MOM_sum_minus = 0.0;

        for(int j = i; j < i + input_CMO_MOM_sum_len; j++) {
            if(CheckArrayBounds(buffer_CMO_MOM, j)) {
                MOM_sum_plus += buffer_CMO_MOM[j] >= 0 ? buffer_CMO_MOM[j] : 0.0;
                MOM_sum_minus += buffer_CMO_MOM[j] >= 0 ?  0.0 : buffer_CMO_MOM[j] * -1;
            }
        }

        if(MOM_sum_plus + MOM_sum_minus != 0.0)
            buffer_CMO[i] = (MOM_sum_plus - MOM_sum_minus) / (MOM_sum_plus + MOM_sum_minus) * 100;
        else
            buffer_CMO[i] = 0.0;

    }

//---
    return(rates_total);
}


//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
