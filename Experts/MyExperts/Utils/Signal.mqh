//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "../RunEA.mq5"


//+------------------------------------------------------------------+
//| Input
//+------------------------------------------------------------------+
input int                   input_MA_D_fast_len     = 10;           // 速い移動平均線の期間
input int                   input_MA_D_slow_len     = 30;           // 遅い移動平均線の期間
input ENUM_MA_METHOD        input_MA_D_type         = MODE_SMA;     // 移動平均線の種別
input ENUM_APPLIED_PRICE    input_MA_D_price_type   = PRICE_CLOSE;  // 移動平均線の計算基準


//+------------------------------------------------------------------+
//| Global
//+------------------------------------------------------------------+
int                         custom_handle;
bool                        is_invalid                      = false;    // 初期化失敗の判定
bool                        is_go_long                      = false;    // 買い信号
bool                        is_go_short                     = false;    // 売り信号


//+------------------------------------------------------------------+
//| Function
//+------------------------------------------------------------------+
void InitSignal() {

// 外部インディケーターのハンドルの取得（iCustom形式）
    custom_handle = iCustom(
                        _Symbol,
                        PERIOD_CURRENT,
                        "MyIndicators/Signal/MA_D.ex5",
                        input_MA_D_fast_len,
                        input_MA_D_slow_len,
                        input_MA_D_type,
                        input_MA_D_price_type
                    );


//--- ハンドルの取得が失敗している場合の例外処理
    if(custom_handle == INVALID_HANDLE) {
        Print("インジケーターのハンドルの取得に失敗しました。");
        is_invalid = true;
    }
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateSingal() {

//--- 売買信号の状態を更新する処理（使用する指標ごとに書き換え）
    double buy_signal[];
    double sell_signal[];

    ArraySetAsSeries(buy_signal, true);
    ArraySetAsSeries(sell_signal, true);

    int start_pos = 0, end_pos = 2;

//--- バッファの複製
    CopyBuffer(custom_handle, 0, start_pos, end_pos, buy_signal);
    CopyBuffer(custom_handle, 1, start_pos, end_pos, sell_signal);


//--- 売買信号の更新
//--- 基本的には、1期間前（確定足）で判断する
    if(buy_signal[0] != EMPTY_VALUE)
        is_go_long = true;
    else
        is_go_long = false;

    if(sell_signal[0] != EMPTY_VALUE)
        is_go_short = true;
    else
        is_go_short = false;
}

//+------------------------------------------------------------------+
