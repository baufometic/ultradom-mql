//*********************************************
// DOM DEFAULT PARAMETERS, IF NOT FOUND IN A SETTINGS FILE, REVERT TO THESE
#define		MINIMUM_NO_OF_DOMS		5	// BOUNDARIES
#define		MAXIMUM_NO_OF_DOMS		5
#define   	DOM_ROWS				100
#define   	DOM_COLUMNS			50
int			NO_OF_ACTIVE_DOMS		= 0;
//*********************************************

// HOLDS ALL INFORMATION ON THE DOM ITSELF. POSITION, SIZE, WHAT IT REPRESENTS
struct sDOMSpecs {
	int 		Rows, Columns;
	int			ZoomPercent;
	int 		ContainerTop, ContainerBottom, ContainerLeft, ContainerRight, ContainerHeight, ContainerWidth, ContainerPadding, Top, Bottom, Left, Right, Height, Width;
	int 		CentreColumn, VolumeProfileColumn, BidDepthColumn, AskDepthColumn, LastTradedColumn, PsychoColumn, PriceLadderColumn;
	string		MarketName[];
};
sDOMSpecs DOMSpecs[/*WHICH DOM*/];

// DOMCELLS IS USED BY THE DOM ELEMENTS TO ALIGN TO IT
struct sDOMCells {
	string 	Name	[DOM_ROWS,DOM_COLUMNS];	// WILL MAKE THIS INVISIBLE ON SCREEN, JUST NEEDS A NAME TEMPORARILY SO I CAN SEE ITS SHAPE IN POSITION
	int		Top 	[DOM_ROWS,DOM_COLUMNS], Bottom[DOM_ROWS,DOM_COLUMNS], Left[DOM_ROWS,DOM_COLUMNS], Right[DOM_ROWS,DOM_COLUMNS], Height[DOM_ROWS,DOM_COLUMNS], Width[DOM_ROWS,DOM_COLUMNS];		
	int		CentreX	[DOM_ROWS,DOM_COLUMNS], CentreY[DOM_ROWS,DOM_COLUMNS];
};
sDOMCells DOMCells[/*WHICH DOM*/];

// DOMObjects is a nephew of ShapeGroup
struct sDOMObjects {
	int		ShapeObjectTop		[DOM_ROWS], ShapeObjectBottom	[DOM_ROWS], ShapeObjectLeft[DOM_ROWS], ShapeObjectRight[DOM_ROWS], ShapeObjectCentreX[DOM_ROWS], ShapeObjectCentreY[DOM_ROWS];
	int		TextObjectTop		[DOM_ROWS], TextObjectBottom	[DOM_ROWS], TextObjectLeft [DOM_ROWS], TextObjectRight	[DOM_ROWS], TextObjectCentreX [DOM_ROWS], TextObjectCentreY [DOM_ROWS];
	int		ShapeObjectHeight	[DOM_ROWS], ShapeObjectWidth	[DOM_ROWS], ShapeObjectXPadding[DOM_ROWS], ShapeObjectYPadding[DOM_ROWS];
	int		TextObjectHeight	[DOM_ROWS], TextObjectWidth	[DOM_ROWS], TextObjectXPadding [DOM_ROWS], TextObjectYPadding [DOM_ROWS];
	int		BorderWidthActive	[DOM_ROWS], BorderWidthInactive	[DOM_ROWS], BorderStyleActive[DOM_ROWS], BorderStyleInactive[DOM_ROWS];
	color 	FillColourActive 	[DOM_ROWS], FillColourInactive	[DOM_ROWS], FillColourGradientActive[100], BorderColourActive[DOM_ROWS], BorderColourInactive[DOM_ROWS],	BorderColourGradientActive[100];
	color	FontColourActive	[DOM_ROWS], FontColourInactive[DOM_ROWS];
	int		FontSize			[DOM_ROWS];
	string 	ShapeObjectName		[DOM_ROWS];
	string	TextObjectName		[DOM_ROWS], Value[DOM_ROWS], Font;
};
sDOMObjects PsychoLineObjects[/*WHICH DOM*/], VolumeProfileObjects[], PriceLadderObjects[], BidDepthObjects[], AskDepthObjects[], LastTradedPriceObjects[];	// which DOM [], rows are contained within each element required

