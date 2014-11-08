package base 
{
	import base.events.GameEvent;
	import com.greensock.TweenMax;
	import com.p3.audio.soundcontroller.P3SoundController;
	import com.p3.display.screenmanager.P3IScreen;
	import com.p3.display.screenmanager.transitions.P3ITransition;
	import com.p3.display.screenmanager.transitions.P3TransitionCrossFadeColour;
	import com.p3.game.chatmapperapi.ChatEvent;
	import com.p3.loading.preloader.P3Preloader;
	import com.p3.utils.P3Globals;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	[Event(name="mute", type="base.events.GameEvent")]
	[Event(name="unmute", type="base.events.GameEvent")]
	[Event(name="pause", type="base.events.GameEvent")]
	[Event(name="resume", type="base.events.GameEvent")]
	public class Control extends EventDispatcher 
	{
		
		protected var _isPaused:Boolean;
	
		public function Control(target:IEventDispatcher=null) 
		{
			super(target);
		}

		public function init():void
		{
			Core.cache.load();
		}
		
		public function startGame ():void
		{
		}
		
		/**
		 * 
		 * @param	level - level data or level object or level key.
		 */
		public function levelStart (level:* ):void {
			
		}
		
		public function levelEnd ($isGameOver:Boolean):void {
			
		}
		
		public function screenPopup ($newPopup:P3IScreen):void
		{
			Core.screens.addScreen($newPopup, { replace:false} );
		}
		
		public function screenSet ($newScreen:P3IScreen, $useFade:Boolean = true):void
		{
			var trans:P3ITransition;
			if ($useFade) 
			{
				trans = new P3TransitionCrossFadeColour (1, 0x000000, 0.3);
				Core.screens.addScreen($newScreen, { replace:true, transition:trans } );
			}
			else
			{
				Core.screens.addScreen($newScreen, { replace:true} );
			}
		}
		
		public function togglePause():void 
		{
			_isPaused = !_isPaused;
			if (_isPaused) pause();
			if (!_isPaused) resume();
		}
		
		public function pause():void 
		{
			if (_isPaused) return;
			_isPaused = true;
			Core.sound.pauseAllSounds();
			dispatchEvent(new GameEvent(GameEvent.PAUSE));
		}
		
		public function resume():void 
		{
			if (!_isPaused) return;
			_isPaused = false;
			Core.screens.display.stage.focus = Core.screens.display.stage;
			Core.sound.resumeAllSounds();
			dispatchEvent(new GameEvent(GameEvent.RESUME));
		}
		
		public function toggleMute ():void
		{
			if (Core.sound.isMute) unmute();
			else mute();
		}
		
		public function mute():void
		{
			Core.control.dispatchEvent(new GameEvent(GameEvent.MUTE));
			Core.sound.muteAllSounds();
			Core.sound.saveCache();
		}
		
		public function unmute ():void
		{
			Core.control.dispatchEvent(new GameEvent(GameEvent.UNMUTE));
			Core.sound.unmuteAllSounds();
			Core.sound.saveCache();
		}

		public function get isMute():Boolean 
		{
			return Core.sound.isMute;
		}
		
		public function get isPaused():Boolean 
		{
			return _isPaused;
		}
		
	}

}