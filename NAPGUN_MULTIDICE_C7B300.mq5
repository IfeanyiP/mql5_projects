//+------------------------------------------------------------------+
//|                                      NAPGUN_MULTIDICE_C&B500.mq5 |
//|                                                   Copyright 2023 |
//|                                         https://www.napgun.co.za |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, NAPGUN TRADING FX Thank you for using our trial lisense multidice C300 bot, ENJOY! 072 587 5954"
#property link      "https://www.napgun.co.za"
#property version   "1.00"
#include <Trade\Trade.mqh>
CTrade trade;

input int NUMBER_TRADES = 2;// Number of Trades per time
ENUM_MA_METHOD MA = MODE_LWMA;
ENUM_MA_METHOD MA_MODE = MODE_LWMA;
ENUM_MA_METHOD MA_MODeall = MODE_EMA;
int MA_1 = 3;
int MA_2 = 5;
int MA_all = 70;
string names = "C300_SPIKE_DETECTOR.ex5";
#resource "\\Indicators\\C300_SPIKE_DETECTOR.ex5"
//===============================================
string name = "B300_SPIKE_DETECTOR.ex5";
#resource "\\Indicators\\B300_SPIKE_DETECTOR.ex5"
//--------------------------------------------------------------------
int enable_daily_profit = 1;
input double daily_profit = 10;
input double daily_loss = 60;
input int Take_profit = 150000; // Take profit
input int Stop_loss = 15000; // Stop loss
input int TrailingStop = 300; //Trailing Stop (0 = disable)
int magicNumber = 778839; // Your magic number
string Cmmt ="NAPGUN_MULTIDICE_C300";

datetime end = D'2024.02.19'; // Expiry Date
long  Account_Number = 21067946;//Account Number Lock

//----------------------------------------------
int timer0 = 20;
int timer30 = 30;
int Spikec;
int Spikeb;
//------------------------------------------------------------------
int T3b = 56;

int T3s = 56;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+



//--------------------------------------------------------------------------
input double LOT = 3.00;// Lot size for scalping
input double lotsize = 0.50;// Lot size for indicator



double p_close;


double profitS = 0.01;// profit for counter trend{sell}

double profitB = 0.01;//profit for counter trend{buy}
//-------------------------------------------------------------------------

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   trade.SetExpertMagicNumber(magicNumber);
   if(Period() != PERIOD_M1)
     {
      Comment("Expert only works on 1min timeframe");
      ExpertRemove();
     }

//---
   Spikec = iCustom(_Symbol, _Period, "::Indicators\\C300_SPIKE_DETECTOR");
//======================================================================
   Spikeb = iCustom(_Symbol, _Period, "::Indicators\\B300_SPIKE_DETECTOR");

//---
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
  trailsl();
