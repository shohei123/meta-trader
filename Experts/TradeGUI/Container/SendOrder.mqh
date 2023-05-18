//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+

#include "../Program.mqh"


//+------------------------------------------------------------------+
//| 取引環境の初期化
//+------------------------------------------------------------------+
void CProgram::OnInitTrading(void) {
    m_trading.SetExpertMagicNumber(m_magic_number);
}


//+------------------------------------------------------------------+
//| 買いの成行注文の実行
//+------------------------------------------------------------------+
void CProgram::SetBuyOrder(void) {
//--- 成行注文のウィンドウが表示されていたら実行
    if(m_market_order_window.IsVisible()) {
        double lot = 0.0, sl = 0.0, tp = 0.0;
        double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

//--- Lot編集欄が入金額に対する割合指定の場合
        if(m_market_order_switch_buttons[0].IsPressed())
            lot = LotPercent(_Symbol, ORDER_TYPE_BUY, SymbolInfoDouble(_Symbol, SYMBOL_ASK), StringToDouble(m_market_order_lot_edits[0].GetValue()));

//--- Lotが固定量の場合
        else
            lot = NormalizeLot(_Symbol, StringToDouble(m_market_order_lot_edits[0].GetValue()));

//--- 利食い・損切りの入力欄が両方とも価格設定になっている場合
        if(m_market_order_switch_buttons[1].IsPressed() && m_market_order_switch_buttons[2].IsPressed()) {
            tp = double(m_market_order_tp_edits[0].GetValue());
            sl = double(m_market_order_sl_edits[0].GetValue());
        }

//--- 利食い・損切りともに、pips指定の場合
        else if(!m_market_order_switch_buttons[1].IsPressed() && !m_market_order_switch_buttons[2].IsPressed()) {
            tp = SymbolInfoDouble(_Symbol, SYMBOL_ASK) + double(m_market_order_tp_edits[0].GetValue()) * point;
            sl = SymbolInfoDouble(_Symbol, SYMBOL_ASK) - double(m_market_order_sl_edits[0].GetValue()) * point;
        }

//--- 利食いは価格指定、損切りはpips指定の場合
        else if(m_market_order_switch_buttons[1].IsPressed() && !m_market_order_switch_buttons[2].IsPressed()) {
            tp = double(m_market_order_tp_edits[0].GetValue());
            sl = SymbolInfoDouble(_Symbol, SYMBOL_ASK) - double(m_market_order_sl_edits[0].GetValue()) * point;
        }

//--- 利食いはpips指定、損切りは価格指定の場合
        else if(!m_market_order_switch_buttons[1].IsPressed() && m_market_order_switch_buttons[2].IsPressed()) {
            tp = SymbolInfoDouble(_Symbol, SYMBOL_ASK) + double(m_market_order_tp_edits[0].GetValue()) * point;
            sl = double(m_market_order_sl_edits[0].GetValue());
        }

//--- 確認ダイアログの表示
        string formated_text = FormatOrderDialogText("成行（買い）", _Symbol, SymbolInfoDouble(_Symbol, SYMBOL_ASK), lot, sl, tp);
        int reaction = MessageBox(formated_text, "確認", MB_YESNO);

        if(reaction == IDYES) {
            if(!m_trading.Buy(lot, _Symbol, SymbolInfoDouble(_Symbol, SYMBOL_ASK), sl, tp))
                Print("成行注文（買い）に成功しました");
            else
                PrintFormat("成行注文（買い）に失敗しました。エラー：%d", GetLastError());
        }
    }
}


