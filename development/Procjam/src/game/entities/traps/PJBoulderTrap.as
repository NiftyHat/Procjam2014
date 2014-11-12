package game.entities.traps 
{
	import game.entities.PJTrap;
	
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class PJBoulderTrap extends PJTrap 
	{
		
		public function PJBoulderTrap() 
		{
			super();
			
		}
		
		override protected function startTrap():void 
		{
			super.startTrap();
			
			var boulder:PJBoulder = new PJBoulder(this.x, this.y);
			boulder._faceDir = this._faceDir;
			boulder._moveDir = this._faceDir;
			
		}
		
	}

}