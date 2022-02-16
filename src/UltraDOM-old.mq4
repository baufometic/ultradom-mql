//===============================================================================================================================================
//======================================================== BEGIN PROGRAM ========================================================================
////=============================================================================================================================================
#property strict
#property icon          "ProgramIcon.ico";
#property link          "http://www.TradingWarfare.com"
#property copyright     "www.TradingWarfare.com"
#property description   "Created by Trading Warfare"

#property description "_________________________________________"
#property description "\n\n!! WARNING -- WARNING -- WARNING -- WARNING -- WARNING !!"
#property description "\nThis program will reformat your chart and remove ALL of your objects"
#property description "Press cancel to use a different template"

//==================== GRAPHICS ==================== //x
#resource "\\EmbeddedFiles\\Images\\Graphics\\WaterBottleBlue.bmp";
#resource "\\EmbeddedFiles\\Images\\Graphics\\WaterBottleRed.bmp";
#resource "\\EmbeddedFiles\\Images\\Graphics\\Bull.bmp";
#resource "\\EmbeddedFiles\\Images\\Graphics\\Iceberg.bmp";
#resource "\\EmbeddedFiles\\Images\\Graphics\\Logo.bmp";
#resource "\\EmbeddedFiles\\Images\\Graphics\\Prototype.bmp";

//==================== SOUNDS ==================== //x
#resource "\\EmbeddedFiles\\Sounds\\BuyLaser.wav";
#resource "\\EmbeddedFiles\\Sounds\\ConfirmationBeep.wav";
#resource "\\EmbeddedFiles\\Sounds\\EnableTheHotkeys.wav";
#resource "\\EmbeddedFiles\\Sounds\\LoadingSound.wav";
#resource "\\EmbeddedFiles\\Sounds\\OrderFailed.wav";
#resource "\\EmbeddedFiles\\Sounds\\Screenshot.wav";
#resource "\\EmbeddedFiles\\Sounds\\SellLaser.wav";
#resource "\\EmbeddedFiles\\Sounds\\UIClick.wav";
#resource "\\EmbeddedFiles\\Sounds\\UIText.wav";
#resource "\\EmbeddedFiles\\Sounds\\UITextDelete.wav";
#resource "\\EmbeddedFiles\\Sounds\\WarfareLoading.wav";
#resource "\\EmbeddedFiles\\Sounds\\Water.wav";

//================================================================ EXTERNAL VARIABLES ================================================================
bool     FastLoad                   = true;              // Developer Mode


extern double  MaximumPositionSize  = 0.1;            //Max Position Size (Lots)
extern double  Lots                 = 0.1;            //Trade Size (Lots)
extern int     StopLossPips         = 3;              //Stop Loss  (Pips)
extern int     TakeProfitPips       = 10;             //Take Profit (Pips)
extern int     Slippage             = 1;              //Maximum Slippage (Pips)

extern color   CandleColourUp       = C'24,202,230';  //Bullish Candle Colour
extern color   CandleColourDown     = C'24,202,230';  //Bearish Candle Colour
extern color   ChartLineColour      = C'24,202,230';  //Chart Line Colour

bool     ChartIsVisible             = true;

bool     DOMEnabled                 = true;
bool     SoundsEnabled              = true;
bool     HotkeysEnabled             = false;
bool     HotkeySplashEnabled        = false;
bool     WaterReminderSound         = true;

bool     BalanceIsVisible           = true;
bool     BrokerIsVisible            = true;
bool     AccountIsVisible           = true;

bool     PsychosEnabled             = true;  bool PsychosEnabledPrior         = PsychosEnabled;
bool     FractalsEnabled            = true;  bool FractalsEnabledPrior        = FractalsEnabled;
bool     PriceLinesEnabled          = true;  bool PriceLinesEnabledPrior      = PriceLinesEnabled;
bool     HigherTFCandlesEnabled     = true;  bool HigherTFCandlesEnabledPrior = HigherTFCandlesEnabled;

//==================== FRACTALS ====================
int      FractalFirstHop            = 1;
int      FractalSecondHop           = 2;
int      FractalTF                  = 1;

//==================== TIMER & LOOPS ====================
bool     ProgramLoaded              = false;
datetime ProgramStartTime           = 0;
int      NoOfPairs                  = 0;

bool     LoopTimer                  = 0;
int      TimerSpeed                 = 1; //MAIN LOOP
ulong    CurrentLoopIterations      = 0;
ulong    PreviousLoopIterations     = 0;

ulong    LoopStarted                = 0;
ulong    LoopTime                   = 0;

uint     myGetTickCount             = 0; //using primes
int      CurrentSecond              = 0;

//==================== PANEL SIZING ====================
long     ThisChart                  = ChartID();
int      ChartHeight                = 0;
int      ChartWidth                 = 0;
int      ChartCentreX               = 0;
int      ChartCentreY               = 0;

//==================== VISUALS ====================
// COLOURS
color    White255                   = C'255,255,255';
color    TronOrange                 = C'223,116,12';
color    TronBlue                   = C'111,195,223';
color    TronYellow                 = C'255,230,77';
color    TronVividBlue              = C'24,202,230';
color    TronWhite                  = C'230,255,255';
color    TronGray                   = C'12,20,31';
color    OrangeGlow                 = C'250,160,85';

color    GridPairNameColour         = TronVividBlue;
color    GridPhaseColour            = TronWhite;
color    GridSpeedColour            = TronWhite;
color    GridPriceBidColour         = clrRed;
color    GridPriceSpreadColour      = TronBlue;
color    GridPriceAskColour         = clrGreenYellow;

// FONTS
string   Font                       = "";
int      FontSize                   = 0;

string   OCR                        = "OCR A Extended";
string   BankGothic                 = "BankGothic";
string   Eurostile                  = "Eurostile URW";
string   Digital                    = "Digital dream Fat Narrow"; //Fat, Fat Narrow

//==================== VARIABLES ====================
int      i, j, k, l, m              = 0;
int      iPAIR                      = 0;
string   str, str2                  = "";
string   name                       = "";
string   FileName                   = "";
datetime Offset                     = 0;

string   me                         = "";
color    myColour                   = 0;
int      myHeight, myWidth          = 0;
int      myXDist, myYDist           = 0;
int      myXSize, myYSize           = 0;
double   Highest, Lowest            = 0;
int      HighestBar, LowestBar      = 0;
string   BidString, AskString, SecondHalf = "";
int      TickTimeInt                = 0;
string   TickTimeStr                = "";
string   myText                     = "";
int      TotalHeight                = 0;
   
//==================== PRICING ====================
int      PairInformation[][3];
#define  POINT                      0
#define  DIGITS                     1
#define  MULTIPLIER                 2

string   PairNames[];

double   TickData[][100000][5];                //NoOfPairs //NoOfTicks //Bid...Ask...Volume...Time...TradeDirection
#define  BID                        0
#define  ASK                        1
#define  VOLUME                     2
#define  TIME                       3
#define  TRADEDIRECTION             4

string   TradePriceStrings[][1000000];
int      TickDataCount[];
double   PreviousPrices[][3];                   //NoOfPairs //BidAskVolume

int      TICKLOG[];                             //CSV FILE HANDLES

//==================== TRADING ====================
double   LongLots, ShortLots        = 0;
double   LongPrice, ShortPrice      = 0;

double   LongStop, ShortStop        = 0;
double   LongTP, ShortTP            = 0;
   
bool     SelectOrder                = false;
int      Ticket                     = 0;

double   StopLoss                   = 0;
double   TakeProfit                 = 0;
long     TicketTime                 = GetTickCount();

#define  PRICE                      0
#define  SIZE                       1

//==================== TIME AND SALES ====================
#define  TimeAndSalesLevels         30
string   TimeAndSalesLabels[TimeAndSalesLevels];

color    TimeSales_TickVolColour    = TronWhite;
color    TimeSales_TimeColour       = TronBlue;
color    TimeAndSalesColour         = 0;

//==================== MULTI MARKET GRID ====================
string   GridPairName[];
string   GridPhase[];
string   GridSpeed[];
string   GridPriceBid[];
string   GridPriceAsk[];
string   GridPriceSpread[];

double   CurrentBid, CurrentAsk     = 0;
double   CurrentVolume              = 0;
ulong    TotalTicksCounted          = 0;
datetime CurrentTime                = 0;
bool     SpeedFound                 = false;

// ----- MISC -----
bool     HigherTFCreated            = false;
bool     PriceLinesCreated          = false;
bool     ScreenshotActive           = false;
datetime ScreenshotTime             = 0;
string   PsychoChartAdjuster        = "";

datetime WaterBottleNextTime        = 0;

//==================== HOTKEY LABEL ====================
#define  HotkeyLabelIterations      50
string   HotkeyLabelColours[HotkeyLabelIterations];
int      HotkeyLabelCurrentIteration= 0;
bool     HotkeyLoopEnabled          = false;

//================================================================ INIT / DEINIT ================================================================
void OnInit() {
   if (  (UninitializeReason() == REASON_CHARTCHANGE)  ||  (UninitializeReason() == REASON_PARAMETERS)  )
      return;
   
   if (!IsExpertEnabled()) {
      MessageBox("AUTOMATED TRADING IS DISABLED.\n\nCertain functionality like hotkeys will not work, so please enable Automated Trading and restart.\n\nTools > Options > Expert Advisors... Allow Automated Trading", "ENABLE AUTOMATED TRADING", 0);
      ExpertRemove();
      return;
   }
   
   MathSrand(GetTickCount());
   InitialiseProgram();
   LoopTimer = EventSetMillisecondTimer(TimerSpeed);
}

void OnDeinit(const int reason) {
   bool RemoveProgram = false;
   switch(UninitializeReason()) {
      case REASON_PROGRAM:    RemoveProgram = true  ; break;  //<--- ExpertRemove called        0
      case REASON_REMOVE:     RemoveProgram = true  ; break;  //<--- Removed from chart         1
      case REASON_RECOMPILE:  RemoveProgram = true  ; break;  //<--- Recompiled                 2
      case REASON_CHARTCHANGE:RemoveProgram = false ; break;  //<--- Chart changed              3
      case REASON_CHARTCLOSE: RemoveProgram = true  ; break;  //<--- Chart closed               4
      case REASON_PARAMETERS: RemoveProgram = false ; break;  //<--- Input parameters changed   5
      case REASON_ACCOUNT:    RemoveProgram = true  ; break;  //<--- Account changed            6
      case REASON_TEMPLATE:   RemoveProgram = true  ; break;  //<--- Template changed           7
      case REASON_INITFAILED: RemoveProgram = true  ; break;  //<--- Initialisation failed      8
      case REASON_CLOSE:      RemoveProgram = true  ; break;  //<--- Platform closed            9
   }
   
   if (RemoveProgram) {
      EventKillTimer();
      CloseTickDataFiles();
      RemoveEverything();
   }
}

//================================================================ CHART EVENTS ================================================================
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   
   //==================== CHART CHANGED ====================
   if (id == CHARTEVENT_CHART_CHANGE) {
      RefitItems();
   }
   
   //==================== ITEM CLICKED [sparam] ====================
   
   if (id == CHARTEVENT_OBJECT_CLICK) {
      // BALANCE
      if (sparam == "BalanceLabel")
         ToggleBalanceVisibility();
   
      // BROKER
      else if (sparam == "BrokerNameLabel")
         ToggleBrokerVisibility();
      
      // ACCOUNT
      else if (sparam == "AccountNameLabel")
         ToggleAccountVisibility();
         
      // ULTRADOM LOGO (ENABLES DOM TEMPORARILY)
      else if (sparam == "prototype_logo")
         ToggleDOMVisibility();
   }
   
   //==================== KEYS PRESSED [lparam] ====================
   if (id == CHARTEVENT_KEYDOWN) {
      switch(lparam) {
         // TOGGLE HOTKEYS
         case 72: if (HotkeysEnabled == true) {                                     // H
                     Sound("UIClick");
                     HotkeysEnabled = false;
                  } else {
                     HotkeysEnabled = true;
                     Sound("ConfirmationBeep");
                  }
                  return;
      }

      switch(lparam) {
         // ORDER SENDING
         case 73: BuyAtMarket();                                        break;      // I
         case 75: SellAtMarket();                                       break;      // K
         case 88: CloseAllAndCancel();                                  break;      // X
         case 67: CancelAll();                                          break;      // C
                  
         // WATER BOTTLE  // W
         case 87: Sound("UIClick");
                  UpdateBitmap("WaterBottle", "Graphics\\WaterBottleBlue");
                  WaterBottleNextTime = TimeCurrent() + (15 * 60);   //15 = WaterFrequencyInMinutes
                  break;

         // CHART VISIBILITY  // Z
         case 90: if (ChartIsVisible)
                     ToggleChartVisibility(false);
                  else
                     ToggleChartVisibility(true);
                  
                  
         // SOUNDS  // S
         case 83: if (SoundsEnabled == true) {
                     Sound("UIClick");
                     SoundsEnabled = false;
                  } else {
                     SoundsEnabled = true;
                     Sound("UIClick");
                  }
                  break;
         
         // PSYCHOS  // P
         case 80: if (PsychosEnabled == true) {
                     Sound("UIClick");
                     PsychosEnabled = false;
                     DeleteObjectsByPrefix("PsychoLine");
                  } else {
                     Sound("UIClick");
                     PsychosEnabled = true;
                     CreatePsychoLines();
                  }
                  break;
         
         // FRACTALS  // F
         case 70: if (FractalsEnabled == true) {
                     Sound("UIClick");
                     FractalsEnabled = false;
                     DeleteObjectsByPrefix("Fractal");
                     DeleteObjectsByPrefix("Trend");
                  } else {
                     Sound("UIClick");
                     FractalsEnabled = true;
                     CreateFractals();
                  }
                  break;
         
         // PRICE LINES  // R
         case 82: if (PriceLinesEnabled == true) {
                     Sound("UIClick");
                     PriceLinesEnabled = false;
                     DeleteObjectsByPrefix("PriceLines");
                  } else {
                     Sound("UIClick");
                     PriceLinesEnabled = true;
                     CreatePriceLines();
                  }
                  break;
         
         // HIGHER TF CANDLES  // T
         case 84: if (HigherTFCandlesEnabled == true) {
                     Sound("UIClick");
                     HigherTFCandlesEnabled = false;
                     DeleteObjectsByPrefix("HigherTF");
                  } else {
                     Sound("UIClick");
                     HigherTFCandlesEnabled = true;
                     CreateHigherTFCandles();
                  }
                  break;
         
         // SCREENSHOTS  // 2
         case 50: FileName = StringConcatenate("SCREENSHOTS\\", Symbol(), " ", DateTimeToString(), ".png");
                  GetChartSize();
                  ChartScreenShot(0, FileName, ChartWidth, ChartHeight);
                  CreateLabel("ScreenshotConfirmation", "SCREENSHOT CAPTURED", OCR, 20, CORNER_LEFT_LOWER, ANCHOR_LEFT_LOWER, 10, 10, clrGreenYellow);
                  ScreenshotActive = true;
                  ScreenshotTime = TimeLocal();
                  break;                                    
         
         // FRACTAL TIMEFRAME HOPPING
         case 53: Sound("UIClick"); FractalFirstHop = 1; FractalTF = PreviousFractalTimeframe(); break;      // 5
         case 54: Sound("UIClick"); FractalFirstHop = 1; FractalTF = NextFractalTimeframe();     break;      // 6
                  
         // PAIR CYCLING
         case 57: Sound("UIClick"); PreviousPair();                      break;      // 9
         case 48: Sound("UIClick"); NextPair();                          break;      // 0
         
         // TIMEFRAME CYCLING
         case 55: Sound("UIClick"); PreviousTimeframe();                 break;      // 7
         case 56: Sound("UIClick"); NextTimeframe();                     break;      // 8
      }
   }
}

