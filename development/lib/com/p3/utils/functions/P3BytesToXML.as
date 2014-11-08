package com.p3.utils.functions 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public function P3BytesToXML ($bytes:ByteArray):XML
	{
		return new XML($bytes.readUTFBytes($bytes.length));
	}

}