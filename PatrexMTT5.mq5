//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                    Durdur.mq5 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Trade\Trade.mqh>
CTrade trade;
//-=============================================================
#include  <Controls\Button.mqh>
CButton KillButton, KillerButton, KillestButton, Autotrading, hedging, swing, pattern, divergance, priceaction, grid, martigale, Killmartigale, Killermartigale, Killestmartigale, Killhedging, Killerhedging, Killesthedging, Killswing, Killerswing, Killestswing, Killpattern, Killerpattern, Killestpattern, Killdivergance, Killerdivergance, Killestdivergance, Killpriceaction, Killerpriceaction, Killestpriceaction, close;


#include  <Controls\Label.mqh> // LABEL CREATION 
CLabel  label600, label500, label400, label1, label2, label3, label4, label5, label6, label7, label8, label9, label10, label11, label12, label13, label14, label15, label16, label17, label18, label19, label20, label21, label22, label23, label24, label25, label26, label27, label28, label29, label30, label31, label32, label33, label34, label35, label36, label37, label38, label39, label40, label41, label42, label43, label44, label45, label46, label47, label48, label49, label50, label51, label52, label53, label54, label55, label56, label57, label58, label59, label60;

enum trades  {BUY_ONLY, SELL_ONLY};
input trades Trading = BUY_ONLY; //Trading Direction

string names = "MACD_Bars_v1.ex5";
#resource "\\Indicators\\MACD_Bars_v1.ex5"

string name8 = "fxamsignal.ex5";
#resource "\\Indicators\\fxamsignal.ex5"
//===============================================
string name = "Donchian_channel_cslegmtfo.ex5";
#resource "\\Indicators\\Donchian_channel_cslegmtfo.ex5"

string namez = "STD_Trend_envelopes_of_averages_-_mtf.ex5";
#resource "\\Indicators\\STD_Trend_envelopes_of_averages_-_mtf.ex5"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double loss = 0; // Max Loss (0 = Disable)
input double gain = 0; //  Max Profit (0 = Disable)
input static string Order_s = "======================Close by Balance Profit=========================="; // Order Settings
input bool bal_p = false; // Close by Balance Profit

input double bal2_ratio = 8.3;//Balance  Profit: Ratio to Trigger
enum balance  {Pause_Until_EA_Restarted_Manually, Continue_Trading};
input balance modes = Continue_Trading; // Balance  Profit: Trigger Mode
input bool bal5_ratio = false; // Close by Balance Loss
input double bal2_ratio2 = 4.4; // Balance  Loss: Ratio to Trigger
enum balance1  {Pause__Until_EA_Restarted_Manually, Continue__Trading};
input balance1 mode1 = Continue__Trading;// Balance  Loss: Trigger Mode
input static string Order_s2 = "======================Order Settings=========================="; // Order Settings

input int Trade_number = 1; // Trades per Signal
input double lot = 0.01; // Lot Size
input int SL = 200; // Stop Loss (0 = Disable)
input bool trailing_switch = true;// Use Trailing Stop (set SL & TP to 0)
input bool continuetrail = true;// Continue Trading When Trailing Stop Hits
input int TrailingStart = 30; // trailing start
input int TrailingStep = 10; // trailing step
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input bool rangefilter = true;// Range Entry Filter
input int TP = 300; // Take Profit (0 = Disable)
input bool Preset = true;// Overall TP and SL
input int  TOTALopen = 5;// Open Trade Limit (0=disable)
input int MaxTPmove = 400; // Max TP (Point)
input int MaxSLmove = 400; // Max SL (Point)
input int Desiredspread = 400; // Max, Spread,Pips (0=Disable)
input int magicnumber= 123000; // Magic Number
input static string Trading_time = "================Trading Time====================="; //Trading Time
input bool Use = false; // Use Trading Time
input string openinghour_min = "00:00"; // Start Trading Time (HH:MM)
input string closinghour_min = "13:00"; // Stop Trading Time (HH:MM)
input bool closealltradeatstoptime = false;// Close All Trades AT Stop Time
input bool pausealltradeatstoptime = false;// Pause All Trades AT Stop Time
input bool usenews = true; // Use News Filter
input int timeBefore = 180; // Close Position Minutes Before News
input int timeAfter = 180; // Don't Trade Minutes After News


input static string Trading_days = "=====================Trading Days================"; // Trading Times

input bool Monday = true;
input bool Tuesday = true;
input bool Wednesday = true;
input bool Thursday = true;
input bool Friday = true;
input bool Saturday = true;
input bool Sunday = true;

input bool Showpop = true;// Show pop up
input bool Sendemail = true;// Send Email
input bool mobilenotification = true;// Send Mobile Notification
input bool Playsound = true;// Play Sound
input static string des = "=====================Style================"; // Description
input color backgrdd = clrBlack; //Chart BG Color
color mloss = clrRed; //Max Loss  Color
color mpro = clrLimeGreen; //Max Profit Color
input static string desx = "=====================Panel================"; // Description
input bool panel = true; // Display Panel
enum Pos {Upper_Left, Upper_Right};
input Pos Position = Upper_Left;//Panel Position
color ml = clrRed; //Negative PL  Color
color mp = clrLimeGreen; //Positive PL Color
input  color backgrd1 = clrPurple; //Panel BG Color
input color buy = clrBlue; //Buy Color
input color sell = clrOrangeRed; // Sell Color
input color closealls = clrGreen; //Close Color
input color pause = clrRed; //Pause Color
bool tradingPaused = false;
bool isNewTradeAlertShown = false; // Global variable to track whether the new trade alert has been shown


datetime entryTime;
datetime exitTime;






int NumTrades;
int Tickets[100];
int MACD;
int TMA;
int fxam;
int Doch;
int mff;
datetime end = D'2024.04.28'; // Expiry Date



//+------------------------------------------------------------------+

//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   trade.SetExpertMagicNumber(magicnumber);
   MACD = iCustom(_Symbol, _Period, "::Indicators\\MACD_Bars_v1");
   fxam = iCustom(_Symbol, _Period, "::Indicators\\fxamsignal");
   Doch = iCustom(_Symbol, _Period, "::Indicators\\Donchian_channel_cslegmtfo");
   mff = iCustom(_Symbol, _Period, "::Indicators\\STD_Trend_envelopes_of_averages_-_mtf");
//--- Subscribe to trade events
   EventSetMillisecondTimer(500); // Set a timer to check for new orders every 500 milliseconds
   EventSetTimer(1); // Set a timer event to check for new orders
//---
   return(INIT_SUCCEEDED);
  }


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(0, "KILL8");
   ObjectDelete(0, "KILL7");
   ObjectDelete(0, "KILLER7");
   ObjectDelete(0, "KILLEST7");

   ObjectDelete(0, "label1");
   ObjectDelete(0, "label2");
   ObjectDelete(0, "label3");
   ObjectDelete(0, "label5");
   ObjectDelete(0, "label6");
   ObjectDelete(0, "label7");
   ObjectDelete(0, "label8");
   ObjectDelete(0, "label9");
   ObjectDelete(0, "label10");
   ObjectDelete(0, "label11");
   ObjectDelete(0, "label12");
   ObjectDelete(0, "label13");
   ObjectDelete(0, "String2");
   ObjectDelete(0, "String4");

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(Playsound == true)
      CheckNewOrders();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
