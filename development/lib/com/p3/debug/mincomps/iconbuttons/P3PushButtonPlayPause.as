package com.p3.debug.mincomps.iconbuttons 
{
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3PushButtonPlayPause extends PushButton
	{
		private var _iconPlay:Shape;
		private var _iconPause:Shape;
		
		protected var _togglePause:Boolean;
		
		public function P3PushButtonPlayPause(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, defaultHandler:Function = null)
		{
			_iconPlay = new Shape ();
			_iconPlay.graphics.beginFill(0, 0.35)
			_iconPlay.graphics.moveTo(0, 0);
			_iconPlay.graphics.lineTo(10, 5.5);
			_iconPlay.graphics.lineTo(0, 10);
			_iconPlay.graphics.lineTo(0, 0);
			_iconPlay.x = 5;
			_iconPlay.y = 5;
			_iconPause = new Shape ();
			_iconPause.graphics.beginFill(0, 0.35)
			_iconPause.graphics.drawRect(3, 2, 4, 12);
			_iconPause.graphics.drawRect(9, 2, 4, 12);
			_iconPause.x = 2;
			_iconPause.y = 2;
			
			super(parent,xpos,ypos,"",defaultHandler);
			_width = 20;
			_height = 20;
		}
		
		override protected function addChildren():void 
		{
			super.addChildren();
			addChild(_iconPause);
			addChild(_iconPlay);
			removeChild(_label);
		}
		
		override public function draw():void 
		{
			super.draw();
			if (_togglePause)
			{
				_iconPause.visible = true;
				_iconPlay.visible = false
			}
			else
			{
				_iconPause.visible = false;
				_iconPlay.visible = true;
			}
		}
		
		override protected function onMouseGoDown(event:MouseEvent):void 
		{
			if (_over)
			{
				togglePause = !_togglePause;
			}
			super.onMouseGoDown(event);
		}
		
		public function set togglePause(value:Boolean):void 
		{
			_togglePause = value;
			invalidate();
		}
		
		public function get togglePause():Boolean 
		{
			return _togglePause;
		}
		
	}

}