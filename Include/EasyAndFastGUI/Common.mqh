//+------------------------------------------------------------------+
//|                                                       Common.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "http://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
class CCommon {
 public:
   //--- Идентификатор и номер окна графика
   static long       m_chart_id;
   static int        m_subwin;
   //--- Идентификатор последнего созданного элемента управления
   static int        m_last_id;
   //--- Угол графика и точка привязки объектов
   ENUM_BASE_CORNER  m_corner;
   ENUM_ANCHOR_POINT m_anchor;
};
//+------------------------------------------------------------------+
