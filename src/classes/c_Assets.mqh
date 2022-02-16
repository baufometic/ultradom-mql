//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			CLOCK
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
#resource 	"\\Assets\\Images\\Clock\\HoursMinutes.bmp";
#resource 	"\\Assets\\Images\\Clock\\Seconds.bmp";
#resource 	"\\Assets\\Images\\Clock\\Dots.bmp";
#resource 	"\\Assets\\Images\\Clock\\Glow.bmp";

class cClock {
	private:
		cImage 	*Dots;
		cImage 	*Hands[4];
		cImage	*Seconds[2];
		cImage 	*Glow[2];
		
		int 	HoursMinutesHeight, HoursMinutesWidth;
        int     SecondsHeight, SecondsWidth;
        int     DotsHeight, DotsWidth;
        int     GlowHeight, GlowWidth;
	
	public:
		sSpecs 	Specs;

		cClock() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			string 	HoursMinutesFileName	= "Clock\\HoursMinutes";
			string 	SecondsFileName     	= "Clock\\Seconds";
			string 	DotsFileName        	= "Clock\\Dots";
			string 	GlowFileName        	= "Clock\\Glow";

			HoursMinutesHeight				= (int)(GetBitmapHeight(HoursMinutesFileName));
			HoursMinutesWidth				= (int)(GetBitmapWidth (HoursMinutesFileName) * 0.1); 	// SHOW ONLY ONE NUMBER OUT OF THE 10 IN THE IMAGE 0:9
			SecondsHeight					= (int)(GetBitmapHeight(SecondsFileName));
			SecondsWidth					= (int)(GetBitmapWidth (SecondsFileName) * 0.1);
            DotsHeight                      = (int)(GetBitmapHeight(DotsFileName));
			DotsWidth						= (int)(GetBitmapWidth (DotsFileName));
			GlowHeight                      = (int)(GetBitmapHeight(GlowFileName));
            GlowWidth						= (int)(GetBitmapWidth (GlowFileName));

			Dots							= new cImage("Clock_Dots", 		DotsFileName);
			Hands   [0] 					= new cImage("Clock_Hands_0", 	HoursMinutesFileName);
			Hands   [1] 					= new cImage("Clock_Hands_1", 	HoursMinutesFileName);
			Hands   [2] 					= new cImage("Clock_Hands_2", 	HoursMinutesFileName);
			Hands   [3] 					= new cImage("Clock_Hands_3", 	HoursMinutesFileName);
			Seconds [0] 					= new cImage("Clock_Seconds_0", SecondsFileName);
			Seconds [1] 					= new cImage("Clock_Seconds_1", SecondsFileName);
			Glow    [0] 					= new cImage("Clock_Glow_0", 	GlowFileName);
			Glow    [1] 					= new cImage("Clock_Glow_1", 	GlowFileName);

