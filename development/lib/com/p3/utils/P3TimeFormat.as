package com.p3.utils
{
	import com.p3.utils.functions.P3PadNumber;

	public class P3TimeFormat
	{

		public static const HOURS:uint = 2;

		public static const MINUTES:uint = 1;

		public static const SECONDS:uint = 0;

		public function P3TimeFormat() 
		{
		}
		/*
		public static function formatTime(time:Number, detailLevel:uint = 2):String 
		{
			var intTime:uint = Math.floor(time);
			var miliseconds:uint = (time / 100);
			var hours:uint = Math.floor(intTime/ 3600);
			var minutes:uint = (intTime - (hours*3600))/60;
			var seconds:uint = intTime -  (hours*3600) - (minutes * 60);
			var hourString:String = detailLevel == HOURS ? hours + ":":"";
			var minuteString:String = detailLevel >= MINUTES ? ((detailLevel == HOURS && minutes <10 ? "0":"") + minutes + ":"):"";
			var secondString:String = ((seconds < 10 && (detailLevel >= MINUTES)) ? "0":"") + seconds + ":" + miliseconds;
			return hourString + minuteString + secondString;
		}
		*/
		
		public static function convertToMinSec( value:int ):String
		{
			var secs:int = Math.floor(( value / 1000 ) % 60 );
			var mins:int = Math.floor(( value / 1000 ) / 60 );
			return P3PadNumber( mins, 2 ) +":" + P3PadNumber( secs, 2 );
		}
		
		public static function convertToMinSecMil( value:int ):String
		{
			var mils:int = Math.floor( value % 1000 );
			var secs:int = Math.floor(( value / 1000 ) % 60 );
			var mins:int = Math.floor(( value / 1000 ) / 60 );
			return P3PadNumber( mins, 2 ) +":" + P3PadNumber( secs, 2 ) +"." + P3PadNumber( mils/ 10, 2 );
		}
		
		public static function convertToSecMil( value:int ):String
		{
			var mils:int = Math.floor( value % 1000 );
			var secs:int = Math.floor(( value / 1000 ) % 60 );
			//var mins:int = Math.floor(( value / 1000 ) / 60 );
			return P3PadNumber( secs, 2 ) +"." + P3PadNumber( mils/ 10, 2 );
		}

	}

}