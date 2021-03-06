//+------------------------------------------------------------------+
//|                                        UltronTraderFX.mqh |
//|                                                     Michael Chiu |
//|                             https://www.facebook.com/weihsinchiu |
//+------------------------------------------------------------------+
#property copyright "Michael Chiu"
#property link      "https://www.facebook.com/weihsinchiu"
#property strict

bool flgSellClose = false;
bool flgBuyClose = false;

bool ALLOW_SELL = false;
bool ALLOW_BUY = false;

string SYS_ShortTerm = "--";
string SYS_MiddleTerm = "--";
string SYS_LongTerm = "--";

string SYS_Direct_SETTING[10];
string SYS_result[10];

int SYS_BullCount = 0;
int SYS_BearCount = 0;
int SYS_WaitCount = 0;
int SYS_SettingCount = 0;

string SYS_馬丁多空 = "--";

string SYS_TakeProfit = "--";
string SYS_StopLoss = "--";

int SYS_均線多空判斷 = 1;
int SYS_技術指標多空判斷 = 1;
int SYS_技術指標逆勢降低獲利 = 1;
int SYS_使用ACAO多空判斷 = 1;
int SYS_多空轉換停損 = 0;
int SYS_馬丁多空同步 = 0;
double SYS_FORCE停損值=0;

string SYS_技術指標計算時間="";

double SYS_SELL = 0;
double SYS_BUY = 0;
int SYS_點差 = 0;

int BUY_張數 = 0;
double BUY_總手數 = 0;
float BUY_第一單手數 = 0;
double BUY_第一單進價 = 0;
float BUY_最新手數 = 0;
double BUY_最新進價 = 0;
double BUY_平均成本 = 0;
double BUY_停利價格 = 0;
int BUY_價差 = 0;
double BUY_獲利 = 0;
int BUY_MAX_張數 = 0;
double BUY_MAX_手數 = 0;
int BUY_MAX_逆勢點數 = 0;
double BUY_MAX_浮虧 = 0;

int SELL_張數 = 0;
double SELL_總手數 = 0;
float SELL_第一單手數 = 0;
double SELL_第一單進價 = 0;
float SELL_最新手數 = 0;
double SELL_最新進價 = 0;
double SELL_平均成本 = 0;
double SELL_停利價格 = 0;
int SELL_價差 = 0;
double SELL_獲利 = 0;
int SELL_MAX_張數 = 0;
double SELL_MAX_手數 = 0;
int SELL_MAX_逆勢點數 = 0;
double SELL_MAX_浮虧 = 0;

double TOTAL_獲利 = 0;
double TOTAL_最大浮虧 = 0;
double TOTAL_最大獲利 = 0;

string MA_Distance[6];

double MA[6][6];
double MA_DIFF[6][6];
double MACD_MAIN[10];
double MACD_SIGNAL[10];
double MACD_DIFF[10];
double KD_MAIN[10];
double KD_SIGNAL[10];
double KD_DIFF[10];
double AC_VALUE[10];
double AC_DIFF[10];
double AO_VALUE[10];
double AO_DIFF[10];
double FORCE[10];
double FORCE_DIFF[10];
double RSI_VALUE[10];
double RSI_DIFF[10];

double FORCE_AVG=0;
double KD_AVG=0;
double MACD_AVG=0;
double RSI_AVG=0;

string MACD_SETTINGS[];
string KD_SETTINGS[];
string RSI_SETTINGS[];

string SYS_SAR_SETTING_1[];
string SYS_SAR_SETTING_2[];
string SYS_SAR_SETTING_3[];

int NewBuy(double iLots, int iSlippage, double iStoploss, double iTakeprofit, string iComment, int iMagicNumber) { 
   int Ticket = -1; 
   color iArrowColor; 

   iArrowColor = clrBlue;
   Ticket = OrderSend(Symbol(), OP_BUY, iLots, Ask, iSlippage, iStoploss, iTakeprofit, iComment, iMagicNumber, 0, iArrowColor); 
         
   return (Ticket); 
} 


int NewSell(double iLots, int iSlippage, double iStoploss, double iTakeprofit, string iComment, int iMagicNumber) { 
   int Ticket = -1; 
   color iArrowColor; 

   iArrowColor = clrPink; 
   Ticket = OrderSend(Symbol(), OP_SELL, iLots, Bid, iSlippage, iStoploss, iTakeprofit, iComment, iMagicNumber, 0, iArrowColor);

   return (Ticket); 
}

int CheckDateTime(string Date1, string Date2) {
   int Len1 = StringLen(Date1), Len2 = StringLen(Date2);
   
   if (Len2 == 5) {
      string ThisYear = TimeYear(TimeLocal());
      Date2 = ThisYear + "." + Date2;
      Len2 = StringLen(Date2);
   }
   
   if (Len1 > Len2)
      Date1 = StringSubstr(Date1, 0, Len2);
   else
      Date2 = StringSubstr(Date2, 0, Len1);
   
   //Print("CheckDateTime: " + Date1 + " -> " + Date2 + " = " + StringCompare(Date1, Date2));
   
   return (StringCompare(Date1, Date2));
}

string GetDate(datetime ThisTime) {
   string result = "" + ThisTime;
   
   result = StringSubstr(result, 0, 10);
   
   return (result);
}

string GetTime(datetime ThisTime) {
   string result = "" + ThisTime;
   
   result = StringSubstr(result, 11, 5);
   
   return (result);
}

string GetDate2(datetime ThisTime) {
   string result = "" + ThisTime;
   
   result = StringSubstr(result, 5, 5);
   
   return (result);
}

int GetPeriod(string ThisPeriod) {
   int i_period = PERIOD_M5;

   if (ThisPeriod == "CURRENT")
      i_period = PERIOD_CURRENT;
   else if (ThisPeriod == "M1")
      i_period = PERIOD_M1;
   else if (ThisPeriod == "M5")
      i_period = PERIOD_M5;
   else if (ThisPeriod == "M10")
      i_period = 10;
   else if (ThisPeriod == "M15")
      i_period = PERIOD_M15;
   else if (ThisPeriod == "M30")
      i_period = PERIOD_M30;
   else if (ThisPeriod == "H1")
      i_period = PERIOD_H1;
   else if (ThisPeriod == "H2")
      i_period = 120;
   else if (ThisPeriod == "H4")
      i_period = PERIOD_H4;
   else if (ThisPeriod == "H6")
      i_period = 360;
   else if (ThisPeriod == "H12")
      i_period = 720;
   else if (ThisPeriod == "D1")
      i_period = PERIOD_D1;
   else if (ThisPeriod == "W1")
      i_period = PERIOD_W1;
   else if (ThisPeriod == "MN1")
      i_period = PERIOD_MN1;
      
   return (i_period);
}

string CheckTechDirect(string TechDirectParam) {
   string params[];
   string settings[];
   string result = "--";
   
   if (TechDirectParam == "")
      return ("");
   
   StringSplit(TechDirectParam, StringGetCharacter(":", 0), params);
   StringSplit(params[2], StringGetCharacter("/", 0), settings);
   
   
   if (params[0] == "0") {
      return ("");
   }
   else {
      if (params[1] == "SAR") {
         result = CheckSAR(settings[0], settings[1], settings[2], settings[3]);
      }
      else if (params[1] == "Alligator") {
         result = CheckAlligator(settings[0], settings[1], settings[2], settings[3]);
      }
      else if (params[1] == "MACD") {
         result = CheckMACD(settings[0], settings[1], settings[2], settings[3]);
      }
      else if (params[1] == "KD") {
         result = CheckKD(settings[0], settings[1], settings[2], settings[3]);
      }
      else if (params[1] == "RSI") {
         result = CheckRSI(settings[0], settings[1], settings[2], settings[3]);
      }
      else if (params[1] == "MA") {
         result = CheckMA(settings[0], settings[1], settings[2], settings[3]);
      }

      if (params[0] == "-1") {
            if (result == "偏多")
                  result = "偏空";
            else if (result == "偏空")
                  result = "偏多";
      }
   }
   
   return (result);
}