			Specs.Height = HoursMinutesHeight;
		}

		~cClock() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			delete(Dots);
			delete(Hands	[0]);
			delete(Hands	[1]);
			delete(Hands	[2]);
			delete(Hands	[3]);
			delete(Seconds	[0]);
			delete(Seconds	[1]);
			delete(Glow		[0]);
			delete(Glow		[1]);
		}

		void SetPositions(int m_CentreX, int m_CentreY) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Specs.CentreX	= m_CentreX;
			Specs.CentreY	= m_CentreY;
			Specs.Height	= HoursMinutesHeight;
            Specs.Width		= (HoursMinutesWidth*4) + DotsWidth + (SecondsWidth*2);
			Specs.Left		= (Specs.CentreX - (int)(Specs.Width * 0.5));
			Specs.Right		= (Specs.Left + Specs.Width);
			Specs.Top		= (Specs.CentreY - (int)(Specs.Height * 0.5));
			Specs.Bottom	= (Specs.Top + Specs.Height);

			for (int i = 0; i < 4; i++) {
				Hands[i].SetHeight	(HoursMinutesHeight);
				Hands[i].SetWidth	(HoursMinutesWidth);
				Hands[i].SetXOffset	(HoursMinutesWidth * i+1);
				Hands[i].SetYOffset	(0);
				Hands[i].SetY		(Specs.CentreY - (int)(HoursMinutesHeight * 0.5));

				switch(i) {
					// HOUR 1
					case 0:	Hands[i].SetX	(Specs.Left);
							break;
					
					// HOUR 2
					case 1:	Hands[i].SetX	(Hands[i-1].Right());
							break;
					
					// MINUTE 1
					case 2:	Hands[i].SetX	(Hands[i-1].Right() + DotsWidth);
							break;
					
					// MINUTE 2
					case 3:	Hands[i].SetX	(Hands[i-1].Right());
							break;
				}
			}

			// DOTS
			Dots.SetX		(Hands[1].Right());
			Dots.SetY		(Specs.CentreY - (int)(HoursMinutesHeight * 0.5) + 8);

			// SECONDS
			for (int i = 0; i < 2; i++) {
				Seconds[i].SetHeight	(SecondsHeight);
				Seconds[i].SetWidth		(SecondsWidth);
				Seconds[i].SetXOffset	(SecondsWidth * i+1);
				Seconds[i].SetYOffset	(0);
				Seconds[i].SetY			(Hands[0].Top());

				switch(i) {
					case 0:   Seconds[i].SetX(Hands[3].Right());	break;
					case 1:   Seconds[i].SetX(Seconds[0].Right());	break;
				}
			}
			
			// MID WAY REFLECTIVE BEZEL			
			Glow[0].SetX(Hands[0].Right() - (int)(GlowWidth * 0.5));
			Glow[0].SetY(Hands[0].CentreY() - 5);

			Glow[1].SetX(Hands[2].Right() - (int)(GlowWidth * 0.5));
			Glow[1].SetY(Hands[0].CentreY() - 5);
			
			UpdateTime();
		}

		void UpdateTime() {
            // STORE TIME
			string    TimeString     = TimeToString(TimeLocal(), TIME_SECONDS);
			int       Hour1          = (int)StringToInteger(StringSubstr(TimeString, 0, 1));
			int       Hour2          = (int)StringToInteger(StringSubstr(TimeString, 1, 1));
			int       Minute1        = (int)StringToInteger(StringSubstr(TimeString, 3, 1));
			int       Minute2        = (int)StringToInteger(StringSubstr(TimeString, 4, 1));
			int       Second1        = (int)StringToInteger(StringSubstr(TimeString, 6, 1));
			int       Second2        = (int)StringToInteger(StringSubstr(TimeString, 7, 1));
			
			// HOURS x MINUTES
			Hands[0].SetXOffset(HoursMinutesWidth * Hour1);
			Hands[1].SetXOffset(HoursMinutesWidth * Hour2);
			Hands[2].SetXOffset(HoursMinutesWidth * Minute1);
			Hands[3].SetXOffset(HoursMinutesWidth * Minute2);
			
			// SECONDS
			Seconds[0].SetXOffset(SecondsWidth * Second1);
			Seconds[1].SetXOffset(SecondsWidth * Second2);
		}
};

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			HUMAN
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
// 100 images 0 through 99
#resource	"\\Assets\\Images\\Human\\0.bmp";
#resource	"\\Assets\\Images\\Human\\1.bmp";
#resource	"\\Assets\\Images\\Human\\2.bmp";
#resource	"\\Assets\\Images\\Human\\3.bmp";
#resource	"\\Assets\\Images\\Human\\4.bmp";
#resource	"\\Assets\\Images\\Human\\5.bmp";
#resource	"\\Assets\\Images\\Human\\6.bmp";
#resource	"\\Assets\\Images\\Human\\7.bmp";
#resource	"\\Assets\\Images\\Human\\8.bmp";
#resource	"\\Assets\\Images\\Human\\9.bmp";
#resource	"\\Assets\\Images\\Human\\10.bmp";
#resource	"\\Assets\\Images\\Human\\11.bmp";
#resource	"\\Assets\\Images\\Human\\12.bmp";
#resource	"\\Assets\\Images\\Human\\13.bmp";
#resource	"\\Assets\\Images\\Human\\14.bmp";
#resource	"\\Assets\\Images\\Human\\15.bmp";
#resource	"\\Assets\\Images\\Human\\16.bmp";
#resource	"\\Assets\\Images\\Human\\17.bmp";
#resource	"\\Assets\\Images\\Human\\18.bmp";
#resource	"\\Assets\\Images\\Human\\19.bmp";
#resource	"\\Assets\\Images\\Human\\20.bmp";
#resource	"\\Assets\\Images\\Human\\21.bmp";
#resource	"\\Assets\\Images\\Human\\22.bmp";
#resource	"\\Assets\\Images\\Human\\23.bmp";
#resource	"\\Assets\\Images\\Human\\24.bmp";
#resource	"\\Assets\\Images\\Human\\25.bmp";
#resource	"\\Assets\\Images\\Human\\26.bmp";
#resource	"\\Assets\\Images\\Human\\27.bmp";
#resource	"\\Assets\\Images\\Human\\28.bmp";
#resource	"\\Assets\\Images\\Human\\29.bmp";
#resource	"\\Assets\\Images\\Human\\30.bmp";
#resource	"\\Assets\\Images\\Human\\31.bmp";
#resource	"\\Assets\\Images\\Human\\32.bmp";
#resource	"\\Assets\\Images\\Human\\33.bmp";
#resource	"\\Assets\\Images\\Human\\34.bmp";
#resource	"\\Assets\\Images\\Human\\35.bmp";
#resource	"\\Assets\\Images\\Human\\36.bmp";
#resource	"\\Assets\\Images\\Human\\37.bmp";
#resource	"\\Assets\\Images\\Human\\38.bmp";
#resource	"\\Assets\\Images\\Human\\39.bmp";
#resource	"\\Assets\\Images\\Human\\40.bmp";
#resource	"\\Assets\\Images\\Human\\41.bmp";
#resource	"\\Assets\\Images\\Human\\42.bmp";
#resource	"\\Assets\\Images\\Human\\43.bmp";
#resource	"\\Assets\\Images\\Human\\44.bmp";
#resource	"\\Assets\\Images\\Human\\45.bmp";
#resource	"\\Assets\\Images\\Human\\46.bmp";
#resource	"\\Assets\\Images\\Human\\47.bmp";
#resource	"\\Assets\\Images\\Human\\48.bmp";
#resource	"\\Assets\\Images\\Human\\49.bmp";
#resource	"\\Assets\\Images\\Human\\50.bmp";
#resource	"\\Assets\\Images\\Human\\51.bmp";
#resource	"\\Assets\\Images\\Human\\52.bmp";
#resource	"\\Assets\\Images\\Human\\53.bmp";
#resource	"\\Assets\\Images\\Human\\54.bmp";
#resource	"\\Assets\\Images\\Human\\55.bmp";
#resource	"\\Assets\\Images\\Human\\56.bmp";
#resource	"\\Assets\\Images\\Human\\57.bmp";
#resource	"\\Assets\\Images\\Human\\58.bmp";
#resource	"\\Assets\\Images\\Human\\59.bmp";
#resource	"\\Assets\\Images\\Human\\60.bmp";
#resource	"\\Assets\\Images\\Human\\61.bmp";
#resource	"\\Assets\\Images\\Human\\62.bmp";
#resource	"\\Assets\\Images\\Human\\63.bmp";
#resource	"\\Assets\\Images\\Human\\64.bmp";
#resource	"\\Assets\\Images\\Human\\65.bmp";
#resource	"\\Assets\\Images\\Human\\66.bmp";
#resource	"\\Assets\\Images\\Human\\67.bmp";
#resource	"\\Assets\\Images\\Human\\68.bmp";
#resource	"\\Assets\\Images\\Human\\69.bmp";
#resource	"\\Assets\\Images\\Human\\70.bmp";
#resource	"\\Assets\\Images\\Human\\71.bmp";
#resource	"\\Assets\\Images\\Human\\72.bmp";
#resource	"\\Assets\\Images\\Human\\73.bmp";
#resource	"\\Assets\\Images\\Human\\74.bmp";
#resource	"\\Assets\\Images\\Human\\75.bmp";
#resource	"\\Assets\\Images\\Human\\76.bmp";
#resource	"\\Assets\\Images\\Human\\77.bmp";
#resource	"\\Assets\\Images\\Human\\78.bmp";
#resource	"\\Assets\\Images\\Human\\79.bmp";
#resource	"\\Assets\\Images\\Human\\80.bmp";
#resource	"\\Assets\\Images\\Human\\81.bmp";
#resource	"\\Assets\\Images\\Human\\82.bmp";
#resource	"\\Assets\\Images\\Human\\83.bmp";
#resource	"\\Assets\\Images\\Human\\84.bmp";
#resource	"\\Assets\\Images\\Human\\85.bmp";
#resource	"\\Assets\\Images\\Human\\86.bmp";
#resource	"\\Assets\\Images\\Human\\87.bmp";
#resource	"\\Assets\\Images\\Human\\88.bmp";
#resource	"\\Assets\\Images\\Human\\89.bmp";
#resource	"\\Assets\\Images\\Human\\90.bmp";
#resource	"\\Assets\\Images\\Human\\91.bmp";
#resource	"\\Assets\\Images\\Human\\92.bmp";
#resource	"\\Assets\\Images\\Human\\93.bmp";
#resource	"\\Assets\\Images\\Human\\94.bmp";
#resource	"\\Assets\\Images\\Human\\95.bmp";
#resource	"\\Assets\\Images\\Human\\96.bmp";
#resource	"\\Assets\\Images\\Human\\97.bmp";
#resource	"\\Assets\\Images\\Human\\98.bmp";
#resource	"\\Assets\\Images\\Human\\99.bmp";

