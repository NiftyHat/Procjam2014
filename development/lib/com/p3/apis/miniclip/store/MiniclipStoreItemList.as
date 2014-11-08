package com.p3.apis.miniclip.store 
{
	import com.miniclip.gamemanager.currencies.CurrencyItem;
	import com.miniclip.gamemanager.currencies.CurrencyUserQuantity;
	import com.p3.apis.miniclip.MiniclipHandler;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipStoreItemList 
	{
		
		protected var m_items_vec:Vector.<MiniclipStoreItem>;
		protected var m_items_dict:Dictionary;
		
		public function MiniclipStoreItemList() 
		{
			m_items_vec = new Vector.<MiniclipStoreItem> ();
			m_items_dict = new Dictionary ();
		}
		
		internal function addItem ($item:MiniclipStoreItem):void
		{
			var currentItem:MiniclipStoreItem = getItemByID($item.id);
			if (currentItem) 
			{
				MiniclipHandler.instance.store.logWarning("Miniclip Store WARNING: " + " already has item at id " + currentItem + " aborting"); 
				return;
				//m_items_vec.splice(m_items_vec.indexOf(currentItem), 1);
			}
			//if (m_items_vec.length < $product.id) m_items_vec.length = $product.id
			m_items_dict[$item.id] = $item;
			m_items_vec.push($item);
		}
		
		internal function addCurrencyItem ($currencyItem:CurrencyItem):void 
		{
			var id:int = $currencyItem.id;
			var itemAtID:MiniclipStoreItem = getItemByID (id);
			if (itemAtID)
			{
				MiniclipHandler.instance.store.logWarning("Miniclip Store WARNING: " + " updating item at id " + itemAtID + " aborting"); 
				itemAtID.fromCurrencyItem($currencyItem)
			}
			else
			{
				var newItem:MiniclipStoreItem = new MiniclipStoreItem ()
				newItem.fromCurrencyItem($currencyItem)
				addItem(newItem);
			}
		}
		
		public function getItemByID ($id:int):MiniclipStoreItem
		{
			if (!hasItemAtID($id)) 
			{
				//trace ("Miniclip Store WARNING: " + " no item at id: " + $id);
				return null;
			}
			return m_items_dict[$id];
		}
		
		public function getAllItems ():Vector.<MiniclipStoreItem>
		{
			return m_items_vec;
		}
		
		public function getAllOwnedItems ():Vector.<MiniclipStoreItem>
		{
			return m_items_vec.filter(filterOwnedItem);
		}
		
		private function filterOwnedItem(item:MiniclipStoreItem, index:int, vector:Vector.<MiniclipStoreItem>):Boolean 
		{
			if (item.qty > 0) return true;
			else return false;
		}
		
		public function hasItemAtID ($id:int):Boolean
		{
			return m_items_dict[$id] != null && m_items_dict[$id] != undefined;
		}
		
		public function updateQuantity($userQuantity:CurrencyUserQuantity):void 
		{
			getItemByID($userQuantity.itemId).qty = $userQuantity.quantity;
		}
		


		
		

	}

}