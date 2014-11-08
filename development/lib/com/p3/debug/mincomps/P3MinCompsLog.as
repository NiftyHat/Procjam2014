package com.p3.debug.mincomps 
{
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	import com.p3.common.events.P3LogEvent;
	import com.p3.common.P3Internal;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import mx.core.ButtonAsset;
	
	/**
	 * Singleton Class
	 * @author Duncan Saunders
	 */
	public class P3MinCompsLog
	{
		
		/*---------------------------------------------------------------------------*\
		 *	BEGIN SINGLETON
		 *---------------------------------------------------------------------------*/
		 
		private static var _instance:P3MinCompsLog
		
		public function P3MinCompsLog() 
		{
			if (_instance) throw new Error ("only one instance of singleton allowed. Use P3MinCompsLog.ins to accsess it");
			init();
		}
		
		public static function get inst ():P3MinCompsLog 
		{
			if (!_instance) _instance = new P3MinCompsLog;
			return _instance;
		}
		
		/*---------------------------------------------------------------------------*\
		 * END SINGLETON
		 *---------------------------------------------------------------------------*/
		
		//FLASH DISPLAY PARTS
		private var _display:MovieClip;
		private var _stage:Stage;
		private var _textField:TextField;
		 
		//MINCOMPS PARTS
		private var _window:Window;
		private var _scrollPane:P3MinCompsScrollPane;
		private var _light:IndicatorLight;
		private var _buttonClear:PushButton;
	
		private var _timerRefreshFront:Timer;
		private var _isInitDone:Boolean;
		private var _sharedObject:SharedObject;
		private var _version:String = "0.7v"
		
		//COLOURS		
		public static const COLOUR_LOG:int = 0x808080;
		public static const COLOUR_WARN:int = 0xFF8000;
		public static const COLOUR_ERROR:int = 0xFF0000;
		public static const COLOUR_INFO:int = 0xA7A7A7;
		public static const COLOUR_SENT:int = 0x008000;
		public static const COLOUR_RECIVED:int = 0x008080;
		
		public static const COLOUR_LIGHT_STANDARD:int = 0x00FF00
		
		/**
		 * Initilized the logger and adds all the display stuff.
		 * @param	$target
		 */
		public function init ($target:DisplayObjectContainer = null):void 
		{
			if (!_isInitDone) 
			{
				_display = new MovieClip ();
				_display.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				_window = new Window (_display);
				_window.title = "   Debug panel 4000";
				_scrollPane = new P3MinCompsScrollPane (_window, 2, 2);
				_window.height = 200;
				_window.hasMinimizeButton = true;
				_timerRefreshFront = new Timer (30, 30);
				_textField = new TextField ();
				_textField.embedFonts = true;
				_textField.defaultTextFormat = new TextFormat (Style.fontName, Style.fontSize);
				_scrollPane.addChild(_textField);
				_textField.x = _textField.y = 2;
				_textField.wordWrap = true;
				_textField.multiline = true;
				_textField.selectable = true;
				_textField.defaultTextFormat = new TextFormat (Style.fontName, Style.fontSize);
				_textField.autoSize = TextFieldAutoSize.LEFT;
				
				_buttonClear = new PushButton (_window, 0, 0 , "Clear", onClickClear);
				_buttonClear.width = 60;
				
				_light = new IndicatorLight (_window.titleBar, 18, 5, 0x00FF00);
				
				//_textArea.html = true
				_display.addEventListener(P3LogEvent.LOG, onLog);
				_display.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_window.addEventListener(Event.RESIZE, onWindowResize);
				_sharedObject = SharedObject.getLocal("p3-min-debug");
			}
			if ($target) $target.addChild(_display);
			_isInitDone = true;
		}
		
		private function onClickClear($event:MouseEvent = null):void 
		{
			_textField.text = "";
			log("Cleared!");
		}
		
		public function log($text:String, $colour:int = 0x808080, $changeLight:Boolean = false):void
		{
			var htmlText:String = "";
			if (!$changeLight) _light.color = COLOUR_LIGHT_STANDARD;
			else _light.color = $colour;
			if (!_light.isFlashing && _window.minimized) 
			{
				_light.flash(100);
				var timer:Timer = new Timer (30, 50);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onFlashingTimerComplete);
				timer.start();
			}
			if ($colour > 0)
			{
				var frontTag:String = "<font color=\"#" + $colour.toString(16) + "\" >"
				var backTag:String = "</font>";
				htmlText = frontTag + $text + backTag
			}
			trace($text);
			_textField.htmlText += htmlText;
			_scrollPane.update();
			_scrollPane.vScrollbar.value = _scrollPane.vScrollbar.maximum;
			//_textField.scrollV += 1;
			bringToFront();
		}
		
		public function warn ($text:String):void {
			log("WARNING: " + $text, COLOUR_WARN, true)
		}
		
		public function error ($text:String):void{
			log("ERROR: " + $text, COLOUR_ERROR, true)
		}
		
		public function info ($text:String):void{
			log($text, COLOUR_INFO)
		}
		
		public function sent ($text:String):void{
			log("SENT: " + $text, COLOUR_SENT)
		}
		
		public function recived ($text:String):void{
			log("RECIVED: " + $text, COLOUR_RECIVED)
		}
		
		P3Internal function preview ():void	{
			log("Example Log Message");
			warn ("Example Warn Message");
			error ("Example Error Message");
			info ("Example info message");
			sent ("Example sent message");
			recived ("Example recived message");
		}
		
		private function saveSettings ():void {
			var settings:Object =
			{
				window_width:_window.width,
				window_height:_window.height,
				minimized:_window.minimized
			}
			_sharedObject.data.settings = settings;
			_sharedObject.flush(100);
		}
		
		private function loadSettings ():void {
			if (!_sharedObject.data.settings) return;
			var settings:Object = _sharedObject.data.settings 
			_window.width = settings.window_width;
			_window.height = settings.window_height;
			_window.minimized = settings.window_minimized;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			_display.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//loadSettings();
			_stage = _display.stage;
			_window.width = _stage.stageWidth
			_window.y = _stage.stageHeight - _window.height;
			_scrollPane.width = _window.width - 4;
			_scrollPane.height = _window.height - 28;
			_scrollPane.autoHideScrollBar = true;
			_textField.width = _scrollPane.width - 24;
			_buttonClear.x = _window.width - _buttonClear.width - 14;
			_buttonClear.y = _window.height - _buttonClear.height - 28;
			saveSettings();
			log("P3MinCompsDebug version " + _version + " up and running!");
		}
		
		private function onWindowResize(e:Event):void 
		{
			if (_stage) 
			{
				_window.y = _stage.stageHeight - _window.height;
				if (_window.x < 0) _window.x = 0;
				if (_window.x + _window.width > _stage.stageWidth) _window.x = 0;
			}
			if (!_window.minimized) _light.flash(0);
			//saveSettings();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			e.stopPropagation();
		}
		
		private function onLog(e:P3LogEvent):void 
		{
			log(e.text);
		}

		private function onFlashingTimerComplete(e:TimerEvent):void 
		{
			_light.flash(0);
		}
		
		public function hide ():void
		{
			_window.minimized = true;
			
		}
		
		private function bringToFront ():void
		{
			if (_display.parent)
			{
				var target:DisplayObjectContainer = _display
				while (target.parent && target.parent is DisplayObjectContainer)
				{
					target = target.parent;
				}
				_display.parent.removeChild(_display);
				target.addChild(_display);
				//_window.minimized = false;
			}
			else if (_stage)
			{
				_stage.addChild(_display)
				bringToFront();
			}
			_timerRefreshFront.start();
		}

		
	}
	
}