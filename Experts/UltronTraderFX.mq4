//+------------------------------------------------------------------+
//|                                           UltronTraderFX.mq4 |
//|                                                     Michael Chiu |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "UltronTraderFX"
#property link      "service@ultrontrader.com"
#property version   "1.68"
#property strict

#include <UltronTraderFX.mqh>

string SYS_APP_Mode = "DEVELOP";
string SYS_APP_NAME_TW = "奧創交易FX";
string SYS_EA_NAME = "UltronTraderFX";
string SYS_APP_VERSION = "v1.68";
string SYS_APP_ExpireDate = "2020.12.31";
string SYS_APP_ExpireDate_Status = "允許";
string SYS_APP_URL = "service@ultrontraderfx.com";

string SYS_Auth_Permission = "";
string SYS_Auth_AppName = "";
string SYS_Auth_UserName = "";
string SYS_Auth_ExpiredDate = "";
string SYS_Auth_AccountType = "";
string SYS_Auth_AccountNo = "";
string SYS_Auth_Result = "";
string SYS_Auth_Message = "";


//--- input parameters
input string      IN_Auth_UserName = "service@ultrontraderfx.com";  //UserName: Email

input string      IN_計算頻率="M1";                     //計算頻率 時區(M1,M5,M15,M30,H1,H4,D1,W1)
input double      IN_起始手數=0.01;                   //起始手數
input int         IN_馬丁多空同步=0;                  //是否根據多空判斷下馬丁單
input int         IN_獲利點數=100;                    //獲利點數
input double      IN_馬丁倍率=2;                      //馬丁倍率
input int         IN_馬丁點距=400;                    //馬丁點距
input double      IN_點距倍率=0;                      //點距倍率
input int         IN_馬丁獲利=100;                    //馬丁獲利
input int         IN_馬丁張數=10;                     //最大馬丁張數
input int         IN_逆勢降低獲利點數=1;                     //逆勢降低獲利點數
int               IN_馬丁避險張數=5;                  //馬丁避險張數

input int         IN_停損點距=30000;                  //停損點距，距離第一單多遠要停損

input string      IN_渦輪增壓="1/0.01/500/10";         //渦輪增壓，起始手數資金配比 -> 1000美金配0.01手

input string      IN_避險日期="1/07.03~07.03&11.07~11.07";      //避險日期 -> 1/02.17~02.19&02.27~02.28
input string      IN_執行時間="0/03:00~11:00";      //系統執行時間 -> 1/03:00~11:00
string      IN_固定平倉時間="0/22:30";

input int         IN_多空轉換停損=0;                  //空轉換停損 -> 0:不停損, 1:自動停損

string IN_SAR_SETTING_1 = "M5/1/0.008,0.2/3";
string IN_SAR_SETTING_2 = "M5/1/0.008,0.2/2";
string IN_SAR_SETTING_3 = "M5/1/0.008,0.2/1";

input string      IN_技術指標1="1:Alligator:M1/1/20,0,10,0,5,0,2,6/3";
input string      IN_技術指標2="1:Alligator:M1/1/240,0,120,0,60,0,2,6/3";
input string      IN_技術指標3="1:Alligator:M30/1/20,0,10,0,5,0,2,6/2";
input string      IN_技術指標4="1:Alligator:M30/1/240,0,120,0,60,0,2,6/2";
input string      IN_技術指標5="1:SAR:M1/1/0.01,2/2";
input string      IN_技術指標6="1:SAR:M30/1/0.01,2/2";
input string      IN_技術指標7="1:KD:M1/1/9,9,6,2,1,55,45/2";
input string      IN_技術指標8="1:KD:M30/1/9,9,6,2,1,55,45/2";
input string      IN_技術指標9="";

/***
1:MA:H1/1/100,0,2,6/2
1:SAR:H4/1/0.02,2/3
1:SAR:H1/1/0.02,2/3
1:SAR:M5/1/0.02,2/3
1:Alligator:D1/2/20,0,10,0,5,0,2,6/1
1:MACD:D1/1/12,26,9,6/1
1:KD:M15/1/9,9,6,2,1,55,45/3
1:RSI:H1/1/5,10,20,52,48,6/1
***/

string IN_多空方向 = ",,,,,,,,,";

string SYS_多空技術指標[];
string SYS_多空方向[];
string DSP_多空技術指標方向[];

