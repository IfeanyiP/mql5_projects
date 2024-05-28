//+------------------------------------------------------------------+
//|                                       Custom_Keltner_Channel.mq5 |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
CTrade trade;
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots 3
#property indicator_type1 DRAW_LINE
#property indicator_style1 STYLE_SOLID
#property indicator_width1 2
#property indicator_color1 clrRed
#property indicator_label1 "Keltner Upper Band"
#property indicator_type2 DRAW_LINE
#property indicator_style2 STYLE_SOLID
#property indicator_width2 1
#property indicator_color2 clrBlue
#property indicator_label2 "Keltner Middle Line"
#property indicator_type3 DRAW_LINE
#property indicator_style3 STYLE_SOLID
#property indicator_width3 2
#property indicator_color3 clrGreen
#property indicator_label3 "Keltner Lower Band"
//+------------------------------------------------------------------------
input double lotSize = 0.01;
input int slPips = 150;
input int tpPips = 300;
input int      maPeriod            = 10;           // Moving Average Period
input double   multiInp             = 2.0;          // Channel multiplier
input bool     isAtr                 = false;        // ATR
input ENUM_MA_METHOD     maMode       = MODE_EMA;     // Moving Average Mode
input ENUM_APPLIED_PRICE priceType = PRICE_TYPICAL;// Price Type
//+---------------------------------------------------------------------------+
int keltner;
int barsTotal;
string symbol = _Symbol;
double upper[], middle[], lower[];
int maHandle, atrHandle;
static int minBars = maPeriod + 1;
//+------------------------------------------------------------------+
int OnInit()
  {
   barsTotal = iBars(symbol,PERIOD_CURRENT);
   keltner = iCustom(symbol,PERIOD_CURRENT,"Custom_Keltner_Channel",maPeriod,multiInp,isAtr,maMode,priceType);
   //+----------------------------------------------------------------------------------------------------
   SetIndexBuffer(0,upper, INDICATOR_DATA);
   SetIndexBuffer(1,middle, INDICATOR_DATA);
   SetIndexBuffer(2,lower, INDICATOR_DATA);
   ArraySetAsSeries(upper, true);
   ArraySetAsSeries(middle, true);
   ArraySetAsSeries(lower, true);
   IndicatorSetString(INDICATOR_SHORTNAME,"Custom_Keltner_Channel " + IntegerToString(maPeriod));
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   maHandle = iMA(NULL, 0, maPeriod, 0, maMode, priceType);
   if(isAtr)
     {
      atrHandle = iATR(NULL, 0, maPeriod);
      if(atrHandle == INVALID_HANDLE)
        {
         Print("Handle Error");
         return(INIT_FAILED);
        }
     }
   else
      atrHandle = INVALID_HANDLE;
   return INIT_SUCCEEDED;
  }
void indValue(const double& h[], const double& l[], int shift)
  {
   double ma[1];
   if(CopyBuffer(maHandle, 0, shift, 1, ma) <= 0)
      return;
   middle[shift] = ma[0];
   double average = AVG(h, l, shift);
   upper[shift]    = middle[shift] + average * multiInp;
   lower[shift] = middle[shift] - average * multiInp;
  }
double AVG(const double& High[],const double& Low[], int shift)
  {
   double sum = 0.0;
   if(atrHandle == INVALID_HANDLE)
     {
      for(int i = shift; i < shift + maPeriod; i++)
         sum += High[i] - Low[i];
     }
   else
     {
      double t[];
      ArrayResize(t, maPeriod);
      ArrayInitialize(t, 0);
      if(CopyBuffer(atrHandle, 0, shift, maPeriod, t) <= 0)
         return sum;
      for(int i = 0; i < maPeriod; i++)
         sum += t[i];
     }
   return sum / maPeriod;
  }
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   if(rates_total <= minBars)
      return 0;
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low,  true);
   int limit = rates_total - prev_calculated;
   if(limit == 0)             
     {
     }
   else
      if(limit == 1)      
        {
         indValue(high, low, 1);
         return(rates_total);
        }
      else
         if(limit > 1)       
           {
            ArrayInitialize(middle, EMPTY_VALUE);
            ArrayInitialize(upper,    EMPTY_VALUE);
            ArrayInitialize(lower, EMPTY_VALUE);
            limit = rates_total - minBars;
            for(int i = limit; i >= 1 && !IsStopped(); i--)
               indValue(high, low, i);
            return(rates_total);
           }
   indValue(high, low, 0);
   return(rates_total);
  }
//+-------------------------------------------------------------------------------------------------+
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
      if(prevLastClose<prevUpperValue && lastClose>upperValue)
        {
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double slVal = upperValue - slPips*_Point;
         double tpVal = upperValue + tpPips*_Point;
         trade.Buy(lotSize,_Symbol,ask,slVal,tpVal);
        }
      if(prevLastClose>prevLowerValue && lastClose<lowerValue)
        {
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double slVal = lowerValue + slPips*_Point;
         double tpVal = lowerValue - tpPips*_Point;
         trade.Sell(lotSize,_Symbol,bid,upperValue,tpVal);
        }
     }
  }
