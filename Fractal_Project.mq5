#include  <Trade\Trade.mqh>

CTrade trade;

input int Take_Profit = 100;
input int Stop_Loss = 20;
input double Lot_Volume = 0.1;
const string symbol = _Symbol;

//creating the upper and lower array as a global variable
//for it to be accessed both on the oninit and ontick function
double Upper_Fractal[];
double Lower_Fractal[];

//creating the OnInit function
int OnInit()
{
  return(INIT_SUCCEEDED);
}

//creating the bid and ask price using the SymboInfoDouble function
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
    //creating the take profit and stop loss of the bid and ask price respectively
    //for buy signal
    double TakeProfit = NormalizeDouble((AskPrice() + Take_Profit * _Point),_Digits);
    double StopLoss = NormalizeDouble((AskPrice() - Stop_Loss * _Point),_Digits);
    
    //for sell signal
    double TakeProfit2 = NormalizeDouble((BidPrice() - Take_Profit * _Point),_Digits);
    double StopLoss2 = NormalizeDouble((BidPrice() + Stop_Loss * _Point),_Digits); 
    
   //Sorting data
   ArraySetAsSeries(Upper_Fractal,true);
   ArraySetAsSeries(Lower_Fractal,true);
   
   //define fractal by adding the fractal inbult variable
   int Fractal = iFractals(_Symbol,_Period);
   
   //define data and store result
   CopyBuffer(Fractal,UPPER_LINE,0,4,Upper_Fractal);
   CopyBuffer(Fractal,LOWER_LINE,0,4,Lower_Fractal);
   
   //define values of the fractal or covert the signal and array into values
   double Fractal_Up_Value = NormalizeDouble(Upper_Fractal[0],5);
   double Fractal_Down_Value = NormalizeDouble(Lower_Fractal[0],5);
   
   //returning zero in case of empty values
   if(Fractal_Up_Value == EMPTY_VALUE)
      Fractal_Up_Value = 0;
   if(Fractal_Down_Value == EMPTY_VALUE)
      Fractal_Down_Value = 0;
      
   //conditions of the strategy and comment on the chart with highs and lows
   //in case of high
   if(Fractal_Up_Value>0)
     {
      Comment("Fractals High around: ",Fractal_Up_Value);
      trade.Sell(Lot_Volume,symbol,BidPrice(),StopLoss2,TakeProfit2,"Sell");
     }
   //in case of low
   if(Fractal_Down_Value>0)
     {
      Comment("Fractals Low around: ",Fractal_Down_Value);
      trade.Buy(Lot_Volume,symbol,AskPrice(),StopLoss,TakeProfit,"Buy");
     }
  }