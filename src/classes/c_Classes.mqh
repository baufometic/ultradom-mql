
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			VARIABLES
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
string		EurostileRegular	= "Eurostile URW";
string 		OCR				= "OCR A Extended";
string 		Verdana			= "Verdana";

ulong		TickCount			= 0;
ulong		TickCount_Prev		= 0;


//____________________ STRUCTURES ____________________
struct sSpecs {
	int Height, Width, Top, Bottom, Left, Right, CentreX, CentreY, XPadding, YPadding;

	sSpecs() {
		Height 		= -1;
		Width 		= -1;
		Top			= -1;
		Bottom		= -1;
		Left		= -1;
		Right		= -1;
		CentreX		= -1;
		CentreY		= -1;
		XPadding	= -1;
		YPadding	= -1;
	}
};

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			FILES
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
class cTimer {
	private:
		// TIMED IN MICROSECONDS (uSec)
		ulong	LAP_TIMES		[1000];
		string	LAP_NOTES		[1000];
		int		Laps;
		ulong	CurrentTime, PreviousTime;
	
	public:
		cTimer() {
			LogFuncSig(__FUNCSIG__);
			Reset();
		}
		~cTimer() {
			LogFuncSig(__FUNCSIG__);
		}

		void Reset() {
			Laps			= 0;
			CurrentTime		= 0;
			PreviousTime	= 0;

			for (int i = 0; i < 1000; i++) {
				LAP_TIMES[i] = 0;
				LAP_NOTES[i] = "";
			}
		}

		// NET CONNECTION CONST SPLASH
		//while (!IsStopped() && !InternetIsConnected()) {

			// THROW A SPLASH SCREEN AT TOP OF SCREEN WHICH WON'T LEAVE -
			// WARN USER THAT TRADING IS DISABLED AND PERFORMANCE NON-
			// OPTIMAL....



			
		//}

		void Start() {
			Reset();
			CurrentTime = GetMicrosecondCount();
		}
		
		void Split(string WhereAmI = " ") {
			PreviousTime = CurrentTime;
			CurrentTime = GetMicrosecondCount();
			LAP_TIMES[Laps] = (CurrentTime - PreviousTime);
			LAP_NOTES[Laps] = WhereAmI;
			++Laps;
		}
		
		void Stop() {
			Split("STOPPED");

			for (int i = 0; i < Laps; i++) {
				Log("TIMER:                     LAP " + (string)i + " | " +
												(string)LAP_TIMES[i] + " µs | " +
												LAP_NOTES[i]);
			}

			Reset();
		}
};
cTimer Timer;


//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			SYSTEM FUNCTIONS
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
class cArray {
	public:
		cArray() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}
		
		~cArray() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}
		
		bool ElementExists(int &ArrayToSearch[], int ElementToFind) {
			for (int i = 0; i < ArraySize(ArrayToSearch); i++) {
				if (ArrayToSearch[i] == ElementToFind) {
					return(true);
				}
			}
			return(false);
		}

		bool ElementExists(string &ArrayToSearch[], string ElementToFind) {
			for (int i = 0; i < ArraySize(ArrayToSearch); i++) {
				if (ArrayToSearch[i] == ElementToFind) {
					return(true);
				}
			}
			return(false);
		}

		void SortAlphabetically(string &PassedArray[]) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			Timer.Start();
			
			// SIZE OF ORIGINAL ARRAY TO SORT
			int		OriginalArraySize		= ArraySize(PassedArray);
			
			// ARRAY TO HOLD ORGANISED STRINGS
			string	OrganisedStringsArray[];
			ArrayResize(OrganisedStringsArray, OriginalArraySize);
			
			// COUNTERS
			int	NoOfOrganisedStrings	= 0;
			int	IndexBeingTested 		= 0;
			E
			while ((NoOfOrganisedStrings != OriginalArraySize) && !IsStopped()) {
				
				//__________ TEST SOURCE __________
				Log("STRINGS ORGANISED:  " + 	  (string)NoOfOrganisedStrings);
				
				string StringToTest = PassedArray[IndexBeingTested];
						
				if (Array.ElementExists(OrganisedStringsArray, StringToTest)) {
					++IndexBeingTested;
					continue;
				}
				
				Log("TESTING STRING:  " + StringToTest);
				
				if (NoOfOrganisedStrings == (OriginalArraySize - 1)) {
					OrganisedStringsArray[NoOfOrganisedStrings] = StringToTest;
					break;
				}
				
				//__________ TEST AGAINST __________
				string CurrentWinnerString = StringToTest;
				
				for (int ComparisonIndex = 0; ComparisonIndex < OriginalArraySize; ComparisonIndex++) {
					string StringToCompareAgainst = PassedArray[ComparisonIndex];
					
					if (  Array.ElementExists(OrganisedStringsArray, StringToCompareAgainst) || (CurrentWinnerString == StringToCompareAgainst)  ) {
						continue;
					}
					
					int Diff = StringCompare(CurrentWinnerString, StringToCompareAgainst, true);
					
					Log(CurrentWinnerString + " vs " + StringToCompareAgainst + " | " + (string)Diff);
					
					if (Diff == 1) {
						CurrentWinnerString = StringToCompareAgainst;
						Log("BEST YET: " + CurrentWinnerString);
					}
				}
				
				OrganisedStringsArray[NoOfOrganisedStrings] = CurrentWinnerString;
				++NoOfOrganisedStrings;
				
				Log("WINNING STRING " + CurrentWinnerString);
			}

			for (int i = 0; i < OriginalArraySize; i++) {
				PassedArray[i] = OrganisedStringsArray[i];
			}

			Timer.Stop();
		}
};
cArray Array;

class cMath {
	public:
		cMath() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			MathSrand((int)GetMicrosecondCount());
		}

		~cMath() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}
		
		int RandomBetween(int Min, int Max) {
			if (Min >= Max) {
				Log("ONE OF THE CALLERS FOR RANDOM NUMBER IS OLD, MIN AND MAX WRONG WAY AROUND");
				Terminal.TriggerKillSwitch("RANDOM NUMBER GEN FAILED");
			}
			return (Min + (Max - Min + 1) * MathRand() / 32768);
		}

		int RodinReduction(ulong Number) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			string    NumberStr				= IntegerToString(Number);
			bool      CompletedReduction 	= false;
			int       NumberSum           	= 0;
			int       NumberStrLen        	= StringLen(NumberStr);

			while ((!CompletedReduction) && (!IsStopped())) {
				NumberSum = 0;

				for (int i = 0; i < NumberStrLen; i++) {
					NumberSum += (int)StringToInteger(StringSubstr(NumberStr, i, 1));
				}

				NumberStrLen = StringLen(IntegerToString(NumberSum));

				if (NumberStrLen == 1) {
					CompletedReduction = true;
				} else {
					NumberStr = IntegerToString(NumberSum);
				}     
			}
			Log("TEST RODIN REDUCTION: " + (string)NumberSum);
			return(NumberSum);
		}
};
cMath Math;

class cString {
	private:
		string Alphabet, AlphaNumeric;

	public:
		cString() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Alphabet		= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			AlphaNumeric 	= "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		}
		
		~cString() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		string RandomLetter() {
			ResetLastError();
			
			return(StringSubstr(Alphabet, Math.RandomBetween(0,25), 1));
		}

		string UnreadableString(string StringToHide) {	// SUPPORTS STRINGS UP TO 30 CHARS LONG
			ResetLastError();
			
			return(StringSubstr("******************************", 0, StringLen(StringToHide)));
		}

		string Uppercase(string myString) {
			ResetLastError();
						
			StringToUpper(myString);
			return(myString);
		}

		string AddCommasToInteger(long Number) {
			ResetLastError();

			string   myString	= IntegerToString(Number);
			int      myLength 	= StringLen(myString);
			string   Formatted 	= "";
			
			while ((myLength > 3) && !IsStopped()) {
				Formatted = "'" + StringSubstr(myString, (myLength - 3), 3) + Formatted;
				myLength = (myLength - 3);
			}
			return(StringSubstr(myString, 0, myLength) + Formatted);
		}
};
cString String;

class cTimeAndDate {
	public:
		
		
		string MonthIntToString(int myMonth) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			if ((myMonth < 1) || (myMonth > 12)) {
				Log("PASSED AN INVALID MONTH");
				return("");
			}

			switch(myMonth) {
				case 1:  return("JAN"); break;
				case 2:  return("FEB"); break;
				case 3:  return("MAR"); break;
				case 4:  return("APR"); break;
				case 5:  return("MAY"); break;
				case 6:  return("JUN"); break;
				case 7:  return("JUL"); break;
				case 8:  return("AUG"); break;
				case 9:  return("SEP"); break;
				case 10: return("OCT"); break;
				case 11: return("NOV"); break;
				case 12: return("DEC"); break;
			}

			return("");
		}

		// needs the extra zero too
		string DateString() {	// APPEARS LIKE 28-11-1991
			ResetLastError();
			//LogFuncSig(__FUNCSIG__);		// DO NOT ENABLE THIS ! CAUSES STACK OVERFLOW BY ENDLESS CALLBACK BY LOGGING

			MqlDateTime dt;
			TimeToStruct(TimeLocal(), dt);

			return(	(dt.day <= 9? "0" : "")  + (string)dt.day + "-" +
					(dt.mon <= 9? "0" : "")  + (string)dt.mon + "-" +
					(dt.year <= 9? "0" : "") + (string)dt.year );
		}

		string TimeString() {
			ResetLastError();
			//LogFuncSig(__FUNCSIG__);	// DO NOT ENABLE THIS ! CAUSES STACK OVERFLOW BY ENDLESS CALLBACK BY LOGGING

			MqlDateTime tm;
			TimeToStruct(TimeLocal(), tm);

			
		}
};
cTimeAndDate Time;

class cColour {
	public:
		cColour() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}
		~cColour() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		color Random() {
			return(StringToColor("C'" + (string)Math.RandomBetween(0,255) + "," + (string)Math.RandomBetween(0,255) + "," + (string)Math.RandomBetween(0,255) + "'"));
		}

		void CreateFadeOutArray(color m_StartingColour, int m_Steps, color &ColourArray[]) {
			// SPLIT COLOURS
			ushort 	u_sep     	= StringGetCharacter(",", 0);
			string	ColourSplit	[];
			int 	k			= StringSplit(ColorToString(m_StartingColour), u_sep, ColourSplit);	// fades to zero
			
			// CALCULATE FADE RATE AND COLOURS
			double 	R_Start		= StringToDouble(ColourSplit[0]);
			double 	G_Start 	= StringToDouble(ColourSplit[1]);
			double 	B_Start 	= StringToDouble(ColourSplit[2]);
			
			double 	R_Step  	= (R_Start / m_Steps);
			double 	G_Step  	= (G_Start / m_Steps);
			double 	B_Step  	= (B_Start / m_Steps);
			
			ArrayResize(ColourArray, m_Steps+1);
			
			string	str = "";
			int j = 0;
			for (int i = m_Steps; i >= 0; i--) {
				StringConcatenate(str, 	DoubleToString(R_Start - (R_Step * j), 0), ",",
										DoubleToString(G_Start - (G_Step * j), 0), ",",
										DoubleToString(B_Start - (B_Step * j), 0));

				j++;
									
				ColourArray[i] = StringToColor(str);
			}
		}
};
cColour Colour;

