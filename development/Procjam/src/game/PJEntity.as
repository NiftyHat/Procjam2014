package game 
{
	import axengine.entities.AxDynamicEntity;
	import axengine.entities.AxGameEntity;
	import axengine.world.AxWorld;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import org.axgl.AxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class PJEntity extends AxDynamicEntity
	{
		
		protected var _moveDir:int = NONE;
		
		protected var _tileX:int = 0;
		protected var _tileY:int = 0;
		
		protected var _nextTile:AxPoint;
		
		protected static const TILE_WIDTH:int = 32;
		protected static const TILE_HEIGHT:int = 32;
		
		
		protected var _animSuffix:String = "";
		protected var _bIsMoving:Boolean = false;
		
		protected var _mMoveSpeed:Number = 0.2;
		
		public function PJEntity() 
		{
			_nextTile = new AxPoint ();
		}
		
		override public function update():void 
		{
			super.update();
			updateTilePos();
		}
		
		private function updateTilePos():void 
		{
			_tileX = int(x / TILE_WIDTH);
			_tileY = int(y / TILE_HEIGHT);
			_nextTile.x = _tileX;
			_nextTile.y = _tileY;
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			updateTilePos();
		}
		
		protected function move($dir:int):void {
			_moveDir = $dir;
			_nextTile.x = _tileX;
			_nextTile.y = _tileY;
			switch ($dir) {
				case DOWN:
					_nextTile.y += 1;
				break;
				case UP:
					_nextTile.y -= 1;
				break;
				case LEFT:
					_nextTile.x -= 1;
				break;
				case RIGHT:
					_nextTile.x += 1;
				break;
			}
			if ($dir != NONE) {
				if (!_bIsMoving && isTileWalkable(_nextTile)) {
					TweenLite.to(this, _mMoveSpeed, { x:(_nextTile.x * TILE_WIDTH), y:(_nextTile.y * TILE_HEIGHT) , onComplete: onMoveComplete, ease:Linear.easeNone } );
					_bIsMoving = true;
					switch ($dir) {
					case DOWN:
						_animSuffix = "_down";
					break;
					case UP:
						_animSuffix = "_up";
					break;
					case LEFT:
						_animSuffix = "_left";
					break;
					case RIGHT:
						_animSuffix = "_right";
					break;
					}
				}
			}
		}
		
		private function isTileWalkable(nextTile:AxPoint):Boolean 
		{
			return !_world.collision_map.tileHasCollision(nextTile.x, nextTile.y);
		}
		
		private function onMoveComplete():void 
		{
			_bIsMoving = false;
		}
		
	}

}