//================================================================ MAIN LOOP ================================================================
bool  PERF_TRACKING     = false;
int   PERF_TIMER        = 0;
long  PERF_ITERATIONS   = 0;

void OnTimer() {
   if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] ", " STARTED AT: ", GetTickCount()));

   CurrentLoopIterations++;
   myGetTickCount          = GetTickCount();
   CurrentTime             = TimeLocal();
   
   // PROGRESS BAR
   LoopTime = (GetTickCount() - LoopStarted);
   UpdateText("ProgressBarStatus", StringConcatenate(AddIntegerCommas(CurrentLoopIterations), " | ", TotalTicksCounted, " TICKS | ", LoopTime, "ms"));
   LoopStarted = GetTickCount();
   
   for (iPAIR = 0; iPAIR <= NoOfPairs; iPAIR++) {
      // UPDATE PRICE OF CURRENT CHART
      PERF_TIMER = GetTickCount();
      
      RefreshRates();
      if (Symbol() == PairNames[iPAIR]) {
         UpdatePriceLines();
      }
      
      if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] PRICE LINES: ", PairNames[iPAIR], " ", (GetTickCount() - PERF_TIMER)));
      
      // CURRENT PRICES
      PERF_TIMER = GetTickCount();
      
      CurrentBid       = SymbolInfoDouble(PairNames[iPAIR], SYMBOL_BID);
      CurrentAsk       = SymbolInfoDouble(PairNames[iPAIR], SYMBOL_ASK);
      CurrentVolume    = (1.0 * iVolume(PairNames[iPAIR], PERIOD_D1, 0));
      BidString        = DoubleToStr(CurrentBid, PairInformation[iPAIR, DIGITS]);
      AskString        = DoubleToStr(CurrentAsk, PairInformation[iPAIR, DIGITS]);
      
      if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] BID ASK: ", (GetTickCount() - PERF_TIMER)));
      
      // VOLUME HAS INCREASED
      PERF_TIMER = GetTickCount();
      
      if (CurrentVolume > PreviousPrices[iPAIR, VOLUME]) {
         TotalTicksCounted++;
         TickDataCount[iPAIR]++;
         ulong ThisTick = TickDataCount[iPAIR];
         
         TickData[iPAIR, ThisTick, BID]      = CurrentBid;
         TickData[iPAIR, ThisTick, ASK]      = CurrentAsk;
         TickData[iPAIR, ThisTick, VOLUME]   = CurrentVolume;
         TickData[iPAIR, ThisTick, TIME]     = CurrentTime;
         
         if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] VOLUME SECTION - TICK ARRAY: ", (GetTickCount() - PERF_TIMER)));
         
         //===== DEFINE AGGRESSOR IN TRADE =====
         PERF_TIMER = GetTickCount();
         
         if        (CurrentAsk > PreviousPrices[iPAIR, ASK]) {    //LIFTING THE OFFER        -BULLISH STRONG
            TickData[iPAIR, ThisTick, TRADEDIRECTION] = 2;
         
         } else if (CurrentBid > PreviousPrices[iPAIR, BID]) {    //ADDING LIMITS AT BID     -BULLISH WEAK
            TickData[iPAIR, ThisTick, TRADEDIRECTION] = 1;
         
         } else if (CurrentAsk < PreviousPrices[iPAIR, ASK]) {    //ADDING LIMITS AT OFFER   -BEARISH WEAK
            TickData[iPAIR, ThisTick, TRADEDIRECTION] = -1;
            
         } else if (CurrentBid < PreviousPrices[iPAIR, BID]) {    //HITTING THE BID          -BEARISH STRONG
            TickData[iPAIR, ThisTick, TRADEDIRECTION] = -2;
         }
         
         if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] VOLUME SECTION - AGGRESSOR: ", (GetTickCount() - PERF_TIMER)));
         
         //===== MARKET SPEED =====
         PERF_TIMER = GetTickCount();
         
         Highest     = iHigh(PairNames[iPAIR], 1, 0);
         Lowest      = iLow(PairNames[iPAIR], 1, 0);
         HighestBar  = 0;
         LowestBar   = 0;
         SpeedFound  = false;
         
         i = 0;
         while (  (!SpeedFound) && (!IsStopped())  ) {
            
            if (iHigh(PairNames[iPAIR], 1, i) > Highest) {
               Highest = iHigh(PairNames[iPAIR], 1, i);
               HighestBar = i;
            }
            
            if (iLow(PairNames[iPAIR], 1, i) < Lowest) {
               Lowest = iLow(PairNames[iPAIR], 1, i);
               LowestBar = i;
            }
            
            if (i > 30) {
               SpeedFound = true;
               myColour = clrRed;
               str = "30+";
               
               if (Symbol() == PairNames[iPAIR]) {
                  me = "MarketSpeedLabel";
                  UpdateText(me, str);
                  UpdateTextColour(me, myColour);
               }
               
               UpdateText(GridSpeed[iPAIR], str);
               UpdateTextColour(GridSpeed[iPAIR], myColour);
               
            } else if (((Highest - Lowest) * PairInformation[iPAIR, MULTIPLIER]) > 10) {
               SpeedFound = true;
               
               if ((i - 1) > 10)       myColour = clrRed;
               else if ((i - 1) < 5)   myColour = clrChartreuse;
               else                    myColour = clrGreenYellow;
               
               str = StringConcatenate(i, "M");
               
               if (Symbol() == PairNames[iPAIR]) {
                  me = "MarketSpeedLabel";
                  UpdateText(me, str);
                  UpdateTextColour(me, myColour);
               }
               
               UpdateText(GridSpeed[iPAIR], str);
               UpdateTextColour(GridSpeed[iPAIR], myColour);
            }
            
            i++;
         }
         
         if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] VOLUME SECTION - MARKET SPEED: ", (GetTickCount() - PERF_TIMER)));
         
         //========== TIME AND SALES ==========
         PERF_TIMER = GetTickCount();
         
         if (Symbol() == PairNames[iPAIR]) {   
            int BuyersCount   = 0;
            int SellersCount  = 0;
               
            for (i = 0; i <= (TimeAndSalesLevels-1); i++) {
            
               if (i >= ThisTick)
                  break;
               
               // ADD '0' to TIME COLUMN FOR EVEN SPACING   
               TickTimeInt = TimeSeconds(TickData[iPAIR, ThisTick-i, TIME]);
               TickTimeStr = "";
               
               if (TickTimeInt < 10) {
                  TickTimeStr = StringConcatenate("0", TickTimeInt);
               } else {
                  TickTimeStr = IntegerToString(TickTimeInt);
               }
                  
               str = StringConcatenate(TickTimeStr, " ", TwoDigitPrice(iPAIR, TickData[iPAIR, ThisTick-i, BID], TickData[iPAIR, ThisTick-i, ASK]) );
               
               UpdateText(TimeAndSalesLabels[i], str);
               
               int Direction     = TickData[iPAIR, ThisTick-i, TRADEDIRECTION];
               switch(Direction) {
                  case 2:  TimeAndSalesColour = clrGreenYellow;   BuyersCount++;   break; //BULLISH STRONG
                  case 1:  TimeAndSalesColour = clrSeaGreen;      BuyersCount++;   break; //BULLISH WEAK
                  case -1: TimeAndSalesColour = clrIndianRed;     SellersCount++;  break; //BEARISH WEAK
                  case -2: TimeAndSalesColour = clrRed;           SellersCount++;  break; //BEARISH STRONG
               }
               
               ObjectSetInteger(0, TimeAndSalesLabels[i], OBJPROP_COLOR, TimeAndSalesColour);
            }
         }
         
         if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] VOLUME SECTION - TIMESALES: ", (GetTickCount() - PERF_TIMER)));
         
         //UPDATE NEW VOLUME THRESHOLD
         PreviousPrices[iPAIR, VOLUME] = CurrentVolume;
         
         // LOG THE TICK TO CSV FILE
         PERF_TIMER = GetTickCount();
         
         str = StringConcatenate(CurrentTime, ",",
                                 myGetTickCount, ",",
                                 CurrentBid, ",",
                                 CurrentAsk, ",",
                                 CurrentVolume);
         
         FileWrite(TICKLOG[iPAIR], str);
         FileFlush(TICKLOG[iPAIR]);
         
         if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] VOLUME SECTION - FILEWRITE: ", (GetTickCount() - PERF_TIMER)));
      }
            
      //UPDATE PRICE IF CHANGED
      PERF_TIMER = GetTickCount();
      
      if (CurrentBid != PreviousPrices[iPAIR, BID]) {
         PreviousPrices[iPAIR, BID] = CurrentBid;
      }
      
      if (CurrentAsk != PreviousPrices[iPAIR, ASK]) {
         PreviousPrices[iPAIR, ASK] = CurrentAsk;
      }
      
      if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] VOLUME SECTION - UPDATE PRICE ", (GetTickCount() - PERF_TIMER)));
   }
   
   if (PERF_TRACKING) Print(StringConcatenate("LOOP [", PERF_ITERATIONS, "] VOLUME SECTION OVERALL: ", (GetTickCount() - PERF_TIMER)));
   
   
   // DO EVERY SECOND
   if (TimeSeconds(TimeLocal()) != CurrentSecond) {
      CreatePsychoLines();
      CreateFractals();
      UpdateMarketPhases();
      UpdateExecutionInfo();
      
      // WATER BOTTLE
      if (TimeCurrent() >= WaterBottleNextTime) {
         UpdateBitmap("WaterBottle", "Graphics\\WaterBottleRed");
         WaterBottleNextTime = TimeCurrent() + (15 * 60);
         if (WaterReminderSound)
            Sound("Water");
      }
      
      // CLOCK
      UpdateText("ClockLabel", TimeToStr(TimeLocal(), TIME_SECONDS));
      ObjectSetInteger(0, "ClockLabel", OBJPROP_XDISTANCE, (ChartCentreX - (GetTextWidth("ClockLabel") * 0.5)));
      
      // SESSION DURATION
      UpdateText("SessionDurationLabel", "SESSION: " + StringConcatenate(TimeToStr((TimeLocal() - ProgramStartTime), TIME_SECONDS)));
      SetXDist("SessionDurationLabel", (ChartCentreX - (GetTextWidth("SessionDurationLabel") * 0.5)));
      
      // SCREENSHOT LABEL
      if (  (ScreenshotActive)  &&  ((TimeLocal() - ScreenshotTime) >= 2)  ) {
         ObjectDelete("ScreenshotConfirmation");
         ScreenshotActive = false;
      }
      
      // MOVE CHART
      int Gap = GetShapeXDistance("ExecutionModeLabel") + GetTextWidth("ExecutionModeLabel") + 150;
      int Total = ChartWidth;
      double Diff =  ((NormalizeDouble(Gap, 2) / NormalizeDouble(Total, 2)) * 100);
      ChartSetDouble(0, CHART_SHIFT_SIZE, Diff);
      
      CurrentSecond = TimeSeconds(TimeLocal());
   }
      
   // HOTKEY LABEL LOOP
   if (HotkeyLoopEnabled) {
      ObjectSetInteger(0, "HotkeyPressedLabel", OBJPROP_COLOR, HotkeyLabelColours[HotkeyLabelCurrentIteration]);
      
      HotkeyLabelCurrentIteration++;
      
      if (HotkeyLabelCurrentIteration >= HotkeyLabelIterations) {
         HotkeyLoopEnabled = false;
         ObjectDelete("HotkeyPressedLabel");
      }
   }
   
   UpdateThePairGrid();                                                                                                                                     // PAIR GRID
   UpdateHigherTFCandles();                                                                                                                                 // HIGHER TF OVERLAY
   UpdateText("SpreadLabel", "SPREAD " + DoubleToStr(MarketInfo(0, MODE_SPREAD) * MarketInfo(0, MODE_POINT), MarketInfo(0, MODE_DIGITS)));                  // MAIN SPREAD LABEL
   UpdateBalance();                                                                                                                                         // BALANCE
   
   UpdateDOM();
   
   PERF_ITERATIONS++;
   //PERF_TRACKING = false;
}

//====================================================================================================================================================
//================================================================ INITIALISE PROGRAM ================================================================
void ToggleChartVisibility(bool ShowChart) {
   if (!ShowChart) {
   
      // HIDE CHART AND INDICATORS
      ChartIsVisible = false;
      
      ChartSetInteger(0, CHART_AUTOSCROLL, 0,         true);
      ChartSetInteger(0, CHART_FOREGROUND,            false);
      
      ChartSetInteger(0, CHART_SCALEFIX,              true);      // HIDE CHART SO LOGO IS CLEAR
      ChartSetDouble(0,  CHART_FIXED_MAX, 0.000002);
      ChartSetDouble(0,  CHART_FIXED_MIN, 0.000001);
      
      ChartSetInteger(0, CHART_SHIFT, 0,              true);
      
      ChartSetInteger(0, CHART_COLOR_ASK, 0,          clrBlack);
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, 0,   clrBlack);
      ChartSetInteger(0, CHART_COLOR_BID, 0,          clrBlack);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, 0,  clrBlack);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, 0,  clrBlack);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, 0,   clrBlack);
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, 0,   clrBlack);
      ChartSetInteger(0, CHART_COLOR_CHART_UP, 0,     clrBlack);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, 0,   clrBlack);
      ChartSetInteger(0, CHART_COLOR_STOP_LEVEL, 0,   clrYellow);
      
      ChartSetInteger(0, CHART_SHOW_ASK_LINE, 0,      false);  
      ChartSetInteger(0, CHART_SHOW_BID_LINE, 0,      false);
      ChartSetInteger(0, CHART_SHOW_DATE_SCALE, 0,    true);
      ChartSetInteger(0, CHART_SHOW_GRID, 0,          false);
      ChartSetInteger(0, CHART_SHOW_OBJECT_DESCR, 0,  false);
      ChartSetInteger(0, CHART_SHOW_LAST_LINE, 0,     false);
      ChartSetInteger(0, CHART_SHOW_OHLC, 0,          false);
      ChartSetInteger(0, CHART_SHOW_ONE_CLICK, 0,     false);
      ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, 0,    false);
      ChartSetInteger(0, CHART_SHOW_PRICE_SCALE, 0,   true);
      ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, 0,  false);
      ChartSetInteger(0, CHART_SHOW_VOLUMES, 0,       false);
      
      PsychosEnabledPrior              = PsychosEnabled;
      FractalsEnabledPrior             = FractalsEnabled;
      PriceLinesEnabledPrior           = PriceLinesEnabled;
      HigherTFCandlesEnabledPrior      = HigherTFCandlesEnabled;
      
      PsychosEnabled                   = false;
      FractalsEnabled                  = false;
      PriceLinesEnabled                = false;
      HigherTFCandlesEnabled           = false;
   } else {
      // SHOW CHART AND RE-ENABLE INDICATORS
      ChartIsVisible = true;
      
      ChartSetSymbolPeriod(0, "GBPJPY", PERIOD_M1);
      ChartSetInteger(0, CHART_COLOR_CHART_UP,   0, CandleColourUp);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, 0, CandleColourDown);
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, 0, ChartLineColour);
      ChartSetInteger(0, CHART_SCALEFIX, false);
      ChartSetInteger(0, CHART_COLOR_FOREGROUND, 0,   TronBlue);
      
      PsychosEnabled                   = PsychosEnabledPrior;
      FractalsEnabled                  = FractalsEnabledPrior;
      PriceLinesEnabled                = PriceLinesEnabledPrior;
      HigherTFCandlesEnabled           = HigherTFCandlesEnabledPrior;
   }
}

