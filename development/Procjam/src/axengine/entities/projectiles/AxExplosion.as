package axengine.entities.projectiles
{
	import axengine.entities.AxDynamicEntity;
	import axengine.entities.AxGameEntity;
	import axengine.world.AxWorld;
	import flash.geom.Rectangle;
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxRect;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxExplosion extends AxDynamicEntity
	{
		
		protected var _radius:int;
		protected var _damage:int = 10;
		protected var _lifespan:Number = 0.2;
		protected var _frameRate:Number = 0;
		protected var _delay:Number = 0;
		protected var _targets:Array = [AxGameEntity]
		
		public function AxExplosion()
		{
			_radius = 64;
			solid = false;
			_isCollision = false;
		}
		
		public function setDelay ($delay:Number):void {
			_delay = $delay;
		}
		
		override public function init($world:AxWorld):void
		{
			super.init($world);
			_frameRate = totalFrames / _lifespan;
			//pivot.x = width * 0.5;
			//pivot.x = height * 0.5;
			
			offset.x = width * 0.5;
			offset.y = height * 0.5;
			//x += offset.x;
			//y += offset.y;
			if (_delay == 0) explode();
			else {
				visible = false;
			}
		}
		
		override public function update():void
		{
			if (_delay > 0) {
				_delay -= Ax.dt;
				if (_delay < 0)
				{
					_delay = 0;
					visible = true;
					explode();
				}
			}
			if (_delay <= 0) {
				if (_lifespan > 0) {
				show( totalFrames - int(_frameRate * _lifespan));
				_lifespan -= Ax.dt;
				
				}
				if (_lifespan <= 0) {
					destroy();
				}
			}
			
			super.update();
		}
		
		public function explode():void {
			if (!_world) return;
			var explosionRect:AxRect = new AxRect (x - _radius, y-_radius , _radius * 2, _radius * 2);
			var targets:Vector.<AxEntity> = _world.getEntitiesInRect(explosionRect, _targets);
			if (!targets) return;
			for each (var item:AxGameEntity in targets) {
				var tx:int = item.x - x;
				var ty:int = item.y - y;
				if ((tx * tx) + (ty * ty) < _radius * _radius) {
					if (item) doDamage(item);
				}
			}
		}
		
		private function doDamage(item:AxGameEntity):void
		{
			item.hurt(_damage);
		}
		
	}

}