class cHuman {
	private:
		ulong	HumanNextUpdateTime, HumanUpdateFrequencyMS;
		int		ImageArray[], ImageArrayPos, SeriesLength;
		
	public:
		cImage *HumanImage;

		cHuman() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Create();
		}

		~cHuman() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Destroy();
		}

		void Destroy() {
			delete(HumanImage);
		}

		void Create() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			HumanNextUpdateTime			= 0;
			HumanUpdateFrequencyMS		= 50;

			// GENERATE SERIES OF IMAGES, RANDOMLY (PREPOPULATES... MUCH FASTER ON LOOP)
			SeriesLength = 10000;
			ArrayResize(ImageArray, SeriesLength);

			int 	NextRandomIteration	= 0;
			int		NoOfImages			= 99;
			int		ImageNumber			= 0;
			int		ImageDirection		= 1;
			
			for (int i = 0; i < SeriesLength; i++) {
				if (i > NextRandomIteration) {
					ImageNumber 		= Math.RandomBetween(0, (NoOfImages-1));
					ImageDirection		= Math.RandomBetween(-1,1);
					NextRandomIteration	= (i + Math.RandomBetween(100, 300));
				}

				if (ImageNumber == 0) {
					ImageDirection = 1;
				} else if (ImageNumber == (NoOfImages-1)) {
					ImageDirection = -1;
				}

				if (ImageDirection == 1) {
					++ImageNumber;
				} else {
					--ImageNumber;
				}

				ImageArray[i] = ImageNumber;
			}

			ImageArrayPos = 0;
			HumanImage = new cImage("Human", "Human\\0");
		}

		void SetPositions(int m_CentreX, int m_CentreY) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			HumanImage.SetX(m_CentreX - (int)(HumanImage.Width() * 0.5));
			HumanImage.SetY(m_CentreY - (int)(HumanImage.Height() * 0.5));
		}

		void LoopHandler() {
			if (TickCount > HumanNextUpdateTime) {
				if (ImageArrayPos < (SeriesLength-1)) {
					++ImageArrayPos;
				} else {
					ImageArrayPos = 0;
				}

				HumanImage.SetFile("Human\\" + (string)ImageArray[ImageArrayPos]);
				HumanNextUpdateTime = (TickCount + HumanUpdateFrequencyMS);
			}
		}
};

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			INFO BOX
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
class cInfoBox {
	private:
		int			NoOfElements;
		color		ActiveBackgroundColour, InactiveBackgroundColour;
		color 		ActiveBorderColour, InactiveBorderColour;

