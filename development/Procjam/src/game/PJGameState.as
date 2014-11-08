package game 
{
	import game.entities.PJPlayer;
	import game.world.PJWorld;
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
			add(new PJWorld);
		}
		
	}

}