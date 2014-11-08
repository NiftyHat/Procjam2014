package com.p3.datastructures.cache 
{
	import de.polygonal.ds.HashMap;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	
	
	public class P3CacheManager 
	{
		
		protected var m_cacheHashmap:HashMap;
		protected var m_sharedObject:SharedObject;
		
		public function P3CacheManager() 
		{
			m_cacheHashmap = new HashMap ();
			m_sharedObject = SharedObject.getLocal("p3-cache-test");
		}
		
		public function add($object:*, $key:String):void
		{
			if (m_cacheHashmap.contains($object)) return;
			m_cacheObjects.push($object);
			m_cacheHashmap.set($key, $object);
		}
		
		public function save ():void 
		{
		}
		
	}

}