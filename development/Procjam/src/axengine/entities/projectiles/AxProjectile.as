package axengine.entities.projectiles 
{
	import axengine.entities.AxDynamicEntity;
	import axengine.util.AxDamage;
	import org.axgl.Ax;
	import org.axgl.AxU;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxProjectile extends AxDynamicEntity
	{
		
		protected var _speed:int = 800;
		protected var _damage:int = 5;
		protected var _lifespan:Number = -1;
		public var source:AxDynamicEntity;
		
		public function AxProjectile() 
		{
			create(8, 8, 0xFFFF0000)
			offset.x = 4;
			offset.y = 4;
			solid = true;
			phased = false;
			_isCollision = false;
			drag.x = 0;
			drag.y = 0;
		}
		
		public function velocityFromSinCos($x:Number, $y:Number):void {
			velocity.x = $x * _speed;
			velocity.y = $y * _speed;
		}
		
		public function velocityFromAngle($angle:Number):void {
			velocity.x = Math.cos($angle) * _speed;
			velocity.y = Math.sin($angle) * _speed;
			if (_isRotating) {
				angle = $angle;
			}
		}
		
		override public function update():void 
		{
			super.update();
			if (wasTouching(ANY)) {
				onDestroyed();
			}
			if (alive && _lifespan > 0) {
				_lifespan -= Ax.dt;
				if (_lifespan < 0) {
					
					_lifespan = 0;
					onDestroyed();
				}
			}
		}
		
		public function onHitEntity($entity:AxDynamicEntity):void 
		{
			if (!alive) return;
			alive = false;
			var isCollided:Boolean = $entity.onProjectileHit(this);
			if (isCollided) onDestroyed();
			//delayedKill(0.2);
		}
		
		public function multiplyDamage($multiplier:int = 1):void {
			_damage = _damage * $multiplier;
		}
		
		protected function onDestroyed():void 
		{
			destroy();
		}
		
		public function onHitCollision():void 
		{
			if (!alive) return;
			alive = false;
			onDestroyed();
		}
		

		public function get speed():int 
		{
			return _speed;
		}
		
		public function set speed(value:int):void 
		{
			_speed = value;
		}
		
		public function get lifespan():Number 
		{
			return _lifespan;
		}
		
		public function set lifespan(value:Number):void 
		{
			_lifespan = value;
		}

	}

}