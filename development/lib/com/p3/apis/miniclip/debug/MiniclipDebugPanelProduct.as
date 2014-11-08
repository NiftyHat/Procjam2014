package com.p3.apis.miniclip.debug 
{
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import com.greensock.loading.core.DisplayObjectLoader;
	import com.p3.apis.miniclip.MiniclipHandler;
	import com.p3.apis.miniclip.store.MiniclipStoreItem;
	import com.p3.apis.miniclip.store.MiniclipStoreItemList;
	import com.p3.apis.miniclip.store.MiniclipStoreProduct;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipDebugPanelProduct extends Panel
	{
		private var m_item:MiniclipStoreItem;
		
		protected var m_product:MiniclipStoreProduct;
		protected var m_text_productInfo:TextArea;
		protected var m_text_itemInfo:TextArea;
		protected var m_list_items:com.bit101.components.List;
		protected var m_lbl_items:Label;
		protected var m_lbl_productInfo:Label;
		protected var m_lbl_itemInfo:Label;
		protected var m_btn_purchase:PushButton = new PushButton ();
		
		public function MiniclipDebugPanelProduct(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			init();
			super(parent, xpos, ypos);
			
		}
		

		override protected function init():void 
		{
			super.init();
			height = 300;
			width = 300;
			m_list_items = new com.bit101.components.List (this as DisplayObjectContainer, 2, 2);
			m_list_items.y = 20
			m_list_items.enabled = false;
			//m_items_list.y = m_text_dump.height + 2;
			m_list_items.height = height- 45;
			m_text_productInfo = new TextArea (this as DisplayObjectContainer, 2, 2, "textDump")
			m_text_productInfo.y = 20;
			m_text_productInfo.x = m_list_items.x + m_list_items.width + 2;
			//m_text_productInfo.enabled = false;
			m_text_productInfo.autoHideScrollBar = true;
			m_text_productInfo.width = 188;
			m_text_productInfo.height = 126;
			m_text_itemInfo = new TextArea (this as DisplayObjectContainer, 2, 2, "textDump")
			m_text_itemInfo.y = m_text_productInfo.y + m_text_productInfo.height + 20;
			m_text_itemInfo.x = m_list_items.x + m_list_items.width + 2;
			//m_lbl_itemInfo.enabled = false;
			m_text_itemInfo.autoHideScrollBar = true;
			m_text_itemInfo.width = 188;
			m_text_itemInfo.height = 126;
			m_btn_purchase = new PushButton (this, 2, height - m_btn_purchase.height-  2, "Purchase", onClickPurchase);
			m_lbl_items = new Label (this, 24, 2, "+ Items + ");
			m_lbl_productInfo = new Label (this, 0, 2, "+ Product Info +");
			m_lbl_productInfo.autoSize = true;
			m_lbl_productInfo.x = m_text_productInfo.x + (m_text_productInfo.width - m_lbl_productInfo.width) * 0.5;
			m_lbl_itemInfo = new Label (this, 0, 2, "+ Item Info +");
			m_lbl_itemInfo.autoSize = true;
			m_lbl_itemInfo.y = m_text_itemInfo.y - 20;
			m_lbl_itemInfo.x = m_text_itemInfo.x + (m_text_itemInfo.width - m_lbl_itemInfo.width) * 0.5;
		}
		
		
		public function setItemList ($list:MiniclipStoreItemList):void
		{
			var allItems:Vector.<MiniclipStoreItem> = $list.getAllItems();
			MiniclipHandler.instance.logError("MiniclipStoreItemList total products= " + allItems.length);
			
			m_list_items.removeAll();
			for each (var item:MiniclipStoreItem in allItems)
			{
				m_list_items.addItem( { label:item.name, item:item } );
			}
			m_list_items.addEventListener(Event.SELECT, onSelectItem);
			m_list_items.enabled = true;
		}
		
		private function onSelectItem(e:Event):void 
		{
			var selectedItem:Object = m_list_items.selectedItem;
			if (selectedItem)
			{
				var item:MiniclipStoreItem = selectedItem.item;
				setItem(item);
			}
			
		}
		
		private function onClickPurchase(e:MouseEvent):void 
		{
			if (m_item) 
			{
				MiniclipHandler.instance.store.purchaseItem(m_item.id,0);
			}
		}
		
		public function setItem ($item:MiniclipStoreItem ):void
		{
			var text:String = $item.printDebug();
			m_text_itemInfo.text = text;
			m_item = $item;
		}
		
		public function setProduct ($product:MiniclipStoreProduct):void
		{
			
			var text:String = $product.printDebug();
			m_product = $product;
			m_text_productInfo.text = text;
			m_list_items.selectedIndex = -1;
			m_list_items.removeAll();
			//for each (var item:MiniclipStoreItem in $product.items)
			//{
				//m_list_items.enabled = true;
				//m_list_items.addItem({label:item.name, item:item});
			//}
		}
		
	}

}