int         IN_均線多空判斷=1;                 //均線多空判斷 -> 0:不使用, 1:簡易判斷, 2:嚴格判斷
int         IN_技術指標多空判斷=1;             //技術指標多空判斷 -> 0:不使用, 1:使用
int         IN_技術指標逆勢降低獲利=1;          //技術指標逆勢降低獲利 -> 0:不使用, 1:使用
string      IN_多空時區="H1";                   //多空判斷時區: CURRENT, M1, M5, M15, M30, H1, H4, D1
string      IN_均線設定="5,10,20,30,40,50";    //均線設定: 5,10,20,30,40,50
string      IN_均線差距="50,40,30,20,10,10";    //均線設定: 50,40,30,20,10,10
int         IN_均線模式=2;                      //均線模式 -> 0:Simple, 1:Exponential, 2:Smoothed, 3:Linear-weighted
int         IN_均價計算模式=0;                  //均價計算模式 -> 0:Close, 1:Open, 2:High, 3:Low, 4:Median, 5:Typical, 6:WEIGHTED
string      IN_避開月底月初設定="0/3/28";       //避開月底月初設定 -> 1/3/28 (只執行每月3號到28號)
string      IN_MACD參數="1/21/34/13/6";           //MACD參數 -> 34/55/21/6
string      IN_KD參數="1/21/21/13/2/1";           //KD參數 -> 21/21/13/2/1
string      IN_RSI參數="1/5/6";                  //RSI參數 -> 21/6
int         IN_使用ACAO多空判斷=1;              //使用ACAO多空判斷 -> 1

datetime OldTime, NewTime;
int TimeDiff = 0;

string SYS_STOP_DATE[];
string SYS_EXECUTE_TIME[];
string SYS_STOP_LOSS_TIME[];
string SYS_渦輪增壓[];
bool flg_stop_date = false;
bool flg_execute_time = true;
string StopDateSetting[];

double iStartLots = IN_起始手數;

string ConnectStatus = "系統連線中..."; 
string AccountTradeMode = "模擬倉";

void ShowAccountInfo() { 
   int P_X = 350;
   int P_Y = 150;
   string TextList[5];
   
   //TextList[0] = "名稱: " + AccountName();
   TextList[0] = "槓桿 1:" + AccountLeverage();
   TextList[1] = "帳號: " + AccountNumber();
   TextList[2] = "貨幣: " + AccountCurrency();
   TextList[3] = "餘額: " + DoubleToStr(AccountBalance(), 2);
   TextList[4] = "淨值: " + DoubleToStr(AccountEquity(), 2);
   //TextList[6] = "伺服器: " + AccountServer();
   //TextList[7] = "券商: " + AccountCompany();
   
   ShowSystemText(P_X, P_Y, 20, 12, "Verdana", White, "AccountInfo", TextList);
}

void ShowAppSetting() {
   return;

   int P_X = 300;
   int P_Y = 150;
   string TextList[13];

   TextList[0] = "計算頻率: " + IN_計算頻率;
   TextList[1] = "起始手數: " + IN_起始手數;
   TextList[2] = "獲利點數: " + IN_獲利點數;
   TextList[3] = "馬丁倍率: " + IN_馬丁倍率;
   TextList[4] = "馬丁點距: " + IN_馬丁點距;
   TextList[5] = "點距倍率: " + IN_點距倍率;
   TextList[6] = "馬丁獲利: " + IN_馬丁獲利;
   TextList[7] = "馬丁張數: " + IN_馬丁張數;
   TextList[8] = "馬丁多空同步: " + IN_馬丁多空同步;
   TextList[9] = "停損點距: " + IN_停損點距;
   TextList[10] = "執行時間: " + IN_執行時間;
   TextList[11] = "渦輪增壓: " + IN_渦輪增壓;
   //TextList[12] = "避險日期: " + IN_避險日期;
   
   ShowSystemText(P_X, P_Y, 20, 10, "Verdana", White, "AppSetting-", TextList);
}

