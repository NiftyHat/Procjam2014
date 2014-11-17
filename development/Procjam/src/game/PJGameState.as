package game 
{
	import axengine.events.AxLevelEvent;
	import game.ui.events.KillEvent;
	import game.ui.PJUserInterface;
	import game.world.PJWorld;
	import org.axgl.Ax;
	import org.axgl.AxState;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class PJGameState extends AxState 
	{
		private var _world:PJWorld;
		private var _ui:PJUserInterface;
		
		public function PJGameState() 
		{
			super();
			Core.control.addEventListener(AxLevelEvent.END, onLevelComplete);
			Core.control.addEventListener(KillEvent.REGISTER_KILL, onPlayerScoreKill);
		}
		
		private function onPlayerScoreKill(e:KillEvent):void 
		{
			switch (e.killType) {
				case KillEvent.KILLTYPE_THIEF:
					Core.control.score[KillEvent.KILLTYPE_THIEF] += 1;
					break;
					case KillEvent.KILLTYPE_WIZARD:
					Core.control.score[KillEvent.KILLTYPE_WIZARD] += 1;
					break;
					case KillEvent.KILLTYPE_BESERKER:
					Core.control.score[KillEvent.KILLTYPE_BESERKER] += 1;
					break;
			}
		}
		
		override public function create():void 
		{
			super.create();
			if (!_world) {
				Core.control.score["THIEF"] = 0;
				Core.control.score["WIZARD"] = 0;
				Core.control.score["BESERKER"] = 0;
				_world = new PJWorld()
				add(_world);
				
				_ui = new PJUserInterface();
				add(_ui);
				
				
			}
		}
		
		override public function destroy():void 
		{
			
			super.destroy();
		}
		
		private function onLevelComplete(e:AxLevelEvent):void 
		{
			_world.destroy();
			_world = null;
			_ui.destroy();
			_ui = null;
			
			Core.control.removeEventListener(AxLevelEvent.END, onLevelComplete);
			Ax.switchState(new PJLevelEndState());
		}
		
	}

}