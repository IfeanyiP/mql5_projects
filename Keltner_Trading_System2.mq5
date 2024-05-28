//+------------------------------------------------------------------+
//|                                      Keltner_Trading_System2.mq5 |
//+------------------------------------------------------------------+
#include <trade/trade.mqh>
input int      maPeriod            = 10;           // Moving Average Period
input double   multiInp             = 2.0;          // Channel multiplier
input bool     isAtr                 = false;        // ATR
input ENUM_MA_METHOD     maMode       = MODE_EMA;     // Moving Average Mode
input ENUM_APPLIED_PRICE priceType = PRICE_TYPICAL;// Price Type
input double      lotSize=1;
input double slPips = 50;
input double tpPips = 100; 
input int Low_Average_Period = 100;
input int High_Average_Period = 20;
input int Ma_Shift = 0;
input int Ma_Period = 10;
input ENUM_APPLIED_PRICE Applied_Price = PRICE_CLOSE;
input ENUM_MA_METHOD Ma_Method = MODE_EMA;
const string symbol = _Symbol; 
double Current_High;
double Current_Low;
int keltner;
int barsTotal;
CTrade trade;
int OnInit()
  {
   barsTotal=iBars(_Symbol,PERIOD_CURRENT);
   keltner = iCustom(_Symbol,PERIOD_CURRENT,"Custom_Keltner_Channel",maPeriod,multiInp, isAtr, maMode, priceType);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print("EA is removed");
  }
//+------------------------------------------------------------------+
void OnTick()
  {
   int bars=iBars(_Symbol,PERIOD_CURRENT);
   if(barsTotal < bars)
     {
      barsTotal=bars;
      double upper[], middle[], lower[];
      CopyBuffer(keltner,0,0,3,upper);
      CopyBuffer(keltner,1,0,3,middle);
      CopyBuffer(keltner,2,0,3,lower);
      ArraySetAsSeries(upper,true);
      ArraySetAsSeries(middle,true);
      ArraySetAsSeries(lower,true);
      double prevUpperValue = NormalizeDouble(upper[2], 5);
      double prevMiddleValue = NormalizeDouble(middle[2], 5);
      double prevLowerValue = NormalizeDouble(lower[2], 5);
      double upperValue = NormalizeDouble(upper[1], 5);
      double middleValue = NormalizeDouble(middle[1], 5);
      double lowerValue = NormalizeDouble(lower[1], 5);
      double lastClose=iClose(_Symbol,PERIOD_CURRENT,1);
      double prevLastClose=iClose(_Symbol,PERIOD_CURRENT,2);
      if(prevLastClose<prevUpperValue && lastClose>upperValue && Moving_Average() == "Buy")
        {
         Comment("Moving Average + Keltner channel Buy");
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double slVal = upperValue - slPips*_Point;
         double tpVal = upperValue + tpPips*_Point;
         trade.Buy(lotSize,_Symbol,ask,slVal,tpVal,"Buy Now");
        }
      if(prevLastClose>prevLowerValue && lastClose<lowerValue && Moving_Average() == "Sell")
        {
         Comment("Moving Average + Keltner channel Sell");
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double slVal = lowerValue + slPips*_Point;
         double tpVal = lowerValue - tpPips*_Point;
         trade.Sell(lotSize,_Symbol,bid,upperValue,tpVal,"Sell Now");
        }
     }
  }
//+------------------------------------------------------------------+

string Moving_Average()
{
  string signal_Ma = "";
  double Ma_Low[], Ma_High[];
   
  ArraySetAsSeries(Ma_High,true);//array for moving average high
  ArraySetAsSeries(Ma_Low,true);//array for moving average low
   
  double Moving_Average_High = iMA(symbol,PERIOD_CURRENT,High_Average_Period,Ma_Shift,Ma_Method,Applied_Price);//fast moving average
  double Moving_Average_Low = iMA(symbol,PERIOD_CURRENT,Low_Average_Period,Ma_Shift,Ma_Method,Applied_Price);//slowmoving average
  
  CopyBuffer(Moving_Average_High,0,0,3,Ma_High);//copying the moving average high to its buffer
  CopyBuffer(Moving_Average_Low,0,0,3,Ma_Low);//copy the moving average low to its buffer
   
  double Average_High = Ma_High[0];
  double Average_Low = Ma_Low[0];
  if(Average_High > Average_Low && Average_High >= Current_High && PositionsTotal() == 0)
  {
    signal_Ma = "Buy";
  }
  else if(Average_Low > Average_High && Average_Low >= Current_Low && PositionsTotal() == 0)
  {
    signal_Ma = "Sell";
  }
  return(signal_Ma);
}