		cRectangle	*InnerContainers[];
		cLabel		*InnerLabels	[];

		sSpecs		Specs;
		string		NamePrefix, NameSuffix;

	public:
		cRectangle	*OuterContainer;	// needs access to change its shit

		cInfoBox(string m_NameSuffix /*Prevents duplicate chart objects which will replace one another*/) {			// just a name! all positioning done LATER by CALLER!
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			NamePrefix 					= "InfoBox_";
			NameSuffix					= m_NameSuffix;

			NoOfElements				= 5;	// this could be changed to customisable later... that's more complex positioning

			ActiveBackgroundColour		= TronBasestar;
			InactiveBackgroundColour	= TronMeanwhile;
			ActiveBorderColour			= TronOrange;
			InactiveBorderColour 		= TronBasestar;
			
			ArrayResize					(InnerContainers, NoOfElements);
			ArrayResize					(InnerLabels, NoOfElements);

			OuterContainer = new cRectangle(NamePrefix + NameSuffix + "_OuterContainer");

			for (int ElementNo = 0; ElementNo < NoOfElements; ElementNo++) {
				InnerContainers	[ElementNo] = new cRectangle(NamePrefix + NameSuffix + "_InnerContainer_ElementNo" + (string)ElementNo);
				InnerLabels		[ElementNo] = new cLabel	(NamePrefix + NameSuffix + "_InnerLabel_ElementNo" + (string)ElementNo);
			}
		}

