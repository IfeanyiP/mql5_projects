//create instance of CTrade
#include <Trade\Trade.mqh>
CTrade trade;

//incluing the necessary input variabes foe the programme
input int CandleScale = 10000;
input int StopLoss = 50;
input int TakeProfit = 150;
input double Lots_Volume = 0.5;
//idewntifying the various values to use for the programme
double wick,tail,body,range;
double open,close,high,low;

//getting the necessary variables ready
double Ask, Bid,stoploss1,takeprofit1;
string symbol = Symbol();

//passing and executing trade based on every thick made available
void OnTick()
  {
    open = (CandleScale * iOpen(symbol,PERIOD_CURRENT,1));
    close = (CandleScale * iClose(symbol,PERIOD_CURRENT,1));
    high = (CandleScale * iHigh(symbol,PERIOD_CURRENT,1));
    low = (CandleScale * iLow(symbol,PERIOD_CURRENT,1)); 
    //calculating the wick,tail,body and range, using the calculations in the specifications given
    wick = high - MathMax(open,close);
    body = close - open;
    tail = MathMin(open,close) - low;
   range = high - low;
    
    //get the askprice of the data
    Ask = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK),_Digits);
    Bid = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),_Digits);
    
    //adding the takeprofit and stoploss values
    stoploss1 = NormalizeDouble((Ask - StopLoss * _Point),_Digits);
    takeprofit1 = NormalizeDouble((Ask + TakeProfit * _Point),_Digits);
    
    //checking the working condition of the above parameters to acertain its scaliability
    if(wick>body)
    {
      //check if we already have an open order
      if(PositionsTotal()==0)
      {
        //then place a buy trade
        trade.Buy(Lots_Volume,symbol,Ask,stoploss1,takeprofit1,"buy_now");
      }
    }
  }

