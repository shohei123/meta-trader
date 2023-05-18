//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "../RunEA.mq5"


//+------------------------------------------------------------------+
//| 買い注文
//+------------------------------------------------------------------+
void OpenBuy(double sl, double tp) {
    sl = ins_symbol.NormalizePrice(sl);
    tp = ins_symbol.NormalizePrice(tp);

    double adjusted_long_lot = AdjustLotByCalcType(
                                   input_lot_calc_type,
                                   input_lot_value,
                                   ins_symbol.GetName(),
                                   ORDER_TYPE_BUY,
                                   ins_symbol.GetAsk(),
                                   sl
                               );

    if(adjusted_long_lot == 0.0) {
        if(input_print_log)
            Print(__FUNCTION__, "：取引量が0ロットになっています。");
        return;
    }

    if(input_print_log)
        Print(
            "損切りの価格：", DoubleToString(sl, ins_symbol.GetDigits()),
            ",　取引量（lot）：", DoubleToString(adjusted_long_lot, 2),
            ",　残高： ",    DoubleToString(ins_account.GetBalance(), 2),
            ",　有効証拠金：", DoubleToString(ins_account.GetEquity(), 2),
            ",　余剰証拠金：", DoubleToString(ins_account.GetFreeMargin(), 2)
        );



//--- 買いポ建玉を持った後の余剰証拠金
    double after_free_margin = ins_account.CalcFreeMargin(
                                   ins_symbol.GetName(),
                                   ORDER_TYPE_BUY,
                                   adjusted_long_lot,
                                   ins_symbol.GetAsk()
                               );

//--- ポ建玉の決済時に必要になる証拠金
    double exit_margin = ins_account.CalcMargin(
                             ins_symbol.GetName(),
                             ORDER_TYPE_SELL,
                             adjusted_long_lot,
                             ins_symbol.GetBid()
                         );

//--- 決済時点も考慮して、充分な余剰証拠金がある場合
    if(after_free_margin > exit_margin) {
        //--- 成行注文の発注に成功
        if(ins_trading.Buy(adjusted_long_lot, ins_symbol.GetName(), ins_symbol.GetAsk(), sl, tp)) {
            //--- 約定チケットが存在しない場合
            if(ins_trading.GetResultDeal() == 0) {
                //--- リクエスト完了の状態
                if(ins_trading.GetResultRetCode() == 10009) {
                    is_transaction_waiting = true; // "true" -> it's forbidden to trade, we expect a transaction
                    order_ticket_waiting = ins_trading.GetResultOrder();

                    if(input_print_log) {
                        Print("#1 成行注文（買い）に失敗しました。リターンコード：", ins_trading.GetResultRetCode(),
                              " 説明：", ins_trading.GetResultRetCodeDescription());
                        PrintResultTrade();
                    }
                }
            }

            //--- 約定チケットが存在する場合
            else {
                //--- リクエスト完了の状態
                if(ins_trading.GetResultRetCode() == 10009) {
                    is_transaction_waiting = true; // "true" -> it's forbidden to trade, we expect a transaction
                    order_ticket_waiting = ins_trading.GetResultOrder();
                }
                if(input_print_log) {
                    Print("#2 成行注文（買い）に成功しました。リターンコード：", ins_trading.GetResultRetCode(),
                          " 説明：", ins_trading.GetResultRetCodeDescription());
                    PrintResultTrade();
                }
            }
        }

        //--- 成行注文の発注に失敗
        else {
            if(input_print_log) {
                Print("#3 成行注文（買い）に成功しました。リターンコード：", ins_trading.GetResultRetCode(),
                      " 説明：", ins_trading.GetResultRetCodeDescription());
                PrintResultTrade();
            }
        }
    }

//--- 決済時点で証拠金が不足する危険がある場合
    else {
        if(input_print_log)
            Print(__FUNCTION__, "：決済時に資金が足りなくなる危険があります。予想される不足金額（", DoubleToString(exit_margin - after_free_margin, 2), "）");
        return;
    }
}