		~cInfoBox() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			delete(OuterContainer);

			for (int i = 0; i < NoOfElements; i++) {
				delete(InnerContainers	[i]);
				delete(InnerLabels		[i]);
			}
		}

		void EventHandler(int m_EventType, long m_KeystrokeOrX, double m_Y, string m_ObjectName) {
			ResetLastError();

			switch(m_EventType) {
				case CHARTEVENT_MOUSE_MOVE:
					if (OuterContainer.MouseHasEntered()) {
						OuterContainer.SetBackgroundColour	(ActiveBackgroundColour);
						OuterContainer.SetBorderColour		(ActiveBorderColour);
						
					} else if (OuterContainer.MouseHasExit()) {
						OuterContainer.SetBackgroundColour	(InactiveBackgroundColour);
						OuterContainer.SetBorderColour		(InactiveBorderColour);
					}
			}
		}

		void SetActiveBackgroundColour(color m_Colour) 		{}
		void SetInactiveBackgroundColour(color m_Colour) 	{}
		void SetActiveBorderColour(color m_Colour) 			{}
		void SetInactiveBorderColour(color m_Colour) 		{}

		void SetPositions(int m_Height, int m_Width, int m_CentreX, int m_CentreY) {
			ResetLastError();

			// UPDATE NEW SPECS GIVEN BY CALLER
			Specs.CentreX	= m_CentreX;
			Specs.CentreY	= m_CentreY;
			Specs.Height	= m_Height;
            Specs.Width		= m_Width;
			Specs.Left		= (Specs.CentreX - (int)(Specs.Width * 0.5));
			Specs.Right		= (Specs.Left + Specs.Width);
			Specs.Top		= (Specs.CentreY - (int)(Specs.Height * 0.5));
			Specs.Bottom	= (Specs.Top + Specs.Height);

			// SET POSITION OF OUTER CONTAINER
			OuterContainer.SetHeight			(Specs.Height);
			OuterContainer.SetWidth				(Specs.Width);
			OuterContainer.SetX					(Specs.Left);
			OuterContainer.SetY					(Specs.Top);
			OuterContainer.SetBackgroundColour	(InactiveBackgroundColour);
			OuterContainer.SetBorderColour		(InactiveBorderColour);
			OuterContainer.SetBorderWidth		(1);

			int h, w, x, y;

			for (int ElementNo = 0; ElementNo < NoOfElements; ElementNo++) {
				switch(ElementNo) {	// USE THIS SWITCH TO SET SPECS, THEN APPLY IN BULK AT END OF METHOD
					
					// MKT NAME (GRID POS FOR NOW)
					case 0:		h = (int)(Specs.Height * 0.20);
								w = (int)(Specs.Width  * 0.99);
								x = (int)(Specs.CentreX - (w * 0.5));
								y = (int) Specs.Top;

								InnerContainers	[ElementNo].SetHeight			(h);
								InnerContainers	[ElementNo].SetWidth			(w);
								InnerContainers	[ElementNo].SetX				(x);
								InnerContainers	[ElementNo].SetY				(y);								
								InnerContainers	[ElementNo].SetBackgroundColour	(TronMeanwhile);
								InnerContainers	[ElementNo].SetBorderColour		(TronSweetYellow);
								InnerContainers	[ElementNo].SetBorderWidth		(1);

								InnerLabels		[ElementNo].SetText				(NameSuffix);
								InnerLabels		[ElementNo].SetFont				(OCR);
								InnerLabels		[ElementNo].SetFontColour		(TronWhite);
								InnerLabels		[ElementNo].SetHeightAndWidth	(InnerContainers[ElementNo].Height(), InnerContainers[ElementNo].Width());
								InnerLabels		[ElementNo].Align				(InnerContainers[ElementNo], CENTRE_CENTRE);
								break;

					// SPEED
					case 1:		h = (int)(Specs.Height * 0.20);
								w = (int)(Specs.Width  * 0.40);
								x = (int)(Specs.Right - w - 1);
								y = (int) Specs.Top + (h * ElementNo);

								InnerContainers	[ElementNo].SetHeight			(h);
								InnerContainers	[ElementNo].SetWidth			(w);
								InnerContainers	[ElementNo].SetX				(x);
								InnerContainers	[ElementNo].SetY				(y);
								InnerContainers	[ElementNo].SetBackgroundColour	(TronMeanwhile);
								InnerContainers	[ElementNo].SetBorderColour		(TronBasestar);
								InnerContainers	[ElementNo].SetBorderWidth		(1);

								InnerLabels		[ElementNo].SetText				("SPEED");
								InnerLabels		[ElementNo].SetFont				(OCR);
								InnerLabels		[ElementNo].SetFontColour		(TronWhite);
								InnerLabels		[ElementNo].SetHeightAndWidth	(InnerContainers[ElementNo].Height(), InnerContainers[ElementNo].Width());
								InnerLabels		[ElementNo].Align				(InnerContainers[ElementNo], RIGHT_CENTRE);
								break;

					// PHASE
					case 2:		h = (int)(Specs.Height * 0.20);
								w = (int)(Specs.Width  * 0.40);
								x = (int)(Specs.Right - w - 1);
								y = (int) Specs.Top + (h * ElementNo);
								
								InnerContainers	[ElementNo].SetHeight			(h);
								InnerContainers	[ElementNo].SetWidth			(w);
								InnerContainers	[ElementNo].SetX				(x);
								InnerContainers	[ElementNo].SetY				(y);
								InnerContainers	[ElementNo].SetBackgroundColour	(TronMeanwhile);
								InnerContainers	[ElementNo].SetBorderColour		(TronBasestar);
								InnerContainers	[ElementNo].SetBorderWidth		(1);

								InnerLabels		[ElementNo].SetText				("PHASE");
								InnerLabels		[ElementNo].SetFont				(OCR);
								InnerLabels		[ElementNo].SetFontColour		(TronWhite);
								InnerLabels		[ElementNo].SetHeightAndWidth	(InnerContainers[ElementNo].Height(), InnerContainers[ElementNo].Width());
								InnerLabels		[ElementNo].Align				(InnerContainers[ElementNo], RIGHT_CENTRE);
								break;

					// LIQUIDITY
					case 3:		h = (int)(Specs.Height * 0.20);
								w = (int)(Specs.Width  * 0.40);
								x = (int)(Specs.Right - w - 1);
								y = (int) Specs.Top + (h * ElementNo);

								InnerContainers	[ElementNo].SetHeight			(h);
								InnerContainers	[ElementNo].SetWidth			(w);
								InnerContainers	[ElementNo].SetX				(x);
								InnerContainers	[ElementNo].SetY				(y);
								InnerContainers	[ElementNo].SetBackgroundColour	(TronMeanwhile);
								InnerContainers	[ElementNo].SetBorderColour		(TronBasestar);
								InnerContainers	[ElementNo].SetBorderWidth		(1);

								InnerLabels		[ElementNo].SetText				("LIQ");
								InnerLabels		[ElementNo].SetFont				(OCR);
								InnerLabels		[ElementNo].SetFontColour		(TronWhite);
								InnerLabels		[ElementNo].SetHeightAndWidth	(InnerContainers[ElementNo].Height(), InnerContainers[ElementNo].Width());
								InnerLabels		[ElementNo].Align				(InnerContainers[ElementNo], RIGHT_CENTRE);
								break;

					// SPREAD
					case 4:		h = (int)(Specs.Height * 0.20);
								w = (int)(Specs.Width  * 0.40);
								x = (int)(Specs.Right - w - 1);
								y = (int) Specs.Top + (h * ElementNo);

								InnerContainers	[ElementNo].SetHeight			(h);
								InnerContainers	[ElementNo].SetWidth			(w);
								InnerContainers	[ElementNo].SetX				(x);
								InnerContainers	[ElementNo].SetY				(y);
								InnerContainers	[ElementNo].SetBackgroundColour	(TronMeanwhile);
								InnerContainers	[ElementNo].SetBorderColour		(TronBasestar);
								InnerContainers	[ElementNo].SetBorderWidth		(1);

								InnerLabels		[ElementNo].SetText				("SPREAD");
								InnerLabels		[ElementNo].SetFont				(OCR);
								InnerLabels		[ElementNo].SetFontColour		(TronWhite);
								InnerLabels		[ElementNo].SetHeightAndWidth	(InnerContainers[ElementNo].Height(), InnerContainers[ElementNo].Width());
								InnerLabels		[ElementNo].Align				(InnerContainers[ElementNo], RIGHT_CENTRE);
								break;
				}
			}
		}
};

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			SPLASH LOGO
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
#resource 	"\\Assets\\Images\\Logo1_Large.bmp";

