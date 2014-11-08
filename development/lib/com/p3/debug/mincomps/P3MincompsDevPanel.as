package com.p3.debug.mincomps 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3MincompsDevPanel extends Window 
	{
		
		private var _checkbox:CheckBox;
		//private var _label:Label;
		
		public function P3MincompsDevPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			_draggable = false;
			addEventListener(Event.RESIZE, onWindowResize);
		}
		
		override protected function init():void 
		{
			super.init();
			width = 120;
			height = 40;
			_checkbox = new CheckBox (this, 3,3, "Dev Mode", onCheckBoxClick);
			//_label = new Label ()
			
		}
		
		private function onCheckBoxClick(e:MouseEvent):void 
		{
			dispatchChange();
		}
		
		private function dispatchChange():void 
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onWindowResize(e:Event):void 
		{
			if (stage) 
			{
				y = 0
				x = 0;
				//if (_window.x + _window.width > stage.stageWidth) _window.x = 0;
			}
			//saveSettings();
		}
		
		public function get isDevModeChecked ():Boolean
		{
			if (_checkbox) return _checkbox.selected;
			return false;
		}
		
	}

}