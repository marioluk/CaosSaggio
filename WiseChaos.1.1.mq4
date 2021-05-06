//+------------------------------------------------------------------+
//|                                                     WiseChaos.1.0 |
//|                                                  Mario Lucangeli |
//|                                         https://www.lucangeli.it |
//+------------------------------------------------------------------+
#property copyright "Mario Lucangeli"
#property link      "https://www.lucangeli.it"
#property version   "1.00"
#property strict

//--- input parameters
input int magnitude=1000; // Magnitudine - Distanza in Pips dalla bocca dell'alligatore
input int shiftAB=10; // shiftABBB apertUra ordine in Ask/Bid
input int FractalLimit=7; // limiteFrattali

input bool UseFirstWiseChaos=true;
input bool UseSecondWiseChaos=true;
input bool UseThirdWiseChaos=true;

input double lotSize=0.01; // Dimensione Ordine
input int magic=03052021; // magic number
string volumeString="";
double stoploss=0;
datetime expiry = TimeCurrent();


double
barAO0=0.0,
barAO1=0.0,
barAO2=0.0,
barAO3=0.0,
barAO4=0.0,
barAO5=0.0;

string volumeString1s="WiseChaos-1 SHORT";
string volumeString1l="WiseChaos-1 LONG";
string volumeString2s="WiseChaos-2 SHORT";
string volumeString2l="WiseChaos-2 LONG";
string volumeString3s="WiseChaos-3 SHORT";
string volumeString3l="WiseChaos-3 LONG";

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int BarsToScan=100;                                //Bars To Scan (10=Last Ten Candles)
input bool UseMagic=true;                               //Filter By Magic Number
input bool EnableTrailingParam=true;                    //Enable Trailing Stop
int OrderOpRetry=5;
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
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   static datetime candletime=0;
   if(candletime!=Time[0]) // che cosa fa???
     {
      expiry=TimeCurrent()+PeriodSeconds(PERIOD_CURRENT); // che cosa fa???
      if(UseFirstWiseChaos)
         FirstWiseChaos();
      if(UseSecondWiseChaos)
         SecondWiseChaos();
      if(UseThirdWiseChaos)
         ThirdWiseChaos();
      if(EnableTrailingParam)
         TrailingStop();
      candletime=Time[0];
     }
