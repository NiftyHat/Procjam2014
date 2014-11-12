package game 
{
	import axengine.state.AxInitState;
	import game.entities.characters.PJWizard;
	import game.entities.characters.PJThief;
	import game.entities.PJCoinPile;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class PJInitState extends AxInitState
	{
		
		public function PJInitState() 
		{
			
		}
		
		override protected function registerClasses():void 
		{
			super.registerClasses();
			Core.registry.registerClass(PJCoinPile, "COIN_PILE");
			Core.registry.registerClass(PJThief, "CHAR_THIEF");
			Core.registry.registerClass(PJWizard, "CHAR_WIZARD");
		}
		
	}

}