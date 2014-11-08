package com.p3.audio.soundcontroller.debug 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import com.p3.audio.soundcontroller.P3SoundController;
	import flash.display.MovieClip;
	import flash.events.Event;
	import sfx.mus_long;
	import sfx.mus_loop;
	import sfx.snd_loop;
	import sfx.snd_oneshot;
	
	/**
	 * P3 Sound Controller debbugging tool v0.7. PLAY ALL THE SOUNDS!
	 * Ugly as hell but it's let me test the sound engine 2.0 to death.
	 * TODO - 23rd of May, Duncan. 
	 * Allow loading of other sounds for more testing.
	 * Clean up the UI, add some nice lables, split into panels. 
	 * Refactor into the sound package for common sense
	 * Add inbuilt support for automatically debugging groups, spawning new windows when they are created. Toggleable
	 * 
	 * @author Duncan Saunders
	 */
	public class P3SoundDebug extends MovieClip 
	{
		
		protected var m_win_main:Window;
		
		protected var m_bnt_sound:PushButton;
		protected var m_bnt_music:PushButton;
		protected var m_bnt_sound_loop:PushButton;
		protected var m_bnt_music_loop:PushButton;
		
		protected var m_btn_pause:PushButton;
		protected var m_btn_fadeOut:PushButton;
		
		protected var m_slider_volume:HUISlider;
		protected var m_stepper_fade_in:NumericStepper;
		protected var m_stepper_fade_out:NumericStepper;
		protected var m_stepper_loops:NumericStepper;
		
		protected var m_chk_mute:CheckBox;
		
		protected var m_paused:Boolean;
		
		protected var m_group_music_debug:P3SoundGroupDebug;
		protected var m_group_sound_debug:P3SoundGroupDebug;
		protected var m_btn_saveSettings:PushButton;
		
		
		public function P3SoundDebug() 
		{
			super();
			m_win_main = new Window (this, 0, 0, "Test");
			m_win_main.width = 240;
			m_win_main.height = 200;
			m_bnt_sound = new PushButton(m_win_main, 2, 2, "Play Sound", onClickPlaySound);
			m_bnt_sound.width = 60;
			m_bnt_music = new PushButton(m_win_main, 62, 2, "Play Music", onClickPlayMusic);
			m_bnt_music.width = 60;
			m_bnt_sound_loop = new PushButton(m_win_main, 122, 2, "Loop Sound", onClickPlaySoundLoop);
			m_bnt_sound_loop.width = 60;
			m_bnt_sound = new PushButton(m_win_main, 182, 2, "Loop Music", onClickPlayMusicLoop);
			m_bnt_sound.width = 60;
			m_slider_volume = new HUISlider (m_win_main, 2, 40, "Volume", onVolumeSliderChange);
			m_slider_volume.maximum = 1;
			m_slider_volume.minimum = 0;
			m_slider_volume.value = 1.0;
			
			//m_slider_volume.labelPrecisio
			new Label (m_win_main, 2, 60, "Fade In:");
			m_stepper_fade_in = new NumericStepper (m_win_main, 40, 60, onChangeFadeIn);
			m_stepper_fade_in
			m_stepper_fade_in.step = 0.1;
			m_stepper_fade_in.minimum = 0;
			new Label (m_win_main, 2, 80, "Loops:");	
			m_stepper_loops = new NumericStepper (m_win_main, 40, 80, null);
			m_stepper_loops.minimum = -1;

			
			m_btn_pause =  new PushButton (m_win_main, 2, 140, "| |", onClickPauseResume);
			m_btn_pause.width = 20;
			m_btn_fadeOut = new PushButton (m_win_main, 22, 140, "FadeOut", onClickFadeout); 
			m_btn_fadeOut.width = 80;
			m_stepper_fade_out = new NumericStepper (m_win_main, 102, 142, onChangeFadeOut);
			m_stepper_fade_out.value = 0.5;
			m_stepper_fade_out.step = 0.1;
			m_stepper_fade_out.minimum = 0;
			m_btn_saveSettings = new PushButton (m_win_main, 22, 160, "Save Settings", onClickSaveSettings);
			m_btn_saveSettings.width = 80;
			
			m_chk_mute = new CheckBox (m_win_main, 108, 164, "Mute", onClickMuteCheck);
			P3SoundController.inst.loadCache();
			m_chk_mute.selected = P3SoundController.inst.isMute;
			m_group_music_debug = new P3SoundGroupDebug (this, 240, 0)
			m_group_music_debug.setGroup(P3SoundController.inst.getSoundGroup(P3SoundController.SG_MUSIC));
			m_group_sound_debug = new P3SoundGroupDebug (this, 380, 0);
			m_group_sound_debug.setGroup(P3SoundController.inst.getSoundGroup(P3SoundController.SG_SOUNDS));
		}
		
		private function onClickMuteCheck($e:Event):void 
		{
			P3SoundController.inst.toggleMute(m_chk_mute.selected);
			m_group_music_debug.refreshList();
			m_group_sound_debug.refreshList();
		}
		
		private function onClickSaveSettings($e:Event):void 
		{
			P3SoundController.inst.saveCache();
		}
		
		private function onClickFadeout($e:Event):void 
		{
			P3SoundController.inst.stopAllSounds(m_stepper_fade_out.value);
		}
		
		private function onClickPauseResume($e:Event):void 
		{
			m_paused = !m_paused;
			if (m_paused)
			{
				P3SoundController.inst.pauseAllSounds();
				m_btn_pause.label = "| >";
			}
			else
			{
				P3SoundController.inst.resumeAllSounds();
				m_btn_pause.label = "| |";
			}
		}
		
		private function onChangeFadeOut($event:Event):void 
		{
			
		}
		
		private function onChangeFadeIn($event:Event):void 
		{
			
		}
		
		private function onVolumeSliderChange($event:Event):void 
		{
			
		}
		
		private function onClickPlayMusicLoop($event:Event):void 
		{
			P3SoundController.inst.playMusic(snd_loop, { fadeIn:m_stepper_fade_in.value, fadeOut:m_stepper_fade_out.value, volume:m_slider_volume.value, loops:m_stepper_loops.value, delay:1 } );
		}
		
		private function onClickPlaySoundLoop($event:Event):void 
		{
			P3SoundController.inst.playSound(snd_loop, {fadeIn:m_stepper_fade_in.value, fadeOut:m_stepper_fade_out.value, volume:m_slider_volume.value, loops:m_stepper_loops.value});
		}
		
		private function onClickPlayMusic($event:Event):void 
		{
			//P3SoundController.inst.playSound(mus_loop, {fade_in:m_stepper_fade_in.value, fade_out:m_stepper_fade_out.value, volume:m_slider_volume.value, loops:m_stepper_loops.value});
			//P3SoundController.inst.playSoundClass(mus_loop, 0.4, 5);
			P3SoundController.inst.playMusic(mus_loop, { fadeIn:m_stepper_fade_in.value, fadeOut:m_stepper_fade_out.value, volume:m_slider_volume.value, loops:m_stepper_loops.value } );
			m_group_music_debug.refreshList();
		}
		
		private function onClickPlaySound($event:Event):void 
		{
			P3SoundController.inst.playSound(snd_oneshot, {fadeIn:m_stepper_fade_in.value, fadeOut:m_stepper_fade_out.value, volume:m_slider_volume.value, loops:m_stepper_loops.value});
		}
		
	}

}