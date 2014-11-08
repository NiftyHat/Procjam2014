package com.p3.apis.playerio.events 
{
	import flash.events.Event;
	import playerio.PlayerIOError;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class PlayerIOErrorEvent extends Event 
	{
		static public const ERROR:String = "error";
		
		private var _error:PlayerIOError;
		
		public function PlayerIOErrorEvent(type:String, error:PlayerIOError, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			_error = error;
		} 
		
		public override function clone():Event 
		{ 
			return new PlayerIOErrorEvent(type, _error, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PlayerIOErrorEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get error():PlayerIOError 
		{
			return _error;
		}
		
	}
	
}