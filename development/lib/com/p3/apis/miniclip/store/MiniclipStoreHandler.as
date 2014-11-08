package com.p3.apis.miniclip.store 
{
	import com.miniclip.events.AuthenticationEvent;
	import com.miniclip.gamemanager.currencies.CurrencyBalance;
	import com.miniclip.gamemanager.currencies.CurrencyCurrency;
	import com.miniclip.gamemanager.currencies.CurrencyItem;
	import com.miniclip.gamemanager.currencies.CurrencyPrice;
	import com.miniclip.gamemanager.currencies.CurrencyUserQuantity;
	import com.miniclip.MiniclipGameManager;
	import com.p3.apis.miniclip.MiniclipHandler;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	 import com.miniclip.MiniclipAPI;
	 import com.miniclip.events.CurrenciesEvent;
	 import com.miniclip.gamemanager.GameCurrencies;
	 import flash.events.TimerEvent;
	 import flash.utils.Timer;
	 //import com.miniclip.gamemanager.currencies.
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipStoreHandler extends EventDispatcher 
	{
		
		protected var _items:MiniclipStoreItemList = new MiniclipStoreItemList ();
		protected var _bundles:MiniclipStoreProductList = new MiniclipStoreProductList ();
		protected var _currencies:MiniclipStoreCurrencyList = new  MiniclipStoreCurrencyList ();
		
		protected var _defaultCurrencyID:int;
		protected var _defaultBalance:CurrencyBalance;
		protected var _isRefreshWaiting:Boolean = true;
		protected var _timerRefresh:Timer;
		
		public function MiniclipStoreHandler ()
		{
			
		}
		
		public function init($forceRefresh:Boolean = false):void
		{
			if ($forceRefresh) _isRefreshWaiting = true;
			if (_isRefreshWaiting) initCurrencies();
		}
        
         
         public function initCurrencies():void
         {
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.READY, onCurrenciesInit);
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.ERROR, onCurrenciesError);
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.PURCHASED, onItemsPurchased);
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.GET_ITEMS_BY_GAME_ID, onGetItems);
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.PURCHASE_FAILED, onPurchaseFailed);
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.PURCHASE_CANCELLED_BY_USER, onPurchaseCancled);
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.BALANCES, onGetBalances);
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.BALANCE, onGetBalance);
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.USER_ITEMS_BY_GAME_ID, onGetUserItems);
			 MiniclipAPI.currencies.addEventListener(CurrenciesEvent.GIVE_ITEM, onItemGiven);
			 MiniclipGameManager.addEventListener(AuthenticationEvent.USER_DETAILS, onPlayerLogin);
			 MiniclipGameManager.addEventListener(AuthenticationEvent.LOGOUT, onPlayerLogout);
			 MiniclipAPI.currencies.init();
         }
		 
		 private function onPurchaseCancled(e:CurrenciesEvent):void 
		 {
			  var copy:String = "user cancled transaction"			
			 dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.PURCHASE_FAILED, copy));
		 }
		 
		 private function onPurchaseFailed(event:CurrenciesEvent):void 
		 {
			 var copy:String = "item purchase failed "
			if (event.data.result)
			{
				copy += "error code: "  + event.data.result.toString();
			}
			
			 dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.PURCHASE_FAILED, copy));
		 }
		 

		 
		 private function onItemGiven(e:CurrenciesEvent):void 
		 {
			var items:Vector.<CurrencyUserQuantity> = new Vector.<CurrencyUserQuantity>
			if (e.data.result && e.data.result is CurrencyUserQuantity)
			{
				items.push(e.data.result);
				addItems(items);
				dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ITEMS_UPDATE, this));
			}
			else {
				 dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ERROR, "Failed to give free item. Error code " + e.data.result));
			}
			
		 }
		 
		 private function onPlayerLogin(e:AuthenticationEvent):void 
		 {
			 requestBalance();
			 MiniclipAPI.currencies.getUserItemsByGameId();
		 }
		 
		 private function onGetItems(event:CurrenciesEvent):void 
		 {
			 var items : Vector.<CurrencyItem> = event.data.result.items as Vector.<CurrencyItem>;
			 if (items)
			 {
				 setItems(items);
			 }
			 requestBalance();
		 }
		 
		 		 
		 private function onPlayerLogout(e:AuthenticationEvent):void 
		 {
			 _defaultBalance = null
			 //_currencies = new  MiniclipStoreCurrencyList ();
			 requestProductsList();
		 }
		 
		 public function setBalances($balances:Vector.<CurrencyBalance>):void
		 {
			  for each (var balance : CurrencyBalance in $balances)
				 {
					 // for each of the balances, display the information
					 trace( "Successfully obtained balance for currency: " + balance.currencyId );
					 trace( "New balance: " + balance.balance );
					 trace( "Currency Code: " + balance.currency.code );
					 if (balance.currencyId == _defaultCurrencyID)
					 {
						 _defaultBalance = balance;
					 }
				 }
				  dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.BALANCE_UPDATE, this));
		 }
		 
		 private function setItems($items: Vector.<CurrencyItem>):void 
		 {
			  for each (var item : CurrencyItem in $items)
				 {
					_items.addCurrencyItem(item);
					 if (item.contains)
					 {
						 // This item has child items. We could iterate through them here
						 for each (var child : CurrencyItem in item.contains)
						 {
							 // child in this case will be a CurrencyItem
							 // object. It will not have children of its own, nor will
							 // it have any prices associated with it
							 trace("Child item: " + child.name);
						 }
					 }
				 }
				  dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ITEMS_UPDATE, this));
		 }
		 
		  private function addItems($items:Vector.<CurrencyUserQuantity>):void
		 {
			  logWarning("updated owned items")
				 for each (var userQty:CurrencyUserQuantity in $items)
				 {
					_items.updateQuantity(userQty);
					 logWarning( "Successfully obtained balance for item id: " + userQty.itemId );
					logWarning( "New balance: " + userQty.quantity );
					logWarning( "Item Description: " + userQty.item.description );
				 }
		 }
		 

		 
		public function onGetUserItems( event:CurrenciesEvent ):void
         {
                 MiniclipAPI.currencies.removeEventListener(CurrenciesEvent.USER_ITEMS_BY_GAME_ID, onGetUserItems);
                 //MiniclipAPI.currencies.removeEventListener(CurrenciesEvent.ERROR, onCurrenciesError);
         
                 if (!event.data.success)
                 {
                     trace("Failed to get user items. Code: " + event.data.result);
                     return;
                 }
         
                 var userItems : Vector.<CurrencyUserQuantity> = event.data.result as Vector.<CurrencyUserQuantity>;
                 if (userItems)
                 {
					 addItems(userItems);
                     // Loop through the returned vector of quantities
                     for each (var userQty : CurrencyUserQuantity in userItems)
                     {
						 
                         // for each of the items, display the information
						 trace( "Successfully obtained balance for item id: " + userQty.itemId );
						 trace( "New balance: " + userQty.quantity );
						 trace( "Item Description: " + userQty.item.description );
                     }
                 }
				
         }
		 
		 public function onGetBalances( event:CurrenciesEvent ):void
         {
                 //MiniclipAPI.currencies.removeEventListener(CurrenciesEvent.BALANCES, onGetBalances);
                 //MiniclipAPI.currencies.removeEventListener(CurrenciesEvent.ERROR, onCurrenciesError);
         
                 if (!event.data.success)
                 {
                     trace("Failed to obtain balances. Code: " + event.data.result);
                     return;
                 }
         
                 var balances : Vector.<CurrencyBalance> = event.data.result as Vector.<CurrencyBalance>;
                 if (balances)
                 {
                     // Loop through the returned vector of balances
                    setBalances(balances);
                 }
				
         }
		 
		private function onGetBalance(event:CurrenciesEvent):void 
		{
			if (event.data.success && event.data.result) 
			{
				var balances:Vector.<CurrencyBalance> = new Vector.<CurrencyBalance> ()
				balances.push(event.data.result as CurrencyBalance);
				setBalances(balances);
			}
		}
		 
		
		 private function onItemsPurchased(event:CurrenciesEvent):void 
		 {
			 
			 var purchases : Vector.<CurrencyUserQuantity> = event.data.result as Vector.<CurrencyUserQuantity>;
			 logWarning("on items purchased!")
			 if (purchases)
			 {
				 addItems(purchases)
				  dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ITEMS_PURCHASED, this));
			 }
			 dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ITEMS_UPDATE, this));
			requestBalance();
		 }
         
         public function onCurrenciesInit( event:CurrenciesEvent ):void
         {
			 MiniclipAPI.currencies.removeEventListener(CurrenciesEvent.READY, onCurrenciesInit);
			 //MiniclipAPI.currencies.removeEventListener(CurrenciesEvent.ERROR, onCurrenciesError);
	 
			 if (!event.data.success)
			 {
				 trace("Failed to initialize currencies API. Code: " + event.data.result);
				 return;
			 }
			 
			 var currencies : Vector.<CurrencyCurrency> = event.data.result.currencies as Vector.<CurrencyCurrency>;
	 
			 if (currencies)
			 {
				 // Loop through the returned vector of currencies
				 for each (var currency : CurrencyCurrency in currencies)
				 {
					 if (!_defaultCurrencyID ) _defaultCurrencyID = currency.id;
					_currencies.addRawCurrency(currency);
					 // for each of the currencies, display the information
				 trace( "Successfully obtained currency id: " + currency.id );
				 trace( "Currency Name: " + currency.name );
				 trace( "Currency Code: " + currency.code );
				 }
			 }
	 
			 var items : Vector.<CurrencyItem> = event.data.result.items as Vector.<CurrencyItem>;
			 if (items)
			 {
				 setItems(items);
			  }
			  requestBalance();
			  if (_isRefreshWaiting)
			  {
				   _isRefreshWaiting = false;
				   _timerRefresh = new Timer (1000, 1800);
				   _timerRefresh.addEventListener(TimerEvent.TIMER_COMPLETE, onRefreshTimerComplete);
				   _timerRefresh.start();
			  }
			 
         }
		 
		 private function onRefreshTimerComplete(e:TimerEvent):void 
		 {
			 _isRefreshWaiting = true;
		 }
		  
		  public function logWarning($text:String):void
		{
			var text:String = "Miniclip Store WARNING: " + $text;
			MiniclipHandler.instance.logError(text);
			//trace (text);
		}
         
         public function onCurrenciesError( event:CurrenciesEvent ):void
         {
             MiniclipAPI.currencies.removeEventListener(CurrenciesEvent.READY, onCurrenciesInit);
             //MiniclipAPI.currencies.removeEventListener(CurrenciesEvent.ERROR, onCurrenciesError);
			 if ( event.data && event.data is String) dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ERROR, event.data));
			 else dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ERROR, "Failed to initialize currencies API. Unrecoverable Error."));
			 
             trace( "Failed to initialize currencies API. Unrecoverable Error.");
         }
		 
		 public function importXML($xml:XML):void 
		 {
			 var xml:XML = $xml;
			 for each (var currencyXML:XML in $xml.CURRENCIES.*)
			{
				var newCurrency:MiniclipStoreCurrency = new MiniclipStoreCurrency ()
				newCurrency.fromXML(currencyXML);
				_currencies.addCurrency(newCurrency);
			}
			for each (var itemXML:XML in $xml.ITEMS.*)
			{
				var newItem:MiniclipStoreItem = new MiniclipStoreItem ()
				newItem.fromXML(itemXML);
				_items.addItem(newItem);
			}
			dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ITEMS_UPDATE, this));
		 }
		 
		 public function exportXML():XML 
		 {
			var xml:XML = new XML(<STORE><CURRENCIES></CURRENCIES><ITEMS></ITEMS></STORE>);
			var allItems:Vector.<MiniclipStoreItem> = _items.getAllItems();
			for each (var item:MiniclipStoreItem in allItems)
			{
				xml.ITEMS.appendChild(item.toXML());
			}
			var allCurrencies:Vector.<MiniclipStoreCurrency> =  _currencies.getAllItems()
			for each (var currency:MiniclipStoreCurrency in allCurrencies)
			{
				if (currency)xml.CURRENCIES.appendChild(currency.toXML());				
			}
			return xml;
		 }
		 
		 public function requestProductsList():void 
		 {
			 MiniclipAPI.currencies.getItemsByGameId();
		 }
		 
		 public function requestBalance():void 
		 {
			MiniclipAPI.currencies.getBalances();
		 }
		 
		 public function requestTopup ():void
		 {
			MiniclipAPI.currencies.topupCurrency();
		 }
		 
		 public function getCurrency($id:int):MiniclipStoreCurrency
		 {
			 return _currencies.getCurrencyByID($id)
		 }
		 
		 public function purchaseBundle($id:int):void
		 {
			MiniclipAPI.currencies.purchaseBundle($id, _defaultCurrencyID);
		 }
		 
		 /**
		  * Amount only applys to free items.
		  * @param	$id
		  * @param	credit_cost
		  * @param	$amount
		  */
		 public function purchaseItem($id:int, credit_cost:int = 0, $amount:int = 1):void 
		 {
			if (_items.getItemByID($id).credit_cost <= 0) 
			{
				MiniclipAPI.currencies.giveItem($id, $amount);
				//MiniclipAPI.currencies.getItemsByGameId();
			}
			else {
				MiniclipAPI.currencies.purchaseItem($id, _defaultCurrencyID, false);
			}
			
		 }
		 
		 public function get items():MiniclipStoreItemList 
		 {
			 return _items;
		 }
		 
		 public function get balance():Number {
			 if (_defaultBalance) return _defaultBalance.balance;
			 return 0;
		 }
		 
		 public function get isEnabled ():Boolean {
			 return (MiniclipAPI.currencies != null )
		 }
		 
		 public function get isRefreshWaiting():Boolean 
		 {
			 return _isRefreshWaiting;
		 }
         
		
	}

}