//+------------------------------------------------------------------+
//| 売りの成行注文の実行
//+------------------------------------------------------------------+
void CProgram::SetSellOrder(void) {
//--- 成行注文のウィンドウが表示されていたら実行
    if(m_market_order_window.IsVisible()) {
        double lot = 0.0, sl = 0.0, tp = 0.0;
        double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

//--- Lot編集欄が入金額に対する割合指定の場合
        if(m_market_order_switch_buttons[3].IsPressed())
            lot = LotPercent(_Symbol, ORDER_TYPE_SELL, SymbolInfoDouble(_Symbol, SYMBOL_BID), StringToDouble(m_market_order_lot_edits[1].GetValue()));

//--- Lotが固定量の場合
        else
            lot = NormalizeLot(_Symbol, StringToDouble(m_market_order_lot_edits[1].GetValue()));

//--- 利食い・損切りの入力欄が両方とも価格設定になっている場合
        if(m_market_order_switch_buttons[4].IsPressed() && m_market_order_switch_buttons[5].IsPressed()) {
            tp = double(m_market_order_tp_edits[1].GetValue());
            sl = double(m_market_order_sl_edits[1].GetValue());
        }

//--- 利食い・損切りともに、pips指定の場合
        else if(!m_market_order_switch_buttons[4].IsPressed() && !m_market_order_switch_buttons[5].IsPressed()) {
            tp = SymbolInfoDouble(_Symbol, SYMBOL_BID) - double(m_market_order_tp_edits[1].GetValue()) * point;
            sl = SymbolInfoDouble(_Symbol, SYMBOL_BID) + double(m_market_order_sl_edits[1].GetValue()) * point;
        }

//--- 利食いは価格指定、損切りはpips指定の場合
        else if(!m_market_order_switch_buttons[4].IsPressed() && m_market_order_switch_buttons[5].IsPressed()) {
            tp = SymbolInfoDouble(_Symbol, SYMBOL_BID) - double(m_market_order_tp_edits[1].GetValue()) * point;
            sl = double(m_market_order_sl_edits[1].GetValue());
        }

//--- 利食いはpips指定、損切りは価格指定の場合
        else if(m_market_order_switch_buttons[4].IsPressed() && !m_market_order_switch_buttons[5].IsPressed()) {
            tp = double(m_market_order_tp_edits[1].GetValue());
            sl = SymbolInfoDouble(_Symbol, SYMBOL_BID) + double(m_market_order_sl_edits[1].GetValue()) * point;
        }

//--- 確認ダイアログの表示
        string formated_text = FormatOrderDialogText("成行（売り）", _Symbol, SymbolInfoDouble(_Symbol, SYMBOL_BID), lot, sl, tp);
        int reaction = MessageBox(formated_text, "確認", MB_YESNO);

        if(reaction == IDYES) {
            if(m_trading.Sell(lot, _Symbol, SymbolInfoDouble(_Symbol, SYMBOL_BID), sl, tp))
                Print("成行注文（売り）に成功しました");
            else
                PrintFormat("成行注文（売り）に失敗しました。エラー：%d", GetLastError());

        }
    }
}

//+------------------------------------------------------------------+
//| 買いの指値注文の実行
//+------------------------------------------------------------------+
void CProgram::SetBuyLimitOrder(void) {
//--- 指値・逆指値のウィンドウが表示されていたら実行
    if(m_limit_order_window.IsVisible()) {
        double lot = 0.0, sl = 0.0, tp = 0.0;
        double price = double(m_limit_order_price_edits[0].GetValue());
        double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

//--- Lot編集欄が入金額に対する割合指定の場合
        if(m_limit_order_switch_buttons[0].IsPressed())
            lot = LotPercent(_Symbol, ORDER_TYPE_BUY, SymbolInfoDouble(_Symbol, SYMBOL_ASK), StringToDouble(m_limit_order_lot_edits[0].GetValue()));
        else
            lot = NormalizeLot(_Symbol, StringToDouble(m_limit_order_lot_edits[0].GetValue()));

//--- 利食い・損切りの入力欄が両方とも価格設定になっている場合
        if(m_limit_order_switch_buttons[1].IsPressed() && m_limit_order_switch_buttons[2].IsPressed()) {
            tp = double(m_limit_order_tp_edits[0].GetValue());
            sl = double(m_limit_order_sl_edits[0].GetValue());
        }

//--- 利食い・損切りともに、pips指定の場合
        else if(!m_limit_order_switch_buttons[1].IsPressed() && !m_limit_order_switch_buttons[2].IsPressed()) {
            tp =  price + double(m_limit_order_tp_edits[0].GetValue()) * point;
            sl =  price - double(m_limit_order_sl_edits[0].GetValue()) * point;
        }

//--- 利食いは価格指定、損切りはpips指定の場合
        else if(m_limit_order_switch_buttons[1].IsPressed() && !m_limit_order_switch_buttons[2].IsPressed()) {
            tp = double(m_limit_order_tp_edits[0].GetValue());
            sl =  price - double(m_limit_order_sl_edits[0].GetValue()) * point;
        }

//--- 利食いはpips指定、損切りは価格指定の場合
        else if(!m_limit_order_switch_buttons[1].IsPressed() && m_limit_order_switch_buttons[2].IsPressed()) {
            tp =  price + double(m_limit_order_tp_edits[0].GetValue()) * point;
            sl = double(m_limit_order_sl_edits[0].GetValue());
        }


//--- 確認ダイアログの表示
        string formated_text = FormatOrderDialogText("指値（買い）", _Symbol, price, lot, sl, tp);
        int reaction = MessageBox(formated_text, "確認", MB_YESNO);

        if(reaction == IDYES) {
            if(m_trading.BuyLimit(lot, price, _Symbol, sl, tp))
                Print("指値注文（買い）に成功しました。");
            else
                PrintFormat("指値注文（買い）に失敗しました。エラー：%d", GetLastError());
        }
    }
}


