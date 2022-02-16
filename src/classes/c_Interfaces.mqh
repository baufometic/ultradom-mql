#define 	MAIN_SCREEN					if (CheckPointer(MainScreen)  != POINTER_INVALID)
#define 	START_SCREEN				if (CheckPointer(StartScreen) != POINTER_INVALID)

class cStartScreen {
	private:
		cImage				*Logo;
		cRectangle 			*TopBox;
		cRectangle 			*BottomBox;
		cLabel				*Copyright1;
		cLabel				*Copyright2;
		cHuman				*Human;
		cLabel 				*Caption1;	// ULTRA_DOM
		cLabel 				*Caption2;	// PRESS_START
		cParallax			*ParallaxCaption1;
		cParallax			*ParallaxCaption2;

		int       			PressStartColourCount, PressStartColourDirection;
		string    			PressStartColourString;

	public:
		cStartScreen() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Create();
		}

		~cStartScreen() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			delete		(Human);
			delete		(Logo);
			delete		(TopBox);
			delete		(BottomBox);
			delete		(Copyright1);
			delete		(Copyright2);
			delete		(Caption1);
			delete		(Caption2);
			delete		(ParallaxCaption1);
			delete		(ParallaxCaption2);

			ChartRedraw	(myChartID);
		}

		void Create() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			// COVER RECT
			int h 	= Screen.Dimensions.Height * 2;
			int w 	= Screen.Dimensions.Width * 2;
			
			cRectangle *CoverRect 				= new cRectangle("Cover Rectangle");	// enables a temp fix for this buggy move into place issue
			CoverRect.SetBackgroundColour		(clrBlack);
			CoverRect.SetBack					(false);
			CoverRect.SetHeight					(h);
			CoverRect.SetWidth					(w);
			CoverRect.SetX						(Screen.Dimensions.CentreX - (int)(w * 0.5));
			CoverRect.SetY						(Screen.Dimensions.CentreY - (int)(h * 0.5));
			ChartRedraw							(myChartID);
			
			Screen.SetBackgroundColour			(clrBlack);	// (C'1,1,3');

			// HUMAN
			Human 								= new cHuman;
			TopBox 								= new cRectangle("StartScreen_TopBox");
			BottomBox 							= new cRectangle("StartScreen_BottomBox");
			Logo								= new cImage	("LogoSmall", "Logo1_Small_NoGlow");
			
			// TOP x BOTTOM BOXES
			TopBox.SetBorderColour				(TronMeanwhile);
			TopBox.SetBorderWidth				(1);
			TopBox.SetBackgroundColour			(clrBlack);

			BottomBox.SetBorderColour			(TronMeanwhile);
			BottomBox.SetBorderWidth			(1);
			BottomBox.SetBackgroundColour		(clrBlack);

 			// COPYRIGHT INFO
			Copyright1 							= new cLabel("CopyrightInfo1");
			Copyright1.SetText					("© 2018 Trading Warfare and UltraDOM are");
			Copyright1.SetFont					(Verdana);
			Copyright1.SetFontColour			(clrWhiteSmoke);
			
			Copyright2 							= new cLabel("CopyrightInfo2");
			Copyright2.SetText					("registered trademarks of Trading Warfare Ltd.");
			Copyright2.SetFont					(Verdana);
			Copyright2.SetFontColour			(clrWhiteSmoke);
			
			// ULTRADOM x PRESS START
			Caption1 							= new cLabel("Caption1");
			Caption1.SetText					("ULTRA_DOM");
			Caption1.SetFont					(OCR);
			Caption1.SetFontColour				(C'230,255,255');
			Caption1.ToggleShadow				(true, C'255,230,77');

			Caption2 							= new cLabel("Caption2");
			Caption2.SetText					("PRESS START");
			Caption2.SetFont					(OCR);
			Caption2.SetFontColour				(C'20,20,10');
			Caption2.ToggleShadow				(true, C'2,20,31');

			// SET POSITIONS
			SetPositions						();

			// CREATE PARALLAX FOR CAPTION LABELS	// can't be done till initial position known ^
			ParallaxCaption1 					= new cParallax(Caption1, 0.08, 0.06);
			ParallaxCaption2 					= new cParallax(Caption2, 0.08, 0.06);

			// TEMPORARY - TESTING POLYGON COORDINATES
			// CCanvas *TestCanvas = new CCanvas;
			// TestCanvas.CreateBitmapLabel	("TestCanvas", Screen.Dimensions.Left, Screen.Dimensions.Top, Screen.Dimensions.Width, Screen.Dimensions.Height, COLOR_FORMAT_ARGB_NORMALIZE); // NAME, x, y, w, h
			// TestCanvas.Erase				(ColorToARGB(clrWhiteSmoke));
			// TestCanvas.TransparentLevelSet(100);

			// int X[4];
			// int Y[4];
			// //int x = Screen.Dimensions.CentreX;
			// //int y = Screen.Dimensions.CentreY;
			// X[0] = 200;	Y[0] = 200;
			// X[1] = 200;	Y[1] = 400;
			// X[2] = 400;	Y[2] = 600;
			// X[3] = 400;	Y[3] = 700;

			// TestCanvas.FillPolygon(X, Y, clrWhite);
			// TestCanvas.Update(true);
			// ChartRedraw(myChartID);

			// COMPLETE
			delete								(CoverRect);
			ChartRedraw							(myChartID);
		}

		void SetPositions() {
			ResetLastError();

			// HUMAN
			Human.SetPositions(Screen.Dimensions.CentreX, Screen.Dimensions.CentreY);
			
			// TOP x BOTTOM BOXES
			int h = (int)(Logo.Height() * 1.06);
			int w = (int)(Screen.Dimensions.Width * 2);

			TopBox.SetHeight				(h);
			TopBox.SetWidth					(w);	
			TopBox.SetX						(Screen.Dimensions.CentreX - (int)(w * 0.5));
			TopBox.SetY						(0);

			BottomBox.SetHeight				(h);
			BottomBox.SetWidth				(w);	
			BottomBox.SetX					(Screen.Dimensions.CentreX - (int)(w * 0.5));
			BottomBox.SetY					(Screen.Dimensions.Bottom - BottomBox.Height() - 2);

			// LOGO
			Logo.SetX(Screen.Dimensions.CentreX - (int)(Logo.Width() * 0.5));
			Logo.SetY(TopBox.Top() + 2);

			//__________ COPYRIGHT INFO __________
			int IndividualHeight	= (int)(BottomBox.Height() * 0.2);
			int RemainingHeight 	= BottomBox.Height() - (IndividualHeight * 2); // 2 elements

			Copyright1.SetHeight	(IndividualHeight);
			Copyright1.SetX			(Screen.Dimensions.CentreX - (int)(Copyright1.Width() * 0.5));
			Copyright1.SetY			(BottomBox.Top() + (int)(RemainingHeight * 0.5));

			Copyright2.SetHeight	(IndividualHeight);
			Copyright2.SetX			(Screen.Dimensions.CentreX - (int)(Copyright2.Width() * 0.5));
			Copyright2.SetY			(Copyright1.Bottom());

			//__________ PRESS START __________
			Caption1.SetWidth		((int)(Screen.Dimensions.Width * 0.6));
			Caption1.SetX			((int)(Screen.Dimensions.CentreX - (Caption1.Width() * 0.5)));
			Caption1.SetY			(Screen.Dimensions.CentreY - Caption1.Height());

			Caption2.SetWidth		((int)(Screen.Dimensions.Width * 0.6));
			Caption2.SetX			(Screen.Dimensions.CentreX - (int)(Caption2.Width() * 0.5));
			Caption2.SetY			(Screen.Dimensions.CentreY);
		}

		void LoopHandler() {
			ResetLastError();

			// HUMAN
			Human.LoopHandler();

			// FLASHING TEXT
			if (PressStartColourDirection == 1) {
				if (PressStartColourCount < 200)	PressStartColourCount 		+= 5;
				else								PressStartColourDirection 	= -1;

			} else if (PressStartColourDirection == -1) {
				if (PressStartColourCount > 0)		PressStartColourCount 		-= 5;
				else								PressStartColourDirection 	= 1;

			} else {
													PressStartColourDirection 	= 1;
													PressStartColourCount 		= 0;
			}

			StringConcatenate(PressStartColourString, "C", "'", PressStartColourCount, ",", PressStartColourCount + 20, ",", PressStartColourCount + 10, "'");
			Caption2.SetFontColour((color)PressStartColourString);
		}

		void EventHandler(int m_EventType, long m_KeystrokeOrX, double m_Y, string m_ObjectName) {
			if (m_EventType == CHARTEVENT_MOUSE_MOVE) {
				ParallaxCaption1.Update();
				ParallaxCaption2.Update();

				if (Logo.MouseHasEntered()) {
					Sound.Play("MenuSelect");
					Logo.SetFile("Logo1_Small_Glow");
				} else if (Logo.MouseHasExit()) {
					Logo.SetFile("Logo1_Small_NoGlow");
				}
					
				return;
			
			} else if (m_EventType == CHARTEVENT_KEYDOWN) {
				return;
			
			} else if (m_EventType == CHARTEVENT_OBJECT_CLICK) {
				return;

			} else if (m_EventType == CHARTEVENT_CHART_CHANGE) {
				SetPositions					();
				ParallaxCaption1.SetPositions();
				ParallaxCaption2.SetPositions();
			}	
		}
};

