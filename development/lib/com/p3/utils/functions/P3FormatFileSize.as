package com.p3.utils.functions 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public function P3FormatFileSize(bytes:uint):String
	{
		var s:Array = ['bytes', 'kb', 'MB', 'GB', 'TB', 'PB'];
		var e:Number = Math.floor( Math.log( bytes ) / Math.log( 1024 ) );
		return ( bytes / Math.pow( 1024, Math.floor( e ) ) ).toFixed( 2 ) + s[e];
	}

}