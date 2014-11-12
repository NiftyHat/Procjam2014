package keith.utils.collections 
{
	import keith.utils.iterators.HashMapIterator
	import keith.utils.iterators.IIterator
	import keith.utils.ArrayUtils
	import keith.utils.ObjectUtils
	/**
	 * ...
	 * @author James Tarling
	 */
	public class HashMap implements ICollection
	{
		private var data : Object;
		private var keys : Array;
		
		/**
		 * Constructor.
		 */
		public function HashMap() {
			data = new Object();
			keys = new Array();	
		}
		/**
		 * Set a value against a string identifier
		 * 
		 * @param key the string ID used to store the value
		 * @param value the value to be stored
		 * 
		 */
		public function setValue(key:*, value:*):void {
			
			var keyString:String = key.toString();
			
			if (value != null)
			{
				if (getValue(keyString) == null)
				{
					keys.push(keyString);	
				}
				data[keyString] = value;	
			} else {
				ArrayUtils.deleteValue(keys, keyString);
				delete data[keyString];	
			}
			
		}
		/**
		 * Get the value saved against a particular string ID
		 * @param key a string ID used to store a value
		 * @return a value saved against the specified ID 
		 */
		public function getValue(key:*):* {
			return key ? data[key.toString()] : null;	
		}
		/**
		 * Get the number of keys used in this hashmap
		 * @return the number of keys used in this hashmap
		 */
		public function count():int {
			return keys.length;	
		}
		/**
		 * Get an IIterator object to iterate through the values in this hashmap
		 * 
		 * @return a HashMapIterator object
		 */
		public function iterator() : IIterator {
			return new HashMapIterator(data, keys);
		}
		/*
		 * Get a list of all the keys used in the hashmap
		 * @return an ArrayCollection of all keys
		 */
		public function getKeys():ArrayCollection {
			return new ArrayCollection(keys);	
		}
		
		public function toString ():String {
			//return "HashMap (" + keys + ")" + ObjectUtils.dump(data);
			return "HashMap " + ObjectUtils.dump(data);
		}
	}

}