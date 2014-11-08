package base.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class UIEvent extends Event 
	{
		static public const SHOW_HINT:String = "showHint";
		static public const UPDATE_HINTS:String = "updateHints";
		static public const POPUP_OPEN:String = "popupOpen";
		static public const POPUP_CLOSE:String = "popupClose";
		static public const CLEAR_HINT:String = "clearHint";
		static public const SHOW_WARNING:String = "showWarning";
		static public const SHOW_MOUSE_OVER_TEXT:String = "showMouseOverText";
		static public const START_DRAG_INVENTORY_ITEM:String = "startDragInventoryItem";
		static public const STOP_DRAG_INVENTORY_ITEM:String = "stopDragInventoryItem";
		static public const PICKUP_ITEM:String = "pickupItem";
		static public const PLAYER_DROP_ITEM:String = "playerDropItem";
		static public const USABLE_ITEM_SELECTED:String = "usableItemSelected";
		
		private var _data:*
		
		public function UIEvent(type:String, data:* = null) 
		{ 
			super(type, false, false);
			_data = data;
		} 
		
		public override function clone():Event 
		{ 
			return new UIEvent(type, _data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("UIEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():* 
		{
			return _data;
		}
		
	}
	
}