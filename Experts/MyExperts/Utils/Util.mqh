//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "../RunEA.mq5"


//+------------------------------------------------------------------+
//| 銘柄のクォーツデータの更新
//+------------------------------------------------------------------+
bool RefreshRates(void) {

//--- symbolメンバのtick構造体を最新に更新
    if(!ins_symbol.RefreshRates()) {
        Print("銘柄の各種情報の更新に失敗しました。");
        return(false);
    }

//--- AskとBidの取得値が0である場合の例外処理
    if(ins_symbol.GetAsk() == 0 || ins_symbol.GetBid() == 0) {
        Print("Ask・Bidの取得に失敗しました。");
        return(false);
    }

//---
    return(true);
}



//+------------------------------------------------------------------+
//| バッファを動的配列に複製
//+------------------------------------------------------------------+
double iGetArray(
    const int handle,
    const int buffer,
    const int start_pos,
    const int end_pos,
    double &arr_buffer[]
) {
    bool result = true;

//--- arr_bufferが動的配列であることの確認
    if(!ArrayIsDynamic(arr_buffer)) {
        Print("引数として静的配列が渡されています。動的配列を渡してください。");
        return(false);
    }

//--- 動的配列のメモリ解放（無要素の状態にする）
    ArrayFree(arr_buffer);

    ResetLastError();

    int copied = CopyBuffer(handle, buffer, start_pos, end_pos, arr_buffer);
    if(copied != end_pos) {
        PrintFormat(
            "指標バッファからデータを複製する処理に失敗しました。エラーコード：%d",
            GetLastError()
        );
        return(false);
    }

//---
    return(result);
}


//+------------------------------------------------------------------+
//| 参照渡しの引数に対して、フリーズレベル・ストップレベルに余裕を持たせた値を代入
//+------------------------------------------------------------------+
bool GetFreezeStopsLevels(double &level) {
    /*
       Type of order/position   |  Activation price  |  Check
       -------------------------|--------------------|--------------------------------------------
       Buy Limit order          |  Ask               |  Ask-OpenPrice  >= SYMBOL_TRADE_FREEZE_LEVEL
       Buy Stop order           |  Ask               |  OpenPrice-Ask  >= SYMBOL_TRADE_FREEZE_LEVEL
       Sell Limit order         |  Bid               |  OpenPrice-Bid  >= SYMBOL_TRADE_FREEZE_LEVEL
       Sell Stop order          |  Bid               |  Bid-OpenPrice  >= SYMBOL_TRADE_FREEZE_LEVEL
       Buy position             |  Bid               |  TakeProfit-Bid >= SYMBOL_TRADE_FREEZE_LEVEL
                                |                    |  Bid-StopLoss   >= SYMBOL_TRADE_FREEZE_LEVEL
       Sell position            |  Ask               |  Ask-TakeProfit >= SYMBOL_TRADE_FREEZE_LEVEL
                                |                    |  StopLoss-Ask   >= SYMBOL_TRADE_FREEZE_LEVEL

       Buying is done at the Ask price                 |  Selling is done at the Bid price
       ------------------------------------------------|----------------------------------
       TakeProfit        >= Bid                        |  TakeProfit        <= Ask
       StopLoss          <= Bid                        |  StopLoss          >= Ask
       TakeProfit - Bid  >= SYMBOL_TRADE_STOPS_LEVEL   |  Ask - TakeProfit  >= SYMBOL_TRADE_STOPS_LEVEL
       Bid - StopLoss    >= SYMBOL_TRADE_STOPS_LEVEL   |  StopLoss - Ask    >= SYMBOL_TRADE_STOPS_LEVEL
    */

//--- 銘柄の各種値を最新版に更新
    if(!RefreshRates() || !ins_symbol.Refresh())
        return(false);

//--- フリーズレベルの算出（確実性を考慮して、算出値に定数を乗算）
    double freeze_level = ins_symbol.GetFreezeLevel() * ins_symbol.GetPoint();
    if(freeze_level == 0.0)
        freeze_level = (ins_symbol.GetAsk() - ins_symbol.GetBid()) * 3.0;
    freeze_level *= 1.1;

//--- ストップレベルの案出（確実性を考慮して、算出値に定数を乗算）
    double stop_level = ins_symbol.GetStopsLevel() * ins_symbol.GetPoint();
    if(stop_level == 0.0)
        stop_level = (ins_symbol.GetAsk() - ins_symbol.GetBid()) * 3.0;
    stop_level *= 1.1;

//--- 例外処理
    if(freeze_level <= 0.0 || stop_level <= 0.0)
        return(false);

//--- 確実性を考慮して、より大きいレベルの方を採用
    level = (freeze_level > stop_level) ? freeze_level : stop_level;

//---
    return(true);
}


//+------------------------------------------------------------------+
//| 同銘柄・同マジックナンバーの建玉の存在を確認
//+------------------------------------------------------------------+
bool IsPositionExists(void) {
    int total = PositionsTotal();

    for(int i = total - 1; i >= 0; i--)
        if(ins_position.SelectByIndex(i))
            if(ins_position.GetSymbol() == ins_symbol.GetName() && ins_position.GetMagicNumber() == input_magic_number)
                return(true);

//---
    return(false);
}


//+------------------------------------------------------------------+