class cSplashLogo {
	private:
		cImage 		*IntroLogo;
		cRectangle 	*LeftPlate;
		cRectangle 	*RightPlate;

	public:
		cSplashLogo() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Create();
		}

		~cSplashLogo() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			delete(IntroLogo);
			delete(LeftPlate);
			delete(RightPlate);
		}

		void Create() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			//_____ CREATE LOGO _____
			IntroLogo = new cImage("Intro_Logo", "Logo1_Large");	// all images are created out of sight initially
			
			//_____ CREATE SURROUNDING PLATES FOR SLIDE IN LOGO EFFECT _____
			int PlateWidth 	= (int)(Screen.Dimensions.Width * 0.5);
			int PlateHeight	= Screen.Dimensions.Height;
			
			// LEFT
			int InitialLeftPlatePosition = Screen.Dimensions.Left;
			LeftPlate = new cRectangle		("Left_Plate");
			LeftPlate.SetX					(Screen.Dimensions.Left);
			LeftPlate.SetY					(Screen.Dimensions.Top);
			LeftPlate.SetHeight				(PlateHeight);
			LeftPlate.SetWidth				(PlateWidth);
			LeftPlate.SetBackgroundColour	(clrBlack);
			
			// RIGHT
			int InitialRightPlatePosition = Screen.Dimensions.CentreX;
			RightPlate = new cRectangle		("Right_Plate");
			RightPlate.SetX					(Screen.Dimensions.CentreX);
			RightPlate.SetY					(Screen.Dimensions.Top);
			RightPlate.SetHeight			(PlateHeight);
			RightPlate.SetWidth				(PlateWidth);
			RightPlate.SetBackgroundColour	(clrBlack);
			
			// MOVE LOGO INTO VIEW
			IntroLogo.SetX(Screen.Dimensions.CentreX - (int)(IntroLogo.Width() * 0.5));
			IntroLogo.SetY(Screen.Dimensions.CentreY - (int)(IntroLogo.Height() * 0.5));
			ChartRedraw	(myChartID);
			
			// SLIDE OUT PLATES
			ulong     RoutineStartTimeMS            = GetTickCount();
			ulong     DesiredAnimationDuration      = 1100; // ms
			int       TotalDistanceToCover          = PlateWidth;
			double    PixelsToMovePerMillisecond    = ((1.0*TotalDistanceToCover) / (1.0*DesiredAnimationDuration));
			bool      RoutineComplete               = false;
				
			while (!RoutineComplete && !IsStopped()) {
				ulong	MillisecondsElapsed = (GetTickCount() - RoutineStartTimeMS);
				double 	DistanceToMove      = (MillisecondsElapsed * PixelsToMovePerMillisecond);

				LeftPlate.SetX	(InitialLeftPlatePosition -  (int)(DistanceToMove * 1));	// MOVE LEFT
				RightPlate.SetX	(InitialRightPlatePosition - (int)(DistanceToMove * -1));	// MOVE RIGHT
				
				ChartRedraw(myChartID);
				
				if (MillisecondsElapsed >= DesiredAnimationDuration) {
					RoutineComplete = true;
				}
			}

			Terminal.Sleep(800);
		}
};