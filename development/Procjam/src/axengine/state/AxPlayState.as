package axengine.state
{
	import axengine.events.AxLevelEvent;
	import axengine.world.AxWorld;
	import base.events.GameEvent;
	import org.axgl.Ax;
	import org.axgl.AxState;
	import org.axgl.text.AxText;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxPlayState extends AxState
	{
		
		private var _world:AxWorld;
		private var _isLevelStarted:Boolean;
		
		public function AxPlayState()
		{
			super();
			addListeners();
			
		}
		
		private function addListeners():void
		{
			
			Core.control.addEventListener(GameEvent.PAUSE, onGamePause);
			Core.control.addEventListener(GameEvent.RESUME, onGameResume);
			Core.control.addEventListener(GameEvent.END, onGameEnd);
			Core.control.addEventListener(AxLevelEvent.END, onLevelEnd);
			Core.control.addEventListener(AxLevelEvent.RESTART, onLevelRestart);
			Core.control.addEventListener(AxLevelEvent.QUIT, onLevelQuit);
		}
		
		
		
		private function onGameEnd(e:GameEvent):void
		{
			
		}
		
		private function onGameResume(e:GameEvent):void
		{
			_world.unpause();
		}
		
		private function onGamePause(e:GameEvent):void
		{
			_world.pause();
		}
		
		private function onLevelQuit(e:AxLevelEvent):void
		{
			
		}
		
		private function onLevelRestart(e:AxLevelEvent):void
		{
			
		}
		
		private function onLevelEnd(e:AxLevelEvent):void
		{
			
		}
		
		override public function create():void
		{
			trace("create play state");
			_isLevelStarted = false;
			if (!_world) _world = new AxWorld();
			add(_world);
			super.create();
		}
		
		override public function destroy():void {
			_world.destroy();
			super.destroy();
		}
		
	}

}