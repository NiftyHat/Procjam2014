package com.p3.utils.functions 
{
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public function P3Capitilize($string:String):String
	{
		if (!$string) 
		{
			trace("can't capitilize null string");
			return null
		}
		var firstChar:String = $string.substr(0, 1);
		var restOfString:String = $string.substr(1, $string.length);

		return firstChar.toUpperCase()+restOfString.toLowerCase();	
	}
	
}