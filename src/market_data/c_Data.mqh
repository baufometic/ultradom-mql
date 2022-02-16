
		void GetAllTicks(string SymbolName) {
			MqlTick   tick_array[];
			int       TicksToGet     = 100000;
			int       Received       = CopyTicks(SymbolName, tick_array, COPY_TICKS_TRADE, 0, TicksToGet);
			
			if (Received != -1) {
				if (GetLastError() == 0) {
				} else {
					PrintFormat("%s: Ticks are not synchronized yet, %d ticks received for %d ms. Error=%d", _Symbol, Received, _LastError);
					return;
				}
			}
		}

		//========== BOOK UPDATES ==========
		void OnBookEvent(const string &symbol) {
		
			if(symbol==_Symbol) {
			
				MqlBookInfo last_bookArray[];
				
				myMarket = "BP6H7";
				
				if (MarketBookGet(myMarket, last_bookArray)) {
					
					for (int idx = 0; idx < ArraySize(last_bookArray); idx++) {
						
						MqlBookInfo curr_info = last_bookArray[idx];
						
						Print("MARKET: ", myMarket, " | TYPE: ", curr_info.type, " | PRICE: ", curr_info.price,
							" | VOLUME: ", curr_info.volume);
					}
					
				} else {
					Print("FAILED TO GET MARKET DATA FOR: ", myMarket);
				}
			}
		}

		//========== NEW TRADES ==========
		void GetLastTick(string Symbol) {
			MqlTick last_tick;

			if (SymbolInfoTick(Symbol, last_tick)) {

					Print("Bid: ", TICK_FLAG_BID, " Ask: ", TICK_FLAG_ASK, " Buy: ", TICK_FLAG_BUY, " Last: ", TICK_FLAG_LAST, " Sell: ", TICK_FLAG_SELL, " Volume: ", TICK_FLAG_VOLUME, " ACTUAL: ", last_tick.flags);

					if (last_tick.flags == (TICK_FLAG_LAST | TICK_FLAG_VOLUME)) {
						string Aggressor = "";
								if       (last_tick.last <= last_tick.bid)
						str = "SELLER ";
						else if  (last_tick.last <= last_tick.bid)
						str = "BUYER ";
						else
						str = "NEUTRAL ";

						StringConcatenate(str, str, " | ", DoubleToString(last_tick.last, SymbolDigits, " x ", last_tick.volume);
						Print(str);
		}

		} else {
		Print("ERROR: ", GetLastError()); // UNABLE TO STORE TICK IN STRUCTURE
		}
		}



		//************************* ERROR TRAPPING *************************
		#define	ERROR_DEPTHDATA_OUTSIDEMARKETSRANGE	-4
		#define	ERROR_DEPTHDATA_COULDNTREQUESTBOOK	-3
		#define	ERROR_DEPTHDATA_NOBIDROWS			-2
		#define	ERROR_DEPTHDATA_NOASKROWS			-1
		
		//************************* ARRAYS *************************
		// MARKET NAMES
		string		MARKET_NAMES			[];

		// MARKET DATA - DOUBLE
		#define		MAX_DATA_MARKETS		100
		#define		MAX_DATA_ROWS			100
		double		MARKET_DATA_DOUBLE		[MAX_DATA_MARKETS,  50, MAX_DATA_ROWS];	// MARKET POS IN NAME LIST (int) | DATA REQ'D | ROW
		#define 	BID_PRICE				/*Market*/		0
		#define 	ASK_PRICE				/*Market*/		1
		#define 	BID_DEPTH				/*Market*/		2
		#define 	ASK_DEPTH				/*Market*/		3
		#define		BID_DEPTH_ENTRIES		/*Market*/		4,  0
		#define		ASK_DEPTH_ENTRIES		/*Market*/		5,  0
		#define 	BID_DEPTH_TOTAL			/*Market*/		6,  0
		#define 	ASK_DEPTH_TOTAL			/*Market*/		7,  0
		#define		BID_DEPTH_MINIMUM		/*Market*/		8,  0
		#define		BID_DEPTH_MAXIMUM		/*Market*/		9,  0
		#define		ASK_DEPTH_MINIMUM		/*Market*/		10, 0
		#define		ASK_DEPTH_MAXIMUM		/*Market*/		11, 0
		#define		BID_DEPTH_DIFF			/*Market*/		12, 0
		#define		ASK_DEPTH_DIFF			/*Market*/		13, 0
		#define		DEPTH_TOTAL_OVERALL		/*Market*/		14, 0
		#define		DEPTH_MIN_OVERALL		/*Market*/		15, 0
		#define		DEPTH_MAX_OVERALL		/*Market*/		16, 0
		
		// MARKET DATA [STRINGS]
		string		MARKET_DATA_STRING		[,100];	// MARKET | DATA REQUIRED
		#define   	MARKET_NAME				0
		#define   	MARKET_CODE				1
		#define   	MARKET_MONTHCODE		2
		#define   	MARKET_YEARCODE			3
		#define   	MARKET_DESCRIPTION		4
		#define   	MARKET_EXPIRYMONTH		5
		
		//************************* VARIABLES *************************
		bool		DataInitialised;
		int			NO_OF_MARKETS;
		double 		myBid, myAsk, myTickSize;
		int			myDigits;

		void Create_FuturesList() {
			ResetLastError();
			Log.Write(__FUNCSIG__);

			//CREATE A LIST OF EVERYTHING ON USER LIST AND FILTER FROM THERE
			int		NoOfUserSymbols = SymbolsTotal(false);
			string 	UserTempList	[,3];	// INDEX | NAME, TYPE, ACTIVE/INACTIVE (based on removing as we go)
			ArrayResize(UserTempList, NoOfUserSymbols);
			#define NAME 		0
			#define TYPE		1
			#define IS_ACTIVE 	2

			for (int i = 0; i < NoOfUserSymbols; i++) {
				string myName = SymbolName(i, false);
				string str = "";

				// NAME
				UserTempList[i,NAME] = myName;
				str += myName;

				// DEFINE TYPE OF MARKET - FX/FUTURE etc.
				if (MarketBookAdd(myName)) {
					str += " | GOT DOM";
				} else {
					str += " | NO DOM";
				}

				// IS NOW FLAGGED AS ACTIVE
				UserTempList[i,IS_ACTIVE] = (string)1;

				Print(str);
			}

			

			#undef TYPE
			#undef IS_ACTIVE
		}
    	
		//************************* TEST THE BOOKS OF MARKETS ADDED TO LIST *************************
		void Create_TestBooks() {
			ResetLastError();
			Log.Write(__FUNCSIG__);
			
			ObjectsDeleteAll(myChartID, "UltraDOM_Temp", -1, -1);
			
			for (int WhichBook = 0; WhichBook < NO_OF_MARKETS; WhichBook++) {
				//__________ DIMENSIONS __________
				int		OrderBookBidRows	= (int)MARKET_DATA_DOUBLE[WhichBook,BID_DEPTH_ENTRIES];
				int		OrderBookAskRows	= (int)MARKET_DATA_DOUBLE[WhichBook,ASK_DEPTH_ENTRIES];
				int		OrderBookTotalRows	= (OrderBookBidRows + OrderBookAskRows);
				int		RowHeight			= (ScreenContainer.Height / OrderBookTotalRows);
				myFont	= OCR;
				myFontSize= MathMin(20, GetFittedFontY("XXXXXXXXXX", RowHeight, myFont));
				
				//__________ POSITIONING __________
				int		MarketListNames_Left	= WhichBook * (ScreenContainer.Width / NO_OF_MARKETS);	// NAMES
				int		MarketListNames_Top		= 0;
				int		MarketDepths_Left		= MarketListNames_Left;							// PRICES
				myYDist	= MarketListNames_Top;
				
				//__________ NAME __________
				string 	MarketName = MARKET_NAMES[WhichBook];
				me		= "UltraDOM_Temp_MarketList_" + MarketName;
				CreateLabel(me, MarketName, myFont, myFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, MarketListNames_Left, myYDist, clrBrown, false);
				
				myYDist += GetTextHeight(me);
				
				//__________ ASK DEPTHS __________
				for (int Row = (OrderBookAskRows-1); Row >= 0; Row--) {
					me		= "UltraDOM_Temp_AskDepths_" + MarketName + "_" +(string)Row;
					
					myBid	= MARKET_DATA_DOUBLE[WhichBook,ASK_DEPTH,Row];
					str		= DoubleToString(myBid, 0);
					
					CreateLabel(me, str, myFont, myFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, MarketDepths_Left, myYDist, clrRed, false);
					
					myYDist += GetTextHeight(me);
				}
				
				//__________ BID DEPTHS __________
				for (int Row = 0; Row < OrderBookBidRows; Row++) {
					me		= "UltraDOM_Temp_BidDepths_" + MarketName + "_" + (string)Row;
					myAsk	= MARKET_DATA_DOUBLE[WhichBook,BID_DEPTH,Row];
					str		= DoubleToString(myAsk, 0);
					CreateLabel(me, str, myFont, myFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, MarketDepths_Left, myYDist, clrGreenYellow, false);
					
					myYDist += GetTextHeight(me);
				}
			}
		}
		
		//************************* RETRIEVE DEPTH DATA [INDIVIDUAL] *************************
		int Get_IndividualDepthData(int MarketPos) {
			
			// DEFINE WHICH SYMBOL SITS AT MARKETPOS
			string mySymbol = MARKET_DATA_STRING[MarketPos,MARKET_NAME];
			
			// REQUEST BOOK
			MqlBookInfo OrderBookRowData[];
			MqlBookInfo book_info;
			
		     if (!MarketBookGet(mySymbol, OrderBookRowData)) {
	               Log.Write("COULDN'T REQUEST BOOK FOR: " + mySymbol);
	               return(ERROR_DEPTHDATA_COULDNTREQUESTBOOK);
			}
			
			// put outside
			double	BidPrice,    AskPrice				= 0;
			int		BidDepth,    AskDepth				= 0;
			int		NoOfBidRows, NoOfAskRows				= 0;
			int 		BidDepthMin, BidDepthMax, BidDepthTotal = 0;
			int		AskDepthMin, AskDepthMax, AskDepthTotal = 0;
			
			//____________________ SORT BID DATA ____________________
			NoOfBidRows	= 0;
			BidDepthMin	= 100000000;
			BidDepthMax	= 0;
			BidDepthTotal	= 0;
			
			for (int Row = 0; Row < ArraySize(OrderBookRowData); Row++) {	// BIDS ARE INVERSE FROM 0 TO BID ROWS
				book_info = OrderBookRowData[Row];
				
				if (book_info.type == 2) { // BIDS
					BidPrice 	= (double)book_info.price;
					BidDepth	= (int)	book_info.volume;
					
					BidDepthTotal += BidDepth;
					
					MARKET_DATA_DOUBLE[MarketPos,BID_PRICE,NoOfBidRows]	= BidPrice;
					MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH,NoOfBidRows]	= BidDepth;
					                    
                         if (BidDepth < BidDepthMin) {
                         	BidDepthMin = BidDepth;
                         }
                         
                         if (BidDepth > BidDepthMax) {
                         	BidDepthMax = BidDepth;
					}
					
                         NoOfBidRows++;
                    }
               }
               
               MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH_TOTAL]	= BidDepthTotal;
               MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH_ENTRIES]	= NoOfBidRows;
			MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH_MINIMUM]	= BidDepthMin;
			MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH_MAXIMUM] 	= BidDepthMax;
			MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH_DIFF]		= (BidDepthMax - BidDepthMin);
               
               // ERROR - NO DATA IN PULL
			if (NoOfBidRows == 0) {
				//Log.Write(__FUNCSIG__ + " | " + mySymbol);
				return(ERROR_DEPTHDATA_NOBIDROWS);
			}
               
			//____________________ SORT ASK DATA ____________________
			NoOfAskRows	= 0;
			AskDepthMin	= 100000000;
			AskDepthMax	= 0;
			AskDepthTotal	= 0;
			
			for (int Row = (ArraySize(OrderBookRowData) - 1); Row >= 0; Row--) {
				book_info = OrderBookRowData[Row];
		
				if (book_info.type == 1) { // ASKS
					AskPrice	= book_info.price;
					AskDepth	= (int)book_info.volume;
					
					AskDepthTotal += AskDepth;
					
					MARKET_DATA_DOUBLE[MarketPos,ASK_PRICE,NoOfAskRows]	= AskPrice;
					MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH,NoOfAskRows]	= AskDepth;
					
					if (AskDepth < AskDepthMin) {
						AskDepthMin = AskDepth;
                         }
                         
                         if (AskDepth > AskDepthMax) {
                         	AskDepthMax = AskDepth;
					}
					
					NoOfAskRows++;
				}
			}
			
			MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH_TOTAL]	= AskDepthTotal;
			MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH_ENTRIES]	= NoOfAskRows;
			MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH_MINIMUM]	= AskDepthMin;
			MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH_MAXIMUM] 	= AskDepthMax;
			MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH_DIFF]		= (AskDepthMax - AskDepthMin);
			
			// ERROR - NO DATA IN PULL
			if (NoOfAskRows == 0) {
				//Log.Write(__FUNCSIG__ + " | " + mySymbol);
				return(ERROR_DEPTHDATA_NOASKROWS);
			}
			
			// OVERALL DEPTH ANALYSIS
			MARKET_DATA_DOUBLE[MarketPos,DEPTH_TOTAL_OVERALL]	= (BidDepthTotal + AskDepthTotal);
			MARKET_DATA_DOUBLE[MarketPos,DEPTH_MAX_OVERALL]		= MathMax(BidDepthMax, AskDepthMax);
			
			// END
			return(1);
		}

		//************************* ADD MARKET STRINGS TO ARRAY *************************
     	void AddMarketStrings(string &Array[] /*GIVES IT LIST OF MARKETS TO SUBSCRIBE TO*/) {
     		ResetLastError();
     		Log.Write(__FUNCSIG__);
		     
		     // CURRENT DATE FOR CALCULATING SYMBOL INFO
		     MqlDateTime Date;
		     TimeToStruct(TimeLocal(), Date);
		     
		     ArrayResize(MARKET_DATA_STRING, 0);
		     int MarketCount = 0;
		     
		     for (int i = 0; i < ArraySize(Array); i++) {
				ResetLastError();
				
				str 		= "CURRENT SYMBOL";
				
				string    CurrentSymbol			= Array[i];
				int       SymbolLength			= StringLen(CurrentSymbol);
				
				str 		+= " | " + CurrentSymbol;
                    
                    //__________ STORE MARKET INFO TO VARIABLES __________
                    string    YearStr				= StringSubstr		(CurrentSymbol, (SymbolLength-1), 1);
				string    CurrentYear			= StringSubstr		((string)Date.year, 3, 1);
				string	MarketCode			= StringSubstr		(CurrentSymbol, 0, (SymbolLength - 2));
				string	MarketMonthCode		= StringSubstr		(CurrentSymbol, (SymbolLength - 2), 1);
				string	MarketYearCode			= StringSubstr		((string)Date.year, 0, 3) + StringSubstr(CurrentSymbol, (SymbolLength - 1), 1);
				string	MarketExpiryMonth 		= MonthIntToString	((StringFind("FGHJKMNQUVXZ", MarketMonthCode, 0)+1)) + " " + MarketYearCode;
				string 	SymbolDescription		= SymbolInfoString	(CurrentSymbol, SYMBOL_DESCRIPTION);
                    int		SemiColonPos			= StringFind		(SymbolDescription, ":", 0);
                    string 	MarketDescriptionString	= StringSubstr		(SymbolDescription, 0, SemiColonPos);
				StringToUpper					(MarketDescriptionString);
				
				//__________ MOVE VARS TO ARRAY __________
				ArrayResize(MARKET_DATA_STRING, MarketCount+1);
				
                    MARKET_DATA_STRING[MarketCount, MARKET_NAME]         	= CurrentSymbol;
                    MARKET_DATA_STRING[MarketCount, MARKET_CODE]         	= MarketCode;
                    MARKET_DATA_STRING[MarketCount, MARKET_MONTHCODE]    	= MarketMonthCode;
                    MARKET_DATA_STRING[MarketCount, MARKET_YEARCODE]     	= MarketYearCode;
                    MARKET_DATA_STRING[MarketCount, MARKET_EXPIRYMONTH]  	= MarketExpiryMonth;
                    MARKET_DATA_STRING[MarketCount, MARKET_DESCRIPTION]	= MarketDescriptionString;
                    
                    str += 	" | " + MARKET_DATA_STRING[MarketCount, MARKET_NAME] +
                    		" | " + MARKET_DATA_STRING[MarketCount, MARKET_CODE] +
                    		" | " + MARKET_DATA_STRING[MarketCount, MARKET_MONTHCODE] +
                    		" | " + MARKET_DATA_STRING[MarketCount, MARKET_YEARCODE] +
                    		" | " + MARKET_DATA_STRING[MarketCount, MARKET_EXPIRYMONTH] +
                    		" | " + MARKET_DATA_STRING[MarketCount, MARKET_DESCRIPTION];
                    
                    MarketCount++;
                    str += " | " + (string)MarketCount;
                    Log.Write(str);
		     }
		}
};
cMarketData MarketData;


