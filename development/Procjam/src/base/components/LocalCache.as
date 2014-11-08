package base.components 
{
	import com.p3.datastructures.cache.IP3CacheObject;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class LocalCache
	{
		
		private var _shared:SharedObject;
		public var has_save:Boolean = false;
		private var _objectRefence:Dictionary;
		private var _versionString:String = "???";

		public function LocalCache() 
		{
			_objectRefence = new Dictionary ();
			_shared = SharedObject.getLocal("temp");
			
		}
		
		//TODO re-write all this stuff to use a namespace to save everything.
		
		/* INTERFACE base.interfaces.ISaveData */
		
		public function add($object:IP3CacheObject, $key:String):void
		{
			if (getCacheObject($key)) trace ("LocalCache key collision @ " + $key);
			_objectRefence[$key] = $object;
		}
		
		public function remove($key:String):void
		{
			delete _objectRefence[$key];
		}
		
		public function save(targetObject:IP3CacheObject = null):void 
		{
			if (targetObject) has_save = true;
			var amfData:Object = _shared.data.amfData;
			
			if (!amfData) amfData = { };
			//TODO Escape is theres no object
			//if (targetObject && !(targetObject in _objectRefence))
			//{
				//return;
			//}
			for (var key:String in _objectRefence)
			{
				var cacheObject:IP3CacheObject = getCacheObject(key);
				if (targetObject && cacheObject != targetObject){
					continue;
				}
				if (cacheObject)
				{
					trace("LocalCache << " + key);
					amfData[key] = cacheObject.save();
				}
				
			}
			_shared.data.amfData = amfData;
			_shared.data.version = _versionString;
			trace("LocalCache version " + _shared.data.version);
			_shared.flush();
			//encodeHashmap(Core.control.level_hashmap);
		}
		
		public function load(targetObject:IP3CacheObject = null):void 
		{
			var amfData:Object = _shared.data.amfData;
			if (!amfData)  
			{
				trace("LocalCache no amfData");
				return 
			}
			if (!_shared.data) 
			{
				trace("LocalCache no sharedData Object");
				return 
			}
			trace("LocalCache version " + _shared.data.version);
			for (var key:String in _objectRefence)
			{
				var cacheData:Object = amfData[key]
				var cachObject:IP3CacheObject = _objectRefence[key]
				if (targetObject && (targetObject != cachObject)) continue;
				if (cachObject && cacheData) cachObject.load(cacheData);
				trace("LocalCache >> " + key);
			}
		}
		
		public function erase():void 
		{
			_shared.clear();
			has_save = false;
			for (var key:String in _objectRefence)
			{
				var cachObject:IP3CacheObject = _objectRefence[key]
				if (cachObject) 
				{
					trace("LocalCache XX " + key);
					cachObject.reset();
				}
			}
			_shared = SharedObject.getLocal("P3-TrainDefense");
		}
		
		internal function getCacheObject ($key:String):IP3CacheObject
		{
			return _objectRefence[$key];
		}
		
		public function destroy():void
		{
			_shared = SharedObject.getLocal("P3-TrainDefense");
			_objectRefence = new Dictionary ();
		}
		
	}

}