class cSound {
	private:
		string 	SoundsPrefix, SoundsSuffix;
		bool	SoundsEnabled;
	
	public:
		cSound() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			ToggleSounds		(true);
		}
		~cSound() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			ToggleSounds		(false);
		}
		
		void Play(string SoundToPlay) {
			ResetLastError();

			string FilePath = EMBED_SOUND_PATH + SoundToPlay + ".wav";
			
			if (!SoundsEnabled) {
				Log("PLAY SOUND:                  SOUNDS DISABLED");
				return;
			} else if (!PlaySound(FilePath)) {
				Log("PLAY SOUND:                  FAILED | " + FilePath);	// if error 4511, check the subfolder of particular sound is correct
			} else {
				Log("PLAY SOUND:                  SUCCESS | " + FilePath);
			}
		}
		
		void ToggleSounds(bool EnabledDisabled) {
			ResetLastError();
			SoundsEnabled = EnabledDisabled;
			Log("SOUNDS:                      " + (string)SoundsEnabled);
		}
};
cSound Sound;

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			OBJECTS
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
// m_vars are member (internal) e_vars are external and passed in by functions, EA etc.
class cMyObject {
	protected:
		bool Exists() {
			return(ObjectFind(myChartID, Name) != -1);
		}

	private:
		bool HasMouseFocusAlready;

		bool MouseHasFocus() {
			return( Mouse.Pos.X > Left() &&
					Mouse.Pos.X < Right() &&
					Mouse.Pos.Y > Top() &&
					Mouse.Pos.Y < Bottom() );
		}

	public:
		string	Name, ShadowName;
		int		Type;
		
		cMyObject() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		~cMyObject() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			ObjectDelete(myChartID, Name);
			ObjectDelete(myChartID, ShadowName);
		}

		bool Create(string m_Name, int m_Type) {
			Name		= m_Name;
			ShadowName 	= m_Name + "_Shadow";
			Type		= m_Type;

			//---------- LABEL ----------
			if (Type == OBJ_LABEL) {
				// CREATE BACKGROUND LABEL [OUT OF SIGHT] - 'Shadow'
				if (!ObjectCreate(myChartID, ShadowName, OBJ_LABEL, 0, 0, 0)) {
					Log("UNABLE TO CREATE SHADOW LABEL: " + Name);
					return(false);
				}
				ObjectSetInteger(myChartID, ShadowName, OBJPROP_XDISTANCE, -1000);

				// CREATE FOREGROUND LABEL
				if (!ObjectCreate(myChartID, Name, OBJ_LABEL, 0, 0, 0)) {
					Log("UNABLE TO CREATE FOREGROUND LABEL: " + Name);
					return(false);
				}

			//---------- RECTANGLE ----------
			} else if (Type == OBJ_RECTANGLE_LABEL) {
				if (!ObjectCreate(myChartID, Name, OBJ_RECTANGLE_LABEL, 0, 0, 0)) {
					Log("UNABLE TO CREATE RECTANGLE: " + Name);
					return(false);
				}
			
			//---------- BITMAP ----------
			} else if (Type == OBJ_BITMAP_LABEL) {
				if (!ObjectCreate(myChartID, Name, OBJ_BITMAP_LABEL, 0, 0, 0)) {
					Log("UNABLE TO CREATE IMAGE: " + Name);
					return(false);
				}
			}

			SetOrder		(0);
			SetHidden		(true);
			SetBack			(true);
			SetSelectable	(false);
			SetSelected		(false);
			SetCorner		(CORNER_LEFT_UPPER);
			SetAnchor		(ANCHOR_LEFT_UPPER);

			return(true);
		}

		// __________________________ MOUSE ACTIONS _______________________________
		bool MouseHasEntered() {
			if (!HasMouseFocusAlready && MouseHasFocus()) {
				HasMouseFocusAlready = true;
				//Print(GetPointer(this).Name + " HAS FOCUS");
				return(true);
			} else {
				return(false);
			}
		}

		bool MouseHasExit() {
			if (HasMouseFocusAlready && !MouseHasFocus()) {
				HasMouseFocusAlready = false;
				//Print(GetPointer(this).Name + " LOST FOCUS");
				return(true);
			} else {
				return(false);
			}
		}

		// __________________________ USABILIITY _______________________________
		// ORDER
		bool SetOrder(long m_Order) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_ZORDER, m_Order)) {
				Log("UNABLE TO SET Z ORDER: " + Name);
				return(false);
			}
			return(true);
		}

		long Order() {
			ResetLastError();
			return(ObjectGetInteger(myChartID, Name, OBJPROP_ZORDER, 0));
		}

		// HIDDEN
		bool SetHidden(bool m_Hidden) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_HIDDEN, m_Hidden)) {
				Log("UNABLE TO SET TO HIDDEN: " + Name);
				return(false);
			}
			return(true);
		}

		bool Hidden() {
			ResetLastError();
			return(ObjectGetInteger(myChartID, Name, OBJPROP_HIDDEN, 0));
		}

		// BACK
		bool SetBack(bool m_AtBack) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_BACK, m_AtBack)) {
				Log("UNABLE TO SET TO BACK: " + Name);
				return(false);
			}
			return(true);
		}

		bool Back() {
			ResetLastError();
			return(ObjectGetInteger(myChartID, Name, OBJPROP_BACK, 0));
		}

		// SELECTABLE
		bool SetSelectable(bool m_Selectable) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_SELECTABLE, m_Selectable)) {
				Log("UNABLE TO SET AS SELECTABLE: " + Name);
				return(false);
			}
			return(true);
		}

		bool Selectable() {
			ResetLastError();
			return(ObjectGetInteger(myChartID, Name, OBJPROP_SELECTABLE, 0));
		}

		// SELECTED
		bool SetSelected(bool m_Selected) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_SELECTED, m_Selected)) {
				Log("UNABLE TO SET AS SELECTED: " + Name);
				return(false);
			}
			return(true);
		}

		bool Selected() {
			ResetLastError();
			return(ObjectGetInteger(myChartID, Name, OBJPROP_SELECTED, 0));
		}

		// CORNER
		bool SetCorner(int m_Corner) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_CORNER, m_Corner)) {
				Log("UNABLE TO SET CORNER: " + Name);
				return(false);
			}
			return(true);
		}

		int Corner() {
			ResetLastError();
			return((int)ObjectGetInteger(myChartID, Name, OBJPROP_CORNER, 0));
		}

		// ANCHOR
		bool SetAnchor(int m_Anchor) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_ANCHOR, m_Anchor)) {
				Log("UNABLE TO SET ANCHOR: " + Name);
				return(false);
			}
			return(true);
		}

		int Anchor() {
			ResetLastError();
			return((int)ObjectGetInteger(myChartID, Name, OBJPROP_ANCHOR, 0));
		}

		//____________________ SIZING ____________________
		// HEIGHT
		virtual bool SetHeight(int m_Height) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_YSIZE, m_Height)) {
				Log("UNABLE TO SET HEIGHT: " + Name);
				return(false);
			}
			return(true);
		}

		virtual int Height() {
			ResetLastError();
			return((int)ObjectGetInteger(myChartID, Name, OBJPROP_YSIZE, 0));
		}

		// WIDTH
		virtual bool SetWidth(int m_Width) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_XSIZE, m_Width)) {
				Log("UNABLE TO SET WIDTH: " + Name);
				return(false);
			}
			return(true);
		}

		virtual int Width() {
			ResetLastError();
			return((int)ObjectGetInteger(myChartID, Name, OBJPROP_XSIZE, 0));
		}
		
		//____________________ POSITIONING ____________________
		// X
		virtual bool SetX(int m_XPos) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_XDISTANCE, m_XPos)) {
				Log("UNABLE TO SET X DIST: " + Name);
				return(false);
			}
			return(true);
		}

		// Y
		virtual bool SetY(int m_YPos) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_YDISTANCE, m_YPos)) {
				Log("UNABLE TO SET Y DIST: " + Name);
				return(false);
			}
			return(true);
		}

		int Top() {
			ResetLastError();
			return((int)ObjectGetInteger(myChartID, Name, OBJPROP_YDISTANCE, 0));
		}
		
		int Bottom() {
			ResetLastError();
			return(Top() + Height());
		}

		int Left() {
			ResetLastError();
			return((int)ObjectGetInteger(myChartID, Name, OBJPROP_XDISTANCE, 0));
		}

		int Right() {
			ResetLastError();
			return(Left() + Width());
		}

		int CentreX() {
			ResetLastError();
			return((int)(Left() + (Width() * 0.5)));
		}

		int CentreY() {
			ResetLastError();
			return((int)(Top() + (Height() * 0.5)));
		}

		/* void Hide() {
			if (!HiddenFromUser) {
				PreviousCoords[0] = (int)ObjectGetInteger(myChartID, Name, OBJPROP_XDISTANCE, 0);	// X
				PreviousCoords[1] = (int)ObjectGetInteger(myChartID, Name, OBJPROP_YDISTANCE, 0);	// Y
				ObjectSetInteger(myChartID, Name, OBJPROP_XDISTANCE, -2000);
				ObjectSetInteger(myChartID, Name, OBJPROP_YDISTANCE, -2000);
				HiddenFromUser = true;
			}
		} */

		/* void Show() {
			if (HiddenFromUser) {
				ObjectSetInteger(myChartID, Name, OBJPROP_XDISTANCE, PreviousCoords[0]);
				ObjectSetInteger(myChartID, Name, OBJPROP_YDISTANCE, PreviousCoords[1]);
				HiddenFromUser = false;
			}
		} */
};

class cRectangle : public cMyObject {
	protected:
		color	BackgroundColour, BorderColour;
		int		BorderType, BorderStyle, BorderWidth;

	public:
		cRectangle(string m_ShapeName) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Create				(m_ShapeName, OBJ_RECTANGLE_LABEL);
			SetX				(-1000);
			SetY				(-1000);
			SetHeight			(1);
			SetWidth			(1);
			SetBackgroundColour	(clrBlack);
			SetBorderColour		(clrBlack);
			SetBorderType		(BORDER_FLAT);
			SetBorderStyle		(STYLE_SOLID);
			SetBorderWidth		(0);
		}

		~cRectangle() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		//____________________ THEMING ____________________
		bool SetBackgroundColour(color m_BackgroundColour) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_BGCOLOR, m_BackgroundColour)) {
				Log("UNABLE TO SET BACKGROUND COLOUR: " + Name);
				return(false);
			}
			return(true);
		}

		bool SetBorderColour(color m_BorderColour) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_COLOR, m_BorderColour)) {
				Log("UNABLE TO SET BORDER COLOUR: " + Name);
				return(false);
			}
			return(true);
		}

		bool SetBorderType(int m_BorderType) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_BORDER_TYPE, m_BorderType)) {
				Log("UNABLE TO SET BORDER TYPE: " + Name);
				return(false);
			}
			return(true);
		}
		
		bool SetBorderStyle(int m_BorderStyle) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_STYLE, m_BorderStyle)) {
				Log("UNABLE TO SET BORDER STYLE: " + Name);
				return(false);
			}
			return(true);
		}

		bool SetBorderWidth(int m_BorderWidth) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_WIDTH, m_BorderWidth)) {
				Log("UNABLE TO SET BORDER WIDTH: " + Name);
				return(false);
			}
			return(true);
		}
};

