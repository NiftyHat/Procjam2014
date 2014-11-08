package com.p3.audio.soundcontroller 
{
	import com.p3.audio.soundcontroller.objects.IP3SoundObject;
	import com.p3.audio.soundcontroller.objects.P3SoundObject;

	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3SoundGroup 
	{
		
		public var max:int = 0xFFFF;
		protected var _key:String;
		protected var _count:int;
		protected var _sounds:Dictionary;
		protected var _isMute:Boolean;
		protected var _isPaused:Boolean;
		protected var _volume:Number = 1.0;
		
		public function P3SoundGroup($key:String) 
		{
			_key = $key;
			_sounds = new Dictionary();
			max = 0xFFFF;
		}
		
		public function addSound(sndObj:P3SoundObject):void 
		{
			_sounds[sndObj] = sndObj;
			sndObj.group = this;
			sndObj.update();
			_count++;
		}
		
		public function removeSound(sndObj:P3SoundObject):void
		{
			_sounds[sndObj] = null;
			delete _sounds[sndObj];
			_count--;
		}
		
		public function getVolume():Number 
		{
			return _volume;
		}
		
		public function pause():void 
		{
			_isPaused = true;
			for each (var sound:P3SoundObject in _sounds)
			{
				if(sound) sound.pause();
			}
		}
		
		public function resume():void {
			_isPaused = false;
			for each (var sound:P3SoundObject in _sounds)
			{
				if(sound) sound.resume();
			}
		}
		
		public function fadeOut($time:Number):void 
		{
			for each (var sound:P3SoundObject in _sounds)
			{
				if(sound) sound.fadeOut($time);
			}
		}
		
		public function mute ():void
		{
			if (_isMute) return;
			_isMute = true;
			for each (var sound:P3SoundObject in _sounds)
			{
				if(sound) sound.mute();
			}
		}
		
		public function unmute():void
		{
			if (!_isMute) return;
			_isMute = false;
			for each (var sound:P3SoundObject in _sounds)
			{
				if(sound) sound.unmute();
			}
		}
		
		public function saveSettings():Object 
		{
			var cacheObject:Object = { key:_key, volume:_volume, mute:_isMute };
			return cacheObject;
		}
		
		public function loadSettings($object:Object):void 
		{
			var cacheObject:Object = $object;
			if (cacheObject.volume) volume = cacheObject.volume;
			if (cacheObject.mute) 
			{
				mute();
			}
		}
		
		
		public function get isMaxSounds():Boolean 
		{
			if (_count > max) return true;
			return false;
		}
		
		public function get sounds():Dictionary { return _sounds; }
		
		public function get isMute():Boolean { return _isMute; }
		
		public function get key():String 
		{
			return _key;
		}

		public function get volume():Number 
		{
			return _volume * (_isMute ? 0 : 1);
		}
		
		public function set volume($volume:Number):void 
		{
			_volume = $volume;
			if ($volume > 1) $volume = 1;
			if ($volume < 0) $volume = 0;
			for each (var sndObj:IP3SoundObject in _sounds)
			{
				if (sndObj) sndObj.update();
			}
		}
		
		public function get isPaused():Boolean 
		{
			return _isPaused;
		}
		
		public function set isMute(value:Boolean):void 
		{
			if (value) mute();
			else unmute();
		}
		
	}

}