// Check if the current symbol is the Crash 500 market
   if(_Symbol != "Crash 300 Index")
     {
      // Remove the EA if it's not trading the desired market
      ExpertRemove();
      return; // Exit the function
     }

   long accountlock = AccountInfoInteger(ACCOUNT_LOGIN);
   if(accountlock != Account_Number)
     {
      Comment("Account is not licensed");
      ExpertRemove();
     }
   else
     {
      Comment("Account is licensed, welcome");

      long IsDemo = AccountInfoInteger(ACCOUNT_TRADE_MODE);
      if(TimeCurrent() < end)
        {
         double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

         double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

         string sym1 = "Boom 500 Index";

         string symc2 = "Crash 500 Index";

         string sym111 = "Boom 1000 Index";

         string symc222 = "Crash 1000 Index";

         string sym11 = "Boom 300 Index";

         string symc22 = "Crash 300 Index";

         //===========================================================================================================
         double TD[],TD1[],TD2[],TD3[],TD4[];

         ArraySetAsSeries(TD, true);

         CopyBuffer(Spikec, 0, 0, 3, TD); // Buffer 0
         //======================================================

         ArraySetAsSeries(TD1, true);

         CopyBuffer(Spikec, 1, 0, 3, TD1); //Buffer 1
         //==========================================================
         ArraySetAsSeries(TD2, true);

         CopyBuffer(Spikec, 2, 0, 3, TD2); //Buffer 2
         //==============================================================
         ArraySetAsSeries(TD3, true);

         CopyBuffer(Spikec, 3, 0, 3, TD3); //Buffer 3
         //================================================================
         ArraySetAsSeries(TD4, true);

         CopyBuffer(Spikec, 4, 0, 3, TD4); //Buffer 4


         double sp = TD[0];

         double sp1 = TD1[0];

         double sp2 = TD2[0];

         double sp3 = TD3[0];

         double sp4 = TD4[0];

         if(_Symbol == symc2 || _Symbol == symc22 || _Symbol == symc222)
           {

            if((sp != EMPTY_VALUE || sp1 != EMPTY_VALUE || sp3 !=EMPTY_VALUE || sp4 != EMPTY_VALUE) && (sp2 == EMPTY_VALUE))

              {
               SELL();
              }
           }
         //==========================
         //==========================
         double TB[],TB1[],TB2[],TB3[],TB4[],TB5[],TB6[],TB7[];

         ArraySetAsSeries(TB, true);

         CopyBuffer(Spikeb, 0, 0, 3, TB); // Buffer 0
         //======================================================

         ArraySetAsSeries(TB1, true);

         CopyBuffer(Spikeb, 1, 0, 3, TB1); //Buffer 1
         //==========================================================
         ArraySetAsSeries(TB2, true);

         CopyBuffer(Spikeb, 2, 0, 3, TB2); //Buffer 2
         //==============================================================
         ArraySetAsSeries(TB3, true);

         CopyBuffer(Spikeb, 3, 0, 3, TB3); //Buffer 3
         //================================================================
         ArraySetAsSeries(TB4, true);

         CopyBuffer(Spikeb, 4, 0, 3, TB4); //Buffer 4
         //================================================================
         ArraySetAsSeries(TB5, true);

         CopyBuffer(Spikeb, 5, 0, 3, TB5); //Buffer 5
         //================================================================
         ArraySetAsSeries(TB6, true);

         CopyBuffer(Spikeb, 6, 0, 3, TB6); //Buffer 6
         //================================================================
         ArraySetAsSeries(TB7, true);

         CopyBuffer(Spikeb, 7, 0, 3, TB7); //Buffer 7

         double sc = TB[0];

         double sc1 = TB1[0];

         double sc2 = TB2[0];

         double sc3 = TB3[0];

         double sc4 = TB4[0];

         double sc5 = TB5[0];

         double sc6 = TB6[0];

         double sc7 = TB7[0];

         if(_Symbol == sym1 || _Symbol == sym11 || _Symbol == sym111)

            if(sc != EMPTY_VALUE || sc1 != EMPTY_VALUE || sc3 !=EMPTY_VALUE || sc4 != EMPTY_VALUE || sc2 != EMPTY_VALUE || sc5 != EMPTY_VALUE || sc6 != EMPTY_VALUE || sc7 != EMPTY_VALUE)
              {
               BUY();
              }


         //========================================================================================
         int shoulder = 4;
         int bar111;
         int bar2;
         bar111 = FINDPEAK(MODE_HIGH, shoulder, 0);
         bar2 = FINDPEAK(MODE_HIGH, shoulder, bar111 + 1);
         double price;
         ObjectDelete(0, "upper");

         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         ObjectCreate(0, "upper", OBJ_HLINE, 0, iTime(Symbol(), Period(), bar2), iHigh(Symbol(), Period(), bar2), iTime(Symbol(), Period(), bar111), iHigh(Symbol(), Period(), bar111));
         ObjectSetInteger(0, "upper", OBJPROP_COLOR, clrRed);
         ObjectSetInteger(0, "upper", OBJPROP_WIDTH, 2);
         ObjectSetInteger(0, "upper", OBJPROP_RAY_LEFT, true);
         price = ObjectGetDouble(0, "upper", OBJPROP_PRICE);
         //  Comment(price);
         //------------------------------------------------------------------------------

         int bar11;
         int bar22;
         bar11 = FINDPEAK(MODE_LOW, shoulder, 0);
         bar22 = FINDPEAK(MODE_LOW, shoulder, bar11 + 1);
         double price1;
         ObjectDelete(0, "LOWER");

         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         ObjectCreate(0, "LOWER", OBJ_HLINE, 0, iTime(Symbol(), Period(), bar22), iLow(Symbol(), Period(), bar22), iTime(Symbol(), Period(), bar11), iLow(Symbol(), Period(), bar11));
         ObjectSetInteger(0, "LOWER", OBJPROP_COLOR, clrBlue);
         ObjectSetInteger(0, "LOWER", OBJPROP_WIDTH, 2);
         ObjectSetInteger(0, "LOWER", OBJPROP_RAY_LEFT, true);
         price1 = ObjectGetDouble(0, "LOWER", OBJPROP_PRICE);

         //------------------------------------------------------------------------------------------------

         //-----------------------------------------------------------------------------------------------------------------------

         datetime timenow = TimeCurrent();

         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         datetime newbar = NewBar(timenow);
         //---------------------------------------------------------------------------------------------------
         //----------------------------------------------------------------------------------------------------------------------------------------
         MqlRates PRICEINFO[];

         string signaleng = " ";

         string signal4 = " ";


         ArraySetAsSeries(PRICEINFO, true);

         int  DATA = CopyRates(_Symbol, _Period, 0, 10, PRICEINFO);




         //------------------------------------------------------------------------------------------------------------------------
         double closeprice0 = PRICEINFO[0].close;

         double openprice0 = PRICEINFO[0].open;

         double closeprice1 = PRICEINFO[1].close;

         double openprice1 = PRICEINFO[1].open;

         double closeprice2 = PRICEINFO[2].close;

         double openprice2 = PRICEINFO[2].open;

         double closeprice3 = PRICEINFO[3].close;

         double openprice3 = PRICEINFO[3].open;

         double closeprice4 = PRICEINFO[4].close;

         double openprice4 = PRICEINFO[4].open;
         //---------------------------------------------------------------------------------------------------
         //-----------------------------------------------------------------------------------------------------

         if(closeprice0 < openprice0)
           {
            signaleng = "sell";
           }

         if(closeprice1 < openprice1 && closeprice2 < openprice2 && closeprice3 < openprice3)
           {
            signal4 = "sell";
           }


         if(closeprice1 < openprice1 && closeprice2 < openprice2)
           {
            signal4 = "sell2";
           }

         //------------------------------------------------------------------------------------------------------------

         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         if(closeprice0 > openprice0)
           {
            signaleng = "buy";
           }

         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         if(closeprice1 > openprice1 && closeprice2 > openprice2 && closeprice3 > openprice3)
           {
            signal4 = "buy";
           }


         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         if(closeprice1 > openprice1 && closeprice2 > openprice2) //&& closeprice4 > openprice4)
           {
            signal4 = "buys";
           }
         //-----------------------------------------------------------------
         //-----------------------------------------------------------------------------------------------------
         MqlRates Priceinfo[];

         ArraySetAsSeries(Priceinfo, true);

         int pricedata = CopyRates(_Symbol, _Period, 0, 3, Priceinfo);

         string signal = " ";

         string signalsell = " ";

         string signalbuy = " ";

         double SMA1arr[], SMA3arr[], SMA8arr[];  // creating array for several prices



         // define properties of MA 1

         int SmallMA1 = iMA(_Symbol, _Period, MA_1, 0, MA, PRICE_CLOSE);

         // define the properties of MA 3

         int SmallMA3 = iMA(_Symbol, _Period, MA_2, 0, MA_MODE, PRICE_CLOSE);



         int SmallMA8 = iMA(_Symbol, _Period, MA_all, 0, MA_MODeall, PRICE_CLOSE);

         ArraySetAsSeries(SMA1arr, true);

         ArraySetAsSeries(SMA3arr, true);

         ArraySetAsSeries(SMA8arr, true);



         CopyBuffer(SmallMA1, 0, 0, 3, SMA1arr);

         CopyBuffer(SmallMA3, 0, 0, 3, SMA3arr);

         CopyBuffer(SmallMA8, 0, 0, 3, SMA8arr);


         if(SMA1arr[1] < SMA3arr[1] &&  SMA1arr[0] > SMA3arr[0] &&  SMA1arr[0] > SMA8arr[0] &&  SMA3arr[0] > SMA8arr[0])

           {
            signal = "buy";
           }

         //----------------------------------------

         if(SMA1arr[1] > SMA3arr[1] &&  SMA1arr[0] < SMA3arr[0]  &&  SMA1arr[0] < SMA8arr[0] &&  SMA3arr[0] < SMA8arr[0])
           {

            signal = "sell";
           }

         //-------------------------------------------------------------------------------------
         MqlRates mrates[];

         //-----------------------------------------------------------------
         //the rates arrays
         ArraySetAsSeries(mrates, true);

         //----Get the details of the last 3 bars


         if(CopyRates(_Symbol, _Period, 0, 10, mrates) < 0)
           {
            Alert("error copying rates", GetLastError());

           }

         //----------------------SELL MA---------------------

         p_close = mrates[4].close;

         double p_close1 = mrates[3].close;

         string signalS = " ";

         string signalB = " ";

         if((p_close1 < SMA8arr[0]) && (p_close < SMA8arr[0]))
           {

            signalS = "SELLS";

           }
         //+-----------------------------------------------------------------------------------
         if((p_close1 > SMA8arr[0]) && (p_close > SMA8arr[0]))
           {

            signalB = "BUYS";
           }
         //----------------------------------------------------------------------------------------------------------------------------


         //--------------------------------------------------one-------------------------------------------------------
         if(ProfitReached() <= daily_profit && LOSS() == false)
           {
            if(_Symbol == sym1 || _Symbol == sym11 || _Symbol == sym111)
              {
               if(signal == "sell" && signaleng == "sell" &&  signal4 == "sell2"  && timenow >= newbar + timer0 && timenow <= newbar + timer30 && sell() < NUMBER_TRADES) //0 t0 30=25
                  //---------------------------------------------CRASH PRICE ACT N MA-----------------------------------------------------------------
                 {

                  // Comment("SELLLLLLLLLLLLLLLLLLLLLLLL      ", newbar + timer0, "\n", timenow);

                  trade.Sell(LOT, NULL, Bid, 0, 0,NULL);


                 }
              }
            //+------------------------------------------------------------------+
            if(_Symbol == symc2 || _Symbol == symc22 || _Symbol == symc222)
              {
               if(signal == "buy" && signaleng == "buy" &&  signal4 == "buys" && timenow >= newbar + timer0 && timenow <= newbar + timer30 && buy() < NUMBER_TRADES) //0 t0 30=25
                  //---------------------------------------------CRASH PRICE ACT N MA-----------------------------------------------------------------
                 {
                  Comment("current time", "\n", TimeCurrent());

                  trade.Buy(LOT, NULL, Ask, 0, 0,NULL);//ADDED

                 }

              }
            //--------------------------------------FUNCTIONS------------------------------------------------------------------------

            if(timenow >= newbar + T3b && timenow < newbar + 58 && PositionsTotal() == 1)
              {

               for(int i = PositionsTotal() - 1; i >= 0; i--)
                 {
                  string symbol = PositionGetSymbol(i);
                  if(_Symbol == symbol)
                    {
                     double open = PositionGetDouble(POSITION_PRICE_OPEN);


                     if((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) && PositionGetString(POSITION_COMMENT) != Cmmt)
                       {
                        ulong positionticket = PositionGetInteger(POSITION_TICKET);
                          {
                           int posMagic = PositionGetInteger(POSITION_MAGIC);
                           if(posMagic == magicNumber)
                             {
                              trade.PositionClose(positionticket, 9);
                             }
                          }
                       }

                    }
                 }
              }


            //--------------------------------------FUNCTIONS------------------------------------------------------------------------

            if(timenow >= newbar + T3s && timenow < newbar + 58  && PositionsTotal() == 1)
              {

               for(int i = PositionsTotal() - 1; i >= 0; i--)
                 {
                  string symbol = PositionGetSymbol(i);
                  if(_Symbol == symbol)
                    {
                     double open = PositionGetDouble(POSITION_PRICE_OPEN);


                     if((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)  && PositionGetString(POSITION_COMMENT) != Cmmt)
                       {
                        ulong positionticket = PositionGetInteger(POSITION_TICKET);
                        int posMagic = PositionGetInteger(POSITION_MAGIC);
                        if(posMagic == magicNumber)
                          {
                           trade.PositionClose(positionticket, 9);
                          }

                       }
                    }
                 }

              }


            //==============

            //------------------------------------------------------------------------------------------------------------------------------------
            //----------------------------------------------------------------------------------------------------------------------------
           }//profit/loss'


         //=====================================================================================================================
         newcandleclose();
         //  profitclose();
         //   profitsell();
         //  profitbuy();
         //======================================================================================================================
         // }//acct number
         //}//demo

         //}//

        }
     }
  }


