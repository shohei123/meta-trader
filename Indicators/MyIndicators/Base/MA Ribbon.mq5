//+------------------------------------------------------------------+
//|                                                    MA Ribbon.mq5 |
//|                                           Copyright 2022, Shohei |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Shohei"
#property link ""
#property version "1.00"
#property description "Two Moving Average Ribbon"

// 依存ファイルの読み込み
#include <MovingAverages.mqh>

// 指標の描画ウィンドウ
#property indicator_chart_window

// 指標に使うバッファ数
#property indicator_buffers 27

// 指標のプロット数
#property indicator_plots 24

// 指標の描画方法
#property indicator_type1 DRAW_LINE
#property indicator_type2 DRAW_LINE
#property indicator_type3 DRAW_LINE
#property indicator_type4 DRAW_LINE
#property indicator_type5 DRAW_LINE
#property indicator_type6 DRAW_LINE
#property indicator_type7 DRAW_FILLING
#property indicator_type8 DRAW_FILLING
#property indicator_type9 DRAW_FILLING
#property indicator_type10 DRAW_FILLING
#property indicator_type11 DRAW_FILLING
#property indicator_type12 DRAW_FILLING
#property indicator_type13 DRAW_FILLING
#property indicator_type14 DRAW_FILLING
#property indicator_type15 DRAW_FILLING

// 指標の描写色
#property indicator_color1 clrRed
#property indicator_color2 clrRed
#property indicator_color3 clrGreen
#property indicator_color4 clrGreen
#property indicator_color5 clrWhite
#property indicator_color6 clrWhite
#property indicator_color7 C'200,10,10', C'200,10,10'
#property indicator_color8 C'100,100,100', C'100,100,100'
#property indicator_color9 C'10,10,200', C'10,10,200'
#property indicator_color10 C'200,10,10', C'200,10,10'
#property indicator_color11 C'100,100,100', C'100,100,100'
#property indicator_color12 C'10,10,200', C'10,10,200'
#property indicator_color13 C'200,10,10', C'200,10,10'
#property indicator_color14 C'100,100,100', C'100,100,100'
#property indicator_color15 C'10,10,200', C'10,10,200'

// 指標の表示名
#property indicator_label1 "S1-MA"
#property indicator_label2 "S2-MA"
#property indicator_label3 "M1-MA"
#property indicator_label4 "M2-MA"
#property indicator_label5 "L1-MA"
#property indicator_label6 "L2-MA"
#property indicator_label7 "S-MA Up Ribbon"
#property indicator_label8 "S-MA Range Ribbon"
#property indicator_label9 "S-MA Down Ribbon"
#property indicator_label10 "M-MA UP Ribbon"
#property indicator_label11 "M-MA Range Ribbon"
#property indicator_label12 "M-MA Down Ribbon"
#property indicator_label13 "L-MA UP Ribbon"
#property indicator_label14 "L-MA Range Ribbon"
#property indicator_label15 "L-MA Down Ribbon"

// 入力欄の定義
input int input_S1_MA_len = 10;                         // 短期の移動平均線1の期間
input int input_S2_MA_len = 30;                         // 短期の移動平均線2の期間
input int input_M1_MA_len = 80;                         // 短期の移動平均線1の期間
input int input_M2_MA_len = 100;                        // 短期の移動平均線2の期間
input int input_L1_MA_len = 180;                        // 短期の移動平均線1の期間
input int input_L2_MA_len = 200;                        // 短期の移動平均線2の期間
input ENUM_APPLIED_PRICE input_MA_source = PRICE_CLOSE; // 移動平均線の計算基準
input int input_trend_grad_len = 3;                     // トレンド判定用の勾配確認の期間

// 入力値に対する矯正考慮の変数
int fixed_S1_MA_len;
int fixed_S2_MA_len;
int fixed_M1_MA_len;
int fixed_M2_MA_len;
int fixed_L1_MA_len;
int fixed_L2_MA_len;

