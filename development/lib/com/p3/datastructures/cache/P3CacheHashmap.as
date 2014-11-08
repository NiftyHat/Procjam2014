package com.p3.datastructures.cache 
{
	import adobe.serialization.json.JSON;
	import com.p3.data.cache.IP3CacheObject;
	import de.polygonal.ds.HashMap;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3CacheHashmap extends HashMap
	{
		
		protected var m_class_def:Class = Object;
		
		public function P3CacheHashmap() 
		{
			
		}
		
		public function setClassDef ($class:Class):void
		{
			m_class_def = $class
		}
		
		public function save ():ByteArray
		{
			//trace("foo:" + Object(m_map));
			var serialized_map:Object = new Object ();
			var key_array:Array = toKeyArray();
			for each (var item:* in key_array)
			{
				var hashmap_key:* =item;
				var hashmap_data:IP3CacheObject = get(item) as IP3CacheObject;
				serialized_map[hashmap_key] = hashmap_data.save();
			}
			var data:Object = serialized_map;
			var bytes:ByteArray = new ByteArray ();
			bytes.writeObject(data)
			return bytes;
		}
		
		public function load ($bytes:ByteArray):void
		{
			if (!$bytes) return;
			$bytes.position = 0;
			var data:Object = $bytes.readObject();
			for (var key:String in data)
			{
				if (key != null && key != "")  
				{
					var target:IP3CacheObject;
					if (hasKey(key)) target = (get(key) as IP3CacheObject);
					else target = new m_class_def()
					target.load(data[key]);
					set(key,  target);
				}
				
			}
		}
		
	}

}