void Show_MA_INFO() {
   int P_X = 350;
   int P_Y = 300;
   string TextList[10];
   string ma_period[];
   StringSplit(IN_均線設定, StringGetCharacter(",", 0), ma_period);

   TextList[0] = "技術指標計算時間: " + SYS_技術指標計算時間;
   TextList[1] = "條件1: " + IN_技術指標1 + " " + SYS_result[0];
   TextList[2] = "條件2: " + IN_技術指標2 + " " + SYS_result[1];
   TextList[3] = "條件3: " + IN_技術指標3 + " " + SYS_result[2];
   TextList[4] = "條件4: " + IN_技術指標4 + " " + SYS_result[3];
   TextList[5] = "條件5: " + IN_技術指標5 + " " + SYS_result[4];
   TextList[6] = "條件6: " + IN_技術指標6 + " " + SYS_result[5];
   TextList[7] = "條件7: " + IN_技術指標7 + " " + SYS_result[6];
   TextList[8] = "條件8: " + IN_技術指標8 + " " + SYS_result[7];
   TextList[9] = "條件9: " + IN_技術指標9 + " " + SYS_result[8];
 
   ShowSystemText(P_X, P_Y, 20, 10, "Verdana", clrLavender, "MA-INFO-", TextList);
}

void DoCheckExpireDate() {
   if (CheckExpireDate() == true)
      SYS_APP_ExpireDate_Status = "過期";
   else
      SYS_APP_ExpireDate_Status = "允許";
}

bool CheckExpireDate() {
   string ThisDate = GetDate(TimeCurrent());
   
   if (StringCompare(ThisDate, SYS_APP_ExpireDate) >= 0)
      return (true);
   else
      return (false);
}

bool CheckStopDate(string enabled, string DateGroup) {
   string DateItem[];
   string CheckDate[];
   string StartDate;
   string EndDate;
   //string ThisDate = GetDate2(TimeLocal());
   string ThisDate = "" + TimeLocal();
   bool result = true;
   
   if (enabled == "0")
      return (false);
   
   StringSplit(DateGroup, StringGetCharacter("&", 0), DateItem);
   
   for (int i = 0; i < ArraySize(DateItem); i++) {
      StringSplit(DateItem[i], StringGetCharacter("~", 0), CheckDate);
      StartDate = CheckDate[0];
      EndDate = CheckDate[1];
      
      //if (StringCompare(ThisDate, StartDate) >= 0 && StringCompare(ThisDate, EndDate) <= 0)
      //   return (true);
      
      if (CheckDateTime(ThisDate, StartDate) >= 0 && CheckDateTime(ThisDate, EndDate) <= 0)
         return (true);
   }
   
   
   return (false);
}


bool CheckExecuteTime(string enabled, string TimeGroup) {
   string TimeItem[];
   string CheckTime[];
   string StartTime;
   string EndTime;
   string ThisTime = GetTime(TimeLocal());
   string ThisYear = TimeYear(TimeLocal());
   bool result = true;
   
   if (enabled == "0")
      return (true);
      
   StringSplit(TimeGroup, StringGetCharacter("&", 0), TimeItem);
   
   for (int i = 0; i < ArraySize(TimeItem); i++) {
      StringSplit(TimeItem[i], StringGetCharacter("~", 0), CheckTime);
      
      StartTime = CheckTime[0];
      EndTime = CheckTime[1];
      
      if (StringCompare(ThisTime, StartTime) >= 0 && StringCompare(ThisTime, EndTime) <= 0)
         return (true);
   }
   
   return (false);
}

bool CheckStopLossTime(string enabled, string StopTime) {
   string ThisTime = GetTime(TimeLocal());
   
   if (enabled == "0")
      return (false);
      
   if (ThisTime == StopTime)
      return (true);
   else
      return (false);
}

void ShowTimeInfo() {
   int P_X = 550;
   int P_Y = 150;
   string TextList[6];
   
   TextList[0] = "線圖時間: " + Time[0]; 
   TextList[1] = "系統時間: " + TimeCurrent(); 
   TextList[2] = "當地時間: " + TimeLocal();
   TextList[3] = "日期: " + GetDate(TimeLocal());
   TextList[4] = "時間: " + GetTime(TimeLocal());
   TextList[5] = "使用期限: " + SYS_APP_ExpireDate + " (" + SYS_APP_ExpireDate_Status + ")";
   
   ShowSystemText(P_X, P_Y, 20, 10, "Verdana", clrOrange, "TimeInfo-", TextList);
}

