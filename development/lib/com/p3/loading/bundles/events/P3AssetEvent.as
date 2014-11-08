package com.p3.loading.bundles.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3AssetEvent extends Event 
	{
		static public const ASSET_COMPLETE:String = "fileComplete";
		static public const ASSETS_COMPLETE:String = "filesComplete";
		static public const ASSET_AUDIT_COMPLETE:String = "assetAuditComplete";
		
		protected var _data:*
		
		public function P3AssetEvent(type:String, data:* =null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			_data = data;
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new P3AssetEvent(type,_data, bubbles, cancelable);
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