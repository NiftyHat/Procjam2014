package game 
{
	import axengine.entities.AxDynamicEntity;
	import axengine.entities.AxGameEntity;
	import axengine.world.AxWorld;
	import be.dauntless.astar.basic2d.BasicTile;
	import be.dauntless.astar.core.AstarPath;
	import be.dauntless.astar.core.IAstarTile;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import game.entities.characters.actions.PJAction;
	import game.world.PJWorld;
	import org.axgl.AxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class PJEntity extends AxDynamicEntity
	{
		protected var _isDebugPathfinding:Boolean;
		protected var _tweenMove:TweenLite;
		
		protected var _moveDir:int = NONE;
		protected var _faceDir:int = DOWN;
		
		protected var _tileX:int = 0;
		protected var _tileY:int = 0;
		
		protected var _nextTile:AxPoint;
		
		protected static const TILE_WIDTH:int = 32;
		protected static const TILE_HEIGHT:int = 32;
		
		protected var _animSuffix:String = "";
		protected var _isMoving:Boolean = false;
		
		protected var _mMoveSpeed:Number = 0.2;
		
		protected var _path:Vector.<IAstarTile> = null;
		
		protected var _action:PJAction;
		
		public function PJEntity(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) 
		{
			super(X, Y, SimpleGraphic);
			_nextTile = new AxPoint ();
		}
		
		public function setAction($action:PJAction, $autoStart:Boolean = true):void {
			if (_action) {
				clearAction();
			}
			_action = $action;
			_action.setEntity(this);
			if ($autoStart) {
				_action.start(this);
			}
		}
		
		protected function isAction($class:Class = null):Boolean {
			if (!$class) {
				if (_action) {
					return true;
				}
			} else {
				if (_action && _action is $class) {
					return true;
				}
			}
			
			return false;
		}
		
		public function clearAction():void 
		{
			if (_action) {
				_action.destroy();
			}
			
			_action = null;
		}
		
		public function onStartAction ($action:PJAction):void {
		}
		
		public function onEndAction($action:PJAction):void {
			//clearAction();
		}
			
		public function face($dir:int):void {
			_faceDir = $dir;
			switch (_faceDir) {
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
		
		override public function update():void 
		{
			super.update();
			if (!alive) {
				 return;
			}
			if (_action) {
				_action.update();
			}
			if (_faceDir != NONE) {
				switch (_faceDir) {
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
			updateTilePos();
			if (_path && _path.length > 0 && !_isMoving) {
				var tile:BasicTile = _path[0] as BasicTile;
				if (tile.getPosition().x == _tileX && tile.getPosition().y == _tileY) {
					_path.shift();
				}
				if (_path.length > 0) {
					tile = _path[0] as BasicTile;
					if (tile.getPosition().x > _tileX) {
						move(RIGHT);
						
					}
					if (tile.getPosition().x < _tileX) {
						move(LEFT);
					}
					if (tile.getPosition().y > _tileY) {
						move(DOWN);
					}
					if (tile.getPosition().y < _tileY) {
						move(UP);
					}
				}
				
			}
		}
		
		protected function animateDirectional($name:String,$reset:Boolean = false):void 
		{
			animate($name + _animSuffix, $reset);
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
			_faceDir = $dir
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
				if (!_isMoving && isTileWalkable(_nextTile)) {
					_tweenMove = TweenLite.to(this, _mMoveSpeed, { x:(_nextTile.x * TILE_WIDTH), y:(_nextTile.y * TILE_HEIGHT) , onComplete: onMoveComplete ,onReverseComplete: onReverseMoveComplete, ease:Linear.easeNone } );
					_isMoving = true;
					_faceDir = $dir;
				}
			}
		}
		
		private function onReverseMoveComplete():void 
		{
			onMoveComplete();
		}
		
		public function isOnTile($tileX:int, $tileY:int):Boolean {
			return (_tileX == $tileX && _tileY == $tileY) 
		}
		
		public function isOnEntity($target:PJEntity):Boolean {
			return isOnTile($target.tileX, $target.tileY);
		}
		
		protected function pathToEntity($target:PJEntity):void {
			var targetTileX:int = $target.tileX
			var targetTileY:int = $target.tileY;
			//trace("Path to entity ",$target ,targetTileX, targetTileY);
			if (!_world.collision_map.tileHasCollision(targetTileX, targetTileY)) {
				(_world as PJWorld).getAStarPath(new Point(_tileX, _tileY), new Point(targetTileX, targetTileY), onPath, null, _isDebugPathfinding);
			}
		}
		
		protected function pathToTile($tileX:int, $tileY:int):void {
			if (isAction()) {
				return;
			}
			if (!_world.collision_map.tileHasCollision($tileX, $tileY)) {
				(_world as PJWorld).getAStarPath(new Point(_tileX, _tileY), new Point($tileX, $tileY), onPath, null,_isDebugPathfinding);
			}
		}
		
		protected function onPath($path:AstarPath):void 
		{
			_path = $path.path;
		}
		
		protected function isTileWalkable(nextTile:AxPoint):Boolean 
		{
			return !_world.collision_map.tileHasCollision(nextTile.x, nextTile.y);
		}
		
		protected function onMoveComplete():void 
		{
			_isMoving = false;
		}
		
		public function get tileX():int 
		{
			return _tileX;
		}
		
		public function get tileY():int 
		{
			return _tileY;
		}
		
		public function get faceDir():int 
		{
			return _faceDir;
		}
		
		public function get world():PJWorld {
			return _world as PJWorld;
		}
		
	}

}