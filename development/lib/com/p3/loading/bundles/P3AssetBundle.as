package com.p3.loading.bundles 
{
	import com.p3.common.P3Internal;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Dispatches when a set of assets has been loaded in.
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * Generic asset bundle base class. Handles registering assets by string in a associative array object.
	 * Logs all asset adding/removing for debugging.
	 */
	public class P3AssetBundle extends EventDispatcher
	{
		
		protected var _map:Object;
		protected var _name:String = "P3AssetBundle"
		protected var _log:String = "";
		private var _writeOnce:Boolean;
		private var _isLoaded:Boolean;
		
		public function P3AssetBundle() 
		{
			_map = new Object ();
			_log = _name + " log:"; 
		}
		
		/**
		 * Loads the assets in the bundle.
		 */
		public function load():void
		{
			_isLoaded = false;
		}
		

		public function getAsset ($key:String):*
		{
			if (_map[$key]) return _map[$key];
		}
		
		/**
		 * Returns true the the asset with given key is stored in the bundle.
		 * @param	$path
		 * @return
		 */
		public function hasAsset ($key:String):Boolean {
			if (_map[$key]) return true;
			return false;
		}
		
		/**
		 * Registers the content $res with the given keys. Keys are normally file paths but can be anything.
		 * If the bundle mode is _writeOnce they
		 * @param	$key
		 * @param	$res
		 */
		protected function registerAsset ($key:String, $res:*):void
		{
			if (_map[$key] != null)
			{
				if (!_writeOnce) 
				{
					log(_name + " overwrite: " + $key + " - " + getQualifiedClassName($res));
					_map[$key] = $res;
				}
				else
				{
					log(_name + "already has asset at key: " + $key + " - " + getQualifiedClassName($res));
				}
			}
			else 
			{
				log(_name + " add: " + $key + " - " + getQualifiedClassName($res));
				_map[$key] = $res;
			}
			
		}
		
		/**
		 * Error handling, lets you colour errors so that they show up nicely
		 */
		protected function error ($errorText:String):void
		{
			_log += "ERROR: " + $errorText + "\n";
		}
		
		/**
		 * Warning handling, lets you colour errors so that they show up nicely
		 */
		protected function warning ($warningText:String):void
		{
			_log += "WARNING: " + $warningText + "\n";
		}
		
		
		/**
		 * Log function. Standard bundles just keep adding to one big log that you can dump out.
		 * @param	$log
		 */
		protected function log($logText:String):void 
		{
			_log += $logText + "\n";
		}
		
		/**
		 * Write once prevents assets from being overriden if they have colliding keys.
		 * @param	$state
		 */
		protected function setWriteOnce($state:Boolean):void
		{
			_writeOnce = $state;
		}
		
		/**
		 * Dispatches the complete event and flags the bundle as loaded.
		 */
		protected function onLoadComplete ():void 
		{
			dispatchEvent(new Event(Event.COMPLETE));
			_isLoaded = true;
		}
		
		P3Internal function clearLog ():void
		{
			_log = "";
		}
		
		internal function getPaths():Vector.<String>
		{
			var ret:Vector.<String> = new Vector.<String> ();
			for (var key:String in _map)
			{
				ret.push(key);
			}
			return ret;
		}
		
		/**
		 * Tracing the bundle dumps the entire log. It can be big so buyer beware.
		 * @return
		 */
		override public function toString():String 
		{
			return _log;
		}
		
		public function get name():String 
		{
			return _name;
		}

		
	}

}