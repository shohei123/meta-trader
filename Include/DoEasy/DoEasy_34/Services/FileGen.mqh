//+------------------------------------------------------------------+
//|                                                      FileGen.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                             https://mql5.com/en/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link "https://mql5.com/en/users/artmedia70"
#property version "1.00"
//+------------------------------------------------------------------+
//| Include files                                                    |
//+------------------------------------------------------------------+
#include "..\\Services\DELib.mqh"
//+------------------------------------------------------------------+
//| File generator class                                             |
//+------------------------------------------------------------------+
class CFileGen
{
private:
  static string m_folder_name; // Name of a folder library resource files are stored in
  static string m_subfolder;   // Name of a subfolder storing audio or bitmap files
  static string m_name;        // File name
  static int m_handle;         // File handle
                               //--- Set a (1) file, (2) subfolder name
  static void SetName(const ENUM_FILE_TYPE file_type, const string file_name);
  static void SetSubFolder(const ENUM_FILE_TYPE file_type);
  //--- Return file extension by its type
  static string Extension(const ENUM_FILE_TYPE file_type);

public:
  //--- Return the (1) set name, (2) the flag of a file presence in the resource directory
  static string Name(void) { return CFileGen::m_name; }
  static bool IsExist(const ENUM_FILE_TYPE file_type, const string file_name);
  //--- Create a file out of the data array
  static bool Create(const ENUM_FILE_TYPE file_type, const string file_name, const uchar &file_data_array[]);
};
//+------------------------------------------------------------------+
//| Initialization of static variables                               |
//+------------------------------------------------------------------+
string CFileGen::m_folder_name = RESOURCE_DIR;
string CFileGen::m_subfolder = "\\";
string CFileGen::m_name = NULL;
int CFileGen::m_handle = INVALID_HANDLE;
//+------------------------------------------------------------------+
//| Create a file out of a data array                                |
//+------------------------------------------------------------------+
bool CFileGen::Create(const ENUM_FILE_TYPE file_type, const string file_name, const uchar &file_data_array[])
{
  //--- Set a file name consisting of the file path, its name and extension
  CFileGen::SetName(file_type, file_name);
  //--- If such a file already exists, return 'false'
  if (::FileIsExist(CFileGen::m_name))
    return false;
  //--- Open the file with the generated name for writing
  CFileGen::m_handle = ::FileOpen(CFileGen::m_name, FILE_WRITE | FILE_BIN);
  //--- If failed to create the file, receive an error code, display the file opening error message and return 'false'
  if (CFileGen::m_handle == INVALID_HANDLE)
  {
    int err = ::GetLastError();
    ::Print(CMessage::Text(MSG_LIB_SYS_FAILED_OPEN_FILE_FOR_WRITE), "\"", CFileGen::m_name, "\". ", CMessage::Text(MSG_LIB_SYS_ERROR), "\"", CMessage::Text(err), "\" ", CMessage::Retcode(err));
    return false;
  }
  //--- Write the contents of the file_data_array[] array, close the file and return 'true'
  ::FileWriteArray(CFileGen::m_handle, file_data_array);
  ::FileClose(CFileGen::m_handle);
  return true;
}
//+------------------------------------------------------------------+
//| The flag of a file presence in the resource directory            |
//+------------------------------------------------------------------+
bool CFileGen::IsExist(const ENUM_FILE_TYPE file_type, const string file_name)
{
  CFileGen::SetName(file_type, file_name);
  return ::FileIsExist(CFileGen::m_name);
}
//+------------------------------------------------------------------+
//| Set a file name                                                  |
//+------------------------------------------------------------------+
void CFileGen::SetName(const ENUM_FILE_TYPE file_type, const string file_name)
{
  CFileGen::SetSubFolder(file_type);
  CFileGen::m_name = CFileGen::m_folder_name + CFileGen::m_subfolder + file_name + CFileGen::Extension(file_type);
}
//+------------------------------------------------------------------+
//| Set a subfolder name                                             |
//+------------------------------------------------------------------+
void CFileGen::SetSubFolder(const ENUM_FILE_TYPE file_type)
{
  CFileGen::m_subfolder = (file_type == FILE_TYPE_BMP ? "Images\\" : file_type == FILE_TYPE_WAV ? "Sounds\\"
                                                                                                : "");
}
//+------------------------------------------------------------------+
//| Return file extension by its type                                |
//+------------------------------------------------------------------+
string CFileGen::Extension(const ENUM_FILE_TYPE file_type)
{
  string ext = ::StringSubstr(::EnumToString(file_type), 10);
  if (!::StringToLower(ext))
    ::Print(DFUN, CMessage::Text(MSG_LIB_SYS_ERROR_FAILED_CONV_TO_LOWERCASE), CMessage::Retcode(::GetLastError()));
  return "." + ext;
}
//+------------------------------------------------------------------+