//---------------------------------------trailing via points--------------------------------
//+------------------------------------------------------------------+
double sell()
  {
   double sellstop = 0 ;

   for(int d = PositionsTotal() - 1; d >= 0; d--)
     {
      ulong positionticket1 = PositionGetTicket(d);

      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
        {
         //   Comment("sellstop is ====", sellstop);
         sellstop = sellstop + 1;

        }

     }
   return(sellstop);
  }

//+------------------------------------------------------------------+
double buy()
  {
   double buystop = 0 ;

   for(int d = PositionsTotal() - 1; d >= 0; d--)
     {
      ulong positionticket1 = PositionGetTicket(d);

      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)

        {
         buystop = buystop + 1;
         // Comment("buystop is ====", buystop);
        }

     }
   return(buystop);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime NewBar(datetime now)
  {
   static datetime lasttime;

   datetime time [];

   CopyTime(_Symbol, PERIOD_M1, 0, 1, time);

   if(time[0] != lasttime)
     {
      lasttime = now;
     }
   return lasttime;
  }
//--------------------------------------------------------------------
void newcandleclose()
  {
//-------------------------------------------------------------------
   static datetime OT;      // old bar time
   datetime NT[1];         //  new bar tiime
   bool IsNewBars = false; // new bar

// copying the last bar time to the element NT[0]

   int copieds = CopyTime(_Symbol, _Period, 0, 1, NT);

   if(copieds > 0)       // data successfully copied

     {
      if(OT != NT[0]) // if the OT IS NOT EQUAL NT
        {
         //------------------------------------------------------------------------------
         for(int i = PositionsTotal() - 1; i >= 0; i--)
           {
            string symbol = PositionGetSymbol(i);
            if(_Symbol == symbol)
              {
               double open = PositionGetDouble(POSITION_PRICE_OPEN);

               if((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL || PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) && (PositionGetString(POSITION_COMMENT) != Cmmt))
                 {
                  ulong positionticket = PositionGetInteger(POSITION_TICKET);
                  int posMagic = PositionGetInteger(POSITION_MAGIC);
                  if(posMagic == magicNumber)
                    {
                     trade.PositionClose(positionticket, 9);
                    }

                 }
              }
           }
         //------------------------------------------------------------------------------

         IsNewBars = true; //

         if(MQL5InfoInteger(MQL5_DEBUGGING))

            Print("we have a new bar", NT[0], "old time was", OT);

         OT = NT[0];
        }

     }
  }
