package com.p3.loading.preloader 
{
	import com.greensock.loading.core.DisplayObjectLoader;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import mx.core.MovieClipLoaderAsset;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	
	 
	 
	public class P3PreloaderGearSkin extends Sprite
	{
		private var _mc_background	:Sprite;
		private var _mc_logo		:MovieClipLoaderAsset;
		private var _txt_title		:TextField;
		private var _txt_version	:TextField;
		private var _txt_perc		:TextField;
		private var _txt_loading	:TextField;
		private var _txt_log		:TextField;
		private var _mc_bar			:MovieClip;
		private var _mc_bar_bg 		:MovieClip;
		
		private var _versionString	:String = "";
		private var _tweenTimer		:Timer;
		private var _isBeingRemoved:Boolean;
		
		[Embed(source = "assets/p3_preloader_gear.swf")]private var _defaultGraphics:Class 
		
		public function P3PreloaderGearSkin():void
		{
			if (!stage) addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			else init();
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		public function setVersion ($string:String):void
		{
			_versionString = $string;
			if (_txt_version) _txt_version.text = $string;
		}
		
		private function init():void 
		{
			_mc_background = new Sprite ();
			
			_mc_logo = new _defaultGraphics()
			
			_txt_title = new TextField ()
			_txt_loading = new TextField ();
			_txt_perc = new TextField ();
			_txt_version = new TextField ();
			_txt_log = new TextField ();
			
			
			_mc_bar = new MovieClip ();
			_mc_bar_bg = new MovieClip ();
			
			const BAR_WIDTH:int = 184;
			
			_mc_background.graphics.beginFill(0x000000, 1);
			_mc_background.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			
			_txt_title.defaultTextFormat = new TextFormat ("Trebuchet MS", 20, 0xFFFFFF, false, null, null, null, null, "center");
			_txt_title.antiAliasType = AntiAliasType.ADVANCED;
			_txt_title.selectable = false;
			_txt_title.width = stage.stageWidth;
			_txt_title.autoSize = TextFieldAutoSize.CENTER
			_txt_title.text = "Loading Scene";
			center(_txt_title, false) 
			
			_txt_title.y -= 16;
			
			var rect_bar:Rectangle = new Rectangle ((stage.stageWidth * 0.5) - BAR_WIDTH * 0.5, stage.stageHeight * 0.5 , BAR_WIDTH, 4)
			
			_mc_bar_bg.graphics.lineStyle(1, 0xC0C0C0, 1);
			_mc_bar_bg.graphics.drawRect(0, 0, rect_bar.width + 3, rect_bar.height + 3);
			_mc_bar_bg.x = rect_bar.x - 2
			_mc_bar_bg.y = rect_bar.y - 2
			
			_mc_bar.graphics.beginFill(0xFFFFFF, 1);
			_mc_bar.graphics.drawRect(0,0,rect_bar.width,rect_bar.height);
			_mc_bar.x = rect_bar.x;
			_mc_bar.y = rect_bar.y;
			
			
			_mc_logo.y = _txt_title.y + 16;
			_mc_logo.x = _txt_title.x + _txt_title.width + 30;
			
			
			_txt_loading.defaultTextFormat = new TextFormat ("Trebuchet MS", 20, 0xFFFFFF, false, null, null, null, null, "center");
			_txt_loading.antiAliasType = AntiAliasType.ADVANCED;
			_txt_loading.selectable = false;
			_txt_loading.width = 200;
			_txt_loading.text = "0";
			center(_txt_loading);
			_txt_loading.y = _mc_bar.y - _txt_loading.textHeight - 2;
			
			_txt_version.defaultTextFormat = new TextFormat ("Trebuchet MS", 10, 0xFFFFFF, false,null,null,null,null,"left");
			_txt_version.autoSize = TextFieldAutoSize.LEFT;
			_txt_version.selectable = false;
			_txt_version.text = _versionString;
			_txt_version.y = stage.stageHeight - _txt_version.textHeight - 1;
			_txt_version.x = 1;
			
			_txt_log.defaultTextFormat = new TextFormat ("Trebuchet MS", 10, 0xC0C0C0, false,null,null,null,null,"left");
			//_txt_log.autoSize = TextFieldAutoSize.LEFT;
			_txt_log.selectable = false;
			_txt_log.text = "log.... \n";
			_txt_log.y = 0;
			_txt_log.x = 1;
			//_txt_log.height = 180;
			_txt_log.width = stage.stageWidth;
			_txt_log.scrollRect = new Rectangle (0, 0, stage.stageWidth, 300);
			
			addChild(_mc_background);
			addChild(_mc_logo);
			addChild(_mc_bar_bg);
			addChild(_mc_bar);
			addChild(_txt_title);
			//addChild(_txt_loading);
			addChild(_txt_perc);
			addChild(_txt_version);
			addChild(_txt_log);
		}
		
		private function center ($object:DisplayObject, $isCenterPoint:Boolean = false):void
		{
			$object.x = (stage.stageWidth * 0.5) - ($isCenterPoint ? 0 :($object.width * 0.5));
			$object.y = (stage.stageHeight * 0.5) - ($isCenterPoint ? 0 :($object.height * 0.5));
		}
		
		public function update ($perc:Number):void
		{
			if (_mc_bar) _mc_bar.scaleX = $perc / 100;
			if (_txt_loading) _txt_loading.text = String(int($perc)) + "%";
		}
		
		public function remove():void 
		{
			_isBeingRemoved = true;
			_tweenTimer = new Timer (20, 5);
			_tweenTimer.addEventListener(TimerEvent.TIMER, onUpdateTween);
			_tweenTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTween);
			_tweenTimer.start();
		}
		
		public function destroy():void
		{
			if (parent) parent.removeChild(this);
			if (_tweenTimer)
			{
				_tweenTimer.stop();
				_tweenTimer.removeEventListener(TimerEvent.TIMER, onUpdateTween);
				_tweenTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCompleteTween);
				_tweenTimer = null;
				
			}
			while (numChildren > 1) removeChildAt(0);
			_mc_background	= null;
			_mc_logo		= null;
			_txt_title		= null;
			_txt_version	= null;
			_txt_perc		= null;
			_txt_loading	= null;
			_txt_log		= null;
			_mc_bar			= null;
		}
		
		private function onCompleteTween(e:TimerEvent):void 
		{
			destroy();
		}
		
		private function onUpdateTween(e:TimerEvent):void 
		{
			alpha = 1 - (1.0 / _tweenTimer.repeatCount) * _tweenTimer.currentCount;
			//_txt_log.y -= 10;
			//_mc_bar.scaleX = 1 - (1.0 / _tweenTimer.repeatCount) * _tweenTimer.currentCount;
		}
			
		public function addLogText($text:String, $colour:int = -1):void 
		{
			
			if (!_txt_log) return;
			_txt_log.appendText($text + "\n");
			if ($colour > 0)
			{
				var len:int = _txt_log.text.length - 1;
				_txt_log.setTextFormat(new TextFormat("Trebuchet MS",8, $colour),len - $text.length, len + 1);
			}
			_txt_log.scrollV += 1;
			//_txt_log.
		}
		
	}
}