void InitialiseProgram() {
   RemoveEverything();
   GetChartSize();
   
   ToggleChartVisibility(false);
   
   // FLASH TW LOGO
   if (!FastLoad) {
      Sound("WarfareLoading");
      me = "TWLogo";
      CreateRectangleLabel("TempCover", CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 0, 0, ChartWidth, ChartHeight, clrBlack, false, BORDER_FLAT, clrBlack, STYLE_SOLID, 0);
      CreateBitmap(me, "Graphics\\Logo", CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 0, 0, true, 1);
      SetXDist(me, ChartCentreX - (GetShapeWidth(me) * 0.5));
      SetYDist(me, ChartCentreY - (GetShapeHeight(me) * 0.5));
      ObjectDelete(0, "TempCover");
      RepaintAndSleep(1000);
      ObjectDelete(0, me);
      RepaintAndSleep(0);
   }
   
   CreateLabel("LoadingStatus", "", OCR, 32, CORNER_LEFT_LOWER, ANCHOR_LEFT_LOWER, 10, 10, clrGreenYellow);
   
   // ORGANISE DATA
   IndexMarketNames();
   CreateTickDataFiles();
      
   ToggleChartVisibility(true);
   
   if (!FastLoad)
      ScanTrends();
   
   CreateHUD();
   CreatePsychoLines(); //<-------- MIGHT NEED TO ADD THIS ONCE DATA IS CONFIGURED, IF WE ARE TO STORE xPOINT AS ARRAY
   CreatePriceLines();
   CreateHigherTFCandles();
   
   CreateDOM();
   
   WindowRedraw();
   
   ProgramStartTime = TimeLocal();
}

//================================================================ CREATE HUD ================================================================
void CreateHUD() {
   UpdateLoadingStatus("BUILDING HUD...", 100);
   
   GetChartSize();
   
   //==================== TOP LEFT ====================
   // PROTOTYPE LOGO
   CreateBitmap("prototype_logo", "Graphics//Prototype", CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 5, 15, true, 0);
   
   // BALANCE
   CreateLabel("BalanceLabel", "000000000000", OCR, 32, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 5, GetShapeYDistance("prototype_logo") + GetShapeHeight("prototype_logo"), C'216,218,231');
   ObjectSetInteger(0, "BalanceLabel", OBJPROP_FONTSIZE, GetFittedFontX(GetText("BalanceLabel"), GetShapeWidth("prototype_logo"), OCR));
   
   // BROKER NAME
   str = StringUppercase(AccountCompany());
   if (!BrokerIsVisible)
      str = UnreadableString(str);
   else
   
   CreateLabel("BrokerNameLabel", str, OCR, 800, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 5, GetShapeYDistance("BalanceLabel") + GetTextHeight("BalanceLabel"), C'216,218,231');
   ObjectSetInteger(0, "BrokerNameLabel", OBJPROP_FONTSIZE, GetFittedFontX(GetText("BrokerNameLabel"), GetTextWidth("BalanceLabel"), OCR));
   
   // ACCOUNT NAME
   str = StringConcatenate(StringUppercase(AccountName()), " X ", StringUppercase(AccountNumber()));
   if (!AccountIsVisible)
      str = UnreadableString(str);
      
   CreateLabel("AccountNameLabel", str, OCR, 12, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 5, GetShapeYDistance("BrokerNameLabel") + GetTextHeight("BrokerNameLabel"), C'216,218,231');
   ObjectSetInteger(0, "AccountNameLabel", OBJPROP_FONTSIZE, GetFittedFontX(GetText("AccountNameLabel"), GetTextWidth("BalanceLabel"), OCR));
   
   // PROGRAM STATUS
   CreateLabel("ProgressBarStatus", "PROGRAM STATUS", OCR, 12, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 5, GetShapeYDistance("AccountNameLabel") + GetTextHeight("AccountNameLabel"), C'216,218,231');
   
   //==================== TOP CENTRE ====================
   // CLOCK
   me = "ClockLabel";
   CreateLabel("ClockLabel", TimeToStr(TimeLocal(), TIME_SECONDS), Eurostile, 32, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 0, 15, C'216,218,231');
   SetXDist(me, (ChartCentreX - (GetTextWidth(me) * 0.5)));
   
   // SESSION TIME
   me = "SessionDurationLabel";
   CreateLabel(me, "SESSION: 00:00:00", Eurostile, 12, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 5, GetShapeYDistance("ClockLabel") + GetTextHeight("ClockLabel"), C'216,218,231');
   ObjectSetInteger(0, me, OBJPROP_FONTSIZE, GetFittedFontX(GetText(me), GetTextWidth("ClockLabel"), Eurostile));
   SetXDist(me, (ChartCentreX - (GetTextWidth(me) * 0.5)));
   
   //==================== TOP RIGHT ====================
   // EXE MODE
   CreateLabel("ExecutionModeLabel", "EXECUTION", Eurostile, 32, CORNER_RIGHT_UPPER, ANCHOR_RIGHT_UPPER, 5, 15, TronWhite);
   
   // MARKET SPEED
   CreateLabel("MarketSpeedLabel", "SPEED", Eurostile, 18, CORNER_RIGHT_UPPER, ANCHOR_RIGHT_UPPER, 5, (GetShapeYDistance("ExecutionModeLabel") + GetTextHeight("ExecutionModeLabel")), TronWhite); // BOTH THE SAME SOURCE FOR Y
   CreateLabel("MarketPhaseLabel", "PHASE", Eurostile, 18, CORNER_RIGHT_UPPER, ANCHOR_RIGHT_UPPER, (GetShapeXDistance("MarketSpeedLabel") + GetTextWidth("MarketSpeedLabel")), (GetShapeYDistance("ExecutionModeLabel") + GetTextHeight("ExecutionModeLabel")), TronWhite); // BOTH THE SAME SOURCE FOR Y
   
   // SPREAD (CURRENT CHART PAIR)
   CreateLabel("SpreadLabel", "SPREAD", Eurostile, 18, CORNER_RIGHT_UPPER, ANCHOR_RIGHT_UPPER, 5, (GetShapeYDistance("MarketSpeedLabel") + GetTextHeight("MarketSpeedLabel")), TronWhite);
   
   //==================== OTHER ====================
   // PAIR TAG
   me = "PairTag";
   Font = Eurostile;
   FontSize = GetFittedFontX("AAAAAAA", ChartCentreX, Font);
   CreateLabel(me, Symbol(), Font, FontSize, CORNER_LEFT_LOWER, ANCHOR_LEFT_LOWER, 0, -10, TronGray);
   ObjectSetInteger(0, me, OBJPROP_BACK, true);
   SetXDist(me, (ChartWidth - GetTextWidth(me)) / 2);
      
   // WATER BOTTLE
   CreateBitmap("WaterBottle", "Graphics\\WaterBottleBlue", CORNER_RIGHT_LOWER, ANCHOR_RIGHT_LOWER, 0, 0, false, 0);
   WaterBottleNextTime = TimeCurrent() + (15 * 60);
      
   //==================== MULTI MARKET ====================
   int myPadding  = 10;
   Font           = OCR;
   
   myXDist = 5;
   myYDist = GetShapeYDistance("ProgressBarStatus") + GetTextHeight("ProgressBarStatus");
   
   int FontSizeA  = GetFittedFontY("00000", ((ChartHeight - myYDist) / (NoOfPairs + 1)), Font);
   int FontSizeB  = GetFittedFontX("0000000000000000000000000000000", GetTextWidth("BalanceLabel"), Font);
   FontSize = MathMin(FontSizeA, FontSizeB);
   
   for (iPAIR = 0; iPAIR <= NoOfPairs; iPAIR++) {
      GridPairName[iPAIR] = StringConcatenate(PairNames[iPAIR], "_LABEL");
      CreateLabel(GridPairName[iPAIR], PairNames[iPAIR], Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, GridPairNameColour);
      
      GridPhase[iPAIR] = StringConcatenate(PairNames[iPAIR], "_PHASE");
      CreateLabel(GridPhase[iPAIR], "TREND", Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, (GetShapeXDistance(GridPairName[iPAIR]) + GetTextWidth(GridPairName[iPAIR]) + myPadding), myYDist, GridPhaseColour);
      
      GridSpeed[iPAIR] = StringConcatenate(PairNames[iPAIR], "_SPEED");
      CreateLabel(GridSpeed[iPAIR], "1000", Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, (GetShapeXDistance(GridPhase[iPAIR]) + GetTextWidth(GridPhase[iPAIR]) + myPadding), myYDist, GridSpeedColour);
      
      GridPriceBid[iPAIR] = StringConcatenate(PairNames[iPAIR], "_BID");
      CreateLabel(GridPriceBid[iPAIR], "0000", Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, (GetShapeXDistance(GridSpeed[iPAIR]) + GetTextWidth(GridSpeed[iPAIR]) + myPadding), myYDist, GridPriceBidColour);
      
      GridPriceSpread[iPAIR] = StringConcatenate(PairNames[iPAIR], "_SPREAD");
      CreateLabel(GridPriceSpread[iPAIR], "000", Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, (GetShapeXDistance(GridPriceBid[iPAIR]) + GetTextWidth(GridPriceBid[iPAIR]) + myPadding), myYDist, GridPriceSpreadColour);
      
      GridPriceAsk[iPAIR] = StringConcatenate(PairNames[iPAIR], "_ASK");
      CreateLabel(GridPriceAsk[iPAIR], "0000", Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, (GetShapeXDistance(GridPriceSpread[iPAIR]) + GetTextWidth(GridPriceSpread[iPAIR]) + myPadding), myYDist, GridPriceAskColour);
      
      myYDist = GetShapeYDistance(GridPairName[iPAIR]) + GetTextHeight(GridPairName[iPAIR]);
   }
   
   //==================== TIME AND SALES LIST ====================
   myXDist = 5;
   myYDist = (GetShapeYDistance("SpreadLabel") + GetTextHeight("SpreadLabel"));
   
   int AvailableSpace = (ChartHeight - myYDist) / TimeAndSalesLevels;
   Font = OCR;
   FontSize = GetFittedFontY("00 00.0 00.0", AvailableSpace, Font);
   
   for (i = 0; i <= (TimeAndSalesLevels - 1); i++) {
      TimeAndSalesLabels[i] = StringConcatenate("TimeAndSalesLabel ", i);
      CreateLabel(TimeAndSalesLabels[i], "TIME & SALES", Font, FontSize, CORNER_RIGHT_UPPER, ANCHOR_RIGHT_UPPER, myXDist, myYDist, clrChartreuse);
      myYDist = GetShapeYDistance(TimeAndSalesLabels[i]) + GetTextHeight(TimeAndSalesLabels[i]);
      ObjectSetString(0, TimeAndSalesLabels[i], OBJPROP_TEXT, "");
   }
   
   ObjectDelete("LoadingStatus");
}

//================================================================ SELF OPTIMISATION ================================================================
// REFIT CHART ITEMS
void RefitItems() {
   int PreviousChartHeight = ChartHeight;
   int PreviousChartWidth = ChartWidth;
   GetChartSize();
   
   if ((ChartHeight != PreviousChartHeight) || (ChartWidth != PreviousChartWidth)) {
      Print("CHART DIMENSIONS HAVE CHANGED");
   }
   
   CreateDOM();
   UpdatePairTag();
}

//================================================================ SOUNDS ================================================================
void Sound(string SoundToPlay) {
   if (SoundsEnabled) {
      SoundToPlay = StringConcatenate("::EmbeddedFiles\\Sounds\\", SoundToPlay, ".wav");
      
      if (!PlaySound(SoundToPlay)) {
         Print("Unable to play sound: ", SoundToPlay);
         ExpertRemove();
      }
   }
}

//================================================================ READ DATA FILES ================================================================
//========== FILE | DEPTH OF MARKET ==========
#define  F_DAX    0
#define  F_FGBL   1
#define  F_6J     2

#define  BIDPRICE 0
#define  BIDDEPTH 1
#define  ASKPRICE 2
#define  ASKDEPTH 3

double   DOMInfo[50,4,30]; // Market ... Bids,BidDepths,Asks,AskDepths ... Value                   // conscious about moving this because it may not reset on each iteration?
double   DOMBidPrices[];
double   DOMBidDepths[];
double   DOMAskPrices[];
double   DOMAskDepths[];

int      DOMBidLevelsRightNow = 0;
int      DOMAskLevelsRightNow = 0;

bool ReadDOMFile() {
   ResetLastError();
   long myStartTime = GetTickCount();
   
   string MarketString = StringConcatenate("Data\\MarketDepthDAX.txt");
   int file_handle = FileOpen(MarketString, FILE_SHARE_READ|FILE_TXT);
   int str_size;
   
   string to_split;
   string sep        = ",";
   ushort u_sep      = StringGetCharacter(sep, 0);
   
   ArrayFree(DOMBidPrices);
   ArrayFree(DOMBidDepths);
   ArrayFree(DOMAskPrices);
   ArrayFree(DOMAskDepths);
         
   if (file_handle == INVALID_HANDLE) {
      //FAILURE READING FILE
      Print(StringConcatenate("FAILED TO READ DOM FILE ",  MarketString, " ERROR ", GetLastError()));
      return(false);
   } else {
      i = 0;
      while (!FileIsEnding(file_handle)) {
      
         str_size = FileReadInteger(file_handle, INT_VALUE);         
         to_split = FileReadString(file_handle, str_size);
         string   result[];
         j        = StringSplit(to_split, u_sep, result);
         int      Entries = ArraySize(result);
         
         switch(i) {
            case 0:  ArrayResize(DOMBidPrices,  Entries);
                     DOMBidLevelsRightNow = Entries;
                     break;
                     
            case 1:  ArrayResize(DOMBidDepths,  Entries);
                     break;
            
            case 2:  ArrayResize(DOMAskPrices,  Entries);
                     DOMAskLevelsRightNow = Entries;
                     break;
            
            case 3:  ArrayResize(DOMAskDepths,  Entries);
                     break;
         }
         
         for (k = 0; k <= (Entries - 1); k++) {
            double myValue = StringToDouble(result[k]);
            
            switch(i) {
               case 0:  DOMInfo[F_DAX,i,k]   = myValue;  // BID PRICES
                        DOMBidPrices[k]      = myValue;
                        break;
                        
               case 1:  DOMInfo[F_DAX,i,k]   = myValue;  // BID DEPTHS
                        DOMBidDepths[k]      = myValue;
                        break;
                        
               case 2:  DOMInfo[F_DAX,i,k]   = myValue;  // ASK PRICES
                        DOMAskPrices[k]      = myValue;
                        break;
                        
               case 3:  DOMInfo[F_DAX,i,k]   = myValue;  // ASK DEPTHS
                        DOMAskDepths[k]      = myValue;
                        break;
            }
         }
            
         i++;
      }
      
      // SUCCESS READING FILE
      FileClose(file_handle);
      //Print(StringConcatenate("DOM FILE READ. ", i, " LINES READ IN ", (GetTickCount() - myStartTime), " µs"));
      
      return(true);
   }
}

//========== FILE |TIME AND SALES ==========
string   FootprintTimesInfo[100000, 1]; // HH:MM:SS
double   FootprintTradeInfo[100000, 3]; // Price, Size, Instigator(-1,+1)

