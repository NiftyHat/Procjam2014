package utils 
{
	import spartacus.data.collections.ICollection;
	import spartacus.data.IArrayData;
	import spartacus.data.iterators.ArrayIterator;
	import spartacus.data.iterators.IIterator;
	import spartacus.utils.ArrayUtils;
	
	/**
	 * ...
	 * @author James Tarling
	 */
	public class IndexedArray implements IArrayData, ICollection
	{
		private var list:Array;
	
		public function IndexedArray (list:Array) {
			if (list)
			{
				this.list = ArrayUtils.clone(list);
			} else {
				this.list = [];
			}
		}
		public function getAt(index:int):*
		{
			return list[index];
		}
		public function indexOf(value:*):int
		{
			return list.indexOf(value);
		}
		public function count():int
		{
			return list.length;
		}
		public function cloneData() : Array
		{
			return ArrayUtils.clone(list);
		}
		public function toString ():String
		{
			return "IndexedArray (" + list + ")";
		}
		
		public function iterator():IIterator 
		{
			return new ArrayIterator(list);
		}
		
	}

}