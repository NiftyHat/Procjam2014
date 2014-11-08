package com.p3.utils.debug 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3DebugUtils 
	{
		
		public function P3DebugUtils() 
		{
			
		}
		
		public static function getFunctionName(error:Error):String 
		{
			var stackTrace:String = error.getStackTrace();     // entire stack trace
			var startIndex:int = stackTrace.indexOf("at ", stackTrace.indexOf("at ") + 1); //start of second line
			var endIndex:int = stackTrace.indexOf("()", startIndex);   // end of function name

			var lastLine:String = stackTrace.substring(startIndex + 3, endIndex);
			var functionSeperatorIndex:int = lastLine.indexOf('/');

			var functionName:String = lastLine.substring(functionSeperatorIndex + 1, lastLine.length);

			return functionName;
		}

		
	}

}