class cDOM {
	public:
		void Set_Positions() {	// DONE IN 
			
			switch(NO_OF_ACTIVE_DOMS) {
				case 1:	// JUST ONE DOM
						myHeight			= DOMContainer.Height - (myPadding * 2);
						myWidth				= DOMContainer.Width - (myPadding * 2);
						myTop				= DOMContainer.Top + myPadding;
						
						DOMSpecs[0].Height	= myHeight;
						DOMSpecs[0].Width	= myWidth;
						DOMSpecs[0].Top		= myTop;
						DOMSpecs[0].Bottom	= myTop + myHeight;
						DOMSpecs[0].Left	= DOMContainer.Left + myPadding;
						DOMSpecs[0].Right	= DOMSpecs[0].Left + myWidth;
						
						break;
				
				case 2:	// 2 x SIDE BY SIDE VERTICALLY
						myWidthFull			= DOMContainer.Width / 2;
						myHeight 			= DOMContainer.Height - (myPadding * 2);
						myWidth				= myWidthFull - (myPadding * 2);
						myTop				= DOMContainer.Top + myPadding;
						
						DOMSpecs[0].Height	= myHeight; 
						DOMSpecs[0].Width	= myWidth;
						DOMSpecs[0].Top		= myTop;
						DOMSpecs[0].Bottom	= myTop + myHeight;
						DOMSpecs[0].Left	= DOMContainer.Left + myPadding;
						DOMSpecs[0].Right	= DOMSpecs[0].Left + myWidth;
						
						DOMSpecs[1].Height	= myHeight;
						DOMSpecs[1].Width	= myWidth;
						DOMSpecs[1].Top		= myTop;
						DOMSpecs[1].Bottom	= myTop + myHeight;
						DOMSpecs[1].Left	= DOMContainer.Left + myWidthFull + myPadding;
						DOMSpecs[1].Right	= DOMSpecs[0].Left + myWidth;
						
						break;
						
				case 3:	// 3 x SIDE BY SIDE VERTICALLY
						myWidthFull			= DOMContainer.Width / 3;
						myHeight			= DOMContainer.Height - (myPadding * 2);
						myWidth				= myWidthFull - (myPadding * 2);
						myTop				= DOMContainer.Top + myPadding;
						
						DOMSpecs[0].Height	= myHeight;
						DOMSpecs[0].Width	= myWidth;
						DOMSpecs[0].Top		= myTop;
						DOMSpecs[0].Bottom	= myTop + myHeight;
						DOMSpecs[0].Left	= DOMContainer.Left + myPadding;
						DOMSpecs[0].Right	= DOMSpecs[0].Left + myWidth;
						
						DOMSpecs[1].Height	= myHeight;
						DOMSpecs[1].Width	= myWidth;
						DOMSpecs[1].Top		= myTop;
						DOMSpecs[1].Bottom	= myTop + myHeight;
						DOMSpecs[1].Left	= DOMContainer.Left + (myWidthFull * 1) + myPadding;
						DOMSpecs[1].Right	= DOMSpecs[0].Left + myWidth;
						
						DOMSpecs[2].Height	= myHeight;
						DOMSpecs[2].Width	= myWidth;
						DOMSpecs[2].Top		= myTop;
						DOMSpecs[2].Bottom	= myTop + myHeight;
						DOMSpecs[2].Left	= DOMContainer.Left + (myWidthFull * 2) + myPadding;
						DOMSpecs[2].Right	= DOMSpecs[0].Left + myWidth;
						
						break;
				
				case 4:	// 4 x 2 on top, 2 below
						myHeightFull		= DOMContainer.Height / 2;
						myWidthFull			= DOMContainer.Width / 2;
						myHeight			= myHeightFull - (myPadding * 2);
						myWidth				= myWidthFull - (myPadding * 2);
						
						myTop				= DOMContainer.Top + myPadding;
						DOMSpecs[0].Height	= myHeight;
						DOMSpecs[0].Width	= myWidth;
						DOMSpecs[0].Top		= myTop;
						DOMSpecs[0].Bottom	= myTop + myHeight;
						DOMSpecs[0].Left	= DOMContainer.Left + myPadding;
						DOMSpecs[0].Right	= DOMSpecs[0].Left + myWidth;
						
						DOMSpecs[1].Height	= myHeight;
						DOMSpecs[1].Width	= myWidth;
						DOMSpecs[1].Top		= myTop;
						DOMSpecs[1].Bottom	= myTop + myHeight;
						DOMSpecs[1].Left	= DOMContainer.Left + (myWidthFull * 1) + myPadding;
						DOMSpecs[1].Right	= DOMSpecs[0].Left + myWidth;
						
						myTop				= DOMContainer.Top + (myHeightFull * 1) + myPadding;
						DOMSpecs[2].Height	= myHeight;
						DOMSpecs[2].Width	= myWidth;
						DOMSpecs[2].Top		= myTop;
						DOMSpecs[2].Bottom	= myTop + myHeight;
						DOMSpecs[2].Left	= DOMContainer.Left + myPadding;
						DOMSpecs[2].Right	= DOMSpecs[0].Left + myWidth;
						
						DOMSpecs[3].Height	= myHeight;
						DOMSpecs[3].Width	= myWidth;
						DOMSpecs[3].Top		= myTop;
						DOMSpecs[3].Bottom	= myTop + myHeight;
						DOMSpecs[3].Left	= DOMContainer.Left + (myWidthFull * 1) + myPadding;
						DOMSpecs[3].Right	= DOMSpecs[0].Left + myWidth;
						
						break;
			}
		}
};

