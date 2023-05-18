//+------------------------------------------------------------------+
//| includeの宣言
//+------------------------------------------------------------------+

#include "../Program.mqh"

//+------------------------------------------------------------------+
//| メンバの更新
//+------------------------------------------------------------------+

void CProgram::SetFontSize(const int font_size)
{
  m_base_font_size = font_size;
}

void CProgram::SetFontName(const string font_name)
{
  m_base_font_name = font_name;
}

void CProgram::SetCaptionBackgroundColor(const color clr)
{
  m_caption_color = clr;
}

void CProgram::SetBackgroundColor(const color clr)
{
  m_background_color = clr;
}

void CProgram::SetMagicNumber(const ulong magic_number)
{
  m_magic_number = magic_number;
}