//+------------------------------------------------------------------+
//| 売りの指値注文の実行
//+------------------------------------------------------------------+
void CProgram::SetSellLimitOrder(void) {
//--- 指値・逆指値のウィンドウが表示されていたら実行
    if(m_limit_order_window.IsVisible()) {
        double lot = 0.0, sl = 0.0, tp = 0.0;
        double price = double(m_limit_order_price_edits[1].GetValue());
        double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

//--- Lot編集欄が入金額に対する割合指定の場合
        if(m_limit_order_switch_buttons[3].IsPressed())
            lot = LotPercent(_Symbol, ORDER_TYPE_BUY, SymbolInfoDouble(_Symbol, SYMBOL_BID), StringToDouble(m_limit_order_lot_edits[1].GetValue()));
        else
            lot = NormalizeLot(_Symbol, StringToDouble(m_limit_order_lot_edits[1].GetValue()));

//--- 利食い・損切りの入力欄が両方とも価格設定になっている場合
        if(m_limit_order_switch_buttons[4].IsPressed() && m_limit_order_switch_buttons[5].IsPressed()) {
            tp = double(m_limit_order_tp_edits[1].GetValue());
            sl = double(m_limit_order_sl_edits[1].GetValue());
        }

//--- 利食い・損切りともに、pips指定の場合
        else if(!m_limit_order_switch_buttons[4].IsPressed() && !m_limit_order_switch_buttons[5].IsPressed()) {
            tp =  price - double(m_limit_order_tp_edits[1].GetValue()) * point;
            sl =  price + double(m_limit_order_sl_edits[1].GetValue()) * point;
        }

//--- 食いは価格指定、損切りはpips指定の場合
        else if(m_limit_order_switch_buttons[4].IsPressed() && !m_limit_order_switch_buttons[5].IsPressed()) {
            tp = double(m_limit_order_tp_edits[1].GetValue());
            sl =  price + double(m_limit_order_sl_edits[1].GetValue()) * point;
        }

//--- 利食いはpips指定、損切りは価格指定の場合
        else if(!m_limit_order_switch_buttons[4].IsPressed() && m_limit_order_switch_buttons[5].IsPressed()) {
            tp =  price - double(m_limit_order_tp_edits[1].GetValue()) * point;
            sl = double(m_limit_order_sl_edits[1].GetValue());
        }

//--- 確認ダイアログの表示
        string formated_text = FormatOrderDialogText("指値（売り）", _Symbol, price, lot, sl, tp);
        int reaction = MessageBox(formated_text, "確認", MB_YESNO);

        if(reaction == IDYES) {
            if(m_trading.SellLimit(lot, price, _Symbol, sl, tp))
                Print("指値注文（売り）に成功しました。");
            else
                PrintFormat("指値注文（売り）に失敗しました。エラー：%d", GetLastError());
        }
    }
}


