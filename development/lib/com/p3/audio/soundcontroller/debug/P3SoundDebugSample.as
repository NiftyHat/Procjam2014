package com.p3.audio.soundcontroller.debug 
{
	import adobe.serialization.json.JSON;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.p3.audio.soundcontroller.debug.events.P3SoundDebugEvent;
	import com.p3.audio.soundcontroller.P3SoundController;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.core.ButtonAsset;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3SoundDebugSample extends Panel
	{
		
		private var _buttonPlay:PushButton;
		private var _labelGroup:Label;
		private var _buttonClose:PushButton;
		private var _class:Class;
		
		private var _soundClass:Class;
		private var _soundName:String;
		private var _groupName:String;
		
		public function P3SoundDebugSample() 
		{
			super();
			height = 23;
			width = 158;
		}
		
		public function setSoundClass ($soundClass:Class, $soundName:String, $groupName:String):void
		{
			//var textButtonLable:String = getQualifiedClassName($soundClass).split("::")[0];
			_class = $soundClass;
			_soundClass = $soundClass;
			_soundName = $soundName;
			_groupName = $groupName;
			_buttonPlay = new PushButton (this, 24, 2, $soundName, onClickPlay);
			_buttonPlay.width = 80;
			_labelGroup = new Label (this, 104, 5, "SG:" +  $groupName);
			_labelGroup.width = 20;
			_buttonClose = new PushButton (this, 4, 2, "X", onClickClose);
			_buttonClose.width = 20;
			_buttonClose.x = 4;
		}
		
		public function load($obj:Object):void {
			var data:Object = $obj;
			var hasDef:Boolean = ApplicationDomain.currentDomain.hasDefinition(data.soundClass);
			if (!hasDef) return;
			var classDef:Class = getDefinitionByName(data.soundClass) as Class;
			_soundClass = classDef;
			_soundName = data.soundName;
			_groupName = data.groupName;
			
			setSoundClass(_soundClass, _soundName, _groupName);
		}
		
		public function save ():Object
		{
			//_soundClass = $soundClass as String;
			var cls:String = getQualifiedClassName(_soundClass)
			var data:Object = {
				soundClass:cls,
				soundName:_soundName,
				groupName:_groupName
			}
			return data;
		}
		
		private function onClickPlay($e:Event):void 
		{
			//P3SoundController.inst.playSound(_class);
			stage.dispatchEvent(new P3SoundDebugEvent(P3SoundDebugEvent.PLAY_SOUND, this, true));
		}
		
		private function onClickClose(e:MouseEvent):void 
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		override public function toString():String {
			return "[P3SoundDebugSample " + _soundName + " ]";
		}
		
		public function get hasClass ():Boolean
		{
			if (_soundClass != null) return true
			return false;
		}
		
		public function get soundClass():Class 
		{
			return _soundClass;
		}
		
		public function get groupName():String 
		{
			return _groupName;
		}
		
	}

}