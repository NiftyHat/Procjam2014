package com.p3.apis.miniclip.store 
{
	//import aholla.screenManager.ScreenManager;
	import com.miniclip.events.CurrenciesEvent;
	import com.miniclip.gamemanager.GameCurrencies;
	import com.miniclip.MiniclipGameManager;
	import flash.events.ErrorEvent;
	import flash.system.Security;
	//import gfx.screens.ClipWarningPopup;
	//import screens.popups.WarningPopupScreen;

	import com.p3.apis.miniclip.MiniclipHandler;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	[Event(name="productsUpdate", type="com.p3.apis.miniclip.store.MiniclipStoreEvent")]
	[Event(name="balanceUpdate", type="com.p3.apis.miniclip.store.MiniclipStoreEvent")]
	[Event(name="productPurchased", type="com.p3.apis.miniclip.store.MiniclipStoreEvent")]
	[Event(name="itemsOwnedUpdate", type="com.p3.apis.miniclip.store.MiniclipStoreEvent")]
	[Event(name="enabled", type="com.p3.apis.miniclip.store.MiniclipStoreEvent")]
	public class MiniclipStoreHandlerOld extends EventDispatcher
	{
		private var m_version_string:String = "0.3";
		private var _isLoggedIn:Boolean;
		
		protected var m_control:GameCurrencies;
		protected var m_balance:int;
		protected var m_isEnabled:Boolean = false;
		
		protected var m_products:MiniclipStoreProductList;
		protected var m_items:MiniclipStoreItemList;
		
		public function MiniclipStoreHandlerOld() 
		{
			Security.loadPolicyFile("https://playerthree.developers.miniclip.com/crossdomain.xml");
		}
		
		public function init():void
		{
			//MiniclipGameManager.currencies
			
			m_control  = MiniclipGameManager.currencies;
			m_products = new MiniclipStoreProductList ();
			m_items = new MiniclipStoreItemList ();
			
			addListeners();
			trace("miniclip store init" + m_control);
			m_control.init();
		}
		
		public function purchaseProduct($id:int,$price:int):void
		{
			//TODO - fix this to check user login state on handler Duncan.S May 2012
			var isLoggedIn:Boolean = MiniclipHandler.instance.isLoggedIn;
			var product:MiniclipStoreProduct = m_products.getProductByID($id);
			//m_control.purchaseProduct($id, product.credit_cost, product.name, !isLoggedIn);
		}
		
		public function exportXML ():XML
		{
			var xml:XML = new XML(<STORE><PRODUCTS></PRODUCTS></STORE>);
			var allProducts:Vector.<MiniclipStoreProduct> = m_products.getAllProducts();
			for each (var item:MiniclipStoreProduct in allProducts)
			{
				xml.PRODUCTS.appendChild(item.toXML());
			}
			return xml;
		}
		
		public function importXML ($xml:XML ):void
		{
			var xml:XML = $xml;
			for each (var item:XML in $xml.PRODUCTS.*)
			{
				var newProduct:MiniclipStoreProduct = new MiniclipStoreProduct ()
				newProduct.fromXML(item);
				m_products.addProduct(newProduct);
			}
			dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.PRODUCTS_UPDATE, this));
		}
		
		private function addListeners():void 
		{
			m_control.addEventListener(CurrenciesEvent.READY, onCurrenciesReady);
			m_control.addEventListener(CurrenciesEvent.BALANCE, onBalanceUpdate);
			m_control.addEventListener(CurrenciesEvent.ERROR, onError);
			m_control.addEventListener(CurrenciesEvent.GET_BUNDLES, onGetAllProducts);
			//m_control.addEventListener(CreditsEvent.GET_PRODUCT_BY_GAME_ID, onGetAllProducts);
			m_control.addEventListener(CurrenciesEvent.GET_ITEM_BY_ID, onGetOwnedProducts);
			m_control.addEventListener(CurrenciesEvent.BUNDLE_PURCHASED, onProductPurchased);
		}
		
		private function onCurrenciesReady(e:CurrenciesEvent):void 
		{
			requestProductsList();
		}
		

		
		private function updateOwnedProducts($array:Array):void 
		{
			for each (var item:Object in $array)
			{
				m_items.addOwnedItem(item);
			}
			dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ITEMS_OWNED_UPDATE, this));
		}
		
		private function onProductPurchased(e:CurrenciesEvent):void 
		{
			var result:Object = e.data.result;
			dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.PRODUCT_PURCHASED, this));
			updateProducts([m_products.getProductByID(result.product_id)]);
			updateBalance(result.balance);
		}

		protected function updateBalance ($new_balance:int):void
		{
			m_balance = $new_balance;
			dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.BALANCE_UPDATE,this));
		}
		
		protected function updateProducts ($array:Array):void
		{
			for each (var item:Object in $array)
			{
				if (!(item is MiniclipStoreProduct)) m_products.addRawProduct(item);
				else m_products.addProduct(item as MiniclipStoreProduct);
			}
			dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.PRODUCTS_UPDATE, this));
			m_control.getUserItemsByGameId();
		}
		
	
		
		private function onError(e:CurrenciesEvent):void 
		{
			logWarning("generalError; " + e.data);
		}
	
		
		public function topupCredits ():void
		{
			if (MiniclipHandler.instance.isMiniclip)
			{
				m_control.topupCurrency();
			}
			else
			{
				//ScreenManager.inst.addScreen(new WarningPopupScreen ("Can't Buy Credits", "Buy Credits will only work within the miniclip.com domain"));
			}
			
		}
		
				
		public function requestProductsList ():void
		{
			m_control.getBundles(0,[0]);
			
		}
		
		public function requestBalance ():void
		{
			m_control.getBalance(0);
		}
		
		private function onGetProduct(e:CurrenciesEvent):void 
		{
			if (!e.data.success) 
			{
				logWarning("onGetProducts failed; Error id " + e.data.result);
				return;
			}
			
			updateProducts([e.data.result]);
			
		}
		
		private function onGetAllProducts(e:CurrenciesEvent):void 
		{
			if (!e.data.success) 
			{
				logWarning("onGetAllProducts failed; Error id " + e.data.result);
				return;
			}
			if (!m_isEnabled)
			{
				dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ENABLED, this));
				logWarning("initilize MiniclipStoreHandler " + m_version_string);
				m_isEnabled = true;
			}
			updateProducts(e.data.result)
		}
		
		private function onGetOwnedProducts(e:CurrenciesEvent):void 
		{
			if (!e.data.success) 
			{
				logWarning("onGetAllProducts failed; Error id " + e.data.result);
				updateOwnedProducts([]);
				return;
			}
			updateOwnedProducts(e.data.result);
			//dispatchEvent(new MiniclipStoreEvent(MiniclipStoreEvent.ITEMS_OWNED_UPDATE, this));
		}
				
		private function onBalanceUpdate(e:CurrenciesEvent):void 
		{
			if (!e.data.success) 
			{
				logWarning("onBalanceUpdate failed; Error id " + e.data.result);
				return;
			}
			var new_balance:int = e.data.result
			_isLoggedIn = true;
			updateBalance(new_balance);
		}
		
		public function get balance():int 
		{
			return m_balance;
		}
		
		public function get products():MiniclipStoreProductList 
		{
			return m_products;
		}
		
		public function get isEnabled ():Boolean
		{
			return (m_control != null);
		}
		
		public function get items():MiniclipStoreItemList 
		{
			return m_items;
		}
		
		public function get isLoggedIn():Boolean 
		{
			return _isLoggedIn;
		}
		
	}

}