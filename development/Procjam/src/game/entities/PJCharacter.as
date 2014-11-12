package game.entities 
{
	import axengine.util.ray.AxRayResult;
	import game.PJEntity;
	import game.world.PJWorld;
	import keith.LightmapCollisionArray;
	import keith.Shadowcaster;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class PJCharacter extends PJEntity
	{
		
		protected var _visionLength:int = 3;
		protected var _visionTarget:AxPoint;
		protected var _visionSource:AxPoint;
		
		protected var prevVisionX:int = -1;
		protected var prevVisionY:int = -1;
		protected var prevVisionDirection:int = -1;
		
		protected var _playerDetectionLevel:int;
		protected var _isAlertMode:Boolean;
		
		public var riskLevel:int = 0;
		public var lightmap:LightmapCollisionArray
		
		public function PJCharacter() 
		{
			_visionTarget = new AxPoint();
			_visionSource = new AxPoint();
		}
		
		override public function loadNativeGraphics(Animated:Boolean = true, Reverse:Boolean = false, Width:uint = 0, Height:uint = 0, Unique:Boolean = false):void 
		{
			super.loadNativeGraphics(Animated, Reverse, Width, Height, Unique);
			generateAnims();
		}
		
		override public function update():void 
		{
			
			super.update();
			if (alive) {
				if (_bIsMoving) {
					animate("walk" + _animSuffix);
				} else {
					animate("idle" + _animSuffix);
					if (_playerDetectionLevel > 0) {
						setDetectionLevel(_playerDetectionLevel - 5);
					}
				}
			} else {
				animate("dead" + _animSuffix);
			}
			
		}
		
		override public function kill():void 
		{
			//super.kill();
			animate("dead" + _animSuffix);
			alive = false;
		}
		
		protected function castVision():void 
		{
			
			if (lightmap != null) {
				if(prevVisionX != tileX || prevVisionY != tileY || prevVisionDirection != _moveDir){
					Shadowcaster.castShadows(lightmap, tileX, tileY, 5, 
						_moveDir == RIGHT ? Shadowcaster.CONE_EAST:
						_moveDir == LEFT ? Shadowcaster.CONE_WEST:
						_moveDir == UP ? Shadowcaster.CONE_NORTH:
						_moveDir == DOWN ? Shadowcaster.CONE_SOUTH:
						Shadowcaster.FULL_CIRLCE);
					prevVisionX = tileX;
					prevVisionY = tileY;
					prevVisionDirection = _moveDir;
				}
				//return;
			}
			
			var isPlayerVisible:Boolean = false;
			_visionTarget.x = centerX;
			_visionTarget.y = centerY;
			_visionSource.x = centerX;
			_visionSource.y = centerY;
			switch (_moveDir) {
				case DOWN:
					_visionTarget.y += 140;
				break;
				case UP:
					_visionTarget.y -= 140;
				break;
				case LEFT:
					_visionTarget.x -= 140;
				break;
				case RIGHT:
					_visionTarget.x += 140;
				break;
			}
			if (_moveDir != NONE) {
				var rayResult:AxRayResult = _world.castRay(_visionSource, new AxPoint(_visionTarget.x, _visionTarget.y), 0);
				for each(var point:AxPoint in rayResult.path) {
					if (_world && (_world.player as PJEntity).isOnTile(point.x, point.y)) {
						_playerDetectionLevel++;
						isPlayerVisible = true;
					} 
					var visionView:AxGroup = PJWorld(_world).visionDebug;
					var temp:AxSprite = visionView.recycle() as AxSprite;
					if (!temp) {
						temp = new AxSprite (0,0);
						temp.load(Core.lib.int.img_vision_tiles, 32, 32);
						temp.addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 0, true);
						
					} else {
					}
					temp.animate("idle");
					temp.x = point.x * 32
					temp.y = point.y * 32
					setDetectionLevel(_playerDetectionLevel);
					//temp.frame =  3 + int((temp.totalFrames /100) * _playerDetectionLevel) 
					visionView.add(temp);
					temp.frame = 4;
				}
			} 
		}
		
		protected function setDetectionLevel($value:int):void {
			_playerDetectionLevel = $value;
			if (_playerDetectionLevel > 0) {
				if (!_isAlertMode) {
					_isAlertMode = true;
					onJustSeenPlayer(_world.player as PJPlayer);
				}
				onSeePlayer(_world.player as PJPlayer);
			} 
			if (_playerDetectionLevel <= 0) {
				if (_isAlertMode) {
					onSeePlayerOver();
					_isAlertMode = false;
				}
				
				
				_playerDetectionLevel = 0;
			}
		}
		
		private function onSeePlayerOver():void 
		{
			
		}
		
		private function onSeePlayer(pJPlayer:PJPlayer):void 
		{
			
		}
		
		protected function onJustSeenPlayer(pJPlayer:PJPlayer):void 
		{
			
		}
		
		protected function generateAnims ():void {
			addAnimation("walk_down", [1, 0, 1, 2], 5, true);
			addAnimation("walk_up", [4, 3, 4, 5], 5, true);
			addAnimation("walk_right", [7, 6, 7, 8], 5, true);
			addAnimation("walk_left", [10, 9, 10, 11], 5, true);
			addAnimation("idle_down", [1], 5, true);
			addAnimation("idle_up", [4], 5, true);
			addAnimation("idle_right", [7], 5, true);
			addAnimation("idle_left", [10], 5, true);
			addAnimation("dead_down", [12], 5, true);
			addAnimation("dead_up", [15], 5, true);
			addAnimation("dead_right", [18], 5, true);
			addAnimation("dead_left", [21], 5, true);
		}
		
	}

}