package com.p3.debug.mincomps.iconbuttons 
{
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3PushButtonSkip extends PushButton
	{
		
		protected var _isBackwards:Boolean;
		
		public function P3PushButtonSkip(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, isBackwards:Boolean = false, defaultHandler:Function = null)
		{
			_isBackwards = isBackwards
			super(parent,xpos,ypos,"",defaultHandler);
			_width = 20;
			_height = 20;
		}
		
		override protected function addChildren():void 
		{
			super.addChildren();
			var bar:Shape = new Shape ();
			
			bar.x = 12;
			bar.y = 2;
			var triangle:Shape = new Shape ();
			triangle.graphics.beginFill(0, 0.35)
			triangle.graphics.moveTo(-1, -6);
			triangle.graphics.lineTo(7, 0);
			triangle.graphics.lineTo(-1, 6);
			triangle.graphics.lineTo(-1, -6);
			triangle.graphics.drawRect(-6, -6, 3, 12);
			triangle.graphics.endFill();
			triangle.x = 10;
			triangle.y = 10;
			if (_isBackwards) triangle.scaleX = -1;
			addChild(bar);
			addChild(triangle);
			removeChild(_label);
		}
		
	}

}