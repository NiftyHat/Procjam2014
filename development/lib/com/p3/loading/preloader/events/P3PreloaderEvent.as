package com.p3.loading.preloader.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3PreloaderEvent extends Event 
	{
		static public const PRELOAD_COMPLETE:String = "preloadComplete";
		static public const PRELOAD_DEBUG:String = "preloadDebug";
		
		protected var _data:*
		
		public function P3PreloaderEvent(type:String, data:* =null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			_data = data;
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new P3PreloaderEvent(type,_data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("P3PreloaderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():* 
		{
			return _data;
		}
		
	}
	
}