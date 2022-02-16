//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                                      MATRIX																	|
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
// MATRIX VARIABLES
#define	MAXIMUM_MATRIX_DIMENSIONS 	50 // ROWS | COLUMNS
int 		HeaderFontSize, DataFontSize 	= 0;
int		MatrixRows, MatrixColumns	= 0;

struct MatrixElements {
	string 	Name		[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	int		Top		[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS], 	Bottom	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	int		Left		[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS], 	Right[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	int		Height	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS], 	Width	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	int		CentreX	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS], 	CentreY	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	int		XPadding	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS],		YPadding	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	
	color 	ActiveFillColour	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS], 	InactiveFillColour	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS],  ActiveFillColourGradient[100];
	color	ActiveBorderColour	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS], 	InactiveBorderColour[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS],	ActiveBorderColourGradient[100];
	int		ActiveBorderWidth	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS], 	InactiveBorderWidth	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	int		ActiveBorderStyle	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS], 	InactiveBorderStyle	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	color	ActiveTextColour	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS],		InactiveTextColour	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];

	int		ValueInt		[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	double	ValueDouble	[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	string	ValueStr		[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	string	Font			[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
	int		FontSize		[MAXIMUM_MATRIX_DIMENSIONS,MAXIMUM_MATRIX_DIMENSIONS];
};
MatrixElements MatrixShape, MatrixText;

class cMatrix {
     public:
          bool Create() {
          	ResetLastError();
          	Files.Log(__FUNCTION__);
          	
          	ObjectsDeleteAll(myChartID, "UltraDOM_Matrix", -1, -1);
          	InterfaceIsActive[INTERFACE_MATRIX] = false;
          	
          	if (!DataInitialised) {
          		Files.Log("DATA NOT INITIALISED YET");
          		return(false);
          	}
          	
          	// CHECKPOINT
          	MatrixRows	= MathMin(NO_OF_MARKETS,MAXIMUM_MATRIX_DIMENSIONS) + 1; // +1 for Headers
          	MatrixColumns	= MatrixRows;
          	
          	//__________ CREATE BACKGROUND __________
          	MatrixContainer.Top		= ClockContainer.Bottom;
          	MatrixContainer.Bottom	= ScreenContainer.Bottom;
          	MatrixContainer.Height	= MatrixContainer.Bottom - MatrixContainer.Top;
          	MatrixContainer.Width	= ScreenContainer.Width;
          	
          	MatrixContainer.Left	= ScreenContainer.Left;
          	int	RowHeight			= (MatrixContainer.Height / MatrixRows);
          	int	ColumnWidth		= (MatrixContainer.Width / MatrixColumns);
          	
          	CreateRectangleLabel("UltraDOM_Matrix_Background", CORNER_LEFT_UPPER, MatrixContainer.Left, MatrixContainer.Top, MatrixContainer.Width, MatrixContainer.Height, clrBlack, false, BORDER_RAISED, clrNONE, STYLE_SOLID, 0);
          	
          	string 	DataText 		= "-00.0";
          	string	HeaderText	= "0000000";
          	
          	myFont			= Verdana;
          	HeaderFontSize	= MathMin(GetFittedFontX(HeaderText, ColumnWidth, myFont), GetFittedFontY(HeaderText, RowHeight, myFont));
          	DataFontSize 	= MathMin(GetFittedFontX(DataText, (int)(ColumnWidth * 0.7), myFont), GetFittedFontY(DataText, (int)(RowHeight * 0.7), myFont));
          	TextHeight	= 0;
          	TextWidth 	= 0;
          	
          	//__________ CREATE MATRIX __________			// adopt the same principle as the DOM, fast drawing initially and speedy refitting of objects as they update. No need to set everything initially.
          	for (int Column = 0; Column < MatrixColumns; Column++) {
	          	for (int Row = 0; Row < MatrixRows; Row++) {
	          		
	          		// SHAPE
	          		me = "UltraDOM_Matrix_Shape_Row_" + (string)Row + "_Column_" + (string)Column;
	          		myHeight	= RowHeight;
	          		myWidth	= ColumnWidth;
	          		myTop	= MatrixContainer.Top + (myHeight * Row);
	          		myLeft 	= MatrixContainer.Left + (myWidth * Column);
	          		myCentreX = (int)(myLeft + (myWidth * 0.5));
	          		myCentreY	= (int)(myTop + (myHeight * 0.5));
	          		
	          		// PASS
	          		MatrixShape.Name	[Row,Column]	= me;
	          		MatrixShape.Top	[Row,Column]	= myTop;
	          		MatrixShape.Left	[Row,Column]	= myLeft;
	          		MatrixShape.CentreX	[Row,Column]	= myCentreX;
	          		MatrixShape.CentreY	[Row,Column]	= myCentreY;
	          		
	          		CreateRectangleLabel(me, CORNER_LEFT_UPPER, myLeft, myTop, myWidth, myHeight, clrNONE, false, BORDER_FLAT, TronGray, STYLE_SOLID, 0);
	          		
	          		// TEXT
	          		if (Row == Column) {
	          			myText	= "----";
	          			myColour 	= TronGray;
	          			myFontSize 	= DataFontSize;
	          		} else if (Column == 0) {
	          			myText 	= MARKET_NAMES[Row-1];
	          			myColour 	= clrWhiteSmoke;
	          			myFontSize 	= HeaderFontSize;
	          		} else if (Row == 0) {
	          			myText 	= MARKET_NAMES[Column-1];
	          			myColour 	= clrWhiteSmoke;
	          			myFontSize 	= HeaderFontSize;
	          		} else {
	          			myText 	= DataText;
	          			myColour 	= clrRosyBrown;
	          			myFontSize 	= DataFontSize;
	          		}
	          		
	          		TextHeight	= GetTextHeightNew(myText, myFont, myFontSize);
					TextWidth		= GetTextWidthNew(myText, myFont, myFontSize);
	          		
	          		me = "UltraDOM_Matrix_Text_" + (string)Row + "_Column_" + (string)Column;
	          		MatrixText.Name[Row,Column] = me;
	          		CreateLabel(me, myText, myFont, myFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, (int)(myCentreX - (TextWidth * 0.5)), (int)(myCentreY - (TextHeight * 0.5)), myColour, false);
				}
			}
			
			InterfaceIsActive[INTERFACE_MATRIX] = true;
			
			return(true);
		}
		
		void Update() {
			//__________ UPDATE MATRIX __________
			int 	RGB_R = 0;
			int 	RGB_G = 0;
			int	RGB_B = 0;
			int IntensityMultiplier = 6;
			
			for (int Column = 0; Column < MatrixColumns; Column++) {
				for (int Row = 0; Row < MatrixRows; Row++) {
					if ((Row == 0) || (Column == 0) || (Row == Column)) {
						continue;
					}
					
					int Rand1 = RandomNumber(-99, 99);
					int Rand2 = RandomNumber(0,9);
					myText = (string)Rand1 + "." + (string)Rand2;
					
					// POSITIVE VALUES
					if (Rand1 >= 70) {
						myBorderWidth 	= 1;
						
						RGB_R = 0;
						RGB_G = 255 - ((100 - Rand1) * IntensityMultiplier);
						RGB_B = 0;
						
						if (Rand1 >= 90) {	// vivid green
							myBorderStyle	= STYLE_SOLID;
						} else if (Rand1 >= 80) {
							myBorderStyle	= STYLE_DOT;
						} else if (Rand1 >= 70) {
							myBorderStyle	= STYLE_DASH;
						}
					
					} else if (Rand1 <= -70) {
						myBorderWidth 	= 1;
						
						RGB_R = 255 - ((Rand1 - -100) * IntensityMultiplier);
						RGB_G = 0;
						RGB_B = 0;
						
						if (Rand1 <= -90) {
							myBorderStyle	= STYLE_SOLID;
						} else if (Rand1 <= -80) {
							myBorderStyle	= STYLE_DOT;
						} else if (Rand1 <= -70) {
							myBorderStyle	= STYLE_DASH;
						}
					
					} else {
						RGB_R = 12;
						RGB_G = 20;
						RGB_B = 31;	// TRON GRAY
						
						myBorderWidth 	= 0;
					}
					
					StringConcatenate(str, "C'", RGB_R, ",", RGB_G, ",", RGB_B, "'");
					myTextColour	= StringToColor(str);
					myBorderColour 	= StringToColor(str);
					
					// UPDATE SHAPE
					me			= MatrixShape.Name[Row,Column];
					myCentreX		= MatrixShape.CentreX[Row,Column];
					SetShapeBorderWidth	(me, myBorderWidth);
					SetShapeBorderColour(me, myBorderColour);
					SetShapeBorderStyle	(me, myBorderStyle);
					
					// UPDATE TEXT
					me			= MatrixText.Name[Row,Column];
					TextHeight 	= GetTextHeightNew(myText, myFont, DataFontSize);
          			TextWidth		= GetTextWidthNew(myText, myFont, DataFontSize);
          			UpdateText	(me, myText);
					UpdateTextColour(me, myTextColour);
					SetXDist(me,  (int)(myCentreX - (TextWidth * 0.5)));
				}
			}
		}
		
		void Destroy() {
			ResetLastError();
          	Files.Log(__FUNCTION__);
          	
			ObjectsDeleteAll(myChartID, "UltraDOM_Matrix", -1, -1);
			InterfaceIsActive[INTERFACE_MATRIX] = false;
		}
};
cMatrix Matrix;