bool ReadTimeAndSalesFile() {
   ResetLastError();
   long     myStartTime   = GetTickCount();
      
   string   MarketString  = StringConcatenate("Data\\TimeAndSalesFGBL.txt");
   int      file_handle   = FileOpen(MarketString, FILE_SHARE_READ|FILE_TXT);
   
   int      str_size;
   string   to_split;
   string   sep           = ",";
   ushort   u_sep         = StringGetCharacter(sep, 0);
   
   if (file_handle == INVALID_HANDLE) {
      //FAILURE READING FILE
      Print(StringConcatenate("FAILED TO READ TIMESALES FILE ",  MarketString, " ERROR ", GetLastError()));
      return(false);
   } else {
      i = 0;
      while (!FileIsEnding(file_handle)) {
      
         str_size = FileReadInteger(file_handle, INT_VALUE);         
         to_split = FileReadString(file_handle, str_size);
         string   result[];
         j        = StringSplit(to_split, u_sep, result);
         
         // EXTRACT DATA FROM ARRAY
         str = StringSubstr(result[0], (StringLen(result[0]) - 8), 8); // strlen = 19
         FootprintTimesInfo[i, 0]   = StringSubstr(str, 0, 8);
         
         double myBid  = StringToDouble(result[1]);                  // bid
         double myAsk  = StringToDouble(result[2]);                  // ask
         double myLast = StringToDouble(result[3]);                  // last
         double mySize = StringToDouble(result[4]);                  // size
         
         FootprintTradeInfo[i, 0] = myLast;                          // trade price
         FootprintTradeInfo[i, 1] = mySize;                          // trade size
         
         // ----- CALCULATE FOOTPRINT -----
         if (myLast <= myBid) {              // SELLER
            FootprintTradeInfo[i, 2] = -1;
         } else if (myLast >= myAsk) {       // BUYER
            FootprintTradeInfo[i, 2] = 1;
         } else {                            // NEUTRAL
            FootprintTradeInfo[i, 2] = 0;
         }
         
         //Print(StringConcatenate(FootprintTimesInfo[i, 0], " | ", FootprintTradeInfo[i, 1], " CTS TRADED AT ", FootprintTradeInfo[i, 0], " BY ", FootprintTradeInfo[i, 2]));
            
         i++;
      }
      
      // SUCCESS READING FILE
      FileClose(file_handle);
      //Print(StringConcatenate("TIMESALES FILE READ. ", i, " LINES READ IN ", (GetTickCount() - myStartTime), " µs"));
      
      // TEST A LEVEL
      double   TestLevel   = 11448;
      int      TotalSize   = 0;
      int      Instigator  = -1;
      
      for (i = 0; i < 100000; i++) {
         if (FootprintTradeInfo[i, 0] == TestLevel) {
            if (FootprintTradeInfo[i, 2] != 32) {
               TotalSize += FootprintTradeInfo[i, 1];
            }
         }
      }
      
      Print(TotalSize);
      
      return(true);
   }
}

//================================================================ DOM ================================================================
//========== CREATE DOM ==========
string   DOMBidShapes[];   // PriceLevels
string   DOMBidText[];     // PriceLevels
string   DOMAskShapes[];   // PriceLevels
string   DOMAskText[];     // PriceLevels

int      BidsEdge    = 0;
int      AsksEdge    = 0;
   
void CreateDOM() {
   DeleteObjectsByPrefix("DOMBid"); // do this
   DeleteObjectsByPrefix("DOMAsk");
   
   if (!DOMEnabled)
      return;
      
   // READ DOM DATA
   ReadDOMFile();
   int DOMTotalLevelsRightNow = (DOMBidLevelsRightNow + DOMAskLevelsRightNow);

   ArrayFree(DOMBidShapes);   ArrayResize(DOMBidShapes,  DOMBidLevelsRightNow);
   ArrayFree(DOMBidText);     ArrayResize(DOMBidText,    DOMBidLevelsRightNow);
   ArrayFree(DOMAskShapes);   ArrayResize(DOMAskShapes,  DOMAskLevelsRightNow);
   ArrayFree(DOMAskText);     ArrayResize(DOMAskText,    DOMAskLevelsRightNow);
    
   int myInnerPadding      = 5;
   int myOuterPadding      = 3;
   int TotalOuterPadding   = (myOuterPadding * DOMTotalLevelsRightNow);
   
   myHeight                = (ChartHeight - TotalOuterPadding) / DOMTotalLevelsRightNow;
   myWidth                 = (ChartWidth * 0.1);

   Font                    = OCR;
   FontSize                = MathMin(GetFittedFontX("000000", (myWidth - (myInnerPadding * 2)), Font), GetFittedFontY("000000", (myHeight - (myInnerPadding * 2)), Font));
   
   color myBoxInnerColour  = C'12,20,31';
   color myBoxBorderColour = C'255,0,128';
   
   //===== BIDS =====
   myXDist                 = (ChartCentreX - myWidth);
   myYDist                 = ChartCentreY;
   BidsEdge                = ((myXDist + myWidth) - myInnerPadding); //doesnt change
   
   for (i = 0; i < DOMBidLevelsRightNow; i++) {
      // OUTER SHAPE
      me = StringConcatenate("DOMBidShape", i);
      DOMBidShapes[i] = me;
      CreateRectangleLabel(me, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, myWidth, myHeight, myBoxInnerColour, true, BORDER_FLAT, myBoxBorderColour, STYLE_SOLID, 1);
      
      // INNER TEXT
      me = StringConcatenate("DOMBidText", i);
      DOMBidText[i] = me;
      int BarCentreY   = (myYDist + (myHeight * 0.5));
      
      CreateLabel(me, StringConcatenate("BID ", i), Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, clrYellow);
      SetXDist(me, (BidsEdge - GetTextWidth(me)));
      SetYDist(me, (BarCentreY - (GetTextHeight(me) * 0.5)));
      
      // pass THE BOX coordinates to next iteration
      myYDist = (GetShapeYDistance(DOMBidShapes[i]) + GetShapeHeight(DOMBidShapes[i]) + myOuterPadding);
   }
   
   //===== OFFERS =====
   myXDist              = ChartCentreX;
   myYDist              = (ChartCentreY - myHeight);
   AsksEdge             = (myXDist + myInnerPadding); //doesnt change
   
   for (i = 0; i < DOMAskLevelsRightNow; i++) {
      // OUTER SHAPE
      me = StringConcatenate("DOMAskShape", i);
      DOMAskShapes[i] = me;
      CreateRectangleLabel(me, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, myWidth, myHeight, myBoxInnerColour, true, BORDER_FLAT, myBoxBorderColour, STYLE_SOLID, 1);
      
      // INNER TEXT
      me = StringConcatenate("DOMAskText", i);
      DOMAskText[i] = me;
      int BarCentreY   = (myYDist + (myHeight * 0.5));
            
      CreateLabel(me, StringConcatenate("ASK ", i), Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, clrYellow);
      SetXDist(me, AsksEdge);
      SetYDist(me, (BarCentreY - (GetTextHeight(me) * 0.5)));
      
      // pass THE BOX coordinates to next iteration
      myYDist = (GetShapeYDistance(DOMAskShapes[i]) - GetShapeHeight(DOMAskShapes[i]) - myOuterPadding);
   }
}

//========== UPDATE DOM ==========
void UpdateDOM() {
   if (!DOMEnabled)
      return;
      
   ReadDOMFile();
   
   for (i = 0; i < DOMBidLevelsRightNow; i++) {
      me = DOMBidText[i];
      UpdateText(me, DOMInfo[F_DAX, BIDDEPTH, i]);
      SetXDist(me, (BidsEdge - GetTextWidth(me)));
   }
   
   // OFFERS
   for (i = 0; i < DOMAskLevelsRightNow; i++) {
      me = DOMAskText[i];
      UpdateText(me, DOMInfo[F_DAX, ASKDEPTH, i]);
      SetXDist(me, AsksEdge);
   }
}

//================================================================ CREATE SHAPES/LINES/ETC ================================================================
//========== STRAIGHT LINE ==========
void CreateStraightLine(string LineName, datetime Time0, double Price0, datetime Time1, double Price1, int Style, color Colour, int Width, bool Ray, bool Back, bool Selectable) {
   ObjectCreate(LineName, OBJ_TREND, 0, Time0, Price0, Time1, Price1, 0, 0);
   ObjectSet(LineName, OBJPROP_STYLE, Style);
   ObjectSet(LineName, OBJPROP_COLOR, Colour);
   ObjectSet(LineName, OBJPROP_WIDTH, Width);
   ObjectSet(LineName, OBJPROP_RAY, Ray);
   ObjectSetInteger(0, LineName, OBJPROP_BACK, Back);
   ObjectSetInteger(0, LineName, OBJPROP_SELECTABLE, Selectable);
   ObjectSet(LineName, OBJPROP_HIDDEN, true);
}

