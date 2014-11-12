package keith.utils 
{
	/**
	 * A set of the functions to manipulate Array's
	 * @author James Tarling
	 */
	final public class ArrayUtils
	{
		
		/**
		 *	Delete the first instance, or all instances, of a value from an array
		 *
		 *	@param	arr	the array to search
		 *	@param	val	the value to delete
		 *	@param	allValues	if set to true, all matching values will be deleted
		 *	@return	true if a value was successfully deleted
		 */
		public static function deleteValue(arr:Array, val:*, allValues:Boolean = false):Boolean
		{
			var len:int = arr.length;
			var found:Boolean = false;

			for (var i:int = 0; i < len; i++)
			{
				if (arr[i] == val)
				{
					arr.splice(i,1);
					found = true;
					if (allValues == true)
					{
						i --;
					} else {
						return true;
					}
				};
			};
			return found;
		};
	
		/**
		 *	Shuffle the members of an array
		 *
		 *	@param	arr	the array to shuffle
		 */
		public static function shuffle(arr:Array):void
		{
			var l:int = arr.length-1;
			var t:*;
			for (var i:int = l; i>0; i--) {
				var j:int = Math.floor(Math.random()*(i+1));
				if (i != j) {
					t = arr[i];
					arr[i] = arr[j];
					arr[j] = t;
				}
			}
		}
		/**
		 * It clones an array 
		 * @param arr the array to be cloned
		 * @return  The cloned array
		 * 
		 */
		public static function clone(arr:Array):Array
		{
			return arr.concat();	
		}
		/**
		 * This is createf to return an Array of increments 
		 * @param startValue The start value
		 * @param inc the increment
		 * @param length The lenght of range
		 * @return 
		 * 
		 */
		public static function makeNumberList(startValue:Number, inc:Number, length:int):Array 
		{
			var list:Array = new Array();
			for (var i:int = 0; i < length; i++)
			{
				list.push(startValue + (i * inc));	
			}
			return list;	
		}
	}

}