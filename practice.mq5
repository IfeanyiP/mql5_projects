#include <Trade\Trade.mqh>
CTrade trade;

//presenting the necessary variables to be used in the program
input int period = 100;
input int shift = 0;
input int StopLoss = 20;
input int TakeProfit = 80;
input double Lot_Volume = 1.0;
const string symbol = _Symbol;
double open;
string signal ="";
void OnTick()
 {
  MqlRates PriceInfo[];
  int copyrate = CopyRates(symbol,PERIOD_CURRENT,0,3,PriceInfo);
  ArraySetAsSeries(PriceInfo,true);
  
  
  double Moving_Average_Array[];
  
  //creating a moving average indicator to foster the expert advisor's accuracy
  int Moving_Average = iMA(symbol,PERIOD_CURRENT,period,shift,MODE_SMA,PRICE_CLOSE);
  
  ArraySetAsSeries(Moving_Average_Array,true);
  
  CopyBuffer(Moving_Average,0,0,5,Moving_Average_Array);
  
  //creating the ask price to be used for the project
  double Ask = SymbolInfoDouble(symbol,SYMBOL_ASK);
  
  //creating the take profit and stoploss for the expert advisor, for buy order
  double StopLoss_Value = NormalizeDouble((Ask - StopLoss * _Point),_Digits);
  double TakeProfit_Value = NormalizeDouble((Ask + TakeProfit * _Point),_Digits);
  
  if(PriceInfo[0].low > Moving_Average_Array[4] && PositionsTotal() == 0)
  {
     signal = "Buy";
     if(signal == "Buy" && PositionsTotal() == 0)
     {
       //Place a buy trade
       trade.Buy(Lot_Volume,symbol,Ask,StopLoss_Value,TakeProfit_Value,"Buy Now");
       //Stop_New_Order();
       signal = "Buy2";
       for(int i = OrdersTotal() + 1;i > 0; i++)
       {  
         if(signal == "Buy2" && PositionsTotal() > 0 && PositionGetInteger(POSITION_TYPE) == (POSITION_SL))
         {
           if(PriceInfo[3].high > Moving_Average_Array[2])
           {
             trade.Buy(Lot_Volume,symbol,Ask,StopLoss_Value,TakeProfit_Value,"Buy Now");
           }
       }
     }
  }
  
 } 
}
 
//+--------------------------------------------------------------------------------------+
//+ ADDING THE STOP NEW TRADES WHEN STOP LOSS IS HIT, AND WAIT FOR 3 CANDLES MORE TO FORM
//-------------------------------Stop_New_Order()----------------------------------------+
void Stop_New_Order()
{
  for(ulong a = OrdersTotal() - 1; a >= 0; a--)
  {
    ulong OrderTicket = OrderGetTicket(a);
    if(OrderGetInteger(ORDER_TYPE) == (POSITION_SL))
    {
      trade.OrderDelete(OrderTicket);
    }
  }
}
 
