//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                                  INTERFACE HANDLER                                                                         |
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
#define	NO_OF_INTERFACES			10
#define	INTERFACE_INTRO			0
#define	INTERFACE_STARTSCREEN		1
#define	INTERFACE_AUTHENTICATION		2
#define	INTERFACE_CREDITS			3
#define	INTERFACE_MAIN				4
#define	INTERFACE_SETTINGSMENU		5
#define	INTERFACE_STARTMENU			6
#define	INTERFACE_PRESSSTART		7
#define	INTERFACE_HUMAN			8
#define	INTERFACE_MATRIX			9
bool 	InterfaceIsActive			[NO_OF_INTERFACES];

struct Containers {
	int 		Top, Bottom, Height, Width, Left, Right, CentreX, CentreY;
	int		PreviousHeight, PreviousWidth;
};
Containers ScreenContainer, DOMContainer, ClockContainer, CreditsContainer, MatrixContainer;

//struct Cells {
//	int		Height	[1000,1000];	// ROWS, COLUMNS
//	int		Width	[1000,1000];
//	int		Top		[1000,1000];
//	int		Bottom	[1000,1000];
//	int		Left		[1000,1000];
//	int		Right	[1000,1000];
//	int		CentreX	[1000,1000];
//	int		CentreY	[1000,1000];
//};

class cInterfaces {
	public:
		
		void Update_ContainerPositions() {
			DOMContainer.Left 	= ScreenContainer.Left;
			DOMContainer.Right	= ScreenContainer.Right;
			DOMContainer.Top	= ClockContainer.Bottom;
			DOMContainer.Bottom = ScreenContainer.Bottom;
			DOMContainer.Height = (DOMContainer.Bottom - DOMContainer.Top);
			DOMContainer.Width	= (DOMContainer.Right - DOMContainer.Left);
			
			ClockContainer.Top			= ScreenContainer.Top;
			CreditsContainer.Top 		= ClockContainer.Bottom;
			CreditsContainer.Bottom 		= ScreenContainer.Bottom;
		}
		

		
		void UpdateElements() {
			ResetLastError();
			
			if (InterfaceIsActive[INTERFACE_HUMAN] || InterfaceIsActive[INTERFACE_PRESSSTART] || InterfaceIsActive[INTERFACE_STARTMENU] || InterfaceIsActive[INTERFACE_CREDITS]) {
				if (CurrentTickCount >= IntroSoundReplayTimeMS) {
	     			Sounds.Sound("IntroMusic");
	     			IntroSoundReplayTimeMS = (CurrentTickCount + IntroSoundLengthMS);
				}
			}
						
   			if (InterfaceIsActive[INTERFACE_PRESSSTART]) {
   				InterfacePressStart.UpdateFlashingText();
   			}
   			
			if (InterfaceIsActive[INTERFACE_STARTMENU]) {
				InterfaceStartMenu.UpdateFlashingText();
			}
			
			if (InterfaceIsActive[INTERFACE_CREDITS]) {
				InterfaceCredits.Update();
			}
			
			if (InterfaceIsActive[INTERFACE_MAIN]) {
				
				
				// ELEMENTS
		          InterfaceMain.Update_Clock();
		          InterfaceMain.Update_Map();
		          InterfaceMain.Fade_LastKeyPressed();
		          
		          // MAIN BACKGROUND PARALLAX
		          SetXDist("UltraDOM_StarryBackground", (int)(StarryBackgroundXDist - (MousePosFromCentreX / MainBackgroundMovementRatioX)));
		          SetYDist("UltraDOM_StarryBackground", (int)(StarryBackgroundYDist - (MousePosFromCentreY / MainBackgroundMovementRatioY)));
		          
		          // PERIMETER LIGHTING
		          // LEFT
		          int ColourInt	= (int) (255 - (((1.0*MouseXCoordinate) / (1.0*ScreenContainer.Width)) * 255));
		          UpdateShapeColour("UltraDOM_PerimeterLeft", (color)("C'" + (string)ColourInt + "," +  (string)ColourInt + "," +  (string)ColourInt + "'") );
		          
		          // RIGHT
		          ColourInt		= (int) ((((1.0*MouseXCoordinate) / (1.0*ScreenContainer.Width)) * 255));
		          UpdateShapeColour("UltraDOM_PerimeterRight", (color)("C'" + (string)ColourInt + "," +  (string)ColourInt + "," +  (string)ColourInt + "'") );
		          
		          // TOP
		          ColourInt		= (int) (255 - (((1.0*MouseYCoordinate) / (1.0*ScreenContainer.Height)) * 255));
		          UpdateShapeColour("UltraDOM_PerimeterTop", (color)("C'" + (string)ColourInt + "," +  (string)ColourInt + "," +  (string)ColourInt + "'") );
		          
		          // BOTTOM
		          ColourInt		= (int) ((((1.0*MouseYCoordinate) / (1.0*ScreenContainer.Height)) * 255));
		          UpdateShapeColour("UltraDOM_PerimeterBottom", (color)("C'" + (string)ColourInt + "," +  (string)ColourInt + "," +  (string)ColourInt + "'") );
		          
			}
			
			if (InterfaceIsActive[INTERFACE_MATRIX]) {
				//Matrix.Update();
			}
			
			//if (InterfaceIsActive[INTERFACE_SETTINGSMENU]) {
			//	if (mySParam == "UltraDOM_SettingsMenu_BetaLink") {
			//		Files.Log("BETA FEEDBACK PRESSED");
			//		Windows.OpenWebpage("http://www.tradingwarfare.com/ultradom-beta");
			//	} else if (mySParam == "UltraDOM_SettingsMenu_SupportLink") {
			//		Files.Log("SUPPORT LINK PRESSED");
			//		Windows.OpenWebpage("http://www.tradingwarfare.com/support");
			//	}
			//}
		}
};
cInterfaces Interfaces;

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                                    START MENU                                                                              |
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
int  NoOfStartMenuItems		= 3;
int  StartMenuBorderWidth	= 2;
int  StartMenuActiveItem		= 0;
int  StartMenuTextColourCount = 0;