//---------------------------------------------------------------------

//+------------------------------------------------------------------+
double ProfitReached()
  {

   ulong ticketnumber = 0;

   long Ordertype;

   double orderprofit;
//=======================================



   orderprofit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);

   Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);


   double swap = HistoryDealGetDouble(ticketnumber, DEAL_SWAP);


   long opentime =  HistoryDealGetInteger(ticketnumber, DEAL_TIME);

   double commission =  HistoryDealGetDouble(ticketnumber, DEAL_COMMISSION);
//=======================================

   double sum = orderprofit + swap + commission; ;

   HistorySelect(0, TimeCurrent());

   for(int i = HistoryDealsTotal() - 1; i > 0 ; i--)
      // for(int i = 0; i < HistoryDealsTotal(); i++)
     {
      if((ticketnumber = HistoryOrderGetTicket(i)) > 0)

        {

         if((HistoryDealGetInteger(ticketnumber, DEAL_ENTRY) >= 1) && (Ordertype == ORDER_TYPE_BUY))//|| Ordertype == ORDER_TYPE_SELL))

           {



            //   Comment("DAILY_PROFIT is equal to ====== ", "\n", sum);   if(opentime < TimeCurrent() - TimeCurrent() % 86400)
              {
               break ;
              }

           }
        }
     }
   return (sum);

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LOSS()
  {

   ulong ticketnumber ;

   long Ordertype;

   double orderprofit;

   double sum = 0 ;

   HistorySelect(0, TimeCurrent());

   for(int i = HistoryDealsTotal() - 1; i > 0 ; i--)
      //    for(int i = 0; i < HistoryDealsTotal(); i++)
     {
      if((ticketnumber = HistoryOrderGetTicket(i)) > 0)

        {



         orderprofit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);

         Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);

         long opentime =  HistoryDealGetInteger(ticketnumber, DEAL_TIME);

         double swap = HistoryDealGetDouble(ticketnumber, DEAL_SWAP);

         double commission =  HistoryDealGetDouble(ticketnumber, DEAL_COMMISSION);



         if((HistoryDealGetInteger(ticketnumber, DEAL_ENTRY) == DEAL_ENTRY_OUT) && (Ordertype == ORDER_TYPE_BUY || Ordertype == ORDER_TYPE_SELL))

           {
            if(opentime < TimeCurrent() - TimeCurrent() % 86400)
              {
               break ;
              }

            sum += orderprofit + swap + commission;

            //  Comment("DAILY_loss is equal to ====== ", "\n", sum);

            if(sum < 0 && sum <= -daily_loss)
              {

               return(true);
              }

           }
        }
     }
   return(false);

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FINDPEAK(int mode, int count, int startbar)
  {
   if(mode != MODE_HIGH && mode != MODE_LOW)
      return(-1);

   int currentbar = startbar;
   int foundbar = FINDNEXTPEAK(mode, count * 2 + 1, currentbar - count);
   while(foundbar != currentbar)
     {
      currentbar = FINDNEXTPEAK(mode, count, currentbar + 1);
      foundbar = FINDNEXTPEAK(mode, count * 2 + 1, currentbar - count);
     }
   return(currentbar);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int FINDNEXTPEAK(int mode, int count, int startbar)
  {
   if(startbar < 0)
     {
      count += startbar;
      startbar = 0;
     }
   return((mode == MODE_HIGH) ?
          iHighest(Symbol(), Period(), (ENUM_SERIESMODE)mode, count, startbar) :
          iLowest(Symbol(), Period(), (ENUM_SERIESMODE)mode, count, startbar)
         );
  }
//+------------------------------------------------------------------+
void SELL()
  {
//---------------------------------------------------------------------------
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

//-------------------------------------------------------------------------------------
   static datetime OT;
   datetime NT[1];

   CopyTime(_Symbol, _Period, 0, 1, NT);

   if(OT != NT[0])
     {
      double SLs = NormalizeDouble(Bid + (Stop_loss * _Point), _Digits);
      double TPs = NormalizeDouble(Bid - (Take_profit * _Point), _Digits);
      trade.Sell(lotsize, NULL, Bid, SLs, TPs,Cmmt);

     }
   OT = NT[0];
  }
//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BUY()
  {

//---------------------------------------------------------------------------
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   static datetime OT;

   datetime NT[1];
   CopyTime(_Symbol, _Period, 0, 1, NT);
   if(OT != NT[0])
     {
      double SL = NormalizeDouble((Ask - (Stop_loss * _Point)), _Digits);
      double TP = NormalizeDouble((Ask + (Take_profit * _Point)), _Digits);
      trade.Buy(lotsize, NULL, Ask, SL, TP, Cmmt);
     }

   OT = NT[0];
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+



//========================
//=======================
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
      if((symbols == _Symbol) && (pos_type  ==  EnumToString(ENUM_POSITION_TYPE(POSITION_TYPE_BUY))))
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
      if((symbols == _Symbol) && (pos_type  ==  EnumToString(ENUM_POSITION_TYPE(POSITION_TYPE_SELL))))
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