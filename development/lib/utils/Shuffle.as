package utils
{
	import de.polygonal.math.PM_PRNG;
    /**
     * Simple class to shuffle items in arrays using a modern Fisher–Yates shuffle as described
     * by Richard Durstenfeld in ACM volume 7, issue 7: "Algorithm 235: Random permutation".
     *
     *   Wikipedia: http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
     *
     *
     * Author: David Wagner
     * Complain/compliment at: http://noiseandheat.com/
     *
     *
     * Sample usage:
     *
     *   import utils.Shuffle
     *   
     *   function myFunction():void
     *   {
     *       var data:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
     *   
     *       // Copy, leaving original untouched
     *       trace("-[Shuffling array copy]-----------------------------------------");
     *       trace( "data before shuffle    : " + data );
     *   
     *       var dataCopy = Shuffle.arrayCopy(data);
     *   
     *       trace( "data after shuffle     : " + data );
     *       trace( "dataCopy after shuffle : " + dataCopy );
     *   
     *       // In place
     *       trace("\n-[Shuffling array in place]-------------------------------------");
     *       trace( "data before shuffle: " + data );
     *   
     *       Shuffle.array(data);
     *   
     *       trace( "data after shuffle : " + data );
     *   }
     *
     * Sample output:
     *
     *   -[Shuffling array copy]-----------------------------------------
     *   data before shuffle    : 0,1,2,3,4,5,6,7,8,9
     *   data after shuffle     : 0,1,2,3,4,5,6,7,8,9
     *   dataCopy after shuffle : 5,7,6,1,2,3,0,9,4,8
     *   
     *   -[Shuffling array in place]-------------------------------------
     *   data before shuffle: 0,1,2,3,4,5,6,7,8,9
     *   data after shuffle : 7,9,4,8,6,5,1,3,0,2
     */
    public class Shuffle
    {
        /**
         * Shuffles an array in place.
         *
         * This assumes the array is 0 indexed (i.e. indexed start from 0) and
         * that it is a dense array, that is the values run from 0 to array.length
         * without any gaps.
         */
        static public function array(a:Array,seed:int = 0):void
        {
            // Using a variant type so any array member type can be swapped
			var pm:PM_PRNG = new PM_PRNG ();
			pm.seed = seed;
            var temp:*;
            var j:int;
            for (var i:int = a.length - 1; i > 0; i--)
            {
                // Generate an integer, j, such that 0 <= j <= i
                //
                // Adding 1 to i because Math.random() returns values in the range: 0 <= n < 1
                j = pm.nextDoubleRange(0,1) * (i + 1);
                
                // Swap items
                temp = a[i];
                a[i] = a[j];
                a[j] = temp;
            }
        }
        
        /**
         * Creates a shuffled copy of the specified array. The original array
         * remains in the order it was passed in.
         *
         * This assumes the array is 0 indexed (i.e. indexed start from 0) and
         * that it is a dense array, that is the values run from 0 to array.length
         * without any gaps.
         */
        static public function arrayCopy(source:Array):Array
        {
            var a:Array = new Array(source.length);
            a[0] = source[0];
            
            var j:int;
            for (var i:int = 1; i < a.length; i++)
            {
                // Generate an integer, j, such that 0 <= j <= i
                //
                // Adding 1 to i because Math.random() returns values in the range: 0 <= n < 1
                j = Math.random() * (i + 1);
                
                // Swap items
                a[i] = a[j];
                a[j] = source[i];
            }
            
            return a;
        }
    }
}