//---
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|Primo Uomo Saggio                                                          |
//+------------------------------------------------------------------+
bool FirstWiseChaos()
  {
//---COLORE DELLA BARRA DELL'AO CHE DEVE ESSERE ROSSO PER BULLISH E VERDE PER BERISH ESSENDO UN CONTROTREND{ Green } else { Red }

   barAO1=iAO(Symbol(),0, 1);

//--- PARAMETRI ORDINE
   expiry=TimeCurrent()+PeriodSeconds(PERIOD_CURRENT);

   double
   highBarPrice=iHigh(Symbol(),PERIOD_CURRENT,1), // prezzo più alto del periodo corrente
   lowBarPrice=iLow(Symbol(),PERIOD_CURRENT,1), // prezzo più basso del periodo corrente
   openLevelBuy=highBarPrice,
   stopLossBuy=lowBarPrice;
   SetStoplosses(OP_BUY,stopLossBuy);


   double
   openLevelSell=lowBarPrice,
   stopLossSell=highBarPrice;
   SetStoplosses(OP_BUY,stopLossSell);

//--- questo if è DETERMINANTE ! Divergenza RIALZISTA e angolazione con AO ROSSO
   if(BullishDivergent(1)==true && Magnitude(1)>magnitude*Point && barAO1<barAO2)

     {
      if(AccountFreeMarginCheck(Symbol(),OP_BUY,lotSize)>0)
        {
         if(OrderSend(Symbol(),OP_BUYSTOP,lotSize,openLevelBuy+shiftAB*Point,3,stopLossBuy-shiftAB*Point,0,"Primo Uomo Saggio",magic,expiry,clrGreen))
            closeReverse(OP_SELL);
         Alert(volumeString1l, ", ", Symbol(), ", ", Period());
        }
      else
        {
         Print(volumeString);
        }
     }

//--- questo if è DETERMINANTE ! Divergenza RIBASSISTA e angolazione con AO VERDE
   if(BearishDivergent(1)==true && Magnitude(1)>magnitude*Point && barAO1>barAO2)
     {
      if(AccountFreeMarginCheck(Symbol(),OP_SELL,lotSize)>0)
        {
         if(OrderSend(Symbol(),OP_SELLSTOP,lotSize,openLevelSell-shiftAB*Point,3,stopLossSell+shiftAB*Point,0,"Primo Uomo Saggio",magic,expiry,clrRosyBrown))
            closeReverse(OP_BUY);
         Alert(volumeString1s, ", ", Symbol(), ", ", Period());
        }
      else
        {
         Print(volumeString);
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Secondo Uomo Saggio                                              |
//+------------------------------------------------------------------+
bool SecondWiseChaos()
  {
   barAO0=iAO(Symbol(),0, 0);
   barAO1=iAO(Symbol(),0, 1);
   barAO2=iAO(Symbol(),0, 2);
   barAO3=iAO(Symbol(),0, 3);
   barAO4=iAO(Symbol(),0, 4);
   barAO5=iAO(Symbol(),0, 5);

//--- PARAMETRI ORDINE
   expiry=TimeCurrent()+PeriodSeconds(PERIOD_CURRENT);
//---
   double
   highBarPrice=iHigh(Symbol(),PERIOD_CURRENT,1), // prezzo più alto del periodo corrente
   lowBarPrice=iLow(Symbol(),PERIOD_CURRENT,1), // prezzo più basso del periodo corrente
   openLevelBuy=highBarPrice,
   stopLossBuy=lowBarPrice;
   SetStoplosses(OP_BUY,stopLossBuy);


   double
   openLevelSell=lowBarPrice,
   stopLossSell=highBarPrice;

   SetStoplosses(OP_SELL,stopLossSell);

   if(barAO1>barAO2 && barAO2>barAO3 && barAO3>barAO4 && barAO4<barAO5)
     {
      if(AccountFreeMarginCheck(Symbol(),OP_BUY,lotSize)>0)
        {
         if(OrderSend(Symbol(),OP_BUYSTOP,lotSize,openLevelBuy+shiftAB*Point,3,stopLossBuy-shiftAB*Point,0,"Secondo Uomo Saggio",magic,expiry,clrGreen))
            closeReverse(OP_SELL);
         Alert(volumeString2l, ", ", Symbol(), ", ", Period());
        }
      else
        {
         Print(volumeString);
        }
     }

   if(barAO1<barAO2 && barAO2<barAO3 && barAO3<barAO4 && barAO4>barAO5)
     {
      if(AccountFreeMarginCheck(Symbol(),OP_SELL,lotSize)>0)
        {
         if(OrderSend(Symbol(),OP_SELLSTOP,lotSize,openLevelSell-shiftAB*Point,3,stopLossSell+shiftAB*Point,0,"Secondo Uomo Saggio",magic,expiry,clrRosyBrown))
            closeReverse(OP_BUY);
         Alert(volumeString2s, ", ", Symbol(), ", ", Period());
        }
      else
        {
         Print(volumeString);
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ThirdWiseChaos()
  {

   double
   jaws=iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,1),
   teeth=iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,1),// punto denti dell'allogatore linea rossa
   lips=iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,1);


//For loop to scan the last limiteFrattali candles starting from the oldest and finishing with the most recent
   for(int i=FractalLimit; i>=0; i--)
     {
      //If there is a fractal on the candle the value will be greater than zero and equal to the highest or lowest price
      double fractalUp=iFractals(Symbol(),PERIOD_CURRENT,MODE_UPPER,i);
      double fractalDown=iFractals(Symbol(),PERIOD_CURRENT,MODE_LOWER,i);
      //If there is an upper fractal I store the value and set true the FractalsUp variable

      //--- PARAMETRI ORDINE
      expiry=TimeCurrent()+PeriodSeconds(PERIOD_CURRENT);
      double
      highBarPrice=iHigh(Symbol(),PERIOD_CURRENT,1), // prezzo più alto del periodo corrente
      lowBarPrice=iLow(Symbol(),PERIOD_CURRENT,1), // prezzo più basso del periodo corrente

      openLevelBuy=fractalUp,
      stopLossBuy=fractalStopLossBuy();
      //SetStoplosses(OP_BUY,stopLossBuy);


      double
      openLevelSell=fractalDown,
      stopLossSell=fractalStopLossSell();
      //SetStoplosses(OP_SELL,stopLossSell);


      if(fractalUp!=NULL && Ask>teeth) // && Ask<fractalUp
        {
         if(AccountFreeMarginCheck(Symbol(),OP_BUY,lotSize)>0)
           {
            if(OrderSend(Symbol(),OP_BUYSTOP,lotSize,openLevelBuy+shiftAB*Point,3,stopLossBuy-shiftAB*Point,0,"Terzo Uomo Saggio",magic,expiry,clrGreen))
               closeReverse(OP_SELL);
            Alert(volumeString3l, ", ", Symbol(), ", ", Period());
           }
         else
           {
            Print(volumeString);
           }
        }


      // se esiste il frattale
      //& il prezzo di vendita è sotto ai denti
      // & il prezzo piu basso dell'ultima barra è maggiore al frattale inferiore
      // & il frattale inferiore è minore della mascella
      if(fractalDown!=NULL && Bid<teeth)
        {
         if(AccountFreeMarginCheck(Symbol(),OP_SELL,lotSize)>0)
           {
            if(OrderSend(Symbol(),OP_SELLSTOP,lotSize,openLevelSell-shiftAB*Point,3,stopLossSell+shiftAB*Point,0,"Terzo Uomo Saggio",magic,expiry,clrRosyBrown))
               closeReverse(OP_BUY);
            Alert(volumeString3s, ", ", Symbol(), ", ", Period());
           }
         else
           {
            Print(volumeString);
           }
        }
     }
   return;
  }


//+------------------------------------------------------------------+
//| A bullish divergent bar is a bar that has a lower lowBarPrice and closes |
//| in the top half of the bar.                                      |
//| Integer --> Boolean                                              |
//+------------------------------------------------------------------+
bool BullishDivergent(int bar)
  {
   double lowBarPrice=iLow(Symbol(),PERIOD_CURRENT,bar),
          median=(iHigh(Symbol(),PERIOD_CURRENT,bar)+lowBarPrice)/2;
   if(lowBarPrice<iLow(Symbol(),PERIOD_CURRENT,bar+1)
      && iClose(Symbol(),PERIOD_CURRENT,bar)>median)
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//| A bearish divergent bar is a bar that has a higher highBarPrice and      |
//| closes in the bottom half of the bar.                            |
//| Integer --> Boolean                                              |
//+------------------------------------------------------------------+
bool BearishDivergent(int bar)
  {
   double highBarPrice=iHigh(Symbol(),PERIOD_CURRENT,bar),
          median=(iLow(Symbol(),PERIOD_CURRENT,bar)+highBarPrice)/2;
   if(highBarPrice>iHigh(Symbol(),PERIOD_CURRENT,bar+1)
      && iClose(Symbol(),PERIOD_CURRENT,bar)<median)
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
/* On a bullish divergent bar, we place the buy stop just above the
top of the bullish divergent bar (see B, Figure 9.1) and on the
bearish divergent bar we place our sell stop just below the bottom of
 the bearish divergent bar
Gregory-Williams, Justine. Trading Chaos: Maximize Profits with Proven
Technical Techniques (A Marketplace Book) (Kindle Locations 2852-2854).
Wiley. Kindle Edition.
*/
/*-------------------------------------------------------------------------------------------------------------
Rules for Angulation The question arises as to how to determine precisely whether angulation is present.

With just a bit of practice this determination becomes instantly easy and obvious.
Here are the four simple rules:
1. Begin where the price bars cross or go through the Alligator’s mouth (jaw, teeth, and lips).
2. Draw or imagine a line that follows the Alligator’s mouth. We usually pay attention to the jaw and teeth more
than the lips.
3. Draw or imagine another line that basically follows the edges of the price bars. You would look at the bottom
edge of the prices in an up move and the top edge of the prices on a down move.
4. If those two lines show clearly that they are moving away from each other, you have angulation.

Gregory-Williams, Justine; Williams, Bill M.. Trading Chaos (A Marketplace Book) . Wiley. Edizione del Kindle.
---------------------------------------------------------------------------------------------------------------*/
double Magnitude(int bar)
  {
   double mag=0,
          magJaws=iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,bar),
          magTeeth=iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,bar),
          magLips=iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,bar),
          highBarPrice= iHigh(Symbol(),PERIOD_CURRENT,bar),
          lowBarPrice = iLow(Symbol(),PERIOD_CURRENT,bar);
   if(BullishDivergent(bar)==true && magJaws>magTeeth<magLips)
     {
      mag=magJaws-highBarPrice;
      Comment(StringFormat("Magnitudine: ",mag));
     }
   if(BearishDivergent(bar)==true && magJaws>magTeeth<magLips)
     {
      mag=lowBarPrice-magJaws;
      Comment(StringFormat("Magnitudine: ",mag));
     }
   Comment(StringFormat("Magnitudine: ",mag));
   return mag;
  }
//+------------------------------------------------------------------+
//| Close all of a particular type of order CHE COSA FA????                         |
//+------------------------------------------------------------------+
void closeReverse(int type)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber()==magic)
           {
            if(OrderType()==type)
              {
               double closingPrice=NULL;
               if(type==OP_BUY)
                  closingPrice=Bid;
               if(type==OP_SELL)
                  closingPrice=Ask;
               if(OrderClose(OrderTicket(),OrderLots(),closingPrice,10,clrAzure))
                 {
                  Print("Order Closed");
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Set stoplosses                                                   |
//| Integer                                                          |
//+------------------------------------------------------------------+
void SetStoplosses(int type,double stopLoss)
  {
//Print(__FUNCTION__);
   double    stopLevel=MarketInfo(NULL,MODE_STOPLEVEL)*Point;
   int total = OrdersTotal();
   for(int i = total; i >= 0; i--)
     {
      // Select order to work with
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         // Check if order magic number matches
         if(OrderMagicNumber()==magic)
           {
            if(OrderType()==type && type==OP_BUY)
              {
               if(OrderStopLoss()<stopLoss && stopLoss<Bid-stopLevel)
                 {
                  // Set new stoploss
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),stopLoss,0,0,clrAliceBlue))
                    {
                     Print("Stoploss moved on #",OrderTicket()," to ",stopLoss);
                    }
                 }
              }
            if(OrderType()==type && type==OP_SELL)
              {
               if(OrderStopLoss()>stopLoss && stopLoss>Ask+stopLevel)
                 {
                  // Set new stoploss
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),stopLoss,0,0,clrAliceBlue))
                    {
                     Print("Stoploss moved on #",OrderTicket()," to ",stopLoss);
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double fractalStopLossBuy()
  {
   double fractalDown=0;
   for(int i = 0; i < BarsToScan; i++)
     {
      fractalDown=iFractals(Symbol(),PERIOD_CURRENT,MODE_LOWER,i);
      if(fractalDown>0)
         break;
     }
   double stopLossValue=fractalDown;
   Comment(StringFormat("fractalDown: ",stopLossValue));
   return stopLossValue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double fractalStopLossSell()
  {
   double fractalUp=0;
   for(int i = 0; i < BarsToScan; i++)
     {
      fractalUp=iFractals(Symbol(),PERIOD_CURRENT,MODE_UPPER,i);
      if(fractalUp>0)
         break;
     }
   double stopLossValue=fractalUp;
   Comment(StringFormat("fractalUp: ",stopLossValue));
   return stopLossValue;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrailingStop()
  {
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false)

         if(UseMagic && OrderMagicNumber()!=magic)
            continue;

      double newStopLoss=0;

      double stopLossBuy=fractalStopLossBuy();
      double stopLossSell=fractalStopLossSell();
      double stopLossPrice=OrderStopLoss();

      double Spread=MarketInfo(NULL,MODE_SPREAD)*MarketInfo(NULL,MODE_POINT);
      double StopLevel=MarketInfo(NULL,MODE_STOPLEVEL)*MarketInfo(NULL,MODE_POINT);

      // posizione long BUY
      if(OrderType()==OP_BUY && stopLossBuy<MarketInfo(NULL,MODE_BID)-StopLevel)
        {
         newStopLoss=stopLossBuy;
         if(newStopLoss>stopLossPrice+StopLevel || stopLossPrice==0)
           {
            ModifyOrder(OrderTicket(),OrderOpenPrice(),newStopLoss);
           }

        }

      //posizione short vendo SELL
      if(OrderType()==OP_SELL && stopLossSell>MarketInfo(NULL,MODE_ASK)+StopLevel+Spread)
        {
         newStopLoss=(stopLossSell);
         if(newStopLoss<stopLossPrice-StopLevel || stopLossPrice==0)
           {
            ModifyOrder(OrderTicket(),OrderOpenPrice(),newStopLoss);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ModifyOrder(int Ticket, double OpenPrice, double stopLossPrice)
  {
   if(OrderSelect(Ticket,SELECT_BY_TICKET)==false)

      for(int i=1; i<=OrderOpRetry; i++)
        {
         bool res=OrderModify(Ticket,OpenPrice,stopLossPrice,0,0,Blue);
         if(res)
           {
            Print("TRADE - UPDATE SUCCESS - Order ",Ticket," new stop loss ",stopLossPrice," new take profit ");
            break;
           }
        }
   return;
  }

//+------------------------------------------------------------------+
//| FINE
//+------------------------------------------------------------------+
/*
note: to do
bullish e berish divergenze devono chiudere ordine anche se no angolazione
ogni ordine di segno opposto deve chiudere posizione posizionando stop su ultima barra(1)
ordine chiuso se tocca i denti dell'alligatore

se tre barre consegutive dello stesso colore spostare TS su ultima barra e non fare piu ts con frattali
*/
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
