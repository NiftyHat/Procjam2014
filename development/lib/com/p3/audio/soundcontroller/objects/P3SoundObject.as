package com.p3.audio.soundcontroller.objects
{
	import com.p3.audio.soundcontroller.P3SoundGroup;
	import com.p3.audio.soundcontroller.events.P3SoundEvent;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	
	/**
	 * Play event is dispatched when the sound starts playing, won't fire until after delay is complete.
	 */
	[Event(name = "play", type = "com.p3.audio.soundcontroller.events.P3SoundEvent")] 
	/**
	 * Complete event is dispatched when the sound is done playing. It won't get called on a sound loop, only when the sound is done playing or fading out.
	 */
	[Event(name = "complete", type = "com.p3.audio.soundcontroller.events.P3SoundEvent")]
	/**
	 * Loaded event is dispatched when a sound is loaded using the "url" paramter in it's vars.
	 */
	[Event(name="loaded", type="com.p3.audio.soundcontroller.events.P3SoundEvent")]
	/**
	 * Destroy event is dispatched after the destroy funciton is done (so the sound object is pretty much a shell).
	 */
	[Event(name = "destroy", type = "com.p3.audio.soundcontroller.events.P3SoundEvent")] 
	/**
	 * Pre-Destroy is event is dispatched at the start of the destroy function so you can grab the group/channel/whatever else before flash trashes it.
	 */
	[Event(name = "preDestroy", type = "com.p3.audio.soundcontroller.events.P3SoundEvent")]

	/**
	 * P3SoundObject
	 * Wrapper for the sound data handled by the P3Sound manager. Handles all the important sound level controls like
	 * creating and removing sound channels for each sound, eternal looping, volume adjusting, panning, pausing.
	 * @author Duncan Saunders
	 * 
	 */
		
	public class P3SoundObject extends EventDispatcher implements IP3SoundObject
	{
		
		//ID Stuff
		protected var _group			:P3SoundGroup	= null;
		protected var _key				:String			= "";
		
		//Playback stuff
		protected var _soundSource		:Sound;
		protected var _channel			:SoundChannel;
		
		//Basic sound handling
		protected var _position			:Number 		= 0;
		protected var _delay			:Number 		= 0;
		protected var _volume			:Number 		= 1;
		protected var _startTime		:Number 		= 0;
		protected var _loops			:int 			= 0;
		protected var _isPlaying		:Boolean 		= false;
		protected var _pan				:Number			= 0;

		//Custom behavoir flags.
		protected var _isManualDestroy	:Boolean		= true;
		protected var _isManualPlay		:Boolean;
		protected var _isMute			:Boolean 		= false;
		protected var _isLoading		:Boolean;
	
		//Fading handling to escape the clutches of TweenMax
		protected var _fadeOutTimer		:Timer;
		protected var _fadeInTimer		:Timer;
		protected var _fadeScale		:Number = 1;
		protected var _fadeOut			:Number;
		
		//Position markers for pause/resume and eternal looping
		protected var _pausePosition	:Number;
		protected var _loopsPosition	:Number = 0 ;
		
		//Callbacks.
		protected var _onComplete		:Function;
		protected var _onCompleteParams	:Array;
		
		protected var _onFadeInCallback	:Function;
		protected var _onFadeOutCallback:Function;
		
		protected var _loader:Loader;
		
		protected var delayTimeoutID:int = -1;
		protected var _fadeInValue:Number = 0;
		
		
		/**
		 * P3SoundObject
		 * Manages all the fiddly fading/looping/pausing for sounds. If you want it to be managed then you need to construct using
		 * P3SoundController.playSound(). You can still manually make sounds and use them, but they won't use the centralized memory
		 * management or volume controls.
		 * @param	$class class to construct the sound with. If you want to load in use a flash.media.Sound derivative
		 */
		public function P3SoundObject ($class:Class = null):void
		{
			super(this);
			if ($class) _soundSource = Sound(new $class);
		}
		
		public function play ($force_restart:Boolean = false):SoundChannel
		{
			if (isPlaying && !$force_restart || _isLoading) return _channel;
			
			var startPosition:Number = $force_restart ? 0: position;
			if (_startTime > 0)  startPosition = _startTime;
			if (delay > 0) 
			{
				delayTimeoutID = setTimeout(play, delay * 1000);
				_channel = new SoundChannel ();
				_delay = 0;
				return _channel;
			}
			_isPlaying = true;
			if (!(_group && _group.isPaused))
			{
				if (soundSource)
				{
					if (!_fadeInTimer) _channel = soundSource.play(startPosition, 1, new SoundTransform(_volume,_pan));
					else _channel = soundSource.play(startPosition, 1, new SoundTransform(0,_pan));	
				}
				
				
			}
			else 
			{
				_pausePosition = 0;
				_channel = new SoundChannel ();
			}
			updateVolume();
			if (_channel) 
			{
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandle);
				dispatchEvent(new P3SoundEvent(P3SoundEvent.PLAY, this));
			}
			
			return _channel;
		}

		protected function updateVolume ():void
		{
			if (!_channel) return;
			if (_isMute) 
			{
				_channel.soundTransform = new SoundTransform(0,_pan);
				return;
			}
			var group_volume:Number = 1;
			if (_group) 
			{
				if (_group.isMute)group_volume = 0;
				else group_volume = _group.volume;
			}
			//trace("volume", volume , group_volume , _fadeScale);
			var new_volume:Number = volume * group_volume * _fadeScale;
			if (new_volume > 1) new_volume = 1;
			if (new_volume < 0) new_volume = 0;
			_channel.soundTransform = new SoundTransform(new_volume,_pan);
		}
		
		public function pause ():void
		{
			//trace(_key + " paused");
			if (!_channel) return;
			_pausePosition = _channel.position;
			if (_pausePosition >= soundSource.length) _pausePosition = 0;
			if (_fadeInTimer)_fadeInTimer.stop();
			if (_fadeOutTimer)_fadeOutTimer.stop();
			_channel.stop();
		}
		
		public function resume ():void
		{
			if (!_channel) return;
			if (_fadeInTimer)_fadeInTimer.start();
			if (_fadeOutTimer)_fadeOutTimer.start();
			if (!isNaN(_pausePosition))
			{
				_channel = soundSource.play(_pausePosition);
				updateVolume();
				_pausePosition = NaN;
			}
			_channel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandle);
		}
		
		public function stop ():void
		{
			if (!_channel) return;
			_channel.stop();
			_isPlaying = false;
			if (!_isManualDestroy) destroy();
		}
		
		public function update ():void
		{
			updateVolume();
		}
		
		public function fadeIn($time:Number = 1, $onFadeCallback:Function = null):void 
		{
			_onFadeInCallback = $onFadeCallback;
			_fadeScale = 0;
			_fadeInTimer = new Timer (0.001, $time * 100);
			_fadeInTimer.addEventListener(TimerEvent.TIMER, onFadeInLoop);
			_fadeInTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFadeInComplete);
			_fadeInTimer.start();
		}
		
		private function onFadeInLoop(e:TimerEvent):void 
		{
			if (_channel && _fadeInTimer) 
			{
				_fadeScale = (1 /  _fadeInTimer.repeatCount) * _fadeInTimer.currentCount;
				updateVolume();
			}
				
		}
		
		private function onFadeInComplete(e:TimerEvent):void 
		{
			if (_fadeInTimer)
			{
				_fadeInTimer.removeEventListener(TimerEvent.TIMER, onFadeInLoop);
				_fadeInTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFadeInComplete);
				_fadeInTimer = null;
			}
			if (_onFadeInCallback != null) _onFadeInCallback.call();
		}
		
		public function fadeOut($time:Number = 1, $onFadeCallback:Function = null, $autoDestroy:Boolean = true):void 
		{
			_onFadeOutCallback = $onFadeCallback; 
			if (!$autoDestroy) _isManualDestroy = false;
			//if for some reason the fade is instant fake the timer completing anyway to avoid funky volume changes.
			if ($time == 0) onFadeOutComplete(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			_fadeOutTimer = new Timer (0.001, $time * 100);
			_fadeOutTimer.addEventListener(TimerEvent.TIMER, onFadeOutLoop);
			_fadeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFadeOutComplete);
			_fadeOutTimer.start();
		}
		
		private function onFadeOutLoop(e:TimerEvent):void 
		{
			if (_channel && _fadeOutTimer) 
			{
				_fadeScale = 1 - ((1 /  _fadeOutTimer.repeatCount) * _fadeOutTimer.currentCount);
				updateVolume();
			}
		}
		
		private function onFadeOutComplete(e:TimerEvent):void 
		{
			//channel.soundTransform = new SoundTransform(volume - ((volume /  fadeOutTimer.repeatCount) * fadeOutTimer.currentCount));
			if (_fadeOutTimer)
			{
				_fadeOutTimer.removeEventListener(TimerEvent.TIMER, onFadeOutLoop );
				_fadeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFadeOutComplete);
				_fadeOutTimer = null;
			}
			if (_onFadeOutCallback != null) _onFadeOutCallback.call();
			stop();
			if (!_isManualDestroy) 
			{
				//stop the sound from looping since you are force fading it out
				//_loops = _loopsPosition = 0;
				if (_channel) _channel.dispatchEvent(new Event(Event.SOUND_COMPLETE));
			}
		}

		protected function onSoundCompleteHandle(e:Event):void 
		{
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandle);
			if (_loopsPosition < loops || loops == -1)
			{
				_loopsPosition++;
				_position = 0;
				play(true);
			}
			else
			{
				_isPlaying = false;
				if (_onComplete != null) callOnComplete();
				dispatchEvent(new P3SoundEvent(P3SoundEvent.COMPLETE, this));
			}
		}
		
		private function callOnComplete():void 
		{
			if (!_onCompleteParams) 
			{
				//no parameters so just do a strait call
				if (_onComplete.length == 0)
					_onComplete();
				else
					trace(this, "WARNING: No argument supplied");
			}
			else 
			{
				//sneaky check to make sure onComplete is ok to take the params
				if (_onComplete.length >= _onCompleteParams.length)
				{
					_onComplete.apply(_onCompleteParams);
				}
				else
				{
					//otherwise throw a warning and prune the parameters down so that it can still fire without OMGWTF crashing everything.
					trace(this, "WARNING: onComplete function can't accept the number of parameters you want to parse.");
					_onCompleteParams.length = _onComplete.length;
					_onComplete.apply(_onCompleteParams);
				}
				
			}
		}
		
		public function destroy():void
		{
			//if (_isPlaying) trace(this, "WARNING " + " destroying sounds whilst playing my have odd consequences");
			dispatchEvent(new P3SoundEvent(P3SoundEvent.PRE_DESTROY, this));
			if (_channel)
			{
				_channel.stop();
				_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandle);				
			}
			if (_fadeInTimer)
			{
				_fadeInTimer.removeEventListener(TimerEvent.TIMER, onFadeInLoop);
				_fadeInTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFadeInComplete);
			}
			if (_fadeOutTimer)
			{
				_fadeOutTimer.removeEventListener(TimerEvent.TIMER, onFadeOutLoop);
				_fadeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFadeOutComplete);
			}
			if (_group) _group.removeSound(this);
			if (delayTimeoutID != -1) clearTimeout(delayTimeoutID);
			_onFadeInCallback 	= null;
			_onComplete 		= null;
			_onCompleteParams 	= null;
			_key				= null;
			_soundSource		= null;
			_channel			= null;
			_position			= 0;
			_fadeOutTimer		= null;
			_fadeInTimer		= null;
			dispatchEvent(new P3SoundEvent(P3SoundEvent.DESTROY, this));
		}
		
		public function setVolume ($value:Number):void
		{
			if (_group.isMute) return;
			volume = $value;
			updateVolume();
		}
		
		public function initVars($vars:Object):void 
		{
			var fadeInValue:Number;
			var startVolume:Number= 1;
			var pan:Number = 0;
			
			_fadeInValue = ($vars.fadeIn) ? Number($vars.fadeIn) : 0;
			if (_fadeInValue <= 0) 
			{
				_fadeScale = 1;
				_fadeInValue = 0;
			}
			if ($vars.onComplete) _onComplete = $vars.onComplete;
			if ($vars.onCompleteParams) _onCompleteParams = $vars.onCompleteParams;
			if ($vars.pan)_pan = $vars.pan;
			if (_pan > 1) _pan = 1;
			if (_pan < -1) _pan = -1;
			if ($vars.fadeOut) _fadeOut = $vars.fadeOut;
			if ($vars.url)
			{
				var context:SoundLoaderContext = $vars.context; 
				var url:String = $vars.url;
				_soundSource.load(new URLRequest(url), context);
				_soundSource.addEventListener(Event.ID3, onSoundLoadedHandle);
				_isLoading = true;
			}
			//_volume = 1;
			if ($vars.volume != null)  startVolume = $vars.volume;
			
			_startTime = ($vars.startTime) ? Number($vars.startTime) : 0;
			_loops = ($vars.loops) ? int($vars.loops) : 0;
			if (_loops == int.MAX_VALUE) _loops = -1;
			update();
			_volume = startVolume;
			_delay = ($vars.delay) ? Number($vars.delay) : 0;
			_isManualDestroy = $vars.manualDestroy;
			_isManualPlay = $vars.manualPlay;
			if (!$vars.manualPlay && !_isLoading)
			{
				if (_fadeInValue > 0) fadeIn(_fadeInValue);
				play();	
			}
			
		}
		
		private function onSoundLoadedHandle(e:Event):void 
		{
			_isLoading = false;
			dispatchEvent(new P3SoundEvent(P3SoundEvent.LOADED, this));
			if (!_isManualPlay) 
			{
				if (_fadeInValue > 0) fadeIn(_fadeInValue);
				play();	
			}
		}
		
		public function mute():void 
		{
			_isMute = true;
			updateVolume();
		}
		
		public function unmute():void 
		{
			_isMute = false;
			updateVolume();
		}
		
		public function get key():String 
		{
			return _key;
		}
		
		public function get delay():Number 
		{
			return _delay;
		}
		
		public function get position():Number 
		{
			if (_channel) return _channel.position;
			return _position;
		}
		
		public function get volume():Number 
		{
			return _volume;
		}
		
		public function set volume(value:Number):void 
		{
			_volume = value;
			updateVolume();
		}
		
		public function get startTime():Number 
		{
			return _startTime;
		}
		
		public function get loops():int 
		{
			return _loops;
		}
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		

		
		public function get pause_position():Number 
		{
			return _pausePosition;
		}
		
		public function get soundSource():Sound 
		{
			return _soundSource;
		}
		
		public function set soundSource(value:Sound):void 
		{
			if (_soundSource == null) _soundSource = value;
		}
		
		public function set key(value:String):void 
		{
			_key = value;
		}
		
		public function get group():P3SoundGroup 
		{
			return _group;
		}
		
		public function set group(value:P3SoundGroup):void 
		{
			_group = value;
		}
		
		public function get pan():Number 
		{
			return _pan;
		}
		
		public function set pan(value:Number):void 
		{
			_pan = value;
			updateVolume();
		}
		
		public function get isFadingOut ():Boolean
		{
			return (_fadeOutTimer != null);
		}
		
		public function get isManualDestroy():Boolean 
		{
			return _isManualDestroy;
		}
		
		public function get isManualPlay():Boolean 
		{
			return _isManualPlay;
		}

	}

}