class cLabel : public cMyObject {
	protected:
		bool	ShadowIsActive;
		
	public:
		cLabel(string m_ShapeName) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Create			(m_ShapeName, OBJ_LABEL);
			SetX			(-1000);
			SetY			(-1000);
			ToggleShadow	(false, clrBlack);
			SetText			("");
			SetTextAngle	(0.00);
			SetFont			("Arial");
			SetFontSize		(-10);
			SetFontColour	(clrBlack);	
		}

		~cLabel() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		//________________________________________ SHADOW LABEL ________________________________________
		void ToggleShadow(bool m_Shadow, color m_FontColour_Shadow) {
			ResetLastError();

			ShadowIsActive = m_Shadow;
			
			if (ShadowIsActive)	{
				SetShadow();
				SetFontColour_Shadow(m_FontColour_Shadow);
			} else {
				HideShadow();
			}
		}

		void HideShadow() {
			ResetLastError();
			ObjectSetString(myChartID, ShadowName, OBJPROP_TEXT, "");
		}
		
		void SetShadowFast() {	// just pos and text
			if (!ShadowIsActive) return;
			ObjectSetString	(myChartID, ShadowName, OBJPROP_TEXT, 			Text());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_XDISTANCE, 		Left() + 3);
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_YDISTANCE, 		Top() + 2);
		}

 		void SetShadow() {
			if (!ShadowIsActive) return;
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_ZORDER, 		Order());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_HIDDEN, 		Hidden());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_BACK, 			Back());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_SELECTABLE, 		Selectable());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_SELECTED,		Selected());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_CORNER, 		Corner());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_ANCHOR, 		Anchor());
			ObjectSetString	(myChartID, ShadowName, OBJPROP_TEXT, 			Text());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_XDISTANCE, 		Left() + 3);
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_YDISTANCE, 		Top() + 2);
			ObjectSetString	(myChartID, ShadowName, OBJPROP_FONT, 			Font());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_FONTSIZE, 		FontSize());
			ObjectSetInteger	(myChartID, ShadowName, OBJPROP_COLOR, 			clrBlack);
		}

		bool SetFontColour_Shadow(color m_FontColour_Shadow) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, ShadowName, OBJPROP_COLOR, m_FontColour_Shadow)) {
				Log("UNABLE TO SET SHADOW FONT COLOUR: " + ShadowName);
				return(false);
			}
			return(true);
		}

		//____________________ CONTENTS ____________________
		// TEXT
		bool SetText(string m_Text) {
			ResetLastError();
			if (!ObjectSetString(myChartID, Name, OBJPROP_TEXT, m_Text)) {
				Log("UNABLE TO SET TEXT: " + Name);
				return(false);
			}
			SetShadowFast();
			return(true);
     	}

		string Text() {
			ResetLastError();
			return(ObjectGetString(myChartID, Name, OBJPROP_TEXT));
		}
		
		// FONT
		bool SetFont(string m_Font) {
			ResetLastError();
			if (!ObjectSetString(myChartID, Name, OBJPROP_FONT, m_Font)) {
				Log("UNABLE TO SET FONT: " + Name);
				return(false);
			}
			SetShadow();
			return(true);
		}

		string Font() {
			ResetLastError();
			return(ObjectGetString(myChartID, Name, OBJPROP_FONT, 0));
		}

		// FONT SIZE
		bool SetFontSize(int m_FontSize) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_FONTSIZE, m_FontSize)) {
				Log("UNABLE TO SET FONT SIZE: " + Name);
				return(false);
			}
			SetShadow();
			return(true);
		}

		int FontSize() {
			ResetLastError();
			return(int)(ObjectGetInteger(myChartID, Name, OBJPROP_FONTSIZE));
		}
		
		// ANGLE
		bool SetTextAngle(double m_TextAngle) {
			ResetLastError();
			if (!ObjectSetDouble(myChartID, Name, OBJPROP_ANGLE, m_TextAngle)) {
				Log("UNABLE TO SET TEXT ANGLE: " + Name);
				return(false);
			}
			SetShadow();
			return(true);
		}

		double TextAngle() {
			ResetLastError();
			return(ObjectGetDouble(myChartID, Name, OBJPROP_ANGLE, 0));
		}

		// FONT COLOUR
		bool SetFontColour(color m_FontColour) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_COLOR, m_FontColour)) {
				Log("UNABLE TO SET FONT COLOUR: " + Name);
				return(false);
			}
			return(true);
		}

		color FontColour() {
			ResetLastError();
			return((color)ObjectGetInteger(myChartID, Name, OBJPROP_COLOR, 0));
		}

		//____________________ POSITIONING ____________________
		void Align(cRectangle &Rect, int Alignment) {
			ResetLastError();

			switch(Alignment) {
				// FIRST SET X
				// THEN SET Y
				case 	LEFT_TOP:			SetX(Rect.Left());
										SetY(Rect.Top());
										break;

				case 	LEFT_CENTRE:		SetX(Rect.Left());
										SetY(Rect.CentreY() - (int)(Height() * 0.5));
										break;
				
				case 	LEFT_BOTTOM:		SetX(Rect.Left());
										SetY(Rect.Bottom() - Height());
										break;
				
				case		CENTRE_TOP:		SetX(Rect.CentreX() - (int)(Width() * 0.5));
										SetY(Rect.Top());
										break;
				
				case		CENTRE_CENTRE:		SetX(Rect.CentreX() - (int)(Width() * 0.5));
										SetY(Rect.CentreY() - (int)(Height() * 0.5));
										break;

				case		CENTRE_BOTTOM:		SetX(Rect.CentreX() - (int)(Width() * 0.5));
										SetY(Rect.Bottom() - Height());
										break;

				case		RIGHT_TOP:		SetX(Rect.Right() - Width());
										SetY(Rect.Top());
										break;
				
				case		RIGHT_CENTRE:		SetX(Rect.Right() - Width());
										SetY(Rect.CentreY() - (int)(Height() * 0.5));
										break;
				
				case		RIGHT_BOTTOM:		SetX(Rect.Right() - Width());
										SetY(Rect.Bottom() - Height());
										break;
			}
		}

		// X POS
		virtual bool SetX(int m_XPos) override {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_XDISTANCE, m_XPos)) {
				Log("UNABLE TO SET X DIST: " + Name);
				return(false);

				// boom

			}

			SetShadowFast();
			return(true);
		}

		// Y POS
		virtual bool SetY(int m_YPos) override {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_YDISTANCE, m_YPos)) {
				Log("UNABLE TO SET Y DIST: " + Name);
				return(false);
			}

			SetShadowFast();
			return(true);
		}

		//____________________ DIMENSIONS ____________________
		bool SetHeightAndWidth(int m_Height, int m_Width) {
			ResetLastError();

			int 	i_FontSize = 1, i_Height = 0, i_Width = 0;
			string 	i_Font = Font(), i_Text = Text();

			TextSetFont	(i_Font, -(int)(i_FontSize * 10));
			TextGetSize	(i_Text, i_Width, i_Height);

			while ((i_Height < m_Height) && (i_Width < m_Width) && !IsStopped()) {
				++i_FontSize;
				TextSetFont(i_Font, -(int)(i_FontSize * 10));
				TextGetSize(i_Text, i_Width, i_Height);
			}

			if ((i_Height >= m_Height) || (i_Width >= m_Width)) {
				--i_FontSize;
				TextSetFont(i_Font, -(int)(i_FontSize * 10));
				TextGetSize(i_Text, i_Width, i_Height);
			}

			SetFontSize(i_FontSize);
			SetShadow();
			return(true);
		}

		// HEIGHT
		virtual bool SetHeight(int m_Height) override {
			ResetLastError();

			int 	i_FontSize = 1, i_Height = 0, i_Width = 0;
			string 	i_Font = Font(), i_Text = Text();

			TextSetFont	(i_Font, -(int)(i_FontSize * 10));
			TextGetSize	(i_Text, i_Width, i_Height);

			while ((i_Height < m_Height) && !IsStopped()) {
				++i_FontSize;
				TextSetFont(i_Font, -(int)(i_FontSize * 10));
				TextGetSize(i_Text, i_Width, i_Height);
			}

			if (i_Height >= m_Height) {
				--i_FontSize;
				TextSetFont(i_Font, -(int)(i_FontSize * 10));
				TextGetSize(i_Text, i_Width, i_Height);
			}

			SetFontSize(i_FontSize);
			SetShadow();
			return(true);
		}

		virtual int Height() override {
			ResetLastError();
			int 	i_FontSize = FontSize(), i_Height = 0, i_Width = 0;
			string 	i_Font = Font(), i_Text = Text();
			
			if (i_Text == "") i_Text = " ";
			TextSetFont	(i_Font, -(int)(i_FontSize * 10));
			TextGetSize	(i_Text, i_Width, i_Height);
			return(i_Height);
		}

		// WIDTH
		virtual bool SetWidth(int m_Width) override {
			ResetLastError();

			int 	i_FontSize = 1, i_Height = 0, i_Width = 0;
			string 	i_Font = Font(), i_Text = Text();

			TextSetFont	(i_Font, -(int)(i_FontSize * 10));
			TextGetSize	(i_Text, i_Width, i_Height);

			while ((i_Width < m_Width) && !IsStopped()) {
				++i_FontSize;
				TextSetFont(i_Font, -(int)(i_FontSize * 10));
				TextGetSize(i_Text, i_Width, i_Height);
			}

			if (i_Width >= m_Width) {
				--i_FontSize;
				TextSetFont(i_Font, -(int)(i_FontSize * 10));
				TextGetSize(i_Text, i_Width, i_Height);
			}

			SetFontSize(i_FontSize);
			SetShadow();
			return(true);
		}

		virtual int Width() override {
			ResetLastError();
			int 	i_FontSize = FontSize(), i_Height = 0, i_Width = 0;
			string 	i_Font = Font(), i_Text = Text();

			TextSetFont	(i_Font, -(int)(i_FontSize * 10));
			TextGetSize	(i_Text, i_Width, i_Height);
			return(i_Width);
		}
};

class cImage : public cMyObject {
	protected:
		string	File;
		int		XOffset, YOffset;

	public:
		cImage(string m_ShapeName, string m_File) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Create				(m_ShapeName, OBJ_BITMAP_LABEL);
			SetFile				(m_File);
			SetX					(-1000);
			SetY					(-1000);
			SetXOffset			(0);
			SetYOffset			(0);
			
		}

		~cImage() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		bool SetFile(string m_File) {
			ResetLastError();
			
			string FileFullPath;
			StringConcatenate(FileFullPath, EMBED_IMAGE_PATH, m_File, ".bmp");

			if (!ObjectSetString(myChartID, Name, OBJPROP_BMPFILE, 0, FileFullPath)) {
				Log("UNABLE TO SET FILE: " + Name);
				return(false);
			}
			return(true);
		}

		bool SetXOffset(int m_XOffset) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_XOFFSET, m_XOffset)) {
				Log("UNABLE TO SET X OFFSET: " + Name);
				return(false);
			}
			return(true);
		}

		bool SetYOffset(int m_YOffset) {
			ResetLastError();
			if (!ObjectSetInteger(myChartID, Name, OBJPROP_YOFFSET, m_YOffset)) {
				Log("UNABLE TO SET Y OFFSET: " + Name);
				return(false);
			}
			return(true);
		}
};

