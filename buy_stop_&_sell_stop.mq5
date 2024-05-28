#include <Trade\Trade.mqh>
CTrade trade;

//providing the necessary input to be used in the programme
input double Lots_Volume1 = 0.01;
input double Lots_Volume2 = 0.04;
input double Lots_Volume3 = 0.1;
input int Order_distance = 5;
input int take_profit = 100;

//generating other variables to be used on the programme
double Buy_Stop,Sell_Stop;
const string symbol = Symbol();
double Buy_Stop_Price,Sell_Stop_Price;

//creating a function for calculating pips
double PointValue()
{
  return(SymbolInfoDouble(symbol,SYMBOL_POINT));
}
//creating function for calculating Ask price
double AskPrice()
{
  return(SymbolInfoDouble(symbol,SYMBOL_ASK));
}
double BidPrice()
{
  return(SymbolInfoDouble(symbol,SYMBOL_BID));
}

void OnTick()
  {
    
    //creating the Buy stop piece to be used in the program
    Buy_Stop = NormalizeDouble(iClose(symbol,PERIOD_CURRENT,1),_Digits);
    
    //creating the stoploss and takeprofit of the programme to be used
    double TakeProfit = NormalizeDouble((AskPrice() + take_profit * _Point),_Digits);
    
    //initializing the function for placing the buystop order
    Buy_Stop_Price = Buy_Stop + (Order_distance * PointValue());
    
    //creating the sell stop price to be used
    Sell_Stop = NormalizeDouble(iClose(symbol,PERIOD_CURRENT,1),_Digits);
    
    //creating the takeprofit for sell stop 1
    double Take_Profit1 = NormalizeDouble((BidPrice() - take_profit * _Point),_Digits);
    
    //initializing the function fornplacing sell stop order
    Sell_Stop_Price = Sell_Stop - (Order_distance * PointValue());
    
    //placing the sell stop order simultaneously
    if(PositionsTotal() == 0 && OrdersTotal() == 0)
    {
      
      int Buy = trade.BuyStop(Lots_Volume1,Buy_Stop_Price,symbol,0,TakeProfit,ORDER_TIME_DAY,0,"BuyStop1");
      int Sell = trade.SellStop(Lots_Volume2,Sell_Stop_Price,symbol,0,Take_Profit1,ORDER_TIME_DAY,0,"Sell Stop");
      
      if(Sell < 0)
      {
        Print("Error placing sellstop:", GetLastError());
      }
      if(Buy < 0)
      {
       Print("Error placing buy trade: ", GetLastError());
      }
    }
    
  }    