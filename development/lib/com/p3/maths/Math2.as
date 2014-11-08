/**
 * ...
 * @author Adam H
 */

package com.p3.maths 
{
	
	public class Math2 
	{
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function Math2() 
		{
			
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Returns a random integer from 1 to the "range supplied".
		 * @param	range - int
		 * @return
		 */
		static public function randomInt(range:int):int
		{
			return int(1 + (Math.random() * range));
		}
		

		/**
		 * Returns a random number from 1 to the "range supplied".
		 * @param	range - int
		 * @return
		 */
		static public function randomNumber(range:Number):Number
		{
			return Number(1 + (Math.random() * range));
		}
		
		static public function roundDecimal(num:Number, precision:Number):Number
		{ 
			var decimalPlaces:Number = Math.pow(10, precision); 
			return Math.round(num * decimalPlaces) / decimalPlaces; 
		}
		
	
		/**
		 * A faster abs
		 * @param	value:Nuumber
		 * @return
		 */
		static public function abs(value:Number):Number
		{
			//v1: 2500 times faster...
			//return value < 0 ? -value : value;

			//v2: 20 times faster than v1.
			return (value ^ (value >> 31)) - (value >> 31);
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}

}