class cDOMObjects {
     public:
     	//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
		//|                                                          			INITIALISE DOMS                                                                     |
		//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
		bool Initialise() {
     		ResetLastError();
     		Files.Log(__FUNCSIG__);

     		if (Files.Exists(SETTINGS_FILENAME)) {
     			//ReadSettings();
     		} else {
    				//SaveSettings();
     		}
     		
     		NO_OF_ACTIVE_DOMS = MathMin(NO_OF_MARKETS, MAXIMUM_NO_OF_DOMS);
     		Files.Log("BUILDING " + (string)NO_OF_ACTIVE_DOMS + " DOM'S ");
			
			ArrayResize(DOMSpecs, 			NO_OF_ACTIVE_DOMS); // different
			
			ArrayResize(PsychoLineObjects, 	NO_OF_ACTIVE_DOMS);
			ArrayResize(VolumeProfileObjects,	NO_OF_ACTIVE_DOMS);
			ArrayResize(PriceLadderObjects, 	NO_OF_ACTIVE_DOMS);
			ArrayResize(BidDepthObjects, 		NO_OF_ACTIVE_DOMS);
			ArrayResize(AskDepthObjects, 		NO_OF_ACTIVE_DOMS);
			ArrayResize(LastTradedPriceObjects,NO_OF_ACTIVE_DOMS);
			
			//
			
			//+-------------------------------------------------------------------+
			//|				OUTER POSITIONING / 	CONTAINERS			|
			//+-------------------------------------------------------------------+
			myPadding = 10;
			
			//+-------------------------------------------------------------------+
			//|						BUILD							|
			//+-------------------------------------------------------------------+
			for (int WhichDOM = 0; WhichDOM < NO_OF_ACTIVE_DOMS; WhichDOM++) {
				
				// OVERALL FONTS (CAN BE CHANGED BY USER!)
				PriceLadderObjects	[WhichDOM].Font = ArialBlack;
				BidDepthObjects	[WhichDOM].Font = OCR;
				AskDepthObjects	[WhichDOM].Font = OCR;
				
				// ELEMENT COLUMNS
				int CentreColumn = (DOM_COLUMNS - 1) / 2;
				DOMSpecs[WhichDOM].CentreColumn				= CentreColumn;	// COLUMNS MUST BE AN _ODD_ NUMBER
				DOMSpecs[WhichDOM].VolumeProfileColumn			= CentreColumn + 1;
				DOMSpecs[WhichDOM].BidDepthColumn				= CentreColumn - 1;
				DOMSpecs[WhichDOM].AskDepthColumn				= CentreColumn + 1;
				DOMSpecs[WhichDOM].PriceLadderColumn			= CentreColumn;
				DOMSpecs[WhichDOM].LastTradedColumn			= CentreColumn;
				DOMSpecs[WhichDOM].PsychoColumn				= CentreColumn - 1;
				
				// ESTABLISH COLOUR GRADIENTS
	               int       StartingColour	= 20;
	               int       EndingColour   = 250;
	               int		clrSteps		= 100;
	               double    Step			= ((1.0*StartingColour) - (1.0*EndingColour)) / clrSteps;
	               for (int i = 0; i < clrSteps; i++) {
	                    StartingColour -= (int)Step;
	                    BidDepthObjects[WhichDOM].FillColourGradientActive[i] = StringToColor("C'" + (string)0 + "," + (string)StartingColour + "," + (string)0 + "'");
	                    AskDepthObjects[WhichDOM].FillColourGradientActive[i] = StringToColor("C'" + (string)StartingColour + "," + (string)0 + "," + (string)0 + "'");
	               }
	               
	               // FOR DEBUGGING - MAKE SHAPES VISIBLE BY DEFAULT
	               if (DEV_MODE) {
	               	myFillColour 	= RandomColour();
	               	myColour 		= 
	               	myBorderColour	= RandomColour();
	               	myBorderWidth 	= 1;
	               	myBorderStyle	= STYLE_SOLID;
	               	myBorderType	= BORDER_FLAT;
	               	myTextColour	= clrWhiteSmoke;
	               } else {
	               	myFillColour 	= clrNONE;	// else invisible
	               	myBorderColour	= clrNONE;
	               	myBorderWidth 	= 0;
	               	myBorderStyle	= STYLE_SOLID;
	               	myBorderType	= BORDER_FLAT;
	               	myTextColour	= clrNONE;
	               }
	               
				for (int myRow = 0; myRow < Rows; myRow++) {
					
	               	// SKELETAL GRID
	               	for (int myColumn = 0; myColumn < Columns; myColumn++) {
	               		me = "UltraDOM_DOM_" + (string)WhichDOM + "_Grid_Row" + (string)myRow + "_Column" + (string)myColumn;
						GridShapeObjects[WhichDOM].Name[myRow,myColumn] = me;
						CreateRectangleLabel(me, CORNER_LEFT_UPPER, 0, 0, 0, 0, myFillColour, true, myBorderType, myBorderColour, myBorderStyle, myBorderWidth);	// temporary visible as shape
						GridShapeObjects[WhichDOM].Left = 
					}
					
					// SHAPES
					me = "UltraDOM_DOM_" + (string)WhichDOM + "_PsychoLineShape_Row_" + (string)myRow;
	                    PsychoLineObjects[WhichDOM].ShapeObjectName[myRow] = me;
					CreateRectangleLabel(me, CORNER_LEFT_UPPER, 0, 0, 0, 0, myFillColour, true, myBorderType, myBorderColour, myBorderStyle, myBorderWidth);
	                    
	                    me = "UltraDOM_DOM_" + (string)WhichDOM + "_VolumeProfileShape_Row_" + (string)myRow;
					VolumeProfileObjects[WhichDOM].ShapeObjectName[myRow] = me;
	                    CreateRectangleLabel(me, CORNER_LEFT_UPPER, 0, 0, 0, 0, myFillColour, true, myBorderType, myBorderColour, myBorderStyle, myBorderWidth);
	                    
	                    me = "UltraDOM_DOM_" + (string)WhichDOM + "_PriceLadderShape_Row_" + (string)myRow;
					PriceLadderObjects[WhichDOM].ShapeObjectName[myRow] = me;
	                    CreateRectangleLabel(me, CORNER_LEFT_UPPER, 0, 0, 0, 0, myFillColour, true, myBorderType, myBorderColour, myBorderStyle, myBorderWidth);
	                    
	                    me = "UltraDOM_DOM_" + (string)WhichDOM + "_BidDepthShape_Row_" + (string)myRow;
	                    BidDepthObjects[WhichDOM].ShapeObjectName[myRow] = me;
	                    CreateRectangleLabel(me, CORNER_LEFT_UPPER, 0, 0, 0, 0, myFillColour, true, myBorderType, myBorderColour, myBorderStyle, myBorderWidth);
	            		
	            		me = "UltraDOM_DOM_" + (string)WhichDOM + "_AskDepthShape_Row_" + (string)myRow;
	                    AskDepthObjects[WhichDOM].ShapeObjectName[myRow] = me;
	                    CreateRectangleLabel(me, CORNER_LEFT_UPPER, 0, 0, 0, 0, myFillColour, true, myBorderType, myBorderColour, myBorderStyle, myBorderWidth);
	                    
	                    me = "UltraDOM_DOM_" + (string)WhichDOM + "_LastTradedShape_Row_" + (string)myRow;
					LastTradedPriceObjects[WhichDOM].ShapeObjectName[myRow] = me;
					CreateRectangleLabel(me, CORNER_LEFT_UPPER, 0, 0, 0, 0, myFillColour, true, myBorderType, myBorderColour, myBorderStyle, myBorderWidth);
					
					// TEXT
					me = "UltraDOM_DOM_" + (string)WhichDOM + "_PriceLadderText_Row_" + (string)myRow;
	                    PriceLadderObjects	[WhichDOM].TextObjectName[myRow] = me;
	                    CreateLabel		(me, " ", PriceLadderObjects[WhichDOM].Font, 10, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 0, 0, myTextColour, true);
					
					me = "UltraDOM_DOM_" + (string)WhichDOM + "_BidDepthText_Row_" + (string)myRow;
					BidDepthObjects	[WhichDOM].TextObjectName[myRow] = me;
	                    CreateLabel		(me, " ", BidDepthObjects[WhichDOM].Font, 10, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 0, 0, myTextColour, true);
	                    
	                    me = "UltraDOM_DOM_" + (string)WhichDOM + "_AskDepthText_Row_" + (string)myRow;
	                    AskDepthObjects	[WhichDOM].TextObjectName[myRow] = me;
	                    CreateLabel		(me, " ", AskDepthObjects[WhichDOM].Font, 10, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 0, 0, myTextColour, true);
	               }
			}
			
			return(true);
		}
};
cDOMObjects DOMObjects;
		
		
//		void Set_PositionsOfAllDOMs() {
//			for (int WhichDOM = 0; WhichDOM < NO_OF_ACTIVE_DOMS; WhichDOM++) {
//				Set_PositionsOfOneDOM(WhichDOM);
//			}
//		}
//		
//		void Set_PositionsOfOneDOM(int WhichDOM) {	// EVERY ASPECT OF DOM
//			ResetLastError();
//			
//			// ALIGNMENTS -- outsub this
//               int 	Rows 		= DOMSpecs[WhichDOM].Rows;
//               int 	Columns		= DOMSpecs[WhichDOM].Columns;
//               //int	ZoomPercent	= 0.15;
//               
//			//int		myColumn				= -1;
//			
//			int		Rows		= DOMSpecs[WhichDOM].Rows;
//			int		Columns	= DOMSpecs[WhichDOM].Columns;
//			
//			for (int Row = 0; Row < Rows; Row++) {
//				for (int Column = 0; Column < Columns; Column++) {
//					me			= GridShapeObjects[WhichDOM].Name[Row,Column];
//					SetXDist		(me, DOMSpecs[WhichDOM].CellLeft	[Row,Column]);
//					SetYDist		(me, DOMSpecs[WhichDOM].
//					SetShapeHeight	(me, DOMSpecs[WhichDOM].CellHeight	[Row,Column]);
//					SetShapeWidth	(me, DOMSpecs[WhichDOM].CellWidth	[Row,Column]);
//				}
//				
//				//____________________ PSYCHO LINES ____________________
//				me			= DOMShapes[WhichDOM].PsychoShape			[Row];
//				SetShapeHeight	(me, DOMSpecs[WhichDOM].PsychoHeight		[Row]);
//				SetShapeWidth	(me, DOMSpecs[WhichDOM].PsychoWidth		[Row]);
//				SetXDist		(me, DOMSpecs[WhichDOM].PsychoLeft			[Row]);
//				SetYDist		(me, DOMSpecs[WhichDOM].PsychoTop			[Row]);
//				
//				//____________________ VOLUME PROFILE ____________________
//				me			= DOMShapes[WhichDOM].VolumeProfileShape	[Row];
//				SetShapeHeight	(me, DOMSpecs[WhichDOM].VolumeProfileHeight	[Row]);
//				SetShapeWidth	(me, DOMSpecs[WhichDOM].VolumeProfileWidth	[Row]);
//				SetXDist		(me, DOMSpecs[WhichDOM].VolumeProfileLeft	[Row]);
//				SetYDist		(me, DOMSpecs[WhichDOM].VolumeProfileTop	[Row]);
//				
//				//____________________ PRICE LADDER SHAPE ____________________
//				me			= DOMShapes[WhichDOM].PriceLadderShape		[Row];
//				SetShapeHeight	(me, DOMSpecs[WhichDOM].PriceLadderHeight	[Row]);
//				SetShapeWidth	(me, DOMSpecs[WhichDOM].PriceLadderWidth	[Row]);
//				SetXDist		(me, DOMSpecs[WhichDOM].PriceLadderLeft		[Row]);
//				SetYDist		(me, DOMSpecs[WhichDOM].PriceLadderTop		[Row]);
//				
//				//____________________ PRICE LADDER TEXT ____________________
//				me			= DOMShapes[WhichDOM].PriceLadderText		[Row];
//				SetXDist		(me, DOMSpecs[WhichDOM].PriceLadderTextLeft	[Row]);
//				SetYDist		(me, DOMSpecs[WhichDOM].PriceLadderTextTop	[Row]);
//				
//				//____________________ BID DEPTH SHAPE ____________________
//				myColumn		= GRID_SETTINGS[WhichGrid,GRID_BIDDEPTHCOLUMN];
//				me			= SHAPE_NAMES	[WhichGrid,BID_DEPTH_SHAPE,myRow,myColumn];
//				
//				myCellHeight	= GRID_SETTINGS[WhichGrid,GRID_CELLHEIGHT,myRow,myColumn];
//				myCellWidth	= GRID_SETTINGS[WhichGrid,GRID_CELLWIDTH, myRow,myColumn];
//				
//				myHeight		= GRID_SETTINGS[WhichGrid,GRID_BIDDEPTHHEIGHT];
//				myWidth		= GridCellWidth;
//				
//				SetShapeHeight	(me, myHeight);
//				SetShapeWidth	(me, myWidth);
//				SetXDist		(me, (int)((GRID_SETTINGS[WhichGrid,GRID_CELLLEFT,myRow,myColumn] + GridCellWidth) - myWidth));
//				SetYDist		(me, (int)((GRID_SETTINGS[WhichGrid,GRID_CELLTOP,myRow,myColumn] + (GridCellHeight * 0.5)) - (myHeight * 0.5)));
//				
//				//____________________ BID DEPTH TEXT ____________________
//				myColumn		= GRID_SETTINGS[WhichGrid,GRID_BIDDEPTHCOLUMN];
//				me			= SHAPE_NAMES	[WhichGrid,BID_DEPTH_TEXT,myRow,myColumn];
//				
//				myCellHeight	= GRID_SETTINGS[WhichGrid,GRID_CELLHEIGHT,myRow,myColumn];
//				myCellWidth	= GRID_SETTINGS[WhichGrid,GRID_CELLWIDTH, myRow,myColumn];
//				
//				myHeight		= DepthTextHeight;
//				myWidth		= DepthTextWidth;
//				
//				UpdateFontSize	(me, DepthFontSize);
//				SetXDist		(me, (int)((GRID_SETTINGS[WhichGrid,GRID_CELLLEFT,myRow,myColumn] + GridCellWidth) - myWidth));
//				SetYDist		(me, (int)((GRID_SETTINGS[WhichGrid,GRID_CELLTOP,myRow,myColumn] + (GridCellHeight * 0.5)) - (myHeight * 0.5)));
//				/// these lot are text, don't need sizes updated
//				
//				//____________________ ASK DEPTH SHAPE ____________________
//				myColumn		= GRID_SETTINGS[WhichGrid,GRID_ASKDEPTHCOLUMN];
//				me			= SHAPE_NAMES	[WhichGrid,ASK_DEPTH_SHAPE,myRow,myColumn];
//				
//				myCellHeight	= GRID_SETTINGS[WhichGrid,GRID_CELLHEIGHT,myRow,myColumn];
//				myCellWidth	= GRID_SETTINGS[WhichGrid,GRID_CELLWIDTH, myRow,myColumn];
//				
//				myHeight		= GRID_SETTINGS[WhichGrid,GRID_ASKDEPTHHEIGHT];
//				myWidth		= GridCellWidth;
//				
//				SetShapeHeight	(me, myHeight);
//				SetShapeWidth	(me, myWidth);
//				SetXDist		(me, (int)(GRID_SETTINGS[WhichGrid,GRID_CELLLEFT,myRow,myColumn]));
//				SetYDist		(me, (int)((GRID_SETTINGS[WhichGrid,GRID_CELLTOP,myRow,myColumn] + (GridCellHeight * 0.5)) - (myHeight * 0.5)));
//
//                    //____________________ ASK DEPTH TEXT ____________________
//                    myColumn		= GRID_SETTINGS[WhichGrid,GRID_ASKDEPTHCOLUMN];
//                    me			= SHAPE_NAMES	[WhichGrid,ASK_DEPTH_TEXT,myRow,myColumn];
//                    
//                    myCellHeight	= GRID_SETTINGS[WhichGrid,GRID_CELLHEIGHT,myRow,myColumn];
//				myCellWidth	= GRID_SETTINGS[WhichGrid,GRID_CELLWIDTH, myRow,myColumn];
//				
//				myHeight  	= DepthTextHeight;
//                    myWidth   	= DepthTextWidth;
//                    
//                    UpdateFontSize	(me, DepthFontSize);
//                    SetXDist		(me, (int)GRID_SETTINGS[WhichGrid,GRID_CELLLEFT,myRow,myColumn]);
//                    SetYDist		(me, (int)((GRID_SETTINGS[WhichGrid,GRID_CELLTOP,myRow,myColumn] + (GridCellHeight * 0.5)) - (myHeight * 0.5)));
//                    
//                    //____________________ LAST TRADED BOX ____________________
//                    if (myRow == 0) {
//                         myColumn  	= GRID_SETTINGS[WhichGrid,GRID_LASTTRADEDCOLUMN];
//                         me			= SHAPE_NAMES	[WhichGrid,LAST_TRADED_SHAPE,0,myColumn];
//                         
//                         myCellHeight	= GRID_SETTINGS[WhichGrid,GRID_CELLHEIGHT,myRow,myColumn];
//					myCellWidth	= GRID_SETTINGS[WhichGrid,GRID_CELLWIDTH, myRow,myColumn];
//					
//                         myHeight  	= GRID_SETTINGS[WhichGrid,GRID_LASTTRADEDHEIGHT];
//                         myWidth   	= GRID_SETTINGS[WhichGrid,GRID_WIDTH];	// FULL SCREEN
//                         
//                         SetShapeHeight	(me, myHeight);
//                         SetShapeWidth	(me, myWidth);
//                         SetXDist		(me, (int)(GRID_SETTINGS[WhichGrid,GRID_CELLLEFT,myRow,myColumn] + (myCellWidth * 0.5) - (myWidth * 0.5)));
//					/*Set when DOM updates*/ //SetYDist		(me, (int)(GRID_SETTINGS[WhichGrid,GRID_CELLTOP,myRow,myColumn] + (myCellHeight * 0.5) - (myHeight * 0.5)));
//				}
//			}
//		}
//};
//cDOM DOM;


// TEMP?
//myHeight 	= DOMSpecs[WhichDOM].Height / Rows;							
//myWidth 	= DOMSpecs[WhichDOM].Width / Columns;
//myTop 	= DOMSpecs[WhichDOM].Top + (myRow * myHeight);				
//myLeft 	= DOMSpecs[WhichDOM].Left + ();					
//myRight	= myLeft + myWidth;					
//myBottom	= myTop + myHeight;					
//
//me = GridShapeObjects[WhichDOM].Name;										
//GridShapeObjects[WhichDOM].Left	[myRow] = myLeft;			SetXDist		(me, myLeft);
//GridShapeObjects[WhichDOM].Width	[myRow] = myWidth;			SetShapeWidth	(me, myWidth);		
//GridShapeObjects[WhichDOM].Right	[myRow] = myRight;						
//GridShapeObjects[WhichDOM].Top	[myRow] = myTop;			SetYDist		(me, myTop);	
//GridShapeObjects[WhichDOM].Height	[myRow] = myHeight;			SetShapeHeight	(me, myHeight);		
//GridShapeObjects[WhichDOM].Bottom	[myRow] = myBottom;						

