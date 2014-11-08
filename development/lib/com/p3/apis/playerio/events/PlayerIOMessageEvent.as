package com.p3.apis.playerio.events 
{
	import flash.events.Event;
	import playerio.Message;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class PlayerIOMessageEvent extends Event 
	{
		static public const MESSAGE:String = "message";
		
		private var _message:Message;
		
		public function PlayerIOMessageEvent(type:String, message:Message, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_message = message;
		} 
		
		public override function clone():Event 
		{ 
			return new PlayerIOMessageEvent(type, _message, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PlayerIOMessageEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get message():Message 
		{
			return _message;
		}
		
	}
	
}