//-----------------------------------------------
void OnTick()
  {
   newsfilter();
   if(Preset == true)
     {
      BuypriceSL();
      BuypriceTP();
      SellpriceSL();
      SellpriceTP();
     }
   double open = PositionGetDouble(POSITION_PRICE_OPEN);
//Comment(open);


   int Demo = AccountInfoInteger(ACCOUNT_TRADE_MODE);
   if(Demo==0 && TimeCurrent() < end)
     {
      datetime localtime = TimeLocal();
      string hourmin = TimeToString(localtime, TIME_MINUTES);
      //------------------------------------------------

      if(Use == true && StringSubstr(hourmin, 0, 5) >= openinghour_min && StringSubstr(hourmin, 0, 5) < closinghour_min && (weekdayM() == 1 || weekdayT() == 2 || weekdayW() == 3 || weekdayTHUR() == 4 || weekdayFri() == 5 || weekdaysat() == 6 || weekdaysun() == 0) && Spread() <= Desiredspread)
        {
         //=================
         // Check if a new trade alert should be shown
         if(isNewTradeAlertShown)
           {
            // Show pop-up if Showpop is true
            if(Showpop)
       +       {
               for(int i = PositionsTotal() - 1; i >= 0; i--)
                 {
                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                    {
                     Alert("Buy trade detected");
                    }
                  else
                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)        
                       {
                        Alert("Sell trade detected");
                       }
                 }
              }
            // Play sound if Playsound is true
            if(Playsound)
              {
               for(int i = PositionsTotal() - 1; i >= 0; i--)
                 {
                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                    {
                     PlaySound("Buytrade1.wav"); // Replace "your_sound_file.wav" with the sound file you want to play
                    }
                  else
                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        PlaySound("selltrade1.wav"); // Replace "your_sound_file.wav" with the sound file you want to play
                       }
                 }

              }
            // Send email if Sendemail is true
            if(Sendemail)
              {
               for(int k = PositionsTotal() - 1; k >= 0; k--)
                 {
                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                    {
                     SendMail("New Buy trade detected", "A new trade has been detected."); // Modify the subject and message as needed
                    }
                  else
                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        SendMail("New Sell trade detected", "A new trade has been detected."); // Modify the subject and message as needed
                       }
                 }
              }
            // Send mobile notification if mobilenotification is true
            if(mobilenotification)
              {
               for(int x = PositionsTotal() - 1; x >= 0; x--)
                 {
                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                    {
                     SendNotification("New Buy trade detected"); // Modify the message as needed
                    }
                  else
                     if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                       {
                        SendNotification("New Sell trade detected"); // Modify the message as needed
                       }
                 }

              }
            isNewTradeAlertShown = false; // Reset the flag
           }
         //==========================================================

         if((continuetrail == false && (trailcloseB() == true || trailcloseS() == true)) && trailing_switch == true)
           {
            Comment("EA OUT");
            ExpertRemove();
           }

         //===============================================================
         //====================================================================
         if((continuetrail == true && (trailcloseB() == true || trailcloseS() == true)) && trailing_switch == true)
           {
            Comment("EA IN");
            if(PositionsTotal() < TOTALopen && TOTALopen > 0)
              {
               if(Trading == BUY_ONLY)
                 {
                  BUY(); // Execute buy trades
                 }
               else
                  if(Trading == SELL_ONLY)
                    {
                     SELL(); // Execute sell trades
                    }
              }


            if(TOTALopen == 0)
              {
               if(Trading == BUY_ONLY)
                 {
                  BUY(); // Execute buy trades
                 }
               else
                  if(Trading == SELL_ONLY)
                    {
                     SELL(); // Execute sell trades
                    }
              }
           }

         //==================================
         //=====================================================

         // Check if trading is paused
         if(tradingPaused)
           {
            // Trading is paused, so do not execute any trades
            Print("Trading is paused. Waiting for resume...");
            return;
           }
         if(PositionsTotal() < TOTALopen && TOTALopen > 0)
           {
            if(Trading == BUY_ONLY)
              {
               BUY(); // Execute buy trades
              }
            else
               if(Trading == SELL_ONLY)
                 {
                  SELL(); // Execute sell trades
                 }
           }


         if(TOTALopen == 0)
           {
            if(Trading == BUY_ONLY)
              {
               BUY(); // Execute buy trades
              }
            else
               if(Trading == SELL_ONLY)
                 {
                  SELL(); // Execute sell trades
                 }
           }
         //============================================================
         // Check if trading is paused
         if(bal_p == true && PROFIT() == true && modes == Pause_Until_EA_Restarted_Manually)
           {
            Comment("Trades are paused");
            tradingPaused = true; // Set trading pause flag
           }

         if(tradingPaused)
           {
            Comment("Trades are paused");
            // Trading is paused, so do not execute any trades
            Print("Trading is paused. Waiting for resume...");
            return;
           }
         //==========================================
         else
            if(bal_p == true && PROFIT()==true && modes == Continue_Trading)
              {
               if(PositionsTotal() < TOTALopen && TOTALopen > 0)
                 {
                  if(Trading == BUY_ONLY)
                    {
                     BUY(); // Execute buy trades
                    }
                  else
                     if(Trading == SELL_ONLY)
                       {
                        SELL(); // Execute sell trades
                       }
                 }


               if(TOTALopen == 0)
                 {
                  if(Trading == BUY_ONLY)
                    {
                     BUY(); // Execute buy trades
                    }
                  else
                     if(Trading == SELL_ONLY)
                       {
                        SELL(); // Execute sell trades
                       }
                 }
              }
         //==============================================================
         //=============================================================
         // Check if trading is paused
         if(bal5_ratio == true && Loss() && mode1 == Pause__Until_EA_Restarted_Manually)
           {
            tradingPaused = true; // Set trading pause flag
           }

         if(tradingPaused)
           {
            Comment("Trades are paused Loss");
            // Trading is paused, so do not execute any trades
            Print("Trading is paused. Waiting for resume...");
            return;
           }
         //==========================================
         else
            if(bal5_ratio == true && Loss() && mode1 == Continue__Trading)
              {
               if(PositionsTotal() < TOTALopen && TOTALopen > 0)
                 {
                  if(Trading == BUY_ONLY)
                    {
                     BUY(); // Execute buy trades
                    }
                  else
                     if(Trading == SELL_ONLY)
                       {
                        SELL(); // Execute sell trades
                       }
                 }


               if(TOTALopen == 0)
                 {
                  if(Trading == BUY_ONLY)
                    {
                     BUY(); // Execute buy trades
                    }
                  else
                     if(Trading == SELL_ONLY)
                       {
                        SELL(); // Execute sell trades
                       }
                 }
              }

         //==================================================================

         MaxlossB();
         MaxlossS();
         MaxProfitB();
         MaxProfitS();


         chartcolor();
         if(bal_p == true)
            PROFIT();
         //==============
         if(bal5_ratio == true)
            Loss();
         //==================
         if(Position == Upper_Right && panel == true)
           {
            D1();
            pricact();
           }
         if(Position == Upper_Left && panel == true)
           {
            D1left();
            pricact_left();
           }

         if(trailing_switch == true)
           {
            trail();
           }

        }

      TimeOff();

      //=======================================================================================================

      if(Use == true && closealltradeatstoptime == true && PositionsTotal()>=1 && StringSubstr(hourmin, 0, 5) == closinghour_min)
        {
         //Comment("9999999","    ",StringSubstr(hourmin, 0, 5));
         closeall();
         // ExpertRemove();
        }

      //=============================================
      if(Use == true && pausealltradeatstoptime == true && PositionsTotal()>=1 && StringSubstr(hourmin, 0, 5) == closinghour_min)
        {
         tradingPaused = true;
        }
     }
  }


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
long Spread()
  {
   long spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   if(spread >= Desiredspread)
     {
      //Comment("DESIRED SPREAD EXCEEDED");
     }
   return spread;
  }
//+------------------------------------------------------------------+
void chartcolor()
  {
   ChartSetInteger(_Symbol, CHART_COLOR_BACKGROUND, backgrdd);
  }
