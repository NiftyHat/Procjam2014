package com.p3.loading.browser 
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3FileBrowserEvent extends Event 
	{
		static public const SAVED:String = "saved";
		static public const LOADED:String = "loaded";
		
		private var _data:ByteArray;
		private var _file:String;
		
		public function P3FileBrowserEvent($type:String, $data:ByteArray, $file:String = "", $bubbles:Boolean=false, $cancelable:Boolean=false) 
		{ 
			_data = $data;
			super($type, $bubbles, $cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new P3FileBrowserEvent(type, _data, _file, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FileSaverEvent", "m_data", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():ByteArray { return _data; }
		
	}
	
}