/*
class cRectangleLabel {
	private:
		//cRectangle = new CRectangle("RectLabel" + 

}
*/

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			TERMINAL x SCREEN
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
class cScreen {
	private:
		void PrintDimensions() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Log("SCREEN HEIGHT:               " + (string)Dimensions.Height);
			Log("SCREEN WIDTH:                " + (string)Dimensions.Width);
			Log("SCREEN TOP:                  " + (string)Dimensions.Top);
			Log("SCREEN LEFT:                 " + (string)Dimensions.Left);
			Log("SCREEN BOTTOM:               " + (string)Dimensions.Bottom);
			Log("SCREEN RIGHT:                " + (string)Dimensions.Right);
			Log("SCREEN CENTRE X:             " + (string)Dimensions.CentreX);
			Log("SCREEN CENTRE Y:             " + (string)Dimensions.CentreY);
		}

		bool SetMarket(string mySymbol) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			if (ChartSetSymbolPeriod(myChartID, mySymbol, PERIOD_CURRENT)) {
				Log("SET TO " + mySymbol);
				return(true);
			} else {
				Log("UNABLE TO SET TO: " + mySymbol);
				return(false);
			}
		}

		void DeleteAllIndicators() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			while (!IsStopped()  &&  (ChartIndicatorsTotal(myChartID, 0) > 0)) {			// MAIN WINDOW
				ChartIndicatorDelete(myChartID, 0, ChartIndicatorName(myChartID, 0, 0));
			}
			while (!IsStopped()  &&  (ChartGetInteger(0, CHART_WINDOWS_TOTAL) > 1)) {		// SUBWINDOWS
				ChartIndicatorDelete(myChartID, 1, ChartIndicatorName(myChartID, 1, 0));
			}
		}

		void DeleteAllObjects() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			ObjectsDeleteAll(myChartID, -1, -1);
		}

	public:
		sSpecs Dimensions, PreviousDimensions;
		
		bool ClearingApproved;

		cScreen() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			//__________ CHART INFORMATION __________
			myChartID 						= ChartID();
			Log								("CHART ID:                    " + (string)myChartID);
			GetDimensions					();
			ClearingApproved				= false;
		}

		~cScreen() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		bool HasChangedInSize() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			PreviousDimensions = Dimensions;
			GetDimensions();
			bool HasChanged = ((Dimensions.Height != PreviousDimensions.Height) || (Dimensions.Width != PreviousDimensions.Width));
			Log("SCREEN:                      " + (HasChanged? "CHANGED" : "UNCHANGED") + 
											  " | PREVIOUS " + (string)PreviousDimensions.Height + "x" + (string)PreviousDimensions.Width +
											  " | " + (string)Dimensions.Height + "x" + (string)Dimensions.Width + " CURRENT");
			
			return(HasChanged);
		}


		void GetDimensions() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Dimensions.Height		= (int)ChartGetInteger(myChartID, CHART_HEIGHT_IN_PIXELS);
			Dimensions.Width		= (int)ChartGetInteger(myChartID, CHART_WIDTH_IN_PIXELS);
			Dimensions.Top			= 0;	// GIVES TOP LEFT OF WINDOW THE POSITION 0,0
			Dimensions.Left			= 0;
			Dimensions.Bottom		= Dimensions.Top  + Dimensions.Height;
			Dimensions.Right		= Dimensions.Left + Dimensions.Width;
			Dimensions.CentreX 		= Dimensions.Left + (int)(Dimensions.Width  * 0.5);
			Dimensions.CentreY 		= Dimensions.Top  + (int)(Dimensions.Height * 0.5);
		}

		void DeleteObjectsByPrefix(string Prefix) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			ObjectsDeleteAll(myChartID, Prefix, -1, -1);
		}

		v
cScreen Screen;

class cTerminal {
	private:
		void DeleteUserPrompts() {
			Screen.DeleteObjectsByPrefix("UserPrompt");
			ChartRedraw(myChartID);
		}

		void PromptUser(string &PromptStrings[]) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			// CREATE LABELS
			cLabel *Labels[];
			ArrayResize(Labels, ArraySize(PromptStrings));
			
			for (int i = 0; i < ArraySize(Labels); i++) {
				// CREATE A NEW LABEL
				Labels[i] = new cLabel("UserPrompt_" + (string)i);

				// DEFINE OTHER ASPECTS
				Labels[i].SetFont		(Verdana);
				Labels[i].SetFontColour	(TronWhite);
				Labels[i].SetText		(PromptStrings[i]);
				Labels[i].SetHeight		((int)(Screen.Dimensions.Height * 0.05));
				Labels[i].SetX			((int)(Screen.Dimensions.CentreX - (Labels[i].Width() * 0.5)));
				Labels[i].SetY			((int)(Screen.Dimensions.Top + (Labels[i].Height() * i)));
			}
			
