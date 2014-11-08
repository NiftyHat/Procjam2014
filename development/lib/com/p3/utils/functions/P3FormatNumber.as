package com.p3.utils.functions
{
	/**
	 * @author Duncan Saunder
	 * Playerthree LTD
	 */
	
	/**
	 * Formats a number so that it is comma seperated. Doesn't work with fractions.
	 * @param	Number you want formated.
	 * @return Formated number.
	 */
	public function P3FormatNumber(number:Number):String
		{
			var numString:String = number.toString()
			var result:String = ''
			while (numString.length > 3)
			{
					var chunk:String = numString.substr(-3)
					numString = numString.substr(0, numString.length - 3)
					result = ',' + chunk + result
			}
			if (numString.length > 0)
			{
					result = numString + result
			}
			return result
		}

}