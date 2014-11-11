package utils.iterators 
{
	
	/**
	 * ...
	 * @author James Tarling
	 */
	public class ArrayIterator implements IIterator
	{
		
		private var index:int = 0;
		private var collection:Array;
		
		public function ArrayIterator(collection:Array)
		{
			this.collection = collection;
			index = 0;
		}
		public function reset():void
		{
			index = 0;
		}

		public function next():*
		{
			return collection[index ++];
		}

		public function hasNext():Boolean
		{
			return index < collection.length;
		}
			
	}

}