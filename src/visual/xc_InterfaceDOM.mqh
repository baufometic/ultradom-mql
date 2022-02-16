//____________________ REMOVING PREVIOUS SHAPES ON DOM UPDATES ____________________
//int	CurrentDepthLevelToRemove	= 0;
//int     NoOfBidShapesToRemove    	[MAXIMUM_NO_OF_GRIDS];
//int	NoOfAskShapesToRemove		[MAXIMUM_NO_OF_GRIDS];
//string	BidTextLabelsToRemove		[MAXIMUM_NO_OF_GRIDS, 100];
//string	BidShapeLabelsToRemove		[MAXIMUM_NO_OF_GRIDS, 100];
//string	AskTextLabelsToRemove		[MAXIMUM_NO_OF_GRIDS, 100];
//string	AskShapeLabelsToRemove		[MAXIMUM_NO_OF_GRIDS, 100];
//string	LadderShapeLabelsToRemove	[MAXIMUM_NO_OF_GRIDS, 4];
//#define	ACTIVEBIDTEXT				0
//#define	ACTIVEBIDSHAPE				1
//#define	ACTIVEASKTEXT				2
//#define	ACTIVEASKSHAPE				3

//____________________ STORAGE ____________________
//double 		PRICE_LADDER_LEVELS 		[,100];	// DOM | ROW

		
  		// Update_PriceLadder(WhichDOM);         
		
		
		
		
		
		
          //+-------------------------------------------------------------------+
		//|					UPDATE PRICE LADDER 					|
		//+-------------------------------------------------------------------+
		int LadderPosition(int WhichGrid, double WhichPrice) {
               int	GridRows	= GRID_SETTINGS[WhichGrid,GRID_ROWS];
               int	myPos	= 0;
               
               for (int i = 0; i < GridRows; i++) {
                    if (PRICE_LADDER_LEVELS[WhichGrid, i] == WhichPrice) {
                         return((GridRows - myPos) - 1);
                    } else {
                         myPos++;
                    }
               }
               
               return(-1);
          }
          
          //+-------------------------------------------------------------------+
		//|					UPDATE BOOK PRICES						|
		//+-------------------------------------------------------------------+
  		//void Update_AllDOMBooks() {
		//	for (int WhichGrid = 0; WhichGrid < MAXIMUM_NO_OF_GRIDS; WhichGrid++) {
		//		if (GridIsActive(WhichGrid)) {
		//			Update_DOMBook(WhichGrid);
		//		}
		//	}
		//}
		
		void Update_DOMBook(int WhichGrid) {		// remember WhichGrid doesn't move up linearly, random ones can be activated
			
			GridBeingUpdated = WhichGrid;	// temp
			
			// need a checkpoint here later to ensure the market names etc all equate
			if (Data.Get_IndividualDepthData(GRID_SETTINGS[WhichGrid,GRID_MARKETPOS]) != 1) {
				return;
			}
			
			ResetLastError();
			
			int		MarketPos 		= GRID_SETTINGS	[WhichGrid,GRID_MARKETPOS];
			string	mySymbol			= MARKET_DATA_STRING[MarketPos,MARKET_NAME];
			
			int		BidDepthMin		= (int)MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH_MINIMUM];
			int		BidDepthMax		= (int)MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH_MAXIMUM];
			int		AskDepthMin		= (int)MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH_MINIMUM];
			int		AskDepthMax		= (int)MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH_MAXIMUM];
			
			int 		BidDepthTotalVol 	= (int)MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH_TOTAL];
			int		AskDepthTotalVol	= (int)MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH_TOTAL];
			int		MaxDepthOverall	= (int)MARKET_DATA_DOUBLE[MarketPos,DEPTH_MAX_OVERALL];
			
			int 		BidDepthColumn		= GRID_SETTINGS[WhichGrid,GRID_BIDDEPTHCOLUMN];
			int		AskDepthColumn  	= GRID_SETTINGS[WhichGrid,GRID_ASKDEPTHCOLUMN];
			int		PriceLadderColumn   = GRID_SETTINGS[WhichGrid,GRID_PRICELADDERCOLUMN];
			int		LastTradedColumn	= GRID_SETTINGS[WhichGrid,GRID_LASTTRADEDCOLUMN];
			
			//____________________ DEPTH OSCILLATION L/R ____________________
		     int		DepthCharWidth 	= GetTextWidthNew("A", DepthFont, DepthFontSize);
		     double	DepthXAdjustment	= 0.0;
			double 	DepthXTweakPercent	= 0.2;
			
			if (BidDepthTotalVol > AskDepthTotalVol) {
				DepthXAdjustment = ((1.0*AskDepthTotalVol) / (1.0*BidDepthTotalVol)) * 100 * DepthXTweakPercent;
			} else if (AskDepthTotalVol > BidDepthTotalVol) {
				DepthXAdjustment = ((1.0*BidDepthTotalVol) / (1.0*AskDepthTotalVol)) * 100 * DepthXTweakPercent;
			}
			
		     //____________________ LAST PRICE ____________________
			double	myLastPrice 		= 0;
			MqlTick 	last_tick;
			
			if (SymbolInfoTick(mySymbol, last_tick)) {
				myLastPrice = last_tick.last;
			} else {
				Files.Log("Couldn't get Last Price for " + mySymbol);
			}
			
		     //____________________ RESET EXISTING ELEMENTS ____________________
		     // BIDS
		     if (NoOfBidShapesToRemove[WhichGrid] > 0) {
		          for (int i = 0; i < NoOfBidShapesToRemove[WhichGrid]; i++) {
		               UpdateText          (BidTextLabelsToRemove [WhichGrid,i], " ");
		               SetShapeBorderWidth (BidShapeLabelsToRemove[WhichGrid,i], 0);
		               UpdateShapeColour   (BidShapeLabelsToRemove[WhichGrid,i], clrNONE);
		          }
		     }     
		     
		     // ASKS
		     if (NoOfAskShapesToRemove[WhichGrid] > 0) {
		          for (int i = 0; i < NoOfAskShapesToRemove[WhichGrid]; i++) {
		               UpdateText          (AskTextLabelsToRemove [WhichGrid,i], " ");
		               SetShapeBorderWidth (AskShapeLabelsToRemove[WhichGrid,i], 0);
		               UpdateShapeColour   (AskShapeLabelsToRemove[WhichGrid,i], clrNONE);
		          }
		     }
		     
		     // ACTIVE BID
		     UpdateTextColour(LadderShapeLabelsToRemove[WhichGrid,ACTIVEBIDTEXT],   PriceLadderTextColour);
		     UpdateTextColour(LadderShapeLabelsToRemove[WhichGrid,ACTIVEBIDSHAPE],  PriceLadderBorderColour);
		     
		     // ACTIVE ASK
		     SetShapeBorderColour(LadderShapeLabelsToRemove[WhichGrid,ACTIVEASKTEXT], PriceLadderTextColour);
		     SetShapeBorderColour(LadderShapeLabelsToRemove[WhichGrid,ACTIVEASKSHAPE],PriceLadderBorderColour);
		     
		     
		     //____________________ UPDATE BID DEPTHS ____________________
		    	CurrentDepthLevelToRemove = 0;
		     NoOfBidShapesToRemove[WhichGrid] = 0;
			
		     // RUN LOOP
		     for (int Row = 0; Row < MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH_ENTRIES]; Row++) {
				int LadderPos = LadderPosition(WhichGrid, MARKET_DATA_DOUBLE[MarketPos,BID_PRICE,Row]);
				
				if (LadderPos == -1) {
					continue;
				}
				
				int       Depth          = (int)MARKET_DATA_DOUBLE[MarketPos,BID_DEPTH,Row];
				
				int		CellHeight	= GRID_SETTINGS[WhichGrid,GRID_CELLHEIGHT,LadderPos,BidDepthColumn];
				int		CellWidth		= GRID_SETTINGS[WhichGrid,GRID_CELLWIDTH, LadderPos,BidDepthColumn];
				int		CellLeft		= GRID_SETTINGS[WhichGrid,GRID_CELLLEFT,  LadderPos,BidDepthColumn];
				int		CellTop		= GRID_SETTINGS[WhichGrid,GRID_CELLTOP,   LadderPos,BidDepthColumn];
				string    ShapeToUpdate  = SHAPE_NAMES[WhichGrid,BID_DEPTH_SHAPE,  LadderPos,BidDepthColumn];
				string    TextToUpdate   = SHAPE_NAMES[WhichGrid,BID_DEPTH_TEXT,   LadderPos,BidDepthColumn];
				
				double	MaxPixelVal	= ((1.0*CellWidth) / (1.0*MaxDepthOverall));
				double	PixelsPerLot	= MathMax(MaxPixelVal, (int)((1.0 * CellWidth) / (1.0 * MaxDepthOverall)));
				
				if (PixelsPerLot <= 0) {
					Files.Log((string)PixelsPerLot + " " + (string)CellWidth + " " + (string)MaxDepthOverall);
				}
				
				//__________ LEVELS TO REMOVE ON NEXT ITERATION __________
				NoOfBidShapesToRemove    [WhichGrid]++;
				BidTextLabelsToRemove    [WhichGrid,CurrentDepthLevelToRemove] = TextToUpdate;
				BidShapeLabelsToRemove   [WhichGrid,CurrentDepthLevelToRemove] = ShapeToUpdate;
				CurrentDepthLevelToRemove++;

		          if (Row == 0) {
		               me = SHAPE_NAMES[WhichGrid,PRICE_LADDER_TEXT,LadderPos,PriceLadderColumn];
		               LadderShapeLabelsToRemove[WhichGrid,ACTIVEBIDTEXT] =  me;
					UpdateTextColour(me, BidDepthTextActiveColour);
		               
		               me = SHAPE_NAMES[WhichGrid,PRICE_LADDER_SHAPE,LadderPos,PriceLadderColumn];
		               LadderShapeLabelsToRemove[WhichGrid,ACTIVEBIDSHAPE] =  me;
		               SetShapeBorderColour(me, BidDepthBorderActiveColour);
		          }
		          
		          //__________ UPDATE BIDS __________
		          ShapeWidth= (int)((double)((1.0*Depth) * PixelsPerLot) + DepthCharWidth);
		          TextWidth = (DepthCharWidth * StringLen((string)Depth));
		          myXDist 	= (int) (CellLeft + CellWidth + DepthXAdjustment);
		          myYDist 	= CellTop;
		          
		          // DEFINE COLOUR - trapping DIV#0
		          double bDepthMinusMin	= MathMax(1, (1.0*Depth - 1.0*BidDepthMin));
		          double bDepthMaxMinusMin	= MathMax(1, (1.0*BidDepthMax - 1.0*BidDepthMin));
		          myColour 	= StringToColor(BidDepthFillColourStrings[(int) ((bDepthMinusMin / bDepthMaxMinusMin) * 99)  ]);
		          
		          // IS LAST?
		          double Bid = MARKET_DATA_DOUBLE[MarketPos,BID_PRICE,Row];
		          
				if (myLastPrice == Bid) {
					SetYDist(SHAPE_NAMES[WhichGrid,LAST_TRADED_SHAPE,0,LastTradedColumn], (int)((myYDist + (CellHeight * 0.5)) - (GRID_SETTINGS[WhichGrid,GRID_LASTTRADEDHEIGHT] * 0.5)));
				}
		          
		          // SHAPE
		          SetXDist			(ShapeToUpdate, (myXDist - ShapeWidth));
		          ObjectSetInteger	(ThisChartID,   ShapeToUpdate, OBJPROP_XSIZE, ShapeWidth);
		          UpdateShapeColour   (ShapeToUpdate, myColour);
		          SetShapeBorderColour(ShapeToUpdate, BidDepthBorderColour);
		          SetShapeBorderWidth (ShapeToUpdate, DepthBorderWidth);
		          
		          // TEXT
		          ObjectSetString	(ThisChartID,   TextToUpdate, OBJPROP_TEXT, (string)Depth);
		          SetXDist			(TextToUpdate,  (myXDist - ShapeWidth));
		     }
		     
		     //____________________ UPDATE ASK DEPTHS ____________________
		    	CurrentDepthLevelToRemove = 0;
		     NoOfAskShapesToRemove[WhichGrid] = 0;
			
		     // RUN LOOP
		     for (int Row = 0; Row < MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH_ENTRIES]; Row++) {
				int LadderPos = LadderPosition(WhichGrid, MARKET_DATA_DOUBLE[MarketPos,ASK_PRICE,Row]);
				
				if (LadderPos == -1) {
					continue;
				}
				
				int       Depth          = (int)MARKET_DATA_DOUBLE[MarketPos,ASK_DEPTH,Row];
				
				int		CellHeight	= GRID_SETTINGS[WhichGrid,GRID_CELLHEIGHT,LadderPos,AskDepthColumn];
				int		CellWidth		= GRID_SETTINGS[WhichGrid,GRID_CELLWIDTH, LadderPos,AskDepthColumn];
				int		CellLeft		= GRID_SETTINGS[WhichGrid,GRID_CELLLEFT,  LadderPos,AskDepthColumn];
				int		CellTop		= GRID_SETTINGS[WhichGrid,GRID_CELLTOP,   LadderPos,AskDepthColumn];
				string    ShapeToUpdate  = SHAPE_NAMES	[WhichGrid,ASK_DEPTH_SHAPE,LadderPos,AskDepthColumn];
				string    TextToUpdate   = SHAPE_NAMES	[WhichGrid,ASK_DEPTH_TEXT, LadderPos,AskDepthColumn];
				
				double	MaxPixelVal	= ((1.0*CellWidth) / (1.0*MaxDepthOverall));
				double	PixelsPerLot	= MathMax(MaxPixelVal, (int)((1.0 * CellWidth) / (1.0 * MaxDepthOverall)));
				
				if (PixelsPerLot <= 0) {
					Files.Log((string)PixelsPerLot + " " + (string)CellWidth + " " + (string)MaxDepthOverall);
				}
				
				//__________ LEVELS TO REMOVE ON NEXT ITERATION __________
				NoOfAskShapesToRemove    [WhichGrid]++;
				AskTextLabelsToRemove    [WhichGrid,CurrentDepthLevelToRemove] = TextToUpdate;
				AskShapeLabelsToRemove   [WhichGrid,CurrentDepthLevelToRemove] = ShapeToUpdate;
				CurrentDepthLevelToRemove++;

		          if (Row == 0) {
		               me = SHAPE_NAMES[WhichGrid,PRICE_LADDER_TEXT,LadderPos,PriceLadderColumn];
		               LadderShapeLabelsToRemove[WhichGrid,ACTIVEASKTEXT] =  me;
		               UpdateTextColour(me, AskDepthTextActiveColour);
		               
		               me = SHAPE_NAMES[WhichGrid,PRICE_LADDER_SHAPE,LadderPos,PriceLadderColumn];
		               LadderShapeLabelsToRemove[WhichGrid,ACTIVEASKSHAPE] =  me;
		               SetShapeBorderColour(me, AskDepthBorderActiveColour);
		          }
		          
		          //__________ UPDATE ASKS __________
		          ShapeWidth= (int)((double)((1.0*Depth) * PixelsPerLot) + DepthCharWidth);
		          TextWidth = (DepthCharWidth * StringLen((string)Depth));
		          myXDist 	= (int) (CellLeft + DepthXAdjustment);
		          myYDist 	= CellTop;
		          
		          // DEFINE COLOUR - trapping DIV#0
		          double aDepthMinusMin	= MathMax(1, (1.0*Depth - 1.0*AskDepthMin));
		          double aDepthMaxMinusMin	= MathMax(1, (1.0*AskDepthMax - 1.0*AskDepthMin));
		          myColour 	= StringToColor(AskDepthFillColourStrings[(int) ((aDepthMinusMin / aDepthMaxMinusMin) * 99)  ]);
		          
		          // IS LAST?
		          double Ask = MARKET_DATA_DOUBLE[MarketPos,ASK_PRICE,Row];
		          
				if (myLastPrice == Ask) {
					SetYDist(SHAPE_NAMES[WhichGrid,LAST_TRADED_SHAPE,0,LastTradedColumn], (int)((myYDist + (CellHeight * 0.5)) - (GRID_SETTINGS[WhichGrid,GRID_LASTTRADEDHEIGHT] * 0.5)));
				}
		          
		          // SHAPE
		          SetXDist			(ShapeToUpdate, myXDist);
		          ObjectSetInteger	(ThisChartID,   ShapeToUpdate, OBJPROP_XSIZE, ShapeWidth);
		          UpdateShapeColour   (ShapeToUpdate, myColour);
		          SetShapeBorderColour(ShapeToUpdate, AskDepthBorderColour);
		          SetShapeBorderWidth (ShapeToUpdate, DepthBorderWidth);
		          
		          // TEXT
		          ObjectSetString	(ThisChartID,   TextToUpdate, OBJPROP_TEXT, (string)Depth);
		          SetXDist			(TextToUpdate,  (myXDist + ShapeWidth) - TextWidth);
		     }
		}
          
          
          TotalNoOfShapes = 
          Rows x    BidShape, Text, BidShape background, textshadow
          
          Bids
          
          
          
     	//+-------------------------------------------------------------------+
		//|					UPDATE PRICE LADDER 					|
		//+-------------------------------------------------------------------+
		void Update_PriceLadder(int WhichGrid) {
			ResetLastError();
			Files.Log(__FUNCSIG__);
			
               int		GridRows		= GRID_SETTINGS	[WhichGrid, GRID_ROWS];
               int		MarketPos		= GRID_SETTINGS	[WhichGrid, GRID_MARKETPOS];
               string    symbol		= MARKET_DATA_STRING[MarketPos, MARKET_NAME];
               
               		myDigits		= (int)SymbolInfoInteger (symbol, SYMBOL_DIGITS);
               		myTickSize	= SymbolInfoDouble       (symbol, SYMBOL_TRADE_TICK_SIZE);
               		myBid		= SymbolInfoDouble       (symbol, SYMBOL_BID);
               		myAsk		= SymbolInfoDouble       (symbol, SYMBOL_ASK);

               // FIGURE OUT THE PRICE AT THE TOP OF THE DOM
               double TopPrice = myBid + ((GridRows / 2) * myTickSize);
               
               int SuperTempLevels[];
               ArrayResize(SuperTempLevels, GridRows);
               int Multiplier           = (int)MathPow(10, myDigits);
               int TickSizeMultiplied   = (int)(myTickSize * Multiplier);
                              
               for (int Row = 0; Row < GridRows; Row++) {
                    SuperTempLevels[Row] = (int)((TopPrice * Multiplier) - (Row * TickSizeMultiplied));
                    
                    // UPDATE PRICE LADDER TEXT
                    int myColumn  	= GRID_SETTINGS[WhichGrid,GRID_PRICELADDERCOLUMN];
                    me = SHAPE_NAMES[WhichGrid,PRICE_LADDER_TEXT,Row,myColumn];
                    UpdateText(me, DoubleToString(((1.0*SuperTempLevels[Row]) / Multiplier), myDigits));
                    
                    // UPDATE PSYCHO SHAPES
                    myColumn		= GRID_SETTINGS[WhichGrid,GRID_PSYCHOSCOLUMN];
                    me = SHAPE_NAMES[WhichGrid,PSYCHO_SHAPE,Row,myColumn];
                    
                    if (MathMod(SuperTempLevels[Row], (TickSizeMultiplied * 10)) == 0) {
                        	SetShapeBorderColour(me, TronOrange);
                         SetShapeBorderWidth (me, 2);
                         UpdateShapeColour   (me, TronOrange);
                    } else {
                         SetShapeBorderColour(me, clrNONE);
                         SetShapeBorderWidth (me, 0);
                         UpdateShapeColour   (me, clrNONE);
                    }
               }
               
               ArraySort(SuperTempLevels);
               
               for (int Row = 0; Row < GridRows; Row++) {
                    PRICE_LADDER_LEVELS[WhichGrid,Row] = ((1.0*SuperTempLevels[Row]) / Multiplier);
               }
		}
};
cDOM DOM;







 
 

