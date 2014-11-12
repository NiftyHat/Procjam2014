package game.entities 
{
	import axengine.entities.projectiles.AxProjectile;
	import game.PJEntity;
	import org.axgl.AxU;
	/**
	 * ...
	 * @author ...
	 */
	public class PJFireball extends PJProjectile
	{
		
		protected var _launchSpeed:int = 80;
		
		public function PJFireball() 
		{
			super();
			create(6, 6, 0xffff0000);
			drag.x = drag.y = 3;
			acceleration.x = acceleration.y = 0;
			load(Core.lib.int.img_fireball, 8, 8)
			addAnimation("idle", [0, 1, 2, 3], 30, true);
			//solid = true;
			animate("idle");
		}
		
		override public function update():void 
		{
			super.update();
			if (isOnEntity(_world.player as PJPlayer)) {
				_world.player.kill();
				_world.player.destroy();
				onDestroyed();
			}
			if (alive) {
				if (wasTouching(ANY)) {
				onDestroyed();
				}
			}
		}
		
		protected function onDestroyed():void 
		{
			destroy();
			alive = false;
			var tx:int = centerX / 32;
			var ty:int = centerY / 32;
			if (!_world.collision_map.getTileAt(tx, ty)) {
				var fire:PJFire = new PJFire(tx * 32, ty * 32);
				_world.addEntity(fire);
			}
			
			
		}
		
		public function shootAtEntity($entity:PJEntity, $velocity:int) {
			var angle:Number = Math.atan2($entity.centerY - centerY, $entity.centerX - centerX);
			 velocity.x = Math.cos(angle) * _launchSpeed;
			 velocity.y = Math.sin(angle) * _launchSpeed;
		}
		
	}

}