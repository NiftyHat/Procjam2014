package axengine.events 
{
	import axengine.world.level.AxLevel;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxLevelEvent extends Event 
	{
		static public const LOAD_STARTED:String = "loadStarted";
		static public const LOAD_FINISHED:String = "loadFinished";
		static public const END:String = "levelEnd";
		static public const RESTART:String = "levelRestart";
		static public const QUIT:String = "levelQuit";
		
		protected var _level:AxLevel
		
		public function AxLevelEvent(type:String, level:AxLevel = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			_level = level;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AxLevelEvent(type, _level, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AxLevelEvent", "level", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get level():AxLevel 
		{
			return _level;
		}
		
	}
	
}