			ChartRedraw(myChartID);
		}
		
	public:
		//____________________ CONSTRUCTOR ____________________
		cTerminal() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			// ENVIRONMENT VARS
			Log("TERMINAL ARCHITECTURE:       " + (string)(TerminalInfoInteger	(TERMINAL_X64)? "64 BIT" : "32 BIT")						);
			Log("TERMINAL BUILD:              " + (string)TerminalInfoInteger	(TERMINAL_BUILD)											);
			Log("TERMINAL CODE PAGE:          " + (string)TerminalInfoInteger	(TERMINAL_CODEPAGE)											);
			Log("TERMINAL COMPANY:            " + (string)TerminalInfoString 	(TERMINAL_COMPANY)											);
			Log("TERMINAL NAME:               " + (string)TerminalInfoString 	(TERMINAL_NAME)												);
			Log("TERMINAL PATH:               " + (string)TerminalInfoString 	(TERMINAL_PATH)												);

			//NET
			Log("TERMINAL PING LAST (µs):     " + (string)TerminalInfoInteger	(TERMINAL_PING_LAST)										);

			// SYS
			Log("TERMINAL CPU CORES:          " + (string)TerminalInfoInteger	(TERMINAL_CPU_CORES)										);
			Log("TERMINAL DISK SPACE:         " + (string)TerminalInfoInteger	(TERMINAL_DISK_SPACE)										);
			Log("TERMINAL MEMORY AVAILABLE:   " + (string)TerminalInfoInteger	(TERMINAL_MEMORY_AVAILABLE)									);
			Log("TERMINAL MEMORY PHYSICAL:    " + (string)TerminalInfoInteger	(TERMINAL_MEMORY_PHYSICAL)									);
			Log("TERMINAL MEMORY TOTAL:       " + (string)TerminalInfoInteger	(TERMINAL_MEMORY_TOTAL)										);
			Log("TERMINAL MEMORY USED:        " + (string)TerminalInfoInteger	(TERMINAL_MEMORY_USED)										);
			Log("TERMINAL DPI:                " + (string)TerminalInfoInteger	(TERMINAL_SCREEN_DPI)										);

			// ENABLEMENT
			Log("INTERNET:                    " + (string)(TerminalInfoInteger	(TERMINAL_CONNECTED)?		"CONNECTED" : "DISCONNECTED")	);
			Log("FTP:                         " + (string)(TerminalInfoInteger	(TERMINAL_FTP_ENABLED)?		"ENABLED"   : "DISABLED")		);
			Log("EA TRADING:                  " + (string)(MQLInfoInteger		(MQL_TRADE_ALLOWED)?		"ENABLED"   : "DISABLED")		);
			Log("TERMINAL TRADING             " + (string)(TerminalInfoInteger	(TERMINAL_TRADE_ALLOWED)?	"ENABLED"   : "DISABLED")		);
			Log("DLLs:                        " + (string)(MQLInfoInteger		(MQL_DLLS_ALLOWED)?			"ENABLED"   : "DISABLED")		);
		}

		~cTerminal() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		//____________________ KILL SWITCH ____________________
		void TriggerKillSwitch(string Reason) {
			ResetLastError();
			Print(__FUNCSIG__);
			Print("REASON:                      " + Reason);
			Screen.Clear();
			ExpertRemove();
		}

		//____________________ SLEEP ____________________
		void Sleep(ulong Milliseconds) {
			ulong EndTime = (GetTickCount() + Milliseconds);
			while ( !IsStopped() && (GetTickCount() < EndTime) ) {
				ChartRedraw(myChartID);
			}
		}

		void SleepIndefinitely() {
			Log("SLEEPING INDEFINITELY");
			while (!IsStopped()) {}
		}

		//____________________ RESTART HANDLING ____________________
		string UninitialiseReasonString(int Reason) {
			ResetLastError();
			
			switch(Reason) {
				case REASON_PROGRAM:		return("EXPERT REMOVE CALLED");		break;	//<--- ExpertRemove called        0
				case REASON_REMOVE:			return("EXPERT REMOVED FROM CHART");	break;	//<--- Removed from chart         1
				case REASON_RECOMPILE:		return("EXPERT RECOMPILED");			break;	//<--- Recompiled                 2
				case REASON_CHARTCHANGE:		return("CHART CHANGED");				break;	//<--- Chart changed              3
				case REASON_CHARTCLOSE:		return("CHART CLOSED");				break;	//<--- Chart closed               4
				case REASON_PARAMETERS:		return("INPUT PARAMETERS CHANGED");	break;	//<--- Input parameters changed   5
				case REASON_ACCOUNT:		return("ACCOUNT CHANGED");			break;	//<--- Account changed            6
				case REASON_TEMPLATE:		return("TEMPLATE CHANGED");			break;	//<--- Template changed           7
				case REASON_INITFAILED:		return("INITIALISATION FAILED");		break;	//<--- Initialisation failed      8
				case REASON_CLOSE:			return("PLATFORM CLOSED");			break;	//<--- Platform closed            9
			}
			return("REASON NOT FOUND");
		}

		bool IsRestartNecessary() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			bool Restart = false;
			switch(UninitializeReason()) {
				case REASON_PROGRAM:	Restart = true;		break;	//<--- ExpertRemove called
				case REASON_INITFAILED: 	Restart = true;		break;	//<--- Initialisation failed
				case REASON_CLOSE:      	Restart = true;		break;	//<--- Platform closed
				case REASON_REMOVE:     	Restart = true;		break;	//<--- EA Removed from chart
				case REASON_RECOMPILE:  	Restart = true;		break;	//<--- Recompiled
				case REASON_CHARTCLOSE: 	Restart = true;		break;	//<--- Chart closed
				case REASON_TEMPLATE:   	Restart = true;		break;	//<--- Template changed
				case REASON_PARAMETERS:		Restart = false;	break;	//<--- Parameters Changed
				case REASON_CHARTCHANGE: 	Restart = false;	break;	//<--- Market Changed (chart)
				case REASON_ACCOUNT:    	Restart = false;	break;	//<--- Account changed
			}
			
			Log("RESTART:                     " + (Restart?"NECESSARY" : "NOT NECESSARY"));
			return(Restart);
		}

		// SECURITY CHECKS
		//____________________ SECURITY CHECKS ____________________
		bool DisclaimerAccepted() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			if (DEV_MODE_SKIP_DISCLAIMER) {
				Log("DISCLAIMER:                  OVERRIDDEN BY DEV MODE");
				return(true);
			}
			
			string DisclaimerCaption = "";
			StringConcatenate(DisclaimerCaption,	"DISCLAIMER",
													"\n\n",
													"By installing, using or distributing the software you, on your own behalf and on behalf of your employer or principal, agree to be bound by these terms.",
													"\n",
													"If you do not agree to any of these terms, you may not use, copy, transmit, distribute, nor install this software - return it to the place of purchase within 14 days to receive a full refund.",
													"\n",
													"The copyrights in this software and any visual or audio work distributed with the software belong to Trading Warfare and others listed in the about box.",
													"\n",
													"All rights are reserved.",
													"\n",
													"Installation of this software and any Trading Warfare software bundled with or installed-on-demand from this software, including shortcuts and start menu folders, is licensed only in accordance with these terms.",
													"\n",
													"This software, and all accompanying files, data and materials, are distributed ""as is"" and with no warranties of any kind, whether express or implied except as required by law.",
													"\n",
													"If you intend to rely on this software for critical purposes you must test it fully prior to using it, install redundant systems and assume any risk.",
													"\n",
													"We will not be liable for any loss arising out of the use of this software including, but not limited to, any special, incidental or consequential loss.",
													"\n",
													"Your entire remedy against us for all claims is limited to receiving a full refund for the amount you paid for the software.",
													"\n",
													"Any analyses, prices, or other information contained in this software do not constitute investment advice or recommendation, and are not intended to be relied upon in your making, or refraining from making, any trading or investment decisions.",
													"\n",
													"We do not accept any liability for losses or damage, including but not limited to, any loss of profit which may arise directly or indirectly from the use of this software.",
													"\n",
													"Trading is highly leveraged and with that - carries a high degree of risk to your capital.",
													"\n",
													"Prices may move rapidly against you and it is possible to lose more than your initial investment. You may be required to make further payments.",
													"\n",
													"Trading is not suitable for all individuals, so please ensure that you understand the risks involved in trading and if necessary seek independent advice."
													"\n\n",
													"By clicking the ""Yes"" button below, you agree to be bound by these terms."
													);

			if (MessageBox(DisclaimerCaption, (string)PROGRAM_NAME, MB_YESNO+MB_ICONEXCLAMATION) == MSGBOX_YES) {
				Log("DISCLAIMER RESPONSE::        YES");
				return(true);
			} else {

				//need to update for 2020 (brexit changed eu priv laws re cookies?)
				MessageBox("You must accept the disclaimer in order to use this program.\nThe program will now exit", (string)PROGRAM_NAME, MB_OK+MB_ICONINFORMATION);
				Log("DISCLAIMER RESPONSE::        NO");
				TriggerKillSwitch("DISCLAIMER NOT ACCEPTED");
				return(false);
			}
		}

		//____________________ TERMINAL CHECKS ____________________
		bool InternetConnected() {
			ResetLastError();
			if (DEV_MODE_SKIP_INTERNET_CHECK) {
				Log("INTERNET CONNECTION:         OVERRIDDEN BY DEV MODE");
				return(true);
			}
			Log("INTERNET CONNECTION:         CHECKING");

			bool Prompted = false;
			while (!IsStopped() && !TerminalInfoInteger(TERMINAL_CONNECTED)) {
				if (!Prompted) {
					// THIS 'Prompts' ARRAY IS PASSED OVER, AND CREATES THE VARIOUS LABELS
					string Prompts[1];
					Prompts[0] = "Please make sure MetaTrader 5 is connected to the internet";
					PromptUser(Prompts);
					Prompted = true;
				}
			}
			DeleteUserPrompts();
			Log("PLATFORM CONNECTION:         ENABLED");
			return(true);
		}

		bool FTPEnabled() {
			ResetLastError();
			if (DEV_MODE_SKIP_FTP_CHECK) {
				Log("FTP:                         OVERRIDDEN BY DEV MODE");
				return(true);
			}
			Log("FTP:                         CHECKING");
			
			bool Prompted = false;
			while (!IsStopped() && !TerminalInfoInteger(TERMINAL_FTP_ENABLED)) {
				if (!Prompted) {
					string Prompts[2];
					Prompts[0] = "Please enable FTP connections";
					Prompts[1] = "BLA BLA";
					PromptUser(Prompts);
					Prompted = true;
				}
			}
			DeleteUserPrompts();
			Log("FTP:                         ENABLED");
			return(true);
		}

		bool MQLTradingAllowed() {
			ResetLastError();
			if (DEV_MODE_SKIP_EA_TRADING_CHECK) {
				Log("EA TRADING:                  OVERRIDDEN BY DEV MODE");
				return(true);
			}
			Log("EA TRADING:                  CHECKING");
			
			bool Prompted = false;	
			while (!IsStopped() && !MQLInfoInteger(MQL_TRADE_ALLOWED)) {
				if (!Prompted) {
					string Prompts[6];
					Prompts[0] = (string)PROGRAM_NAME + " needs permission to send orders.";
					Prompts[1] = " ";
					Prompts[2] = "Please click:";
					Prompts[3] = "Menu > Charts > Expert List";
					Prompts[4] = "Select " + (string)PROGRAM_NAME + ", then 'Properties'";
					Prompts[5] = "Select the 'Common' tab, and enable 'Allow Automated Trading'";
					PromptUser(Prompts);
					Prompted = true;
				}
			}
			DeleteUserPrompts();
			Log("EA TRADING:                  ENABLED");
			return(true);
		}

		bool TerminalTradingAllowed() {
			ResetLastError();
			if (DEV_MODE_SKIP_TERMINAL_TRADING_CHECK) {
				Log("TERMINAL TRADING:            OVERRIDDEN BY DEV MODE");
				return(true);
			}
			Log("TERMINAL TRADING:            CHECKING");
			
			bool Prompted = false;			
			while (!IsStopped() && !TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {
				if (!Prompted) {
					string Prompts[4];
					Prompts[0] = "Automated trading needs to be enabled in MetaTrader 5.";
					Prompts[1] = " ";
					Prompts[2] = "Menu > Tools > Options > Expert Advisors";
					Prompts[3] = "And select 'Allow Automated Trading'";
					PromptUser(Prompts);
					Prompted = true;
				}
			}
			DeleteUserPrompts();
			Log("TERMINAL TRADING:            ENABLED");
			return(true);
		}
		
		bool DLLsAllowed() {
			ResetLastError();
			if (DEV_MODE_SKIP_DLL_CHECK) {
				Log("DLLs:                        OVERRIDDEN BY DEV MODE");
				return(true);
			}
			Log("DLL's:                       CHECKING");
			
			bool Prompted 			= false;
			while (!IsStopped() && !MQLInfoInteger(MQL_DLLS_ALLOWED)) {
				if (!Prompted) {
					string Prompts[3];
					Prompts[0] = "Please allow DLL's from the MetaTrader 5 settings";
					Prompts[1] = " ";
					Prompts[2] = "Menu > Tools > Options > Expert Advisors > 'Allow DLL Imports'";
					PromptUser(Prompts);
					Prompted = true;
				}
			}
			DeleteUserPrompts();
			Log("DLL's:                       ENABLED");
			return(true);
		}
};
cTerminal Terminal;

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			USER
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
class cKeyboard {
	private:
		#define MAX_NO_OF_HOTKEYS 	500
		bool	HotkeyIsActive		[MAX_NO_OF_HOTKEYS];
		string 	HotkeyDefinitions	[MAX_NO_OF_HOTKEYS];

		void MapHotkeys() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			for (int i_Keycode = 0; i_Keycode < MAX_NO_OF_HOTKEYS; i_Keycode++) {
				// INITIALLY SET TO ACTIVE UNTIL PROVEN OTHERWISE
				HotkeyIsActive		[i_Keycode] = false;
				HotkeyDefinitions	[i_Keycode] = "";

				switch(i_Keycode) {
					case	KEY_UP		:	HotkeyDefinitions[i_Keycode] = "UP"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_DOWN	:	HotkeyDefinitions[i_Keycode] = "DOWN"	;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_0 		:	HotkeyDefinitions[i_Keycode] = "0"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_1 		:	HotkeyDefinitions[i_Keycode] = "1"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_2 		:	HotkeyDefinitions[i_Keycode] = "2"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_3 		:	HotkeyDefinitions[i_Keycode] = "3"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_4 		:	HotkeyDefinitions[i_Keycode] = "4"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_5 		:	HotkeyDefinitions[i_Keycode] = "5"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_6 		:	HotkeyDefinitions[i_Keycode] = "6"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_7 		:	HotkeyDefinitions[i_Keycode] = "7"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_8 		:	HotkeyDefinitions[i_Keycode] = "8"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_9 		:	HotkeyDefinitions[i_Keycode] = "9"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_A 		:	HotkeyDefinitions[i_Keycode] = "A"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_B 		:	HotkeyDefinitions[i_Keycode] = "B"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_C 		:	HotkeyDefinitions[i_Keycode] = "C"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_D 		:	HotkeyDefinitions[i_Keycode] = "D"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_E 		:	HotkeyDefinitions[i_Keycode] = "E"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_F 		:	HotkeyDefinitions[i_Keycode] = "F"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_G 		:	HotkeyDefinitions[i_Keycode] = "G"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_H 		:	HotkeyDefinitions[i_Keycode] = "H"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_I 		:	HotkeyDefinitions[i_Keycode] = "I"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_J 		:	HotkeyDefinitions[i_Keycode] = "J"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_K 		:	HotkeyDefinitions[i_Keycode] = "K"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_L 		:	HotkeyDefinitions[i_Keycode] = "L"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_M 		:	HotkeyDefinitions[i_Keycode] = "M"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_N 		:	HotkeyDefinitions[i_Keycode] = "N"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_O 		:	HotkeyDefinitions[i_Keycode] = "O"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_P 		:	HotkeyDefinitions[i_Keycode] = "P"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_Q 		:	HotkeyDefinitions[i_Keycode] = "Q"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_R 		:	HotkeyDefinitions[i_Keycode] = "R"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_S 		:	HotkeyDefinitions[i_Keycode] = "S"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_T 		:	HotkeyDefinitions[i_Keycode] = "T"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_U 		:	HotkeyDefinitions[i_Keycode] = "U"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_V 		:	HotkeyDefinitions[i_Keycode] = "V"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_W 		:	HotkeyDefinitions[i_Keycode] = "W"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_X 		:	HotkeyDefinitions[i_Keycode] = "X"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_Y 		:	HotkeyDefinitions[i_Keycode] = "Y"		;	HotkeyIsActive[i_Keycode] = true	;	break;
					case	KEY_Z 		:	HotkeyDefinitions[i_Keycode] = "Z"		;	HotkeyIsActive[i_Keycode] = true	;	break;
				}				
			}			
		}

	public:
		cKeyboard() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Enabled = false;
			MapHotkeys	();
		}
		
		~cKeyboard() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Enabled = false;
		}

		bool Enabled;

		void Toggle(bool EnabledDisabled) {
			ResetLastError();
			
			Enabled = EnabledDisabled;
			if (Enabled) {
				Sound.Play("Hotkeys\\HotkeysEnabled");
			} else {
				Sound.Play("Hotkeys\\HotkeysDisabled");
			}

			Log("KEYSTROKES:                  " + (Enabled? "SET TO ENABLED" : "SET TO DISABLED"));
		}

		void Keystroke(long lparam) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			Log("KEY PRESSED:                 " + (HotkeyIsActive[(int)lparam]? HotkeyDefinitions[(int)lparam] : "KEY NOT ADDED") + " (" + (string)lparam + ") " + (Enabled? "KEYS ARE CURRENTLY ENABLED" : "KEYS ARE CURRENTLY DISABLED"));
		}

		bool KeyIsInUse(long lparam) {
			ResetLastError();
			return(HotkeyIsActive[(int)lparam]);
		}
};
cKeyboard Keyboard;