//+------------------------------------------------------------------+
void BUY()
  {
//============================
//===========================================================================================================
   double DD1[], DD2[];
   ArraySetAsSeries(DD1, true);
   CopyBuffer(Doch, 1, 0, 3, DD1); // Buffer 1
//======================================================
   ArraySetAsSeries(DD2, true);
   CopyBuffer(Doch, 2, 0, 3, DD2); //Buffer 2
//==========================================================

   double dH = DD1[0];

   double dL = DD2[0];

//Comment(dH, "         ",dL);

//==========================================================

//===========================================================================================================
   double TD2[],TD3[];

   ArraySetAsSeries(TD2, true);

   CopyBuffer(fxam, 0, 0, 3, TD2); // Buffer 2
//======================================================

   ArraySetAsSeries(TD3, true);

   CopyBuffer(fxam, 1, 0, 3, TD3); //Buffer 3
//==========================================================

   double sp = TD2[0];

   double sp1 = TD3[0];

//==================================================
//======================================================


//===========================================================================================================
   double MD0[], MD2[], MD1[], MD3[];
   ArraySetAsSeries(MD0, true);
   CopyBuffer(MACD, 0, 0, 3, MD0); // Buffer 1
//======================================================
   ArraySetAsSeries(MD2, true);
   CopyBuffer(MACD, 2, 0, 3, MD2); //Buffer 2
//==========================================================
//======================================================
   ArraySetAsSeries(MD1, true);
   CopyBuffer(MACD, 1, 0, 3, MD1); //Buffer 2
//==========================================================

//======================================================
   ArraySetAsSeries(MD3, true);
   CopyBuffer(MACD, 3, 0, 3, MD3); //Buffer 2
//==========================================================

   double MH = MD0[1];

   double ML = MD2[1];

   double MY = MD1[1];

   double MZ = MD3[1];


   Comment(ML);


//--------------------------------------------------------------------------

//---------------------------------------------------------------------------
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

//-------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
   double open = iOpen(_Symbol, _Period, 1);
   double closes = iClose(_Symbol, _Period, 1);
   string c = " ";

   if(closes > open)
     {
      c = "buy";
     }
//-----------------------------

   static datetime OT;
   datetime NT[1];

   CopyTime(_Symbol, _Period, 0, 1, NT);


   if(OT != NT[0])
     {
      if(c == "buy" && (ML == 1 || MY == 1) && rangefilter == true)
        {
         //=================================BUY=======================================
         NumTrades = Trade_number;
         for(int k = 0; k < NumTrades; k++)
           {
            if(SL > 0 && TP > 0)
              {
               //=================================BUY===========================================
               Tickets[k] = trade.Buy(lot, NULL, Ask, NormalizeDouble((Ask - SL * _Point), _Digits), NormalizeDouble((Ask + TP * _Point), _Digits), NULL);
              }
            //=====================================================================
            if(SL == 0 && TP == 0)
              {
               //=================================BUY==========================================
               Tickets[k] = trade.Buy(lot, NULL, Ask, 0, 0, NULL);
              }
           }
         //============================================================================
        }
      //======================
      if(c == "buy" && rangefilter == false)
        {
         //=================================BUY=======================================
         NumTrades = Trade_number;
         for(int k = 0; k < NumTrades; k++)
           {
            if(SL > 0 && TP > 0)
              {
               //=================================BUY===========================================
               Tickets[k] = trade.Buy(lot, NULL, Ask, NormalizeDouble((Ask - SL * _Point), _Digits), NormalizeDouble((Ask + TP * _Point), _Digits), NULL);
              }
            //=====================================================================
            if(SL == 0 && TP == 0)
              {
               //=================================BUY===========================================
               Tickets[k] = trade.Buy(lot, NULL, Ask, 0, 0, NULL);
              }
           }
         //============================================================================
        }
     }
   OT = NT[0];

  }
//-------------------------------------------------------------------------------------------------------------
//+------------------------------------------------------------------+
void SELL()
  {
//===========================================================================================================
//===========================================================================================================
   double DD1[], DD2[];
   ArraySetAsSeries(DD1, true);
   CopyBuffer(Doch, 1, 0, 3, DD1); // Buffer 1
//======================================================
   ArraySetAsSeries(DD2, true);
   CopyBuffer(Doch, 2, 0, 3, DD2); //Buffer 2
//==========================================================

   double dH = DD1[0];

   double dL = DD2[0];

//Comment(dH, "         ",dL);
 
//==========================================================

//===========================================================================================================
   double TD2[],TD3[];

   ArraySetAsSeries(TD2, true);

   CopyBuffer(fxam, 0, 0, 3, TD2); // Buffer 2
//======================================================

   ArraySetAsSeries(TD3, true);

   CopyBuffer(fxam, 1, 0, 3, TD3); //Buffer 3
//==========================================================

   double sp = TD2[0];

   double sp1 = TD3[0];

//==================================================
//======================================================


//===========================================================================================================
   double MD0[], MD2[], MD1[], MD3[];
   ArraySetAsSeries(MD0, true);
   CopyBuffer(MACD, 0, 0, 3, MD0); // Buffer 1
//======================================================
   ArraySetAsSeries(MD2, true);
   CopyBuffer(MACD, 2, 0, 3, MD2); //Buffer 2
//==========================================================
//======================================================
   ArraySetAsSeries(MD1, true);
   CopyBuffer(MACD, 1, 0, 3, MD1); //Buffer 2
//==========================================================

//======================================================
   ArraySetAsSeries(MD3, true);
   CopyBuffer(MACD, 3, 0, 3, MD3); //Buffer 2
//==========================================================

   double MH = MD0[1];

   double ML = MD2[1];

   double MY = MD1[1];

   double MZ = MD3[1];

//---------------------------------------------------------------------------
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

//-------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
   double open = iOpen(_Symbol, _Period, 1);
   double closes = iClose(_Symbol, _Period, 1);
   string c = " ";
//-----------------------------
   if(closes < open)
     {
      c = "sell";
     }
//-----------------------------
   static datetime OT;
   datetime NT[1];

   CopyTime(_Symbol, _Period, 0, 1, NT);

   if(OT != NT[0])
     {
      if(c == "sell" && (MH == 1 || MZ == 1) && rangefilter == true)
        {
         //============================================================================
         NumTrades = Trade_number;
         for(int l = 0; l < NumTrades; l++)
           {
            if(SL > 0 && TP > 0)
              {
               //=================================SELL===========================================
               Tickets[l] = trade.Sell(lot, NULL, Bid, NormalizeDouble((Bid + SL * _Point), _Digits), NormalizeDouble((Bid - TP * _Point), _Digits), NULL);
               //==================================SELL==========================================
              }
            //===========================================================================================

            if(SL == 0 && TP == 0)
              {
               //=================================SELL===========================================
               Tickets[l] = trade.Sell(lot, NULL, Bid, 0, 0, NULL);
               //==================================SELL==========================================
              }

           }
        }
      //==============================
      if(c == "sell" && rangefilter == false)
        {
         //============================================================================
         NumTrades = Trade_number;
         for(int l = 0; l < NumTrades; l++)
           {
            if(SL > 0 && TP > 0)
              {
               //=================================SELL===========================================
               Tickets[l] = trade.Sell(lot, NULL, Bid, NormalizeDouble((Bid + SL * _Point), _Digits), NormalizeDouble((Bid - TP * _Point), _Digits), NULL);
               //==================================SELL==========================================
              }
            //===========================================================================================

            if(SL == 0 && TP == 0)
              {
               //=================================SELL===========================================
               Tickets[l] = trade.Sell(lot, NULL, Bid, 0, 0, NULL);
               //==================================SELL==========================================
              }

           }
        }

     }
   OT = NT[0];
  }