//========== TREND LINES ==========
void CreateTrendLine(string LineName, color LineColour, int FirstBarIndex, int BarDiff, datetime FirstTime, double FirstPrice, datetime SecondTime, double SecondPrice) {
   ObjectDelete(0, LineName);
   
   Offset = (iTime(Symbol(), 1, 0) + 60);
   
   double   Gradient       = ((FirstPrice - SecondPrice) / BarDiff);  //(y2 - y1) / (x2 - x1)
   double   NewY           = (FirstPrice + (FirstBarIndex * Gradient));
   
   ObjectCreate(LineName, OBJ_TREND, 0, Offset, NewY, SecondTime, SecondPrice);
   
   ObjectSet(LineName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(LineName, OBJPROP_COLOR, LineColour);
   ObjectSet(LineName, OBJPROP_WIDTH, 2);
   ObjectSet(LineName, OBJPROP_RAY, false);
   ObjectSetInteger(0, LineName, OBJPROP_BACK, true);
   ObjectSetInteger(0, LineName, OBJPROP_SELECTABLE, false);
   ObjectSet(LineName, OBJPROP_HIDDEN, true);
}

//========== RECTANGLE LABELS ==========
bool CreateRectangleLabel(string LabelName, int LabelCorner, int LabelAnchor, int LabelXDist, int LabelYDist, int LabelWidth, int LabelHeight, int LabelBackColour, bool LabelAtBack, int LabelBorderType, int LabelBorderColour, int LabelBorderStyle, int LabelBorderWidth) {
   ResetLastError();
   
   if (!ObjectCreate(0, LabelName, OBJ_RECTANGLE_LABEL, 0, 0, 0)) {
      Print("Unable to create rectangle, error: ", GetLastError());
      ExpertRemove();
      return(false);
   }
   
   ObjectSet       (   LabelName, OBJPROP_CORNER, LabelCorner);
   ObjectSetInteger(0, LabelName, OBJPROP_ANCHOR, LabelAnchor);
   ObjectSetInteger(0, LabelName, OBJPROP_BGCOLOR, LabelBackColour);
   ObjectSetInteger(0, LabelName, OBJPROP_XDISTANCE, LabelXDist);
   ObjectSetInteger(0, LabelName, OBJPROP_YDISTANCE, LabelYDist);
   ObjectSetInteger(0, LabelName, OBJPROP_XSIZE, LabelWidth);
   ObjectSetInteger(0, LabelName, OBJPROP_YSIZE, LabelHeight);
   ObjectSetInteger(0, LabelName, OBJPROP_BACK, LabelAtBack);
   ObjectSetInteger(0, LabelName, OBJPROP_BORDER_TYPE, LabelBorderType);
   ObjectSetInteger(0, LabelName, OBJPROP_COLOR, LabelBorderColour);
   ObjectSetInteger(0, LabelName, OBJPROP_STYLE, LabelBorderStyle);
   ObjectSetInteger(0, LabelName, OBJPROP_WIDTH, LabelBorderWidth);
   ObjectSetInteger(0, LabelName, OBJPROP_ZORDER, 1);
   
   return(true);
}

//========== TEXT LABELS ==========
bool CreateLabel(string LabelName, string LabelText, string LabelFont, int LabelFontSize, int LabelCorner, int LabelAnchor, int LabelX, int LabelY, color LabelColour) {
   if (!ObjectCreate(LabelName, OBJ_LABEL, 0, 0, 0)) {
      Print("Unable to create label, error: ", GetLastError());
      return(false);
   }
   
   ObjectSet       (   LabelName, OBJPROP_CORNER, LabelCorner);
   ObjectSetInteger(0, LabelName, OBJPROP_ANCHOR, LabelAnchor);
   ObjectSetString (0, LabelName, OBJPROP_FONT, LabelFont);
   ObjectSetInteger(0, LabelName, OBJPROP_FONTSIZE, LabelFontSize);
   ObjectSetString (0, LabelName, OBJPROP_TEXT, LabelText);
   ObjectSetInteger(0, LabelName, OBJPROP_XDISTANCE, LabelX);
   ObjectSetInteger(0, LabelName, OBJPROP_YDISTANCE, LabelY);
   ObjectSetText   (   LabelName, LabelText);
   ObjectSetInteger(0, LabelName, OBJPROP_COLOR, LabelColour);
   ObjectSetInteger(0, LabelName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, LabelName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, LabelName, OBJPROP_ZORDER, 10);
   ObjectSetInteger(0, LabelName, OBJPROP_BACK, false);
      
   return(true);
}

//========== ARROW LABELS ==========
void CreateArrow(string ArrowName, int ArrowType, datetime Time0, double Price0, int Style, color Colour, int Width, bool Back, bool Selectable) {
   ObjectCreate(ArrowName, OBJ_ARROW, 0, Time0, Price0);
   ObjectSet(ArrowName, OBJPROP_ARROWCODE, ArrowType);
   ObjectSet(ArrowName, OBJPROP_COLOR, Colour);
   ObjectSet(ArrowName, OBJPROP_WIDTH, Width);
   ObjectSetInteger(0, ArrowName, OBJPROP_BACK, Back);
   ObjectSetInteger(0, ArrowName, OBJPROP_SELECTABLE, Selectable);
   ObjectSetInteger(0, ArrowName, OBJPROP_HIDDEN, true);
}

//========== CREATE EMBEDDED BITMAP ==========
bool CreateBitmap(string BitmapLabelName, string BitmapFilename, int BitmapCorner, int BitmapAnchor, int BitmapXPos, int BitmapYPos, bool BitmapBack, int BitmapZOrder) {
   ResetLastError();
   
   string BitmapFileLocation = StringConcatenate("::EmbeddedFiles\\Images\\", BitmapFilename, ".bmp");
   
   if (!ObjectCreate(0, BitmapLabelName, OBJ_BITMAP_LABEL, 0, 0, 0)) {
      Print("Unable to create bitmap (embedded) [", BitmapLabelName, "] error: ", GetLastError());
      ExpertRemove();
      return(false);
   }
   
   if (!ObjectSetString(0, BitmapLabelName, OBJPROP_BMPFILE, 0, BitmapFileLocation)) {
      Print("Unable to set bitmap (embedded) [", BitmapLabelName, "] error: ", GetLastError());
      ExpertRemove();
      return(false);
   }
   
   ObjectSet         (BitmapLabelName,    OBJPROP_CORNER, BitmapCorner);
   ObjectSetInteger  (0, BitmapLabelName, OBJPROP_ANCHOR, BitmapAnchor);
   ObjectSetInteger  (0, BitmapLabelName, OBJPROP_ZORDER, 0);
   ObjectSetInteger  (0, BitmapLabelName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger  (0, BitmapLabelName, OBJPROP_BACK, BitmapBack);
   ObjectSetInteger  (0, BitmapLabelName, OBJPROP_XDISTANCE, BitmapXPos);
   ObjectSetInteger  (0, BitmapLabelName, OBJPROP_YDISTANCE, BitmapYPos);
   
   return(true);
}

//========== UPDATE EMBEDDED BITMAP ==========
bool UpdateBitmap(string BitmapLabelName, string BitmapFilename) {
   string BitmapFileLocation = StringConcatenate("::EmbeddedFiles\\Images\\", BitmapFilename, ".bmp");
   
   if (!ObjectSetString(0, BitmapLabelName, OBJPROP_BMPFILE, 0, BitmapFileLocation)) {
      Print("Unable to set bitmap (embedded) ", BitmapLabelName, ", error: ", GetLastError());
      ExpertRemove();
      return(false);
   } else {
      return(true);
   }
}

//================================================================ UPDATE LABELS ================================================================
//========== UPDATE TEXT LABELS ==========
void UpdateText(string LabelName, string TextToShow) {
   ObjectSetString(0, LabelName, OBJPROP_TEXT, TextToShow);
}

//========== UPDATE TEXT COLOUR ==========
void UpdateTextColour(string LabelName, int Colour) {
   ObjectSet(LabelName, OBJPROP_COLOR, Colour);
}

//========== UPDATE LOADING STATUS ==========
void UpdateLoadingStatus(string TextToShow, int SleepTime) {
   ObjectSetString(0, "LoadingStatus", OBJPROP_TEXT, TextToShow);
   SetXDist("LoadingStatus", (ChartCentreX - (GetTextWidth("LoadingStatus") * 0.5)));
   
   WindowRedraw();
   
   if (SleepTime > 0)
      Sleep(SleepTime);
}

//================================================================ ANIMATIONS AND TEXT EFFECTS ================================================================
//========== LAST HOTKEY PRESSED ==========
void HotkeyPressed(string TextToPrint, color TextColour) {
   me = "HotkeyPressedLabel";
   
   // TEST FOR EXISTING LABEL
   if (ObjectFind(0, me) == 0) {
      ObjectDelete(me);

   }
   
   CreateLabel(me, TextToPrint, Eurostile, 12, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 5, GetShapeYDistance("SessionDurationLabel") + GetTextHeight("SessionDurationLabel"), TextColour);
   ObjectSetInteger(0, me, OBJPROP_FONTSIZE, GetFittedFontX(GetText(me), GetTextWidth("ClockLabel"), Eurostile));
   SetXDist(me, (ChartCentreX - (GetTextWidth(me) * 0.5)));
   
   // ARRAY STORE LOOP COLOURS FROM GET GO, CYCLE THROUGH ARRAY, MUCH QUICKER
   string   result[];
   ushort   u_sep       = StringGetCharacter(",", 0);
   int      k           = StringSplit(ColorToString(TextColour), u_sep, result);
   
   double   ColourR    = result[0];
   double   ColourG    = result[1];
   double   ColourB    = result[2];
   
   double   RStep      = (ColourR / HotkeyLabelIterations);
   double   GStep      = (ColourG / HotkeyLabelIterations);
   double   BStep      = (ColourB / HotkeyLabelIterations);
   
   for (i = 0; i <= (HotkeyLabelIterations-1); i++) {
      ColourR = (ColourR - RStep);
      ColourG = (ColourG - GStep);
      ColourB = (ColourB - BStep);
      
      HotkeyLabelColours[i] = StringToColor(StringConcatenate(ColourR, ",", ColourG, ",", ColourB));
   }
   
   HotkeyLabelCurrentIteration = 0;
   HotkeyLoopEnabled = true;
}

//========== BULL FLASH ==========
void BullFlash(int NoOfTimes, int SleepTime) {
   me = "BullIcon";
   
   CreateBitmap(me, "Graphics\\Bull", CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 0, 0, true, 0);
   SetXDist(me, (ChartCentreX - (GetShapeWidth(me) * 0.5)));
   SetYDist(me, (ChartCentreY - (GetShapeHeight(me) * 0.5)));
   RepaintAndSleep(SleepTime);
   DeleteObjectsByPrefix("BullIcon");
   RepaintAndSleep(SleepTime);
}

//========== MW3 LABEL ==========
void MW3Label(string TextToShow) {
   CreateLabel("MW3Label", " ", OCR, 20, CORNER_LEFT_LOWER, ANCHOR_LEFT_LOWER, 10, 10, clrGreenYellow);
   Sound("UIText");
   
   // BRING IN
   for (i = 1; i <= StringLen(TextToShow); i++) {
      ObjectSetString(0, "MW3Label", OBJPROP_TEXT, StringSubstr(TextToShow, 0, i));
      WindowRedraw();
      Sleep(20 + 50*MathRand()/32768);
   }
   
   PlaySound(NULL);
   Sleep(800);
   
   // DELETE
   Sound("UITextDelete");
   int BlanksCount = 0;
   
   while (BlanksCount < StringLen(TextToShow)) {
      for (i = 0; i <= StringLen(TextToShow); i++) {
         if (StringSubstr(TextToShow, i, 1) == " ") {
            BlanksCount++;
         }
      }
      
      int CharToRemove = (0 + StringLen(TextToShow)*MathRand()/32768);
      str = StringSubstr(TextToShow, CharToRemove, 1);
      StringReplace(TextToShow, str, " ");
      ObjectSetString(0, "MW3Label", OBJPROP_TEXT, TextToShow);
      
      WindowRedraw();
      Sleep(50 + 100*MathRand()/32768);
   }
   
   ObjectDelete(0, "MW3Label");
}

//================================================================ TOGGLE ELEMENTS ================================================================
// BALANCE
void ToggleBalanceVisibility() {
   if (BalanceIsVisible)
      BalanceIsVisible = false;
   else
      BalanceIsVisible = true;
}

// BROKER
void ToggleBrokerVisibility() {
   str = StringUppercase(AccountCompany());
   
   if (BrokerIsVisible) {
      BrokerIsVisible = false;
      UpdateText("BrokerNameLabel", UnreadableString(str));
   } else {
      BrokerIsVisible = true;
      UpdateText("BrokerNameLabel", str);
   }
}

// ACCOUNT ID
void ToggleAccountVisibility() {
   str = StringUppercase(StringConcatenate(AccountName(), " X ", AccountNumber()));
    
   if (AccountIsVisible) {
      AccountIsVisible = false;
      UpdateText("AccountNameLabel", UnreadableString(str));
   } else {
      AccountIsVisible = true;
      UpdateText("AccountNameLabel", str);
   }
}

// DEPTH OF MARKET
void ToggleDOMVisibility() {
   if (DOMEnabled) {
      DOMEnabled = false;
      CreateDOM();
   } else {
      DOMEnabled = true;
      CreateDOM();
   }
}

//================================================================ RETRIEVE OBJECT INFO ================================================================
void SetXDist(string WhichShape, int Dist) {
   ResetLastError();
   
   if (!ObjectSetInteger(0, WhichShape, OBJPROP_XDISTANCE, Dist)) {
      Print("Unable to set X dist, error: ", GetLastError(), " in shape ", WhichShape);
      ExpertRemove();
   }
}

void SetYDist(string WhichShape, int Dist) {
   ResetLastError();
   
   if (!ObjectSetInteger(0, WhichShape, OBJPROP_YDISTANCE, Dist)) {
      Print("Unable to set Y dist, error: ", GetLastError(), " in shape ", WhichShape);
      ExpertRemove();
   }
}

int GetShapeWidth(string WhichShape) {
   ResetLastError();
   
   long ShapeWidth = 0;
   
   if (!ObjectGetInteger(0, WhichShape, OBJPROP_XSIZE, NULL, ShapeWidth)) {
      Print("Unable to get shape width, error: ", GetLastError(), " in shape ", WhichShape);
      ExpertRemove();
      return(0);
   } else {
      return(ShapeWidth);
   }
}
   
int GetShapeHeight(string WhichShape) {
   ResetLastError();
   
   long ShapeHeight = 0;
   
   if (!ObjectGetInteger(0, WhichShape, OBJPROP_YSIZE, NULL, ShapeHeight)) {
      Print("Unable to get shape height, error: ", GetLastError(), " in shape ", WhichShape);
      ExpertRemove();
      return(0);
   } else {
      return(ShapeHeight);
   }
}

int GetShapeXDistance(string WhichShape) {
   ResetLastError();
   
   long ShapeXDistance = 0;
   
   if (!ObjectGetInteger(0, WhichShape, OBJPROP_XDISTANCE, NULL, ShapeXDistance)) {
      Print("Unable to get shape X distance, error: ", GetLastError(), " in shape ", WhichShape);
      ExpertRemove();
      return(0);
   } else {
      return(ShapeXDistance);
   }
}

int GetShapeYDistance(string WhichShape) {
   ResetLastError();
   
   long ShapeYDistance = 0;
   
   if (!ObjectGetInteger(0, WhichShape, OBJPROP_YDISTANCE, NULL, ShapeYDistance)) {
      Print("Unable to get shape Y distance, error: ", GetLastError(), " in shape ", WhichShape);
      ExpertRemove();
      return(0);
   } else {
      return(ShapeYDistance);
   }
}

string GetFont(string WhichShape) {
   ResetLastError();
   
   string FontInsideShape = "";
   
   if (!ObjectGetString(0, WhichShape, OBJPROP_FONT, NULL, FontInsideShape)) {
      Print("Unable to get font, error: ", GetLastError(), " in shape ", WhichShape);
      ExpertRemove();
      return("");
   } else {
      return(FontInsideShape);
   }
}

int GetFontSize(string WhichShape) {
   ResetLastError();
   
   long FontSizeInsideShape = 0;
   
   if (!ObjectGetInteger(0, WhichShape, OBJPROP_FONTSIZE, NULL, FontSizeInsideShape)) {
      Print("Unable to get font size, error: ", GetLastError(), " in shape ", WhichShape);
      ExpertRemove();
      return(0);
   } else {
      return(FontSizeInsideShape);
   }
}

string GetText(string WhichShape) {
   ResetLastError();
   
   string TextInsideShape = "";
   
   if (!ObjectGetString(0, WhichShape, OBJPROP_TEXT, NULL, TextInsideShape)) {
      Print("Unable to get text, error: ", GetLastError(), " in shape ", WhichShape);
      ExpertRemove();
      return("");
   } else {
      return(TextInsideShape);
   }
}

int GetTextHeight(string WhichShape) {
   string   FontInsideShape      = GetFont(WhichShape);
   int      FontSizeInsideShape  = GetFontSize(WhichShape);
   string   TextInsideShape      = GetText(WhichShape);
   
   int      WidthOfText, HeightOfText = 0;
   
   TextSetFont(FontInsideShape, -FontSizeInsideShape*10);
   TextGetSize(TextInsideShape, WidthOfText, HeightOfText);
   
   return(HeightOfText);
}

int GetTextWidth(string WhichShape) {
   string   FontInsideShape      = GetFont(WhichShape);
   int      FontSizeInsideShape  = GetFontSize(WhichShape);
   string   TextInsideShape      = GetText(WhichShape);
   
   int      WidthOfText, HeightOfText = 0;
   
   TextSetFont(FontInsideShape, -FontSizeInsideShape*10);
   TextGetSize(TextInsideShape, WidthOfText, HeightOfText);
   
   return(WidthOfText);
}

int GetFittedFontX(string TextToFit, int AvailableSpace, string myFont) {
   FontSize = 500;
   TextSetFont(myFont, -FontSize*10);
   
   int FittedWidth, FittedHeight = 0;
   
   TextGetSize(TextToFit, FittedWidth, FittedHeight);
   
   while (FittedWidth > AvailableSpace) {
      FontSize -= 1;
      TextSetFont(myFont, -FontSize*10);
      TextGetSize(TextToFit, FittedWidth, FittedHeight);
   }
   
   return(FontSize);
}

int GetFittedFontY(string TextToFit, int AvailableSpace, string myFont) {
   FontSize = 500;
   TextSetFont(myFont, -FontSize*10);
   
   int FittedWidth, FittedHeight = 0;
   
   TextGetSize(TextToFit, FittedWidth, FittedHeight);
   
   while (FittedHeight > AvailableSpace) {
      FontSize -= 1;
      TextSetFont(myFont, -FontSize*10);
      TextGetSize(TextToFit, FittedWidth, FittedHeight);
   }
   
   return(FontSize);
}

//================================================================ PATTERN RECOGNITION ================================================================
//========== MARKET PHASE ==========
void UpdateMarketPhases() {
   for (iPAIR = 0; iPAIR <= NoOfPairs; iPAIR++) {
      
      int ChopCount = 0;
      
      for (i = 0; i <= 10; i++) {
      
         if (  (iHigh(PairNames[iPAIR], 1, i) > iHigh(PairNames[iPAIR], 1, i+1))  &&  (iLow(PairNames[iPAIR], 1, i) < iLow(PairNames[iPAIR], 1, i+1))  ) {
            ChopCount++;
         }
      }
      
      if (ChopCount >= 3) {
         UpdateText(GridPhase[iPAIR], "CHOP");
         UpdateTextColour(GridPhase[iPAIR], clrRed);
         
         if (Symbol() == PairNames[iPAIR]) {
            UpdateText("MarketPhaseLabel", "CHOPPY");
            UpdateTextColour("MarketPhaseLabel", clrRed);
            SetXDist("MarketPhaseLabel", (GetShapeXDistance("MarketSpeedLabel") + GetTextWidth("MarketSpeedLabel") + 10));
         }
      } else {
         UpdateText(GridPhase[iPAIR], "TREND");
         UpdateTextColour(GridPhase[iPAIR], clrChartreuse);
         
         if (Symbol() == PairNames[iPAIR]) {
            UpdateText("MarketPhaseLabel", "TRENDING");
            UpdateTextColour("MarketPhaseLabel", clrChartreuse);
            SetXDist("MarketPhaseLabel", (GetShapeXDistance("MarketSpeedLabel") + GetTextWidth("MarketSpeedLabel") + 10));
         }
      }
   }
}

//========== SCAN TRENDS ==========
void ScanTrends() {
   UpdateLoadingStatus("MAPPING MARKET", 0);
   
   int   SleepDelay = 30;
   FractalTF = 1;
   FractalFirstHop = 1;
   
   while (  (FractalFirstHop < 15)  &&  (!IsStopped())  ) {
      CreateFractals();
      RepaintAndSleep(SleepDelay);
      FractalFirstHop++;
   }
   
   while (  (FractalFirstHop >= 1)  &&  (!IsStopped())  ) {
      CreateFractals();
      RepaintAndSleep(SleepDelay);
      FractalFirstHop--;
   }
   
   FractalTF         = 1;
   FractalFirstHop   = 1;
}

//================================================================ CHART CONTROL ================================================================
//========== SWITCH MARKET ==========
void SwitchPair(string Pair, int Timeframe) {
   ChartSetSymbolPeriod(0, Pair, Timeframe);
}
      
//========== GET & SET CHART SHIFT ==========
double GetChartShift() {   
   return(ChartGetDouble(0, CHART_SHIFT_SIZE));
}

void SetChartShift(double ShiftPercent) {
   ChartSetDouble(0, CHART_SHIFT_SIZE, ShiftPercent);
}

//========== GET DIMENSIONS ==========
void GetChartSize() {
   ChartHeight = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
   ChartWidth = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   
   ChartCentreX = (ChartWidth * 0.5);
   ChartCentreY = (ChartHeight * 0.5);
}

//========== REPAINT ==========
void RepaintAndSleep(int SleepTime) {
   WindowRedraw();
   
   if (SleepTime > 0)
      Sleep(SleepTime);
}

//========== REMOVE STUFF ==========
void RemoveEverything() {
   //MAIN WINDOW
   while (  (!IsStopped())  &&  (ChartIndicatorsTotal(ThisChart, 0) > 0)  ) {
      string IndicatorName = ChartIndicatorName(ThisChart, 0, 0);
      ChartIndicatorDelete(ThisChart, 0, IndicatorName);
   }
   
   //SUBWINDOWS
   while (  (!IsStopped())  &&  (WindowsTotal() > 1)  ) {
      string IndicatorName = ChartIndicatorName(ThisChart, 1, 0);
      ChartIndicatorDelete(ThisChart, 1, IndicatorName);
      ObjectsDeleteAll(ThisChart, 1);
   }
   
   //OTHER STUFF
   ObjectsDeleteAll();
}

void DeleteObjectsByPrefix(string Prefix) {
   int LL = StringLen(Prefix);
   int ii = 0;
   
   while (ii < ObjectsTotal()) {
      string ObjName = ObjectName(ii);
      if (StringSubstr(ObjName, 0, LL) != Prefix) {
         ii++; 
         continue;
      }
      ObjectDelete(ObjName);
  }
}

//========== PREVIOUS PAIR ==========
void PreviousPair() {
   for (iPAIR = 0; iPAIR <= NoOfPairs; iPAIR++) {
      // SCAN KNOWN PAIRS FIRST
      if (ChartSymbol() == PairNames[0]) {
         ChartSetSymbolPeriod(0, PairNames[NoOfPairs], PERIOD_CURRENT);
         break;
      } else if (ChartSymbol() == PairNames[iPAIR]) {
         ChartSetSymbolPeriod(0, PairNames[iPAIR - 1], PERIOD_CURRENT);
         break;
      }
      
      // NOT IN LIST, SWITCH BACK TO LIST
      if (iPAIR == NoOfPairs) {
         ChartSetSymbolPeriod(0, PairNames[0], PERIOD_CURRENT);
         break;
      }
   }
}

//========== NEXT PAIR ==========
void NextPair() {
   for (iPAIR = 0; iPAIR <= NoOfPairs; iPAIR++) {      
      // SCAN KNOWN PAIRS FIRST
      if (ChartSymbol() == PairNames[NoOfPairs]) {
         ChartSetSymbolPeriod(0, PairNames[0], PERIOD_CURRENT);
         break;
      } else if (ChartSymbol() == PairNames[iPAIR]) {
         ChartSetSymbolPeriod(0, PairNames[iPAIR + 1], PERIOD_CURRENT);
         break;
      }
      
      // NOT IN LIST, SWITCH BACK TO LIST
      if (iPAIR == NoOfPairs) {
         ChartSetSymbolPeriod(0, PairNames[0], PERIOD_CURRENT);
         break;
      }
   }
}

//========== TIMEFRAME HOPPING ==========
// PREVIOUS
void PreviousTimeframe() {
   int NewPeriod = 0;
   
   switch(Period()) {
      case PERIOD_M1:  NewPeriod = PERIOD_M1  ; break;
      case PERIOD_M5:  NewPeriod = PERIOD_M1  ; break;
      case PERIOD_M15: NewPeriod = PERIOD_M5  ; break;
      case PERIOD_M30: NewPeriod = PERIOD_M15 ; break;
      case PERIOD_H1:  NewPeriod = PERIOD_M30 ; break;
      case PERIOD_H4:  NewPeriod = PERIOD_H1  ; break;
      case PERIOD_D1:  NewPeriod = PERIOD_H4  ; break;
      case PERIOD_W1:  NewPeriod = PERIOD_D1  ; break;
      case PERIOD_MN1: NewPeriod = PERIOD_W1  ; break;
   }
   
   ChartSetSymbolPeriod(0, NULL, NewPeriod);
}

// NEXT
void NextTimeframe() {
   int NewPeriod = 0;

   switch(Period()) {
      case PERIOD_M1:  NewPeriod = PERIOD_M5  ; break;
      case PERIOD_M5:  NewPeriod = PERIOD_M15 ; break;
      case PERIOD_M15: NewPeriod = PERIOD_M30 ; break;
      case PERIOD_M30: NewPeriod = PERIOD_H1  ; break;
      case PERIOD_H1:  NewPeriod = PERIOD_H4  ; break;
      case PERIOD_H4:  NewPeriod = PERIOD_D1  ; break;
      case PERIOD_D1:  NewPeriod = PERIOD_W1  ; break;
      case PERIOD_W1:  NewPeriod = PERIOD_MN1 ; break;
      case PERIOD_MN1: NewPeriod = PERIOD_MN1 ; break;
   }
   
   ChartSetSymbolPeriod(0, NULL, NewPeriod);
}

//========== FRACTAL HOPPING ==========
// PREVIOUS
int PreviousFractalTimeframe() {
   switch(Period()) {
      case PERIOD_M1:  return(PERIOD_M1)  ; break;
      case PERIOD_M5:  return(PERIOD_M1)  ; break;
      case PERIOD_M15: return(PERIOD_M5)  ; break;
      case PERIOD_M30: return(PERIOD_M15) ; break;
      case PERIOD_H1:  return(PERIOD_M30) ; break;
      case PERIOD_H4:  return(PERIOD_H1)  ; break;
      case PERIOD_D1:  return(PERIOD_H4)  ; break;
      case PERIOD_W1:  return(PERIOD_D1)  ; break;
      case PERIOD_MN1: return(PERIOD_W1)  ; break;
   }
   
   return(0);
}

// NEXT
int NextFractalTimeframe() {
   switch(Period()) {
      case PERIOD_M1:  return(PERIOD_M5)  ; break;
      case PERIOD_M5:  return(PERIOD_M15) ; break;
      case PERIOD_M15: return(PERIOD_M30) ; break;
      case PERIOD_M30: return(PERIOD_H1)  ; break;
      case PERIOD_H1:  return(PERIOD_H4)  ; break;
      case PERIOD_H4:  return(PERIOD_D1)  ; break;
      case PERIOD_D1:  return(PERIOD_W1)  ; break;
      case PERIOD_W1:  return(PERIOD_MN1) ; break;
      case PERIOD_MN1: return(PERIOD_MN1) ; break;
   }
   
   return(0);
}

//================================================================ STRING FUNCTIONS ================================================================
//========== UNREADABLE STRING ==========
string UnreadableString(string StringToHide) {
   string OutputString = "";
   
   for (i = 0; i < StringLen(StringToHide); i++) {
      OutputString = StringConcatenate(OutputString, "*");
   }
   return(OutputString);
}

//========== STRING TO UPPERCASE ==========
string StringUppercase(string UppercaseString) {
   StringToUpper(UppercaseString);
   return(UppercaseString);
}

//========== TWO DIGIT PRICE ==========
string TwoDigitPrice(int ThePair, double TheBid, double TheAsk) {
   double   mySpread = ((TheAsk - TheBid) * PairInformation[ThePair, DIGITS]);
   
   BidString      = DoubleToStr(TheBid, PairInformation[ThePair, DIGITS]);
   AskString      = DoubleToStr(TheAsk, PairInformation[ThePair, DIGITS]);
   string   BidSecondHalf  = "";
   string   AskSecondHalf  = "";
   int      myDigits       = PairInformation[ThePair, DIGITS];
   int      DecimalPos     = StringFind(BidString, ".", 0);
   
   if        (myDigits == 3) {
      BidSecondHalf  = StringSubstr(BidString, (DecimalPos + 1), 3);
      AskSecondHalf  = StringSubstr(AskString, (DecimalPos + 1), 3);      
   } else if (myDigits == 5) {
      BidSecondHalf  = StringSubstr(BidString, (DecimalPos + 3), 3);
      AskSecondHalf  = StringSubstr(AskString, (DecimalPos + 3), 3);
   }
   
   BidString   = StringConcatenate( StringSubstr(BidSecondHalf, 0, 2), ".", StringSubstr(BidSecondHalf, 2, 1));
   AskString   = StringConcatenate( StringSubstr(AskSecondHalf, 0, 2), ".", StringSubstr(AskSecondHalf, 2, 1));
   
   return(StringConcatenate(BidString, " ", AskString));
}

//========== ADD COMMAS ==========
string AddIntegerCommas(long Number) {
   string   myString = IntegerToString(Number);
   int      myLength = StringLen(myString);
   string   Formatted = "";
   
   while (myLength > 3) {
      Formatted = "'" + StringSubstr(myString, (myLength - 3), 3) + Formatted;
      myLength = (myLength - 3);
   }
   
   return(StringConcatenate(StringSubstr(myString, 0, myLength), Formatted));
}

//========== DATE/TIME TO STRING ==========
string DateTimeToString() {
   
   datetime TimeNow        = TimeLocal();
   string   DateTimeString = "";
   
   int Unformatted[6];
   Unformatted[0] = TimeDay(TimeNow);
   Unformatted[1] = TimeMonth(TimeNow);
   Unformatted[2] = TimeYear(TimeNow);
   
   Unformatted[3] = TimeHour(TimeNow);
   Unformatted[4] = TimeMinute(TimeNow);
   Unformatted[5] = TimeSeconds(TimeNow);
   
   string Formatted[6];
   
   for (i = 0; i < 6; i++) {
      if (Unformatted[i] < 10) {
         Formatted[i] = StringConcatenate("0", IntegerToString(Unformatted[i]));
         continue;
      }
      Formatted[i] = IntegerToString(Unformatted[i]);
   }
   
   DateTimeString = StringConcatenate( Formatted[0], "-", MonthString(Unformatted[1]), "-", Formatted[2],   //DATE
                                       " ",
                                       Formatted[3], "-", Formatted[4], "-", Formatted[5] );                //TIME
   
   return(DateTimeString);
}

//========== GET MONTH ==========
string MonthString(int TheMonth) {
   string MonthString;
   
   switch(TheMonth) {
      case 1:  MonthString = "Jan"; break;
      case 2:  MonthString = "Feb"; break;
      case 3:  MonthString = "Mar"; break;
      case 4:  MonthString = "Apr"; break;
      case 5:  MonthString = "May"; break;
      case 6:  MonthString = "Jun"; break;
      case 7:  MonthString = "Jul"; break;
      case 8:  MonthString = "Aug"; break;
      case 9:  MonthString = "Sep"; break;
      case 10: MonthString = "Oct"; break;
      case 11: MonthString = "Nov"; break;
      case 12: MonthString = "Dec"; break;
   }
   
   return(MonthString);
}

//================================================================ DATA ================================================================
//========== CREATE TICK DATA FILES ==========
void CreateTickDataFiles() {
   string   TimeString     = DateTimeToString();
      
   for (iPAIR = 0; iPAIR <= NoOfPairs; iPAIR++) {
      UpdateLoadingStatus(StringConcatenate("CREATING SPOT FOREX TICK DATA FILES: ", PairNames[iPAIR]), 50);
      
      FileName = StringConcatenate("TICK DATA - ", PairNames[iPAIR], "\\", TimeString, ".csv");
      
      TICKLOG[iPAIR] = -1;
      
      while (  (TICKLOG[iPAIR] == -1) && (!IsStopped())  ) {
         TICKLOG[iPAIR] = FileOpen(FileName, FILE_WRITE|FILE_SHARE_READ|FILE_CSV);
      }
      FileSeek(TICKLOG[iPAIR], 0, SEEK_SET);
      FileWrite(TICKLOG[iPAIR], "TIME,TICKCOUNT,BID,ASK,VOLUME");
  }
}

//========== CLOSE TICK DATA FILES ==========
void CloseTickDataFiles() {
   for (iPAIR = 0; iPAIR <= NoOfPairs; iPAIR++) {
      FileFlush(TICKLOG[iPAIR]);
      FileClose(TICKLOG[iPAIR]);
   }
}

//========== PREPARE DATA ==========
void IndexMarketNames() {

   i = 0;
   int CurrentPairCount = 0;
   int ThisPair = 0;
   
   while (i < SymbolsTotal(true)) { // True - only symbols in MarketWatch
      
      // INDEX AVAILABLE MARKETS
      string mySymbol      = SymbolName(i, true);
      string BaseCurrency  = StringSubstr(mySymbol, 0, 3);
      string QuoteCurrency = StringSubstr(mySymbol, 3, 3);
      
      if (  (StringLen(mySymbol) == 6) &&
      
           ((BaseCurrency == "AUD") || (BaseCurrency == "CAD") || (BaseCurrency == "CHF")  || (BaseCurrency == "EUR") ||
            (BaseCurrency == "GBP") || (BaseCurrency == "NZD") || (BaseCurrency == "JPY") || (BaseCurrency == "USD")) &&
               
           ((QuoteCurrency == "AUD") || (QuoteCurrency == "CAD") || (QuoteCurrency == "CHF")  || (QuoteCurrency == "EUR") ||
            (QuoteCurrency == "GBP") || (QuoteCurrency == "NZD") || (QuoteCurrency == "JPY") || (QuoteCurrency == "USD"))  ) {
            
         CurrentPairCount++;
            
         ArrayResize(PairInformation, CurrentPairCount, 0);
         ArrayResize(PairNames, CurrentPairCount, 0);            
         ArrayResize(GridPairName, CurrentPairCount, 0);
         ArrayResize(GridPhase, CurrentPairCount, 0);
         ArrayResize(GridSpeed, CurrentPairCount, 0);
         ArrayResize(GridPriceBid, CurrentPairCount, 0);
         ArrayResize(GridPriceAsk, CurrentPairCount, 0);
         ArrayResize(GridPriceSpread, CurrentPairCount, 0);
         ArrayResize(GridPairName, CurrentPairCount, 0);
         
         // STORE PAIR INFORMATION
         UpdateLoadingStatus(StringConcatenate("INDEXING SPOT FOREX MARKETS: ", mySymbol), 50);
         
         PairNames[ThisPair] = mySymbol;
         
         int myDigits = MarketInfo(mySymbol, MODE_DIGITS);
         PairInformation[ThisPair, DIGITS] = myDigits;
         
         switch(myDigits) {
            case 2:  PairInformation[ThisPair, MULTIPLIER] = 100;   break;
            case 3:  PairInformation[ThisPair, MULTIPLIER] = 100;   break;
            case 4:  PairInformation[ThisPair, MULTIPLIER] = 10000; break;
            case 5:  PairInformation[ThisPair, MULTIPLIER] = 10000; break;
         }
         
         ThisPair++;
      }
      
      i++;
   }
   
   NoOfPairs = (ThisPair - 1);
   
   ArrayResize(PreviousPrices, CurrentPairCount, 0);
   ArrayResize(TickData, CurrentPairCount, 0);
   ArrayResize(TickDataCount, CurrentPairCount, 0);
   ArrayResize(TICKLOG, CurrentPairCount, 0);
   ArrayResize(TradePriceStrings, CurrentPairCount, 0);
   
   ArrayInitialize(PreviousPrices, 0);
   ArrayInitialize(TickData, 0);
   ArrayInitialize(TickDataCount, 0);
   ArrayInitialize(TICKLOG, 0);
}

//================================================================ ORDER HANDLING ================================================================
//========== TEST HOTKEYS ENABLED pre trade ==========
bool HotkeysAreEnabled() {
   if (HotkeysEnabled) {
      return(true);
   } else {
      Sound("EnableTheHotkeys");
      return(false);
   }
}

//========== EXECUTION INFO ==========
void UpdateExecutionInfo() {
   int   ExecutionStatus   = 0;
   int   TradeModeStatus   = 0;

   i = (int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_EXEMODE);
   switch(i) {
      case SYMBOL_TRADE_EXECUTION_REQUEST:   str = "REQ";         TradeModeStatus = 1;        break;
      case SYMBOL_TRADE_EXECUTION_INSTANT:   str = "INST";        TradeModeStatus = 2;        break;
      case SYMBOL_TRADE_EXECUTION_MARKET:    str = "MKT";         TradeModeStatus = 3;        break;
      case SYMBOL_TRADE_EXECUTION_EXCHANGE:  str = "XCHG";        TradeModeStatus = 4;        break;
   }
   
   i = (int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_MODE);
   switch(i) {
      case SYMBOL_TRADE_MODE_DISABLED:       str2 = "DISABLED";   myColour = clrRed;         break;
      case SYMBOL_TRADE_MODE_LONGONLY:       str2 = "LONG ONLY";  myColour = clrRed;         break;
      case SYMBOL_TRADE_MODE_SHORTONLY:      str2 = "SHORT ONLY"; myColour = clrRed;         break;
      case SYMBOL_TRADE_MODE_CLOSEONLY:      str2 = "CLOSE ONLY"; myColour = clrRed;         break;
      case SYMBOL_TRADE_MODE_FULL:           str2 = "FULL";       myColour = clrGreenYellow; break;
   }
   
   UpdateText("ExecutionModeLabel", StringConcatenate(str, " x ", str2));
   UpdateTextColour("ExecutionModeLabel", myColour);
}
   
//========== CLOSE ALL AND CXL ==========
void CloseAllAndCancel() {
   if (!HotkeysAreEnabled())
      return;
      
   RefreshRates();
   
   int TotalOrders = OrdersTotal();
   
   for (i = (TotalOrders - 1); i >= 0; i--) {
      SelectOrder = OrderSelect(i, SELECT_BY_POS);
      int  type   = OrderType();
      bool result = false;
       
      switch (type) {
         case OP_BUY:         result = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);  break;
         case OP_SELL:        result = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);  break;
         case OP_BUYLIMIT:    result = OrderDelete(OrderTicket());   break;
         case OP_BUYSTOP:     result = OrderDelete(OrderTicket());   break;
         case OP_SELLLIMIT:   result = OrderDelete(OrderTicket());   break;
         case OP_SELLSTOP  :  result = OrderDelete(OrderTicket());   break;
      }
       
      if (result == false) {
         Print("FAILED TO CLOSE ORDER [" , OrderTicket() , "] WITH ERROR CODE ", GetLastError());
      }
   }
}