//MACD設定: 12/26/9/0
//KD設定: 5/5/5/2/0
void CheckSellBuyAllow() {

   
   SYS_技術指標計算時間 = "" + TimeCurrent();
   
   /***
   SYS_LongTerm = CheckAlligator("D1,H1,M15", 2,"20,0,10,0,5,0,2,6", 2);
   SYS_MiddleTerm = CheckMACD("D1,H1,M15", 1, "12,26,9,6", 2);
   SYS_ShortTerm = CheckKD("D1,H1,M15", 1, "9,9,6,2,1,55,45", 2);
   SYS_ShortTerm = CheckRSI("M30", 1,"5,10,20,52,48,6", 3);
   
   SYS_LongTerm = CheckAlligator("D1,H1,M15", 2,"20,0,10,0,5,0,2,6", 2);
   SYS_MiddleTerm = CheckSAR("D1,H1,M15", 1, "0.01,0.1", 2);
   SYS_ShortTerm = CheckKD("D1,H1,M15", 1, "9,9,6,2,1,55,45", 2);

   SYS_LongTerm = CheckTechDirect(SYS_Direct_SETTING_1);
   SYS_MiddleTerm = CheckTechDirect(SYS_Direct_SETTING_2);
   SYS_ShortTerm = CheckTechDirect(SYS_Direct_SETTING_3);
   
   SYS_馬丁多空 = CheckSAR("M1", 1, "0.008,0.2", 1);
   
   if (SYS_ShortTerm == "偏多" && SYS_MiddleTerm == "偏多" && SYS_LongTerm == "偏多") {
      ALLOW_BUY = true;
      ALLOW_SELL = false;
   }
   else if (SYS_ShortTerm == "偏空" && SYS_MiddleTerm == "偏空" && SYS_LongTerm == "偏空") {
      ALLOW_BUY = false;
      ALLOW_SELL = true;
   }
   else {
      ALLOW_BUY = false;
      ALLOW_SELL = false;
   }
   ***/
   
   SYS_BullCount = 0;
   SYS_BearCount = 0;
   SYS_WaitCount = 0;
   SYS_SettingCount = 0;
   
   for (int i = 0; i < 9; i++) {
      SYS_result[i] = CheckTechDirect(SYS_Direct_SETTING[i]);
   }
  
   for (int i = 0; i < 9; i++) {
      if (SYS_result[i] != "")
         SYS_SettingCount++;
         
      if (SYS_result[i] == "--")
         SYS_WaitCount++;
         
      if (SYS_result[i] == "偏多")
         SYS_BullCount++;
         
      if (SYS_result[i] == "偏空")
         SYS_BearCount++;
   }
   
   
   if (SYS_BullCount == SYS_SettingCount) {
      ALLOW_BUY = true;
      ALLOW_SELL = false;
   }
   else if (SYS_BearCount == SYS_SettingCount) {
      ALLOW_BUY = false;
      ALLOW_SELL = true;
   }
   else {
      ALLOW_BUY = false;
      ALLOW_SELL = false;
   }
}

string CheckCandlestick(string ThisPeriodList, int iMode, string TechnicalSetting, int count) {
   string result = "--";
   string Settings[];
   string ThisPeriod[];
   bool BuyAllow = true;
   bool SellAllow = true;
   int timeframe = PERIOD_D1;
   int PeriodCount = 0;
   
   if (TechnicalSetting == "")
      TechnicalSetting = "12,26,9,0";
   
   //timeframe = GetPeriod(ThisPeriod);
   StringSplit(TechnicalSetting, StringGetCharacter(",", 0), Settings);
   StringSplit(ThisPeriodList, StringGetCharacter(",", 0), ThisPeriod);
   
   PeriodCount = ArraySize(ThisPeriod);
   
   return ("");
}

