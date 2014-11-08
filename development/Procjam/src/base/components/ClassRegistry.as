package base.components 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class ClassRegistry 
	{
		
		private var store:Dictionary = new Dictionary
		private var warnings:Dictionary = new Dictionary
		
		public function ClassRegistry() 
		{
			
		}
		
		public function registerClass ($class:Class, $key:String):void
		{
			trace("registering " + $class +  " at " + $key);
			//if ($key in store)
			//{
				//trace("warning, key overlap, class " + store[$key] + " will be replaced with " + $class);
			//}
			store[$key] = $class;
		}
		
		public function getClass ($key:String):Class
		{
			if ($key in store) return store[$key];
			else if (!warnings[$key]) 
			{
				trace(this + " WARNING : [" + $key + "] not registered with a class, call registerClass first");
				warnings[$key] = true;
			}
			return null;
		}
		
		public function hasClass($key:String):Boolean 
		{
			if ($key in store) return true;
			return false;
		}
		
	}

}