//========== CXL ALL ==========
void CancelAll() {
   if (!HotkeysAreEnabled())
      return;
      
   RefreshRates();
   
   int TotalOrders = OrdersTotal();
   
   for (i = (TotalOrders - 1); i >= 0; i--) {
      SelectOrder = OrderSelect(i, SELECT_BY_POS);
      int  type   = OrderType();
      bool result = false;
       
      switch (type) {
         case OP_BUYLIMIT:    result = OrderDelete(OrderTicket());   break;
         case OP_BUYSTOP:     result = OrderDelete(OrderTicket());   break;
         case OP_SELLLIMIT:   result = OrderDelete(OrderTicket());   break;
         case OP_SELLSTOP  :  result = OrderDelete(OrderTicket());   break;
      }
       
      if (result == false) {
         Print("FAILED TO CLOSE ORDER [" , OrderTicket() , "] WITH ERROR CODE ", GetLastError());
      }
   }
}

//========== BUY MARKET ==========
void BuyAtMarket() {
   if (!HotkeysAreEnabled())
      return;
      
   RefreshRates();
   
   TicketTime  = GetTickCount();
   Ticket      = 0;
   StopLoss    = (Bid - NormalizeDouble( ((StopLossPips * 10.0) * Point), Digits));
   TakeProfit  = (Ask + NormalizeDouble( ((TakeProfitPips * 10.0) * Point), Digits));
   Ticket      = OrderSend(Symbol(), OP_BUY, Lots, Ask, Slippage, StopLoss, TakeProfit, "BUY MARKET", 000, 0, clrNONE);
      
   if (Ticket == false) {
      Print("BUY MARKET FAILED.", GetErrorReason());
      Sound("BuyLaser");
   } else {
      Sound("BuyLaser");
      Print(StringConcatenate("BUY MARKET TOOK ", (GetTickCount() - TicketTime), " milliseconds"));
   }
   
   HotkeyPressed("BUY MARKET", clrGreenYellow);
}