class cMouse {
	private:
		bool 	Enabled;

	public:
		struct sMousePos {
			int	X, Y, FromCentreX, FromCentreY;

			sMousePos() {
				X = 0; Y = 0; FromCentreX = 0; FromCentreY = 0;
			}
		}; sMousePos Pos;

		cMouse() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Toggle		(true);

			//__________ SUBSCRIBE TO MOUSE EVENTS __________
			Log("MOUSE:                       " + (ChartSetInteger(myChartID, CHART_EVENT_MOUSE_MOVE, 1)?"SUBSCRIBED" : "ERROR SUBSCRIBING"));

			// DISABLE MOUSE SCROLL EVENTS
			ChartSetInteger(myChartID, CHART_EVENT_MOUSE_WHEEL, false);
		}
		
		~cMouse() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Toggle		(false);
		}

		void Toggle(bool EnabledDisabled) {
			ResetLastError();
			Enabled = EnabledDisabled;
			Log("MOUSE CLICKS:                " + (string)Enabled);
		}

		void Moved(long lparam, double dparam) {
			Pos.X			= (int)lparam;
			Pos.Y			= (int)dparam;
			Pos.FromCentreX = (Pos.X - Screen.Dimensions.CentreX);
			Pos.FromCentreY	= (Pos.Y - Screen.Dimensions.CentreY);
		}

		void ObjectClicked(string sparam) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			Log("OBJECT CLICKED:              " + sparam + " | CLICKS " + (Enabled? "ENABLED" : "DISABLED"));
			LastObjectClicked = sparam;
		}

		void ScreenClicked(long lparam, double dparam) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			Log("MOUSE CLICKED:               X" + (string)lparam + "  Y" + (string)dparam + "  " + (Enabled? "ENABLED" : "DISABLED"));
			LastScreenClickXPos = (int)lparam;
			LastScreenClickYPos = (int)dparam;
		}
};
cMouse Mouse;

class cAccount {
	public:
		cAccount() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}
		~cAccount() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		string BrokerName() {
			return(String.Uppercase(AccountInfoString(ACCOUNT_COMPANY)));
		}
		
		string Balance() {
			int		AccountBalance = (int)MathRound(AccountInfoDouble(ACCOUNT_BALANCE));
			string 	BalanceStr 	= "";
			
			// NORMALISE DECIMALS
			if			(AccountBalance < 10) 		{
				BalanceStr = "0000000";
			} else if 	(AccountBalance < 100) 		{
				BalanceStr = "000000";
			} else if 	(AccountBalance < 1000) 	{
				BalanceStr = "00000";
			} else if 	(AccountBalance < 10000) 	{
				BalanceStr = "0000";
			} else if 	(AccountBalance < 100000) 	{
				BalanceStr = "000";
			} else if 	(AccountBalance < 1000000) 	{
				BalanceStr = "00";
			} else if 	(AccountBalance < 10000000) {
				BalanceStr = "0";
			}
		
			StringConcatenate(BalanceStr, AccountInfoString(ACCOUNT_CURRENCY), " ", BalanceStr, (string)AccountBalance);
			return(BalanceStr);
		}
};
cAccount Account;

class cScreenshot {
	private:
		string	LastFileName;
		int		NoOfScreenshots;

		bool vCapture(string FileName, bool PlaySoundEffect) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			bool 	Success = ChartScreenShot(myChartID, FileName, Screen.Dimensions.Width, Screen.Dimensions.Height, ALIGN_CENTER);
			Log		("SCREENSHOT:                  " + (Success? "SUCCESS" : "FAILED"));
			if (PlaySoundEffect) Sound.Play("Screenshot");
			return	(Success);
		}

	public:
		cScreenshot() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			LastFileName	= "";
			NoOfScreenshots = 0;

			Log("SCREENSHOT FOLDER:           " + (FolderCreate("Screenshots", 0)? "CREATED" : "UNABLE TO CREATE"));
		}
		~cScreenshot() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

		void CaptureCustomFilename(string FileName) {
			vCapture(FileName, false);
		}

		void Capture() {
			StringConcatenate(LastFileName, "Screenshots\\", Symbol(), " ", Time.TimeString(), ".png");
			vCapture(LastFileName, true);
			++NoOfScreenshots;
		}
				
/* 		void OpenFolder() {          
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			WinAPI.OpenFolder("Screenshots");
		} */
		
/* 		void OpenLastCapture() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			if (NoOfScreenshots == 0) {
				Log("NO SCREENSHOTS TAKEN YET");
				return;
			} else {
				WinAPI.OpenFileOrProgram(TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL5\\Files\\Screenshots\\" + LastFileName);
			}
		} */
};
cScreenshot Screenshot;

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			ON_TIMER LOOP
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
class cMainLoop {
	private:
		#define MAX_LOOPS 100000000
		int		LoopSpeedMS, RedrawFrequencyMS;
		ulong	Iterations, NextRedrawMS, LoopSpeeds[MAX_LOOPS-10];
		cLabel 	*LoopLabel;
		cLabel	*MouseCoordsLabel;
		
	public:
		cMainLoop() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}
		
		~cMainLoop() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			delete(LoopLabel);
			delete(MouseCoordsLabel);
		}

		void Initialise(int m_InitialLoopSpeedMS) {
			// LOOP LABEL
			LoopLabel 					= new cLabel("Loop");
			LoopLabel.SetBack				(false);
			LoopLabel.SetFont				(OCR);
			LoopLabel.SetFontSize			(10);
			LoopLabel.SetFontColour			(TronBlue);
			LoopLabel.SetX					(10);
			LoopLabel.SetY					(10);
			
			// MOUSE COORDS LABEL
			MouseCoordsLabel 				= new cLabel("MouseCoords");
			MouseCoordsLabel.SetBack			(false);
			MouseCoordsLabel.SetFont			(OCR);
			MouseCoordsLabel.SetFontSize		(10);
			MouseCoordsLabel.SetFontColour	(TronBlue);
			MouseCoordsLabel.SetX			(10);
			MouseCoordsLabel.SetY			(LoopLabel.Bottom());
			
			// START TIMER
			LoopSpeedMS					= m_InitialLoopSpeedMS;
			Iterations 					= 0;
			NextRedrawMS					= 0;
			RedrawFrequencyMS				= 20;
			TickCount						= GetTickCount();
			ArrayInitialize				(LoopSpeeds, 0);

			EventSetMillisecondTimer(LoopSpeedMS);
		}

		void AdjustTimerSpeed(int m_SpeedInMS) {
			Iterations				= 0;
			LoopSpeedMS 			= m_SpeedInMS;
			EventKillTimer			();
			EventSetMillisecondTimer(LoopSpeedMS);
		}
		
		void LoopHandler() {
			if (Iterations >= MAX_LOOPS) {
				Iterations = 1;
			} else {
				++Iterations;
			}

			TickCount_Prev 	= TickCount;
			TickCount		= GetTickCount();

			LoopSpeeds[(int)Iterations-1] = (TickCount - TickCount_Prev);

			if (TickCount > NextRedrawMS) {
				LoopLabel.SetText		((string)Iterations + " | TIMER SPEED " + (string)LoopSpeedMS + " | REDRAW FREQ " + (string)RedrawFrequencyMS + " | LAST LOOP MS " + (string)LoopSpeeds[(int)Iterations-1]);
				MouseCoordsLabel.SetText("X " + (string)Mouse.Pos.X + " Y " + (string)Mouse.Pos.Y + " | Y_OFF " + (string)Mouse.Pos.FromCentreX + " Y_OFF " + (string)Mouse.Pos.FromCentreY);
				ChartRedraw(myChartID);
				NextRedrawMS = (TickCount + RedrawFrequencyMS);
			}
		}
};
cMainLoop MainLoop;

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			MARKET DATA
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
// STRUCTURE FOR HOLDING ORDER BOOK INFORMATION
#define BID	0
#define ASK 	1

struct sOrderBookData final {
	double Bid, Ask, Last;
	double Depth[2,100]; // Bid x Ask | 100 levels per side max. 0 refers to best bid or ask.
	sOrderBookData() {	// default constructor
		Bid = 0; Ask = 0; Last = 0;
		ArrayInitialize(Depth, 0);
	}
};

class cMarket {
	private:
		// ERROR HANDLING
		#define	DOM_NOT_AVAILABLE		4901
		
		string	Symbol;
		bool		Subscribed;

		bool Unsubscribe() {
			ResetLastError();

			if (Subscribed) {
				Subscribed = MarketBookRelease(Symbol);
				Log("UNSUBSCRIBE:                 " + Symbol + " | " + (Subscribed? "SUCCESS" : "FAILED"));
			}
			return(Subscribed);
		}

	public:
		cMarket(string m_Symbol) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			Symbol = m_Symbol;
		}
		~cMarket() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Unsubscribe();
			Subscribed = false;
		}

		bool Subscribe() {
			ResetLastError();

			Subscribed = MarketBookAdd(Symbol);
			string ErrorStr = "";

			if (GetLastError() == DOM_NOT_AVAILABLE) {
				ResetLastError();
				ErrorStr = "DOM NOT AVAILABLE";
			}
			
			Log("SUBSCRIBE:                   " + Symbol + " | " + (Subscribed? "SUCCESS" : "FAILED ") + ErrorStr);
			return(Subscribed);
		}
};

class cWatchlist {
	public:
		cMarket	*Markets[];

		cWatchlist() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Create();
		}

		~cWatchlist() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			for (int i = 0; i < ArraySize(Markets); i++) {
				delete(Markets[i]);
			}
		}

		void Create() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Log("TOTAL SYMBOLS AVAILABLE      " + (string)SymbolsTotal(false));
			Log("SYMBOLS ON USER LIST         " + (string)SymbolsTotal(true));

			bool	OnlyUserSymbols	= true;
			int 	TotalSymbols 		= SymbolsTotal(OnlyUserSymbols);
			int 	SymbolsAdded		= 0;

			for (int i = 0; i < TotalSymbols; i++) {
				string SymbolToAdd = SymbolName(i, OnlyUserSymbols);
				
				ArrayResize(Markets, SymbolsAdded+1);
				Markets[SymbolsAdded] = new cMarket(SymbolToAdd);

				if (!Markets[SymbolsAdded].Subscribe()) {
					delete(Markets[SymbolsAdded]);
				} else {
					Log("ADDED " + SymbolToAdd);
					++SymbolsAdded;
				}
			}
		}
};
//cWatchlist Watchlist;

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			EFFECTS
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
class cTypewriter {
	private:
		string 	Text[], Font;
		color	FontColour;
		int 	Width, CentreX, CentreY, NoOfLines;
		bool 	PlaySoundEffect;
		cLabel 	*Label[];

