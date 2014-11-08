package com.p3.debug.mincomps.iconbuttons 
{
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3PushButtonArrow extends PushButton 
	{
		
		protected var _arrowRotation:Number = 0;
		
		public function P3PushButtonArrow(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, arrowRotation:Number = 0, defaultHandler:Function=null) 
		{
			_arrowRotation = arrowRotation;
			if (_arrowRotation > 360 || _arrowRotation < 0) _arrowRotation = _arrowRotation % 360;
			super(parent,xpos,ypos,"",defaultHandler);
			_width = 20;
			_height = 20;
			
			
		}
		
		override protected function addChildren():void 
		{
			super.addChildren();
			var arrow:Shape = new Shape ();
			arrow.graphics.beginFill(0, 0.35)
			arrow.graphics.moveTo(6, -1);
			arrow.graphics.lineTo(0,-7);
			arrow.graphics.lineTo(-6,-1);
			arrow.graphics.lineTo(6, -1);
			arrow.graphics.drawRect( -2, -1, 4, 7);
			arrow.graphics.endFill();
			arrow.x = 10;
			arrow.y = 10;
			arrow.rotation = _arrowRotation;
			addChild(arrow);
			removeChild(_label);
		}
		
	}

}