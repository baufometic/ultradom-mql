void ReadFuturesFile_CME() {
   ResetLastError();
   
   MW3Label("ESTABLISHING CONNECTION TO CME...");
   
   long myStartTime = GetTickCount();
   
   FileName = "TimeAndSales.txt";
   int file_handle = FileOpen(FileName, FILE_SHARE_READ|FILE_TXT);
   int str_size;
   i = 0;
   
   if (file_handle != INVALID_HANDLE) {
      while (!FileIsEnding(file_handle)) {
         str_size = FileReadInteger(file_handle, INT_VALUE);
         str = FileReadString(file_handle, str_size);
         i++;
      }
      
      FileClose(file_handle);
      str = StringConcatenate("Data read & file closed. ", i, " LINES READ IN ", (GetTickCount() - myStartTime), " MS");
      Print(str);
      MW3Label(str);
   } else {
      str = StringConcatenate("Failed to open FUTURES file, Error code ", GetLastError());
      Print(str);
      MW3Label(str);
   }
}