void ShowSystemInfo() { 
   int P_X = 10;
   int P_Y = 10;
   string AllowSellBuy = "";
   
   
   if (AllowSellBuy == "")
      if (flg_execute_time == false) {
         AllowSellBuy = "時間避險，停止操作";
         ALLOW_BUY = false;
         ALLOW_SELL = false;
      }
      
   if (AllowSellBuy == "")
      if (flg_stop_date == true) {
         AllowSellBuy = "日期避險，停止操作";
         ALLOW_BUY = false;
         ALLOW_SELL = false;
      }
      
   if (AllowSellBuy == "") {
      if (ALLOW_BUY == true && ALLOW_SELL == false)
         AllowSellBuy = "偏多操作";
      else if (ALLOW_SELL == true && ALLOW_BUY == false)
         AllowSellBuy = "偏空操作";
      else if (ALLOW_SELL == true && ALLOW_BUY == true)
         AllowSellBuy = "多空同時";
      else
         AllowSellBuy = "等待方向";
   }
   
   iSetLabel("SystemTitle", SYS_APP_NAME_TW, P_X, P_Y, 20, "Verdana", Olive); 
   iSetLabel("SystemSymbol", Symbol(), P_X+250, P_Y, 20, "Verdana", Olive);
   iSetLabel("SystemAllowBuy", AllowSellBuy, P_X+400, P_Y, 20, "Verdana", clrGold);
   iSetLabel("SystemActionTimes", "" + SYS_APP_VERSION, P_X, P_Y+(40*1), 20, "Verdana", Olive);
   
   iSetLabel("SystemAppUrl", SYS_APP_URL, P_X, P_Y+75, 16, "Verdana", clrGold);
} 

void ShowCheckConnect() { 
   
   if(!IsConnected()) 
      ConnectStatus = "未連線"; 
   else
      ConnectStatus = "連線中"; 
      
      
   switch (AccountInfoInteger(ACCOUNT_TRADE_MODE)) {
      case ACCOUNT_TRADE_MODE_REAL:
         AccountTradeMode = "REAL";
         break;
   
      case ACCOUNT_TRADE_MODE_DEMO:
         AccountTradeMode = "DEMO";
         break;
         
      case ACCOUNT_TRADE_MODE_CONTEST:
         AccountTradeMode = "CONTEST";
         break;
         
      default:
         AccountTradeMode = "--";
         break;
   }

   iSetLabel("SystemConnect-1", ConnectStatus, 350, 50, 10, "Verdana", clrLightSkyBlue); 
   iSetLabel("SystemConnect-2", AccountTradeMode, 420, 50, 10, "Verdana", clrLightSkyBlue); 
} 