//+------------------------------------------------------------------+
//| 買いの逆指値注文の実行
//+------------------------------------------------------------------+
void CProgram::SetBuyStopOrder(void) {
//--- 指値・逆指値のウィンドウが表示されていたら実行
    if(m_stop_order_window.IsVisible()) {
        double lot = 0.0, sl = 0.0, tp = 0.0;
        double price = double(m_stop_order_price_edits[0].GetValue());
        double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

//--- Lot編集欄が入金額に対する割合指定の場合
        if(m_stop_order_switch_buttons[0].IsPressed())
            lot = LotPercent(_Symbol, ORDER_TYPE_BUY, SymbolInfoDouble(_Symbol, SYMBOL_ASK), StringToDouble(m_stop_order_lot_edits[0].GetValue()));
        else
            lot = NormalizeLot(_Symbol, StringToDouble(m_stop_order_lot_edits[0].GetValue()));

//--- 利食い・損切りの入力欄が両方とも価格設定になっている場合
        if(m_stop_order_switch_buttons[1].IsPressed() && m_stop_order_switch_buttons[2].IsPressed()) {
            tp = double(m_stop_order_tp_edits[0].GetValue());
            sl = double(m_stop_order_sl_edits[0].GetValue());
        }

//--- 利食い・損切りともに、pips指定の場合
        else if(!m_stop_order_switch_buttons[1].IsPressed() && !m_stop_order_switch_buttons[2].IsPressed()) {
            tp =  price + double(m_stop_order_tp_edits[0].GetValue()) * point;
            sl =  price - double(m_stop_order_sl_edits[0].GetValue()) * point;
        }

//--- 食いは価格指定、損切りはpips指定の場合
        else if(m_stop_order_switch_buttons[1].IsPressed() && !m_stop_order_switch_buttons[2].IsPressed()) {
            tp = double(m_stop_order_tp_edits[0].GetValue());
            sl =  price - double(m_stop_order_sl_edits[0].GetValue()) * point;
        }

//--- 利食いはpips指定、損切りは価格指定の場合
        else if(!m_stop_order_switch_buttons[1].IsPressed() && m_stop_order_switch_buttons[2].IsPressed()) {
            tp =  price + double(m_stop_order_tp_edits[0].GetValue()) * point;
            sl = double(m_stop_order_sl_edits[0].GetValue());
        }

//--- 確認ダイアログの表示
        string formated_text = FormatOrderDialogText("逆指値（買い）", _Symbol, price, lot, sl, tp);
        int reaction = MessageBox(formated_text, "確認", MB_YESNO);

        if(reaction == IDYES) {
            if(m_trading.BuyStop(lot, price, _Symbol, sl, tp))
                Print("逆指値注文（買い）に成功しました。");
            else
                PrintFormat("逆指値注文（買い）に失敗しました。エラー：%d", GetLastError());
        }
    }
}


