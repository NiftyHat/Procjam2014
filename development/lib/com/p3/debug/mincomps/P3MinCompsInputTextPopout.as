package com.p3.debug.mincomps 
{
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.brokenfunction.json.decodeJson;
	import com.brokenfunction.json.encodeJson;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3MinCompsInputTextPopout extends Panel
	{
		
		private var _minimizeButton:Sprite;
		private var _minimized:Boolean;
		
		private var _firstParent:DisplayObjectContainer;
		private var _firstPos:Point;
		private var _lightValidator:IndicatorLight;
		private var _labelInfo:Label;
		
		private var _regExpValidate:RegExp;
		private var _inputText:TextArea;
		
		public function P3MinCompsInputTextPopout(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, jsonObject:* = null)
		{
			_firstParent = parent;
			_firstPos = new Point (xpos,ypos);
			super(parent,xpos,ypos);
			
		}
		
		override protected function init():void 
		{
			super.init();
			//setSize(400, 24);
		}

		override protected function addChildren():void 
		{
			super.addChildren(); 
			_inputText = new TextArea (this, 32, 2, "Test String");
			_inputText.height = 42;
			_minimizeButton = new Sprite();
			_minimizeButton.graphics.beginFill(0, 0);
			_minimizeButton.graphics.drawRect(-10, -10, 20, 20);
			_minimizeButton.graphics.endFill();
			_minimizeButton.graphics.beginFill(0, .35);
			_minimizeButton.graphics.moveTo(-5, -3);
			_minimizeButton.graphics.lineTo(5, -3);
			_minimizeButton.graphics.lineTo(0, 4);
			_minimizeButton.graphics.lineTo(-5, -3);
			_minimizeButton.graphics.endFill();
			_minimizeButton.x = 10;
			_minimizeButton.y = 10;
			_minimizeButton.useHandCursor = true;
			_minimizeButton.buttonMode = true;
			_minimizeButton.addEventListener(MouseEvent.CLICK, onMinimize); 
			_lightValidator = new IndicatorLight (this, 17, 4, 0x00ff00);
			_lightValidator.isLit = true;
			_inputText.addEventListener(Event.CHANGE, onInputChanged);
			_labelInfo = new Label (this, 2, 18, "Info");
			addChild(_inputText)
			addChild(_minimizeButton);
			minimized = true;
			onInputChanged();
		}
		
		private function onInputChanged(e:Event = null):void 
		{
			
			var isValid:Boolean = checkValid();
			if (isValid)
			{
				if (_inputText.text.length >= _inputText.maxChars)
				{
					_labelInfo.text = "Character Limit";
					_lightValidator.color = 0xFF8000;
				}
				else {
					_lightValidator.color = 0x00ff00;
				}
				
			}
			else _lightValidator.color = 0xff0000;
			if (e)
			{
				e.stopImmediatePropagation()
				dispatchEvent(e);
			}
			
		}
		
		private function checkValid():void 
		{
			if (_regExpValidate)
			{
				var index:int = _labelInfo.text.search(_regExpValidate)
				if (index== -1) return false;
				else _labelInfo.text = "invalid @char " + index;
			}
			return true;
		}
		
		protected function onMinimize(event:MouseEvent):void
		{
			minimized = !minimized;
		}
		
		/**
		 * Gets / sets whether the window is closed. A closed window will only show its title bar.
		 */
		public function set minimized(value:Boolean):void
		{
			_minimized = value;
//			_panel.visible = !_minimized;
			if(_minimized)
			{
				x = _firstPos.x;
				y = _firstPos.y;
				if (_firstParent) _firstParent.addChild(this);
				setSize(140, 36);
				//if(contains(_panel)) removeChild(_panel);
				_minimizeButton.rotation = -90;
			}
			else
			{
				var pt:Point = this.parent.localToGlobal(new Point (x,y));
				x = pt.x;
				y = pt.y;
				
				stage.addChild(this);
				setSize((stage.stageWidth - x) - 2, 36);
				_inputText.width = width - 12;
				//if(!contains(_panel)) super.addChild(_panel);
				_minimizeButton.rotation = 0;
			}
			dispatchEvent(new Event(Event.RESIZE));
			draw();
		}
		
		public function get minimized():Boolean
		{
			return _minimized;
		}
		

	}

}