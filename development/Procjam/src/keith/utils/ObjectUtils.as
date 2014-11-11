package utils 
{
	/**
	 * This Class contains a collection of functions to manipulate Objects
	 * @author James Tarling
	 */
	public final class ObjectUtils
	{
		public static function dump(o:*):String
		{
			var output:String = "";
			for (var s:String in o)
			{
				output += s + ":" + o[s] + "\n";
			}
			return output;
		}
		
	}

}