// バッファと紐づける動的配列
// MA
double ind_S1_MA_buffer[];
double ind_S2_MA_buffer[];
double ind_M1_MA_buffer[];
double ind_M2_MA_buffer[];
double ind_L1_MA_buffer[];
double ind_L2_MA_buffer[];

// Ribbon
double ind_S1_ribbon_up_buffer[];
double ind_S2_ribbon_up_buffer[];
double ind_S1_ribbon_range_buffer[];
double ind_S2_ribbon_range_buffer[];
double ind_S1_ribbon_down_buffer[];
double ind_S2_ribbon_down_buffer[];
double ind_M1_ribbon_up_buffer[];
double ind_M2_ribbon_up_buffer[];
double ind_M1_ribbon_range_buffer[];
double ind_M2_ribbon_range_buffer[];
double ind_M1_ribbon_down_buffer[];
double ind_M2_ribbon_down_buffer[];
double ind_L1_ribbon_up_buffer[];
double ind_L2_ribbon_up_buffer[];
double ind_L1_ribbon_range_buffer[];
double ind_L2_ribbon_range_buffer[];
double ind_L1_ribbon_down_buffer[];
double ind_L2_ribbon_down_buffer[];

// トレンド判定
double S_Trend[];
double M_Trend[];
double L_Trend[];

// ハンドル用の変数
int S1_MA_handle;
int S2_MA_handle;
int M1_MA_handle;
int M2_MA_handle;
int L1_MA_handle;
int L2_MA_handle;