class cInterfaceStartMenu {
     public:
          void Create() {
               ResetLastError();
			Files.Log(__FUNCSIG__);
               
               ObjectsDeleteAll(myChartID, "UltraDOM_StartMenu", -1, -1);
               
               StartMenuActiveItem = 0;
               
               int       MenuItemHeight			= (int) (ScreenContainer.Height * 0.1);
               int       MenuItemWidth			= (int) (ScreenContainer.Width * 0.4);
               int       MenuItemYPadding		= 15;
               int       MenuItemTotalHeight		= (MenuItemHeight * NoOfStartMenuItems) + (MenuItemYPadding * (NoOfStartMenuItems - 1));
               string    MenuItemFont			= OCR;
                         StartMenuActiveItem    	= 0;
               
               // MENU ITEM STRINGS
               int       MenuItemFontSize         = 1000;
               string    MenuItemStrings[];
               ArrayResize(MenuItemStrings, NoOfStartMenuItems);
               for (int i = 0; i < NoOfStartMenuItems; i++) {
                    switch(i) {
                         case 0: MenuItemStrings[i] = "LIVE TRADING"; break;
                         case 1: MenuItemStrings[i] = "TRAINING";     break;
                         case 2: MenuItemStrings[i] = "CREDITS";      break;
                    }
               }
               
               // MAKE ALL FONT SIZES THE SAME
               int FontSizes[];
               ArrayResize(FontSizes, NoOfStartMenuItems);
               for (int i = 0; i < NoOfStartMenuItems; i++) {
                    FontSizes[i] = MathMin(GetFittedFontX(MenuItemStrings[i], (int)(MenuItemWidth * 0.9), MenuItemFont), GetFittedFontY(MenuItemStrings[i], (int)(MenuItemHeight * 0.9), MenuItemFont));
                    if (FontSizes[i] < MenuItemFontSize) {
                         MenuItemFontSize = FontSizes[i];
                    }     
               }

               // CREATE MENU
               for (int i = 0; i < NoOfStartMenuItems; i++) {
                    //_____ SHAPE _____
                    StringConcatenate(me, "UltraDOM_StartMenuItemShape_", i);
                    myYDist = (int) (ScreenContainer.CentreY - (MenuItemTotalHeight * 0.5)) + (MenuItemHeight * i) + (i * MenuItemYPadding);
                    myXDist = (int) (ScreenContainer.CentreX - (MenuItemWidth * 0.5));
                    
                    if (i == 0) {
                         StartMenuBorderWidth = 3;
                         myColour = clrWhiteSmoke;
                    } else {
                         StartMenuBorderWidth = 0;
                         myColour = clrGray;
                    }
                    CreateRectangleLabel(me, CORNER_LEFT_UPPER, myXDist, myYDist, MenuItemWidth, MenuItemHeight, C'12,20,31', false, BORDER_FLAT, clrOrangeRed, STYLE_SOLID, StartMenuBorderWidth);
                    
                    //_____ TEXT LABEL _____
                    StringConcatenate(me, "UltraDOM_StartMenuItemText_", i);
                    
                    myXDist = (int) ((myXDist + (MenuItemWidth * 0.5)) - (GetTextWidthNew(MenuItemStrings[i], MenuItemFont, MenuItemFontSize) * 0.5));
                    myYDist = (int) ((myYDist + (MenuItemHeight * 0.5)) - (GetTextHeightNew(MenuItemStrings[i], MenuItemFont, MenuItemFontSize) * 0.5));
                    CreateLabel(me, MenuItemStrings[i], MenuItemFont, MenuItemFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, myColour, false);
               }
               
               InterfaceIsActive[INTERFACE_STARTMENU] = true;
               ChartRedraw(myChartID);
          }
          
