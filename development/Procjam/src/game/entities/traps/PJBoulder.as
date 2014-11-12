package game.entities.traps 
{
	import game.PJEntity;
	
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class PJBoulder extends PJEntity 
	{
		
		protected var HPRemaining:int
		
		public function PJBoulder(X:Number=0, Y:Number=0) 
		{
			super(X, Y);
			HPRemaining = 100;
		}
		
		override protected function move($dir:int):void 
		{
			if (HPRemaining == 0) {
				kill();
				return;
			}
			var nextTileX:int = tileX + (_moveDir == LEFT ? -1 : _moveDir == RIGHT ? 1 : 0)
			var nextTileY:int = tileY + (_moveDir == UP ? -1 : _moveDir == DOWN ? 1 : 0)
			
			if (_world.collision_map.getTileAt(nextTileX, nextTileY).collision) {
				if ($dir == UP) $dir = RIGHT;
				else if ($dir == DOWN) $dir = DOWN;
				else if ($dir == RIGHT) $dir = LEFT;
				else if ($dir == LEFT) $dir = UP;
				else { kill(); return };
				
				move($dir)
				return;
			}
			
			HPRemaining --;
			
			super.move($dir);
			
			
		}
		
	}

}