//+------------------------------------------------------------------+
double Profit()
  {
   double profits = 0;
//------------------------------------------------------------------------------
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         double profit = PositionGetDouble(POSITION_PROFIT);

         ulong positionticket = PositionGetInteger(POSITION_TICKET);

         profits += profit;

        }
     }
   return (NormalizeDouble((profits), 2));
  }









//==============================================
double MaxlossB()
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
           {
            if(loss != 0)
              {
               if(Ask < PositionGetDouble(POSITION_PRICE_OPEN) && PositionGetDouble(POSITION_PRICE_OPEN) - Ask >= (10*-loss) * _Point)
                 {
                  closeall();
                  Alert("MaxLoss Reached");
                 }
               break;
              }

           }
        }

     }
   return 0;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MaxlossS()
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
           {
            if(loss != 0)
              {
               if(Bid > PositionGetDouble(POSITION_PRICE_OPEN) &&  Bid - PositionGetDouble(POSITION_PRICE_OPEN) >= (10*-loss) * _Point)
                 {
                  closeall();
                  Alert("MaxLoss Reached");
                 }
               break;
              }
           }
        }
     }
   return 0;
  }



//+------------------------------------------------------------------+
//|
double MaxProfitS()
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
           {
            if(gain != 0)
              {
               if(Bid < PositionGetDouble(POSITION_PRICE_OPEN) &&  Bid - PositionGetDouble(POSITION_PRICE_OPEN) >= (10*gain) * _Point)
                 {
                  closeall();
                 }
               break;
              }
           }
        }
     }
   return 0;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MaxProfitB()
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
           {
            if(gain != 0)
              {
               if(Ask > PositionGetDouble(POSITION_PRICE_OPEN) &&  Ask - PositionGetDouble(POSITION_PRICE_OPEN) >= (10*gain) * _Point)
                 {
                  closeall();
                 }
               break;
              }
           }
        }
     }
   return 0;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int weekdayM()
  {
   int date = 0;
   string weekdays = " ";
   if(Monday == true)
     {

      datetime timeds = TimeLocal();
      MqlDateTime structime;
      TimeToStruct(timeds, structime);
      date = structime.day_of_week;


      if(date == 1)
         weekdays = "monday";
     }
   return date;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
int weekdayT()
  {
   int date = 0;
   string weekdays = " ";
   if(Tuesday == true)
     {

      datetime timeds = TimeLocal();
      MqlDateTime structime;
      TimeToStruct(timeds, structime);
      date = structime.day_of_week;


      if(date == 2)
         weekdays = "TUES";
     }
   return date;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
int weekdayW()
  {
   int date = 0;
   string weekdays = " ";
   if(Wednesday == true)
     {

      datetime timeds = TimeLocal();
      MqlDateTime structime;
      TimeToStruct(timeds, structime);
      date = structime.day_of_week;


      if(date == 3)
         weekdays = "wed";
     }
   return date;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
int weekdayTHUR()
  {
   int date = 0;
   string weekdays = " ";
   if(Thursday == true)
     {

      datetime timeds = TimeLocal();
      MqlDateTime structime;
      TimeToStruct(timeds, structime);
      date = structime.day_of_week;

      if(date == 4)
         weekdays = "thurs";
     }
   return date;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int weekdayFri()
  {
   int date = 0;
   string weekdays = " ";
   if(Friday == true)
     {

      datetime timeds = TimeLocal();
      MqlDateTime structime;
      TimeToStruct(timeds, structime);
      date = structime.day_of_week;


      if(date == 5)
         weekdays = "fri";
     }
   return date;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int weekdaysat()
  {
   int date = 0;
   string weekdays = " ";
   if(Saturday == true)
     {

      datetime timeds = TimeLocal();
      MqlDateTime structime;
      TimeToStruct(timeds, structime);
      date = structime.day_of_week;

      if(date == 6)
         weekdays = "sat";
     }
   return date;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int weekdaysun()
  {
   int date = 0;
   string weekdays = " ";
   if(Sunday == true)
     {

      datetime timeds = TimeLocal();
      MqlDateTime structime;
      TimeToStruct(timeds, structime);
      date = structime.day_of_week;


      if(date == 0)
         weekdays = "sun";
     }
   return date;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void D1()
  {
   COLOUR();
//===================
   label1.Create(0, "label1", 0, 480, 20, 75, 40);

   label1.Font("Comic Sans MS");
   label1.Text("PATREX PRO EXECUTOR");
   label1.Color(clrGreenYellow);
   label1.FontSize(14);
//======================================================================
   label2.Create(0, "label2", 0, 425, 60, 35, 60);

   label2.Font("Comic Sans MS");
   label2.Text("Current Time                       " + TimeCurrent());
   label2.Color(clrWhite);
   label2.FontSize(11);

//-----------------------------------------------------------------------
   label3.Create(0, "label3", 0, 425, 90, 35, 80);

   label3.Font("Comic Sans MS");
   label3.Text("Expire Time                         " + end);
   label3.Color(clrWhite);
   label3.FontSize(11);
//=======================================================================
//=========================================================================
   label5.Create(0, "label5", 0, 425, 120, 35, 100);

   label5.Font("Comic Sans MS");
   label5.Text("Total Open Trades             " + PositionsTotal());
   label5.Color(clrWhite);
   label5.FontSize(11);
//=======================================================================

   label8.Create(0, "label8", 0, 425, 150, 35, 120);

   label8.Font("Comic Sans MS");
   label8.Text("Total Open LotSizes          " + openlots());
   label8.Color(clrWhite);
   label8.FontSize(11);

//-----------------------------------------------------------------------
   label9.Create(0, "label9", 0, 425, 180, 35, 140);

   label9.Font("Comic Sans MS");
   label9.Text("Total P/L                             " + DoubleToString(Profitz(), 1) + "pips");//
   label9.Color(clrWhite);
   label9.FontSize(11);

//-----------------------------------------------------------------------
   label6.Create(0, "label6", 0, 425, 210, 35, 160);

   label6.Font("Comic Sans MS");
   label6.Text("Balance/Equity                   " + AccountInfoDouble(ACCOUNT_BALANCE) + " " + AccountInfoString(ACCOUNT_CURRENCY) + " | " + AccountInfoDouble(ACCOUNT_EQUITY) + " " + AccountInfoString(ACCOUNT_CURRENCY));
   label6.Color(clrWhite);
   label6.FontSize(11);

//-----------------------------------------------------------------------
   label10.Create(0, "label10", 0, 425, 240, 35, 180);
   label10.Font("Comic Sans MS");
   label10.Text("Total P/L                             " + DoubleToString(Profit(), 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));
   label10.Color(clrWhite);
   label10.FontSize(11);
//-----------------------------------------------------------------------
   label11.Create(0, "label11", 0, 425, 270, 35, 200);
   label11.Font("Comic Sans MS");
   label11.Text("Spread                                 " + IntegerToString(Spread()));
   label11.Color(clrWhite);
   label11.FontSize(11);
// -----------------------------------------------
   label12.Create(0, "label12", 0, 425, 300, 35, 255);
   label12.Font("Comic Sans MS");
   label12.Text("Manual Control ");
   label12.Color(clrWhite);
   label12.FontSize(12);


   label13.Create(0, "label13", 0, 425, 350, 35, 280);
   label13.Font("Comic Sans MS");
   label13.Text("LET ME DO MY WORK NOW");
   label13.Color(clrYellow);
   label13.FontSize(11);


  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void D1left()
  {

   COLOUR_left();
//===================
   label1.Create(0, "label1", 0, 70, 20, 75, 40);

   label1.Font("Comic Sans MS");
   label1.Text("PATREX PRO EXECUTOR");
   label1.Color(clrGreenYellow);
   label1.FontSize(14);
//======================================================================
   label2.Create(0, "label2", 0, 5, 60, 35, 60);

   label2.Font("Comic Sans MS");
   label2.Text("Current Time                       " + TimeCurrent());
   label2.Color(clrWhite);
   label2.FontSize(11);

//-----------------------------------------------------------------------
   label3.Create(0, "label3", 0, 5, 90, 35, 80);

   label3.Font("Comic Sans MS");
   label3.Text("Expire Time                         " + end);
   label3.Color(clrWhite);
   label3.FontSize(11);
//=======================================================================
//=========================================================================
   label5.Create(0, "label5", 0, 5, 120, 35, 100);

   label5.Font("Comic Sans MS");
   label5.Text("Total Open Trades             " + PositionsTotal());
   label5.Color(clrWhite);
   label5.FontSize(11);
//=======================================================================

   label8.Create(0, "label8", 0, 5, 150, 35, 120);

   label8.Font("Comic Sans MS");
   label8.Text("Total Open LotSizes          " + openlots());
   label8.Color(clrWhite);
   label8.FontSize(11);

//-----------------------------------------------------------------------
   label9.Create(0, "label9", 0, 5, 180, 35, 140);

   label9.Font("Comic Sans MS");
   label9.Text("Total P/L                             " + DoubleToString(Profitz(), 1) + "pips");//
   label9.Color(clrWhite);
   label9.FontSize(11);

//-----------------------------------------------------------------------
   label6.Create(0, "label6", 0, 5, 210, 35, 160);

   label6.Font("Comic Sans MS");
   label6.Text("Balance/Equity                   " + AccountInfoDouble(ACCOUNT_BALANCE) + " " + AccountInfoString(ACCOUNT_CURRENCY) + " | " + AccountInfoDouble(ACCOUNT_EQUITY) + " " + AccountInfoString(ACCOUNT_CURRENCY));
   label6.Color(clrWhite);
   label6.FontSize(11);

//-----------------------------------------------------------------------
   label10.Create(0, "label10", 0, 5, 240, 35, 180);
   label10.Font("Comic Sans MS");
   label10.Text("Total P/L                             " + DoubleToString(Profit(), 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));
   label10.Color(clrWhite);
   label10.FontSize(11);
//-----------------------------------------------------------------------
   label11.Create(0, "label11", 0, 5, 270, 35, 200);
   label11.Font("Comic Sans MS");
   label11.Text("Spread                                 " + IntegerToString(Spread()));
   label11.Color(clrWhite);
   label11.FontSize(11);
// -----------------------------------------------
   label12.Create(0, "label12", 0, 5, 300, 35, 255);
   label12.Font("Comic Sans MS");
   label12.Text("Manual Control ");
   label12.Color(clrWhite);
   label12.FontSize(12);

   label13.Create(0, "label13", 0, 5, 350, 35, 280);
   label13.Font("Comic Sans MS");
   label13.Text("LET ME DO MY WORK NOW");
   label13.Color(clrYellow);
   label13.FontSize(11);


  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void COLOUR_left()
  {

   ObjectCreate(0, "String2", OBJ_RECTANGLE_LABEL, 0, 0, 0, 0, 0);
   ObjectSetInteger(0, "String2", OBJPROP_XDISTANCE, 0);
   ObjectSetInteger(0, "String2", OBJPROP_YDISTANCE, 10);
   ObjectSetInteger(0, "String2", OBJPROP_XSIZE, 530);
   ObjectSetInteger(0, "String2", OBJPROP_YSIZE, 380);
   ObjectSetInteger(0, "String2", OBJPROP_BGCOLOR, backgrd1);
   ObjectSetInteger(0, "String2", OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, "String2", OBJPROP_BORDER_COLOR, clrBlue);
   ObjectSetInteger(0, "String2", OBJPROP_BACK, false);
   ObjectSetInteger(0, "String2", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "String2", OBJPROP_SELECTED, false);
   ObjectSetInteger(0, "String2", OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "String2", OBJPROP_ZORDER, 0);
  }
//------------------------------------------------------
void COLOUR()
  {
   ObjectCreate(0, "String4", OBJ_RECTANGLE_LABEL, 0, 0, 0, 0, 0);
   ObjectSetInteger(0, "String4", OBJPROP_XDISTANCE, 420);
   ObjectSetInteger(0, "String4", OBJPROP_YDISTANCE, 10);
   ObjectSetInteger(0, "String4", OBJPROP_XSIZE, 530);
   ObjectSetInteger(0, "String4", OBJPROP_YSIZE, 380);
   ObjectSetInteger(0, "String4", OBJPROP_BGCOLOR, backgrd1);
   ObjectSetInteger(0, "String4", OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, "String4", OBJPROP_BORDER_COLOR, clrBlue);
   ObjectSetInteger(0, "String4", OBJPROP_BACK, false);
   ObjectSetInteger(0, "String4", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "String4", OBJPROP_SELECTED, false);
   ObjectSetInteger(0, "String4", OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, "String4", OBJPROP_ZORDER, 0);
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---------------------------------------------------------------------------
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
//----------------------------------------------------------------------------------------
//========================================================================================

   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "KILL7")
     {
      trade.Buy(lot, NULL, Ask, NormalizeDouble((Ask - SL * _Point), _Digits), NormalizeDouble((Ask + TP * _Point), _Digits), NULL);
     }

   bool state13 = ObjectSetInteger(0, "KILL7", OBJPROP_STATE, false);

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "KILLER7")
     {
      //=================================SELL===========================================
      trade.Sell(lot, NULL, Bid, NormalizeDouble((Bid + SL * _Point), _Digits), NormalizeDouble((Bid - TP * _Point), _Digits), NULL);
     }
//--------------------------------------------------------------------------------
   bool state14 = ObjectSetInteger(0, " KILLER7", OBJPROP_STATE, false);
//--------------------------------------------------------------------------------
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "KILLEST7")
     {
      closeall();
     }
//--------------------------------------------------------------------------------
   bool state15 = ObjectSetInteger(0, " KILLEST7", OBJPROP_STATE, false);
//-----------------------------------------------------------------------

   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "KILL8")
     {
      // Toggle the tradingPaused flag
      tradingPaused = !tradingPaused;

      // Update the button text based on the new state
      if(tradingPaused)
        {
         Killhedging.Text("Resume");
        }
      else
        {
         Killhedging.Text("Pause");
        }
     }
   bool state7 = ObjectSetInteger(0, "KILL8", OBJPROP_STATE, false);
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
   ChartRedraw(0);
  }
//+------------------------------------------------------------------+


//--------------------------PRICE-ACTION------------------------------
//+------------------------------------------------------------------+
bool pricact()
  {
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
//-----------------------------------------------------------------------
   Killpriceaction.Create(0, "KILL7", 0, 570, 300, 650, 320);
   Killpriceaction.Text("BUY");
   Killpriceaction.Color(clrWhite);
   Killpriceaction.ColorBackground(buy);
//--------------------------------------------------------------------
   Killerpriceaction.Create(0, "KILLER7", 0, 680, 300, 730, 320);
   Killerpriceaction.Text("SELL");
   Killerpriceaction.Color(clrWhite);
   Killerpriceaction.ColorBackground(sell);
//------------------------------------------------------------------------
   Killestpriceaction.Create(0, "KILLEST7", 0, 750, 300, 820, 320);
   Killestpriceaction.Text("Close All");
   Killestpriceaction.Color(clrWhite);
   Killestpriceaction.ColorBackground(closealls);
//----------------------------------------------------------------------------------

// In your OnInit function:
   Killhedging.Create(0, "KILL8", 0, 840, 300, 900, 320);
   Killhedging.Text("Pause");
   Killhedging.Color(clrWhite);
   Killhedging.ColorBackground(pause);
//--------------------------------------------------------------------
   return true;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool pricact_left()
  {
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);

//-----------------------------------------------------------------------
   Killpriceaction.Create(0, "KILL7", 0, 130, 300, 200, 320);
   Killpriceaction.Text("BUY");
   Killpriceaction.Color(clrWhite);
   Killpriceaction.ColorBackground(buy);
//--------------------------------------------------------------------
   Killerpriceaction.Create(0, "KILLER7", 0, 220, 300, 300, 320);
   Killerpriceaction.Text("SELL");
   Killerpriceaction.Color(clrWhite);
   Killerpriceaction.ColorBackground(sell);
//------------------------------------------------------------------------
   Killestpriceaction.Create(0, "KILLEST7", 0, 320, 300, 400, 320);
   Killestpriceaction.Text("Close All");
   Killestpriceaction.Color(clrWhite);
   Killestpriceaction.ColorBackground(closealls);
//----------------------------------------------------------------------------------

   Killhedging.Create(0, "KILL8", 0, 420, 300, 480, 320);
   Killhedging.Text("Pause");
   Killhedging.Color(clrWhite);
   Killhedging.ColorBackground(pause);
//--------------------------------------------------------------------
   return true;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double openlots()
  {
   double lots = 0;
//+------------------------------------------------------------------+
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      //if(_Symbol == symbol)
        {
         if((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) || (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY))
           {
            double Volume = PositionGetDouble(POSITION_VOLUME);
            lots += Volume;
           }
         //---------------------------------------------------------------
        }
     }
   return(NormalizeDouble(lots, 2));
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void closeall()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      //if(_Symbol == symbol)
        {
         if((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) || (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY))
           {

            ulong positionticket = PositionGetInteger(POSITION_TICKET);
            trade.PositionClose(positionticket, 9);

           }
         //---------------------------------------------------------------
        }
     }
  }

//======================
void closeLoss()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      // if(_Symbol == symbol)
        {
         if((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) || (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY))
           {
            if(PositionGetDouble(POSITION_PROFIT) < 0)
              {
               ulong positionticket = PositionGetInteger(POSITION_TICKET);
               trade.PositionClose(positionticket, 9);
              }
           }
         //---------------------------------------------------------------
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void closeProfit()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      //if(_Symbol == symbol)
        {
         if((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) || (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY))
           {
            if(PositionGetDouble(POSITION_PROFIT) > 0)
              {
               ulong positionticket = PositionGetInteger(POSITION_TICKET);
               trade.PositionClose(positionticket, 9);
              }
           }
         //---------------------------------------------------------------
        }
     }
  }
//+------------------------------------------------------------------+
void trail()
  {
   double  MyPoint  =  _Point;
   if(_Digits  ==  3  ||  _Digits  ==  5 || _Digits == 2)
      MyPoint  =  _Point;
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
         if(TrailingStep  >  0)
           {
            if((Ask  -  dExecutedPrice)  > (MyPoint  *  TrailingStart))
              {
               if(OrderStopLoss  < (Ask  -  MyPoint  *  TrailingStart))
                 {
                  trade.PositionModify(PositionTicket, Ask - (TrailingStep  *  MyPoint), OrderTakeProfit);
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
         if(TrailingStep  >  0)
           {
            if((sdExecutedPrice  -  Bid)  > (MyPoint  *  TrailingStart))
              {
               if((sOrderStopLoss  > (Bid  +  MyPoint  *  TrailingStart)) || (sOrderStopLoss  ==  0))
                 {
                  trade.PositionModify(sPositionTicket, Bid + (TrailingStep  *  MyPoint), sOrderTakeProfit);
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
void chckerLoss() //DAILY
  {
   double amt = ((Ap() + Al()) + (comm()*2) + profitclose2()) ;

   datetime localtime = TimeLocal();
   string hourmin = TimeToString(localtime, TIME_MINUTES);

   double acct_balance = AccountInfoDouble(ACCOUNT_BALANCE);

   double result_balance = (bal2_ratio2/100) * acct_balance;

   ulong ticketnumber ;
   long Ordertype;

   double orderprofits = 0;

//------------------------------------------------
   datetime now = TimeCurrent();
   datetime today = (now / 86400) * 86400;

//------------------------------------
   HistorySelect(today, now);

   for(int i = HistoryDealsTotal() - 1; i > 0 ; i--)
     {
      if((ticketnumber = HistoryDealGetTicket(i)) > 0)

        {

         Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);

         double orderprofit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);

         long OrderOpenTime = HistoryDealGetInteger(ticketnumber, DEAL_TIME);

         if(OrderOpenTime < TimeCurrent() - TimeCurrent() % 86400)
           {
            break;
           }


         if(amt < 0 && amt <= -result_balance)
           {
            closeLoss();
           }

        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void chCPROFIT() //DAILY
  {
   double amt = (Ap() + Al() + (comm()*2) + profitclose2());

   datetime localtime = TimeLocal();
   string hourmin = TimeToString(localtime, TIME_MINUTES);

   double acct_balance = AccountInfoDouble(ACCOUNT_BALANCE);

   double result_balance = (bal2_ratio/100) * acct_balance;

   ulong ticketnumber ;
   long Ordertype;

   double orderprofits = 0;

//------------------------------------------------
   datetime now = TimeCurrent();
   datetime today = (now / 86400) * 86400;

//------------------------------------
   HistorySelect(today, now);

   for(int i = HistoryDealsTotal() - 1; i > 0 ; i--)
     {
      if((ticketnumber = HistoryDealGetTicket(i)) > 0)

        {

         Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);

         double orderprofit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);

         long OrderOpenTime = HistoryDealGetInteger(ticketnumber, DEAL_TIME);

         if(OrderOpenTime < TimeCurrent() - TimeCurrent() % 86400)
           {
            break;
           }
         //   Comment(result_balance);

         if(amt > 0 && amt >= result_balance)
           {
            closeProfit();
           }

        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//------------------------------------------------------
void pendelete()
  {
   if(PositionsTotal() < 1 && OrdersTotal() == 1)
     {
      for(int d = OrdersTotal() - 1; d >= 0; d--)
        {
         ulong positionticket1 = OrderGetTicket(d);

         if((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT))
           {
            trade.OrderDelete(positionticket1);
           }

        }
     }
  }
//--------------------------------------------------------------------
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+-------------------------------------------------------------------------------------+
//+-------------------------------------------------------------------------------------+
double Al()
  {
   ulong ticketnumber ;
   long Ordertype;

   double orderprofits = 0;

//------------------------------------------------
   datetime now = TimeCurrent();
   datetime today = (now / 86400) * 86400;

//------------------------------------
   HistorySelect(today, now);

   for(int i = HistoryDealsTotal() - 1; i > 0 ; i--)
     {
      if((ticketnumber = HistoryDealGetTicket(i)) > 0)

        {

         Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);

         double orderprofit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);

         long OrderOpenTime = HistoryDealGetInteger(ticketnumber, DEAL_TIME);


         double commisson = HistoryDealGetDouble(ticketnumber,DEAL_COMMISSION);

         if(OrderOpenTime < TimeCurrent() - TimeCurrent() % 86400)
           {
            break;
           }

         if((HistoryDealGetInteger(ticketnumber, DEAL_ENTRY) == DEAL_ENTRY_OUT) && orderprofit < 0)
           {

            orderprofits = orderprofit + orderprofits;

           }

        }
     }
   return (NormalizeDouble((orderprofits), 4));
  }
//=======================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+-------------------------------------------------------------------------------------+
double Ap()
  {
   ulong ticketnumber ;
   long Ordertype;

   double orderprofits = 0;

//------------------------------------------------
   datetime now = TimeCurrent();
   datetime today = (now / 86400) * 86400;

//------------------------------------
   HistorySelect(today, now);

   for(int i = HistoryDealsTotal() - 1; i > 0 ; i--)
     {
      if((ticketnumber = HistoryDealGetTicket(i)) > 0)

        {

         Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);

         double orderprofit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);

         long OrderOpenTime = HistoryDealGetInteger(ticketnumber, DEAL_TIME);
         double commisson = HistoryDealGetDouble(ticketnumber,DEAL_COMMISSION);

         if(OrderOpenTime < TimeCurrent() - TimeCurrent() % 86400)
           {
            break;
           }

         if((HistoryDealGetInteger(ticketnumber, DEAL_ENTRY) == DEAL_ENTRY_OUT) && orderprofit > 0)
           {

            orderprofits = orderprofit + orderprofits;
           }

        }
     }
   return (NormalizeDouble((orderprofits), 4));
  }
//=======================================================================================
//+-------------------------------------------------------------------------------------+
//---------------------------------------------------------------------
double profitclose2()
  {
   double profits = 0;
//------------------------------------------------------------------------------
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         double profit = PositionGetDouble(POSITION_PROFIT);

         ulong positionticket = PositionGetInteger(POSITION_TICKET);

         profits += profit;

        }
     }
   return (NormalizeDouble((profits), 2));
  }
//+------------------------------------------------------------------+
//+-----------------AMT-DAILY ENDS HERE ------------------------------------------------+
double comm()
  {
   ulong ticketnumber ;
   long Ordertype;

   double orderprofits = 0;

//------------------------------------------------
   datetime now = TimeCurrent();
   datetime today = (now / 86400) * 86400;

//------------------------------------
   HistorySelect(today, now);

   for(int i = HistoryDealsTotal() - 1; i > 0 ; i--)
     {
      if((ticketnumber = HistoryDealGetTicket(i)) > 0)

        {

         Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);

         double orderprofit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);

         long OrderOpenTime = HistoryDealGetInteger(ticketnumber, DEAL_TIME);
         double commisson = HistoryDealGetDouble(ticketnumber,DEAL_COMMISSION);

         if(OrderOpenTime < TimeCurrent() - TimeCurrent() % 86400)
           {
            break;
           }

         if((HistoryDealGetInteger(ticketnumber, DEAL_ENTRY) == DEAL_ENTRY_OUT))
           {

            orderprofits += commisson;
           }

        }
     }
   return (NormalizeDouble((orderprofits), 4));
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Check for new orders                                             |
//+------------------------------------------------------------------+
void CheckNewOrders()
  {
// Loop through all positions
   for(int i = 0; i < PositionsTotal(); i++)
     {
      // Get the ticket of the current position
      ulong ticket = PositionGetTicket(i);
      // Check if the position is new (opened within the last tick)
      if(PositionGetInteger(POSITION_TIME) == TimeCurrent() && !isNewTradeAlertShown)
        {
         // Show pop-up if Showpop is true
         if(Showpop)
           {
            Alert("New trade detected");
           }
         // Play sound if Playsound is true
         if(Playsound)
           {
            PlaySound("your_sound_file.wav"); // Replace "your_sound_file.wav" with the sound file you want to play
           }
         isNewTradeAlertShown = true; // Set the flag to true
         break; // Exit the loop after showing the alert for the first new order
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
bool trailcloseB()
  {
   ulong ticketnumber;
   long Ordertype;
   datetime now = TimeCurrent();
   datetime today = (now / 86400) * 86400;

//------------------------------------
   HistorySelect(0, now);
   for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
     {
      if((ticketnumber = HistoryDealGetTicket(i)) > 0)
        {
         //ticketnumber = HistoryDealGetInteger(DEAL_TICKET);
         Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);
         double profit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);
         double stoploss = HistoryDealGetDouble(ticketnumber, DEAL_SL);
         double openprice = HistoryDealGetDouble(ticketnumber, DEAL_PRICE);
         if((HistoryDealGetInteger(ticketnumber, DEAL_ENTRY) == DEAL_ENTRY_OUT) && (Ordertype == DEAL_TYPE_SELL))
           {
            // Add conditions based on your criteria
            if(profit > 0 && stoploss > openprice)
              {
               return true; // Found a deal meeting the conditions
              }
           }
        }
     }
   return false;
  }

//+------------------------------------------------------------------+
bool trailcloseS()
  {
   ulong ticketnumber;
   long Ordertype;
   datetime now = TimeCurrent();
   datetime today = (now / 86400) * 86400;

//------------------------------------
   HistorySelect(0, now);
   for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
     {
      if((ticketnumber = HistoryDealGetTicket(i)) > 0)
        {
         //ticketnumber = HistoryDealGetInteger(DEAL_TICKET);
         Ordertype = HistoryDealGetInteger(ticketnumber, DEAL_TYPE);
         double profit = HistoryDealGetDouble(ticketnumber, DEAL_PROFIT);
         double stoploss = HistoryDealGetDouble(ticketnumber, DEAL_SL);
         double openprice = HistoryDealGetDouble(ticketnumber, DEAL_PRICE);
         if((HistoryDealGetInteger(ticketnumber, DEAL_ENTRY) == DEAL_ENTRY_OUT) && (Ordertype == DEAL_TYPE_BUY))
           {
            // Add conditions based on your criteria
            if(profit > 0 && stoploss < openprice)
              {
               return true; // Found a deal meeting the conditions
              }
           }
        }
     }
   return false;
  }

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//==============
//=============
bool PROFIT()
  {

   double acct_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double result_balance = (bal2_ratio/100) * acct_balance;

   if(profitclose2() > 0 && profitclose2() >= result_balance)
     {
      // Alert("Close By Balance Profit Activated :", "  ",profitclose2(), "   ",result_balance);
      closeProfit();
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Loss()
  {

   double acct_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double result_balance = (bal2_ratio2/100) * acct_balance;

   if(profitclose2() < 0 && profitclose2() <= -result_balance)
     {
      //Alert("Close By Balance Loss Activated :", "  ",profitclose2(), "   ",result_balance);
      closeLoss();
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Profitz()
  {
   double profits = 0;
// Get the pip value of the symbol
   double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
// Loop through all open positions
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      // Check if the position belongs to the current symbol
      if(_Symbol == symbol)
        {
         // Get the profit of the position
         double profit = PositionGetDouble(POSITION_PROFIT);
         // Convert profit to pips using the pip value
         profits += (profit / pipValue)/100000;
        }
     }
// Normalize the result to 2 decimal places
   return NormalizeDouble(profits, 1);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
void TimeOff()
  {
   if(Preset == true)
     {
      BuypriceSL();
      BuypriceTP();
      SellpriceSL();
      SellpriceTP();
     }
   if(Use == false && (weekdayM() == 1 || weekdayT() == 2 || weekdayW() == 3 || weekdayTHUR() == 4 || weekdayFri() == 5 || weekdaysat() == 6 || weekdaysun() == 0) && Spread() <= Desiredspread)
     {
      //=================
      // Check if a new trade alert should be shown
      if(isNewTradeAlertShown)
        {
         // Show pop-up if Showpop is true
         if(Showpop)
           {
            for(int i = PositionsTotal() - 1; i >= 0; i--)
              {
               if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                 {
                  Alert("Buy trade detected");
                 }
               else
                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                    {
                     Alert("Sell trade detected");
                    }
              }
           }
         // Play sound if Playsound is true
         if(Playsound)
           {
            for(int i = PositionsTotal() - 1; i >= 0; i--)
              {
               if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                 {
                  PlaySound("Buytrade1.wav"); // Replace "your_sound_file.wav" with the sound file you want to play
                 }
               else
                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                    {
                     PlaySound("selltrade1.wav"); // Replace "your_sound_file.wav" with the sound file you want to play
                    }
              }

           }
         // Send email if Sendemail is true
         if(Sendemail)
           {
            for(int k = PositionsTotal() - 1; k >= 0; k--)
              {
               if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                 {
                  SendMail("New Buy trade detected", "A new trade has been detected."); // Modify the subject and message as needed
                 }
               else
                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                    {
                     SendMail("New Sell trade detected", "A new trade has been detected."); // Modify the subject and message as needed
                    }
              }
           }
         // Send mobile notification if mobilenotification is true
         if(mobilenotification)
           {
            for(int x = PositionsTotal() - 1; x >= 0; x--)
              {
               if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                 {
                  SendNotification("New Buy trade detected"); // Modify the message as needed
                 }
               else
                  if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                    {
                     SendNotification("New Sell trade detected"); // Modify the message as needed
                    }
              }

           }
         isNewTradeAlertShown = false; // Reset the flag
        }
      //==========================================================

      if((continuetrail == false && (trailcloseB() == true || trailcloseS() == true)) && trailing_switch == true)
        {
         Comment("EA OUT");
         ExpertRemove();
        }

      //===============================================================
      //====================================================================
      if((continuetrail == true && (trailcloseB() == true || trailcloseS() == true)) && trailing_switch == true)
        {
         Comment("EA IN");
         if(PositionsTotal() < TOTALopen && TOTALopen > 0)
           {
            if(Trading == BUY_ONLY)
              {
               BUY(); // Execute buy trades
              }
            else
               if(Trading == SELL_ONLY)
                 {
                  SELL(); // Execute sell trades
                 }
           }


         if(TOTALopen == 0)
           {
            if(Trading == BUY_ONLY)
              {
               BUY(); // Execute buy trades
              }
            else
               if(Trading == SELL_ONLY)
                 {
                  SELL(); // Execute sell trades
                 }
           }
        }

      //==================================
      //=====================================================

      // Check if trading is paused
      if(tradingPaused)
        {
         // Trading is paused, so do not execute any trades
         Print("Trading is paused. Waiting for resume...");
         return;
        }
      if(PositionsTotal() < TOTALopen && TOTALopen > 0)
        {
         if(Trading == BUY_ONLY)
           {
            BUY(); // Execute buy trades
           }
         else
            if(Trading == SELL_ONLY)
              {
               SELL(); // Execute sell trades
              }
        }


      if(TOTALopen == 0)
        {
         if(Trading == BUY_ONLY)
           {
            BUY(); // Execute buy trades
           }
         else
            if(Trading == SELL_ONLY)
              {
               SELL(); // Execute sell trades
              }
        }
      //============================================================
      // Check if trading is paused
      if(bal_p == true && PROFIT() == true && modes == Pause_Until_EA_Restarted_Manually)
        {
         Comment("Trades are paused");
         tradingPaused = true; // Set trading pause flag
        }

      if(tradingPaused)
        {
         Comment("Trades are paused");
         // Trading is paused, so do not execute any trades
         Print("Trading is paused. Waiting for resume...");
         return;
        }
      //==========================================
      else
         if(bal_p == true && PROFIT()==true && modes == Continue_Trading)
           {

            if(PositionsTotal() < TOTALopen && TOTALopen > 0)
              {
               if(Trading == BUY_ONLY)
                 {
                  BUY(); // Execute buy trades
                 }
               else
                  if(Trading == SELL_ONLY)
                    {
                     SELL(); // Execute sell trades
                    }
              }


            if(TOTALopen == 0)
              {
               if(Trading == BUY_ONLY)
                 {
                  BUY(); // Execute buy trades
                 }
               else
                  if(Trading == SELL_ONLY)
                    {
                     SELL(); // Execute sell trades
                    }
              }
           }
      //==============================================================
      //=============================================================
      // Check if trading is paused
      if(bal5_ratio == true && Loss() && mode1 == Pause__Until_EA_Restarted_Manually)
        {
         tradingPaused = true; // Set trading pause flag
        }

      if(tradingPaused)
        {
         Comment("Trades are paused Loss");
         // Trading is paused, so do not execute any trades
         Print("Trading is paused. Waiting for resume...");
         return;
        }
      //==========================================
      else
         if(bal5_ratio == true && Loss() && mode1 == Continue__Trading)
           {
            if(PositionsTotal() < TOTALopen && TOTALopen > 0)
              {
               if(Trading == BUY_ONLY)
                 {
                  BUY(); // Execute buy trades
                 }
               else
                  if(Trading == SELL_ONLY)
                    {
                     SELL(); // Execute sell trades
                    }
              }


            if(TOTALopen == 0)
              {
               if(Trading == BUY_ONLY)
                 {
                  BUY(); // Execute buy trades
                 }
               else
                  if(Trading == SELL_ONLY)
                    {
                     SELL(); // Execute sell trades
                    }
              }
           }

      //==================================================================

      //------------------------------------------------



      chartcolor();
      if(bal_p == true)
         PROFIT();
      //==============
      if(bal5_ratio == true)
         Loss();
      //==================
      if(Position == Upper_Right && panel == true)
        {
         D1();
         pricact();
        }
      if(Position == Upper_Left && panel == true)
        {
         D1left();
         pricact_left();
        }

      if(trailing_switch == true)
        {
         trail();
        }
     }
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
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
           {
            ulong positionticket = PositionGetInteger(POSITION_TICKET);
            trade.PositionClose(positionticket, 9);

           }
         //---------------------------------------------------------------
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closesell()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
           {
            ulong positionticket = PositionGetInteger(POSITION_TICKET);
            trade.PositionClose(positionticket, 9);
           }
         //---------------------------------------------------------------
        }
     }
  }

//=======
void BuypriceTP()
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double openP = PositionGetDouble(POSITION_PRICE_OPEN);
//------------------------------------------------------------------------------
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
           {
            if(PositionsTotal() >= 1 && Bid - openP >= MaxTPmove *_Point)
              {
               closebuy();
               closesell();
               tradingPaused = true;
               ExpertRemove();
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
void BuypriceSL()
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double openP = PositionGetDouble(POSITION_PRICE_OPEN);
//------------------------------------------------------------------------------
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
           {
            if(PositionsTotal() >= 1 && openP - Ask >= MaxSLmove *_Point)
              {
               closebuy();
               closesell();
               tradingPaused = true;
               ExpertRemove();
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//=======
void SellpriceTP()
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double openP = PositionGetDouble(POSITION_PRICE_OPEN);
//------------------------------------------------------------------------------
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
           {
            if(PositionsTotal() >= 1 && openP - Ask  >= MaxTPmove *_Point)
              {
               closebuy();
               closesell();
               tradingPaused = true;
               ExpertRemove();
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
void SellpriceSL()
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double openP = PositionGetDouble(POSITION_PRICE_OPEN);
//------------------------------------------------------------------------------
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(_Symbol == symbol)
        {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
           {
            if(PositionsTotal() >= 1 && Ask - openP >= MaxSLmove *_Point)
              {
               closebuy();
               closesell();
               tradingPaused = true;
               ExpertRemove();
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void newsfilter()
  {
   if(usenews == true)
     {
      MqlCalendarValue values[];
      datetime startTime = TimeCurrent();
      datetime endTime = startTime + PeriodSeconds(PERIOD_D1);

      if(CalendarValueHistory(values, startTime, endTime))
        {
         int i;
         for(i = 0; i < ArraySize(values); i++)
           {
            MqlCalendarEvent event;
            MqlCalendarCountry country;
            if(CalendarEventById(values[i].event_id, event) && CalendarCountryById(event.country_id, country))
              {
               if(StringFind("USDAUDNZDGBPCADEUR", country.currency) < 0)
                  continue;

               if(event.importance == CALENDAR_IMPORTANCE_HIGH)
                 {
                  string news = country.currency + " " + event.name;
                  entryTime = values[i].time - timeBefore;
                  exitTime = values[i].time + timeAfter;
                  i = i + 1;
                  break;
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