//+------------------------------------------------------------------+
//| 売りの逆指値注文の実行
//+------------------------------------------------------------------+
void CProgram::SetSellStopOrder(void) {
//--- 指値・逆指値のウィンドウが表示されていたら実行
    if(m_stop_order_window.IsVisible()) {
        double lot = 0.0, sl = 0.0, tp = 0.0;
        double price = double(m_stop_order_price_edits[0].GetValue());
        double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

//--- Lot編集欄が入金額に対する割合指定の場合
        if(m_stop_order_switch_buttons[3].IsPressed())
            lot = LotPercent(_Symbol, ORDER_TYPE_BUY, SymbolInfoDouble(_Symbol, SYMBOL_BID), StringToDouble(m_stop_order_lot_edits[1].GetValue()));
        else
            lot = NormalizeLot(_Symbol, StringToDouble(m_stop_order_lot_edits[1].GetValue()));

//--- 利食い・損切りの入力欄が両方とも価格設定になっている場合
        if(m_stop_order_switch_buttons[4].IsPressed() && m_stop_order_switch_buttons[5].IsPressed()) {
            tp = double(m_stop_order_tp_edits[1].GetValue());
            sl = double(m_stop_order_sl_edits[1].GetValue());
        }

//--- 利食い・損切りともに、pips指定の場合
        else  if(!m_stop_order_switch_buttons[4].IsPressed() && !m_stop_order_switch_buttons[5].IsPressed()) {
            tp =  price - double(m_stop_order_tp_edits[1].GetValue()) * point;
            sl =  price + double(m_stop_order_sl_edits[1].GetValue()) * point;
        }

//--- 食いは価格指定、損切りはpips指定の場合
        else  if(m_stop_order_switch_buttons[4].IsPressed() && !m_stop_order_switch_buttons[5].IsPressed()) {
            tp = double(m_stop_order_tp_edits[1].GetValue());
            sl =  price + double(m_stop_order_sl_edits[1].GetValue()) * point;
        }

//--- 利食いはpips指定、損切りは価格指定の場合
        else  if(!m_stop_order_switch_buttons[4].IsPressed() && m_stop_order_switch_buttons[5].IsPressed()) {
            tp = price - double(m_stop_order_tp_edits[1].GetValue()) * point;
            sl = double(m_stop_order_sl_edits[1].GetValue());
        }

//--- 確認ダイアログの表示
        string formated_text = FormatOrderDialogText("逆指値（売り）", _Symbol, price, lot, sl, tp);
        int reaction = MessageBox(formated_text, "確認", MB_YESNO);

        if(reaction == IDYES) {
            if(m_trading.SellStop(lot, price, _Symbol, sl, tp))
                Print("逆指値注文（売り）に成功しました。");
            else
                PrintFormat("逆指値注文（売り）に失敗しました。エラー：%d", GetLastError());
        }
    }
}


//+------------------------------------------------------------------+
//| 取り扱う銘柄の規定取引量を考慮した正規化
//+------------------------------------------------------------------+
double CProgram::LotPercent(string symbol, ENUM_ORDER_TYPE trade_type, double price, double percent) {
    double margin = 0.0;

//--- 例外処理
    if(symbol == "" || price <= 0.0 || percent < 1 || percent > 100)
        return(0.0);

//--- 1Lotを取引するために必要な証拠金の額を算出
    if(!OrderCalcMargin(trade_type, symbol, 1.0, price, margin) || margin < 0.0)
        return(0.0);

//--- 例外処理
    if(margin == 0.0)
        return(0.0);

//--- 口座の残高に定率を乗じた金額（豆乳金額）をLot換算
    double volume = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE) * percent / 100.0 / margin, 2);

    volume = NormalizeLot(symbol, volume);

    return(volume);
}


//+------------------------------------------------------------------+
//| 取り扱う銘柄の規定取引量を考慮した正規化
//+------------------------------------------------------------------+
double CProgram::NormalizeLot(string symbol,  double volume) {
//--- その銘柄の取引量の刻み幅に適合するように、取引量を正規化
    double stepvol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
    if(stepvol > 0.0)
        volume = stepvol * MathFloor(volume / stepvol);

//--- その銘柄における最小取引量を超えているのか確認（下回ったら、0に矯正）
    double minvol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    if(volume < minvol)
        volume = 0.0;

//--- その銘柄における最小取引量を下回るのか確認（超過したら、最大取引量に矯正）
    double maxvol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
    if(volume > maxvol)
        volume = maxvol;

    return(volume);

}


