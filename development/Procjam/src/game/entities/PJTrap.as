package game.entities 
{
	import game.PJEntity;
	import org.axgl.AxPoint;
	
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class PJTrap extends PJEntity 
	{
		protected var isReadyToTrigger:Boolean = false;
		
		public function PJTrap() 
		{
			this.isReadyToTrigger = true;
		}
		
		public function reset():void {
			isReadyToTrigger = true;
		}
		
		override public function update():void 
		{
			
			
		}
		
		public function activate():void {
			if (isReadyToTrigger) {
				this.isReadyToTrigger = false;
				startTrap();
			}
		}
		
		protected function startTrap():void 
		{
			
		}
		
		
	}

}