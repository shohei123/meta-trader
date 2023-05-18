//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "../RunEA.mq5"


//+------------------------------------------------------------------+
//| 新規注文のラッパー
//+------------------------------------------------------------------+
void OpenPositionByType(const ENUM_POSITION_TYPE pos_type) {

    if(!RefreshRates() || !ins_symbol.Refresh()) {
        Print(__FUNCTION__, "：気配値の更新に失敗しました");
        return;
    }


    double freeze_level = ins_symbol.GetFreezeLevel() * ins_symbol.GetPoint();
    if(freeze_level == 0.0)
        freeze_level = (ins_symbol.GetAsk() - ins_symbol.GetBid()) * 3.0;
    freeze_level *= 1.1;

    double stop_level = ins_symbol.GetStopsLevel() * ins_symbol.GetPoint();
    if(stop_level == 0.0)
        stop_level = (ins_symbol.GetAsk() - ins_symbol.GetBid()) * 3.0;
    stop_level *= 1.1;

    if(freeze_level <= 0.0 || stop_level <= 0.0)
        return;

    if(pos_type == POSITION_TYPE_BUY) {
        double price = ins_symbol.GetAsk();
        double sl = (input_stop_loss == 0) ? 0.0 : price - adjusted_stop_loss;
        double tp = (input_take_profit == 0) ? 0.0 : price + adjusted_take_profit;

        if(((sl != 0 && adjusted_stop_loss >= stop_level) || sl == 0.0) && ((tp != 0 && adjusted_take_profit >= stop_level) || tp == 0.0)) {
            OpenBuy(sl, tp);
            return;
        }
        //---
        else {
            Print(__FUNCTION__, "：買い注文のslまたはtpに誤りがあるので、注文できません。");
        }
    }

    if(pos_type == POSITION_TYPE_SELL) {
        double price = ins_symbol.GetBid();
        double sl = (input_stop_loss == 0) ? 0.0 : price + adjusted_stop_loss;
        double tp = (input_take_profit == 0) ? 0.0 : price - adjusted_take_profit;

        if(((sl != 0 && adjusted_stop_loss >= stop_level) || sl == 0.0) && ((tp != 0 && adjusted_take_profit >= stop_level) || tp == 0.0)) {
            OpenSell(sl, tp);
            return;
        }
        //---
        else {
            Print(__FUNCTION__, "：売り注文のslまたはtpに誤りがあるので、注文できません。");
        }
    }
}


//+------------------------------------------------------------------+
//| 売買建玉の個数を代入（取引量は不問）
//+------------------------------------------------------------------+
void CalcAllPositions(int &num_long, int &num_short) {
    num_long = 0;
    num_short = 0;

    for(int i = PositionsTotal() - 1; i >= 0; i--)
        if(ins_position.SelectByIndex(i))
            if(ins_position.GetSymbol() == ins_symbol.GetName() && ins_position.GetMagicNumber() == input_magic_number) {
                if(ins_position.GetPositionType() == POSITION_TYPE_BUY)
                    num_long++;

                if(ins_position.GetPositionType() == POSITION_TYPE_SELL)
                    num_short++;
            }

//---
    return;
}



//+------------------------------------------------------------------+
//| ポジションの有無と方向の確認
//+------------------------------------------------------------------+
double CheckPosition(string const symbol) {
    bool res = false;

//--- ヘッジアカウントの場合は、銘柄・マジックナンバーの一致するポジションを選択
    if((ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING) {
        uint total = PositionsTotal();
        for(uint i = 0; i < total; i++) {
            string position_symbol = PositionGetSymbol(i);
            if(position_symbol == symbol && input_magic_number == PositionGetInteger(POSITION_MAGIC)) {
                res = true;
                break;
            }
        }
    }

//--- ネットアカウントの場合
    else
        res = PositionSelect(symbol);

//--- ポジションがある場合には、売買方向に応じて正負調整した取引量を返却
    if(res) {
        double volume = PositionGetDouble(POSITION_VOLUME);

        if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            return(volume);
        else
            return(volume * -1);
    }

//--- ポジション無しの場合は、0を返却
    else
        return(0);
}


//+------------------------------------------------------------------+