class cMainScreen {
	private:
        cClock			*Clock;
		cFadingLabel	*LastKeyPressed;
		cGodMode		*GodMode;

		int h, w, CentreX, CentreY;

	public:
		cMainScreen() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			GodMode								= new cGodMode();
			Clock								= new cClock();
			LastKeyPressed 						= new cFadingLabel("Last Key Pressed", OCR, 50, Screen.Dimensions.CentreX, clrWhite, 50);
			LastKeyPressed.Label.ToggleShadow	(true, C'2,20,31');
			LastKeyPressed.Label.SetHeight		((int)(Screen.Dimensions.Height * 0.1));
		}

		~cMainScreen() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			delete		(LastKeyPressed);
			delete		(Clock);
			delete		(GodMode);
		}

		void LoopHandler() {
			ResetLastError();

			Clock.UpdateTime();
			LastKeyPressed.LoopHandler();
		}

		void SetPositions() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			// CLOCK
			CentreX = Screen.Dimensions.CentreX;
			CentreY = Screen.Dimensions.Top + (int)(Clock.Specs.Height * 0.5);
			Clock.SetPositions	(CentreX, CentreY);

			// GOD MODE - REQUIRES SETTING OF CLOCK FIRST SO POSITION CAN BE PULLED THROUGH .SPECS.
			h 		= Screen.Dimensions.Bottom - Clock.Specs.CentreY;
			w 		= Screen.Dimensions.Width;
			CentreX	= Screen.Dimensions.CentreX;
			CentreY	= Clock.Specs.CentreY + (int)(h * 0.5);
			GodMode.SetPositions(h, w, CentreX, CentreY);
		}
		
		void EventHandler(int m_EventType, long m_KeystrokeOrX, double m_Y, string m_ObjectName) {
			ResetLastError();
			
			if (m_EventType == CHARTEVENT_MOUSE_MOVE) {
				if (CheckPointer(GodMode) != POINTER_INVALID) {
					GodMode.EventHandler(m_EventType, m_KeystrokeOrX, m_Y, m_ObjectName);
				}
			
			} else if (m_EventType == CHARTEVENT_KEYDOWN) {
				LastKeyPressed.Update();
					
				switch((int)m_KeystrokeOrX) {
                    if (lparam == KEY_T) {
                        Enabled = !Enabled;
                        Toggle(Enabled);
                        return(false);
                    }

                    if (Enabled) {
                        LastKeyPressed = HotkeyDefinitions[(int)lparam];
                        return(true);
                    } else {
                        Sound.Play("Hotkeys\\EnableTheHotkeys");
                        return(false);
                    }
				}
				
			} else if (m_EventType == CHARTEVENT_OBJECT_CLICK) {
				
			} else if (m_EventType == CHARTEVENT_CHART_CHANGE) {
				SetPositions();
				
			}
		}
};

