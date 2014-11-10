package game 
{
	import axengine.events.AxLevelEvent;
	import base.events.GameEvent;
	import game.entities.characters.PJThief;
	import game.entities.PJPlayer;
	import game.world.PJWorld;
	import org.axgl.Ax;
	import org.axgl.AxState;
	import org.axgl.text.AxText;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class PJGameState extends AxState 
	{
		
		public function PJGameState() 
		{
			super();
			Core.control.addEventListener(AxLevelEvent.END, onLevelComplete);
			add(new PJWorld);
		}
		
		private function onLevelComplete(e:AxLevelEvent):void 
		{
			Ax.switchState(new PJLevelEndState());
		}
		
	}

}