//+------------------------------------------------------------------+
//| 初期化の処理
//+------------------------------------------------------------------+
int OnInit()
{
  // バッファと動的配列の紐づけ
  // MA
  SetIndexBuffer(0, ind_S1_MA_buffer, INDICATOR_DATA);
  SetIndexBuffer(1, ind_S2_MA_buffer, INDICATOR_DATA);
  SetIndexBuffer(2, ind_M1_MA_buffer, INDICATOR_DATA);
  SetIndexBuffer(3, ind_M2_MA_buffer, INDICATOR_DATA);
  SetIndexBuffer(4, ind_L1_MA_buffer, INDICATOR_DATA);
  SetIndexBuffer(5, ind_L2_MA_buffer, INDICATOR_DATA);

  // Ribbon
  SetIndexBuffer(6, ind_S1_ribbon_up_buffer, INDICATOR_DATA);
  SetIndexBuffer(7, ind_S2_ribbon_up_buffer, INDICATOR_DATA);
  SetIndexBuffer(8, ind_S1_ribbon_range_buffer, INDICATOR_DATA);
  SetIndexBuffer(9, ind_S2_ribbon_range_buffer, INDICATOR_DATA);
  SetIndexBuffer(10, ind_S1_ribbon_down_buffer, INDICATOR_DATA);
  SetIndexBuffer(11, ind_S2_ribbon_down_buffer, INDICATOR_DATA);
  SetIndexBuffer(12, ind_M1_ribbon_up_buffer, INDICATOR_DATA);
  SetIndexBuffer(13, ind_M2_ribbon_up_buffer, INDICATOR_DATA);
  SetIndexBuffer(14, ind_M1_ribbon_range_buffer, INDICATOR_DATA);
  SetIndexBuffer(15, ind_M2_ribbon_range_buffer, INDICATOR_DATA);
  SetIndexBuffer(16, ind_M1_ribbon_down_buffer, INDICATOR_DATA);
  SetIndexBuffer(17, ind_M2_ribbon_down_buffer, INDICATOR_DATA);
  SetIndexBuffer(18, ind_L1_ribbon_up_buffer, INDICATOR_DATA);
  SetIndexBuffer(19, ind_L2_ribbon_up_buffer, INDICATOR_DATA);
  SetIndexBuffer(20, ind_L1_ribbon_range_buffer, INDICATOR_DATA);
  SetIndexBuffer(21, ind_L2_ribbon_range_buffer, INDICATOR_DATA);
  SetIndexBuffer(22, ind_L1_ribbon_down_buffer, INDICATOR_DATA);
  SetIndexBuffer(23, ind_L2_ribbon_down_buffer, INDICATOR_DATA);

  // Trend
  SetIndexBuffer(24, S_Trend, INDICATOR_CALCULATIONS);
  SetIndexBuffer(25, M_Trend, INDICATOR_CALCULATIONS);
  SetIndexBuffer(26, L_Trend, INDICATOR_CALCULATIONS);

  // 移動平均線の期間数のエラー回避
  if (input_S1_MA_len <= 0)
  {
    fixed_S1_MA_len = 10;
    PrintFormat("短期の移動平均線1の期間数が0以下になっているので、(%d)に矯正しました。", fixed_S1_MA_len);
  }
  else
  {
    fixed_S1_MA_len = input_S1_MA_len;
  }

  if (input_S2_MA_len <= 0)
  {
    fixed_S2_MA_len = 30;
    PrintFormat("短期の移動平均線2の期間数が0以下になっているので、(%d)に矯正しました。", fixed_S2_MA_len);
  }
  else
  {
    fixed_S2_MA_len = input_S2_MA_len;
  }

  if (input_M1_MA_len <= 0)
  {
    fixed_M1_MA_len = 80;
    PrintFormat("中期の移動平均線1の期間数が0以下になっているので、(%d)に矯正しました。", fixed_M1_MA_len);
  }
  else
  {
    fixed_M1_MA_len = input_M1_MA_len;
  }

  if (input_M2_MA_len <= 0)
  {
    fixed_M2_MA_len = 100;
    PrintFormat("中期の移動平均線2の期間数が0以下になっているので、(%d)に矯正しました。", fixed_M2_MA_len);
  }
  else
  {
    fixed_M2_MA_len = input_M2_MA_len;
  }

  if (input_L1_MA_len <= 0)
  {
    fixed_L1_MA_len = 180;
    PrintFormat("長期の移動平均線1の期間数が0以下になっているので、(%d)に矯正しました。", fixed_L1_MA_len);
  }
  else
  {
    fixed_L1_MA_len = input_L1_MA_len;
  }

  if (input_L2_MA_len <= 0)
  {
    fixed_L2_MA_len = 200;
    PrintFormat("長期の移動平均線2の期間数が0以下になっているので、(%d)に矯正しました。", fixed_L2_MA_len);
  }
  else
  {
    fixed_L2_MA_len = input_L2_MA_len;
  }

  // 指標名の表示変更
  string s_name = StringFormat(
      "MA Ribbons(%d,%d,%d,%d,%d,%d)",
      fixed_S1_MA_len, fixed_S2_MA_len,
      fixed_M1_MA_len, fixed_M2_MA_len,
      fixed_L1_MA_len, fixed_L2_MA_len);
  IndicatorSetString(INDICATOR_SHORTNAME, s_name);

  // 指標の描写開始の調整
  // MA
  PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, fixed_S1_MA_len);
  PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, fixed_S2_MA_len);
  PlotIndexSetInteger(2, PLOT_DRAW_BEGIN, fixed_M1_MA_len);
  PlotIndexSetInteger(3, PLOT_DRAW_BEGIN, fixed_M2_MA_len);
  PlotIndexSetInteger(4, PLOT_DRAW_BEGIN, fixed_L1_MA_len);
  PlotIndexSetInteger(5, PLOT_DRAW_BEGIN, fixed_L2_MA_len);

  // Ribbon
  PlotIndexSetInteger(6, PLOT_DRAW_BEGIN, fixed_S2_MA_len);
  PlotIndexSetInteger(7, PLOT_DRAW_BEGIN, fixed_S2_MA_len);
  PlotIndexSetInteger(8, PLOT_DRAW_BEGIN, fixed_S2_MA_len);
  PlotIndexSetInteger(9, PLOT_DRAW_BEGIN, fixed_M2_MA_len);
  PlotIndexSetInteger(10, PLOT_DRAW_BEGIN, fixed_M2_MA_len);
  PlotIndexSetInteger(11, PLOT_DRAW_BEGIN, fixed_M2_MA_len);
  PlotIndexSetInteger(12, PLOT_DRAW_BEGIN, fixed_L2_MA_len);
  PlotIndexSetInteger(13, PLOT_DRAW_BEGIN, fixed_L2_MA_len);
  PlotIndexSetInteger(14, PLOT_DRAW_BEGIN, fixed_L2_MA_len);

  // 指標に関するハンドルの作成
  S1_MA_handle = iMA(NULL, 0, fixed_S1_MA_len, 0, MODE_EMA, input_MA_source);
  S2_MA_handle = iMA(NULL, 0, fixed_S2_MA_len, 0, MODE_EMA, input_MA_source);
  M1_MA_handle = iMA(NULL, 0, fixed_M1_MA_len, 0, MODE_EMA, input_MA_source);
  M2_MA_handle = iMA(NULL, 0, fixed_M2_MA_len, 0, MODE_EMA, input_MA_source);
  L1_MA_handle = iMA(NULL, 0, fixed_L1_MA_len, 0, MODE_EMA, input_MA_source);
  L2_MA_handle = iMA(NULL, 0, fixed_L2_MA_len, 0, MODE_EMA, input_MA_source);

  return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{

  // 最小期間数に達するまで即時返却
  if (rates_total < fixed_S1_MA_len)
    return (0);

  // 処理の開始地点の取得
  int end_position;
  if (prev_calculated > rates_total || prev_calculated <= 0)
  {
    end_position = rates_total;
  }
  else
  {
    end_position = rates_total - prev_calculated;
    end_position++;
  }

  // MAの描写
  if (fixed_S1_MA_len < rates_total)
  {
    CopyBuffer(S1_MA_handle, 0, 0, end_position, ind_S1_MA_buffer);
  }

  if (fixed_S2_MA_len < rates_total)
  {
    CopyBuffer(S2_MA_handle, 0, 0, end_position, ind_S2_MA_buffer);
  }

  if (fixed_M1_MA_len < rates_total)
  {
    CopyBuffer(M1_MA_handle, 0, 0, end_position, ind_M1_MA_buffer);
  }

  if (fixed_M2_MA_len < rates_total)
  {
    CopyBuffer(M2_MA_handle, 0, 0, end_position, ind_M2_MA_buffer);
  }

  if (fixed_L1_MA_len < rates_total)
  {
    CopyBuffer(L1_MA_handle, 0, 0, end_position, ind_L1_MA_buffer);
  }

  if (fixed_L2_MA_len < rates_total)
  {
    CopyBuffer(L2_MA_handle, 0, 0, end_position, ind_L2_MA_buffer);
  }

  // トレンド描写
  // 動的配列の操作なので、0に近いインデックスほど古いデータであることに注意
  int start_position;
  if (prev_calculated > 1)
  {
    start_position = prev_calculated - 1;
  }
  else
  {
    start_position = 1;
  }

  for (int i = start_position; i < rates_total; i++)
  {
    S_Trend[i] = S_Trend[i - 1];
    M_Trend[i] = M_Trend[i - 1];
    L_Trend[i] = L_Trend[i - 1];

    ind_S1_ribbon_up_buffer[i] = 0.0;
    ind_S2_ribbon_up_buffer[i] = 0.0;
    ind_S1_ribbon_range_buffer[i] = 0.0;
    ind_S2_ribbon_range_buffer[i] = 0.0;
    ind_S1_ribbon_down_buffer[i] = 0.0;
    ind_S2_ribbon_down_buffer[i] = 0.0;

    ind_M1_ribbon_up_buffer[i] = 0.0;
    ind_M2_ribbon_up_buffer[i] = 0.0;
    ind_M1_ribbon_range_buffer[i] = 0.0;
    ind_M2_ribbon_range_buffer[i] = 0.0;
    ind_M1_ribbon_down_buffer[i] = 0.0;
    ind_M2_ribbon_down_buffer[i] = 0.0;

    ind_L1_ribbon_up_buffer[i] = 0.0;
    ind_L2_ribbon_up_buffer[i] = 0.0;
    ind_L1_ribbon_range_buffer[i] = 0.0;
    ind_L2_ribbon_range_buffer[i] = 0.0;
    ind_L1_ribbon_down_buffer[i] = 0.0;
    ind_L2_ribbon_down_buffer[i] = 0.0;

    // 短期のトレンド判定
    if (ind_S1_MA_buffer[i] > ind_S2_MA_buffer[i])
    {
      S_Trend[i] = 1;
    }
    else
    {
      S_Trend[i] = -1;
    }

    int S_diff = i - input_trend_grad_len;
    if ((S_diff >= 0))
    {

      if (S_Trend[i] == 1)
      {
        if ((ind_S1_MA_buffer[i] - ind_S1_MA_buffer[S_diff]) < 0)
        {
          S_Trend[i] = 0;
        }

        if ((ind_S2_MA_buffer[i] - ind_S2_MA_buffer[S_diff]) < 0)
        {
          S_Trend[i] = 0;
        }
      }

      if (S_Trend[i] == -1)
      {
        if ((ind_S1_MA_buffer[i] - ind_S1_MA_buffer[S_diff]) > 0)
        {
          S_Trend[i] = 0;
        }

        if ((ind_S2_MA_buffer[i] - ind_S2_MA_buffer[S_diff]) > 0)
        {
          S_Trend[i] = 0;
        }
      }
    }

    // 中期のトレンド判定
    if (ind_M1_MA_buffer[i] > ind_M2_MA_buffer[i])
    {
      M_Trend[i] = 1;
    }
    else
    {
      M_Trend[i] = -1;
    }

    int M_diff = i - input_trend_grad_len;
    if ((M_diff >= 0))
    {
      if (M_Trend[i] == 1)
      {
        if ((ind_M1_MA_buffer[i] - ind_M1_MA_buffer[M_diff]) < 0)
        {
          M_Trend[i] = 0;
        }

        if ((ind_M2_MA_buffer[i] - ind_M2_MA_buffer[M_diff]) < 0)
        {
          M_Trend[i] = 0;
        }
      }

      if (M_Trend[i] == -1)
      {
        if ((ind_M1_MA_buffer[i] - ind_M1_MA_buffer[M_diff]) > 0)
        {
          M_Trend[i] = 0;
        }

        if ((ind_M2_MA_buffer[i] - ind_M2_MA_buffer[M_diff]) > 0)
        {
          M_Trend[i] = 0;
        }
      }
    }

    // 長期のトレンド判定
    if (ind_L1_MA_buffer[i] > ind_L2_MA_buffer[i])
    {
      L_Trend[i] = 1;
    }
    else
    {
      L_Trend[i] = -1;
    }

    int L_diff = i - input_trend_grad_len;
    if ((L_diff >= 0))
    {

      if (L_Trend[i] == 1)
      {
        if ((ind_L1_MA_buffer[i] - ind_L1_MA_buffer[L_diff]) < 0)
        {
          L_Trend[i] = 0;
        }

        if ((ind_L2_MA_buffer[i] - ind_L2_MA_buffer[L_diff]) < 0)
        {
          L_Trend[i] = 0;
        }
      }

      if (L_Trend[i] == -1)
      {
        if ((ind_L1_MA_buffer[i] - ind_L1_MA_buffer[L_diff]) > 0)
        {
          L_Trend[i] = 0;
        }

        if ((ind_L2_MA_buffer[i] - ind_L2_MA_buffer[L_diff]) > 0)
        {
          L_Trend[i] = 0;
        }
      }
    }

    // 短期トレンドの描写調整
    switch ((int)S_Trend[i])
    {
    case 1:
      ind_S1_ribbon_up_buffer[i] = ind_S1_MA_buffer[i];
      ind_S2_ribbon_up_buffer[i] = ind_S2_MA_buffer[i];
      if (S_Trend[i - 1] != 1)
      {
        ind_S1_ribbon_up_buffer[i - 1] = ind_S1_MA_buffer[i - 1];
        ind_S2_ribbon_up_buffer[i - 1] = ind_S2_MA_buffer[i - 1];
      }
      break;
    case 0:
      ind_S1_ribbon_range_buffer[i] = ind_S1_MA_buffer[i];
      ind_S2_ribbon_range_buffer[i] = ind_S2_MA_buffer[i];
      if (S_Trend[i - 1] != 0)
      {
        ind_S1_ribbon_range_buffer[i - 1] = ind_S1_MA_buffer[i - 1];
        ind_S2_ribbon_range_buffer[i - 1] = ind_S2_MA_buffer[i - 1];
      }
      break;
    case -1:
      ind_S1_ribbon_down_buffer[i] = ind_S1_MA_buffer[i];
      ind_S2_ribbon_down_buffer[i] = ind_S2_MA_buffer[i];
      if (S_Trend[i - 1] != -1)
      {
        ind_S1_ribbon_down_buffer[i - 1] = ind_S1_MA_buffer[i - 1];
        ind_S2_ribbon_down_buffer[i - 1] = ind_S2_MA_buffer[i - 1];
      }
      break;
    }

    // 中期トレンドの描写調整
    switch ((int)M_Trend[i])
    {
    case 1:
      ind_M1_ribbon_up_buffer[i] = ind_M1_MA_buffer[i];
      ind_M2_ribbon_up_buffer[i] = ind_M2_MA_buffer[i];
      if (M_Trend[i - 1] != 1)
      {
        ind_M1_ribbon_up_buffer[i - 1] = ind_M1_MA_buffer[i - 1];
        ind_M2_ribbon_up_buffer[i - 1] = ind_M2_MA_buffer[i - 1];
      }
      break;
    case 0:
      ind_M1_ribbon_range_buffer[i] = ind_M1_MA_buffer[i];
      ind_M2_ribbon_range_buffer[i] = ind_M2_MA_buffer[i];
      if (M_Trend[i - 1] != 0)
      {
        ind_M1_ribbon_range_buffer[i - 1] = ind_M1_MA_buffer[i - 1];
        ind_M2_ribbon_range_buffer[i - 1] = ind_M2_MA_buffer[i - 1];
      }
      break;
    case -1:
      ind_M1_ribbon_down_buffer[i] = ind_M1_MA_buffer[i];
      ind_M2_ribbon_down_buffer[i] = ind_M2_MA_buffer[i];
      if (M_Trend[i - 1] != -1)
      {
        ind_M1_ribbon_down_buffer[i - 1] = ind_M1_MA_buffer[i - 1];
        ind_M2_ribbon_down_buffer[i - 1] = ind_M2_MA_buffer[i - 1];
      }
      break;
    }

    // 長期トレンドの描写調整
    switch ((int)L_Trend[i])
    {
    case 1:
      ind_L1_ribbon_up_buffer[i] = ind_L1_MA_buffer[i];
      ind_L2_ribbon_up_buffer[i] = ind_L2_MA_buffer[i];
      if (L_Trend[i - 1] != 1)
      {
        ind_L1_ribbon_up_buffer[i - 1] = ind_L1_MA_buffer[i - 1];
        ind_L2_ribbon_up_buffer[i - 1] = ind_L2_MA_buffer[i - 1];
      }
      break;
    case 0:
      ind_L1_ribbon_range_buffer[i] = ind_L1_MA_buffer[i];
      ind_L2_ribbon_range_buffer[i] = ind_L2_MA_buffer[i];
      if (L_Trend[i - 1] != 0)
      {
        ind_L1_ribbon_range_buffer[i - 1] = ind_L1_MA_buffer[i - 1];
        ind_L2_ribbon_range_buffer[i - 1] = ind_L2_MA_buffer[i - 1];
      }
      break;
    case -1:
      ind_L1_ribbon_down_buffer[i] = ind_L1_MA_buffer[i];
      ind_L2_ribbon_down_buffer[i] = ind_L2_MA_buffer[i];
      if (L_Trend[i - 1] != -1)
      {
        ind_L1_ribbon_down_buffer[i - 1] = ind_L1_MA_buffer[i - 1];
        ind_L2_ribbon_down_buffer[i - 1] = ind_L2_MA_buffer[i - 1];
      }
      break;
    }
  }

  return (rates_total);
}