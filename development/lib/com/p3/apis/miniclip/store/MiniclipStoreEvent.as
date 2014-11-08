package com.p3.apis.miniclip.store 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipStoreEvent extends Event 
	{
		static public const BALANCE_UPDATE:String = "balanceUpdate";
		static public const ITEMS_OWNED_UPDATE:String = "itemsOwnedUpdate";
		static public const ITEMS_UPDATE:String = "itemsUpdate";
		static public const PRODUCT_PURCHASED:String = "productPurchased";
		static public const ENABLED:String = "enabled";
		static public const ERROR:String = "error";
		static public const ITEMS_PURCHASED:String = "itemsPurchased";
		static public const PURCHASE_FAILED:String = "purchaseFailed";
		
		protected var m_data:*
		
		public function MiniclipStoreEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			m_data = data;
		} 
		
		public override function clone():Event 
		{ 
			return new MiniclipStoreEvent(type, m_data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MiniclipStoreEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():* 
		{
			return m_data;
		}
		
	}
	
}