package com.p3.datastructures.cache 
{
	import com.p3.data.cache.P3CacheManager;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public interface P3ICacheObject 
	{
		function save():Object
		function load($object:Object):void
	}
	
}