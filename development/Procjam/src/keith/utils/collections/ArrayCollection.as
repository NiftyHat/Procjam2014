package keith.utils.collections 
{
	import keith.utils.IArrayData;
	import keith.utils.ArrayUtils;
	import keith.utils.iterators.ArrayIterator;
	import keith.utils.iterators.IIterator;
	/**
	 * ...
	 * @author James Tarling
	 */
	public class ArrayCollection implements ICollection, IArrayData
	{
		
		private var list:Array;	
	
		/**
		 * Constructor.
		 * 
		 * @param data an Array to wrap in an ICollection-friendly object. if null a new Array is created 
		 */
		function ArrayCollection(data:Array = null)
		{
			if (data != null)
			{
				list = ArrayUtils.clone(data);	
			} else {
				list = new Array();
			}
		}
		/**
		 * Get the value saved at the specified index
		 * @param index the slot the value is saved in
		 * @return the value saved in the specified index
		 */
		public function getAt(index:int):*
		{
			return list[index];
		}
		/**
		 * Get the index that a particular value is saved at
		 */
		public function indexOf(obj:*):int
		{
			return list.indexOf(obj);	
		}
		public function count():int
		{
			return list.length;
		}
		public function push(item:*):void
		{
			list.push(item);	
		}
		public function pop():*
		{
			return list.pop();	
		}
		public function iterator():IIterator
		{
			return new ArrayIterator(list);
		}
		public function cloneData() : Array
		{
			return ArrayUtils.clone(list);
		}
		public function toString ():String {
			return "ArrayCollection (" + list + ")";
		}
	}

}