package keith.utils.iterators 
{
	/**
	 * ...
	 * @author James Tarling
	 */
	public class HashMapIterator implements IIterator
	{
		private var data : Object;
		private var keys : Array;
		private var index:int = 0;
	
		public function HashMapIterator(data:Object, keys:Array) {
			this.data = data;
			this.keys = keys;
			reset();
		}
		
		/* INTERFACE shared.data.iterators.IIterator */
		
		public function reset():void
		{
			index = 0;
		}
		
		public function next():*
		{
			var key:String = keys[index ++];
			return data[key];
		}
		
		public function hasNext():Boolean
		{
			return index < keys.length;
		}
		
	}

}