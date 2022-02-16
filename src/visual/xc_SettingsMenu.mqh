////+------------------------------------------------------------------------------------------------------------------------------------------------------------+
////|                                                                    SETTINGS MENU                                                                           |
////+------------------------------------------------------------------------------------------------------------------------------------------------------------+
////____________________ CONTAINER ____________________
//int       BottomContainerHeight         = 0;
//int       BottomContainerWidth          = 0;
//int       BottomContainerXDist          = 0;
//int       BottomContainerYDist          = 0;
//
//int       TopContainerHeight            = 0;
//int       TopContainerWidth             = 0;
//int       TopContainerXDist             = 0;
//int       TopContainerYDist             = 0;
//
//int       OuterContainerHeight          = 0;
//int       OuterContainerWidth           = 0;
//int       OuterContainerTop             = 0;
//int       OuterContainerBottom          = 0;
//int       OuterContainerRight           = 0;
//int       OuterContainerLeft            = 0;
//int       OuterContainerCentreX         = 0;
//int       OuterContainerCentreY         = 0;
//
////____________________ UX ACTIVE ____________________
//bool      NavBarActive                  = false;
//
////____________________ NAV BAR ____________________
//int       NoOfNavBarItems               = 5;
//int       NavBarActiveItem              = 0;
//string    NavBarTitles                  [];
//color     NavBarShapeActiveColour       = TronWhite;
//color     NavBarShapeInactiveColour     = TronGray;
//color     NavBarTextActiveColour        = clrBlack;
//color     NavBarTextInactiveColour      = TronWhite;
//
////string	DNAFileName				= "";
//int		DNAHelixCount				= 0;
//
//class cInterfaceSettings {
//     public:
//          //____________________ NAV BAR ____________________
//          void UpdateNavBarLabels() {
//               UpdateText("UltraDOM_SettingsMenu_NavTitle", NavBarTitles[NavBarActiveItem]);
//               
//               for (int i = 0; i < NoOfNavBarItems; i++) {
//                    if (i == NavBarActiveItem) {
//                         // SHAPE
//                         StringConcatenate(me, "UltraDOM_SettingsMenu_NavBar_Shape_", i);
//                         UpdateShapeColour(me, NavBarShapeActiveColour);
//                         
//                         // TEXT
//                         StringConcatenate(me, "UltraDOM_SettingsMenu_NavBar_Text_", i);
//                         UpdateTextColour(me, NavBarTextActiveColour);
//                    
//                    } else {
//                         // SHAPE
//                         StringConcatenate(me, "UltraDOM_SettingsMenu_NavBar_Shape_", i);
//                         UpdateShapeColour(me, NavBarShapeInactiveColour);
//                         
//                         // TEXT
//                         StringConcatenate(me, "UltraDOM_SettingsMenu_NavBar_Text_", i);
//                         UpdateTextColour(me, NavBarTextInactiveColour);
//                    }
//               }
//               
//               UpdateNavBarGraphics();
//          }
//          
//          void UpdateNavBarGraphics() {
//               ObjectsDeleteAll(ChartContainer.myChartID, "UltraDOM_SettingsMenu_Group", -1, -1);
//               
//               if (NavBarActiveItem == 0) {
//                    //__________ CONTROLLER GRAPHIC __________
//                    string    Group = "Group1";
//                    StringConcatenate(me, "UltraDOM_SettingsMenu_", Group, "_ControllerLayoutStandard");
//                    GetBitmapSize("Graphics\\ControllerLayoutStandard");
//                    myXDist   = (OuterContainerRight - myWidth);
//                    myYDist   = GetShapeYDistance("UltraDOM_SettingsMenu_NavBar_Shape_0") + GetShapeHeight("UltraDOM_SettingsMenu_NavBar_Shape_0");
//                    
//                    if (!CreateBitmap(me, "Graphics\\ControllerLayoutStandard", CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, false, 0)) {
//                         Files.Log("COULDN'T CREATE " + me);
//                    }
//               }
//          }
//          
//          void NavBarPreviousItem() {
//               if (NavBarActiveItem == 0) {
//                    NavBarActiveItem = (NoOfNavBarItems - 1);
//               } else {
//                    NavBarActiveItem--;
//               }
//               
//               UpdateNavBarLabels();
//          }
//          
//          void NavBarNextItem() {
//               if (NavBarActiveItem == (NoOfNavBarItems - 1)) {
//                    NavBarActiveItem = 0;
//               } else {
//                    NavBarActiveItem++;
//               }
//               
//               UpdateNavBarLabels();
//          }
//
//          //____________________ NAVIGATION OVERALL ____________________
//          void Select() {
//               Files.Log(__FUNCTION__);
//               ResetLastError();
//          }
//          
//          void NavigateLeft() {
//               Files.Log(__FUNCTION__);
//               ResetLastError();
//               
//               if (NavBarActive) {
//                    NavBarPreviousItem();
//               }
//          }
//          
//          void NavigateRight() {
//               Files.Log(__FUNCTION__);
//               ResetLastError();
//               
//               if (NavBarActive) {
//                    NavBarNextItem();
//               }
//          }
//          
//          void NavigateUp() {
//               Files.Log(__FUNCTION__);
//               ResetLastError();
//          }
//          
//          void NavigateDown() {
//               Files.Log(__FUNCTION__);
//               ResetLastError();
//          }
//          
//          //____________________ SETTINGS ____________________
//          //__________ TOGGLE __________
//          void ToggleVisibility(bool Enabled) {
//               ResetLastError();
//               Files.Log(__FUNCTION__);
//               
//               if (!Enabled) {
//                    ObjectsDeleteAll(ChartContainer.myChartID, "UltraDOM_SettingsMenu", 0, -1);
//                    InterfaceIsActive[INTERFACE_SETTINGSMENU] = false;
//               } else {
//                    Create();
//                    UpdateNavBarLabels();
//                    InterfaceIsActive[INTERFACE_SETTINGSMENU] = true;
//               }
//          }
//          
//          //__________ CREATE __________
//          void Create() {
//               NavBarActive      = true;
//               NavBarActiveItem  = 1;
//               
//               string ShapeName;
//               
//               //____________________ BACKGROUND ____________________
//               me        = "UltraDOM_SettingsMenu_Background";
//               myWidth   = (ChartContainer.Width + 100);
//               myHeight  = (ChartContainer.Height + 100);
//               CreateRectangleLabel(me, CORNER_LEFT_UPPER, (int)(ChartContainer.CentreX - (myWidth * 0.5)), (int)(ChartContainer.CentreY - (myHeight * 0.5)), myWidth, myHeight, clrBlack, false, BORDER_FLAT, clrNONE, STYLE_SOLID, 0);
//               
//               //____________________ ____________________//____________________ CONTAINERS ____________________//____________________ ____________________
//               // BOTTOM
//               me   = "UltraDOM_SettingsMenu_BottomContainer";
//               GetBitmapSize("Graphics\\Logo1_Small");
//               BottomContainerHeight    = (int)(myHeight * 1.05);
//               BottomContainerWidth     = (int)(ChartContainer.Width * 1.05);
//               BottomContainerXDist     = (int)(ChartContainer.CentreX - (BottomContainerWidth * 0.5));
//               BottomContainerYDist     = (ChartContainer.Bottom - BottomContainerHeight);
//               CreateRectangleLabel(me, CORNER_LEFT_UPPER, BottomContainerXDist, BottomContainerYDist, BottomContainerWidth, BottomContainerHeight, clrBlack, false, BORDER_FLAT, TronGray, STYLE_SOLID, 1);
//               
//               // TOP
//               me   = "UltraDOM_SettingsMenu_TopContainer";
//               TopContainerHeight       = BottomContainerHeight;
//               TopContainerWidth        = BottomContainerWidth;
//               TopContainerXDist        = (int)(ChartContainer.CentreX - (TopContainerWidth * 0.5));
//               TopContainerYDist        = ChartContainer.Top;
//               CreateRectangleLabel(me, CORNER_LEFT_UPPER, TopContainerXDist, TopContainerYDist, TopContainerWidth, TopContainerHeight, clrBlack, false, BORDER_FLAT, TronGray, STYLE_SOLID, 1);
//               
//               // CENTRE
//               me   = "UltraDOM_SettingsMenu_OuterContainer";
//               OuterContainerHeight     = (int)(ChartContainer.Height - TopContainerHeight - BottomContainerHeight);
//               OuterContainerWidth      = (int)(ChartContainer.Width * 0.7);
//               OuterContainerLeft       = (int)(ChartContainer.CentreX - (OuterContainerWidth * 0.5));
//               OuterContainerRight      = (OuterContainerLeft + OuterContainerWidth);
//               OuterContainerTop        = (int)(ChartContainer.CentreY - (OuterContainerHeight * 0.5));
//               OuterContainerBottom     = (int)(OuterContainerTop + OuterContainerHeight);
//               OuterContainerCentreX    = (int)(OuterContainerLeft + (OuterContainerWidth * 0.5));
//               OuterContainerCentreY    = (int)(OuterContainerTop + (OuterContainerHeight * 0.5));
//               //CreateRectangleLabel(me, CORNER_LEFT_UPPER, OuterContainerLeft, OuterContainerTop, OuterContainerWidth, OuterContainerHeight, clrBlack, false, BORDER_FLAT, clrBlack, STYLE_SOLID, 1);
//               
//               //____________________ DNA HELIX ____________________
//               DNAHelixCount = 0;
//               GetBitmapSize("Graphics\\DNA\\0");
//               CreateBitmap("UltraDOM_SettingsMenu_DNA", "Graphics\\DNA\\0", CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, (OuterContainerLeft - myWidth), OuterContainerTop, false, 0);
//               
//               //____________________ NAV BREADCRUMB ____________________
//               me        = "UltraDOM_SettingsMenu_NavBreadcrumb";
//               myText    = "MAIN MENU/";
//               Font      = EurostileRegular;
//               FontSize  = GetFittedFontX(myText, (int)(OuterContainerWidth * 0.15), Font);
//               myXDist   = OuterContainerLeft;
//               myYDist   = OuterContainerTop;
//               CreateLabel(me, myText, Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, TronWhite, false);
//               
//               //____________________ NAV TITLE ____________________
//               me        = "UltraDOM_SettingsMenu_NavTitle";
//               myText    = "CONTROLS";
//               Font      = EurostileRegular;
//               FontSize  = (FontSize * 2);
//               myXDist   = OuterContainerLeft;
//               myYDist   = GetShapeYDistance("UltraDOM_SettingsMenu_NavBreadcrumb") + GetTextHeight("UltraDOM_SettingsMenu_NavBreadcrumb");
//               CreateLabel(me, myText, Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, TronWhite, false);
//               
//               //____________________ NAV BAR ____________________
//               // ALL FONTS THE SAME SIZE
//               int       NavBarItemHeight         = (int)(OuterContainerHeight * 0.08);
//               int       NavBarItemWidth          = (OuterContainerWidth / NoOfNavBarItems);
//               string    NavBarItemFont           = EurostileRegular;
//               int       NavBarItemFontSize       = 1000;
//               int       FontSizes                [];
//               int       NavBarItemYDist          = GetShapeYDistance("UltraDOM_SettingsMenu_NavTitle") + GetTextHeight("UltraDOM_SettingsMenu_NavTitle");
//               ArrayResize(NavBarTitles, NoOfNavBarItems);
//               ArrayResize(FontSizes,    NoOfNavBarItems);
//               
//               for (int i = 0; i < NoOfNavBarItems; i++) {
//                    switch(i) {
//                         case 0: NavBarTitles[i] = "CONTROLS";  break;
//                         case 1: NavBarTitles[i] = "SOUNDS";    break;
//                         case 2: NavBarTitles[i] = "DOM";       break;
//                         case 3: NavBarTitles[i] = "CHARTS";    break;
//                         case 4: NavBarTitles[i] = "ORDERS";    break;
//                    }
//                    
//                    FontSizes[i] = MathMin(GetFittedFontX(NavBarTitles[i], (int)(NavBarItemWidth * 0.9), Font), GetFittedFontY(NavBarTitles[i], (int)(0.9 * NavBarItemHeight), Font));
//                    if (FontSizes[i] < NavBarItemFontSize) {
//                         NavBarItemFontSize = FontSizes[i];
//                    }
//               }
//               
//               for (int i = 0; i < NoOfNavBarItems; i++) {                    
//                    StringConcatenate(me, "UltraDOM_SettingsMenu_NavBar_Shape_", i);
//                    ShapeName = me;
//                    myXDist   = OuterContainerLeft + (NavBarItemWidth * i);
//                    myYDist   = NavBarItemYDist;
//                    CreateRectangleLabel(me, CORNER_LEFT_UPPER, myXDist, myYDist, NavBarItemWidth, NavBarItemHeight, NavBarShapeInactiveColour, false, BORDER_RAISED, clrNONE, STYLE_SOLID, 1);
//                    
//                    StringConcatenate(me, "UltraDOM_SettingsMenu_NavBar_Text_", i);
//                    myHeight  = GetTextHeightNew(NavBarTitles[i], NavBarItemFont, NavBarItemFontSize);
//                    myWidth   = GetTextWidthNew(NavBarTitles[i], NavBarItemFont, NavBarItemFontSize);
//                    myXDist   = (int)( (GetShapeXDistance(ShapeName) + (GetShapeWidth(ShapeName) * 0.5)) - (myWidth * 0.5) );
//                    myYDist   = (int)( (GetShapeYDistance(ShapeName) + (GetShapeHeight(ShapeName) * 0.5)) - (myHeight * 0.5) );
//                    CreateLabel(me, NavBarTitles[i], NavBarItemFont, NavBarItemFontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, NavBarTextInactiveColour, false);
//               }
//               
//               //____________________ ____________________//____________________ BOTTOM ____________________//____________________ ____________________
//               //____________________ TW LOGO ____________________
//               GetBitmapSize("Graphics\\Logo1_Small");
//               me        = "UltraDOM_SettingsMenu_Logo";
//               myXDist   = 0;
//               myYDist   = 0;
//               
//               if (!CreateBitmap(me, "Graphics\\Logo1_Small", CORNER_LEFT_LOWER, ANCHOR_LEFT_LOWER, myXDist, myYDist, false, 0)) {
//                    Files.Log("COULDN'T CREATE " + me);
//               }
//               
//               ShapeName = me;
//               
//               //____________________ BETA FEEDBACK ____________________
//               me        = "UltraDOM_SettingsMenu_BetaLink";
//               myText    = "BETA FEEDBACK";
//               Font      = EurostileRegular;
//               FontSize  = MathMin(GetFittedFontX(myText, GetShapeWidth(ShapeName), Font), GetFittedFontY(myText, (int)(BottomContainerHeight * 0.3), Font));
//               myHeight  = GetTextHeightNew(myText, Font, FontSize);
//               myWidth   = GetTextWidthNew(myText, Font, FontSize);
//               myXDist   = GetShapeXDistance(ShapeName) + GetShapeWidth(ShapeName) + 30;
//               myYDist   = (int)( (ChartContainer.Bottom - (BottomContainerHeight * 0.5)) - (myHeight * 0.5) );
//               CreateLabel(me, myText, Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, clrTomato, false);
//               
//               ShapeName = me;
//               
//               //____________________ SUPPORT ____________________
//               me        = "UltraDOM_SettingsMenu_SupportLink";
//               myText    = "SUPPORT";
//               Font      = EurostileRegular;
//               myHeight  = GetTextHeightNew(myText, Font, FontSize);
//               myWidth   = GetTextWidthNew(myText, Font, FontSize);
//               myXDist   = GetShapeXDistance(ShapeName) + GetTextWidth(ShapeName) + 30;
//               myYDist   = (int)( (ChartContainer.Bottom - (BottomContainerHeight * 0.5)) - (myHeight * 0.5) );
//               CreateLabel(me, myText, Font, FontSize, CORNER_LEFT_UPPER, ANCHOR_LEFT_UPPER, myXDist, myYDist, clrGreenYellow, false);
//               
//               // END
//               InterfaceIsActive[INTERFACE_SETTINGSMENU] = true;
//          }
//};
//cInterfaceSettings InterfaceSettings;