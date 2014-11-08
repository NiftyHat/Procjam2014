package com.p3.display.ui 
{
	import com.greensock.loading.core.DisplayObjectLoader;
	import com.greensock.TweenNano;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * P3GridLayout
	 * Basic class for doing grid layout of movieclips (like buttons, achivement icons ect ect). Grid resizes
	 * to fit biggest clip. Add's new items on end of grid. Will add functionality to inject extra items and 
	 * stuff eventually.
	 * @author Duncan Saunders
	 */
	public class P3GridLayout extends Sprite
	{
		
		private var _itemList:Vector.<DisplayObject>;
		private var _rows:int;
		private var _cols:int;
		private var _rowHeight:int;
		private var _colWidth:int;
		private var _margin:int = 2;
		
		
	
		public function P3GridLayout($cols:int = 4, $rows:int = 3) 
		{
			_rows = $rows;
			_cols = $cols;
			_itemList = new Vector.<DisplayObject> ();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			destroy();
		}
		
		public function destroy():void 
		{
			if (parent) parent.removeChild(this);
			_itemList = null;
		}
		
		public function setSize ($cols:int = 0, $rows:int = 0):void
		{
			if ($rows <= 0) $rows = _rows;
			if ($cols <= 0) $cols = _cols;
			_rows = $rows;
			_cols = $cols;
			//var newLength:int = _cols * _rows;
			//_itemList.length = newLength;
		}
		
		public function removeItem ($item:DisplayObject):void
		{
			var index:int = _itemList.indexOf($item);
			removeItemAtIndex(index);
		}
		
		public function removeItemAt ($col:int, $row:int):void
		{
			var index:int = cellToIndex($col, $row);
			if (index < _itemList.length + 1) removeItemAtIndex ( index);
		}
		
		public function addItem ($item:DisplayObject):void
		{
			addItemAtIndex($item, _itemList.length)
		}
		
		public function addItems ($array:Array):void
		{
			for each (var item:DisplayObject in $array)
			{
				if (item) addItem(item);
			}
		}
		
		public function addItemAt ($item:DisplayObject, $col:int, $row:int):void
		{
			var index:int = cellToIndex($col, $row);
			if (index < _itemList.length + 1) addItemAtIndex ($item, index);
		}
		
		
		public function addItemAtIndex ($item:DisplayObject, $index:int):void
		{
			var index:int = $index;
			if (index > _itemList.length && _itemList[$index]) 
			{
				removeChild(_itemList[$index]);
			}
			var updateSize:Boolean;
			var targetRow:int = ($index/_cols);
			var targetCol:int = $index % _cols;
			$item.x = targetCol * (_colWidth + _margin);
			$item.y = targetRow * (_rowHeight + _margin);
			if (_itemList.length < index) _itemList.length = index;
			_itemList[index] = $item;
			if ($item.height > _rowHeight) 
			{
				_rowHeight = $item.height
				updateSize = true;
			}
			if ($item.width > _colWidth)
			{
				_colWidth = $item.width;
				updateSize = true;
			}
			if (updateSize) updateCellSize(_colWidth,_rowHeight);
			addChild($item);
		}
		
		public function removeItemAtIndex($index:int):void 
		{
			var index:int = $index;
			
			var updateSize:Boolean;
			var len:int = _itemList.length;
			var nullIndexTotal:int = 0;
			var removedItem:DisplayObject = _itemList[index]
			if (removedItem)
			{
				removeChild(removedItem);
				_itemList[index] = null;
			}
			
			for (var i:int = 0; i < len; i++)
			{
				//trace("i:", i, "      total:", nullIndexTotal);
				if (_itemList[i] == null)
				{
					nullIndexTotal++;
				}
				else {
					var item:DisplayObject = _itemList[i];
					_itemList[i - nullIndexTotal] = _itemList[i];
					if (nullIndexTotal > 0) _itemList[i] = null;
					if (item)
					{
						var newPos:int = i - nullIndexTotal
						var targetRow:int = (newPos/_rows);
						var targetCol:int = newPos % _cols;
						updateItemPosition(item,targetRow, targetCol);
					}
				}
			}
		}
		
		public function updateCellSize ($width:int, $height:int):void
		{
			if ($width > 0) _colWidth = $width
			if ($height > 0) _rowHeight = $height;
			var len:int = _itemList.length;
			for (var index:int = 0; index < len; index++)
			{
				var item:DisplayObject = _itemList[index];
				if (!item) continue;
				var targetRow:int = (index/_cols);
				var targetCol:int = index % _cols;
				updateItemPosition(item,targetRow, targetCol);
			}
		}
		
		public function updateItemPosition ($item:DisplayObject, $row:int, $col:int):void
		{
			$item.x = $col * (_colWidth + _margin);
			$item.y = $row * (_rowHeight + _margin);
			//TweenNano.to($item, 0.3, {x: $col * (_colWidth + _margin), y:$row * (_rowHeight + _margin)} )
		}
		
		
		private function cellToIndex ($col:int, $row:int):int
		{
			var index:int = ($row * (_rows)) + $col
			return index;
			
		}
		
		
	}

}