//+------------------------------------------------------------------+
//| 含み益の約定注文の全決済
//+------------------------------------------------------------------+
void CProgram::CloseAllMarketProfit(void) {
    int reaction = MessageBox("含み益のある約定注文を全て決済します。よろしいですか?", "確認", MB_YESNO);

    if (reaction == IDYES) {
        MqlTradeRequest request;
        MqlTradeResult  result;

        int total = PositionsTotal();

        //--- ポジションを最後から決済することで、ポジション数とインデックスのズレを回避
        for(int i = total - 1; i >= 0; i--) {
            ulong  position_ticket = PositionGetTicket(i);
            string position_symbol = PositionGetString(POSITION_SYMBOL);
            int    digits = (int)SymbolInfoInteger(position_symbol, SYMBOL_DIGITS);
            ulong  magic = PositionGetInteger(POSITION_MAGIC);
            double volume = PositionGetDouble(POSITION_VOLUME);
            ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            double profit = PositionGetDouble(POSITION_PROFIT);
            double swap = PositionGetDouble(POSITION_SWAP);

            if(magic == m_magic_number)
                if(position_symbol == _Symbol)
                    //--- スワップを考慮した含み益ポジションのみ実行
                    if(profit + swap > 0) {
                        ZeroMemory(request);
                        ZeroMemory(result);

                        request.action   = TRADE_ACTION_DEAL;
                        request.position = position_ticket;
                        request.symbol   = position_symbol;
                        request.volume   = volume;
                        request.deviation = 5;
                        request.magic    = m_magic_number;

                        //--- 決済ポジションと反対方向のPOSITION_TYPEを設定
                        if(type == POSITION_TYPE_BUY) {
                            request.price = SymbolInfoDouble(position_symbol, SYMBOL_BID);
                            request.type = ORDER_TYPE_SELL;
                        } else {
                            request.price = SymbolInfoDouble(position_symbol, SYMBOL_ASK);
                            request.type = ORDER_TYPE_BUY;
                        }

                        if(!OrderSend(request, result))
                            PrintFormat("含み益のあるポジションの決済に失敗しました。エラー： %d", GetLastError());
                    }
        }
    }
}

//+------------------------------------------------------------------+
//| 含み損の約定注文の全決済
//+------------------------------------------------------------------+
void CProgram::CloseAllMarketLoss(void) {
    int reaction = MessageBox("含み損のある約定注文を全て決済します。よろしいですか?", "確認", MB_YESNO);

    if (reaction == IDYES) {
        MqlTradeRequest request;
        MqlTradeResult  result;

        int total = PositionsTotal();

        //--- ポジションを最後から決済することで、ポジション数とインデックスのズレを回避
        for(int i = total - 1; i >= 0; i--) {
            ulong  position_ticket = PositionGetTicket(i);
            string position_symbol = PositionGetString(POSITION_SYMBOL);
            int    digits = (int)SymbolInfoInteger(position_symbol, SYMBOL_DIGITS);
            ulong  magic = PositionGetInteger(POSITION_MAGIC);
            double volume = PositionGetDouble(POSITION_VOLUME);
            ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            double profit = PositionGetDouble(POSITION_PROFIT);
            double swap = PositionGetDouble(POSITION_SWAP);

            if(magic == m_magic_number)
                if(position_symbol == _Symbol)
                    //--- スワップを考慮した含み損ポジションのみ実行
                    if(profit + swap < 0) {
                        ZeroMemory(request);
                        ZeroMemory(result);

                        request.action   = TRADE_ACTION_DEAL;
                        request.position = position_ticket;
                        request.symbol   = position_symbol;
                        request.volume   = volume;
                        request.deviation = 5;
                        request.magic    = m_magic_number;

                        //--- 決済ポジションと反対方向のPOSITION_TYPEを設定
                        if(type == POSITION_TYPE_BUY) {
                            request.price = SymbolInfoDouble(position_symbol, SYMBOL_BID);
                            request.type = ORDER_TYPE_SELL;
                        } else {
                            request.price = SymbolInfoDouble(position_symbol, SYMBOL_ASK);
                            request.type = ORDER_TYPE_BUY;
                        }

                        if(!OrderSend(request, result))
                            PrintFormat("含み損のあるポジションの決済に失敗しました。エラー： %d", GetLastError());
                    }
        }
    }
}


//+------------------------------------------------------------------+
//| 未決注文の全削除
//+------------------------------------------------------------------+
void CProgram::RemoveAllPosition(void) {
    int reaction = MessageBox("未決注文を全て削除します。よろしいですか?", "確認", MB_YESNO);

    if (reaction == IDYES)
        m_trading.PendingOrderAllDelete();
}

//+------------------------------------------------------------------+