          void Delete() {	// SLIDES OUT
          	ResetLastError();
			Files.Log(__FUNCSIG__);
          	
               int InitialItemPositions[,2,3]; // MENU ITEM | BOXES, TEXT | X_POS, Y_POS, DIST TILL OFFSCREEN
               ArrayResize(InitialItemPositions, NoOfStartMenuItems);
               
               int DistanceToOffscreen = 0;
               
               for (int i = 0; i < NoOfStartMenuItems; i++) {
                    //__________ SHAPES __________
                    StringConcatenate(me, "UltraDOM_StartMenuItemShape_", i);
                    myXDist   = GetShapeXDistance(me);
                    myYDist   = GetShapeYDistance(me);
                    myWidth   = GetShapeWidth(me);
                    
                    InitialItemPositions[i,0,0] = myXDist;
                    InitialItemPositions[i,0,1] = myYDist;
                    InitialItemPositions[i,0,2] = (myXDist + myWidth);
                    
                    //__________ TEXT __________
                    StringConcatenate(me, "UltraDOM_StartMenuItemText_", i);
                    myXDist   = GetShapeXDistance(me);
                    myYDist   = GetShapeYDistance(me);
                    myWidth   = GetTextWidth(me);
                    
                    InitialItemPositions[i,1,0] = myXDist;
                    InitialItemPositions[i,1,1] = myYDist;
                    InitialItemPositions[i,1,2] = (myXDist + myWidth); 
               }
               
               //____________________ ____________________
               ulong     RoutineStartTimeMS            = GetTickCount();
               ulong     DesiredAnimationDuration      = 500; // ms
               int       TotalDistanceToCover          = InitialItemPositions[0,0,2];
               double    PixelsToMovePerMicrosecond    = ((1.0*TotalDistanceToCover) / (1.0*DesiredAnimationDuration));
               bool      RoutineComplete               = false;
               
               while (!RoutineComplete && !IsStopped()) {
                    ulong	MillisecondsElapsed = (GetTickCount() - RoutineStartTimeMS);
                    double 	DistanceToMove      = (MillisecondsElapsed * PixelsToMovePerMicrosecond);
                    
                    for (int j = 0; j < NoOfStartMenuItems; j++) {
                         
                         // GO LEFT
                         int Direction = 0;
                         if (MathMod(j,2) == 0) {
                              Direction = 1;
                         } else {
                              Direction = -1;
                         }
                         
                         StringConcatenate(me, "UltraDOM_StartMenuItemShape_", j);
                         SetXDist(me, (InitialItemPositions[j,0,0] - (int)(DistanceToMove * Direction)));
                         
                         StringConcatenate(me, "UltraDOM_StartMenuItemText_", j);
                         SetXDist(me, (InitialItemPositions[j,1,0] - (int)(DistanceToMove * Direction)));
                    }
          
                    ChartRedraw(myChartID);
                    
                    if (MillisecondsElapsed >= DesiredAnimationDuration) {
                         RoutineComplete = true;
                    }     
               }
               
               // DELETE MENU ITEMS
               for (int i = 0; i < NoOfStartMenuItems; i++) {
                    StringConcatenate(me, "UltraDOM_StartMenuItemShape_", i);
                    ObjectDelete(myChartID, me);
                    
                    StringConcatenate(me, "UltraDOM_StartMenuItemText_", i);
                    ObjectDelete(myChartID, me);
               }
               
               InterfaceIsActive[INTERFACE_STARTMENU] = false;
          }
          
          void MoveUp() {
          	ResetLastError();
			Files.Log(__FUNCSIG__);
			
          	if (StartMenuActiveItem > 0) {
				StartMenuActiveItem -= 1;
     		} else {
				StartMenuActiveItem = (NoOfStartMenuItems - 1);
			}

			for (int i = 0; i < NoOfStartMenuItems; i++) {
				if (i == StartMenuActiveItem) {
					// BORDERS
					StringConcatenate(me, "UltraDOM_StartMenuItemShape_", i);
					SetShapeBorderWidth(me, 3);
				
					// TEXT
					StringConcatenate(me, "UltraDOM_StartMenuItemText_", i);
					UpdateTextColour(me, clrWhiteSmoke);
				} else {
					// BORDERS
					StringConcatenate(me, "UltraDOM_StartMenuItemShape_", i);
					SetShapeBorderWidth(me, 0);
					
					// TEXT
					StringConcatenate(me, "UltraDOM_StartMenuItemText_", i);
					UpdateTextColour(me, clrGray);
				}
			}
					
			StartMenuTextColourCount = 255;
			
			ChartRedraw(myChartID);
		}
		
		void MoveDown() {
			ResetLastError();
			Files.Log(__FUNCSIG__);
			
			if (StartMenuActiveItem < (NoOfStartMenuItems-1)) {
                    StartMenuActiveItem += 1;
               } else {
                    StartMenuActiveItem = 0;
               }
               
               for (int i = 0; i < NoOfStartMenuItems; i++) {
                    if (i == StartMenuActiveItem) {
                         // BORDERS
                         StringConcatenate(me, "UltraDOM_StartMenuItemShape_", i);
                         SetShapeBorderWidth(me, 3);
                         
                         // TEXT
                         StringConcatenate(me, "UltraDOM_StartMenuItemText_", i);
                         UpdateTextColour(me, clrWhiteSmoke);
                    } else {
                         // BORDERS
                         StringConcatenate(me, "UltraDOM_StartMenuItemShape_", i);
                         SetShapeBorderWidth(me, 0);
                         
                         // TEXT
                         StringConcatenate(me, "UltraDOM_StartMenuItemText_", i);
                         UpdateTextColour(me, clrGray);
                    }
               }
               
               StartMenuTextColourCount = 255;
               
               ChartRedraw(myChartID);
		}
		
