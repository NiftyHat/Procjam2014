package game.ui.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class KillEvent extends Event 
	{
		
		public static const REGISTER_KILL:String = "UI_KE<--REGISTER_KILL";
		
		public static const KILLTYPE_WIZARD:String = "WIZARD";
		public static const KILLTYPE_BESERKER:String = "BESERKER";
		public static const KILLTYPE_THIEF:String = "THIEF";
		
		public var killType:String;
		
		public function KillEvent(type:String, killType:String) 
		{ 
			super(type, false, false);
			this.killType = killType;
			
		} 
		
		public override function clone():Event 
		{ 
			return new KillEvent(type, killType);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("KillEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}