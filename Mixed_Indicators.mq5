#include <trade\trade.mqh>

CTrade trade;

//input variables to be used on the program
input double lots = 0.01;
input int StopLoss = 50;
input int TakeProfit = 100;
//input double Moving_Average_Slow;
//input int Moving_Average_Fast = 0;
input int Low_Average_Period = 100;
input int High_Average_Period = 20;
input int Ma_Shift = 0;
input int Ma_Period = 10;
input ENUM_APPLIED_PRICE Applied_Price = PRICE_CLOSE;
input ENUM_MA_METHOD Ma_Method = MODE_EMA;

//other predefined variables to be used
int Bar_Total;
int keltner;
const string symbol = _Symbol; 
double Current_High;
double Current_Low;

int OnInit()
  {
   Bar_Total = iBars(symbol,PERIOD_CURRENT);
   //moving average indicators in the initialization function
   double Moving_Average_High = iMA(symbol,PERIOD_CURRENT,High_Average_Period,Ma_Shift,Ma_Method,Applied_Price);//fast moving average
   double Moving_Average_Low = iMA(symbol,PERIOD_CURRENT,Low_Average_Period,Ma_Shift,Ma_Method,Applied_Price);//slowmoving average
   
   //for keltner channel
   //keltner = iCustom(symbol,PERIOD_CURRENT,"::Indicators\\Custom_Keltner_Channel");
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
       //for the moving average indicator
       MqlRates PriceInfo[];
       ArraySetAsSeries(PriceInfo,true);
       int data = CopyRates(symbol,PERIOD_CURRENT,0,3,PriceInfo);
       Current_High = PriceInfo[0].high;
       Current_Low = PriceInfo[0].low;
       //creating the stoploss and takeprofit regions to be considered for placing new orders
       double TP = NormalizeDouble((Ask() + TakeProfit * _Point),_Digits);
       double SL = NormalizeDouble((Ask() - StopLoss * _Point),_Digits);
       double SL2 = NormalizeDouble((Bid() + StopLoss * _Point),_Digits);
       double TP2 = NormalizeDouble((Bid() - TakeProfit * _Point),_Digits);
   
       if(Moving_Average() == "Buy" && PositionsTotal() == 0)
       {
         if(keltner_Channel() == "Buy" && PositionsTotal() == 0)
         {
           trade.Buy(lots,symbol,Ask(),SL,TP,"Buy now");
         }
       }
       if(Moving_Average() == "Sell" && PositionsTotal() == 0)
       {
         trade.Sell(lots,symbol,Bid(),SL2,TP2,"Sell Now");
       }
    }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//adding the Ask() and Bid()
double Ask()
{
  return(SymbolInfoDouble(symbol,SYMBOL_ASK));
}

double Bid()
{
  return(SymbolInfoDouble(symbol,SYMBOL_BID));
}

//+---------------------------------------------------------------------------------------
//for moving average
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
//+---------------------------------------------------------------------------------------------------
//For keltner channel
double keltner_Channel()
{
      string keltner_Signal = "";
      double upper[], middle[], lower[];
      keltner = iCustom(symbol,PERIOD_CURRENT,"::Indicator\\Custom_Keltner_Channel");
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
      double prevLastClose = iClose(_Symbol,PERIOD_CURRENT,2);
      if(prevLastClose  < prevUpperValue && lastClose > upperValue)
      {
        keltner_Signal = "Buy";
      }
      if(prevLastClose > prevLowerValue && lastClose < lowerValue)
      {
        keltner_Signal = "Sell";
      }
    return(keltner_Signal);
}