//		
//		void Update_PrintBoxes() {
//			// MOVING PRICE PRINT BOXES
//               int Rows = GridSettings[GridPointer,GRIDROWS];
//               
//               for (int i = 0; i < Rows; i++) {
//                    //____________________ CANDLESTICKS ____________________
//                    if ((MousePosX >= (IndividualGridWidth * GridPointer)) && (MousePosX <= (IndividualGridWidth * (GridPointer+1)))) {
//                    } else {
//                         break;
//                    }
//                    
//                    myWidth = (int)MathAbs(MousePosX - GridSettings[myPosInArray,GRIDXDIST]);
//                    
//                    MqlRates rates[1];
//                    if (CopyRates(Symbol(), PERIOD_M15, 0, 1, rates) != 1) {
//                         Log.Write("UNABLE TO GRAB OHLC DATA");
//                    } else {
//                         //Log.Write("OP " + rates[0].open + " | HI " + rates[0].high + " | LO " + rates[0].low + " | CL " + rates[0].close);
//                    }
//                    
//                    if (myWidth <= PrintMinWidth) {
//                         me   = ShapeNames[WhichGrid,PRINT_SHAPE,i,0];
//                         
//                         int  RowsInRangeCol1[3];
//                         RowsInRangeCol1[0] = 12;
//                         RowsInRangeCol1[1] = 13;
//                         RowsInRangeCol1[2] = 14;
//                         ArraySort(RowsInRangeCol1);
//                         
//                         int CandlePos = ArrayBsearch(RowsInRangeCol1, i);
//                         
//                         if (RowsInRangeCol1[CandlePos] == i) {  // current row in outer loop is found in candlestick
//                              UpdateBorderColour(me, clrBlue);
//                              SetShapeBorderWidth(me, 3);
//                         } else {
//                              UpdateBorderColour(me, clrNONE);
//                              SetShapeBorderWidth(me, 0);
//                         }
//                    }
//                    
//                    for (int j = 0; j < NoOfPrintColumns; j++) { // columns
//                         // PRINT BOXES
//                         myWidth = (int)MousePosX;
//                         SetShapeWidth(ShapeNames[WhichGrid,PRINT_SHAPE,i,j], myWidth);
//                         myXDist = PrintLocations[WhichGrid,i,j,PrintXDist] - ((j + 1) * myWidth);
//                         SetXDist(ShapeNames[WhichGrid,PRINT_SHAPE,i,j], myXDist);
//                         
//                         int XDiff = MathAbs(myWidth-PrintMinWidth);
//                         if (XDiff < 255) {
//                              clrR = (int)XDiff;
//                              clrG = (int)XDiff;
//                              clrB = (int)XDiff;
//                         } else {
//                              clrR = 255;
//                              clrG = 255;
//                              clrB = 255;
//                         }
//                              
//                         //__________ FOOTPRINT CONTROL __________
//                         if (myWidth <= PrintMinWidth) {
//                              // SHAPE
//                              me                  = ShapeNames[WhichGrid,PRINT_SHAPE,i,j];
//                              //StringConcatenate   (ColourString, "C'", "222", ",", clrG, ",", "111", "'");
//                              
//                              // TEXT
//                              me                  = ShapeNames[WhichGrid,PRINT_TEXT,i,j];
//                              UpdateText          (me, " ");
//                              
//                         } else {
//                              // SHAPE
//                              me                  = ShapeNames[WhichGrid,PRINT_SHAPE,i,j];
//                              StringConcatenate   (ColourString, "C'", clrR, ",", clrG, ",", clrB, "'");
//                              UpdateBorderColour  (me, StringToColor(ColourString));
//                              
//                              // TEXT
//                              me                  = ShapeNames[WhichGrid,PRINT_TEXT,i,j];
//                              StringConcatenate   (ColourString, "C'", clrR, ",", clrG, ",", clrB, "'");
//                              UpdateTextColour    (me, StringToColor(ColourString));
//                              
//                              StringConcatenate   (myText, "X", j, "Y", i);
//                              UpdateText          (me, myText);
//                              SetXDist            (me, PrintLocations[WhichGrid,i,j,PrintXDist] - ((j + 1) * myWidth));
//                              SetXDist            (me, (int)(myXDist + (myWidth * 0.5) - (GetTextWidthNew(myText, PrintFont, PrintFontSize) * 0.5))  );
//                         }
//                    }
//               }
//		}
