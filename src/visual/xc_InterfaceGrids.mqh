//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                                GRID POINTER                                                                                |
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//class cGridPointer {
//	public:
////		void Reset() {
////			ResetLastError();
////			Log.WriteGridPointer(__FUNCSIG__);
////			
////			// FIND FIRST ACTIVE GRID IN CHART AND ASSIGN POINTER TO IT
////			for (int WhichGrid = 0; WhichGrid < MAXIMUM_NO_OF_GRIDS; WhichGrid++) {
////				if (GRID_SETTINGS[WhichGrid,GRID_ISACTIVE] == 1) {
////					GRID_POINTER = WhichGrid;
////					break;
////				}
////			}
////		}
//
//		
//};
//cGridPointer GridPointer;

     	


//     	void InsertRows() {
//     		ResetLastError();
//     		Files.Log(__FUNCTION__);
//     		
//     		SettingsFiles.Read(GRIDSETTINGS_FILENAME, GRID_SETTINGS);
//     		     		
//          	int ACTIVE_ROWS = GRID_SETTINGS[GRID_POINTER,GRID_ROWS];
//          	
//          	if ((ACTIVE_ROWS + 2) <= MAXIMUM_GRID_ROWS) {
//          		GRID_SETTINGS[GRID_POINTER,GRID_ROWS] = (ACTIVE_ROWS + 2);
//          	} else {
//          		Files.Log("MAXIMUM ROWS REACHED");
//          	}
//          	
//          	Settings.Write();
//     		Create_IndividualGrid(GRID_POINTER);
//     		Create_IndividualDOM(GRID_POINTER);
//     		Create_PointerLabels();
//     		PrintGridSpecs();
//     	}
//     	
//     	void RemoveRows() {
//     		ResetLastError();
//     		Files.Log(__FUNCTION__);
//     		
//     		Settings.Read();
//     		int ACTIVE_ROWS = GRID_SETTINGS[GRID_POINTER,GRID_ROWS];
//          	
//          	if ((ACTIVE_ROWS - 2) >= MINIMUM_GRID_ROWS) {
//          		GRID_SETTINGS[GRID_POINTER,GRID_ROWS] = (ACTIVE_ROWS - 2);
//          	} else {
//          		Files.Log("MINIMUM ROWS REACHED");
//          	}
//          	
//          	Settings.Write();
//     		Create_IndividualGrid(GRID_POINTER);
//     		Create_IndividualDOM(GRID_POINTER);
//     		Create_PointerLabels();
//     		PrintGridSpecs();
//     	}
//     	
//     	//________________________________________
//     	int NextInactiveMarket_Left() {
//     		ResetLastError();
//     		Files.Log(__FUNCTION__);
//     		
//     		Settings.Read();
//          	int ACTIVE_MARKET = GRID_SETTINGS[GRID_POINTER,GRID_MARKETPOS];
//          	
//          	// SEARCH ACTIVE_MARKET DOWNWARDS TOWARD ZERO, TOP TO BOTTOM DIRECTION
//          	for (int i = ACTIVE_MARKET-1; i >= 0; i--) {
//          		bool ThisMarketIsInUse = false;
//          		
//     			for (int j = 0; j < MAXIMUM_NO_OF_GRIDS; j++) {
//					if ((GRID_SETTINGS[j,GRID_MARKETPOS] == i) && GridIsActive(j)) {
//						ThisMarketIsInUse = true;
//						break;
//					}
//				}
//				
//				if (!ThisMarketIsInUse) {
//					Files.Log("FOUND AVAILABLE MARKET IN " + (string)i + " | " + MarketDataString[i,MARKET_CODE]);
//					return(i);
//				}
//			}
//			
//			// SEARCH FROM NO_OF_MARKETS THROUGH TO CURRENT ONE, TOP TO BOTTOM IS THE DIRECTION
//          	for (int i = NO_OF_MARKETS-1; i > ACTIVE_MARKET; i--) {
//          		bool ThisMarketIsInUse = false;
//          		
//     			for (int j = 0; j < MAXIMUM_NO_OF_GRIDS; j++) {
//					if ((GRID_SETTINGS[j,GRID_MARKETPOS] == i) && GridIsActive(j)) {
//						ThisMarketIsInUse = true;
//						break;
//					}
//				}
//				
//				if (!ThisMarketIsInUse) {
//					Files.Log("FOUND AVAILABLE MARKET IN " + (string)i + " | " + MarketDataString[i,MARKET_CODE]);
//					return(i);
//				}
//			}
//			
//			Files.Log("COULDN'T FIND AVAILABLE MARKET");
//			return(-1);
//          }
//		
////		//________________________________________
////     	int NextInactiveMarket_Right() {
////     		ResetLastError();
////     		Files.Log(__FUNCTION__);
////     		
////     		Settings.Read();   	
////          	int ACTIVE_MARKET = GRID_SETTINGS[GRID_POINTER,GRID_MARKETPOS];
////          	
////          	// SEARCH ACTIVE_MARKET UPWARD TOWARD NO_OF_MARKETS
////          	for (int i = ACTIVE_MARKET+1; i < MARKETS_SUBSCRIBED; i++) {
////          		bool ThisMarketIsInUse = false;
////          		
////     			for (int j = 0; j < MAXIMUM_NO_OF_GRIDS; j++) {
////					if ((GRID_SETTINGS[j,GRID_MARKETPOS] == i) && GridIsActive(j)) {
////						ThisMarketIsInUse = true;
////						break;
////					}
////				}
////				
////				if (!ThisMarketIsInUse) {
////					Files.Log("FOUND AVAILABLE MARKET IN " + (string)i + " | " + MarketDataString[i,MARKET_CODE]);
////					return(i);
////				}
////			}
////			
////			// SEARCH FROM CURRENT MARKET TO TOP
////          	for (int i = 0; i < ACTIVE_MARKET-1; i++) {
////          		bool ThisMarketIsInUse = false;
////          		
////     			for (int j = 0; j < MAXIMUM_NO_OF_GRIDS; j++) {
////					if ((GRID_SETTINGS[j,GRID_MARKETPOS] == i) && GridIsActive(j)) {
////						ThisMarketIsInUse = true;
////						break;
////					}
////				}
////				
////				if (!ThisMarketIsInUse) {
////					Files.Log("FOUND AVAILABLE MARKET IN " + (string)i + " | " + MarketDataString[i,MARKET_CODE]);
////					return(i);
////				}
////			}
////			
////			Files.Log("COULDN'T FIND AVAILABLE MARKET");
////			return(-1);
////          }
//          
//          //________________________________________
////          int NextInactiveGrid_Left() {
////          	ResetLastError();
////     		Files.Log(__FUNCTION__);
////           	
////     		Settings.Read();
////          	
////          	for (int i = GRID_POINTER; i >= 0; i--) {
////				Files.Log("CALLING GridIsActiveWith " + (string)i + " SEARCHING LOWER <<");
////				
////				if (!GridIsActive(i)) {
////					Files.Log("FOUND AVAILABLE GRID IN " + (string)i);
////					return(i);
////				}
////			}
////			
////			for (int i = MAXIMUM_NO_OF_GRIDS-1; i >= GRID_POINTER; i--) {
////				Files.Log("CALLING GridIsActiveWith " + (string)i + " SEARCHING UPPER <<");
////				
////				if (!GridIsActive(i)) {
////					Files.Log("FOUND AVAILABLE GRID IN " + (string)i);
////					return(i);
////				}
////			}
////			
////			Files.Log("COULDN'T FIND AVAILABLE GRID");
////			return(-1);
////     	}
//
//     	
////     	//________________________________________
////     	int NextActiveGrid_Right() {
////     		ResetLastError();
////			Files.Log(__FUNCTION__);
////			
////     		if (NoOfActiveGrids() == 1) {
////           		return(GRID_POINTER);
////           	}
////           	
////           	// START FROM POINTER AND WORK TO END OF ARRAY
////           	Files.Log("GRID POINTER " + GRID_POINTER);
////    			for (int i = GRID_POINTER+1; i < MAXIMUM_NO_OF_GRIDS; i++) {
////				Files.Log("Searching upwards/upper section: " + i);
////				if (GridIsActive(i)) {
////					Files.Log("Found in " + i);
////					return(i);
////				}
////			}
////			Files.Log("NOT FOUND IN UPPER SECTION");
////			
////			
////			//... NOT FOUND IN UPPER SECTION, TRY BOTTOM
////			Files.Log("GRID POINTER " + GRID_POINTER);
////			for (int i = 0; i < GRID_POINTER; i++) {
////     			Files.Log("Searching upwards/lower section: " + i);
////     			if (GridIsActive(i)) {
////     				Files.Log("Found in " + i);
////     				return(i);
////     			}
////			}
////			Files.Log("NOT FOUND IN LOWER SECTION");
////			
////			return(-1);
////		}
//		
//		//________________________________________
////          void AddGrid() {
////          	ResetLastError();
////          	Files.Log(__FUNCTION__);
////          	
////          	Settings.Read();
////          	
////          	if (NoOfActiveGrids() >= MARKETS_SUBSCRIBED) {
////     			Files.Log("ADD MORE MARKETS TO WATCHLIST");
////     			return;
////     		} else if (NoOfActiveGrids() == MAXIMUM_NO_OF_GRIDS) {
////          		Files.Log("MAXIMUM NO OF GRIDS REACHED");
////          		return;
////          	}
////			
////			// UPDATE GRID AND MARKET
////			int 	GridToEnable	= NextInactiveGrid_Left();
////			int	MarketToEnable	= NextInactiveMarket_Right();
////			
////			Files.Log("GRID TO ENABLE = " + (string)GridToEnable);
////			Files.Log("MARKET TO ENABLE = " + (string)MarketToEnable);
////			
////			GRID_SETTINGS[GridToEnable,GRID_ISACTIVE]	= 1;
////   			GRID_SETTINGS[GridToEnable,GRID_MARKETPOS] 	= MarketToEnable;
////			
////          	Settings.Write();
////          	Create_AllGrids();
////          	Create_AllDOMs();
////          	Create_PointerLabels();
////          }
//          
//          //________________________________________
////          void RemoveGrid() {
////               ResetLastError();
////               Files.Log(__FUNCTION__);
////               
////               Settings.Read();
////               
////               if (NoOfActiveGrids() == MINIMUM_NO_OF_GRIDS) {
////                    Files.Log("MINIMUM NO OF GRIDS REACHED");
////                    return;
////			}
////   
////   			GRID_SETTINGS[GRID_POINTER,GRID_ISACTIVE] = -1;
////   			GRID_SETTINGS[GRID_POINTER,GRID_MARKETPOS] = -1;
////   			            
////               Settings.Write();
////               Create_AllGrids();
////               Create_AllDOMs();
////               Create_PointerLabels();
////          }