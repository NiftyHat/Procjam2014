package com.p3.audio.soundcontroller.debug 
{
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.InputText;
	import com.bit101.components.List;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.VUISlider;
	import com.bit101.components.Window;
	import com.p3.audio.soundcontroller.events.P3SoundEvent;
	import com.p3.audio.soundcontroller.objects.P3SoundObject;
	import com.p3.audio.soundcontroller.P3SoundController;
	import com.p3.audio.soundcontroller.P3SoundGroup;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3SoundGroupDebug extends Window 
	{
		
		protected var m_group:P3SoundGroup;
		
		protected var m_list_sounds:List;
		protected var m_slider_volume:VUISlider;
		protected var m_light_mute:IndicatorLight;
		protected var m_max_sounds:InputText;
		
		public function P3SoundGroupDebug(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Window") 
		{
			super(parent, xpos, ypos, "");
			width = 140
			height = 200;
			m_list_sounds = new List (this, 30, 22);
			m_list_sounds.height = height - m_list_sounds.y - 30;
			m_light_mute = new IndicatorLight (this, 32, 6, 0x00FF00, "Mute");
			m_slider_volume = new VUISlider (this, 2, 2, "Vol", onChangeVolume);
			m_slider_volume.maximum = 1.0;
			m_slider_volume.minimum = 0;
			m_slider_volume.labelPrecision = 2;
			m_max_sounds = new InputText (this, width - 64, 2,"");
			m_max_sounds.width = 60;
		}
		
		private function onGroupUpdate(e:P3SoundEvent):void 
		{
			refreshList();
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
			m_max_sounds.text = String(m_group.max);
			P3SoundController.inst.addEventListener(P3SoundEvent.GROUP_UPDATE, onGroupUpdate);
			refreshList();
		}
		
		public function refreshList():void 
		{
			if (!m_group) return;
			m_list_sounds.removeAll();
			 m_light_mute.isLit = m_group.isMute;
			for each (var item:P3SoundObject in m_group.sounds)
			{
				if (item) m_list_sounds.addItem( { label:item.key } );
			}
		}
		
	}

}