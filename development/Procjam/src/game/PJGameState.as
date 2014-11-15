package game 
{
	import axengine.events.AxLevelEvent;
	import base.events.GameEvent;
	import game.entities.characters.PJThief;
	import game.entities.characters.PJWizard;
	import game.entities.PJPlayer;
	import game.world.PJWorld;
	import org.axgl.Ax;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;
	import org.axgl.text.AxText;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class PJGameState extends AxState 
	{
		private var _world:PJWorld;
		
		public function PJGameState() 
		{
			super();
			Core.control.addEventListener(AxLevelEvent.END, onLevelComplete);
			
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
			Core.control.removeEventListener(AxLevelEvent.END, onLevelComplete);
			Ax.switchState(new PJLevelEndState());
		}
		
	}

}