void ShowOrderInfo() { 
   int P_X = 20;
   int P_Y = 150;
   int P_Sell_X = P_X+80;
   int P_Buy_X = P_X+160;
   
   iSetLabel("OrderInfo-Sell-Title", "Sell", P_Sell_X, P_Y, 10, "Verdana", clrGold); 
   iSetLabel("OrderInfo-Buy-Title", "Buy", P_Buy_X, P_Y, 10, "Verdana", clrGold); 

   iSetLabel("OrderInfo-Title-01", "價格", P_X, P_Y+(20*1), 10, "Verdana", clrGold); 
   iSetLabel("OrderInfo-Title-02", "張數", P_X, P_Y+(20*2), 10, "Verdana", clrGold); 
   iSetLabel("OrderInfo-Title-03", "總手數", P_X, P_Y+(20*3), 10, "Verdana", clrGold); 
   iSetLabel("OrderInfo-Title-04", "平均成本", P_X, P_Y+(20*4), 10, "Verdana", clrGold); 
   iSetLabel("OrderInfo-Title-05", "價差", P_X, P_Y+(20*5), 10, "Verdana", clrGold); 
   iSetLabel("OrderInfo-Title-06", "獲利", P_X, P_Y+(20*6), 10, "Verdana", clrGold);
   iSetLabel("OrderInfo-Title-07", "最大張數", P_X, P_Y+(20*7), 10, "Verdana", clrGold);
   iSetLabel("OrderInfo-Title-08", "最大手數", P_X, P_Y+(20*8), 10, "Verdana", clrGold);
   iSetLabel("OrderInfo-Title-09", "最大浮虧", P_X, P_Y+(20*9), 10, "Verdana", clrGold);
   iSetLabel("OrderInfo-Title-10", "逆勢點距", P_X, P_Y+(20*10), 10, "Verdana", clrGold);
   
   iSetLabel("OrderInfo-Title-11", "總獲利", P_X, P_Y+(20*12), 10, "Verdana", clrGold);
   iSetLabel("OrderInfo-Title-12", "最大浮虧", P_X, P_Y+(20*13), 10, "Verdana", clrGold);
   iSetLabel("OrderInfo-Title-13", "最大獲利", P_X, P_Y+(20*14), 10, "Verdana", clrGold);

   iSetLabel("OrderInfo-Sell-Info-01", DoubleToStr(SYS_SELL, Digits), P_Sell_X, P_Y+(20*1), 10, "Verdana", clrLavender); 
   iSetLabel("OrderInfo-Sell-Info-02", SELL_張數, P_Sell_X, P_Y+(20*2), 10, "Verdana", clrLavender); 
   iSetLabel("OrderInfo-Sell-Info-03", DoubleToStr(SELL_總手數, 2), P_Sell_X, P_Y+(20*3), 10, "Verdana", clrLavender); 
   iSetLabel("OrderInfo-Sell-Info-04", DoubleToStr(SELL_平均成本, Digits), P_Sell_X, P_Y+(20*4), 10, "Verdana", clrLavender); 
   iSetLabel("OrderInfo-Sell-Info-05", SELL_價差, P_Sell_X, P_Y+(20*5), 10, "Verdana", clrLavender); 
   iSetLabel("OrderInfo-Sell-Info-06", DoubleToStr(SELL_獲利, 2), P_Sell_X, P_Y+(20*6), 10, "Verdana", clrLavender);
   iSetLabel("OrderInfo-Sell-Info-07", SELL_MAX_張數, P_Sell_X, P_Y+(20*7), 10, "Verdana", clrLavender);
   iSetLabel("OrderInfo-Sell-Info-08", DoubleToStr(SELL_MAX_手數, 2), P_Sell_X, P_Y+(20*8), 10, "Verdana", clrLavender);
   iSetLabel("OrderInfo-Sell-Info-09", DoubleToStr(SELL_MAX_浮虧, 2), P_Sell_X, P_Y+(20*9), 10, "Verdana", clrLavender);
   iSetLabel("OrderInfo-Sell-Info-10", SELL_MAX_逆勢點數, P_Sell_X, P_Y+(20*10), 10, "Verdana", clrLavender);
   
   if (TOTAL_獲利 >= 0)
      iSetLabel("OrderInfo-ALL-Info-05", DoubleToStr(TOTAL_獲利, 2), P_Sell_X, P_Y+(20*12), 10, "Verdana", clrGold);
   else
      iSetLabel("OrderInfo-ALL-Info-05", DoubleToStr(TOTAL_獲利, 2), P_Sell_X, P_Y+(20*12), 10, "Verdana", clrRed);

   iSetLabel("OrderInfo-ALL-Info-06", DoubleToStr(TOTAL_最大浮虧, 2), P_Sell_X, P_Y+(20*13), 10, "Verdana", clrRed);
   iSetLabel("OrderInfo-ALL-Info-07", DoubleToStr(TOTAL_最大獲利, 2), P_Sell_X, P_Y+(20*14), 10, "Verdana", clrGold);

   iSetLabel("OrderInfo-Buy-Info-01", DoubleToStr(SYS_BUY, Digits), P_Buy_X, P_Y+(20*1), 10, "Verdana", clrLightBlue); 
   iSetLabel("OrderInfo-Buy-Info-02", BUY_張數, P_Buy_X, P_Y+(20*2), 10, "Verdana", clrLightBlue); 
   iSetLabel("OrderInfo-Buy-Info-03", DoubleToStr(BUY_總手數, 2), P_Buy_X, P_Y+(20*3), 10, "Verdana", clrLightBlue); 
   iSetLabel("OrderInfo-Buy-Info-04", DoubleToStr(BUY_平均成本, Digits), P_Buy_X, P_Y+(20*4), 10, "Verdana", clrLightBlue); 
   iSetLabel("OrderInfo-Buy-Info-05", BUY_價差, P_Buy_X, P_Y+(20*5), 10, "Verdana", clrLightBlue); 
   iSetLabel("OrderInfo-Buy-Info-06", DoubleToStr(BUY_獲利, 2), P_Buy_X, P_Y+(20*6), 10, "Verdana", clrLightBlue); 
   iSetLabel("OrderInfo-Buy-Info-07", BUY_MAX_張數, P_Buy_X, P_Y+(20*7), 10, "Verdana", clrLightBlue);
   iSetLabel("OrderInfo-Buy-Info-08", DoubleToStr(BUY_MAX_手數, 2), P_Buy_X, P_Y+(20*8), 10, "Verdana", clrLightBlue);
   iSetLabel("OrderInfo-Buy-Info-09", DoubleToStr(BUY_MAX_浮虧, 2), P_Buy_X, P_Y+(20*9), 10, "Verdana", clrLightBlue);
   iSetLabel("OrderInfo-Buy-Info-10", BUY_MAX_逆勢點數, P_Buy_X, P_Y+(20*10), 10, "Verdana", clrLightBlue);

   iSetLabel("OrderInfo-ALL-Info-01", SYS_點差, P_Buy_X+80, P_Y+(20*1), 10, "Verdana", clrLightGoldenrod); 
} 