#define   TIMESALES_ARRAYDIMENSIONS     7
#define   TRADE_TIME                    0
#define   TRADE_TIMEMSC                 1
#define   TRADE_BID                     2
#define   TRADE_ASK                     3
#define   TRADE_LAST                    4
#define   TRADE_VOLUME                  5
#define   TRADE_INSTIGATOR              6
double    TimeAndSalesList              [,TIMESALES_ARRAYDIMENSIONS];     // ROW | TIME,MILLISECOND,PRICE,VOL,INSTIGATOR   // REMEMBER TO DIVIDE BY ARR_SIZE (ArraySize(TimeAndSalesList) / ARRAY_DIMENSIONS)


int Prints[1000,GridTotalRows,2];    // COLUMN, PRICE




    // NEW DATA ARRAY DIMENSIONS:
    int ArrSize = ArraySize(tick_array);
    ArrayResize(TimeAndSalesList, 1);
    ArrayResize(TimeAndSalesList, ArrSize);
    
    //____________________ BUILD PRINT/TIMESALES ARRAYS FROM THE ABOVE ____________________
    // TIME THRESHOLD
    MqlDateTime    TickArrStartTime, TickArrEndTime;     
    TimeToStruct   ((int)TimeAndSalesList[0,TRADE_TIME], TickArrStartTime);
    int            PreviousTimeFloor  = (int)MathFloor(TickArrStartTime.min/MinuteToSplit) * MinuteToSplit;

    // STORAGE ARRAYS
    #define SELL_VOL 0
    #define BUY_VOL  1
    ArrayInitialize(Prints, 0);
    
    int CurrentColumn = 0;
    int ColumnsPopulated = 0;



    for (int i = 0; i < ArrSize; i++) {
         TimeAndSalesList[i, TRADE_TIME]    = (double) tick_array[i].time;
         TimeAndSalesList[i, TRADE_TIMEMSC] = (double) tick_array[i].time_msc;
         TimeAndSalesList[i, TRADE_LAST]    = (double) tick_array[i].last;;
         TimeAndSalesList[i, TRADE_VOLUME]  = (int)    tick_array[i].volume;
         
         double TradeLast    = tick_array[i].last;
         int    TradeVolume  = (int)tick_array[i].volume;
         int    Pos          = PricePositionInLadder(TradeLast);
         
         // AT BID
         if ((tick_array[i].flags&TICK_FLAG_SELL)==TICK_FLAG_SELL) {
              TimeAndSalesList[i, TRADE_INSTIGATOR] = -1;
              
              if (Pos >= 0) {
                   Prints[CurrentColumn,Pos,SELL_VOL] += TradeVolume;
              }
         
         // AT ASK
         } else if ((tick_array[i].flags&TICK_FLAG_BUY) == TICK_FLAG_BUY) {
              TimeAndSalesList[i, TRADE_INSTIGATOR] = 1;
              
              if (Pos >= 0) {
                   Prints[CurrentColumn,Pos,BUY_VOL] += TradeVolume;
              }
              
         } else {
              TimeAndSalesList[i, TRADE_INSTIGATOR]    = 0;      // BETWEEN BID ASK
         }
         
         //__________ CALCULATE CELL BLOCK __________
         TimeToStruct   ((int)TimeAndSalesList[i,TRADE_TIME], TickArrEndTime);
         int CurrentTimeFloor = (int)MathFloor(TickArrEndTime.min/MinuteToSplit) * MinuteToSplit;
         
         if (CurrentTimeFloor != PreviousTimeFloor) {
              PreviousTimeFloor = CurrentTimeFloor;
              CurrentColumn += 1;
              ColumnsPopulated++;
         }
    }
    
    int SellVol, BuyVol = 0;
    string myShape, SellVolStr, BuyVolStr;
    int myColumn = 0;
    
    for (int i = 0; i < GridTotalRows; i++) {
         
         int ColumnToPrint = CurrentColumn;
         
         for (int j = 0; j < MathMin(ColumnsPopulated, NoOfPrintColumns); j++) {
         
              // SELL PRINTS
              myColumn  = SellPrintColumns[j];
              SellVol   = Prints[ColumnToPrint,i,SELL_VOL];
              myShape   = ShapeNames[OBJECT_SELLPRINT_TEXT,i,myColumn];
              
              if (SellVol > 0) {
                   SellVolStr     = DoubleToString(SellVol, 0);
                   myXDist        = ShapeSpecs[OBJECT_SELLPRINT_TEXT,i,myColumn,X_POS];
                   myWidth        = GetTextWidthNew(SellVolStr,PrintFont,PrintFontSize);
                   SetXDist       (myShape, (myXDist - myWidth));
              } else {
                   SellVolStr     = " ";
              }
              UpdateText(myShape, SellVolStr);
              
              // BUY PRINTS
              myColumn  = BuyPrintColumns[j];
              BuyVol    = Prints[ColumnToPrint,i,BUY_VOL];
              myShape   = ShapeNames[OBJECT_BUYPRINT_TEXT,i,myColumn];
              
              if (BuyVol > 0) {
                   BuyVolStr      = DoubleToString(BuyVol, 0);
                   UpdateText     (myShape, BuyVolStr);
              } else {
                   BuyVolStr      = " ";
                   
              }
              UpdateText(myShape, BuyVolStr);
              
              
              ColumnToPrint--;
         }
         
         // BOX OFF LAST TRADED PRICE (currently set to between bid/ask print)
         if (PriceLadderLevels[i] == TimeAndSalesList[ArrSize-1,TRADE_LAST]) {
              
              // REMOVE PREVIOUS BORDER
              SetShapeBorderWidth(ShapeNames[OBJECT_SELLPRINT_SHAPE,PreviouslyTradedRow,SellPrintColumn], 0);
              SetShapeBorderWidth(ShapeNames[OBJECT_BUYPRINT_SHAPE,PreviouslyTradedRow,BuyPrintColumn], 0);
              
              // SET NEW ONE
              PreviouslyTradedRow = i;
              

              // CHANGE PRITN SIZE TO REFLECTION PARTH IN THE WHOLE
              //SetShapeWidth(ShapeNames[OBJECT_SELLPRINT_SHAPE,PreviouslyTradedRow,SellPrintColumn], 
              
              if        (TimeAndSalesList[ArrSize-1,TRADE_INSTIGATOR] == -1) {
                   myColour = C'223,21,26';
                   UpdateBorderColour(ShapeNames[OBJECT_SELLPRINT_SHAPE,PreviouslyTradedRow,SellPrintColumn], myColour);
                   SetShapeBorderWidth(ShapeNames[OBJECT_SELLPRINT_SHAPE,PreviouslyTradedRow,SellPrintColumn], PriceLadderBorderWidth);
              SetShapeBorderStyle(ShapeNames[OBJECT_SELLPRINT_SHAPE,PreviouslyTradedRow,SellPrintColumn], LastPriceBoxStyle);
                   
              } else if   (TimeAndSalesList[ArrSize-1,TRADE_INSTIGATOR] == 1) {
                   myColour = C'0,218,60';
                   UpdateBorderColour(ShapeNames[OBJECT_BUYPRINT_SHAPE,PreviouslyTradedRow,BuyPrintColumn], myColour);
                   SetShapeBorderWidth(ShapeNames[OBJECT_BUYPRINT_SHAPE,PreviouslyTradedRow,BuyPrintColumn], PriceLadderBorderWidth);
              SetShapeBorderStyle(ShapeNames[OBJECT_BUYPRINT_SHAPE,PreviouslyTradedRow,BuyPrintColumn], LastPriceBoxStyle);
              } else {
                   myColour = clrWhiteSmoke;
                   UpdateBorderColour(ShapeNames[OBJECT_SELLPRINT_SHAPE,PreviouslyTradedRow,SellPrintColumn], myColour);
              }
         }
    }
    
    if (LastPriceBoxStyle == STYLE_DASH) {
         LastPriceBoxStyle = STYLE_DASHDOTDOT;
    } else {
         LastPriceBoxStyle = STYLE_DASH;
    }

    //____________________ UPDATE TIME AND SALES TEXTS ____________________
    int iRow = (ArrSize - 1);
    
    for (int i = 0; i < NoOfTimeAndSalesRows; i++) {
         if        (TimeAndSalesList[iRow, TRADE_INSTIGATOR] == -1)  myColour = C'223,21,26';
         else if   (TimeAndSalesList[iRow, TRADE_INSTIGATOR] == 1)   myColour = C'0,218,60';
         else                                                        myColour = clrWhiteSmoke;
         
         string Suffix = "";
         if (i == 0)    Suffix = "<";
         else           Suffix = "";
         
         StringConcatenate(myText,DoubleToString(TimeAndSalesList[iRow,TRADE_VOLUME], 0),
                                  "  ",
                                  DoubleToString(TimeAndSalesList[iRow,TRADE_LAST], myDigits)
                                  );
                          //      "  ",
                          //        TimeToString((int)TimeAndSalesList[iRow,TRADE_TIME], TIME_MINUTES|TIME_SECONDS),
                          //        ".",
                          //        StringSubstr(  DoubleToString(TimeAndSalesList[iRow,TRADE_TIMEMSC],0), 10, 3),
                          //        " ", Suffix
                          //);
         
         UpdateText  (ShapeNames[OBJECT_TIMEANDSALES_TEXT,i,TimeAndSalesColumn], myText);
         UpdateTextColour(ShapeNames[OBJECT_TIMEANDSALES_TEXT,i,TimeAndSalesColumn], myColour);
         
         iRow--;
    }
}

}


