package com.p3.audio.soundcontroller.debug 
{
	//import com.adobe.utils.IntUtil;
	import base.Core;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HUISlider;
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollBar;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Window;
	import com.greensock.loading.core.DisplayObjectLoader;
	import com.p3.audio.soundcontroller.debug.events.P3SoundDebugEvent;
	import com.p3.audio.soundcontroller.P3SoundController;
	import flash.display.DisplayObjectContainer;
	import flash.display.GraphicsPathCommand;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.system.ApplicationDomain;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	//import com.bit101.components.Text;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3SoundDebugSampleList extends Panel
	{
		
		[Embed(source = "data/beep.mp3")] protected var _sampleBeep:Class;
		[Embed(source = "data/music.mp3")] protected var _sampleMusic:Class;
		
		private var _lightSampleNameLegal:IndicatorLight;
		private var _inputTextSampleClass:InputText; 
		private var _comboSoundGroup:ComboBox;
		private var _inputGroupEntry:InputText;
		private var _groupsPanel:Panel;
		private var _inputSoundPanel:Panel;
		
		private var _samplesList:Vector.<P3SoundDebugSample>
		private var _saveSamples:PushButton;
		
		private var m_scroll_panel_samples:ScrollPane
		
		protected var m_slider_volume:HUISlider;
		protected var m_slider_pan:HUISlider;
		
		protected var m_stepper_fade_in:NumericStepper;
		protected var m_stepper_delay:NumericStepper;
		protected var m_stepper_start_time:NumericStepper;
		protected var m_stepper_loops:NumericStepper;
		
			protected var m_panel_init:Panel;
		
		
		private var _sharedObject:SharedObject;
		
		
		public function P3SoundDebugSampleList(parent:DisplayObjectContainer, x:int = 0, y:int = 0) 
		{
			super(parent, x, y)
			//SOUND INIT PANEL
			
			width = 184;

			
			//bindSampleClass(_sampleMusic, "sampleMusic", P3SoundController.SG_MUSIC); 
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(P3SoundDebugEvent.PLAY_SOUND, onPlaySound);
			
			//height = stage.stageHeight
			addEverything();
			//init()
			
		}
		
		private function addEverything():void 
		{
			height = stage.stageHeight - 98;
			
			m_panel_init = new Panel (this, 2, 2);
			m_panel_init.width = 176;
			m_panel_init.height = 120;
			m_panel_init.y = height - m_panel_init.height;
			
			m_slider_volume = new HUISlider (m_panel_init, 2, 2, "Volume");
			m_slider_volume.maximum = 1;
			m_slider_volume.minimum = 0;
			m_slider_volume.tick = 0.01; 
			m_slider_volume.value = 1;
			m_slider_volume.width = 180;
			
			m_slider_pan = new HUISlider (m_panel_init, 2, 22, "Panning");
			m_slider_pan.maximum = 1;
			m_slider_pan.minimum = -1;
			m_slider_pan.tick = 0.01; 
			m_slider_pan.value = 0;
			m_slider_pan.width = 180;
			//m_slider_volume
			
			
			
			//FADE IN
			new Label (m_panel_init, 2, 42, "Fade In:");
			m_stepper_fade_in = new NumericStepper (m_panel_init, 46, 42);
			m_stepper_fade_in.step = 0.1;
			m_stepper_fade_in.minimum = 0;
			m_stepper_fade_in.width = 60;
			//LOOPS
			new Label (m_panel_init, 2, 62, "Loops:");	
			m_stepper_loops = new NumericStepper (m_panel_init, 46, 62, null);
			m_stepper_loops.minimum = -1;
			m_stepper_loops.width = 60;
			
			//FADE IN
			new Label (m_panel_init, 2, 82, "Delay:");
			m_stepper_delay = new NumericStepper (m_panel_init, 46, 82);
			m_stepper_delay.step = 0.1;
			m_stepper_delay.minimum = 0;
			m_stepper_delay.width = 60;
			//LOOPS
			new Label (m_panel_init, 2, 102, "Start:");	
			m_stepper_start_time = new NumericStepper (m_panel_init, 46, 102);
			m_stepper_start_time.minimum = 0;
			m_stepper_delay.step = 0.1;
			m_stepper_start_time.width = 60;
			
			m_scroll_panel_samples = new ScrollPane(this, 4,4 );
			m_scroll_panel_samples.autoHideScrollBar = true;
			//m_scroll_panel_samples
			//m_scroll_panel_samples.
			m_scroll_panel_samples.width = 170;
			m_scroll_panel_samples.height = 180;
			//m_scroll_panel_samples
			
			_samplesList = new Vector.<P3SoundDebugSample> ();
			_sharedObject = SharedObject.getLocal("p3-soundDebug");
			_groupsPanel = new Panel (this, 3, m_panel_init.y - 36);
			_groupsPanel.width = 178;
			_groupsPanel.height = 32;
			//_groupsPanel.height = 103;
			_inputSoundPanel = new Panel (this, 3, _groupsPanel.y -36);
			_inputSoundPanel.width = 108;
			_inputSoundPanel.height = 30;
			_inputSoundPanel
			new Label(_groupsPanel, 2, -3,"Add Group");
			_inputTextSampleClass = new InputText (_inputSoundPanel, 2, 12, "", onClassNameInputChange);
			_inputTextSampleClass.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_inputTextSampleClass.width = 90;
			_lightSampleNameLegal = new IndicatorLight (_inputSoundPanel, 96, 16, 0x00FF00);
			
			new Label(_inputSoundPanel, 2, -3,"Add Sound Class");
			_inputGroupEntry = new InputText (_groupsPanel, 3, 13, "Name");
			_inputGroupEntry.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownGroupEntry);
			_inputGroupEntry.width = 70;
			_inputGroupEntry.height = 18;
			_comboSoundGroup = new ComboBox(_groupsPanel, 76, 12);
			
			//_saveSamples = new PushButton (this, _inputSoundPanel.x + _inputSoundPanel.width + 2, _inputSoundPanel.y, "Save", onClickSaveSamples)
			//_saveSamples.width = 68;
			popuplateSoundGroups();
			//_comboSoundGroup
			
			loadSamples();
			//bindSampleClass(_sampleBeep, "sampleSound");
			if (_samplesList.length == 0)
			{
				bindSampleClass(_sampleBeep, "sampleSound");
				bindSampleClass(_sampleMusic, "sampleMusic", P3SoundController.SG_MUSIC);
			}
		}
		
		private function getParamsObject():Object 
		{
			var paramsObject:Object = {
				volume : m_slider_volume.value,
				loops : m_stepper_loops.value,
				fadeIn : m_stepper_fade_in.value,
				delay : m_stepper_delay.value,
				startTime : m_stepper_start_time.value,
				pan :m_slider_pan.value
					
			}
			return paramsObject;
		}
		
				
		private function onPlaySound(e:P3SoundDebugEvent):void 
		{
			var sample:P3SoundDebugSample = e.data;
			var paramsObject:* = getParamsObject();
			paramsObject.group = sample.groupName;
			P3SoundController.inst.playSound(sample.soundClass,paramsObject)
		}
		
		private function onKeyDownGroupEntry(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				var groupName:String = _inputGroupEntry.text
				P3SoundController.inst.addSoundGroup(groupName);
			}
			popuplateSoundGroups();
		}
		
		//private function onClickSaveSamples(e:Event):void 
		//{
			//saveSamples()
		//}
		
		private function saveSamples():void 
		{
			var ary:Array = new Array ();
			for each (var item:P3SoundDebugSample in _samplesList)
			{
				ary.push(item.save());
			}
			_sharedObject.data.soundArray = ary;
			_sharedObject.flush();
		}
		
		private function loadSamples():void
		{
			if (!_sharedObject.data) return;
			var ary:Array = _sharedObject.data.soundArray;
			for each (var data:Object in ary)
			{
				if (!data) return;
				var hasDef:Boolean = ApplicationDomain.currentDomain.hasDefinition(data.soundClass);
				if (!hasDef) return;
				var sample:P3SoundDebugSample = new P3SoundDebugSample ();
				sample.load(data);
				addSample(sample);
				
			}
		}
		
		private function popuplateSoundGroups():void 
		{
			_comboSoundGroup.removeAll();
			var keysList:Vector.<String> = P3SoundController.inst.getGroupKeys();
			for each (var item:String in keysList)
			{
				_comboSoundGroup.addItem(item);
			}
			_comboSoundGroup.selectedItem = P3SoundController.SG_SOUNDS
		}
		
		private function onClassNameInputChange(e:Event):void 
		{
			//if (
			trace(_inputTextSampleClass.text)
			_lightSampleNameLegal.isLit = ApplicationDomain.currentDomain.hasDefinition(_inputTextSampleClass.text)
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				var className:String = _inputTextSampleClass.text;
				bindSampleString(className);
				var hasDef:Boolean = ApplicationDomain.currentDomain.hasDefinition(className)
				if (hasDef) saveSamples()
			}
			
			
		}
		
		private function bindSampleString($className:String):void 
		{
			var className:String = $className;
			var hasDef:Boolean = ApplicationDomain.currentDomain.hasDefinition(className)
			if (hasDef)
			{
				var classDef:Class = getDefinitionByName(className) as Class;
				bindSampleClass(classDef,className, _comboSoundGroup.selectedItem as String);
			}
			
		}
		
		public function bindSampleClass ($class:Class, $name:String = null, $group:String = ""):void {
			var sampleItem:P3SoundDebugSample = new P3SoundDebugSample ();
			if ($group == "") $group = P3SoundController.inst.soundGroup.key;
			if ($name == "") $name = $class as String;
			//sampleItem.addEventListener(Event.CLOSE, onCloseSampleItem);
			sampleItem.setSoundClass($class, $name, $group);
			sampleItem.x = 2;
			addSample(sampleItem);
		}
		
		private function addSample($sampleItem:P3SoundDebugSample):void 
		{
			if (!$sampleItem.hasClass) return;
			$sampleItem.addEventListener(Event.CLOSE, onCloseSampleItem);
			_samplesList.push($sampleItem);
			sortSampleHeights();
			m_scroll_panel_samples.addChild($sampleItem);
			m_scroll_panel_samples.update();
		}
		
		private function onCloseSampleItem(e:Event):void 
		{
			var sampleItem:P3SoundDebugSample = e.target as P3SoundDebugSample;
			if (sampleItem) removeSampleItem(sampleItem);
		}
		
		private function removeSampleItem($sampleItem:P3SoundDebugSample):void 
		{	
			var index:int = _samplesList.indexOf($sampleItem);
			
			if (index  != -1)
			{
				var sampleItem:P3SoundDebugSample = _samplesList.splice((index), 1)[0];
				sampleItem.removeEventListener(Event.CLOSE, onCloseSampleItem);
				sortSampleHeights();
				if (sampleItem.parent) 
				{
					sampleItem.parent.removeChild(sampleItem);
					m_scroll_panel_samples.update();
				}
			}
			saveSamples();
			
		}
		
		private function sortSampleHeights():void 
		{
			var len:int = _samplesList.length;
			var maxY:int;
			for (var i:int = len - 1; i >= 0; i--)
			{
				var sampleItem:P3SoundDebugSample = _samplesList[i];
				if (sampleItem)
				{
					trace(sampleItem)
					if (sampleItem.parent) sampleItem.parent.removeChild(sampleItem);
					sampleItem.x = 0;
					sampleItem.y = (i * 22) //+  + _inputSoundPanel.height + 2;
					m_scroll_panel_samples.addChild(sampleItem);
					m_scroll_panel_samples.update();
				}
				//if (sampleItem.y + 20 > height)
				//{
					//height = sampleItem.y + 20
				//}
				if (sampleItem.y > maxY)
				{
					maxY = sampleItem.y; 
				}
			}
			//var newHeight:int = maxY  + 24 ;
			//if (newHeight > 70) height = newHeight
			//else height = 70;
		}
		
	}

}