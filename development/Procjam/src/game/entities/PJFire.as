package game.entities 
{
	import axengine.world.AxWorld;
	import game.PJEntity;
	import game.world.PJWorld;
	import org.axgl.AxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJFire extends PJEntity 
	{
		
		var spreadChance:int = 0;
		
		protected var _neighbors:Vector.<AxPoint>;
		
		public function PJFire(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			load(Core.lib.int.img_fire, 32,32);
			addAnimation("spawn", [0, 1, 2], 15, false, onSpawnComplete);
			addAnimation("idle", [2,3, 4, 5, 6], 10, true)
		}
		
		override public function update():void 
		{
			super.update();
			if (isOnEntity(_world.player as PJPlayer)) {
				_world.player.destroy();
			}
			spreadChance++
			if (spreadChance > 100) {
				//var fire:PJFire = new PJFire ();
				
			}
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			animate("spawn");
			
		}
		
		private function updateNeighbors():void {
			_neighbors = new Vector.<AxPoint> ();
			_neighbors.push(new AxPoint(tileX + 1, 0));
			_neighbors.push(new AxPoint(tileX -1, 0));
			_neighbors.push(new AxPoint(0, tileY + 1));
			_neighbors.push(new AxPoint(0, tileY -1));
			for (var i = 0; i < _neighbors.length; i++) {
				var tile:AxPoint = _neighbors[i];
				_world.collision_map.getTileAt(tile.x, tile.y);
				_neighbors.splice(i, 1);
			}
		}
		
		private function onSpawnComplete():void 
		{
			animate("idle");
			addTimer(3.0, onFireBurnout)
		}
		
		private function onFireBurnout():void 
		{
			destroy();
		}
		
	}

}