package game.entities 
{
	import axengine.entities.AxDynamicEntity;
	import axengine.util.ray.AxRayResult;
	import game.deco.PJGravestone;
	import game.PJEntity;
	import game.world.PJWorld;
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
		
		protected var _playerDetectionLevel:int;
		protected var _isAlertMode:Boolean;
		
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
			if (_bIsMoving) {
				animate("walk" + _animSuffix);
			} else {
				animate("idle" + _animSuffix);
				if (_playerDetectionLevel > 0) {
					setDetectionLevel(_playerDetectionLevel - 5);
				}
			}
			if (isOnEntity(PJEntity(_world.player))) {
				kill();
			}
		}
		
		override public function kill():void 
		{
			super.kill();
			var grave:PJGravestone = new PJGravestone (x, y);
			_world.addEntity(grave);
			destroy();
		}
		
		protected function castVision():void 
		{
			var isPlayerVisible:Boolean = false;
			_visionTarget.x = centerX;
			_visionTarget.y = centerY;
			_visionSource.x = centerX;
			_visionSource.y = centerY;
			switch (_moveDir) {
				case DOWN:
					_visionTarget.y += 140;
					_visionSource.y += 32;
				break;
				case UP:
					_visionTarget.y -= 140;
					_visionSource.y -= 32;
				break;
				case LEFT:
					_visionTarget.x -= 140;
					_visionSource.x -= 32;
				break;
				case RIGHT:
					_visionTarget.x += 140;
					_visionSource.x += 32;
				break;
			}
			if (_moveDir != NONE) {
				var rayResult:AxRayResult = _world.castRay(_visionSource, new AxPoint(_visionTarget.x, _visionTarget.y), 0);
				for each(var point:AxPoint in rayResult.path) {
					if (_world && (_world.player as PJEntity).isOnTile(point.x, point.y)) {
						_playerDetectionLevel++;
						isPlayerVisible = true;
					} 
					var temp:AxSprite = new AxSprite (point.x * 32, point.y * 32);
					
					temp.load(Core.lib.int.img_vision_tiles, 32, 32);
					temp.animate("idle");
					setDetectionLevel(_playerDetectionLevel);
					//temp.frame =  3 + int((temp.totalFrames /100) * _playerDetectionLevel) 
					PJWorld(_world).visionDebug.add(temp);
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
			addAnimation("walk_left", [4, 3, 4, 5], 5, true);
			addAnimation("walk_right", [7, 6, 7, 8], 5, true);
			addAnimation("walk_up", [10, 9, 10, 11], 5, true);
			addAnimation("idle_down", [1], 5, true);
			addAnimation("idle_left", [4], 5, true);
			addAnimation("idle_right", [7], 5, true);
			addAnimation("idle_up", [10], 5, true);
			
		}
		
	}

}