package com.p3.datastructures.cache 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public interface IP3CacheObject 
	{
		function save():*
		
		function load($object:*):void
		
		function reset():void
	}
	
}