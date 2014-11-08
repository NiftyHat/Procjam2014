package com.p3.debug 
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3VersionTag extends MovieClip 
	{
		
		private var txt_versionText:TextField;
		private var txt_shadowText:TextField;
		private var _alignment:String;
		private var _string:String;
		
		public function P3VersionTag($string:String = "version" , $alignMode:String = "TR", $alpha:Number = 0.8) 
		{
			super();
			_string = $string;
			_alignment = StageAlign.TOP_LEFT;
			addChildren();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			mouseEnabled = false;
			mouseChildren = false;
			alpha = 0.8;
			setString($string);
			if ($alignMode) _alignment = $alignMode;
			//setAlignment(_alignment);
		}
		
		public function setString($string:String):void 
		{
			_string = $string;
			txt_versionText.text = $string;
			txt_shadowText.text = $string;
		}
		
		/**
		 * Use StageAlign constants.
		 * @param	$mode
		 */
		public function setAlignment($mode:String):void
		{
			_alignment = $mode;
			if (!stage)return;
			var left:int = 0;
			var right:int = stage.stageWidth - txt_versionText.width;
			var bottom:int = stage.stageHeight - txt_versionText.height;
			var top:int = 0;
			var mid_horz:int = stage.stageWidth * 0.5 - txt_versionText.width * 0.5;
			var mid_vert:int = stage.stageHeight * 0.5 - txt_versionText.height * 0.5;
			switch ($mode)
			{
				case StageAlign.BOTTOM:
				setAutoSize(TextFieldAutoSize.CENTER);
				setPosition(mid_horz, bottom);
				break;
				case StageAlign.TOP:
				setAutoSize(TextFieldAutoSize.CENTER);
				setPosition(mid_horz, top);
				break;
				case StageAlign.BOTTOM_LEFT:
				setAutoSize(TextFieldAutoSize.LEFT);
				setPosition(left, bottom);
				break;
				case StageAlign.LEFT:
				setAutoSize(TextFieldAutoSize.LEFT);
				setPosition(left, mid_vert);
				break;
				case StageAlign.TOP_LEFT:
				default:
				setAutoSize(TextFieldAutoSize.LEFT);
				setPosition(left, top);
				break;
				case StageAlign.RIGHT:	
				setAutoSize(TextFieldAutoSize.RIGHT);
				setPosition(right, mid_vert);
				break;
				case StageAlign.BOTTOM_RIGHT:
				setAutoSize(TextFieldAutoSize.RIGHT);
				setPosition(right, bottom);	
				break;
				case StageAlign.TOP_RIGHT:
				setAutoSize(TextFieldAutoSize.RIGHT);
				setPosition(right, top);				
				break;
			}
		}
		
		public function setPosition($x:int, $y:int):void 
		{
			txt_versionText.x = $x;
			txt_versionText.y= $y;
			txt_shadowText.x = txt_versionText.x + 1
			txt_shadowText.y = txt_versionText.y + 1;
		}
		
		private function setAutoSize($mode:String):void 
		{
			txt_versionText.autoSize = $mode;
			txt_shadowText.autoSize = $mode;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			setAlignment(_alignment);
		}
		
		private function addChildren():void 
		{
			txt_versionText = new TextField ()
			txt_shadowText = new TextField ()
			txt_versionText.defaultTextFormat = new TextFormat ("Tahoma", 9, 0xFFFFFF, true);
			txt_shadowText.defaultTextFormat = new TextFormat ("Tahoma", 9, 0x000000, true);
			txt_versionText.height = 13;
			txt_shadowText.height = 13;
			addChild(txt_shadowText);
			addChild(txt_versionText);
		}
		
	}

}