//========== SELL MARKET ==========
void SellAtMarket() {
   if (!HotkeysAreEnabled())
      return;
      
   RefreshRates();

   TicketTime  = GetTickCount();
   Ticket      = 0;
   StopLoss    = (Ask + NormalizeDouble( ((StopLossPips * 10.0) * Point), Digits));
   TakeProfit  = (Bid - NormalizeDouble( ((TakeProfitPips * 10.0) * Point), Digits));
   Ticket      = OrderSend(Symbol(), OP_SELL, Lots, Bid, Slippage, StopLoss, TakeProfit, "SELL MARKET", 000, 0, clrNONE);

   if (Ticket <= 0) {
      Print("SELL MARKET FAILED.", GetErrorReason());
      Sound("SellLaser");
   } else {
      Sound("SellLaser");
      Print(StringConcatenate("SELL MARKET TOOK ", (GetTickCount() - TicketTime), " milliseconds"));
   }
   
   HotkeyPressed("SELL MARKET", clrRed);
}

//========== TRADE ERROR HANDLING ==========
string GetErrorReason() {
   int    ErrorCode   = GetLastError();
   string ErrorReason = "";
   
   switch(ErrorCode) {
      case 1:   ErrorReason = "UNKNOWN ERROR"; break;
      case 2:   ErrorReason = "COMMON ERROR"; break;
      case 3:   ErrorReason = "ERR_INVALID_TRADE_PARAMETERS"; break;
      case 4:   ErrorReason = "TRADE SERVER BUSY"; break;
      case 5:   ErrorReason = "OLD VERSION OF TERMINAL"; break;
      case 6:   ErrorReason = "NO CONNECTION TO TRADE SERVER"; break;
      case 7:   ErrorReason = "NOT ENOUGH RIGHTS"; break;
      case 8:   ErrorReason = "REQUESTS ARE TOO FREQUENT"; break;
      case 9:   ErrorReason = "MALFUNCTIONAL TRADE OPERATION"; break;
      case 64:  ErrorReason = "ACCOUNT DISABLED"; break;
      case 65:  ErrorReason = "INVALID ACCOUNT"; break;
      case 128: ErrorReason = "TRADE TIMEOUT"; break;
      case 129: ErrorReason = "INVALID PRICE"; break;
      case 130: ErrorReason = "INVALID STOPS"; break;
      case 131: ErrorReason = "INVALID TRADE VOLUME"; break;
      case 132: ErrorReason = "MARKET IS CLOSED"; break;
      case 133: ErrorReason = "TRADE IS DISABLED"; break;
      case 134: ErrorReason = "NOT ENOUGH MONEY"; break;
      case 135: ErrorReason = "PRICE HAS CHANGED"; break;
      case 136: ErrorReason = "OFF QUOTES"; break;
      case 137: ErrorReason = "BROKER IS BUSY"; break;
      case 138: ErrorReason = "REQUOTE"; break;
      case 139: ErrorReason = "ORDER IS LOCKED"; break;
      case 140: ErrorReason = "ONLY BUY ORDERS ALLOWED"; break;
      case 141: ErrorReason = "TOO MANY REQUESTS"; break;
      case 145: ErrorReason = "MODIFICATION DENIED, ORDER TOO CLOSE TO MARKET"; break;
      case 146: ErrorReason = "TRADE CONTEXT IS BUSY"; break;
      case 147: ErrorReason = "EXPIERIATIONS ARE DENIED BY BROKER"; break;
      case 148: ErrorReason = "OPEN / PENDING ORDERS LIMIT REACHED"; break;
      case 149: ErrorReason = "HEDGING PROHIBITED"; break;
      case 150: ErrorReason = "ORDER PROHIBITED BY FIFO RULE"; break;
   }
   
   return(StringConcatenate(" [ERROR ", ErrorCode, ": ", ErrorReason, "]"));
}

