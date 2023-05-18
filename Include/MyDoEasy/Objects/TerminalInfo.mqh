//+------------------------------------------------------------------+
//| Include
//+------------------------------------------------------------------+
#include <Object.mqh>


//+------------------------------------------------------------------+
//| Class CTerminalObject
//+------------------------------------------------------------------+
class CTerminalObject : public CObject
   {
public:
                     CTerminalObject(void);
                    ~CTerminalObject(void);
    int               GetBuild(void) const;
    bool              IsConnected(void) const;
    bool              IsDLLsAllowed(void) const;
    bool              IsTradeAllowed(void) const;
    bool              IsEmailEnabled(void) const;
    bool              IsFtpEnabled(void) const;
    int               GetMaxBars(void) const;
    int               GetCodePage(void) const;
    int               GetCPUCores(void) const;
    int               GetMemoryPhysical(void) const;
    int               GetMemoryTotal(void) const;
    int               GetMemoryAvailable(void) const;
    int               GetMemoryUsed(void) const;
    bool              IsX64(void) const;
    int               OpenCLSupport(void) const;
    int               GetDiskSpace(void) const;
    string            GetLanguage(void) const;
    string            GetName(void) const;
    string            GetCompany(void) const;
    string            GetPath(void) const;
    string            GetDataPath(void) const;
    string            GetCommonDataPath(void) const;
    long              InfoInteger(const ENUM_TERMINAL_INFO_INTEGER prop_id) const;
    string            InfoString(const ENUM_TERMINAL_INFO_STRING prop_id) const;
   };


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTerminalObject::CTerminalObject(void)
   {
   }


//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTerminalObject::~CTerminalObject(void)
   {
   }


//+------------------------------------------------------------------+
//| クライアント端末のビルド番号（MetaTraderプラットフォームのバージョン）を取得
//+------------------------------------------------------------------+
int CTerminalObject::GetBuild(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_BUILD));
   }


//+------------------------------------------------------------------+
//| 取引サーバーに接続しているのか
//+------------------------------------------------------------------+
bool CTerminalObject::IsConnected(void) const
   {
    return((bool)TerminalInfoInteger(TERMINAL_CONNECTED));
   }


//+------------------------------------------------------------------+
//| DLLの使用が許可されているのか
//+------------------------------------------------------------------+
bool CTerminalObject::IsDLLsAllowed(void) const
   {
    return((bool)TerminalInfoInteger(TERMINAL_DLLS_ALLOWED));
   }


//+------------------------------------------------------------------+
//| 取引の自動化が許可されているのか
//+------------------------------------------------------------------+
bool CTerminalObject::IsTradeAllowed(void) const
   {
    return((bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED));
   }


//+------------------------------------------------------------------+
//| SMTPサーバーへの電子メールの送信・ログインの許可
//+------------------------------------------------------------------+
bool CTerminalObject::IsEmailEnabled(void) const
   {
    return((bool)TerminalInfoInteger(TERMINAL_EMAIL_ENABLED));
   }


//+------------------------------------------------------------------+
//| FTPサーバーへのレポート送信・ログインの許可
//+------------------------------------------------------------------+
bool CTerminalObject::IsFtpEnabled(void) const
   {
    return((bool)TerminalInfoInteger(TERMINAL_FTP_ENABLED));
   }


//+------------------------------------------------------------------+
//|チャートのバーの最大数を取得
//+------------------------------------------------------------------+
int CTerminalObject::GetMaxBars(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_MAXBARS));
   }


//+------------------------------------------------------------------+
//| 言語のコードページを表す定数を取得
//+------------------------------------------------------------------+
int CTerminalObject::GetCodePage(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_CODEPAGE));
   }


//+------------------------------------------------------------------+
//| システムのCPUコア数を取得
//+------------------------------------------------------------------+
int CTerminalObject::CPUCores(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_CPU_CORES));
   }


