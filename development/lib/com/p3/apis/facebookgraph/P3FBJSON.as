package com.p3.apis.facebookgraph 
{
	import com.brokenfunction.json.decodeJson;
	import com.brokenfunction.json.encodeJson;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3FBJSON 
	{
		
		public function P3FBJSON() 
		{
			
		}
		
		public static function decode ($string:String):Object
		{
			var ret:Object;
			ret = decodeJson($string);
			return ret;
		}
		
		public static function encode ($object:*):String
		{
			var ret:String;
			ret = encodeJson($object);
			return ret;
		}
		
	}

}