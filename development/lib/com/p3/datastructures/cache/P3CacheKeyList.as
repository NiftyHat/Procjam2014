package com.p3.datastructures.cache 
{
	import com.p3.datastructures.list.P3KeyList;
	import com.p3.datastructures.list.P3KeyListItem;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3CacheKeyList implements P3ICacheObject
	{
		
		var list:P3KeyList;
		var template:Object;
		
		public function P3CacheKeyList() 
		{
			super();
			template = { };
		}
		
		public function save ():void {
			list.forEach(forEachSave);
		}
		
		public function load():void
		{
			list.forEach(forEachLoad);
		}
		
		private function forEachLoad($listItem:P3KeyListItem):void 
		{
			if ($listItem is P3ICacheObject)
			{
				var saveData:Object = template[$listItem.key]
				if (saveData) 
				{
					trace("saving object key" + $listItem.key);
					P3ICacheObject($listItem).load(saveData);
				}
			}
		}
		
		private function forEachSave($listItem:P3KeyListItem):void 
		{
			if ($listItem is P3ICacheObject)
			{
				trace("loading object key" + $listItem.key);
				template[$listItem.key] = P3ICacheObject($listItem).save();
			}
		}
		
	}

}