string CheckMACD(string ThisPeriodList, int iMode, string MACD設定, int count) {
   string result = "--";
   string Settings[];
   string ThisPeriod[];
   bool BuyAllow = true;
   bool SellAllow = true;
   int timeframe = PERIOD_D1;
   int PeriodCount = 0;
   
   if (MACD設定 == "")
      MACD設定 = "12,26,9,0";
   
   //timeframe = GetPeriod(ThisPeriod);
   StringSplit(MACD設定, StringGetCharacter(",", 0), Settings);
   StringSplit(ThisPeriodList, StringGetCharacter(",", 0), ThisPeriod);
   
   PeriodCount = ArraySize(ThisPeriod);
   
   for (int p = 0; p < PeriodCount; p++) {
      timeframe = GetPeriod(ThisPeriod[p]);
      
      for (int i = 0; i < count; i++) {
         double iMACD_MAIN = iMACD(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], MODE_MAIN, i);
         double iMACD_MAIN2 = iMACD(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], MODE_SIGNAL, i+1);
         double iMACD_SIGNAL = iMACD(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], MODE_SIGNAL, i);
         double iMACD_SIGNAL2 = iMACD(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], MODE_SIGNAL, i+1);
         double iMACD_DIFF = iMACD_MAIN - iMACD_MAIN2;
         double iMACD_OSC = iMACD_MAIN - iMACD_SIGNAL;
         double iMACD_OSC2 = iMACD_MAIN2 - iMACD_SIGNAL2;
         double iMACD_OSC_DIFF = iMACD_OSC - iMACD_OSC2;
         
         switch (iMode) {
            case 1:
               if (!(iMACD_OSC > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iMACD_OSC < 0))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 2:
               if (!(iMACD_OSC > 0 && iMACD_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
                     
                if (!(iMACD_OSC < 0 && iMACD_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 3:
               if (!(iMACD_MAIN > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
                     
               if (!(iMACD_MAIN < 0))
                  if (SellAllow == true)
                     SellAllow = false;
   
               break;
               
            case 4:
               if (!(iMACD_OSC > 0 && iMACD_DIFF > 0 && iMACD_MAIN > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
                     
               if (!(iMACD_OSC < 0 && iMACD_DIFF < 0 && iMACD_MAIN < 0))
                  if (SellAllow == true)
                     SellAllow = false;
   
               break;
            
            case 5:
               if (!(iMACD_OSC_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
                     
               if (!(iMACD_OSC_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
   
               break;
         }
      }
   }
   
   
   
   if (BuyAllow == true && SellAllow == false)
      result = "偏多";
      
   if (BuyAllow == false && SellAllow == true)
      result = "偏空";
      
   return (result);
}

string CheckRSI(string ThisPeriodList, int iMode, string RSI設定, int count) {
   string result = "--";
   string Settings[];
   string ThisPeriod[];
   bool BuyAllow = true;
   bool SellAllow = true;
   int timeframe = PERIOD_D1;
   int KD_BUY = 0, KD_SELL = 0;
   int PeriodCount = 0;
   
   if (RSI設定 == "")
      RSI設定 = "5,10,20,6";
   
   StringSplit(RSI設定, StringGetCharacter(",", 0), Settings);
   StringSplit(ThisPeriodList, StringGetCharacter(",", 0), ThisPeriod);
   
   PeriodCount = ArraySize(ThisPeriod);
   
   for (int p = 0; p < PeriodCount; p++) {
      timeframe = GetPeriod(ThisPeriod[p]);
      
      for (int i = 0; i < count; i++) {
         double iRSI_s = iRSI(NULL, timeframe, Settings[0], Settings[5], i);
         double iRSI_m = iRSI(NULL, timeframe, Settings[1], Settings[5], i);
         double iRSI_l = iRSI(NULL, timeframe, Settings[2], Settings[5], i);
         
         switch (iMode) {
            case 1:
               if (!(iRSI_s > iRSI_m && iRSI_m > iRSI_l))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iRSI_s < iRSI_m && iRSI_m < iRSI_l))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 2:
               if (!(iRSI_s > iRSI_m && iRSI_m > iRSI_l && iRSI_s > StrToDouble(Settings[3]) && iRSI_m > StrToDouble(Settings[3]) && iRSI_l > StrToDouble(Settings[3])))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iRSI_s < iRSI_m && iRSI_m < iRSI_l && iRSI_s < StrToDouble(Settings[4]) && iRSI_m < StrToDouble(Settings[4]) && iRSI_l < StrToDouble(Settings[4])))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
         }
      }
   }
   
   
   if (BuyAllow == true && SellAllow == false)
      result = "偏多";
      
   if (BuyAllow == false && SellAllow == true)
      result = "偏空";
      
   return (result);
}

string CheckSAR(string ThisPeriodList, int iMode, string SAR設定, int count) {
   string result = "--";
   string Settings[];
   string ThisPeriod[];
   bool BuyAllow = true;
   bool SellAllow = true;
   int timeframe = PERIOD_D1;
   int PeriodCount = 0;
   
   if (SAR設定 == "")
      SAR設定 = "0.02,0.2";
   
   StringSplit(SAR設定, StringGetCharacter(",", 0), Settings);
   StringSplit(ThisPeriodList, StringGetCharacter(",", 0), ThisPeriod);
   
   PeriodCount = ArraySize(ThisPeriod);
   
   for (int p = 0; p < PeriodCount; p++) {
      timeframe = GetPeriod(ThisPeriod[p]);
      
      for (int i = 0; i < count; i++) {
         double iSAR_Value = iSAR(NULL, timeframe, Settings[0], Settings[1], i);
         double iClose_Value = iClose(NULL, timeframe, i);
         double iPower = iClose_Value - iSAR_Value;
         double iSAR_Value2 = iSAR(NULL, timeframe, Settings[0], Settings[1], i+1);
         double iClose_Value2 = iClose(NULL, timeframe, i+1);
         double iPower2 = iClose_Value2 - iSAR_Value2;
         double iDiff = iPower - iPower2;
         
         switch (iMode) {
            case 1:
               if (!(iSAR_Value < iClose_Value))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iSAR_Value > iClose_Value))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 2:
               if (!(iSAR_Value < iClose_Value && iDiff > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iSAR_Value > iClose_Value && iDiff < 0))
                  if (SellAllow == true)
                     SellAllow = false;
               break;
         }
      }
   }
   
   
   if (BuyAllow == true && SellAllow == false)
      result = "偏多";
      
   if (BuyAllow == false && SellAllow == true)
      result = "偏空";
      
   return (result);
}
/***
double  iMA( 
   string       symbol,           // symbol 
   int          timeframe,        // timeframe 
   int          ma_period,        // MA averaging period 
   int          ma_shift,         // MA shift 
   int          ma_method,        // averaging method 
   int          applied_price,    // applied price 
   int          shift             // shift 
   );
   
ENUM_MA_METHOD		
ID	Value	Description
MODE_SMA	0	Simple averaging
MODE_EMA	1	Exponential averaging
MODE_SMMA	2	Smoothed averaging
MODE_LWMA	3	Linear-weighted averaging

ENUM_APPLIED_PRICE		
ID	Value	Description
PRICE_CLOSE	0	Close price
PRICE_OPEN	1	Open price
PRICE_HIGH	2	The maximum price for the period
PRICE_LOW	3	The minimum price for the period
PRICE_MEDIAN	4	Median price, (high + low)/2
PRICE_TYPICAL	5	Typical price, (high + low + close)/3
PRICE_WEIGHTED	6	Weighted close price, (high + low + close + close)/4

***/
string CheckMA(string ThisPeriodList, int iMode, string MA設定, int count) {
   string result = "--";
   string Settings[];
   string ThisPeriod[];
   bool BuyAllow = true;
   bool SellAllow = true;
   int timeframe = PERIOD_D1;
   int KD_BUY = 0, KD_SELL = 0;
   int PeriodCount = 0;
   
   if (MA設定 == "")
      MA設定 = "100,0,2,6";
   
   StringSplit(MA設定, StringGetCharacter(",", 0), Settings);
   StringSplit(ThisPeriodList, StringGetCharacter(",", 0), ThisPeriod);
   
   PeriodCount = ArraySize(ThisPeriod);
   
   for (int p = 0; p < PeriodCount; p++) {
      timeframe = GetPeriod(ThisPeriod[p]);
      
      for (int i = 0; i < count; i++) {
         double ThisPrice = iClose(NULL, timeframe, i);
         double ThisPrice2 = iClose(NULL, timeframe, i+1);
         double iMA_Price = iMA(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], i);
         double iMA_Price2 = iMA(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], i+1);
         double Price_MA_DIFF = ThisPrice - iMA_Price;
         double Price_MA_DIFF2 = ThisPrice2 - iMA_Price2;
         double Price_MA_DIFF_DIFF = Price_MA_DIFF - Price_MA_DIFF2;
         double iMA_DIFF = iMA_Price - iMA_Price2;
         
         switch (iMode) {
            case 1:
               if (!(Price_MA_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(Price_MA_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 2:
               if (!(Price_MA_DIFF > 0 && iMA_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
                     
                if (!(Price_MA_DIFF < 0 && iMA_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 3:
               if (!(Price_MA_DIFF > 0 && iMA_DIFF > 0 && Price_MA_DIFF_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
                     
               if (!(Price_MA_DIFF < 0 && iMA_DIFF < 0 && Price_MA_DIFF_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
   
               break;
         }
      }
   }
   
   
   if (BuyAllow == true && SellAllow == false)
      result = "偏多";
      
   if (BuyAllow == false && SellAllow == true)
      result = "偏空";
      
   return (result);
}

string CheckKD(string ThisPeriodList, int iMode, string KD設定, int count) {
   string result = "--";
   string Settings[];
   string ThisPeriod[];
   bool BuyAllow = true;
   bool SellAllow = true;
   int timeframe = PERIOD_D1;
   int KD_BUY = 0, KD_SELL = 0;
   int PeriodCount = 0;
   
   if (KD設定 == "")
      KD設定 = "9,9,6,2,0,60,40";
   
   StringSplit(KD設定, StringGetCharacter(",", 0), Settings);
   StringSplit(ThisPeriodList, StringGetCharacter(",", 0), ThisPeriod);
   
   PeriodCount = ArraySize(ThisPeriod);
   
   KD_BUY = Settings[5];
   KD_SELL = Settings[6];
   
   for (int p = 0; p < PeriodCount; p++) {
      timeframe = GetPeriod(ThisPeriod[p]);
      
      for (int i = 0; i < count; i++) {
         double iKD_MAIN = iStochastic(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], MODE_MAIN, i);
         double iKD_MAIN2 = iStochastic(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], MODE_MAIN, i+1);
         double iKD_SIGNAL = iStochastic(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], MODE_SIGNAL, i);
         double iKD_SIGNAL2 = iStochastic(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], MODE_SIGNAL, i+1);
         double iKD_DIFF = iKD_MAIN - iKD_SIGNAL;
         double iKD_DIFF2 = iKD_MAIN2 - iKD_SIGNAL2;
         double iKD_MAIN_DIFF = iKD_MAIN - iKD_MAIN2;
         double iKD_DIFF_DIFF = iKD_DIFF - iKD_DIFF2;
         
         
         switch (iMode) {
            case 1:
               if (!(iKD_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iKD_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 2:
               if (!(iKD_DIFF > 0 && iKD_MAIN > KD_BUY))
                  if (BuyAllow == true)
                     BuyAllow = false;
                     
                if (!(iKD_DIFF < 0 && iKD_MAIN < KD_SELL))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 3:
               if (!(iKD_MAIN > KD_BUY && iKD_DIFF > 0 && iKD_DIFF_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
                     
               if (!(iKD_MAIN < KD_SELL && iKD_DIFF < 0 && iKD_DIFF_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
   
               break;
               
            case 4:
               if (!(iKD_MAIN > KD_BUY))
                  if (BuyAllow == true)
                     BuyAllow = false;
                     
               if (!(iKD_MAIN < KD_SELL))
                  if (SellAllow == true)
                     SellAllow = false;
   
               break;
         }
      }
   }
   
   
   if (BuyAllow == true && SellAllow == false)
      result = "偏多";
      
   if (BuyAllow == false && SellAllow == true)
      result = "偏空";
      
   return (result);
}

string CheckAOAC(string ThisPeriodList, int iMode, int count) {
   string result = "--";
   string Settings[];
   string ThisPeriod[];
   bool BuyAllow = true;
   bool SellAllow = true;
   int timeframe = PERIOD_D1;
   int PeriodCount = 0;
   
   StringSplit(ThisPeriodList, StringGetCharacter(",", 0), ThisPeriod);
   PeriodCount = ArraySize(ThisPeriod);
   
   for (int p = 0; p < PeriodCount; p++) {
      timeframe = GetPeriod(ThisPeriod[p]);
      
      for (int i = 0; i < count; i++) {
         double iAO_VALUE1 = iAO(NULL, timeframe, i);
         double iAO_VALUE2 = iAO(NULL, timeframe, i+1);
         double iAC_VALUE1 = iAC(NULL, timeframe, i);
         double iAC_VALUE2 = iAC(NULL, timeframe, i+1);
         double iAO_DIFF = iAO_VALUE1 - iAO_VALUE2;
         double iAC_DIFF = iAC_VALUE1 - iAC_VALUE2;
         
         
         switch (iMode) {
            case 1:
               if (!(iAO_DIFF > 0 && iAC_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iAO_DIFF < 0 && iAC_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 2:
               if (!(iAO_DIFF > 0 && iAO_VALUE1 > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iAO_DIFF < 0 && iAO_VALUE1 < 0))
                  if (SellAllow == true)
                     SellAllow = false;
               
               break;
               
            case 3:
               if (!(iAC_VALUE1 > 0 && iAC_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iAC_VALUE1 < 0 && iAC_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
   
               break;
               
            case 4:
               if (!(iAO_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iAO_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
   
               break;
               
            case 5:
               if (!(iAC_DIFF > 0))
                  if (BuyAllow == true)
                     BuyAllow = false;
               
               if (!(iAC_DIFF < 0))
                  if (SellAllow == true)
                     SellAllow = false;
   
               break;
         }
      }
   
   }
   
   
   
   if (BuyAllow == true && SellAllow == false)
      result = "偏多";
      
   if (BuyAllow == false && SellAllow == true)
      result = "偏空";
      
   return (result);
}

/***
double  iAlligator( 
   string       symbol,            // symbol 
   int          timeframe,         // timeframe 
   int          jaw_period,        // Jaw line averaging period 
   int          jaw_shift,         // Jaw line shift 
   int          teeth_period,      // Teeth line averaging period 
   int          teeth_shift,       // Teeth line shift 
   int          lips_period,       // Lips line averaging period 
   int          lips_shift,        // Lips line shift 
   int          ma_method,         // averaging method 
   int          applied_price,     // applied price 
   int          mode,              // line index 
   int          shift              // shift 
   );
***/
string CheckAlligator(string ThisPeriodList, int iMode, string Alligator設定, int count) {
   string result = "--";
   string Settings[];
   string ThisPeriod[];
   bool BuyAllow = true;
   bool SellAllow = true;
   int timeframe = PERIOD_D1;
   int PeriodCount = 0;
   
   if (Alligator設定 == "")
      Alligator設定 = "20,0,10,0,5,0,2,0";
      
   StringSplit(Alligator設定, StringGetCharacter(",", 0), Settings);
   StringSplit(ThisPeriodList, StringGetCharacter(",", 0), ThisPeriod);
   PeriodCount = ArraySize(ThisPeriod);
   
   for (int pp = 0; pp < PeriodCount; pp++) {
      timeframe = GetPeriod(ThisPeriod[pp]);
   
      for (int i = 0; i < count; i++) {
         double iMA_S = iAlligator(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], Settings[5], Settings[6], Settings[7], MODE_GATORLIPS, i);
         double iMA_M = iAlligator(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], Settings[5], Settings[6], Settings[7], MODE_GATORTEETH, i);
         double iMA_L = iAlligator(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], Settings[5], Settings[6], Settings[7], MODE_GATORJAW, i);
         double iMA_S_DIFF = iMA_S - iAlligator(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], Settings[5], Settings[6], Settings[7], MODE_GATORLIPS, i+1);
         double iMA_M_DIFF = iMA_M - iAlligator(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], Settings[5], Settings[6], Settings[7], MODE_GATORTEETH, i+1);
         double iMA_L_DIFF = iMA_L - iAlligator(NULL, timeframe, Settings[0], Settings[1], Settings[2], Settings[3], Settings[4], Settings[5], Settings[6], Settings[7], MODE_GATORJAW, i+1);
         double iMA_S_NEXT = iMA_S + iMA_S_DIFF;
         double iMA_M_NEXT = iMA_M + iMA_M_DIFF;
         double iMA_L_NEXT = iMA_L + iMA_L_DIFF;
         double ThisClose = iClose(NULL, timeframe, i);
         double ThisOpen = iOpen(NULL, timeframe, i);
         
         switch (iMode) {
            case 1:
               /***
               if (BuyAllow == true)
                  if ( !(iMA_S > iMA_M && iMA_M > iMA_L && iMA_S_DIFF > 0 && iMA_M_DIFF > 0 && iMA_L_DIFF > 0) )
                     BuyAllow = false;
               
               if (SellAllow == true)
                  if ( !(iMA_S < iMA_M && iMA_M < iMA_L && iMA_S_DIFF < 0 && iMA_M_DIFF < 0 && iMA_L_DIFF < 0) )
                     SellAllow = false;
               **/
                     
               if (BuyAllow == true)
                  if ( !(iMA_S > iMA_M && iMA_M > iMA_L) )
                     BuyAllow = false;
               
               if (SellAllow == true)
                  if ( !(iMA_S < iMA_M && iMA_M < iMA_L) )
                     SellAllow = false;
               
               break;
               
            case 2:
               if (BuyAllow == true)
                  if ( !(iMA_S_DIFF > 0 && iMA_M_DIFF > 0 && iMA_L_DIFF > 0) )
                     BuyAllow = false;
               
               
               if (SellAllow == true)
                  if ( !(iMA_S_DIFF < 0 && iMA_M_DIFF < 0 && iMA_L_DIFF < 0 ) )
                     SellAllow = false;
               break;
               
            case 3:
               if (BuyAllow == true)
                  if ( !(ThisClose > iMA_S && iMA_S > iMA_M && iMA_M > iMA_L) )
                     BuyAllow = false;
               
               
               if (SellAllow == true)
                  if ( !(ThisClose < iMA_S && iMA_S < iMA_M && iMA_M < iMA_L) )
                     SellAllow = false;
               break;
               
            case 4:
               if (BuyAllow == true)
                  if ( !(iMA_S_NEXT > iMA_M_NEXT && iMA_M_NEXT > iMA_L_NEXT && iMA_S_DIFF > 0 && iMA_M_DIFF > 0 && iMA_L_DIFF > 0) )
                     BuyAllow = false;
               
               
               if (SellAllow == true)
                  if ( !(iMA_S_NEXT < iMA_M_NEXT && iMA_M_NEXT < iMA_L_NEXT && iMA_S_DIFF < 0 && iMA_M_DIFF < 0 && iMA_L_DIFF < 0) )
                     SellAllow = false;
               break;
         }
      }
   }
   
   if (BuyAllow == true && SellAllow == false)
      result = "偏多";
      
   if (BuyAllow == false && SellAllow == true)
      result = "偏空";
      
   return (result);
}

//MACD設定: 12/26/9/0
//KD設定: 5/5/5/2/0

string CheckBullAndBear(string ThisPeriod, int iMode, string MACD設定, string KD設定, int count) {
   string result = "--";
   bool BuyAllow = true;
   bool SellAllow = true;
   int timeframe = PERIOD_D1;
   string SettingsMACD[];
   string SettingsKD[];
   
   if (MACD設定 == "")
      MACD設定 = "12/26/9/0";
      
   if (KD設定 == "")
      KD設定 = "9/9/6/2/0";
   
   timeframe = GetPeriod(ThisPeriod);
   StringSplit(MACD設定, StringGetCharacter("/", 0), SettingsMACD);
   StringSplit(KD設定, StringGetCharacter("/", 0), SettingsKD);
   
   for (int i = 0; i < count; i++) {
      double iMACD_MAIN = iMACD(NULL, timeframe, SettingsMACD[0], SettingsMACD[1], SettingsMACD[2], SettingsMACD[3], MODE_MAIN, i);
      double iMACD_MAIN2 = iMACD(NULL, timeframe, SettingsMACD[0], SettingsMACD[1], SettingsMACD[2], SettingsMACD[3], MODE_SIGNAL, i+1);
      double iMACD_DIFF = iMACD_MAIN - iMACD_MAIN2;
      double iMACD_SIGNAL = iMACD(NULL, timeframe, SettingsMACD[0], SettingsMACD[1], SettingsMACD[2], SettingsMACD[3], MODE_SIGNAL, i);
      
      double iKD_MAIN = iStochastic(NULL, timeframe, SettingsKD[0], SettingsKD[1], SettingsKD[2], SettingsKD[3], SettingsKD[4], MODE_MAIN, i);
      double iKD_MAIN2 = iStochastic(NULL, timeframe, SettingsKD[0], SettingsKD[1], SettingsKD[2], SettingsKD[3], SettingsKD[4], MODE_MAIN, i+1);
      double iKD_DIFF = iKD_MAIN - iKD_MAIN2;
      double iKD_SIGNAL = iStochastic(NULL, timeframe, SettingsKD[0], SettingsKD[1], SettingsKD[2], SettingsKD[3], SettingsKD[4], MODE_SIGNAL, i);
      
      double iAC_MAIN = iAC(NULL, timeframe, i);
      double iAC_DIFF = iAC_MAIN-iAC(NULL, timeframe, i+1);
      
      double iAO_MAIN = iAO(NULL, timeframe, i);
      double iAO_DIFF = iAO_MAIN-iAO(NULL, timeframe, i+1);
   
      if (BuyAllow == true) {
         //if (iClose(NULL, timeframe, i) < iMA(NULL, timeframe, 3, 0, 2, 4, i))
         //   BuyAllow = false;
         
         switch (iMode) {
            case 1:
               if (!(iMACD_MAIN > iMACD_SIGNAL))
                  BuyAllow = false;
                  
               if (!(iKD_MAIN > iKD_SIGNAL && iKD_MAIN > 50))
                  BuyAllow = false;
               
               break;
               
            case 2:
               if (!(iMACD_MAIN > 0 && iMACD_DIFF > 0))
                  BuyAllow = false;
                  
               if (!(iKD_MAIN > iKD_SIGNAL && iKD_DIFF > 0))
                  BuyAllow = false;
               break;
               
            case 3:
               if (!(iAC_DIFF > 0 && iAO_DIFF > 0))
                  BuyAllow = false;
               break;
         }
         
      }
      
      if (SellAllow == true) {
         //if (iClose(NULL, timeframe, i) > iMA(NULL, timeframe, 3, 0, 2, 4, i))
         //   SellAllow = false;
            
         switch (iMode) {
            case 1:
               if (!(iMACD_MAIN < iMACD_SIGNAL))
                  SellAllow = false;
                  
               if (!(iKD_MAIN < iKD_SIGNAL && iKD_MAIN < 50))
                  SellAllow = false;
               
               break;
               
            case 2:
               if (!(iMACD_MAIN < 0 && iMACD_DIFF < 0))
                  SellAllow = false;
                  
               if (!(iKD_MAIN < iKD_SIGNAL && iKD_DIFF > 0))
                  SellAllow = false;
               break;
               
            case 3:
               if (!(iAC_DIFF < 0 && iAO_DIFF < 0))
                  SellAllow = false;
               break;
         }
      }
   }
   
   if (BuyAllow == true && SellAllow == false)
      result = "偏多";
      
   if (BuyAllow == false && SellAllow == true)
      result = "偏空";
      
   return (result);
}

void CheckSellBuyAllow_OLD(string ThisPeriod, string ma_period_list, int iMode, int iPrice, int iShift) {
   SYS_技術指標計算時間 = "" + TimeCurrent();
   int i_period = PERIOD_M5;
   string ma_period[];
   int MaxRow = 6;
   int MaxCol = 4;
   
   StringSplit(ma_period_list, StringGetCharacter(",", 0), ma_period);
   
   i_period = GetPeriod(ThisPeriod);
   
   for (int i = 0; i < 6; i++) {
      if (MACD_SETTINGS[0] != "0") {
         MACD_MAIN[i] = iMACD(NULL, i_period, MACD_SETTINGS[1], MACD_SETTINGS[2], MACD_SETTINGS[3], MACD_SETTINGS[4], MODE_MAIN, iShift+i);
         MACD_SIGNAL[i] = iMACD(NULL, i_period, MACD_SETTINGS[1], MACD_SETTINGS[2], MACD_SETTINGS[3], MACD_SETTINGS[4], MODE_SIGNAL, iShift+i);
      }
      
      if (KD_SETTINGS[0] != "0") {
         KD_MAIN[i] = iStochastic(NULL, i_period, KD_SETTINGS[1], KD_SETTINGS[2], KD_SETTINGS[3], KD_SETTINGS[4], KD_SETTINGS[5], MODE_MAIN, iShift+i);
         KD_SIGNAL[i] = iStochastic(NULL, i_period, KD_SETTINGS[1], KD_SETTINGS[2], KD_SETTINGS[3], KD_SETTINGS[4], KD_SETTINGS[5], MODE_SIGNAL, iShift+i);
      }
      
      if (RSI_SETTINGS[0] != "0") {
         RSI_VALUE[i] = iRSI(NULL, i_period, RSI_SETTINGS[1], RSI_SETTINGS[2], iShift+i);
      }
      
      if (SYS_使用ACAO多空判斷 > 0) {
         AC_VALUE[i] = iAC(NULL, i_period, iShift+i);
         AO_VALUE[i] = iAO(NULL, i_period, iShift+i);
      }
      
      KD_AVG += KD_MAIN[i];
      MACD_AVG += MACD_MAIN[i];
      RSI_AVG += RSI_VALUE[i];
      
   }
   
   KD_AVG = KD_AVG/6;
   MACD_AVG = MACD_AVG/6;
   RSI_AVG = RSI_AVG/6;
   
   for (int i = 0; i < 5; i++) {
      if (MACD_SETTINGS[0] != "0")
         MACD_DIFF[i] = MACD_MAIN[i] - MACD_MAIN[i+1];
       
      if (KD_SETTINGS[0] != "0")
         KD_DIFF[i] = KD_MAIN[i] - KD_MAIN[i+1];
         
      if (RSI_SETTINGS[0] != "0")
         RSI_DIFF[i] = RSI_VALUE[i] - RSI_VALUE[i+1];
      
      if (SYS_使用ACAO多空判斷 > 0) {
         AC_DIFF[i] = AC_VALUE[i] - AC_VALUE[i+1];
         AO_DIFF[i] = AO_VALUE[i] - AO_VALUE[i+1];
      }
   }
   
   for (int row = 0; row < MaxRow; row++) {
      for (int col = 0; col < MaxCol; col++) {
         MA[row][col] = iMA(NULL, i_period, ma_period[row], 0, iMode, iPrice, iShift+col);
      }
   }

   if (SYS_均線多空判斷 > 0) {
      for (int row = 0; row < MaxRow; row++) {
         for (int col = 0; col < MaxCol-1; col++) {
            MA_DIFF[row][col] = MA[row][col] - MA[row][col+1];
         }
      }
   }
   
   ALLOW_BUY = true;
   ALLOW_SELL = true;
   
   if (SYS_均線多空判斷 == 0) {
      //ALLOW_BUY = true;
      //ALLOW_SELL = true;
      //return ;
   }
   else if (SYS_均線多空判斷 == 1) {
      
      if (MA_DIFF[0][0]/Point > StrToInteger(MA_Distance[0]) 
         && MA_DIFF[1][0]/Point > StrToInteger(MA_Distance[1])
         && MA_DIFF[2][0]/Point > StrToInteger(MA_Distance[2])
         && MA_DIFF[3][0]/Point > StrToInteger(MA_Distance[3])
         && MA_DIFF[4][0]/Point > StrToInteger(MA_Distance[4])
         && MA_DIFF[5][0]/Point > StrToInteger(MA_Distance[5])
         ) {
         
         ALLOW_BUY = true;
         ALLOW_SELL = false;
      }
      else if (MA_DIFF[0][0]/Point < -1*StrToInteger(MA_Distance[0]) 
         && MA_DIFF[1][0]/Point < -1*StrToInteger(MA_Distance[1])
         && MA_DIFF[2][0]/Point < -1*StrToInteger(MA_Distance[2])
         && MA_DIFF[3][0]/Point < -1*StrToInteger(MA_Distance[3])
         && MA_DIFF[4][0]/Point < -1*StrToInteger(MA_Distance[4])
         && MA_DIFF[5][0]/Point < -1*StrToInteger(MA_Distance[5])
         ) {
         
         ALLOW_BUY = false;
         ALLOW_SELL = true;
      }
      else {
         ALLOW_BUY = false;
         ALLOW_SELL = false;
      }
   }
   else if (SYS_均線多空判斷 == 2) {
      if (MA[0][0] > MA[1][0] && MA[1][0] > MA[2][0] && MA[2][0] > MA[3][0] && MA[3][0] > MA[4][0] && MA[4][0] > MA[5][0]) {
         ALLOW_BUY = true;
         ALLOW_SELL = false;
      }
      else if (MA[0][0] < MA[1][0] && MA[1][0] < MA[2][0] && MA[2][0] < MA[3][0] && MA[3][0] < MA[4][0] && MA[4][0] < MA[5][0]) {
         ALLOW_BUY = false;
         ALLOW_SELL = true;
      }
      else {
         ALLOW_BUY = false;
         ALLOW_SELL = false;
      }
   }
   else if (SYS_均線多空判斷 == 3) {
      if (MA[0][0] > MA[1][0] && MA[1][0] > MA[2][0] && MA[3][0] > MA[4][0] && MA[4][0] > MA[5][0]) {
         ALLOW_BUY = true;
         ALLOW_SELL = false;
      }
      else if (MA[0][0] < MA[1][0] && MA[1][0] < MA[2][0] && MA[3][0] < MA[4][0] && MA[4][0] < MA[5][0]) {
         ALLOW_BUY = false;
         ALLOW_SELL = true;
      }
      else {
         ALLOW_BUY = false;
         ALLOW_SELL = false;
      }
   }
   else if (SYS_均線多空判斷 == 5) {
      if (Close[0] > MA[0][0] && Close[1] > MA[0][1] && Close[2] > MA[0][2]) {
         ALLOW_BUY = true;
         ALLOW_SELL = false;
      }
      else if (Close[0] < MA[0][0] && Close[1] < MA[0][1] && Close[2] < MA[0][2]) {
         ALLOW_BUY = false;
         ALLOW_SELL = true;
      }
      else {
         ALLOW_BUY = false;
         ALLOW_SELL = false;
      }
   }
   
   if (SYS_技術指標多空判斷 == 1) {
      if (ALLOW_BUY == true) {
      
         if (MACD_SETTINGS[0] == "1")
            if (
                  MACD_MAIN[0] < MACD_SIGNAL[0] 
                  || MACD_MAIN[1] < MACD_SIGNAL[1]
                  || MACD_MAIN[2] < MACD_SIGNAL[2]
               )
               ALLOW_BUY = false;
         
         if (KD_SETTINGS[0] == "1")
            if (
                  KD_MAIN[0] < KD_SIGNAL[0]
                  || KD_MAIN[1] < KD_SIGNAL[1]
                  || KD_MAIN[2] < KD_SIGNAL[2]
               )
               ALLOW_BUY = false;
         
         if (RSI_SETTINGS[0] == "1")
            if (RSI_VALUE[0] < 50 || RSI_DIFF[0] < 0)
               ALLOW_BUY = false;
               
         if (SYS_使用ACAO多空判斷 == 1) {
            if (
                  AO_DIFF[0] < 0 || AC_DIFF[0] < 0
                  || AO_DIFF[1] < 0 || AC_DIFF[1] < 0
                  || AO_DIFF[2] < 0 || AC_DIFF[2] < 0
               )
               ALLOW_BUY = false;
            
            //if (AO_VALUE[0] < 0 || AO_VALUE[1] < 0)
            //   ALLOW_BUY = false;
         }
      }
            
      if (ALLOW_SELL == true) {
         
         if (MACD_SETTINGS[0] == "1")
            if (
                  MACD_MAIN[0] > MACD_SIGNAL[0] 
                  || MACD_MAIN[1] > MACD_SIGNAL[1]
                  || MACD_MAIN[2] > MACD_SIGNAL[2]
               )
               ALLOW_SELL = false;
         
         if (KD_SETTINGS[0] == "1")
            if (
                  KD_MAIN[0] > KD_SIGNAL[0]
                  || KD_MAIN[1] > KD_SIGNAL[1]
                  || KD_MAIN[2] > KD_SIGNAL[2]
               )
               ALLOW_SELL = false;
         
         if (RSI_SETTINGS[0] == "1")
            if (RSI_VALUE[1] > 50)
               ALLOW_SELL = false;
               
         if (SYS_使用ACAO多空判斷 == 1) {
            if (
                  AO_DIFF[0] > 0 || AC_DIFF[0] > 0
                  || AO_DIFF[1] > 0 || AC_DIFF[1] > 0
                  || AO_DIFF[2] > 0 || AC_DIFF[2] > 0
               )
               ALLOW_SELL = false;
               
            //if (AO_VALUE[0] > 0 || AO_VALUE[1] > 0)
            //   ALLOW_SELL = false;
         }
      }
   }
}

void CheckFirstOrder(double iLots, string EA_NAME) { 
   int Ticket = 0; 
   
   //Print("CheckFirstOrder(" + iLots + ", " + EA_NAME + ")");
   
   if (SELL_張數 == 0 && flgSellClose == false && ALLOW_SELL == true) { 
      Ticket = NewSell(iLots, 5, 0, 0, EA_NAME + "-" + Symbol() + "-S0", -1); 
      CalculateSysSellInfo(); 
   } 

   if (BUY_張數 == 0 && flgBuyClose == false && ALLOW_BUY == true) { 
      Ticket = NewBuy(iLots, 5, 0, 0, EA_NAME + "-" + Symbol() + "-B0", 1); 
      CalculateSysBuyInfo(); 
   }    
} 

void CheckRaiseOrder(double StartLots, double RaiseTimes, int RaisePoint, double RaisePointRatio, int MAX_ORDER, string EA_NAME) {
   int Ticket = 0;
   bool ThisAllowSell = true;
   bool ThisAllowBuy = true;
   
   //Print("CheckRaiseOrder(" + StartLots + ", " + RaiseTimes + ", " + RaisePoint + ", " + RaisePointRatio + ", " + MAX_ORDER + ", " + EA_NAME + ")");
   
   if (SYS_馬丁多空同步 == 0) {
      ThisAllowSell = true;
      ThisAllowBuy = true;
   }
   else {
      if (SYS_馬丁多空 == "偏多")
         ThisAllowBuy = true;
      else
         ThisAllowBuy = false;
         
         
      if (SYS_馬丁多空 == "偏空")
         ThisAllowSell = true;
      else
         ThisAllowSell = false;
   }
   
   if (SELL_張數 > 0 && SELL_張數 <= MAX_ORDER && flgSellClose == false && ThisAllowSell == true) {
      int Diff = (SYS_BUY - SELL_最新進價)/Point;
      int Distance = RaisePoint;
      
      if (SELL_張數 > 1) {
         if (RaisePointRatio > 1)
            Distance = RaisePoint*MathPow(RaisePointRatio, 1.0*(SELL_張數-1));
         else if (RaisePointRatio == 1)
            Distance = RaisePoint*SELL_張數;
      }
      
      if (RaisePoint > 0) {  
         if (Diff >= Distance) {
            Ticket = NewSell(StartLots*MathPow(RaiseTimes, 1.0 * SELL_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-S" + SELL_張數, -1 * (SELL_張數+1));
            //Ticket = NewSell(SELL_第一單手數*MathPow(RaiseTimes, 1.0 * SELL_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-S" + SELL_張數, -1 * (SELL_張數+1));
            CalculateSysSellInfo();
         }
      }
      else if (RaisePoint < 0) {
         if (Diff <= Distance) {
            Ticket = NewSell(StartLots*MathPow(RaiseTimes, 1.0 * SELL_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-S" + SELL_張數, -1 * (SELL_張數+1));
            //Ticket = NewSell(SELL_第一單手數*MathPow(RaiseTimes, 1.0 * SELL_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-S" + SELL_張數, -1 * (SELL_張數+1));
            CalculateSysSellInfo();
         }
      }
      else {
         Ticket = NewSell(StartLots*MathPow(RaiseTimes, 1.0 * SELL_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-S" + SELL_張數, -1 * (SELL_張數+1));
         //Ticket = NewSell(SELL_第一單手數*MathPow(RaiseTimes, 1.0 * SELL_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-S" + SELL_張數, -1 * (SELL_張數+1));
         CalculateSysSellInfo();
      }
   }
   
   if (BUY_張數 > 0 && BUY_張數 <= MAX_ORDER && flgBuyClose == false && ThisAllowBuy == true) {
      int Diff = (BUY_最新進價 - SYS_SELL)/Point;
      int Distance = RaisePoint;
      
      if (BUY_張數 > 1) {
         if (RaisePointRatio > 1)
            Distance = RaisePoint*MathPow(RaisePointRatio, 1.0*(BUY_張數-1));
         else if (RaisePointRatio == 1)
            Distance = RaisePoint*BUY_張數;
         
      }
      
      if (RaisePoint > 0) {
         if (Diff >= Distance) {
            Ticket = NewBuy(StartLots*MathPow(RaiseTimes, 1.0 * BUY_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-B" + BUY_張數, 1 * (BUY_張數+1));
            //Ticket = NewBuy(BUY_第一單手數 *MathPow(RaiseTimes, 1.0 * BUY_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-B" + BUY_張數, 1 * (BUY_張數+1));
            CalculateSysBuyInfo();
         }
      }
      else if (RaisePoint < 0) {
         if (Diff <= Distance) {
            Ticket = NewBuy(StartLots*MathPow(RaiseTimes, 1.0 * BUY_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-B" + BUY_張數, 1 * (BUY_張數+1));
            //Ticket = NewBuy(BUY_第一單手數*MathPow(RaiseTimes, 1.0 * BUY_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-B" + BUY_張數, 1 * (BUY_張數+1));
            CalculateSysBuyInfo();
         }
      }
      else {
         Ticket = NewBuy(StartLots*MathPow(RaiseTimes, 1.0 * BUY_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-B" + BUY_張數, 1 * (BUY_張數+1));
         //Ticket = NewBuy(BUY_第一單手數*MathPow(RaiseTimes, 1.0 * BUY_張數), 5, 0, 0, EA_NAME + "-" + Symbol() + "-B" + BUY_張數, 1 * (BUY_張數+1));
         CalculateSysBuyInfo();
      }
   }
}

void SellClose() {
   for (int i = OrdersTotal()-1; i >= 0 ; i--) { 
      int iTicket = 0;
      bool isClose = false;
      
      OrderSelect(i, SELECT_BY_POS); 

      if (OrderSymbol() != Symbol()) 
         continue;
         
      if (OrderType() != OP_SELL)
         continue;

      if (OrderMagicNumber() == 0) 
         continue;
         
      iTicket = OrderTicket();
      OrderClose(iTicket, OrderLots(), Ask, 5, clrLavender);
   }
}

void BuyClose() {
   for (int i = OrdersTotal()-1; i >= 0 ; i--) {
      int iTicket = 0;
      bool isClose = false;
      
      OrderSelect(i, SELECT_BY_POS); 

      if (OrderSymbol() != Symbol()) 
         continue;
         
      if (OrderType() != OP_BUY)
         continue;

      if (OrderMagicNumber() == 0) 
         continue;
         
      iTicket = OrderTicket();
      OrderClose(iTicket, OrderLots(), Bid, 5, clrLavender);
   }
}

void AllClose() {
   for (int i = 0; i < OrdersTotal(); i++) { 
      int iTicket = 0;
      bool isClose = false;
      
      OrderSelect(i, SELECT_BY_POS); 

      if (OrderSymbol() != Symbol()) 
         continue;

      if (OrderMagicNumber() == 0) 
         continue;
         
      iTicket = OrderTicket();
      
      if (OrderType() == OP_BUY) {
         OrderClose(iTicket, OrderLots(), Bid, 5, clrLavender);
      }
      
      if (OrderType() == OP_SELL) {
         OrderClose(iTicket, OrderLots(), Ask, 5, clrLavender);
      }
   }
}

void CalculatePrice() { 
   SYS_BUY = Ask; 
   SYS_SELL = Bid; 
   SYS_點差 = (int)((SYS_BUY-SYS_SELL)/Point); 
} 

void CalculateProfit() { 
      
      BUY_價差 = (SYS_SELL - BUY_平均成本)/Point;
      SELL_價差 = (SELL_平均成本 - SYS_BUY)/Point;

   if (BUY_張數 == 0)
      BUY_價差 = 0;  
   
   if (SELL_張數 == 0)
      SELL_價差 = 0;
      
   BUY_獲利 = BUY_總手數 * BUY_價差;
   SELL_獲利 = SELL_總手數 * SELL_價差;
   
   TOTAL_獲利 = BUY_獲利 + SELL_獲利;
   
   if (TOTAL_最大浮虧 > TOTAL_獲利)
      TOTAL_最大浮虧 = TOTAL_獲利;
      
   if (SELL_張數 > SELL_MAX_張數)
      SELL_MAX_張數 = SELL_張數;

   if (SELL_總手數 > SELL_MAX_手數)
      SELL_MAX_手數 = SELL_總手數;
      
   if (SELL_獲利 < SELL_MAX_浮虧)
      SELL_MAX_浮虧 = SELL_獲利;

   if (SELL_張數 > 0)
      if ((Ask - SELL_第一單進價)/Point > SELL_MAX_逆勢點數)
         SELL_MAX_逆勢點數 = (Ask - SELL_第一單進價)/Point;
      
   if (BUY_張數 > BUY_MAX_張數)
      BUY_MAX_張數 = BUY_張數;

   if (BUY_總手數 > BUY_MAX_手數)
      BUY_MAX_手數 = BUY_總手數;
      
   if (BUY_獲利 < BUY_MAX_浮虧)
      BUY_MAX_浮虧 = BUY_獲利;

   if (BUY_張數 > 0)
      if ((BUY_第一單進價 - Bid)/Point > BUY_MAX_逆勢點數)
         BUY_MAX_逆勢點數 = (BUY_第一單進價 - Bid)/Point;
      
} 


void CalculateSysBuyInfo() { 
   int count = 0; 
   int FirstTicket = 0;
   double TotalLots = 0.0, TotalCost = 0.0, AvgCost = 0.0, LastLots = 0.0, LastPrice = 0.0, FirstLots = 0.0, FirstPrice = 0.0; 
   datetime LastTime, FirstTime;
   string LIST_單號 = "";
   
   for (int i = 0; i < OrdersTotal(); i++) { 
      
      OrderSelect(i, SELECT_BY_POS); 

      if (OrderSymbol() != Symbol()) 
         continue; 

      if (OrderType() != OP_BUY) 
         continue; 

      if (OrderMagicNumber() == 0) 
         continue; 

      if (count == 0) 
      { 
         FirstTicket = OrderTicket(); 
         FirstLots = OrderLots(); 
         FirstPrice = OrderOpenPrice(); 
         FirstTime = OrderOpenTime(); 
      }

      LastLots = OrderLots(); 
      LastPrice = OrderOpenPrice(); 
      LastTime = OrderOpenTime(); 
      TotalLots += OrderLots(); 
      TotalCost += (OrderLots() * OrderOpenPrice()); 
      
      if (LIST_單號 == "") {
         LIST_單號 = "" + OrderTicket();
      }
      else {
         LIST_單號 += "," + OrderTicket();
      }

      count++; 
   } 

   if (count == 0) { 
      BUY_最新手數 = 0; 
      BUY_最新進價 = 0; 
      BUY_平均成本 = 0; 
      BUY_總手數 = 0; 
      BUY_張數 = 0; 
      BUY_第一單手數 = 0; 
      BUY_第一單進價 = 0; 
      BUY_獲利 = 0;  
      BUY_價差 = 0; 
      return; 
   } 

   AvgCost = TotalCost / TotalLots; 
   BUY_最新手數 = LastLots; 
   BUY_最新進價 = LastPrice;
   BUY_平均成本 = AvgCost; 
   BUY_總手數 = TotalLots; 
   BUY_張數 = count; 
   BUY_第一單手數 = FirstLots; 
   BUY_第一單進價 = FirstPrice;
   BUY_價差 = (SYS_SELL - BUY_平均成本) / Point; 
   BUY_獲利 = BUY_總手數 * BUY_價差;
} 

void CalculateSysSellInfo() { 
   int count = 0; 
   int FirstTicket = 0;
   double TotalLots = 0.0, TotalCost = 0.0, AvgCost = 0.0, LastLots = 0.0, LastPrice = 0.0, FirstLots = 0.0, FirstPrice = 0.0; 
   datetime LastTime, FirstTime;
   string LIST_單號 = "";

   for (int i = 0; i < OrdersTotal(); i++) { 
      
      OrderSelect(i, SELECT_BY_POS); 

      if (OrderSymbol() != Symbol()) 
         continue; 

      if (OrderType() != OP_SELL) 
         continue; 

      if (OrderMagicNumber() == 0) 
         continue; 

      if (count == 0) 
      { 
         FirstTicket = OrderTicket(); 
         FirstLots = OrderLots(); 
         FirstPrice = OrderOpenPrice(); 
         FirstTime = OrderOpenTime(); 
      }

      LastLots = OrderLots(); 
      LastPrice = OrderOpenPrice(); 
      LastTime = OrderOpenTime(); 
      TotalLots += OrderLots(); 
      TotalCost += (OrderLots() * OrderOpenPrice());
      
      if (LIST_單號 == "") {
         LIST_單號 = "" + OrderTicket();
      }
      else {
         LIST_單號 += "," + OrderTicket();
      }

      count++; 
   } 

   if (count == 0) { 
      SELL_最新手數 = 0; 
      SELL_最新進價 = 0; 
      SELL_平均成本 = 0; 
      SELL_總手數 = 0; 
      SELL_張數 = 0; 
      SELL_第一單手數 = 0; 
      SELL_第一單進價 = 0; 
      SELL_獲利 = 0;  
      SELL_價差 = 0; 
      return; 
   } 

   AvgCost = TotalCost / TotalLots; 
   SELL_最新手數 = LastLots; 
   SELL_最新進價 = LastPrice;
   SELL_平均成本 = AvgCost; 
   SELL_總手數 = TotalLots; 
   SELL_張數 = count; 
   SELL_第一單手數 = FirstLots; 
   SELL_第一單進價 = FirstPrice;
   SELL_價差 = (SELL_平均成本 - SYS_BUY)/Point;
   SELL_獲利 = SELL_總手數 * SELL_價差; 
}

void iSetLabel(string name, string text, int x, int y,int size, string style, color TextColor) { 
   ObjectCreate(name, OBJ_LABEL, 0, 0, 0); 
   ObjectSetText(name, text, size, style, TextColor); 
   ObjectSet(name, OBJPROP_XDISTANCE, x); 
   ObjectSet(name, OBJPROP_YDISTANCE, y); 
}

void ShowSystemText(int P_X, int P_Y, int height, int FontSize, string FontStyle, color FontColor, string LabeName, string &TextList[]) {
   int iMax = 0;
   iMax = ArraySize(TextList);
   
   for (int i = 0; i < iMax; i++) {
      iSetLabel(LabeName + "-" + i, TextList[i], P_X, P_Y+(height*i), FontSize, FontStyle, FontColor);
   }
}

void func_上下引線砍單(string ThisPeriod)
{
}
