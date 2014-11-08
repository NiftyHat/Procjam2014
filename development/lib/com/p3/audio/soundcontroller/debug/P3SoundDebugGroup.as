package com.p3.audio.soundcontroller.debug 
{
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.VUISlider;
	import com.bit101.components.Window;
	import com.p3.audio.soundcontroller.debug.events.P3SoundDebugEvent;
	import com.p3.audio.soundcontroller.events.P3SoundEvent;
	import com.p3.audio.soundcontroller.objects.P3SoundObject;
	import com.p3.audio.soundcontroller.P3SoundController;
	import com.p3.audio.soundcontroller.P3SoundGroup;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3SoundDebugGroup extends Window 
	{
		private var m_isDirty:Boolean;
		
		protected var m_group:P3SoundGroup;
		
		protected var m_list_sounds:List;
		protected var m_slider_volume:VUISlider;
		protected var m_light_mute:IndicatorLight;
		protected var m_max_sounds:NumericStepper; 
		protected var m_minHeight:int = 90;
		protected var m_shrinkTimer:Timer;
		
		public function P3SoundDebugGroup(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			width = 120
			height = 200;
			m_list_sounds = new List (this, 20, 22);
			m_shrinkTimer = new Timer (1600, 0);
			m_shrinkTimer.start();
			m_shrinkTimer.addEventListener(TimerEvent.TIMER, onShrinkTimer);
			m_list_sounds.height = 60;
			
			m_light_mute = new IndicatorLight (_titleBar, width - 64, 4, 0x00FF00, "isMute");
			m_slider_volume = new VUISlider (this, 1, 2,"Vol", onChangeVolume);
			m_slider_volume.maximum = 1.0;
			m_slider_volume.tick = 0.1;
			m_slider_volume.minimum = 0;
			m_slider_volume.value = 1;
			m_slider_volume.height = m_minHeight - 20;
			m_slider_volume.labelPrecision = 2;
			m_max_sounds = new NumericStepper (this, width - 84, 2, onChangeMax);
			
			m_max_sounds.width = 80;
			shrinkDown();
		}
		
		private function onChangeMax(e:Event):void 
		{
			m_group.max = m_max_sounds.value;
			
		}
		
		private function onShrinkTimer(e:TimerEvent):void 
		{
			if (!m_isDirty) return;
			shrinkDown();
			m_isDirty = false;
		}
		
		
		private function shrinkDown():void
		{
			var listHeight:int = 0;
			if (m_list_sounds.items.length <= 3)
			{
				listHeight = 60;
			}
			else
			{
				listHeight = m_list_sounds.items.length * 20;
			}
			m_list_sounds.height = listHeight;
			height = m_list_sounds.y + m_list_sounds.height + 26;
		}
		
		private function onGroupUpdate(e:P3SoundDebugEvent):void 
		{
			if (e.data == m_group)
			{
				m_isDirty = true;
				refreshList();
			}
			
		}
		
		private function onChangeVolume(e:Event = null):void 
		{
			if (m_group)
			{
				m_group.volume = m_slider_volume.value;
			}
			
		}
		
		public function setGroup ($soundGroup:P3SoundGroup):void
		{
			m_group = $soundGroup;
			title = m_group.key;
			m_slider_volume.value = m_group.volume;
			m_light_mute.isLit = m_group.isMute;
			m_max_sounds.value =  m_group.max;
			P3SoundController.inst.addEventListener(P3SoundDebugEvent.GROUP_UPDATE, onGroupUpdate);
			refreshList();
		}
		
		public function refreshList():void 
		{
			if (!m_group) return;
			m_list_sounds.removeAll();
			//m_list_sounds.draw();
			trace(m_list_sounds.items.length);
			m_light_mute.isLit = m_group.isMute;
			for each (var item:P3SoundObject in m_group.sounds)
			{
				if (item)
				{
					m_list_sounds.addItem( { label:item.key } );
					trace(item.key);
				}
			}
			var listHeight:int = 0;
			if (m_list_sounds.items.length <= 3)
			{
				listHeight = 60;
			}
			else
			{
				listHeight = m_list_sounds.items.length * 20;
			}
			if (listHeight > m_list_sounds.height)
			{
				m_list_sounds.height = listHeight;
				height = m_list_sounds.y + m_list_sounds.height + 26;
			}
			
		}
		
	}

}