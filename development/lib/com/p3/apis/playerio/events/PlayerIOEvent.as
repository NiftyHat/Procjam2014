package com.p3.apis.playerio.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class PlayerIOEvent extends Event 
	{
		static public const LOGGED_IN:String = "loggedIn";
		static public const LOGGED_OUT:String = "loggedOut";
		
		public function PlayerIOEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			//PlayerIOEvent.LOGGED_OUT
		} 
		
		public override function clone():Event 
		{ 
			return new PlayerIOEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PlayerIOEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}