		void UpdateFlashingText() {
			if (StartMenuTextColourCount > 100) {
				StartMenuTextColourCount -= 4;
			} else {
				StartMenuTextColourCount = 255;
			}
			
			UpdateTextColour("UltraDOM_StartMenuItemText_" + (string)StartMenuActiveItem, 	
							(color)("C'" + (string)StartMenuTextColourCount +
								  "," +  (string)StartMenuTextColourCount +
								  "," +  (string)StartMenuTextColourCount +
					 		       "'")
						 );
		}
};
cInterfaceStartMenu InterfaceStartMenu;

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                                        CREDITS                                                                             |
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
int 	NoOfCredits		= 2;
int	CreditsStartPosY 	= 0;

class cInterfaceCredits {
     public:
          void Create() {
			ResetLastError();
			Files.Log(__FUNCSIG__);
			
			ObjectsDeleteAll(myChartID, "UltraDOM_Credits", -1, -1);
			
               // INSERT CREDITS SLIGHTLY OUT OF VIEW
               myFont      = Verdana;
               myText    = "Developed by Trading Warfare";
               myFontSize  = GetFittedFontX(myText, (int) (ScreenContainer.Width * 0.3), myFont);
               
               for (int i = 0; i < NoOfCredits; i++) {
                    switch(i) {
                         case 0:   myText = "Developed by Trading Warfare | www.TradingWarfare.com";	break;
                         case 1:   myText = "All rights reserved, 2017";							break;
                    }
                    CreateLabel("UltraDOM_Credits" + (string)i, myText, myFont, myFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, (int) (ScreenContainer.CentreX - (GetTextWidthNew(myText, myFont, myFontSize) * 0.5)), CreditsStartPosY + (i * 60), clrOrangeRed, true);
               }
               
               InterfaceIsActive[INTERFACE_CREDITS] = true;
          }
          
          void Update() {
          	int RollRateInPixels = 2;
          	
			for (int i = 0; i < NoOfCredits; i++) {
				StringConcatenate(me, "UltraDOM_Credits", i);
				SetYDist(me, (GetShapeYDistance(me) - RollRateInPixels));
			}
			
			// CHECK IF OFF SCREEN, IF SO: RESET TO BOTTOM
			StringConcatenate(me, "UltraDOM_Credits", NoOfCredits-1);
			
			if (GetShapeYDistance(me) < CreditsContainer.Top) {
				for (int i = 0; i < NoOfCredits; i++) {
					StringConcatenate(me, "UltraDOM_Credits", i);
					SetYDist(me, (CreditsStartPosY + (i * 60)));
				}
			}
		}

          void Delete() {
          	ResetLastError();
			Files.Log(__FUNCSIG__);
			
          	ObjectsDeleteAll(myChartID, "UltraDOM_Credits", -1, -1);
          	InterfaceIsActive[INTERFACE_CREDITS] = false;
          }
     
};
cInterfaceCredits InterfaceCredits;

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                                      MAIN INTERFACE                                                                        |
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
// VARS TO USE IN OTHER UI ELEMENTS
int		StarryBackgroundXDist, StarryBackgroundYDist = 0;

int		HoursMinutesHeight, HoursMinutesWidth		= 0;
int		SecondsHeight, SecondsWidth				= 0;

int		MainBackgroundMovementRatioX, MainBackgroundMovementRatioY  = 0;

int       MapWidth, MapHeight, MapXDist, MapYDist;
int       MapDotHeight, MapDotWidth, MapDotXDist, MapDotYDist;
int       MapFadeHeight, MapFadeWidth, MapFadeXDist, MapFadeYDist;
int       MapFadeCount             = 0;
bool      MapDotVisible            = true;
int       MapUpdateFrequencyMS     = 150;
ulong     NextMapUpdate            = 0;


//__________ STATUS LABELS __________
string StatusLabels[];