//+------------------------------------------------------------------+
//| 売り注文
//+------------------------------------------------------------------+
void OpenSell(double sl, double tp) {
    sl = ins_symbol.NormalizePrice(sl);
    tp = ins_symbol.NormalizePrice(tp);

    double adjusted_short_lot = AdjustLotByCalcType(
                                    input_lot_calc_type,
                                    input_lot_value,
                                    ins_symbol.GetName(),
                                    ORDER_TYPE_SELL,
                                    ins_symbol.GetBid(),
                                    sl
                                );
    if(adjusted_short_lot == 0.0) {
        if(input_print_log)
            Print(__FUNCTION__, "：取引量が0ロットになっています。");
        return;
    }

    if(input_print_log)
        Print(
            "損切りの価格：", DoubleToString(sl, ins_symbol.GetDigits()),
            ",　取引量（lot）：", DoubleToString(adjusted_short_lot, 2),
            ",　残高： ",    DoubleToString(ins_account.GetBalance(), 2),
            ",　有効証拠金：", DoubleToString(ins_account.GetEquity(), 2),
            ",　余剰証拠金：", DoubleToString(ins_account.GetFreeMargin(), 2)
        );




//--- 売りポ建玉を持った後の余剰証拠金
    double after_free_margin = ins_account.CalcFreeMargin(
                                   ins_symbol.GetName(),
                                   ORDER_TYPE_SELL,
                                   adjusted_short_lot,
                                   ins_symbol.GetBid()
                               );

//--- 建玉の決済時に必要になる証拠金
    double exit_margin = ins_account.CalcMargin(
                             ins_symbol.GetName(),
                             ORDER_TYPE_SELL,
                             adjusted_short_lot,
                             ins_symbol.GetBid()
                         );

//--- 決済時点も考慮して、充分な余剰証拠金がある場合
    if(after_free_margin > exit_margin) {
        //--- 成行注文の発注に成功
        if(ins_trading.Sell(adjusted_short_lot, ins_symbol.GetName(), ins_symbol.GetBid(), sl, tp)) {
            //--- 約定チケットが存在しないが、リクエストは成功した場合
            if(ins_trading.GetResultDeal() == 0) {
                if(ins_trading.GetResultRetCode() == 10009) {
                    is_transaction_waiting = true; // "true" -> 取引を待っている状態
                    order_ticket_waiting = ins_trading.GetResultOrder();

                    if(input_print_log) {
                        Print(
                            "#1 成行注文（売り）がリクエストされ、約定待ちです。リターンコード：", ins_trading.GetResultRetCode(), "\n",
                            " 説明：", ins_trading.GetResultRetCodeDescription());
                        PrintResultTrade();
                    }
                }
            }

            //--- 約定チケットが存在し、リクエストが成功した場合
            else {
                if(ins_trading.GetResultRetCode() == 10009) {
                    is_transaction_waiting = true; // "true" -> 取引を待っている状態
                    order_ticket_waiting = ins_trading.GetResultOrder();
                }
                if(input_print_log) {
                    Print(
                        "#2 成行注文（売り）が約定しました。リターンコード：", ins_trading.GetResultRetCode(), "\n",
                        " 説明：", ins_trading.GetResultRetCodeDescription()
                    );
                    PrintResultTrade();
                }
            }
        }

        //--- 成行注文の発注に失敗
        else {
            if(input_print_log) {
                Print("#3 成行注文（売り）に失敗しました。リターンコード：", ins_trading.GetResultRetCode(), "\n",
                      " 説明：", ins_trading.GetResultRetCodeDescription());
                PrintResultTrade();
            }
        }
    }

//--- 決済時点で証拠金が不足する危険がある場合
    else {
        if(input_print_log)
            Print(__FUNCTION__, "：決済時に資金が足りなくなる危険があります。予想される不足金額（", DoubleToString(exit_margin - after_free_margin, 2), "）");
        return;
    }
}


//+------------------------------------------------------------------+
//| ロットの算出方法に応じて、調整されたロット数を返却
//+------------------------------------------------------------------+
double AdjustLotByCalcType(
    ENUM_LOT_CALC_TYPE lot_calc_type,
    double lot_value,
    string symbol,
    ENUM_ORDER_TYPE order_type,
    double price,
    double sl
) {


//--- 引数についての例外処理
    if(lot_value <= 0.0 || symbol == "" || price <= 0.0) {
        Print(__FUNCTION__, "：引数の設定値に問題があります。");
        return(0.0);
    }

//--- 取引量の算出方法ごとに、取引量を計算
    double lot = 0.0;

//--- 固定値の場合
    if(lot_calc_type == fixed) {
        lot = lot_value;
    }

//--- 残高に対する百分率の場合
    else if(lot_calc_type == percent) {
        //--- 1ロットを約定するために必要な証拠金（つまり、1ロットあたりの取引価格）
        double margin = 0.0;
        if(!OrderCalcMargin(order_type, symbol, 1.0, price, margin) || margin <= 0.0) {
            Print(__FUNCTION__, "：marginの計算時に問題が発生しました。");
            return(0.0);
        }
        lot = ins_account.GetFreeMargin() / margin / 100.0 * lot_value;
    }

//--- 残高に対する損失許容額の百分率の場合
    else if(lot_calc_type == risk) {
        double diff = MathAbs(price - sl);
        double acceptable_loss_amount = ins_account.GetFreeMargin() / 100.0 * lot_value / diff;
        //--- 損失を許容可能な通貨量を「1ロットあたりの通貨量」で除して、ロットに換算
        lot = acceptable_loss_amount / ins_symbol.GetContractSize();
    }

//---
    else {
        Print(__FUNCTION__, "：ロットの計算方法の指定に問題があります。");
        return(0.0);
    }

    double adjusted_lot = CheckAppropriateLot(ins_symbol.GetName(), NormalizeDouble(lot, 2));

//---
    return(adjusted_lot);
}


//+------------------------------------------------------------------+
//| 発注可能なロット量か確認
//+------------------------------------------------------------------+
double CheckAppropriateLot(string symbol, double lot) {
    double adjusted_lot = 0.0;

//--- 発注可能なロット刻み幅に適合するように調整
    double step_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
    if(step_lot > 0.0)
        adjusted_lot = step_lot * MathFloor(lot / step_lot);

//--- 発注可能な最大取引量の上限・下限の範囲内に収まるように調整
    double min_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    if(adjusted_lot < min_lot)
        adjusted_lot = 0.0;

    double max_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
    if(adjusted_lot > max_lot)
        adjusted_lot = max_lot;

//---
    return(adjusted_lot);
}


//+------------------------------------------------------------------+
