package com.p3.audio.soundcontroller.events 
{
	import com.p3.audio.soundcontroller.objects.P3SoundObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders - PlayerThree 2012
	 */
	public class P3SoundEvent extends Event 
	{
		static public const PLAY:String = "play";
		static public const COMPLETE:String = "complete";
		static public const DESTROY:String = "destroy";
		static public const GROUP_UPDATE:String = "groupUpdate";
		static public const PRE_DESTROY:String = "preDestroy";
		static public const LOADED:String = "loaded";
		
		private var _sound:P3SoundObject;
	
		
		public function P3SoundEvent(type:String, sound:P3SoundObject, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_sound = sound;
		} 
		
		public override function clone():Event 
		{ 
			return new P3SoundEvent(type, _sound, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("P3SoundEvent", "type", "sound" ,"bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get sound():P3SoundObject 
		{
			return _sound;
		}
		
		
	}
	
}