//================================================================ HIGHER TF CANDLES ================================================================
void CreateHigherTFCandles() {
   if (!HigherTFCandlesEnabled) {
      DeleteObjectsByPrefix("HigherTF");
      return;
   }
   
   int NumberOfBars = 20;
   
   for (i = 0; i < NumberOfBars; i++) {
      ObjectCreate("HigherTF_Body" + i, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
      ObjectCreate("HigherTF_TopWick" + i, OBJ_TREND, 0, 0, 0, 0, 0);
      ObjectCreate("HigherTF_BtmWick" + i, OBJ_TREND, 0, 0, 0, 0, 0);
   }
   
   HigherTFCreated = true;
}

void UpdateHigherTFCandles() {
   if (  (!HigherTFCandlesEnabled)  ||  (Period() != PERIOD_M1)  ) {
      DeleteObjectsByPrefix("HigherTF");
      HigherTFCreated = false;
      return;
   } else {
      if (!HigherTFCreated)
         CreateHigherTFCandles();
   }
   
   int      TFBar          = 15;
   int      NumberOfBars   = 20;
   color    ColorUp        = TronOrange;
   color    ColorDown      = TronOrange;
   int      shb            = 0;
   double   po, pc         = 0;
   double   ph             = 0;
   double   pl             = 500;
   datetime to, tc, ts;
   
   shb = 0;
   while (shb < NumberOfBars) {
      to = iTime(Symbol(), TFBar, shb);
      tc = iTime(Symbol(), TFBar, shb) + TFBar*60;
      po = iOpen(Symbol(), TFBar, shb);
      pc = iClose(Symbol(), TFBar, shb);
      ph = iHigh(Symbol(), TFBar, shb);
      pl = iLow(Symbol(), TFBar, shb);
      
      if (po < pc) {
         myColour = ColorUp;   // CLOSE > OPEN
      } else {
         myColour = ColorDown; // CLOSE < OPEN
      }
      
      // BODY
      name = StringConcatenate("HigherTF_Body", shb);
      ObjectSet(name, OBJPROP_TIME1, to);
      ObjectSet(name, OBJPROP_PRICE1, po);
      ObjectSet(name, OBJPROP_TIME2, tc);
      ObjectSet(name, OBJPROP_PRICE2, pc);
      ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(name, OBJPROP_WIDTH, 2);
      ObjectSet(name, OBJPROP_BACK, false);
      ObjectSet(name, OBJPROP_COLOR, myColour);
      ObjectSet(name, OBJPROP_HIDDEN, true);
      ObjectSet(name, OBJPROP_SELECTABLE, false);
      
      // UPPER WICK
      ts = to + MathRound((TFBar*60)/2);
      name = StringConcatenate("HigherTF_TopWick", shb);
      ObjectSet(name, OBJPROP_TIME1, ts);
      ObjectSet(name, OBJPROP_PRICE1, ph);
      ObjectSet(name, OBJPROP_TIME2, ts);
      ObjectSet(name, OBJPROP_PRICE2, MathMax(po,pc));
      ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(name, OBJPROP_WIDTH, 2);
      ObjectSet(name, OBJPROP_BACK, false);
      ObjectSet(name, OBJPROP_RAY, False);
      ObjectSet(name, OBJPROP_COLOR, myColour);
      ObjectSet(name, OBJPROP_HIDDEN, true);
      ObjectSet(name, OBJPROP_SELECTABLE, false);
      
      // LOWER WICK
      name = StringConcatenate("HigherTF_BtmWick", shb);
      ObjectSet(name, OBJPROP_TIME1, ts);
      ObjectSet(name, OBJPROP_PRICE1, MathMin(po,pc));
      ObjectSet(name, OBJPROP_TIME2, ts);
      ObjectSet(name, OBJPROP_PRICE2, pl);
      ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(name, OBJPROP_WIDTH, 2);
      ObjectSet(name, OBJPROP_BACK, false);
      ObjectSet(name, OBJPROP_RAY, False);
      ObjectSet(name, OBJPROP_COLOR, myColour);
      ObjectSet(name, OBJPROP_HIDDEN, true);
      ObjectSet(name, OBJPROP_SELECTABLE, false);
      
      shb++;
   }
   
   DeleteObjectsByPrefix("HigherTF_Body0");
   DeleteObjectsByPrefix("HigherTF_TopWick0");
   DeleteObjectsByPrefix("HigherTF_BtmWick0");
}

//================================================================ PSYCHO LINES ================================================================
void CreatePsychoLines() {
   DeleteObjectsByPrefix("PsychoLine");

   if (!PsychosEnabled)
      return;

   int     NumLinesAboveBelow    = 20;
   int     SweetSpotMainLevels   = 1000;
   int     SweetSpotSubLevels    = 100;
   
   int      ssp1, ssp            = 0;
   int      thickness            = 1;
   double   ds1                  = 0;
   
   ssp1 = (Bid / Point);
   ssp1 = ssp1 - ssp1%SweetSpotSubLevels;
   
   for (i = -NumLinesAboveBelow; i < NumLinesAboveBelow; i++) {
      ssp = ssp1 + (i * SweetSpotSubLevels);
      
      if ((ssp % SweetSpotMainLevels) == 0)
         thickness = 3;
      else
         thickness = 1;
      
      ds1 = (ssp * Point);
      MakePsychoLine(DoubleToStr(ds1,Digits), ds1,  TronOrange, STYLE_SOLID, thickness, Time[10]);
   }
}

void MakePsychoLine(string text, double level, color col1, int linestyle, int thickness, datetime startofday) {
   // PSYCHO LINES
   me = StringConcatenate("PsychoLine ", text);
   if (ObjectFind(me) != 0) {
      ObjectCreate(me, OBJ_TREND, 0, Time[0], level, Time[Bars-1], level, 0, 0);
      
      //ObjectCreate(me, OBJ_HLINE, 0, 0, level);
      ObjectSet(me, OBJPROP_STYLE, linestyle);
      ObjectSet(me, OBJPROP_COLOR, col1);
      ObjectSet(me, OBJPROP_WIDTH, thickness);
      ObjectSet(me, OBJPROP_RAY, true);
      ObjectSet(me, OBJPROP_BACK, True);
      
      ObjectSetInteger(0, me, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, me, OBJPROP_HIDDEN, true);
      
   } else {
      ObjectMove(me, 0, Time[0], level);
   }
   
   // PSYCHO LABELS
   me = StringConcatenate("PsychoLine Label ", text);
   Offset   = (iTime(Symbol(), 1, 0) + 60);
   if (ObjectFind(me) != 0) {
      CreateArrow(me, SYMBOL_RIGHTPRICE, Offset, level, STYLE_SOLID, TronOrange, 2, True, False);
      PsychoChartAdjuster = me;
   }
}

//================================================================ PRICE LINES ================================================================
void CreatePriceLines() {
   //LINES
   CreateStraightLine("PriceLinesBidLevel", Time[0], Bid, Time[1], Bid, STYLE_DASHDOTDOT, clrRed, 1, true, true, false);
   CreateStraightLine("PriceLinesAskLevel", Time[0], Ask, Time[1], Ask, STYLE_DASHDOTDOT, clrGreenYellow, 1, true, true, false);

   //LABELS
   CreateArrow("PriceLinesBidLabel", SYMBOL_RIGHTPRICE, Time[0], Bid, STYLE_SOLID, clrRed, 1, true, false);
   CreateArrow("PriceLinesAskLabel", SYMBOL_RIGHTPRICE, Time[0], Ask, STYLE_SOLID, clrGreenYellow, 1, true, false);
   
   PriceLinesCreated = true;
}

void UpdatePriceLines() {
   if (  (!PriceLinesEnabled)  ||  (Period() != PERIOD_M1)  ) {
      DeleteObjectsByPrefix("PriceLines");
      PriceLinesCreated = false;
      return;
   } else {
      if (!PriceLinesCreated)
         CreatePriceLines();
   }
   
   Offset = (iTime(Symbol(), 1, 0) + 60);
   ObjectMove("PriceLinesBidLabel", 0, Offset, Bid);
   ObjectSet("PriceLinesBidLevel", OBJPROP_PRICE1, Bid);
   ObjectSet("PriceLinesBidLevel", OBJPROP_PRICE2, Bid);
   ObjectSet("PriceLinesBidLevel", OBJPROP_TIME1, Offset);
   ObjectSet("PriceLinesBidLevel", OBJPROP_TIME2, Time[1]);
   
   ObjectMove("PriceLinesAskLabel", 0, Offset, Ask);
   ObjectSet("PriceLinesAskLevel", OBJPROP_PRICE1, Ask);
   ObjectSet("PriceLinesAskLevel", OBJPROP_PRICE2, Ask);
   ObjectSet("PriceLinesAskLevel", OBJPROP_TIME1, Offset);
   ObjectSet("PriceLinesAskLevel", OBJPROP_TIME2, Time[1]);
}

//================================================================ PAIR GRID ================================================================
void UpdateThePairGrid() {
   int DecimalPos = 0;
   
   for (iPAIR = 0; iPAIR <= NoOfPairs; iPAIR++) {
      //BID
      double myBid = SymbolInfoDouble(PairNames[iPAIR], SYMBOL_BID);
      double myAsk = SymbolInfoDouble(PairNames[iPAIR], SYMBOL_ASK);
      double mySpread = ((myAsk - myBid) * PairInformation[iPAIR, MULTIPLIER]);
      
      BidString   = DoubleToStr(myBid, PairInformation[iPAIR, DIGITS]);
      DecimalPos  = StringFind(BidString, ".", 0);
      
      if (PairInformation[iPAIR, DIGITS] == 3) {
         SecondHalf  = StringSubstr(BidString, (DecimalPos + 1), 3);
         BidString   = StringConcatenate( StringSubstr(SecondHalf, 0, 2), ".", StringSubstr(SecondHalf, 2, 1));
      } else if (PairInformation[iPAIR, DIGITS] == 5) {
         SecondHalf  = StringSubstr(BidString, (DecimalPos + 3), 3);
         BidString   = StringConcatenate( StringSubstr(SecondHalf, 0, 2), ".", StringSubstr(SecondHalf, 2, 1));
      }
      
      //ASK
      AskString   = DoubleToStr(myAsk, PairInformation[iPAIR, DIGITS]);
      DecimalPos  = StringFind(AskString, ".", 0);
      
      if (PairInformation[iPAIR, DIGITS] == 3) {
         SecondHalf  = StringSubstr(AskString, (DecimalPos + 1), 3);
         AskString   = StringConcatenate( StringSubstr(SecondHalf, 0, 2), ".", StringSubstr(SecondHalf, 2, 1));
      } else if (PairInformation[iPAIR, DIGITS] == 5) {
         SecondHalf  = StringSubstr(AskString, (DecimalPos + 3), 3);
         AskString   = StringConcatenate( StringSubstr(SecondHalf, 0, 2), ".", StringSubstr(SecondHalf, 2, 1));
      }
      
      UpdateText(GridPriceBid[iPAIR], BidString);
      UpdateText(GridPriceSpread[iPAIR], DoubleToStr(mySpread, 1));
      UpdateText(GridPriceAsk[iPAIR], AskString);
   }
}

//================================================================ BALANCE ================================================================
void UpdateBalance() {
   if (!BalanceIsVisible) {
      UpdateText("BalanceLabel", StringConcatenate(AccountCurrency(), " ********"));
   } else {
      int Balance = MathRound(AccountBalance());
   
      if (Balance < 10)
         str = "0000000";
      else if (Balance < 100)
         str = "000000";
      else if (Balance < 1000)
         str = "00000";
      else if (Balance < 10000)
         str = "0000";
      else if (Balance < 100000)
         str = "000";
      else if (Balance < 1000000)
         str = "00";
      else if (Balance < 10000000)
         str = "0";
         
      UpdateText("BalanceLabel", StringConcatenate(AccountCurrency(), " ", str, Balance));
   }
}

//================================================================ PAIR TAG ================================================================
void UpdatePairTag() {
   switch(Period()) {
      case PERIOD_M1:  str = "M1"  ; break;
      case PERIOD_M5:  str = "M5"  ; break;
      case PERIOD_M15: str = "M15" ; break;
      case PERIOD_M30: str = "M30" ; break;
      case PERIOD_H1:  str = "H1"  ; break;
      case PERIOD_H4:  str = "H4"  ; break;
      case PERIOD_D1:  str = "D1"  ; break;
      case PERIOD_W1:  str = "W1"  ; break;
      case PERIOD_MN1: str = "MN1" ; break;
   } 
   
   me = "PairTag";
   UpdateText(me, StringConcatenate(Symbol(), " ", str));
   SetXDist(me, (ChartWidth - GetTextWidth(me)) / 2);
}

//================================================================ FRACTALS ================================================================
//========== CALCULATE FRACTALS ==========
void CreateFractals() {
   DeleteObjectsByPrefix("Fractal");
   DeleteObjectsByPrefix("Trend");
      
   if (!FractalsEnabled) {  
      return;
   }
   
   int      FractalHighCount     = 0;  //FOR LABELLING
   int      FractalLowCount      = 0;  //FOR LABELLING
   int      FractalsToScan       = 10000;
      
   double   FractalPrice         = 0;
   datetime FractalTime          = 0;
   
   bool     FractalHighFound     = false;
   bool     FractalLowFound      = false;
   
   int      NoOfHighsFound       = 0;
   int      NoOfLowsFound        = 0;
   
   //FOR DRAWING TRENDLINES BETWEEN 2 FRACTALS
   double   FirstHighPrice       = 0;
   double   SecondHighPrice      = 0;
   double   FirstLowPrice        = 0;
   double   SecondLowPrice       = 0;
   
   datetime FirstHighTime        = 0;
   datetime SecondHighTime       = 0;
   datetime FirstLowTime         = 0;
   datetime SecondLowTime        = 0;
   
   bool     High1Set             = false;
   bool     High2Set             = false;
   
   bool     Low1Set              = false;
   bool     Low2Set              = false;
   
   int      FirstHighBar         = 0;
   int      SecondHighBar        = 0;
   
   int      FirstLowBar          = 0;
   int      SecondLowBar         = 0;
   
   int      FirstHighIndex       = 0;
   int      FirstLowIndex        = 0;
   
   FractalSecondHop = (FractalFirstHop + 1);
   
   string   FractalPair          = Symbol();
   
   //========== HIGHS ==========
   for (i = 2; i <= FractalsToScan; i++) {  //BEGIN 2 BARS BACK FROM NOW
      
      //===== UPPER TREND LINES =====
      if (  (NoOfHighsFound == FractalFirstHop)  &&  (!High1Set)  ) {
         FirstHighPrice       = FractalPrice;
         FirstHighTime        = FractalTime;
         FirstHighBar         = (i-1);
         FirstHighIndex       = i;
         High1Set             = true;
         FractalHighFound     = false;
      } else if (NoOfHighsFound < FractalSecondHop) {
         FractalHighFound     = false;
      } else if (  (NoOfHighsFound == FractalSecondHop)  &&  (!High2Set)  ) {
         SecondHighPrice      = FractalPrice;
         SecondHighTime       = FractalTime;
         SecondHighBar        = (i-1);
         High2Set             = true;
         FractalHighFound     = true;
         CreateTrendLine("Trend Line Higher", TronVividBlue, FirstHighIndex, (SecondHighBar - FirstHighBar), FirstHighTime, FirstHighPrice, SecondHighTime, SecondHighPrice);
      }
      
      FractalTime = iTime(NULL, FractalTF, i);
      FractalPrice = iHigh(FractalPair, FractalTF, i);
      
      if (!FractalHighFound && FractalPrice > iHigh(FractalPair, FractalTF, i+1) && FractalPrice > iHigh(FractalPair, FractalTF, i+2) &&
            FractalPrice > iHigh(FractalPair, FractalTF, i-1) && FractalPrice > iHigh(FractalPair, FractalTF, i-2)) {
         
         FractalHighFound = true;
         NoOfHighsFound++;
         DrawFractalLines("High", FractalTime, FractalPrice, FractalHighCount++);
      }
      
      //----6 bars Fractal
      if(!FractalHighFound && (Bars-i-1) >=3) {
         if(FractalPrice == iHigh(FractalPair, FractalTF, i+1) && FractalPrice > iHigh(FractalPair, FractalTF, i+2) && FractalPrice > iHigh(FractalPair, FractalTF, i+3) &&
            FractalPrice > iHigh(FractalPair, FractalTF, i-1) && FractalPrice > iHigh(FractalPair, FractalTF, i-2)) {
            
            FractalHighFound = true;
            NoOfHighsFound++;
            DrawFractalLines("High", FractalTime, FractalPrice, FractalHighCount++);
         }
      }         
      
      //----7 bars Fractal
      if (!FractalHighFound && (Bars-i-1) >=4) {   
         if (FractalPrice >= iHigh(FractalPair, FractalTF, i+1) && FractalPrice == iHigh(FractalPair, FractalTF, i+2) && FractalPrice > iHigh(FractalPair, FractalTF, i+3) && 
            FractalPrice > iHigh(FractalPair, FractalTF, i+4) && FractalPrice > iHigh(FractalPair, FractalTF, i-1) && FractalPrice > iHigh(FractalPair, FractalTF, i-2)) {
               
               FractalHighFound = true;
               NoOfHighsFound++;
               DrawFractalLines("High", FractalTime, FractalPrice, FractalHighCount++);
         }
      }
      
      //----8 bars Fractal                          
      if (!FractalHighFound && (Bars-i-1) >=5) {   
         if (FractalPrice >= iHigh(FractalPair, FractalTF, i+1) && FractalPrice == iHigh(FractalPair, FractalTF, i+2) && FractalPrice == iHigh(FractalPair, FractalTF, i+3) &&
            FractalPrice > iHigh(FractalPair, FractalTF, i+4) && FractalPrice > iHigh(FractalPair, FractalTF, i+5) &&
               FractalPrice > iHigh(FractalPair, FractalTF, i-1) && FractalPrice > iHigh(FractalPair, FractalTF, i-2)) {
               
               FractalHighFound = true;
               NoOfHighsFound++;
               DrawFractalLines("High", FractalTime, FractalPrice, FractalHighCount++);
         }
      } 
      
      //----9 bars Fractal                                        
      if (!FractalHighFound && (Bars-i-1) >=6) {   
         if (FractalPrice >= iHigh(FractalPair, FractalTF, i+1) && FractalPrice == iHigh(FractalPair, FractalTF, i+2) && FractalPrice >= iHigh(FractalPair, FractalTF, i+3) &&
            FractalPrice == iHigh(FractalPair, FractalTF, i+4) && FractalPrice > iHigh(FractalPair, FractalTF, i+5) && FractalPrice > iHigh(FractalPair, FractalTF, i+6) &&
               FractalPrice > iHigh(FractalPair, FractalTF, i-1) && FractalPrice > iHigh(FractalPair, FractalTF, i-2)) {
               
               FractalHighFound = true;
               NoOfHighsFound++;
               DrawFractalLines("High", FractalTime, FractalPrice, FractalHighCount++);
         }
      }
   }
   
   //========== LOWS ==========
   for (i = 2; i <= FractalsToScan; i++) {  //BEGIN 2 BARS BACK FROM NOW
      
      //===== LOWER TREND LINES =====
      if (  (NoOfLowsFound == FractalFirstHop)  &&  (!Low1Set)  ) {
         FirstLowPrice       = FractalPrice;
         FirstLowTime        = FractalTime;
         FirstLowBar         = (i-1);
         FirstLowIndex       = i;
         Low1Set             = true;
         FractalLowFound     = false;
      } else if (NoOfLowsFound < FractalSecondHop) {
         FractalLowFound     = false;
      } else if (  (NoOfLowsFound == FractalSecondHop)  &&  (!Low2Set)  ) {
         SecondLowPrice      = FractalPrice;
         SecondLowTime       = FractalTime;
         SecondLowBar        = (i-1);
         Low2Set             = true;
         FractalLowFound     = true;
         CreateTrendLine("Trend Line Lower", TronVividBlue, FirstLowIndex, (SecondLowBar - FirstLowBar), FirstLowTime, FirstLowPrice, SecondLowTime, SecondLowPrice);
      }
         
      FractalTime = iTime(NULL, FractalTF, i);
      FractalPrice = iLow(FractalPair, FractalTF, i);
      
      if (!FractalLowFound && FractalPrice < iLow(FractalPair, FractalTF, i+1) && FractalPrice < iLow(FractalPair, FractalTF, i+2) &&
         FractalPrice < iLow(FractalPair, FractalTF, i-1) && FractalPrice < iLow(FractalPair, FractalTF, i-2)) {
         
         FractalLowFound = true;
         NoOfLowsFound++;
         DrawFractalLines("Low", FractalTime, FractalPrice, FractalLowCount++);
      }
      
      //----6 bars Fractal
      if (!FractalLowFound && (Bars-i-1) >= 3) {
         if (FractalPrice == iLow(FractalPair, FractalTF, i+1) && FractalPrice < iLow(FractalPair, FractalTF, i+2) && FractalPrice < iLow(FractalPair, FractalTF, i+3) &&
            FractalPrice < iLow(FractalPair, FractalTF, i-1) && FractalPrice < iLow(FractalPair, FractalTF, i-2)) {
               
               FractalLowFound = true;
               NoOfLowsFound++;
               DrawFractalLines("Low", FractalTime, FractalPrice, FractalLowCount++);
         }
      }      
      
      //----7 bars Fractal
      if(!FractalLowFound && (Bars-i-1) >= 4) {   
         if (FractalPrice <= iLow(FractalPair, FractalTF, i+1) && FractalPrice == iLow(FractalPair, FractalTF, i+2) && FractalPrice < iLow(FractalPair, FractalTF, i+3) &&
            FractalPrice < iLow(FractalPair, FractalTF, i+4) && FractalPrice < iLow(FractalPair, FractalTF, i-1) && FractalPrice < iLow(FractalPair, FractalTF, i-2)) {
               
               FractalLowFound = true;
               NoOfLowsFound++;
               DrawFractalLines("Low", FractalTime, FractalPrice, FractalLowCount++);
         }
      }  
      
      //----8 bars Fractal                          
      if (!FractalLowFound && (Bars-i-1) >= 5) {
         if (FractalPrice <= iLow(FractalPair, FractalTF, i+1) && FractalPrice == iLow(FractalPair, FractalTF, i+2) && FractalPrice == iLow(FractalPair, FractalTF, i+3) &&
            FractalPrice < iLow(FractalPair, FractalTF, i+4) && FractalPrice < iLow(FractalPair, FractalTF, i+5) && FractalPrice < iLow(FractalPair, FractalTF, i-1) && FractalPrice < iLow(FractalPair, FractalTF, i-2)) {
               
               FractalLowFound = true;
               NoOfLowsFound++;
               DrawFractalLines("Low", FractalTime, FractalPrice, FractalLowCount++);
         }                      
      } 
      
      //----9 bars Fractal                                        
      if (!FractalLowFound && (Bars-i-1) >= 6) {
         if (FractalPrice <= iLow(FractalPair, FractalTF, i+1) && FractalPrice == iLow(FractalPair, FractalTF, i+2) && FractalPrice <= iLow(FractalPair, FractalTF, i+3) && FractalPrice == iLow(FractalPair, FractalTF, i+4) &&
            FractalPrice < iLow(FractalPair, FractalTF, i+5) && FractalPrice < iLow(FractalPair, FractalTF, i+6) && FractalPrice < iLow(FractalPair, FractalTF, i-1) && FractalPrice < iLow(FractalPair, FractalTF, i-2)) {
               
               FractalLowFound = true;
               NoOfLowsFound++;
               DrawFractalLines("Low", FractalTime, FractalPrice, FractalLowCount++);
         }                      
      }
   }
}

//========== DRAW FRACTALS ==========
void DrawFractalLines(string HighOrLow, datetime FractalTime, double FractalLevel, int FractalCount) {
   
   color    FractalColour     = 0;
   int      FractalStyle      = STYLE_DASH;
   double   FractalDistance   = (20 * (Point * 10));
   int      FractalThickness  = 1;
   
   if (FractalLevel > Ask) {
      FractalColour = clrRed;
   } else if (FractalLevel < Bid) {
      FractalColour = clrLawnGreen;
   } else {
      FractalColour = clrGray;
   }
   
   if (HighOrLow == "High") {
      name = StringConcatenate("Fractal High Line ", FractalCount);
   } else if (HighOrLow == "Low") {
      name = StringConcatenate("Fractal Low Line ", FractalCount);
   }
      
   ObjectCreate(name, OBJ_TREND, 0, Time[0], FractalLevel, FractalTime, FractalLevel, 0, 0);
   ObjectSet(name, OBJPROP_STYLE, FractalStyle);
   ObjectSet(name, OBJPROP_COLOR, FractalColour);
   ObjectSet(name, OBJPROP_WIDTH, FractalThickness);
   ObjectSet(name, OBJPROP_RAY, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSet(name, OBJPROP_HIDDEN, true);
}