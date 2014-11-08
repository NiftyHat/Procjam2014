package com.p3.datastructures.list 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3KeyListItem 
	{
		
		private var _index:uint = int.MAX_VALUE;
		private var _key:String = null;
		private var _isLocked:Boolean;
		
		public function P3KeyListItem() 
		{
			
		}
		
		public function get index():uint 
		{
			return _index;
		}
		
		public function get key():String 
		{
			return _key;
		}
		
		public function set index(value:uint):void 
		{
			if (_isLocked) return;
			_index = value;
		}
		
		public function set key(value:String):void 
		{
			if (_isLocked) return;
			_key = value;
		}
		
		internal function free():void {
			_index = int.MAX_VALUE;
			_key = null;
			_isLocked = false;
		}
		
		internal function lock():void 
		{
			_isLocked = true;
		}
		
	}

}