	public:
		cTypewriter(string &m_Text[], string m_Font, color m_FontColour, int m_Width, int m_CentreX, int m_CentreY, bool m_PlaySoundEffect) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			ArrayCopy		(Text, m_Text, 0, 0, WHOLE_ARRAY);
			Font 			= m_Font;
			FontColour 		= m_FontColour;
			Width 			= m_Width;
			CentreX 		= m_CentreX;
			CentreY 		= m_CentreY;
			PlaySoundEffect = m_PlaySoundEffect;

			NoOfLines 		= ArraySize(Text);
			ArrayResize		(Label, NoOfLines);

			Create();
		}
		
		~cTypewriter() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			for (int i = 0; i < ArraySize(Label); i++) {
				delete(Label[i]);
			}
		}

		void Create() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			for (int Line = 0; Line < NoOfLines; Line++) {
				// CHOOSE A UNIQUE NAME, ALLOWING FOR MULTIPLE LABELS TO CO-EXIST --- ALMOST DIDN'T SPOT THAT 'PROGRAM' NAME NEEDS PREFIXING BEFORE SEARCHING FOR FREE SLOT
				string Prefix 	= "TypewriterEffect_" + (string)Line;
				string Name		= Prefix + FindFreeNamingSlot(Prefix);
			
				Label[Line] = new cLabel(Name);
				Label[Line].SetText			(Text[Line]);
				Label[Line].SetFont			(Font);
				Label[Line].SetFontColour	(FontColour);
				Label[Line].SetWidth		(Width);
			}

			// GET TOTAL HEIGHT OF THE LINES
			int TotalLineHeight = 0;
			for (int Line = 0; Line < NoOfLines; Line++) {
				TotalLineHeight += Label[Line].Height();
			}

			// BEGIN EFFECT
			for (int Line = 0; Line < NoOfLines; Line++) {
				if (PlaySoundEffect) {
					Sound.Play("DigitalTextSound");
				}
							
				string str = Text[Line];
				Label[Line].SetText	("");

				if (Line == 0) {
					Label[Line].SetY(CentreY - (int)(TotalLineHeight * 0.5));
				} else { 
					Label[Line].SetY(Label[Line-1].Bottom());
				}
				
				for (int i = 1; i <= StringLen(str); i++) {
					for (int j = 0; j < Math.RandomBetween(3,20); j++) {
						Label[Line].SetText	(StringSubstr(str, 0, i-1) + String.RandomLetter());
						ChartRedraw			(myChartID);
					}
					
					Label[Line].SetText	(StringSubstr(str, 0, i));
					Label[Line].SetX	(CentreX - (int)(Label[Line].Width() * 0.5));
					ChartRedraw			(myChartID);
					Terminal.Sleep		(Math.RandomBetween(20,50));
				}
				
				if (PlaySoundEffect) {			
					Sound.Play("NULL");
				}

				Terminal.Sleep(700);
			}
		}

 		void Out() {
			for (int Line = 0; Line < NoOfLines; Line++) {
				string	LabelText		= Label[Line].Text();
				int		StringLength	= StringLen(LabelText);

				if (ObjectFind(myChartID, Label[Line].Name) == -1) {
					return;
				}

				// FIND SPACES IN TEXT
				int Spaces 	= 0;
				while (Spaces < StringLength) {
					for (int i = 0; i <= StringLength; i++) {
						if (StringSubstr(LabelText, i, 1) == " ") {
							Spaces++;
						}
					}
				
					int CharToRemove = (0 + StringLen(LabelText) * MathRand()/32768);
					StringReplace		(LabelText, StringSubstr(LabelText, CharToRemove, 1), " ");	// string, find, replace
					Label[Line].SetText	(LabelText);
					ChartRedraw			(myChartID);
					Terminal.Sleep		(Math.RandomBetween(50,100));
				}
				
				delete		(Label[Line]);
				ChartRedraw	(myChartID);	
			}
		}
};

class cParallax {
	private:
		int 	m_Height, m_Width, m_Left, m_Right, m_CentreX, m_CentreY;
		double 	MovementPercentX, MovementPercentY;
		int 	MovementRateX, MovementRateY;
		cLabel	*LabelToMove;

		void StoreCoords() {
			ResetLastError();

			m_Height	= LabelToMove.Height();
			m_Width		= LabelToMove.Width();
			m_Left		= LabelToMove.Left();
			m_Right 	= LabelToMove.Right();
			m_CentreX 	= LabelToMove.CentreX();
			m_CentreY 	= LabelToMove.CentreY();
		}

	public:
		cParallax(cLabel &myLabel, double myMovementPercentX, double myMovementPercentY) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			LabelToMove = GetPointer(myLabel);
			StoreCoords();

			MovementPercentX 	= myMovementPercentX;
			MovementPercentY 	= myMovementPercentY;
		}
		
		~cParallax() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			delete(LabelToMove);
		}

		void SetPositions() {
			StoreCoords();
		}

		void Update() {
			MovementRateX 	= (int)(Mouse.Pos.FromCentreX * MovementPercentX);
			MovementRateY 	= (int)(Mouse.Pos.FromCentreY * MovementPercentY);
			LabelToMove.SetX((int)(m_CentreX - (m_Width * 0.5) - MovementRateX));
			LabelToMove.SetY((int)(m_CentreY - (m_Height * 0.5) - MovementRateY));
		}
};

class cFadingLabel {
	private:
		int		TotalSteps;
		int		CurrentStep;
		color	StartingColour;
		color 	FadeArray[];
		int		XPos, YPos;

	public:
		cFadingLabel(string m_Name, string m_Font, int m_YPos, int m_XPos, color m_StartingColour, int m_Steps) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Label 						= new cLabel(m_Name);
			Label.SetText				("     ");
			XPos						= m_XPos;
			YPos						= m_YPos;

			StartingColour				= m_StartingColour;
			TotalSteps					= m_Steps;
			CurrentStep					= 0;
			Colour.CreateFadeOutArray	(StartingColour, TotalSteps, FadeArray);
		}

		~cFadingLabel() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			delete(Label);
		}

		cLabel *Label;

		void Update() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Label.SetText		(LastKeyPressed);
			Label.SetFont		(OCR);
			Label.SetFontColour	(StartingColour);
			Label.SetX			(XPos - (int)(Label.Width() * 0.05));
			Label.SetY			(YPos);
			CurrentStep			= TotalSteps;
		}

		void LoopHandler() {
			if (CurrentStep >= 0) {
				if (CurrentStep == 0) {
					Label.SetText(" ");
				}
				Label.SetFontColour(FadeArray[CurrentStep]);
				--CurrentStep;
			}
		}
};

class cGrid {
	public:
		sSpecs	GridSpecs;
		sSpecs	CellSpecs	[1000,1000];

		cGrid() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}
	
		~cGrid() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
		}

	protected:
		int NoOfRows, NoOfColumns;

		void GetPositions() {
			ResetLastError();

			int CellHeight			= (int)((1.0 * GridSpecs.Height) / (1.0 * NoOfRows));	// PRE PADDING
			int CellWidth			= (int)((1.0 * GridSpecs.Width)  / (1.0 * NoOfColumns));
			
			int TotalCellHeight		= CellHeight * NoOfRows;
			int TotalCellWidth		= CellWidth * NoOfColumns;

			GridSpecs.Top			= GridSpecs.CentreY - (int)(TotalCellHeight * 0.5);
			GridSpecs.Left 			= GridSpecs.CentreX - (int)(TotalCellWidth * 0.5);

			int CellHeight_Inner	= CellHeight - (GridSpecs.YPadding * 2); 		// WITH PADDING
			int CellWidth_Inner		= CellWidth -  (GridSpecs.XPadding * 2);

			for (int Column = 0; Column < NoOfColumns; Column++) {
				for (int Row = 0; Row < NoOfRows; Row++) {
					CellSpecs[Column,Row].Height	= CellHeight_Inner;
					CellSpecs[Column,Row].Width		= CellWidth_Inner;
					CellSpecs[Column,Row].Left		= GridSpecs.Left + (CellWidth * Column) + GridSpecs.XPadding;
					CellSpecs[Column,Row].Top 		= GridSpecs.Top +  (CellHeight * Row) +   GridSpecs.YPadding;
					CellSpecs[Column,Row].Right		= CellSpecs[Column,Row].Left + CellWidth_Inner;
					CellSpecs[Column,Row].Bottom	= CellSpecs[Column,Row].Top  +  CellHeight_Inner;
					CellSpecs[Column,Row].CentreX	= CellSpecs[Column,Row].Left + (int)(CellSpecs[Column,Row].Width * 0.5);
					CellSpecs[Column,Row].CentreY	= CellSpecs[Column,Row].Top  + (int)(CellSpecs[Column,Row].Height * 0.5);
				}
			}
		}
};

class cGridOpaque : public cGrid {
	public:
		cRectangle 	*Cells		[1000,1000];
		
		cGridOpaque(int m_Columns, int m_Rows) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			NoOfColumns 		= m_Columns;
			NoOfRows			= m_Rows;
			
			for (int Column = 0; Column < NoOfColumns; Column++) {
				for (int Row = 0; Row < NoOfRows; Row++) {
					string i_Name 		= "GridCell_Col" + (string)Column + "_Row" + (string)Row;
					Cells[Column,Row] 	= new cRectangle(i_Name);
				}
			}
		}
		
		~cGridOpaque() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			for (int Column = 0; Column < NoOfColumns; Column++) {
				for (int Row = 0; Row < NoOfRows; Row++) {
					delete(Cells[Column,Row]);
				}
			}
		}

		void SetPositions(int m_Height, int m_Width, int m_CentreX, int m_CentreY) {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			GridSpecs.XPadding	= 2;
			GridSpecs.YPadding	= 2;
			GridSpecs.Height	= m_Height;
			GridSpecs.Width		= m_Width;
			GridSpecs.CentreX	= m_CentreX;
			GridSpecs.CentreY	= m_CentreY;
			GridSpecs.Top		= GridSpecs.CentreY - (int)(GridSpecs.Height * 0.5);
			GridSpecs.Bottom	= GridSpecs.Top + GridSpecs.Height;
			GridSpecs.Left		= GridSpecs.CentreX - (int)(GridSpecs.Width * 0.5);
			GridSpecs.Right		= GridSpecs.Left + GridSpecs.Width;

			GetPositions();

			for (int Column = 0; Column < NoOfColumns; Column++) {
				for (int Row = 0; Row < NoOfRows; Row++) {
					Cells[Column,Row].SetHeight		(CellSpecs[Column,Row].Height);
					Cells[Column,Row].SetWidth		(CellSpecs[Column,Row].Width);
					Cells[Column,Row].SetX			(CellSpecs[Column,Row].Left);
					Cells[Column,Row].SetY			(CellSpecs[Column,Row].Top);
				}
			}
		}
};