class cInterfaceMain {
     public:
          void Create() {
               ResetLastError();
			Files.Log(__FUNCSIG__);
			
			ObjectsDeleteAll(myChartID, "UltraDOM", -1, -1);
               
               //____________________ STARRY BACKGROUND ____________________
               GetBitmapSize("Graphics\\StarryBackground");
               me                       = "UltraDOM_StarryBackground";
               myXDist                  = (int) (ScreenContainer.CentreX - (myWidth * 0.5));
               myYDist                  = (int) (ScreenContainer.CentreY - (myHeight * 0.5));
               StarryBackgroundXDist    = myXDist;
               StarryBackgroundYDist    = myYDist;
               
               int      MainBackgroundMaxMovementX = (int)(ScreenContainer.Width * 0.02);
               int      MainBackgroundMaxMovementY = (int)(ScreenContainer.Height * 0.02);
               MainBackgroundMovementRatioX = (ScreenContainer.Width / MainBackgroundMaxMovementX);
               MainBackgroundMovementRatioY = (ScreenContainer.Height / MainBackgroundMaxMovementY);
          
               CreateBitmap(me, "Graphics\\StarryBackground", CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, true, 1);
              
             
               //____________________ MAP ____________________
               Create_Map();
               Update_MapCoords();
               Update_Map();
               
               //____________________ PERIMETER ____________________
               Create_Perimeter();
               
               
               //____________________ STATUS LABELS ____________________
               Create_StatusLabels();
               
               // END
               InterfaceIsActive[INTERFACE_MAIN] = true;
               ChartRedraw(myChartID);
          }
           
				
          void Create_Perimeter() {
          	#define 	TOP		0
          	#define	BOTTOM 	1
          	#define	LEFT 	2
          	#define	RIGHT 	3
          	
          	int		myThickness		= 4;
          	int		DistanceFromEdge	= 0;
          	
          	for (int i = 0; i < 4; i++) {
          		switch(i) {
          			case TOP:		me		= "UltraDOM_PerimeterTop";
          						myWidth	= (int)(ScreenContainer.Width * 1.1);
				          		myHeight	= myThickness;
				          		myXDist	= (int)(ScreenContainer.CentreX - (myWidth * 0.5));
          						myYDist	= DistanceFromEdge;
          						break;
          			
          			case BOTTOM:	me		= "UltraDOM_PerimeterBottom";
          						myWidth	= (int)(ScreenContainer.Width * 1.1);
				          		myHeight	= myThickness;
          						myXDist	= (int)(ScreenContainer.CentreX - (myWidth * 0.5));
          						myYDist	= (int)(ScreenContainer.Bottom - myHeight - DistanceFromEdge);
          						break;
          						
					case LEFT:	me		= "UltraDOM_PerimeterLeft";
								myWidth	= myThickness;
								myHeight	= (int)(ScreenContainer.Height * 1.1);
								myXDist	= DistanceFromEdge;
								myYDist	= (int)(ScreenContainer.CentreY - (myHeight * 0.5));
								break;
								
					case RIGHT:	me		= "UltraDOM_PerimeterRight";
								myWidth	= myThickness;
								myHeight	= (int)(ScreenContainer.Height * 1.1);
								myXDist	= (int)(ScreenContainer.Right - myWidth - DistanceFromEdge);
								myYDist	= (int)(ScreenContainer.CentreY - (myHeight * 0.5));
								break;
          		}
          		
          		CreateRectangleLabel(me, CORNER_LEFT_UPPER, myXDist, myYDist, myWidth, myHeight, clrWhite, false, BORDER_FLAT, clrNONE, STYLE_SOLID, 0);
          	}
          	
          	#undef TOP
          	#undef BOTTOM
          	#undef LEFT
          	#undef RIGHT
          }
          
          void Create_Map() {
               ResetLastError();
			Files.Log(__FUNCSIG__);
			
			// MAP
               me             = "UltraDOM_Map_Map";
               myFileName     = "Graphics\\Map\\Map";
               GetBitmapSize  (myFileName);
               MapWidth       = myWidth;
               MapHeight      = myHeight;
               MapXDist       = 0;
               MapYDist       = 0;
               CreateBitmap   (me, myFileName, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, MapXDist, MapYDist, false, 0);
               
               // DOT
               me             = "UltraDOM_Map_Dot";
               myFileName     = "Graphics\\Map\\Dot";
               GetBitmapSize  (myFileName);
               MapDotWidth    = myWidth;
               MapDotHeight   = myHeight;
               CreateBitmap   (me, myFileName, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 0, 0, false, 0);
               
               // FADE
               me             = "UltraDOM_Map_Fade";
               myFileName     = "Graphics\\Map\\Fade0";
               GetBitmapSize  (myFileName);
               MapFadeWidth   = myWidth;
               MapFadeHeight  = myHeight;
               CreateBitmap   (me, myFileName, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, 0, 0, false, 0);
          }
          
          void Update_MapCoords() {
               string MarketCity   = "London";
               double CityXOffset  = 0;
               double CityYOffset  = 10;
               
               if (MarketCity == "London") {
                    CityXOffset = 0.45;
                    CityYOffset = 0.33;
               }
               
               MapDotXDist  = (int)(MapXDist + (MapWidth * CityXOffset));
               MapDotYDist  = (int)(MapYDist + (MapHeight * CityYOffset));
               
               MapFadeXDist = (int)((MapDotXDist + (MapDotWidth * 0.5)) - (MapFadeWidth * 0.5) - 2); // 2 as image isn't cut perfectly
               MapFadeYDist = (int)((MapDotYDist + (MapDotHeight * 0.5)) - (MapFadeHeight * 0.5));
               
               me = "UltraDOM_Map_Dot";
               SetXDist(me, MapDotXDist);
               SetYDist(me, MapDotYDist);
               
               me = "UltraDOM_Map_Fade";
               SetXDist(me, MapFadeXDist);
               SetYDist(me, MapFadeYDist);
          }
          
