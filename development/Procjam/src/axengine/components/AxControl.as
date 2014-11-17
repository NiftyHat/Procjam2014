package axengine.components 
{
	import axengine.events.AxLevelEvent;
	import axengine.events.AxLibraryEvent;
	import axengine.state.AxPlayState;
	import axengine.world.level.AxLevel;
	import axengine.world.level.AxLevelList;
	import base.events.GameEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import game.PJGameState;
	import game.PJTitleState;
	import org.axgl.Ax;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxControl extends EventDispatcher 
	{
		private var m_paused:Boolean;
		private var m_level:AxLevel;
		private var _levelList:AxLevelList;
		
		public var isWon:Boolean;
		public var isTutorial:Boolean; 
		
		public var score:Object = {}
		public var lives:int = 0;
		public var time_taken:Number = 0;
		
		//public var startingState:Class = AxPlayState;
		
		public function AxControl(target:IEventDispatcher = null) 
		{
			super(target);
		}
		
		public function init():void 
		{
			initLevelData();
		}
		
		public function togglePause ():void
		{
			m_paused = !m_paused;
			if (m_paused) pause();
			else unpause ();
		}
		
		public function pause ():void
		{
			m_paused = true;
			Core.control.dispatchEvent(new GameEvent(GameEvent.RESUME));
		}
		
		public function unpause ():void
		{
			m_paused = false;
			Core.control.dispatchEvent(new GameEvent(GameEvent.PAUSE));
			
		}
		
		public function initLevelData ():void
		{
			_levelList = new AxLevelList ();
			for each (var item:XML in Core.xml.levels.*)
			{
				var new_level:AxLevel = new AxLevel();
				new_level.init(item.ID.@key);
				_levelList.add(new_level);
			}
		}
		
		public function getLevelData ($key:String):AxLevel
		{
			return _levelList.get($key);
		}

		public function levelStart($file_name:String):void
		{
			trace("start level ") + $file_name;
			if (FlxG.music)
			{
				FlxG.music.fadeOut(0.3);
				FlxG.music = null;				
			}
		}
		
		public function startNewGame ():void
		{
			Ax.state.destroy();
			Ax.pushState(new PJTitleState());
			
		}
	
		public function trackStat ():void
		{
			
		}
		
		public function levelEnd($isWon:Boolean):void 
		{
			
			isWon = $isWon;
			//TODO
			dispatchEvent(new AxLevelEvent(AxLevelEvent.END, m_level));
			//dispatchEvent(new GameEvent(GameEvent));
		}
		
		public function quitLevel():void 
		{
			dispatchEvent(new AxLevelEvent(AxLevelEvent.QUIT, m_level));
			//FlxG.switchState(new MenuState());
		}
		
		public function loadLevel($key:String = ""):void 
		{
			m_level = _levelList.get($key);
			m_level.loadData();
			//TODO - write this XD XD;
			//if (m_level && !m_level.isLoaded) return;
			//isWon = false;
			//trace("load level " + $key);
			//Core.level_file = $key;
			//var level_header:XML = Core.xml.getLevelXML($key);
			//m_level = new Level ();
			//m_level.loadRemote($key);
		}
		
		public function gameEnd():void 
		{
			dispatchEvent(new GameEvent(GameEvent.END));
		}

		public function get paused():Boolean { return m_paused; }
		
		public function get level():AxLevel { return m_level; }

		
	}

}