/* class cGridTransparent : public cGrid {		// *********************** DANGER! COLS AND ROWS NOT YET REVERSED LIKE THE OTHER NEWER GRID CLASSES
	private:
		CCanvas		*Grid;
		uchar 		TransparencyLevel;

	public:
		cGridTransparent(	int m_Rows, int m_Columns,
							int m_XPadding, int m_YPadding,
							int m_Height, int m_Width,
							int m_CentreX, int m_CentreY) {

			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			NoOfRows			= m_Rows;
			NoOfColumns 		= m_Columns;
			GridSpecs.Height	= m_Height;
			GridSpecs.Width		= m_Width;
			GridSpecs.CentreX	= m_CentreX;
			GridSpecs.CentreY	= m_CentreY;
			GridSpecs.XPadding	= m_XPadding;
			GridSpecs.YPadding	= m_YPadding;

			GetPositions	();
			Create			();
			SetPositions	();
		}
		
		~cGridTransparent() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			Destroy();
		}

		void Destroy() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);

			if (CheckPointer(Grid) != POINTER_INVALID) {
				Grid.Destroy();
				delete	(Grid);
			}
		}
	
		void Create() {
			ResetLastError();
			LogFuncSig(__FUNCSIG__);
			
			Destroy();
						
			Grid 					= new CCanvas;
			Grid.CreateBitmapLabel	("GridTransparent", GridSpecs.Left, GridSpecs.Top, GridSpecs.Width, GridSpecs.Height, COLOR_FORMAT_ARGB_NORMALIZE); // NAME, x, y, w, h
			Grid.Erase				(ColorToARGB(clrWhiteSmoke));
			SetTransparency			(100);
		}

		void SetPositions() {
			ResetLastError();

			for (int Column = 0; Column < NoOfColumns; Column++) {
				for (int Row = 0; Row < NoOfRows; Row++) {
					Grid.FillRectangle(	CellSpecs[Row,Column].Left,		// x1, y1, x2, y2, clr;
										CellSpecs[Row,Column].Top,
										CellSpecs[Row,Column].Right,
										CellSpecs[Row,Column].Bottom,
										clrBlack);
				}
			}

			Grid.Update(false);
		}

		void SetTransparency(uchar m_TransparencyLevel) {
			ResetLastError();
			
			TransparencyLevel 		= m_TransparencyLevel;
			Grid.TransparentLevelSet(TransparencyLevel);
			Grid.Update				(false);
		}

		void RefitHandler(int m_Height, int m_Width, int m_CentreX, int m_CentreY) {
			ResetLastError();

			GridSpecs.Height	= m_Height;
			GridSpecs.Width		= m_Width;
			GridSpecs.CentreX	= m_CentreX;
			GridSpecs.CentreY	= m_CentreY;

			GetPositions();

			Grid.Destroy();
			delete					(Grid);
			Grid 					= new CCanvas;
			Grid.CreateBitmapLabel	("GridTransparent", GridSpecs.Left, GridSpecs.Top, GridSpecs.Width, GridSpecs.Height, COLOR_FORMAT_ARGB_NORMALIZE); // NAME, x, y, w, h
			Grid.Erase				(ColorToARGB(clrWhiteSmoke));
			SetTransparency			(TransparencyLevel);
			Grid.Update				(true);

			SetPositions();
		}
}; */

//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
//|                                                          			INDICATORS
//+------------------------------------------------------------------------------------------------------------------------------------------------------------+
// ----- BUILD INTO A CLASS! -----


//string   			name				= "";
datetime			Offset			= 0;
ENUM_TIMEFRAMES	FractalTF			= PERIOD_M1;
int				FractalFirstHop	= 1;
int				FractalSecondHop	= 2;
int				NoOfBars			= Bars(Symbol(), FractalTF);


void CreateTrendLine(string LineName, color LineColour, int FirstBarIndex, int BarDiff, datetime FirstTime, double FirstPrice, datetime SecondTime, double SecondPrice) {
	ObjectDelete(0, LineName);

	Offset = (iTime(Symbol(), 1, 0) + 60);

	double   Gradient       = ((FirstPrice - SecondPrice) / BarDiff);  //(y2 - y1) / (x2 - x1)
	double   NewY           = (FirstPrice + (FirstBarIndex * Gradient));

	ObjectCreate(myChartID, LineName, OBJ_TREND, 0, Offset, NewY, SecondTime, SecondPrice);
	
	ObjectSetInteger(myChartID, LineName, OBJPROP_STYLE, STYLE_SOLID);
	ObjectSetInteger(myChartID, LineName, OBJPROP_COLOR, LineColour);
	ObjectSetInteger(myChartID, LineName, OBJPROP_WIDTH, 2);
	ObjectSetInteger(myChartID, LineName, OBJPROP_RAY, false);
	ObjectSetInteger(myChartID, LineName, OBJPROP_BACK, true);
	ObjectSetInteger(myChartID, LineName, OBJPROP_SELECTABLE, false);
	ObjectSetInteger(myChartID, LineName, OBJPROP_HIDDEN, true);
}

//========== CALCULATE FRACTALS ==========
void CreateFractals() {
   
	Screen.DeleteObjectsByPrefix("Fractal");
	Screen.DeleteObjectsByPrefix("Trend");
   
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
   int i = 0;

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
      if(!FractalHighFound && (NoOfBars-i-1) >=3) {
         if(FractalPrice == iHigh(FractalPair, FractalTF, i+1) && FractalPrice > iHigh(FractalPair, FractalTF, i+2) && FractalPrice > iHigh(FractalPair, FractalTF, i+3) &&
            FractalPrice > iHigh(FractalPair, FractalTF, i-1) && FractalPrice > iHigh(FractalPair, FractalTF, i-2)) {
            
            FractalHighFound = true;
            NoOfHighsFound++;
            DrawFractalLines("High", FractalTime, FractalPrice, FractalHighCount++);
         }
      }         
      
      //----7 bars Fractal
      if (!FractalHighFound && (NoOfBars-i-1) >=4) {   
         if (FractalPrice >= iHigh(FractalPair, FractalTF, i+1) && FractalPrice == iHigh(FractalPair, FractalTF, i+2) && FractalPrice > iHigh(FractalPair, FractalTF, i+3) && 
            FractalPrice > iHigh(FractalPair, FractalTF, i+4) && FractalPrice > iHigh(FractalPair, FractalTF, i-1) && FractalPrice > iHigh(FractalPair, FractalTF, i-2)) {
               
               FractalHighFound = true;
               NoOfHighsFound++;
               DrawFractalLines("High", FractalTime, FractalPrice, FractalHighCount++);
         }
      }
      
      //----8 bars Fractal                          
      if (!FractalHighFound && (NoOfBars-i-1) >=5) {   
         if (FractalPrice >= iHigh(FractalPair, FractalTF, i+1) && FractalPrice == iHigh(FractalPair, FractalTF, i+2) && FractalPrice == iHigh(FractalPair, FractalTF, i+3) &&
            FractalPrice > iHigh(FractalPair, FractalTF, i+4) && FractalPrice > iHigh(FractalPair, FractalTF, i+5) &&
               FractalPrice > iHigh(FractalPair, FractalTF, i-1) && FractalPrice > iHigh(FractalPair, FractalTF, i-2)) {
               
               FractalHighFound = true;
               NoOfHighsFound++;
               DrawFractalLines("High", FractalTime, FractalPrice, FractalHighCount++);
         }
      } 
      
      //----9 bars Fractal                                        
      if (!FractalHighFound && (NoOfBars-i-1) >=6) {   
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
      if (!FractalLowFound && (NoOfBars-i-1) >= 3) {
         if (FractalPrice == iLow(FractalPair, FractalTF, i+1) && FractalPrice < iLow(FractalPair, FractalTF, i+2) && FractalPrice < iLow(FractalPair, FractalTF, i+3) &&
            FractalPrice < iLow(FractalPair, FractalTF, i-1) && FractalPrice < iLow(FractalPair, FractalTF, i-2)) {
               
               FractalLowFound = true;
               NoOfLowsFound++;
               DrawFractalLines("Low", FractalTime, FractalPrice, FractalLowCount++);
         }
      }      
      
      //----7 bars Fractal
      if(!FractalLowFound && (NoOfBars-i-1) >= 4) {   
         if (FractalPrice <= iLow(FractalPair, FractalTF, i+1) && FractalPrice == iLow(FractalPair, FractalTF, i+2) && FractalPrice < iLow(FractalPair, FractalTF, i+3) &&
            FractalPrice < iLow(FractalPair, FractalTF, i+4) && FractalPrice < iLow(FractalPair, FractalTF, i-1) && FractalPrice < iLow(FractalPair, FractalTF, i-2)) {
               
               FractalLowFound = true;
               NoOfLowsFound++;
               DrawFractalLines("Low", FractalTime, FractalPrice, FractalLowCount++);
         }
      }  
      
      //----8 bars Fractal                          
      if (!FractalLowFound && (NoOfBars-i-1) >= 5) {
         if (FractalPrice <= iLow(FractalPair, FractalTF, i+1) && FractalPrice == iLow(FractalPair, FractalTF, i+2) && FractalPrice == iLow(FractalPair, FractalTF, i+3) &&
            FractalPrice < iLow(FractalPair, FractalTF, i+4) && FractalPrice < iLow(FractalPair, FractalTF, i+5) && FractalPrice < iLow(FractalPair, FractalTF, i-1) && FractalPrice < iLow(FractalPair, FractalTF, i-2)) {
               
               FractalLowFound = true;
               NoOfLowsFound++;
               DrawFractalLines("Low", FractalTime, FractalPrice, FractalLowCount++);
         }                      
      } 
      
      //----9 bars Fractal                                        
      if (!FractalLowFound && (NoOfBars-i-1) >= 6) {
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
	color	FractalColour		= 0;
	int		FractalStyle		= STYLE_DASH;
	double	FractalDistance	= (20 * (Point() * 10));
	int		FractalThickness 	= 1;
	
	double	Bid				= SymbolInfoDouble(Symbol(), SYMBOL_BID);
	double	Ask				= SymbolInfoDouble(Symbol(), SYMBOL_ASK);
	string	name 			= "";

	if (FractalLevel > Ask) {
		FractalColour = clrRed;
	} else if (FractalLevel < Bid) {
		FractalColour = clrLawnGreen;
	} else {
		FractalColour = clrGray;
	}
   
	if (HighOrLow == "High") {
		StringConcatenate(name, "Fractal High Line ", FractalCount);
	} else if (HighOrLow == "Low") {
		StringConcatenate(name, "Fractal Low Line ", FractalCount);
	}

	int start = 0; // bar index
	int count = 1; // number of bars
	datetime CurrentBarTime[]; // array storing the returned bar time
	CopyTime(Symbol(), FractalTF, start, count, CurrentBarTime);

	ObjectCreate(myChartID, name, OBJ_TREND, 0, CurrentBarTime[0], FractalLevel, FractalTime, FractalLevel, 0, 0);
	ObjectSetInteger(myChartID, name, OBJPROP_STYLE, FractalStyle);
	ObjectSetInteger(myChartID, name, OBJPROP_COLOR, FractalColour);
	ObjectSetInteger(myChartID, name, OBJPROP_WIDTH, FractalThickness);
	ObjectSetInteger(myChartID, name, OBJPROP_RAY, false);
	ObjectSetInteger(myChartID, name, OBJPROP_BACK, true);
	ObjectSetInteger(myChartID, name, OBJPROP_SELECTABLE, false);
	ObjectSetInteger(myChartID, name, OBJPROP_HIDDEN, true);
}