void CheckOrderClose() {
       
      int timeframe = GetPeriod("M1");
      int This_BUY_價差 = (iHigh(NULL, timeframe, 0) - BUY_平均成本)/Point;
      int This_SELL_價差 = (SELL_平均成本 - iLow(NULL, timeframe, 0) + (SYS_BUY-SYS_SELL))/Point;

      if (SELL_MAX_張數 > 0)
            if (CheckStopLossTime(SYS_STOP_LOSS_TIME[0], SYS_STOP_LOSS_TIME[1]) == true)
            flgSellClose = true;
            
      if (BUY_MAX_張數 > 0)
            if (CheckStopLossTime(SYS_STOP_LOSS_TIME[0], SYS_STOP_LOSS_TIME[1]) == true)
            flgBuyClose = true;

      if (SELL_張數 == 1)
            if (This_SELL_價差 >= IN_獲利點數) {
                  flgSellClose = true;
            
                  if (TOTAL_最大獲利 < SELL_獲利)
                        TOTAL_最大獲利 = SELL_獲利;
            }

      if (BUY_張數 == 1)
            if (This_BUY_價差 >= IN_獲利點數) {
                  flgBuyClose = true;
            
                  if (TOTAL_最大獲利 < BUY_獲利)
                        TOTAL_最大獲利 = BUY_獲利;
            }
      if (SELL_張數 > 1)
            if (This_SELL_價差 >= IN_馬丁獲利) {
                  flgSellClose = true;
            
                  if (TOTAL_最大獲利 < SELL_獲利)
                        TOTAL_最大獲利 = SELL_獲利;
            }
      
      if (BUY_張數 > 1)
            if (This_BUY_價差 >= IN_馬丁獲利) {
                  flgBuyClose = true;
            
                  if (TOTAL_最大獲利 < BUY_獲利)
                        TOTAL_最大獲利 = BUY_獲利;
            }

      if (SELL_張數 > 0)
            if ((Ask - SELL_第一單進價)/Point >= IN_停損點距)
                  flgSellClose = true;

      if (BUY_張數 > 0)
            if ((BUY_第一單進價 - Bid)/Point >= IN_停損點距)
                  flgBuyClose = true;
      
      /***
      if (ALLOW_BUY == false && ALLOW_SELL == false) {
            if (BUY_張數 > 0 && This_BUY_價差 >= IN_馬丁獲利/2) {
                  flgBuyClose = true;
            
                  if (TOTAL_最大獲利 < BUY_獲利)
                        TOTAL_最大獲利 = BUY_獲利;
            }
            
            if (SELL_張數 > 0 && This_SELL_價差 >= IN_馬丁獲利/2) {
                  flgSellClose = true;
            
                  if (TOTAL_最大獲利 < SELL_獲利)
                        TOTAL_最大獲利 = SELL_獲利;
            }
      }
      
      if (SYS_BullCount > SYS_BearCount) {
            if (SELL_張數 > 0 && This_SELL_價差 >= IN_馬丁獲利/4) {
                  flgSellClose = true;
            
                  if (TOTAL_最大獲利 < SELL_獲利)
                        TOTAL_最大獲利 = SELL_獲利;
            }
      }
      
      if (SYS_BearCount > SYS_BullCount) {
            if (BUY_張數 > 0 && This_BUY_價差 >= IN_馬丁獲利/4) {
                  flgBuyClose = true;
            
                  if (TOTAL_最大獲利 < BUY_獲利)
                        TOTAL_最大獲利 = BUY_獲利;
                  }
      }
      
      if (BUY_張數 > 0 && ALLOW_SELL == true) {
            if (This_BUY_價差 >= IN_馬丁獲利/8) {
            flgBuyClose = true;
            
            if (TOTAL_最大獲利 < BUY_獲利)
                  TOTAL_最大獲利 = BUY_獲利;
            }
      }
      
      if (SELL_張數 > 0 && ALLOW_BUY == true) {
            if (This_SELL_價差 >= IN_馬丁獲利/8) {
            flgSellClose = true;
            
            if (TOTAL_最大獲利 < SELL_獲利)
                  TOTAL_最大獲利 = SELL_獲利;
            }
      }
      ***/
      
      /***
      if (BUY_張數 > 0 && SYS_TakeProfit == "偏空")
            if (This_BUY_價差 >= SYS_點差)
                  flgBuyClose = true;  
            
      if (BUY_張數 == 1 && SYS_StopLoss == "偏空")
            flgBuyClose = true;

      if (SELL_張數 > 0 && SYS_TakeProfit == "偏多")
            if (This_SELL_價差 >= SYS_點差)
                  flgSellClose = true;  
            
      if (SELL_張數 == 1 && SYS_StopLoss == "偏多")
            flgSellClose = true;
      ***/

      if (SYS_多空轉換停損 == 1) {
            if (BUY_張數 > 0)
                  if (ALLOW_BUY == false && ALLOW_SELL == true)
                        flgBuyClose = true;
                  
            if (SELL_張數 > 0)
                  if (ALLOW_BUY == true && ALLOW_SELL == false)
                        flgSellClose = true;
      }
      
      /***
      double iPriceDiff = iClose(NULL, GetPeriod("M15"), 0) - iOpen(NULL, GetPeriod("M15"), 0);
      iPriceDiff = iPriceDiff/Point;
      
      if (SELL_張數 > 0)
            if (iPriceDiff > 0 && iPriceDiff >= (IN_馬丁點距))
            flgSellClose = true;
            
      if (BUY_張數 > 0)
            if (iPriceDiff < 0 && -1*iPriceDiff >= (IN_馬丁點距))
            flgBuyClose = true;
      ***/
}