class cInterfaces {

		bool Initialise() {
			if (!DEV_MODE_SKIP_LOGOSPLASH) {
				cSplashLogo *SplashLogo = new cSplashLogo;
				delete(SplashLogo);
			}

			// TYPERWRITER
			if (!DEV_MODE_SKIP_TEXTSPLASH) {
				string Lines[1];
				Lines[0] = "TRADING WARFARE PRESENTS";
				cTypewriter *SplashText = new cTypewriter(Lines, OCR, TronWhite, (int)(Screen.Dimensions.Width * 0.5), Screen.Dimensions.CentreX, Screen.Dimensions.CentreY, true);
				SplashText.Out();
				delete(SplashText);
			}

			// CREATE INTERFACES UP FRONT SO ABLE TO ACCESS THE 'Active()' MEMBER
			if (!DEV_MODE_SKIP_STARTSCREEN) {
				StartScreen = new cStartScreen;
			} else {
				MainScreen = new cMainScreen;
				MainScreen.SetPositions();
			}
		}

		void LoopHandler() {
			START_SCREEN {
				StartScreen.LoopHandler();
			}

			MAIN_SCREEN {
				MainScreen.LoopHandler();
			}
		}

		void EventHandler(int m_EventType, long m_KeystrokeOrX, double m_Y, string m_ObjectName) {
			START_SCREEN {
				switch((int)m_KeystrokeOrX) {
					case KEY_Q:	delete(StartScreen);
						MainScreen = new cMainScreen;
						MainScreen.SetPositions();
						break;
				}

				StartScreen.EventHandler(id, lparam, dparam, sparam);
			}

			MAIN_SCREEN {
				MainScreen.EventHandler(id, lparam, dparam, sparam);
			}
		}
};
cInterfaces Interfaces;

