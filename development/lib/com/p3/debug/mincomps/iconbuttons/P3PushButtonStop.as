package com.p3.debug.mincomps.iconbuttons 
{
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3PushButtonStop extends PushButton
	{
		
		public function P3PushButtonStop(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, defaultHandler:Function = null)
		{
			super(parent,xpos,ypos,"",defaultHandler);
			_width = 20;
			_height = 20;
		}
		
		override protected function addChildren():void 
		{
			super.addChildren();
			var square:Shape = new Shape ();
			square.graphics.beginFill(0, 0.35)
			square.graphics.drawRect(0, 0, 10, 10);
			square.graphics.endFill();
			square.x = 5;
			square.y = 5;
			addChild(square);
			removeChild(_label);
		}
		
	}

}