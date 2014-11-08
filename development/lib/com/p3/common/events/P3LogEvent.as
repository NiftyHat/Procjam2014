package com.p3.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3LogEvent extends Event 
	{
		static public const LOG:String = "log";
		
		protected var _text:String;
		protected var _logCode:int;
		
		/**
		 * Error dispatch event
		 * @param	type Error type, only has one type to make tracking easier.
		 * @param	text The error content
		 * @param	logCode The error code, you can use constants if you like. I've been using colour codes for simplcity. Colour themes in common.P3Colours.
		 */
		public function P3LogEvent(type:String, text:String = "logText", logCode:int = 0xFFFFFF, bubbles:Boolean=true, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_text = text;
			_logCode = logCode;
		} 
		
		public override function clone():Event 
		{ 
			return new P3LogEvent(type, text, _logCode, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("P3LogEvent", "type", "text", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get text():String 
		{
			return _text;
		}
		
		public function get logCode():int 
		{
			return _logCode;
		}
		

	}
	
}