package game.entities 
{
	import axengine.util.ray.AxRayResult;
	import axengine.world.AxWorld;
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Itr;
	import game.PJEntity;
	import game.util.EnumShadowType;
	import game.VisionMap;
	import game.world.PJWorld;
	import keith.LightmapCollisionArray;
	import keith.Shadowcaster;
	import keith.ShadowPoint;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxSprite;
	import org.axgl.text.AxFont;
	import org.axgl.text.AxText;
	/**
	 * ...
	 * @author ...
	 */
	public class PJCharacter extends PJEntity
	{
		private var _visionCone:HashMap;
		private var _prevVisionRadius:int;
		
		protected var _visionLength:int = 3;
		protected var _visionTarget:AxPoint;
		protected var _visionSource:AxPoint;
		
		protected var _prevVisionX:int = -1;
		protected var _prevVisionY:int = -1;
		protected var _prevVisionDirection:int = -1;
		
		protected var _playerDetectionLevel:int;
		protected var _isAlertMode:Boolean;
		protected var _isPounced:Boolean;
		protected var _isPlayerVisible:Boolean;
		
		public var riskLevel:int = 0;
		public var lightmap:LightmapCollisionArray;
		
		protected var _txtDetection:AxText;
		
		public function PJCharacter() 
		{
			_visionTarget = new AxPoint();
			_visionSource = new AxPoint();
		}
		
		override public function loadNativeGraphics(Animated:Boolean = true, Reverse:Boolean = false, Width:uint = 0, Height:uint = 0, Unique:Boolean = false):void 
		{
			super.loadNativeGraphics(Animated, Reverse, Width, Height, Unique);
			
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			_txtDetection = new AxText (0, 0, AxFont.fromFont("alagard", true, 16), "100", 32, "center");
			$world.add(_txtDetection);
		}
		
		override public function update():void 
		{
			super.update();
			if (_txtDetection) {
				_txtDetection.x = x + 2;
				_txtDetection.y = y - 18;
				_txtDetection.text = _playerDetectionLevel.toString();
			}
			if (_isPounced) {
				return;
			}
			
			if (_playerDetectionLevel > 0 && !_isPlayerVisible) {
				setDetectionLevel(_playerDetectionLevel - 5);
			}
			updateAnimation();
			
		}
		
		protected function updateAnimation():void 
		{
			if (alive) {
				if (_isMoving) {
					animateDirectional("walk");
				} else {
					animateDirectional("idle");
					
				}
			} else {
				animateDirectional("dead");
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		override public function kill():void 
		{
			//super.kill();
			animate("dead" + _animSuffix);
			alive = false;
		}
		
		protected function castVision($shadowType:EnumShadowType = null, $visionRadius:int = 4):void 
		{
			
			if (lightmap != null) {
				var shadowCasterCone:int;
				switch ($shadowType) {
					default:
					case EnumShadowType.CONE:
							shadowCasterCone = (
							_faceDir == RIGHT ? Shadowcaster.CONE_EAST:
							_faceDir == LEFT ? Shadowcaster.CONE_WEST:
							_faceDir == UP ? Shadowcaster.CONE_NORTH:
							_faceDir == DOWN ? Shadowcaster.CONE_SOUTH:
							Shadowcaster.FULL_CIRLCE);
						break;
						
					case EnumShadowType.HALF:
						shadowCasterCone = (
							_faceDir == RIGHT ? Shadowcaster.HALF_EAST:
							_faceDir == LEFT ? Shadowcaster.HALF_WEST:
							_faceDir == UP ? Shadowcaster.HALF_NORTH:
							_faceDir == DOWN ? Shadowcaster.HALF_SOUTH:
							Shadowcaster.FULL_CIRLCE);
					break;
					
					case EnumShadowType.PERIPHERAL:
						shadowCasterCone = (
							_faceDir == RIGHT ? Shadowcaster.PERIPHERAL_EAST:
							_faceDir == LEFT ? Shadowcaster.PERIPHERAL_WEST:
							_faceDir == UP ? Shadowcaster.PERIPHERAL_NORTH:
							_faceDir == DOWN ? Shadowcaster.PERIPHERAL_SOUTH:
							Shadowcaster.FULL_CIRLCE);
					break;
				}
				if(_prevVisionX != tileX || _prevVisionY != tileY || _prevVisionDirection != _faceDir || _prevVisionRadius != $visionRadius){
					_visionCone = Shadowcaster.castShadows(lightmap, tileX, tileY, $visionRadius, shadowCasterCone);
					_prevVisionY = tileY;
					_prevVisionDirection = _moveDir;
					_prevVisionRadius = $visionRadius;
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
			if (_visionCone) {
				var visionMap:VisionMap = (_world as PJWorld).visionMap;
				if (_faceDir != NONE && alive)
				{
					var pjPlayer:PJPlayer = _world.player as PJPlayer
					var containsPlayer:Boolean;
					if (pjPlayer && pjPlayer.alive && pjPlayer.active) {
						visionMap.showVisionCone(_visionCone, this);
						var itterator:Itr = _visionCone.iterator();
						var sp:ShadowPoint;
						
						while (sp = itterator.next() as ShadowPoint) {
							if (pjPlayer.isOnTile(sp.x, sp.y)) {
								_playerDetectionLevel += (sp.intensity) * 10;
								containsPlayer = true;
								_isPlayerVisible = true;
							}
						}
					}
					if ( !containsPlayer) {
						_isPlayerVisible = false;
					}
				}
				else {
					visionMap.removeVisionCone(_visionCone);
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
		
		protected function onPounced():void {
			_isPounced = true;
			_tweenMove.kill();
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