void doOrderClose() {
   if (flgSellClose == true) {
      SellClose();
      CalculateSysSellInfo();
      if (SELL_張數 == 0)
         flgSellClose = false;
   }
   
   if (flgBuyClose == true) {
      BuyClose();
      CalculateSysBuyInfo();
      if (BUY_張數 == 0)
         flgBuyClose = false;
   }
}

bool CheckDayStop(int MinDay, int MaxDay) {
   string ThisDate = "" + TimeCurrent();
   int ThisDay = 0;
   ThisDate = StringSubstr(ThisDate, 8, 2);
   ThisDay = StringToInteger(ThisDate);
   
   if (ThisDay >= MaxDay)
      return (true);
      
   if (ThisDay <= MinDay)
      return (true);
      
   return (false);
}

void InitParam() {
   SYS_均線多空判斷 = IN_均線多空判斷;
   SYS_技術指標多空判斷 = IN_技術指標多空判斷;
   SYS_技術指標逆勢降低獲利 = IN_技術指標逆勢降低獲利;
   SYS_使用ACAO多空判斷 = IN_使用ACAO多空判斷;
   SYS_多空轉換停損 = IN_多空轉換停損;
   SYS_馬丁多空同步 = IN_馬丁多空同步;
   
   
   StringSplit(IN_避開月底月初設定, StringGetCharacter("/", 0), StopDateSetting);
   StringSplit(IN_渦輪增壓, StringGetCharacter("/", 0), SYS_渦輪增壓);
   
   //StringSplit(IN_SAR_SETTING_1, StringGetCharacter("/", 0), SYS_SAR_SETTING_1);
   //StringSplit(IN_SAR_SETTING_2, StringGetCharacter("/", 0), SYS_SAR_SETTING_2);
   //StringSplit(IN_SAR_SETTING_3, StringGetCharacter("/", 0), SYS_SAR_SETTING_3);
   
   SYS_Direct_SETTING[0] = IN_技術指標1;
   SYS_Direct_SETTING[1] = IN_技術指標2;
   SYS_Direct_SETTING[2] = IN_技術指標3;
   SYS_Direct_SETTING[3] = IN_技術指標4;
   SYS_Direct_SETTING[4] = IN_技術指標5;
   SYS_Direct_SETTING[5] = IN_技術指標6;
   SYS_Direct_SETTING[6] = IN_技術指標7;
   SYS_Direct_SETTING[7] = IN_技術指標8;
   SYS_Direct_SETTING[8] = IN_技術指標9;
}

