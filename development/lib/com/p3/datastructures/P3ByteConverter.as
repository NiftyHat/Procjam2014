package com.p3.datastructures 
{
	import flash.utils.ByteArray;
	import mx.core.ByteArrayAsset;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3ByteConverter 
	{
		
		public static function classToXML ($class:Class):XML
		{
			if ($class is ByteArrayAsset) return bytesToXML(new $class);
			trace("class isn't a valid byte array asset");
			return null;
		}
		
		public static function classToString ($class:Class):String
		{
			if ($class is ByteArrayAsset) return bytesToString(new $class);
			trace("class isn't a valid byte array asset");
			return null;
		}
		
		public static function bytesToXML ($bytes:ByteArray):XML
		{
			return new XML($bytes.readUTFBytes($bytes.length));
		}
		
		public static function bytesToString ($bytes:ByteArray):String
		{
			var string:String =  $bytes.readUTFBytes($bytes.length);
			return string;
		}
		
	}

}