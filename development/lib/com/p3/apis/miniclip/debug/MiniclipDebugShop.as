package com.p3.apis.miniclip.debug 
{
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import com.miniclip.events.AuthenticationEvent;
	import com.p3.apis.miniclip.MiniclipHandler;
	import com.p3.apis.miniclip.store.MiniclipStoreEvent;
	import com.p3.apis.miniclip.store.MiniclipStoreProduct;
	import com.p3.apis.miniclip.store.MiniclipStoreProductList;
	import com.p3.loading.browser.P3FileBrowser;
	import com.p3.loading.browser.P3FileBrowserEvent;
	import com.p3.utils.functions.P3BytesToXML;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipDebugShop extends Window 
	{
		
		private var m_btn_update:PushButton;
		private var m_btn_export:PushButton;
		private var m_btn_import:PushButton;
		private var m_btn_topup:PushButton;
		private var m_lgt_LoggedIn:IndicatorLight;
		private var m_lbl_creditBalance:Label;
		protected var m_list_products:com.bit101.components.List;
		
		protected var m_panel_product:MiniclipDebugPanelProduct;
		
		public function MiniclipDebugShop(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Miniclip Shop") 
		{
			_width = 800;
			_height = 600;
		
			super(parent, xpos, ypos, title);
			hasMinimizeButton = true;
			addListeners();
		}
		
		override protected function init():void 
		{
			super.init();
			m_btn_update = new PushButton (this, 4, 4, "Update", onClickUpdateShop);
			m_btn_update.width = 60;
			m_btn_export = new PushButton (this, 200, 4, "Export", onClickExport);
			m_btn_export.width = 60;
			m_btn_import = new PushButton (this, 264, 4, "Import", onClickImport);
			m_btn_import.width = 60;
			m_btn_topup = new PushButton (this, 340, 4, "Topup", onClickTopup);
			m_btn_topup.width = 60;
			//m_btn_topup.enabled = false;
			m_list_products = new com.bit101.components.List (this, 0, 30);
			m_lbl_creditBalance = new Label (this, 70, 4, "Log in for credits");
			m_panel_product = new MiniclipDebugPanelProduct (this,100,30);
		}
		
		private function onClickTopup(event:MouseEvent):void 
		{
			MiniclipHandler.instance.store.requestTopup();
		}
		
		private function onClickImport($event:MouseEvent):void 
		{
			P3FileBrowser.ins.addEventListener(P3FileBrowserEvent.LOADED, onLoadedImportData)
			P3FileBrowser.ins.browse($event);
		}
		
		private function onLoadedImportData(e:P3FileBrowserEvent):void 
		{
			MiniclipHandler.instance.store.importXML(P3BytesToXML(P3FileBrowser.ins.data));
		}
		
		private function onClickExport($event:MouseEvent):void 
		{
			P3FileBrowser.ins.save($event, MiniclipHandler.instance.store.exportXML(), ".xml");
		}
		
		private function addListeners():void 
		{
			MiniclipHandler.instance.store.addEventListener(MiniclipStoreEvent.BALANCE_UPDATE, onBalanceUpdate);
			MiniclipHandler.instance.store.addEventListener(MiniclipStoreEvent.PRODUCT_PURCHASED, onPurchase);
			MiniclipHandler.instance.store.addEventListener(MiniclipStoreEvent.ITEMS_UPDATE, onProductsUpdate);
			MiniclipHandler.instance.store.addEventListener(MiniclipStoreEvent.ITEMS_OWNED_UPDATE, onItemsOwnedUpdate);
			MiniclipHandler.instance.addEventListener(AuthenticationEvent.USER_DETAILS, onUserDetails);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onUserDetails(e:AuthenticationEvent):void 
		{
			m_lbl_creditBalance.text = "Credits : ???";
			m_btn_topup.enabled = true;
		}
		
		private function onItemsOwnedUpdate(e:MiniclipStoreEvent):void 
		{
			//MiniclipHandler.instance.logError("MiniclipStoreProductList total owned items= " + MiniclipHandler.instance.store.items.getAllItems().length);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			width = 400;
			height = stage.stageHeight - 120;
			m_list_products.height = height - 54; 
		}
		
		private function onClickUpdateShop(e:MouseEvent = null):void 
		{
			MiniclipHandler.instance.store.requestProductsList();
			MiniclipHandler.instance.store.requestBalance();
			//MiniclipHandler.instance.store.updateBalance();
		}

		private function setProductList ($list:MiniclipStoreProductList):void
		{
			var allItems:Vector.<MiniclipStoreProduct> = $list.getAllProducts();
			MiniclipHandler.instance.logError("MiniclipStoreProductList total products= " + allItems.length);
			m_list_products.removeAll();
			for each (var item:MiniclipStoreProduct in allItems)
			{
				m_list_products.addItem( { label:item.name, product:item } );
			}
			m_list_products.addEventListener(Event.SELECT, onProductListSelected);
		}
		
		private function onProductListSelected(e:Event):void 
		{
			var item:Object = m_list_products.selectedItem;
			var product:MiniclipStoreProduct = item.product;
			m_panel_product.setProduct(product);
		}
		
		private function onPurchase(e:MiniclipStoreEvent):void 
		{
			
		}
		
		private function onProductsUpdate(e:MiniclipStoreEvent):void 
		{
			//setProductList(MiniclipHandler.instance.store.products);
			m_panel_product.setItemList(MiniclipHandler.instance.store.items);
		}
		
	
		private function onBalanceUpdate(e:MiniclipStoreEvent):void 
		{
			m_lbl_creditBalance.text = "Credits = " + MiniclipHandler.instance.store.balance;
			
		}
		
		
	}

}