// class cGodMode {
// 	public:
// 		int				NoOfRows, NoOfColumns, GridSize;
// 		cGridOpaque		*Grid;
// 		cInfoBox		*InfoBoxes[,1000];
		
// 		int h, w, CentreX, CentreY;
		
// 		cGodMode() {
// 			ResetLastError();
// 			LogFuncSig(__FUNCSIG__);

// 			NoOfColumns		= 10;
// 			NoOfRows		= 5;
// 			GridSize		= NoOfColumns * NoOfRows;

// 			Grid = new cGridOpaque(NoOfColumns, NoOfRows);

// 			ArrayResize(InfoBoxes, NoOfColumns);

// 			for (int Column = 0; Column < NoOfColumns; Column++) {
// 				for (int Row = 0; Row < NoOfRows; Row++) {
// 					InfoBoxes[Column,Row] = new cInfoBox("Col"+(string)Column + "_Row"+(string)Row);	// sending suffix to the class
// 				}
// 			}
// 		}

// 		~cGodMode() {
// 			ResetLastError();
// 			LogFuncSig(__FUNCSIG__);

// 			delete(Grid);

// 			for (int Column = 0; Column < NoOfColumns; Column++) {
// 				for (int Row = 0; Row < NoOfRows; Row++) {
// 					delete(InfoBoxes[Column,Row]);
// 				}
// 			}
// 		}

// 		void SetPositions(int m_Height, int m_Width, int m_CentreX, int m_CentreY) {
// 			ResetLastError();
// 			LogFuncSig(__FUNCSIG__);

// 			// GRID
// 			CentreX		= m_CentreX;
// 			CentreY		= m_CentreY;
// 			h			= m_Height;
// 			w			= m_Width;
// 			Grid.SetPositions(h, w, CentreX, CentreY);
			
// 			for (int Column = 0; Column < NoOfColumns; Column++) {
// 				for (int Row = 0; Row < NoOfRows; Row++) {
// 					InfoBoxes[Column,Row].SetPositions(Grid.CellSpecs[Column,Row].Height, Grid.CellSpecs[Column,Row].Width, Grid.CellSpecs[Column,Row].CentreX, Grid.CellSpecs[Column,Row].CentreY);
// 				}
// 			}
// 		}

// 		void EventHandler(int m_EventType, long m_KeystrokeOrX, double m_Y, string m_ObjectName) {
// 			ResetLastError();

// 			switch(m_EventType) {
// 				case CHARTEVENT_MOUSE_MOVE:
// 					for (int Column = 0; Column < NoOfColumns; Column++) {
// 						for (int Row = 0; Row < NoOfRows; Row++) {
// 							InfoBoxes[Column,Row].EventHandler(m_EventType, m_KeystrokeOrX, m_Y, m_ObjectName);
// 						}
// 					}
// 			}
// 		}
// };
