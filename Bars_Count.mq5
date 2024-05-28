//+------------------------------------------------------------------+
//|                                                   Bars_Count.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

//+---------------------------------------------------------------------------------------------------------------+
//+-----including the input vairables used for the code. This program is basically for counting the---------------+
//+-----number of current candle bars formed, knowing fully well, the oninit function is been called first--------+
//----------------------------------------------------------------------------------------------------------------+
const string symbol = _Symbol;

int OnInit()
  {
    int Bars_OnInit = iBars(symbol,PERIOD_CURRENT);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    int Bars_OnTick = iBars(symbol,PERIOD_CURRENT);
    if(Bars_OnTick > iBars(symbol,PERIOD_CURRENT));
    {
      Comment("A new bar candle");
      Print("New bar detected");
    }
   
  }
//+------------------------------------------------------------------+
