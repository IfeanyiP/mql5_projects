//+------------------------------------------------------------------+
//|                                              Bollinger_Bands.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

CTrade trade;
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_maximum 100
#property indicator_minimum -100
//for the upper band level
#property indicator_label1 "upper_Band"
#property indicator_color1 clrAliceBlue
#property indicator_width1 1
#property indicator_type1 DRAW_LINE
//for the middle band level
#property indicator_label2 "Middle_Band"
#property indicator_color2 clrAzure
#property indicator_width2 2
#property indicator_type2 DRAW_LINE
//for the lower band level
#property indicator_label3 "Lower_Band"
#property indicator_color3 clrBlue
#property indicator_width3 1
#property indicator_type3 DRAW_LINE

input double Deviation = 2.0;
input int Ma_Period = 20;
input int Ma_Shift = 0;
input ENUM_APPLIED_PRICE Applied_Price = PRICE_CLOSE;
input int StopLoss = 20;
input int TakeProfit = 50;
input double Lot_Volume = 0.5;
const string symbol = _Symbol;

//+------------------------------------------------------------------+
// create a function for bid and ask price to be used in the EA
//+------------------------------------------------------------------+
//for Ask
double Ask()
{
  return(SymbolInfoDouble(symbol,SYMBOL_ASK));
}
//for Bid
double Bid()
{
  return(SymbolInfoDouble(symbol,SYMBOL_BID));
}

//+------------------------------------------------------------------+
//+---------------------stoploss and takeprofit variable-------------+
//+------------------------------------------------------------------+
double Stop_Loss = NormalizeDouble((Ask() - StopLoss * _Point),_Digits);
double Take_Profit = NormalizeDouble((Ask() + TakeProfit * _Point),_Digits);
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+ 
int OnInit()
  {
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    //creating the arrays to be used in getting the price and number of candles within the bollinger bands
    double Upper_Band[];
    double Middle_Band[];
    double Lower_Band[];
    
    //Using array set as series in elaborating it
    ArraySetAsSeries(Upper_Band,true);
    ArraySetAsSeries(Middle_Band,true);
    ArraySetAsSeries(Lower_Band,true);
    
    //calling the bollinger inbuilt function and assigning its values and variable
    int Bollinger_Bands = iBands(symbol,PERIOD_CURRENT,Ma_Period,Ma_Shift,Deviation,Applied_Price);
    
    //creating the buffer of the above array of candles created
    CopyBuffer(Bollinger_Bands,0,0,3,Upper_Band);
    CopyBuffer(Bollinger_Bands,0,0,3,Middle_Band);
    CopyBuffer(Bollinger_Bands,0,0,3,Lower_Band);
    
    //changing the array values to an integer value for easy identification
    double Upper_Band_Value = Upper_Band[0];
    double Middle_Band_Value = Middle_Band[0];
    double Lower_Band_Value = Lower_Band[0];
    
    //using the if statement to determine when to buy or sell
    if(iClose(symbol,PERIOD_CURRENT,0) > Upper_Band_Value)
    {
      trade.Buy(Lot_Volume,symbol,Ask(),Stop_Loss,Take_Profit,"Buy");
    }
} 
      /**if(Ask() >= Upper_Band[0] && PositionsTotal() == 1)
      {
        Pendelete();
        Comment("Trigger Stop Loss");
      }
    }
  }
//+------------------------------------------------------------------+

//+------------PENDELETE-----------------------------------+
void Pendelete()
{
  for(int i = OrdersTotal() == 1; i >= 0; i--)
  {
    ulong TotalPosition = OrderGetTicket(i);
    if(OrderGetInteger(ORDER_TYPE) == (ORDER_SL))
    {
      trade.OrderDelete(TotalPosition);
    }
  }
}
**/
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
/**int Price_Current()
{
  For(int a = OrdersTotal() <= 1; a >= 0; a--)
  {
    if(OrderGetInteger(ORDER_TYPE) == (ORDER_PRICE_CURRENT) && OrderGetInteger(ORDER_TYPE) == (ORDER_TYPE_BUY))
    {
      return(Price_Current());
    }
  }
}**/