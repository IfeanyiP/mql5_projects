#include <Trade\Trade.mqh>

CTrade trade;
#property indicator_separate_window
#property indicator_maximum 100
#property indicator_minimum -100
#property indicator_buffers 2
#property indicator_plots   2
//for cci indicator
#property indicator_label1  "CCI"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//for ma indicator
#property indicator_label2  "MA"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2

input int Cci_Period = 14; // CCI period
input int Ma_Period = 50; // Moving average period
input int Ma_Shift = 0; // Moving average shift
input ENUM_MA_METHOD Ma_Method = MODE_SMA; // Moving average method
input int Buy_Level = -100; // CCI buy level
input int Sell_Level = 100; // CCI sell level
input int Take_Profit = 100; //take profit level
input int Stop_Loss = 40; //stop loss level
input double Lot_Volume = 1.0;
const string symbol = _Symbol;
int TotalPosition = 1;
int Period_Max;

//indicators buffer
double Ma_buffer[];
double Cci_buffer[];
   
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   //interating through the candle to create the number of candles to consider, while calling Cci_buffer
   //for the cci indicator
   ArraySetAsSeries(Cci_buffer,true);
   ArrayResize(Cci_buffer,Bars(symbol,PERIOD_CURRENT,TimeCurrent(),TimeCurrent()) - 10,0);
   
   //using the for loop, to get the actual number of 10 candles
   for(int i = 0; i < Bars(symbol,PERIOD_CURRENT,TimeCurrent(),TimeCurrent()) - 10; i++)
   {
     Cci_buffer[i] = iCCI(symbol,PERIOD_CURRENT,Cci_Period,PRICE_CLOSE);
   }
   
   //setting up the indicators color, size, and its respective parameter
   //using a for loop
   for(int i = 0; i < Bars(symbol,PERIOD_CURRENT,TimeCurrent(),TimeCurrent()) - 10; i++)
   {
     //using the object function to draw the required object(arrows) for the cci indicator
     ObjectCreate(0,"Cci_Indicator",OBJ_ARROW,0,TimeCurrent(),Cci_buffer[i]);
     ObjectGetInteger(0,"Cci_indicator",OBJPROP_COLOR,0);
   }
   
   //for the moving average indidator
   ArraySetAsSeries(Ma_buffer,true);
   ArrayResize(Ma_buffer,Bars(symbol,PERIOD_CURRENT,TimeCurrent(),TimeCurrent()) - 30,0);
   
   //using the for loop to ge the actual number of bars to consider
   for(int i = 0; i < Bars(symbol,PERIOD_CURRENT,TimeCurrent(),TimeCurrent()) - 30; i++);
   {
     Ma_buffer[i] = iMA(symbol,PERIOD_CURRENT,Ma_Period,Ma_Shift,MODE_SMA,PRICE_CLOSE);
   }
   
   //setting the indicators line, boundaries and inputting the neccessary parameters on it
   for(int i = 0; i < Bars(symbol,PERIOD_CURRENT,TimeCurrent(),TimeCurrent()) - 30; i++);
   {
     //using the objectcreate and objectGetInteger to draw the trends,line with its color
     ObjectCreate(0,"Ma_Indicator",OBJ_TREND,0,TimeCurrent(),Ma_buffer[i]);
     ObjectGetInteger(0,"Ma_Indicator",OBJPROP_COLOR,0);
   }
           
   // Set up indicator buffers
   SetIndexBuffer(0, Cci_buffer,INDICATOR_DATA);
   SetIndexBuffer(1, Ma_buffer,INDICATOR_DATA);
   
   //setting indicators parameters
   IndicatorSetString(INDICATOR_SHORTNAME,"Cci_Ma");
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   
   //the maximum number of periods in both the indicators
   Period_Max = fmax(Cci_Period,Ma_Period);

   // Return initialization result
 
   return (INIT_SUCCEEDED);
}
//creating the ask and bid price function
double AskPrice()
{
  return(SymbolInfoDouble(symbol,SYMBOL_ASK));
}

//bid price function
double BidPrice()
{
  return(SymbolInfoDouble(symbol,SYMBOL_BID));
}
    
void OnTick()
{
   
   //declaring the takeprofit and stoploss variable
   //for buy signal
   double StopLoss = NormalizeDouble((AskPrice() - Stop_Loss * _Point), _Digits);
   double TakeProfit = NormalizeDouble((AskPrice() + Take_Profit * _Point), _Digits);
   
   //for sell signal
   double StopLoss2 = NormalizeDouble((BidPrice() + Stop_Loss * _Point), _Digits);
   double TakeProfit2 = NormalizeDouble((BidPrice() - Take_Profit * _Point), _Digits);
  
   int Ma_Indicator = iMA(symbol,PERIOD_CURRENT,Ma_Period,Ma_Shift,Ma_Method,PRICE_CLOSE);
   int Cci_Indicator = iCCI(symbol,PERIOD_CURRENT,Cci_Period,PRICE_CLOSE);
   
   ArraySetAsSeries(Ma_buffer,true);
   ArraySetAsSeries(Cci_buffer,true);
   
   CopyBuffer(0,0,0,3,Cci_buffer);
   CopyBuffer(1,0,0,3,Ma_buffer);
   
   if(Ma_buffer[0] > Cci_buffer[0] && Cci_buffer[1] > Sell_Level && PositionsTotal() < TotalPosition)
   {
     trade.Sell(Lot_Volume,symbol,BidPrice(),StopLoss2,TakeProfit2,"SellNow");
   }
   else if(Ma_buffer[0] < Cci_buffer[0] && Cci_buffer[1] < Buy_Level && PositionsTotal() < TotalPosition)
   {
     trade.Buy(Lot_Volume,symbol,AskPrice(),StopLoss,TakeProfit,"Buy Now");
   }
 }