          void Update_Map() {
               if (CurrentTickCount > NextMapUpdate) {
                    if (MapFadeCount < 3) {
                         MapFadeCount++;
                    } else {
                         MapFadeCount = 0;
                    
                         if (MapDotVisible) {
                              MapDotVisible = false;
                              SetXDist("UltraDOM_Map_Dot", -100);
                         } else {
                              MapDotVisible = true;
                              SetXDist("UltraDOM_Map_Dot", MapDotXDist);
                         }
                    }
                    
                    UpdateBitmap("UltraDOM_Map_Fade", "Graphics\\Map\\Fade" + (string)MapFadeCount);
                    NextMapUpdate = (CurrentTickCount + MapUpdateFrequencyMS);
               }
          }
          
		
};
cInterfaceMain InterfaceMain;

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                                      AUTHENTICATION                                                                        |
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
string   	Cipher1    				= "abcdefghijklmnopqrstuvwxyz";
string   	Cipher2					= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
string   	Cipher3					= "0123456789";

string	CipherRandom   			= "wfgoubw3c6nweinoithewoth30";
                        				// 01234567890123456789012345
                        
string	UsernameAllowedChars[] 		= {"abcdefghijklmnopqrstuvwxyz",
                                 	        "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                                 	   	   "0123456789"};
                                 	 
string	PasswordAllowedChars[] 		= {"abcdefghijklmnopqrstuvwxyz",
                                 	   	   "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                                 	   	   "0123456789"};

string	AuthenticationUsernameLabel	= "UltraDOM_Credentials_UsernameLabel";
string	AuthenticationPasswordLabel	= "UltraDOM_Credentials_PasswordLabel";
string	AuthenticationSubmitShape	= "UltraDOM_Credentials_Shape";
string	AuthenticationSubmitText		= "UltraDOM_Credentials_Text";

color	CredentialsTextColour		= clrWhiteSmoke;
string	DefaultUsernameField		= "    USERNAME    ";
string	DefaultPasswordField		= "    PASSWORD    ";

class cInterfaceAuthentication {
	public:
		void Create() {
			ResetLastError();
			Files.Log(__FUNCTION__);
			
			ObjectsDeleteAll(myChartID, "UltraDOM_Credentials");
			
			string myUserNameText 	= DefaultUsernameField;
			string myPasswordText	= DefaultPasswordField;
			myHeight			= (int)(ScreenContainer.Height * 0.1);
			myWidth 			= (int)(ScreenContainer.Width * 0.4);
			
			myFont 			= OCR;
			myFontSize			= MathMin(GetFittedFontX(myUserNameText, myWidth, myFont), GetFittedFontY(myUserNameText, myHeight, myFont));
			int BoxXPadding 	= 2;
			
			// USERNAME INPUT BOX
			myXDist			= (int)(ScreenContainer.CentreX - (myWidth * 0.5));
			myYDist			= (int)(ScreenContainer.CentreY - myHeight - (BoxXPadding * 0.5));
			CreateInputBox		(AuthenticationUsernameLabel, myUserNameText, CredentialsTextColour, clrBlack, TronOrange, myFont, myFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER,
							myHeight, myWidth, myXDist, myYDist, false);
						
			// PASSWORD INPUT BOX
			myXDist			= (int)(ScreenContainer.CentreX - (myWidth * 0.5));
			myYDist			= (int)(ScreenContainer.CentreY + (BoxXPadding * 0.5));
			CreateInputBox		(AuthenticationPasswordLabel, myPasswordText, CredentialsTextColour, clrBlack, TronOrange, myFont, myFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER,
							myHeight, myWidth, myXDist, myYDist, false);
						
			// SUBMIT SHAPE
			myHeight 			= (int) (GetShapeHeight(AuthenticationUsernameLabel) * 0.5);
			myWidth			= (int) (GetShapeWidth(AuthenticationUsernameLabel) * 0.2);
			myXDist			= (int) (ScreenContainer.CentreX - (myWidth * 0.5));
			myYDist			= (int) (GetShapeYDistance(AuthenticationPasswordLabel) + GetShapeHeight(AuthenticationPasswordLabel) + BoxXPadding);
			CreateRectangleLabel(AuthenticationSubmitShape, CORNER_LEFT_UPPER, myXDist, myYDist, myWidth, myHeight, clrNONE, false, BORDER_RAISED, clrWhiteSmoke, STYLE_SOLID, 1);
			
			// SUBMIT TEXT
			str				= "SUBMIT";
			myFont				= OCR;
			myWidth			= GetShapeWidth	(AuthenticationSubmitShape);
			myFontSize			= GetFittedFontX(str, myWidth, myFont);
			int ParentXDist 	= GetShapeXDistance	(AuthenticationSubmitShape);
			int ParentYDist	= GetShapeYDistance	(AuthenticationSubmitShape);
			int ParentHeight	= GetShapeHeight	(AuthenticationSubmitShape);
			int ParentWidth	= GetShapeWidth	(AuthenticationSubmitShape);
			
			myXDist			= (int)( (ParentXDist + (ParentWidth * 0.5)) - (GetTextWidthNew(str, myFont, myFontSize) * 0.5)   );
			myYDist			= (int)( (ParentYDist + (ParentHeight * 0.5)) - (GetTextHeightNew(str, myFont, myFontSize) * 0.5) );
			CreateLabel		(AuthenticationSubmitText, str, myFont, myFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, clrWhiteSmoke, true);
			
			InterfaceIsActive	[INTERFACE_AUTHENTICATION] = true;
		}
		
		bool Authenticate() {
			ResetLastError();
			Files.Log(__FUNCTION__);
			
			if (DEV_MODE_SKIP_AUTHENTICATION) {
				InterfaceIsActive[INTERFACE_AUTHENTICATION] = false;
				return(true);
			}
			
			string myUsername = ObjectGetString(myChartID, AuthenticationUsernameLabel, OBJPROP_TEXT);
			string myPassword = ObjectGetString(myChartID, AuthenticationPasswordLabel, OBJPROP_TEXT);
			
			if (CheckUsernameIsValid(myUsername) && CheckPasswordIsValid(myUsername, myPassword)) {
				Files.Log("USERNAME / PASSWORD ARE VALID | USERNAME " + myUsername);
				
				InterfaceIsActive[INTERFACE_AUTHENTICATION] = false;
				return(true);
			
			} else {
				Files.Log("USERNAME / PASSWORD INVALID | USERNAME " + myUsername);
				
				UpdateTextColour	(AuthenticationUsernameLabel, clrRed);
				UpdateText		(AuthenticationUsernameLabel, "INVALID");
				SetXDist			(AuthenticationUsernameLabel, (int)(ScreenContainer.CentreX - (GetShapeWidth(AuthenticationUsernameLabel) * 0.5)));
				
				UpdateTextColour	(AuthenticationPasswordLabel, clrRed);
				UpdateText		(AuthenticationPasswordLabel, "INVALID");
				SetXDist			(AuthenticationPasswordLabel, (int)(ScreenContainer.CentreX - (GetShapeWidth(AuthenticationPasswordLabel) * 0.5)));
				
				ChartRedraw(myChartID);
				Sleep(800);
				
				UpdateTextColour	(AuthenticationUsernameLabel, CredentialsTextColour);
				UpdateTextColour	(AuthenticationPasswordLabel, CredentialsTextColour);
				UpdateText		(AuthenticationUsernameLabel, DefaultUsernameField);
				UpdateText		(AuthenticationPasswordLabel, DefaultPasswordField);
				
				return(false);
			}
		}
		
		bool	CheckUsernameIsValid(string myUsername) {
			ResetLastError();
			Files.Log(__FUNCTION__);
			
		     int  LegalCharsFound	= 0;
		     int	UsernameLength 	= StringLen(myUsername);
		     
		     // CHECKPOINT - USERNAME LENGTH
		     Files.Log("USERNAME CHAR LENGTH: " + (string)UsernameLength);
		     if (UsernameLength > 0) {
		  		Files.Log("USERNAME LENGTH OK");
		  	} else {
		  		Files.Log("USERNAME LENGTH NOT OK");
		  		return(false);
		     }
		     
		     for (int i = 0; i < UsernameLength; i++) {
		          string CharToFind = StringSubstr(myUsername, i, 1);
		          
		          for (int j = 0; j < ArraySize(UsernameAllowedChars); j++) {
		               int FoundPos = StringFind(UsernameAllowedChars[j], CharToFind, 0);
		               
		               if (FoundPos >= 0) {
		                    LegalCharsFound++;
		                    continue;
		               }
		          }
		     }
		     
		     if (LegalCharsFound == UsernameLength) {
		     	Files.Log("LEGAL CHARS FOUND: " + (string)LegalCharsFound + " | SUCCESS");
		     	return(true);
		     } else {
		     	Files.Log("LEGAL CHARS FOUND: " + (string)LegalCharsFound + " | FAILED");
		          return(false);
		     }
		}
		
		bool CheckPasswordIsValid(string myUsername, string myPassword) {
			ResetLastError();
			Files.Log(__FUNCTION__);
			
			//____________________ CHECK PASSWORD ____________________
			string 	EncryptedString 	= "";
			int		UsernameLength		= StringLen(myUsername);
			
			for (int i = 0; i < UsernameLength; i++) {
				string CharToFind = StringSubstr(myUsername, i, 1);
				
				// CIPHER 1
				int FoundPos = StringFind(Cipher1, CharToFind, 0);
				if (FoundPos >= 0) {
					StringConcatenate(EncryptedString, EncryptedString, StringSubstr(CipherRandom, FoundPos, 1));
					continue;
				}
				
				// CIPHER 2
				FoundPos = StringFind(Cipher2, CharToFind, 0);
				if (FoundPos >= 0) {
					StringConcatenate(EncryptedString, EncryptedString, StringSubstr(CipherRandom, FoundPos, 1));
					continue;					
				}
				
				// CIPHER 3
				FoundPos = StringFind(Cipher3, CharToFind, 0);
				if (FoundPos >= 0) {
					StringConcatenate(EncryptedString, EncryptedString, StringSubstr(CipherRandom, FoundPos, 1));
					continue;
				}
			}
			
			Files.Log("USERNAME: " + myUsername + " | PASSWORD: " + EncryptedString);

			if (EncryptedString == myPassword) {
				return(true);
			} else {
				return(false);
			}
		}
};
cInterfaceAuthentication InterfaceAuthentication;











//          //+--------------------------------------------------------------------------------
//          //|                                SETTINGS MENU                                  |
//          //+--------------------------------------------------------------------------------
//          if (ActiveInterface == INTERFACE_SETTINGSMENU) {
//               switch((int)lparam) {
//                    // Q - CLOSE MENU
//                    case KEY_Q:  InterfaceSettings.ToggleVisibility(false);
//                              break;
//                    
//                    // P - SELECT
//                    case 80:  InterfaceSettings.Select();
//                              break;
//                              
//                    // LEFT
//                    case 37:  InterfaceSettings.NavigateLeft();
//                              break;
//
//                    // RIGHT
//                    case 39:  InterfaceSettings.NavigateRight();
//                              break;
//                    
//                    // UP
//                    case 38:  InterfaceSettings.NavigateUp();
//                              break;
//                    
//                    // DOWN
//                    case 40:  InterfaceSettings.NavigateDown();
//                              break;
//               }
//               
//               return;
//          }
//
//          //+--------------------------------------------------------------------------------
//          //|                                MAIN INTERFACE                                 |
//          //+--------------------------------------------------------------------------------
//          if (ActiveInterface == INTERFACE_MAIN) {
//			
//			Orders.HotkeysPressed();
//			
//			switch((int)lparam) {
//				// K - TOGGLE HOTKEYS
//                   
//
//                    // L - TOGGLE BRACKET ORDERS
//                    else if (myLParam == 76) {
//                    	if (BracketsEnabled) {
//                              Sound("BracketsDisabled");
//                              InterfaceMain.UpdateLastKeyPressedLabel("BRACKETS DISABLED");
//                              BracketsEnabled = false;
//                         } else {
//                              Sound("BracketsEnabled");
//                              InterfaceMain.UpdateLastKeyPressedLabel("BRACKETS ENABLED");
//                              BracketsEnabled = true;
//                         }
//                    
//                    // U - BUY LIMIT
//                    else if (myLParam == 85) {
//					if (FirstBookEventRetrieved) {
//                              Orders.BuyLimitWithBrackets(BidPrices[0]);
//					}
//                    } else {
//                         if (FirstBookEventRetrieved) {
//                              //BuyLimitNoBrackets(BidPrices[0]);
//                         }     
//                    }
//               } else {
//               
//                                   Sound("EnableTheHotkeys");
//                                   InterfaceMain.UpdateLastKeyPressedLabel("ENABLE THE HOTKEYS");
//                              }
//                              break;
//                              
//                            
//		
//		
//                    
//                    // I - SELL LIMIT
//                    case 73:  if (HotkeysEnabled) {
//                                   if (BracketsEnabled) {
//                                        //SellLimitWithBrackets(SymbolInfoDouble(_Symbol, SYMBOL_ASK));
//                                   } else {
//                                        //SellLimitNoBrackets(SymbolInfoDouble(_Symbol, SYMBOL_ASK));
//                                   }
//                              } else {
//                                   Sound("EnableTheHotkeys");
//                                   InterfaceMain.UpdateLastKeyPressedLabel("ENABLE THE HOTKEYS");
//                              }
//                              break;
//                              
//                    // O - CANCEL ALL
//                    case 79:  if (HotkeysEnabled) {
//                                   //CancelAll();
//                              } else {
//                                   Sound("EnableTheHotkeys");
//                              }
//                              break;
//                  
//                  
//                     //____________________ MATRIX ____________________
//                    // G - Toggle Visibility
//                    case 71:  CorrelationMatrix.ToggleVisibility(true);
//                              break;
//                              
//                    //____________________ SETTINGS MENU ____________________
//                    // Q - SETTINGS MENU
//                    case 81:  InterfaceSettings.ToggleVisibility(true);
//                              break;          
//
//                    //____________________ FEATURES ____________________
//                    // Y - SCREENSHOT
//                    case 89:  ResetLastError();
//                              TakeScreenshot();
//                              break;
//                           
//                    // E - OPEN SCREENSHOT FOLDER          
//                    case 69:  ResetLastError();
//                              OpenScreenshotFolder();
//                              break;
//               }
//               
//               return;
//          }
//     }
//
//
//


