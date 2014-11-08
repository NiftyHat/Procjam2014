package com.p3.datastructures.list 
{
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3KeyList 
	{
		
		protected var _vector:Vector.<P3KeyListItem> = new Vector.<P3KeyListItem>;
		protected var _dictionary:Dictionary = new Dictionary ();
		
		protected var _isWarnings:Boolean;
		
		public function P3KeyList() 
		{
			_vector = new Vector.<P3KeyListItem>;
			_dictionary = new Dictionary ();
		}
		
		public function addItem ($item:P3KeyListItem):void
		{
			if ($item.key == null) $item.key = generateNextKey();
			if ($item.index == int.MAX_VALUE) $item.index = generateNextIndex();
			//index stuff
			if (_vector.length < $item.index + 1) _vector.length = $item.index + 1;
			if (_vector[$item.index] != null) 
			{
				trace("P3KeyList " + " index is already in use " + $item.index);
				return;
			}
			if (_dictionary[$item.key] != null) 
			{
				trace("P3KeyList " + " key is already in use " + $item.key);
				return;
			}
			if ($item.index > _vector.length) _vector.length = $item.index;
			_vector[$item.index] = $item;
			_dictionary[$item.key] = $item;
			$item.lock();
		}
		
		public function removeItem ($item:P3KeyListItem):void
		{
			if ($item == null) 
			{
				trace("can't remove null items from list!")
				return;
			}
			_vector[$item.index] = null;
			_dictionary[$item.key] = null;
		}
		
		public function hasItemAtKey ($key:String):*
		{
			return (_dictionary[$key] != null);
		}
		
		public function hasItemAtIndex ($index:int):*
		{
			return (_vector[$index] != null);
		}
		
		public function removeItemByKey ($key:String):void
		{
			removeItem(_dictionary[$key]);
		}
		
		public function removeItemByIndex ($index:uint):void
		{
			if ($index >= _vector.length) 
			{
				trace("P3KeyList :- can't remove item at " + $index + " not avalible in vector")
				return;
			}
			removeItem(_vector[$index]);
		}
		
		public function getItemByKey ($key:String):P3KeyListItem
		{
			if (_dictionary[$key] != null && _dictionary[$key] != undefined ) return _dictionary[$key];
			return null;
		}
		
		public function getItemByIndex ($index:uint):P3KeyListItem
		{
			if ($index < _vector.length) return _vector[$index];
			return null;
		}
		
		public function forEach ($function:Function):void
		{
			var func:Function = $function;
			for each (var item:P3KeyListItem in _vector)
			{
				func(item);
			}
		}
		
		protected function generateNextIndex ():int
		{
			var len:int = _vector.length
			var i:int = 0;
			while (i < len)
			{
				if (_vector[i] == null) return i;
				i++
			}
			return len;
		}
		
		protected function generateNextKey ():String
		{
			var len:int = _vector.length
			var i:int = 0;
			while (i < len)
			{
				if (_vector[i] == null) return "item" + i;
				i++;
			}
			return "item0";
		}
		
		public function get vector():Vector.<P3KeyListItem> 
		{
			return _vector;
		}
	}

}