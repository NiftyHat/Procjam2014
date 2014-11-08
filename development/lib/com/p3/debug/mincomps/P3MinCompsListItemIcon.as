package com.p3.debug.mincomps 
{
	import com.bit101.components.ListItem;
	import com.greensock.loading.core.DisplayObjectLoader;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3MinCompsListItemIcon extends ListItem
	{
		
		protected var _icon:Sprite;
		protected var _iconSize:int = 18;
		protected var _iconGutter:int = 1;
		protected var _iconContent:DisplayObject;
		
		public function P3MinCompsListItemIcon(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object = null)
		{
			_icon = new Sprite ()
			_icon.x = 1;
			_icon.y = 1;
			super(parent, xpos, ypos);
		}
		
		override protected function addChildren():void 
		{
			super.addChildren();
			addChild(_icon);
		}
		
		override public function setSize(w:Number, h:Number):void 
		{
			super.setSize(w, h);
			var newSize:int = _height;
			_iconGutter = int((_iconSize / 20) + 0.5)
			_iconSize =  newSize - (_iconGutter * 2);
			_icon.x = 1;
			_icon.y = 1;
			_icon.graphics.clear();
			_icon.graphics.lineStyle(0.5, 0x004080, 0.5);
			_icon.graphics.beginFill(0x8AD2D2);
			_icon.graphics.drawRect(0, 0, _iconSize, _iconSize);
			_icon.graphics.endFill();
			_label.x = _icon.x + _icon.width + _iconGutter;
			updateIconContent();
			
		}
		
		private function updateIconContent ():void
		{
			if (_iconContent)
			{
				_iconContent.width = _icon.width;
				_iconContent.height = _icon.height;
			}
		}
		
		override public function draw():void 
		{
			super.draw();
			if (_data && _data.icon && _data.icon is DisplayObject && _data.icon != _iconContent)
			{
				_iconContent = _data.icon
				
				updateIconContent();
				_icon.addChild(_iconContent);
			}
			
		}
		
	}

}