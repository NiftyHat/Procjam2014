package com.p3.loading.bundles 
{
	import com.p3.common.events.P3LogEvent;
	import com.p3.common.P3Colours;
	import com.p3.loading.bundles.events.P3AssetEvent;
	import com.p3.loading.bundles.helpers.P3ExternalAsset;
	import com.p3.loading.preloader.P3Preloader;
	import flash.events.IOErrorEvent;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3PreloaderBundle extends P3ExternalBundle 
	{
		
		public function P3PreloaderBundle() 
		{
			super();
			
		}
		
		override public function getAsset($key:String):* 
		{
			return super.getAsset($key);
		}
		

		
		override protected function warning($warningText:String):void 
		{
			dispatchEvent(new P3LogEvent (P3LogEvent.LOG, $warningText, P3Colours.COLOUR_WARN));
		}
		
		override protected function log($logText:String):void 
		{
			dispatchEvent(new P3LogEvent (P3LogEvent.LOG, $logText, P3Colours.COLOUR_LOG));
		}
		
		override protected function error($errorText:String):void 
		{
			dispatchEvent(new P3LogEvent (P3LogEvent.LOG, $errorText, P3Colours.COLOUR_ERROR));
		}
		
	}

}