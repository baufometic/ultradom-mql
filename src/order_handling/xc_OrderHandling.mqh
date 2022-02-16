#define BUYMARKET 0
#define BUYLIMIT  1

class cOrders {
	public:
		//____________________ SHOW POSITIONS ____________________
		void ShowPositions() {
		     ResetLastError();
		     
		     MqlTradeRequest request={0};
		     MqlTradeResult  result={0};
		     
		     int total = OrdersTotal();
		     
		     for(int i = (total-1); i >= 0; i--) {
		          ulong  order_ticket=OrderGetTicket(i);                   // order ticket
		          ulong  magic=OrderGetInteger(ORDER_MAGIC);               // MagicNumber of the order
		          
		          //--- zeroing the request and result values
		          ZeroMemory(request);
		          ZeroMemory(result);
		          
		          //--- setting the operation parameters     
		          request.action=TRADE_ACTION_REMOVE;                   // type of trade operation
		          request.order = order_ticket;                         // order ticket
		          
		          
		          //--- send the request
		          if (!OrderSend(request,result)) {
		               Log.Write("ORDER SEND ERROR ON CANCEL");
		          }
		          
		          //--- information about the operation
		          Log.Write((string)result.retcode + " " + (string)result.deal + " " + (string)result.order);
		     }
		     
		     if (OrdersTotal() == 0) {
		     }
		}
		     
		//____________________ BUY LIMIT BRACKETS ____________________
		void BuyLimitWithBrackets(double BuyLimitPrice) {
		     ResetLastError();
		     
		     MqlTradeRequest     request={0};
		     MqlTradeResult      result={0};
		     
		     request.action      = TRADE_ACTION_PENDING;
		     request.symbol      = Symbol();
		     request.volume      = LotSize;
		     request.deviation   = 0;
		     request.type        = ORDER_TYPE_BUY_LIMIT;
		     request.price       = BuyLimitPrice;
		     
		     double SL           = BuyLimitPrice - (SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * StopLossInTicks);
		     double TP           = BuyLimitPrice + (SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * TakeProfitInTicks);
		     request.sl          = SL;
		     request.tp          = TP;
		     
		     if (OrderSend(request, result)) {
		          PERF_TIMER_LAP();
		     } else {
		          Log.Write("BUY LIMIT FAILED");
		     }
		}
		
		//____________________ BUY LIMIT NO BRACKETS ____________________
		void BuyLimitNoBrackets(double BuyLimitPrice) {
		     ResetLastError();
		     
		     MqlTradeRequest     request = {0};
		     MqlTradeResult      result  = {0};
		     
		     request.action      = TRADE_ACTION_PENDING;
		     request.symbol      = Symbol();
		     request.volume      = LotSize;
		     request.deviation   = 0;
		     request.type        = ORDER_TYPE_BUY_LIMIT;
		     request.price       = BuyLimitPrice;
		     
		     if (OrderSend(request, result)) {
		          PERF_TIMER_LAP();
		     } else {
		          Log.Write("BUY LIMIT FAILED");
		     }
		}
		
		//____________________ SELL LIMIT BRACKETS ____________________
		void SellLimitWithBrackets(double SellLimitPrice) {
		     ResetLastError();
		     
		     MqlTradeRequest     request={0};
		     MqlTradeResult      result={0};
		     
		     request.action      = TRADE_ACTION_PENDING;
		     request.symbol      = Symbol();
		     request.volume      = 1;
		     request.deviation   = 0;
		     request.type        = ORDER_TYPE_SELL_LIMIT;
		     request.price       = SellLimitPrice;
		     
		     double SL           = SellLimitPrice + (SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * StopLossInTicks);
		     double TP           = SellLimitPrice - (SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * TakeProfitInTicks);
		     request.sl          = SL;
		     request.tp          = TP;
		     
		     if (OrderSend(request, result)) {
		          PERF_TIMER_LAP();
		     } else {
		          Log.Write("SELL LIMIT FAILED");
		     }
		}
		
		//____________________ SELL LIMIT NO BRACKETS ____________________
		void SellLimitNoBrackets(double SellLimitPrice) {
		     ResetLastError();
		     
		     MqlTradeRequest     request={0};
		     MqlTradeResult      result={0};
		     
		     request.action      = TRADE_ACTION_PENDING;
		     request.symbol      = Symbol();
		     request.volume      = 1;
		     request.deviation   = 0;
		     request.type        = ORDER_TYPE_SELL_LIMIT;
		     request.price       = SellLimitPrice;
		     
		     if (OrderSend(request, result)) {
		          PERF_TIMER_LAP();
		     } else {
		          Log.Write("SELL LIMIT FAILED");
		     }
		}
		
		//========== CANCEL ALL ==========
		void CancelAll() {
		     ResetLastError();
		     
		     MqlTradeRequest request={0};
		     MqlTradeResult  result={0};
		     
		     int total = OrdersTotal();
		     
		     for(int i = (total-1); i >= 0; i--) {
		          ulong  order_ticket=OrderGetTicket(i);                   // order ticket
		          ulong  magic=OrderGetInteger(ORDER_MAGIC);               // MagicNumber of the order
		          
		          //--- zeroing the request and result values
		          ZeroMemory(request);
		          ZeroMemory(result);
		          
		          //--- setting the operation parameters     
		          request.action=TRADE_ACTION_REMOVE;                   // type of trade operation
		          request.order = order_ticket;                         // order ticket
		          
		          //--- send the request
		          if (!OrderSend(request,result)) {
		               Log.Write("ORDER SEND ERROR ON CANCEL");
		          }
		          
		          //--- information about the operation
		          Log.Write((string)result.retcode + " " + (string)result.deal + " " + (string)result.order);
		     }
		     
		     if (OrdersTotal() == 0) {
		     }
		}
};
cOrders Orders;