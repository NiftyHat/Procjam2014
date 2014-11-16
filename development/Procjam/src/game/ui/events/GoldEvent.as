package game.ui.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class GoldEvent extends Event 
	{
		public var value:int;
		public static const SET_DUNGEON_TOTAL_GOLD_TO:String = "UI_GE<--SET_DUNGEON_TOTAL_GOLD_TO";
		public static const SET_DUNGEON_CURRENT_GOLD_TO:String = "UI_GE<--SET_DUNGEON_CURRENT_GOLD_TO";
		
		public function GoldEvent(type:String, value:int) 
		{ 
			super(type, false, false);
			this.value = value;
			
		} 
		
		public override function clone():Event 
		{ 
			return new GoldEvent(type, value);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GoldEvent", "type", "value"); 
		}
		
	}
	
}