//+------------------------------------------------------------------+
//| propertyの宣言
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+
#include "./Program.mqh"
#include <GetFontName.mqh>


//+------------------------------------------------------------------+
//| 入力値の定義
//+------------------------------------------------------------------+
input int input_base_font_size = 10;
input type_font input_base_font_type = 23; // MS Sans Serif
input color input_caption_background_color = clrRoyalBlue;
input color input_background_color = clrWhite;
input ulong input_magic_number = 12345;


//+------------------------------------------------------------------+
//| グローバル変数の宣言
//+------------------------------------------------------------------+
CProgram program;
ulong tick_counter;


//+------------------------------------------------------------------+
//| Expert initialization function
//+------------------------------------------------------------------+
int OnInit(void)
   {
    tick_counter = ::GetTickCount();

// Enum型の数値に対応する書体情報を取得
    CFontName FontName;
    string font_name = FontName.GetFontName(input_base_font_type);

// EAの実行連動させたいメソッドを実行
    program.SetFontSize(input_base_font_size);
    program.SetFontName(font_name);
    program.SetCaptionBackgroundColor(input_caption_background_color);
    program.SetBackgroundColor(input_background_color);
    program.SetMagicNumber(input_magic_number);

// GUIの作成(MainWindow.mqhで定義)
    if(!program.CreateGUI())
       {
        ::Print(__FUNCTION__, " > GUIの作成に失敗しました。");
        return (INIT_FAILED);
       }

    return (INIT_SUCCEEDED);
   }


//+------------------------------------------------------------------+
//| Expert deinitialization function
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
// EAの破棄に連動させたいメソッドを実行
    program.OnDeinitEvent(reason);
   }


//+------------------------------------------------------------------+
//| Expert tick function
//+------------------------------------------------------------------+
void OnTick(void)
   {
   }


//+------------------------------------------------------------------+
//| Timer function
//+------------------------------------------------------------------+
void OnTimer(void)
   {
// 定期実行に連動させたいメソッドを実行
    program.OnTimerEvent();
   }


//+------------------------------------------------------------------+
//| Trade function
//+------------------------------------------------------------------+
void OnTrade(void)
   {
   }


//+------------------------------------------------------------------+
//| ChartEvent function
//+------------------------------------------------------------------+
void OnChartEvent(
    const int id,
    const long &lparam,
    const double &dparam,
    const string &sparam)
   {
// チャート上のイベント情報をCWndEvents側に渡して、要素ごとの処理を実行させる
    program.ChartEvent(id, lparam, dparam, sparam);
   }


//+------------------------------------------------------------------+
