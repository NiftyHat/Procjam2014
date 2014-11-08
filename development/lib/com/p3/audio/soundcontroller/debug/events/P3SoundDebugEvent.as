package com.p3.audio.soundcontroller.debug.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3SoundDebugEvent extends Event 
	{
		static public const PLAY_SOUND:String = "playSound";
		static public const GROUP_ADDED:String = "groupAdded";
		static public const GROUP_UPDATE:String = "groupUpdate";
		
		private var _data:*
		
		public function P3SoundDebugEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_data = data;
		} 
		
		public override function clone():Event 
		{ 
			return new P3SoundDebugEvent(type, _data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("P3SoundDebugEvent", "type", "data", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():* 
		{
			return _data;
		}
		
	}
	
}