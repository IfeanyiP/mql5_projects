//+------------------------------------------------------------------+
//|                                               band bollinger.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

CTrade trade;
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots 3
//for the upper band level
#property indicator_label1 "upper_Band"
#property indicator_color1 clrAliceBlue, clrAqua
#property indicator_width1 1
#property indicator_type1 DRAW_COLOR_LINE
//for the middle band level
#property indicator_label2 "Middle_Band"
#property indicator_color2 clrAzure
#property indicator_width2 2
#property indicator_type2 DRAW_COLOR_LINE
//for the lower band level
#property indicator_label3 "Lower_Band"
#property indicator_color3 clrBlue, clrRed
#property indicator_width3 1
#property indicator_type3 DRAW_COLOR_LINE

//input variables
input double Deviation = 2.0;
input int Ma_Period = 20;
input int Ma_Shift = 0;
input ENUM_APPLIED_PRICE Applied_Price = PRICE_CLOSE;
input int StopLoss = 20;
input int TakeProfit = 50;
input double Lot_Volume = 0.5;
input int MaxTrading = 1;
const string symbol = _Symbol;

//other variables
double Middle_Buffer[];
double Upper_Buffer[];
double Lower_Buffer[];
double Color_Buffer[];
int BB_Value;

double Middle;
double Upper;
double Lower;
double colour;
   

int OnInit()
  {
   SetIndexBuffer(BASE_LINE,Middle_Buffer,INDICATOR_DATA);
   SetIndexBuffer(UPPER_BAND,Upper_Buffer,INDICATOR_DATA);
   SetIndexBuffer(LOWER_BAND,Lower_Buffer,INDICATOR_DATA);
   SetIndexBuffer(1,Color_Buffer,INDICATOR_COLOR_INDEX); 
   
   ArraySetAsSeries(Middle_Buffer,true);
   ArraySetAsSeries(Upper_Buffer,true);
   ArraySetAsSeries(Lower_Buffer,true);
   ArraySetAsSeries(Color_Buffer,true);
    
   int Band = iBands(symbol,PERIOD_CURRENT,Ma_Period,Ma_Shift,Deviation,Applied_Price);
    
   CopyBuffer(Band,0,0,3,Middle_Buffer);
   CopyBuffer(Band,1,0,3,Upper_Buffer);
   CopyBuffer(Band,2,0,3,Lower_Buffer);
   CopyBuffer(Band,3,0,3,Color_Buffer);
   
   Middle = Middle_Buffer[0];
   Upper = Upper_Buffer[0];
   Lower = Lower_Buffer[0];
   colour = Color_Buffer[0];                                                                                
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
   //for ask price
   double SL = NormalizeDouble((Ask - StopLoss * _Point),_Digits);
   double TP = NormalizeDouble((Ask + TakeProfit * _Point),_Digits);
   
   //for bid price
   double SL2 = NormalizeDouble((Bid + StopLoss * _Point),_Digits);
   double TP2 = NormalizeDouble((Bid - TakeProfit * _Point),_Digits);
   
   if(Bollinger() == "Buy")
   {
     trade.Buy(Lot_Volume,symbol,Ask,SL,TP,"Buy Now");
   }
   else if(Bollinger() == "SELL")
   {
     trade.Sell(Lot_Volume,symbol,Bid,SL2,TP2,"Sell Now");
   }
}

//+creating function of bollinger band
 string Bollinger()
{
   double colour1;
   double colour2;
   string signal = "";
   
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo,true);
   CopyRates(symbol,PERIOD_CURRENT,0,3,PriceInfo);
   double Current_Close = PriceInfo[0].open;
   
   SetIndexBuffer(BASE_LINE,Middle_Buffer,INDICATOR_DATA);
   SetIndexBuffer(UPPER_BAND,Upper_Buffer,INDICATOR_DATA);
   SetIndexBuffer(LOWER_BAND,Lower_Buffer,INDICATOR_DATA);
   SetIndexBuffer(1,Color_Buffer,INDICATOR_COLOR_INDEX); 
   
   ArraySetAsSeries(Middle_Buffer,true);
   ArraySetAsSeries(Upper_Buffer,true);
   ArraySetAsSeries(Lower_Buffer,true);
   ArraySetAsSeries(Color_Buffer,true);
   
   BB_Value = iBands(symbol,PERIOD_CURRENT,Ma_Period,Ma_Shift,Deviation,Applied_Price);
   
   CopyBuffer(BB_Value,0,0,3,Middle_Buffer);
   CopyBuffer(BB_Value,1,0,3,Upper_Buffer);
   CopyBuffer(BB_Value,2,0,3,Lower_Buffer);
   CopyBuffer(BB_Value,3,0,3,Color_Buffer);
   
   Middle = Middle_Buffer[0];
   Upper = Upper_Buffer[0];
   Lower = Lower_Buffer[0];
   colour1 = Color_Buffer[0];
   colour2 = Color_Buffer[1];
   double Close = iClose(symbol,PERIOD_CURRENT,0);
    
   
   //using the if statement to get the trades done
   if(Close <= Upper && Close > Middle && PositionsTotal() < MaxTrading)
   {
     signal = "Sell";
     colour1;
   }
   else if(Close >= Lower && Close < Middle && PositionsTotal() < MaxTrading)
   {
     signal = "Buy";
     colour2;
   }
  return(signal);
}
   
   
//creating the ask and bid price
double Ask = SymbolInfoDouble(symbol,SYMBOL_ASK);

double Bid = SymbolInfoDouble(symbol,SYMBOL_BID);