//+------------------------------------------------------------------+
//| システムの物理メモリ（MB 単位）を取得
//+------------------------------------------------------------------+
int CTerminalObject::MemoryPhysical(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_MEMORY_PHYSICAL));
   }


//+------------------------------------------------------------------+
//| 端末のプロセス（エージェント）に使用可能なメモリ（MB 単位）を取得
//+------------------------------------------------------------------+
int CTerminalObject::MemoryTotal(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_MEMORY_TOTAL));
   }


//+------------------------------------------------------------------+
//| 端末（エージェント）プロセスの空きメモリ（MB 単位）を取得
//+------------------------------------------------------------------+
int CTerminalObject::MemoryAvailable(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE));
   }


//+------------------------------------------------------------------+
//| 端末（エージェント）で使用されるメモリ（MB 単位）を取得
//+------------------------------------------------------------------+
int CTerminalObject::MemoryUsed(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_MEMORY_USED));
   }


//+------------------------------------------------------------------+
//| MetaTrader 5クライアント端末が64ビット版 (x64) かどうか
//+------------------------------------------------------------------+
bool CTerminalObject::IsX64(void) const
   {
    return((bool)TerminalInfoInteger(TERMINAL_X64));
   }


//+------------------------------------------------------------------+
//| OpenCLでサポートされているかどうか
//+------------------------------------------------------------------+
int CTerminalObject::GetOpenCLSupport(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_OPENCL_SUPPORT));
   }


//+------------------------------------------------------------------+
//| 端末（エージェント）のMQL5\ Filesフォルダの空きディスク容量（MB 単位）お取得
//+------------------------------------------------------------------+
int CTerminalObject::GetDiskSpace(void) const
   {
    return((int)TerminalInfoInteger(TERMINAL_DISK_SPACE));
   }


//+------------------------------------------------------------------+
//| 端末の言語を取得
//+------------------------------------------------------------------+
string CTerminalObject::GetLanguage(void) const
   {
    return(TerminalInfoString(TERMINAL_LANGUAGE));
   }


//+------------------------------------------------------------------+
//| 端末名を取得
//+------------------------------------------------------------------+
string CTerminalObject::GetName(void) const
   {
    return(TerminalInfoString(TERMINAL_NAME));
   }


//+------------------------------------------------------------------+
//| 会社名を取得
//+------------------------------------------------------------------+
string CTerminalObject::GetCompany(void) const
   {
    return(TerminalInfoString(TERMINAL_COMPANY));
   }


//+------------------------------------------------------------------+
//| 端末が起動されるフォルダパスを取得
//+------------------------------------------------------------------+
string CTerminalObject::GetPath(void) const
   {
    return(TerminalInfoString(TERMINAL_PATH));
   }


//+------------------------------------------------------------------+
//| 端末データが格納されるフォルダを取得
//+------------------------------------------------------------------+
string CTerminalObject::DataPath(void) const
   {
    return(TerminalInfoString(TERMINAL_DATA_PATH));
   }


//+------------------------------------------------------------------+
//| 全ての端末の共通パスを取得
//+------------------------------------------------------------------+
string CTerminalObject::GetCommonDataPath(void) const
   {
    return(TerminalInfoString(TERMINAL_COMMONDATA_PATH));
   }


//+------------------------------------------------------------------+
//| Access functions AccountInfoInteger(...)                         |
//+------------------------------------------------------------------+
long CTerminalObject::InfoInteger(const ENUM_TERMINAL_INFO_INTEGER prop_id) const
   {
    return(TerminalInfoInteger(prop_id));
   }


//+------------------------------------------------------------------+
//| Access functions AccountInfoString(...)                          |
//+------------------------------------------------------------------+
string CTerminalObject::InfoString(const ENUM_TERMINAL_INFO_STRING prop_id) const
   {
    return(TerminalInfoString(prop_id));
   }


//+------------------------------------------------------------------+
