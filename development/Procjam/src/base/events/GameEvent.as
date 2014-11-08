package base.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class GameEvent extends Event 
	{
		static public const MUTE:String = "mute";
		static public const UNMUTE:String = "unmute";
		static public const PAUSE:String = "game_pause";
		static public const RESUME:String = "game_resume";
		static public const LOG:String = "log";
		static public const LEVEL_COMPLETE:String = "levelComplete";
		static public const END:String = "end";
		
		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new GameEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GameEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}