package com.p3.utils.functions 
{
	
	/**
	 * ...
	 * @author Duncan
	 */
	public function P3PadNumber(number:int, width:int):String 
	{
		var ret:String = "" + number;
		var len:int = ret.length;
			while ( len < width )
			{
			   ret = "0" + ret;
			   len++
			}
		return ret;
	}

	
}