void StartAction() {
   
   
   CalculatePrice();
   CalculateProfit();
   CheckSellBuyAllow();
   
   if (StopDateSetting[0] == "1")
      if (CheckDayStop(StopDateSetting[1], StopDateSetting[2]) == true) {
         ALLOW_BUY = false;
         ALLOW_SELL = false;
         
         //if (SELL_張數 > 0)
         //   flgSellClose = true;
            
         //if (BUY_張數 > 0)
         //   flgBuyClose = true;
      }
      
   flg_stop_date = CheckStopDate(SYS_STOP_DATE[0], SYS_STOP_DATE[1]);
   flg_execute_time = CheckExecuteTime(SYS_EXECUTE_TIME[0], SYS_EXECUTE_TIME[1]);
   
   iStartLots = GetStartLots(IN_起始手數);
   
   if (flg_execute_time == true && flg_stop_date == false) {
      CheckFirstOrder(iStartLots, SYS_EA_NAME);
   }

   if (SYS_EXECUTE_TIME[0] == "2") {
         if (flg_execute_time == false) {
               if (SELL_張數 > 0) {
                     flgSellClose = true;
               }

               if (BUY_張數 > 0) {
                     flgBuyClose = true;
               }
         }
   }
   
   CheckRaiseOrder(iStartLots, IN_馬丁倍率, IN_馬丁點距, IN_點距倍率, IN_馬丁張數, SYS_EA_NAME);
   
   CalculateProfit();
}

double GetStartLots(double StartLots) {
   int AllowTurbo = StrToInteger(SYS_渦輪增壓[0]);
   double BaseLots = StrToDouble(SYS_渦輪增壓[1]);
   double BaseBalance = StrToDouble(SYS_渦輪增壓[2]);
   double MaxLots = StrToDouble(SYS_渦輪增壓[3]);
   double iTimes = AccountBalance() / BaseBalance;
   double ReturnLots = 0.01;
   
   ReturnLots = BaseLots * iTimes;
   
   if (ReturnLots < 0.01)
      ReturnLots = 0.01;
   
   if (ReturnLots > MaxLots)
      ReturnLots = MaxLots;
   
   if (AllowTurbo == 0) {
      return (StartLots);
   }
   else {
      return (ReturnLots);
   }
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   
   OldTime = iTime(NULL, GetPeriod(IN_計算頻率), 0);
   NewTime = iTime(NULL, GetPeriod(IN_計算頻率), 0);
   
   StringSplit(IN_避險日期, StringGetCharacter("/", 0), SYS_STOP_DATE);
   StringSplit(IN_執行時間, StringGetCharacter("/", 0), SYS_EXECUTE_TIME);
   StringSplit(IN_固定平倉時間, StringGetCharacter("/", 0), SYS_STOP_LOSS_TIME);
   
   InitParam();
   
   CalculateSysSellInfo(); 
   CalculateSysBuyInfo(); 
   
   DoCheckExpireDate();
   
   if (SYS_APP_ExpireDate_Status == "允許"
      && AccountTradeMode == "DEMO"
      ) {
      StartAction();
   }
   
   ShowSystemInfo();
   ShowCheckConnect();
   ShowAccountInfo();
   ShowAppSetting();
   Show_MA_INFO();
   ShowTimeInfo();
   ShowOrderInfo();
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      if (IN_計算頻率 != "TICK") {
            if (IN_計算頻率 == "SEC") {
                  NewTime = TimeCurrent();
            }
            else {
                  NewTime = iTime(NULL, GetPeriod(IN_計算頻率), 0);
            }
            
            TimeDiff = NewTime - OldTime;

            if ((""+NewTime) != (""+OldTime)) {
                  OldTime = NewTime;
                  DoCheckExpireDate();

                  if (SYS_APP_ExpireDate_Status == "允許")
                        StartAction();
            }
      }
      else { 
            DoCheckExpireDate();

            if (SYS_APP_ExpireDate_Status == "允許")
                  StartAction();
      }
      
      CalculatePrice();
      CalculateProfit();
      CheckOrderClose();
      doOrderClose();
      
      ShowSystemInfo();
      ShowCheckConnect();
      ShowAccountInfo();
      ShowAppSetting();
      Show_MA_INFO();
      ShowTimeInfo();
      ShowOrderInfo();
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
