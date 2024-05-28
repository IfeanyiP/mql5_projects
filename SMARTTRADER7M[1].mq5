//+------------------------------------------------------------------+
//|                                                      MULT_TF.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
CTrade trade;

input double LOT = 0.2;// Lot size
int maxtrading = 1;
input int TP = 20; //TakeProfit in Pips
input int gap = 10;//Gap in Pips
int gaps = (gap * 10);
input int TrailingStop = 300; //Trailing Stop (0 = disable)
//+------------------------------------------------------------------+
input int k_period = 5; // STOCHASTIC K PERIOD
input int d_period = 3; // STOCHASTIC D PERIOD
input int slowing = 3; // STOCHASTIC SLOWING
input int overbought_level = 80; //OVER BOUGHT LEVEL
input int oversold_level = 20; // OVERSOLD LEVEL
//+------------------------------------------------------------------+

input ENUM_MA_METHOD MA_MODE = MODE_SMA; // MOVING AVERAGE METHOD
input int MA_PERIOD_1 = 10; // MOVING AVERAGE PERIOD
input double psarstep = 0.001;// Psar Step
input double psarmax = 0.1;// Psar Max
input int PeriodCMO = 9;// Period CMO
input int PeriodEMA = 100;// Period EMA
input int IndicatorShift = 0;// Indicator Shift
input ENUM_TIMEFRAMES HF = PERIOD_CURRENT; //HIGHER TIMER FRAME
input ENUM_TIMEFRAMES LF = PERIOD_M5; // LOWER TIME FRAME

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//if(TimeCurrent() < end)
     {
      trailsl();
      double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

      double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

      if(Stoc() == "sell" && OrdersTotal() < maxtrading && PositionsTotal() < maxtrading)
        {
         if(MA() == "sell" && Psar() == "sell")
           {
            trade.SellLimit(LOT, NormalizeDouble((Bid + gaps * _Point), _Digits), NULL, 0, NormalizeDouble((Bid - (10 * TP) * _Point), _Digits), ORDER_TIME_GTC, 0, NULL);
            trade.Sell(LOT, NULL, Bid, 0, NormalizeDouble((Bid - (10 * TP) * _Point), _Digits), NULL);
           }
        }
      //+------------------------------------------------------------------+
      if(Stoc() == "buy" && OrdersTotal() < maxtrading && PositionsTotal() < maxtrading)
        {
         if(MA() == "buy" && Psar() == "buy")
           {
            trade.BuyLimit(LOT, NormalizeDouble((Ask - gaps * _Point), _Digits), NULL, 0, NormalizeDouble((Ask + (10 * TP) * _Point), _Digits), 0, 0, NULL);
            trade.Buy(LOT, NULL, Ask, 0, NormalizeDouble((Ask + (10 * TP) * _Point), _Digits), NULL);
           }
        }

      //===================================================
      //=====================================================
      
      if(Stoc() == "sell" && OrdersTotal() < maxtrading && PositionsTotal() < maxtrading)
        {
         trade.SellLimit(LOT, NormalizeDouble((Bid + gaps * _Point), _Digits), NULL, 0, NormalizeDouble((Bid - (10 * TP) * _Point), _Digits), ORDER_TIME_GTC, 0, NULL);
         trade.Sell(LOT, NULL, Bid, 0, NormalizeDouble((Bid - (10 * TP) * _Point), _Digits), NULL);
        }
      //=========================================================
      if(Stoc() == "buy" && OrdersTotal() < maxtrading && PositionsTotal() < maxtrading)
        {
         trade.BuyLimit(LOT, NormalizeDouble((Ask - gaps * _Point), _Digits), NULL, 0, NormalizeDouble((Ask + (10 * TP) * _Point), _Digits), 0, 0, NULL);
         trade.Buy(LOT, NULL, Ask, 0, NormalizeDouble((Ask + (10 * TP) * _Point), _Digits), NULL);
        }
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|          CLOSE AT OPPOSITE SIGNAL OF MA AND VDI                  |
      //+------------------------------------------------------------------+
      if(MA() == "buy")
        {
         closesell();
         pendelete();
        }
      if(MA() == "sell")
        {
         closebuy();
         pendelete();
        }

      if(hisT() == true)
        {
         pendelete();
        }

     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string Stoc() //stocastic indicator
  {
//-----------------------------------------------------------------------------------------------
   string stoc = " ";

   double karr[];
   double darr[];
   ArraySetAsSeries(karr, true);
   ArraySetAsSeries(darr, true);

   int stoch = iStochastic(_Symbol, HF, k_period, d_period, slowing, MODE_SMMA, STO_LOWHIGH);

   CopyBuffer(stoch, 0, 0, 3, karr);
   CopyBuffer(stoch, 1, 0, 3, darr);

   double kvalue1 = karr[0];
   double dvalue1 = darr[0];//signal

   if(dvalue1 <= oversold_level)
     {
      stoc = "buy";
     }

   else
      if(dvalue1 >= overbought_level)
        {
         stoc = "sell";
        }
   return stoc;
  }
//+------------------------------------------------------------------+
//--------------------------------------------------------------------
string MA() // moving average function and vdi indicators
  {

   MqlRates Priceinfo[];

   string signalma = " ";

   double SMA1arr[], varr[];  // creating array for several prices


// define properties of MA 1

   int SmallMA1 = iMA(_Symbol, LF, MA_PERIOD_1, 0, MA_MODE, PRICE_CLOSE);


   int va = iVIDyA(_Symbol, LF, PeriodCMO, PeriodEMA, IndicatorShift, PRICE_CLOSE);



   ArraySetAsSeries(SMA1arr, true);

   ArraySetAsSeries(varr, true);


   CopyBuffer(SmallMA1, 0, 0, 3, SMA1arr);

   CopyBuffer(va, 0, 0, 3, varr);


   if(SMA1arr[0] > varr[0])
     {
      signalma = "buy";
     }
//-----------------------------------

   if(SMA1arr[0] < varr[0])
     {
      signalma = "sell";
     }
   return (signalma);
  }

//------------

//+------------------------------------------------------------------+
string Psar() //parabolic indicator
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

   string signal = "";

//create a SAR array
   double mySARArray[];

//defining sar array
   int SARDefinition = iSAR(_Symbol, LF, psarstep, psarmax);

//SORT THE ARRAY FROM C1 DOWNWARDS
   ArraySetAsSeries(mySARArray, true);

//defined EA, current buffer, current candle, 3cs
   CopyBuffer(SARDefinition, 0, 0, 3, mySARArray);

//value for last C confirm
   double LastSARValue = NormalizeDouble(mySARArray[0], 5);

   if(LastSARValue > Bid)
     {
      signal = "sell";
     }
   else
      if(LastSARValue < Bid)
        {
         signal = "buy";
        }
   return signal;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void closebuy()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY))
           {

            ulong positionticket = PositionGetInteger(POSITION_TICKET);
            trade.PositionClose(positionticket, 9);

           }
         //---------------------------------------------------------------
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void closesell()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL))
           {
            ulong positionticket = PositionGetInteger(POSITION_TICKET);
            trade.PositionClose(positionticket, 9);

           }
         //---------------------------------------------------------------
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//------------------------------------------------------
void pendelete()
  {
   for(int d = OrdersTotal() - 1; d >= 0; d--)
     {
      ulong positionticket1 = OrderGetTicket(d);

      if(OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT)
        {
         trade.OrderDelete(positionticket1);
        }

     }
  }

//---------------------------------------------------------------------------------------
//+------------------------------------------------------------------+
//+-------------------------------------------------------------------------------------+
bool hisT()
  {
   ulong ticketnumber ;
   long Ordertype;
   HistorySelect(0, TimeCurrent());
   for(int i = HistoryDealsTotal() - 1; i > 0 ; i--)
     {
      if((ticketnumber = HistoryOrderGetTicket(i)) > 0)
        {
         long magic = HistoryDealGetInteger(ticketnumber, DEAL_MAGIC);
         Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);
         double orderprofit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);
         long time = HistoryDealGetInteger(ticketnumber, DEAL_TIME);
         if((HistoryDealGetInteger(ticketnumber, DEAL_ENTRY) == DEAL_ENTRY_OUT))
           {
            int diff = ((int)(TimeCurrent() - time));
            if(diff < 60)
              {
               return true;
              }
           }
        }
     }
   return  false;
  }
//=======================================================================================
//+------------------------------------------------------------------+
void trailsl()
  {
   double  MyPoint  =  _Point;
   if(_Digits  ==  3  ||  _Digits  ==  5 || _Digits == 2)
      MyPoint  =  _Point  *  10;
   double Ask, Bid;
   Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   for(int i = PositionsTotal() - 1; i >= 0; i--) // loop all Open Positions
     {
      string symbols = PositionGetSymbol(i);   // get position symbol
      string pos_type = EnumToString(ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE)));
      ulong magic = PositionGetInteger(POSITION_MAGIC);
      if(symbols == _Symbol && pos_type  ==  EnumToString(ENUM_POSITION_TYPE(POSITION_TYPE_BUY)))
        {
         ulong PositionTicket = PositionGetInteger(POSITION_TICKET);
         double dExecutedPrice = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN), 5);
         double OrderStopLoss = PositionGetDouble(POSITION_SL);
         double OrderTakeProfit = PositionGetDouble(POSITION_TP);
         if(TrailingStop  >  0)
           {
            if((Ask  -  dExecutedPrice)  > (MyPoint  *  TrailingStop))
              {
               if(OrderStopLoss  < (Ask  -  MyPoint  *  TrailingStop))
                 {
                  trade.PositionModify(PositionTicket, Ask - (TrailingStop  *  MyPoint), OrderTakeProfit);
                 }
              }
           }
        }
      if(symbols == _Symbol && pos_type  ==  EnumToString(ENUM_POSITION_TYPE(POSITION_TYPE_SELL)))
        {
         ulong sPositionTicket = PositionGetInteger(POSITION_TICKET);
         double sdExecutedPrice = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN), 5);
         double sOrderStopLoss = PositionGetDouble(POSITION_SL);
         double sOrderTakeProfit = PositionGetDouble(POSITION_TP);
         if(TrailingStop  >  0)
           {
            if((sdExecutedPrice  -  Bid)  > (MyPoint  *  TrailingStop))
              {
               if((sOrderStopLoss  > (Bid  +  MyPoint  *  TrailingStop)) || (sOrderStopLoss  ==  0))
                 {
                  trade.PositionModify(sPositionTicket, Bid + (TrailingStop  *  MyPoint), sOrderTakeProfit);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
