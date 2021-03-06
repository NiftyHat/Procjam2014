package game.entities 
{
	import axengine.entities.AxPlayer;
	import axengine.util.ray.AxRayResult;
	import axengine.world.AxWorld;
	import be.dauntless.astar.core.AstarPath;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import game.ai.PathCallbackRequest;
	import game.PJEntity;
	import game.world.PJWorld;
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxRect;
	import org.axgl.AxSprite;
	import org.axgl.input.AxKey;
	import org.axgl.util.AxTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJPlayer extends PJEntity 
	{
		private var _attackTarget:AxPoint;
	
		protected var _stunTimer:AxTimer;
		protected var _isStunned:Boolean = false;
		protected var _isChargingPounce:Boolean = false;
		protected var _isPouncing:Boolean = false;
		protected var _pounceTimer:AxTimer;
		
		
		public function PJPlayer() 
		{
			super();
			addAnimation("walk_down", [0, 1, 2],4);
			addAnimation("walk_left", [3, 4, 5],4);
			addAnimation("walk_right", [6, 7, 8],4);
			addAnimation("walk_up", [9, 10, 11],4);
			addAnimation("idle_down", [1]);
			addAnimation("idle_left", [4]);
			addAnimation("idle_right", [7]);
			addAnimation("idle_up", [10]);
			_attackTarget = new AxPoint();
			_mMoveSpeed = 0.20;
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world); 
			_libraryAssetName = "PLAYER";
			loadNativeGraphics();
		}
		
		override public function update():void 
		{
			super.update();
			if (_isPouncing) {
				animate("pounce" + _animSuffix);
				return;
			}
			if (_isStunned) {
				animate("stun" + _animSuffix);
				return;
			}
			if (!_isMoving) {
				if (Ax.keys.down(AxKey.SPACE)) {
					pounceCharge();
				} else if (_isChargingPounce) {
					pounceCancel();
				}
				if (!_isChargingPounce && !_isPouncing) {
					if (Ax.keys.down(AxKey.DOWN)) {
					move(DOWN);
					}
					else if (Ax.keys.down(AxKey.UP)) {
						move(UP);
					}
					else if (Ax.keys.down(AxKey.LEFT)) {
						move(LEFT);
					}
					else if (Ax.keys.down(AxKey.RIGHT)) {
						move(RIGHT);
					}
					else {
						move(NONE);
					}
				} 
				else 
				{
					var oldFaceDir:int = _faceDir;
					
					if (Ax.keys.down(AxKey.DOWN)) {
					_faceDir = DOWN;
					}
					else if (Ax.keys.down(AxKey.UP)) {
						_faceDir =  (UP);
					}
					else if (Ax.keys.down(AxKey.LEFT)) {
						_faceDir = (LEFT);
					}
					else if (Ax.keys.down(AxKey.RIGHT)) {
						_faceDir = (RIGHT);
					}
					if (oldFaceDir != _faceDir) {
						//_pounceTimer.repeat = _pounceTimer.max;
						clearPounceEffect();
					}
				}
				
			}
			
			if (_isMoving) {
				animate("walk" + _animSuffix);
			} else {
				if (_isChargingPounce) {
					animate("pounce_charge" + _animSuffix);
				} else {
					animate("idle" + _animSuffix);
				}
				
			}
		}
		
		private function pounceCancel():void 
		{
			if (_pounceTimer) {
				var pounceResult:AxRayResult = castPounce((_pounceTimer.max - _pounceTimer.repeat));
				_pounceTimer.stop();
				clearPounceEffect();
				if (_isChargingPounce && !_isPouncing) {
						if (pounceResult) {
						pounceAttack(pounceResult);
					}
				}
				_isChargingPounce = false;
				_pounceTimer = null;
				
				
			}
		}
		
		private function pounceAttack($rayResult:AxRayResult):void 
		{
			if (_isPouncing) {
				return;
			}
			trace("pounce attack from", _tileX,tileY);
			var char:PJCharacter;
			for each (var tile:AxPoint in $rayResult.path) {
				var characters:Vector.<AxEntity> = _world.getEntitiesInTile(tile, [PJCharacter]);
				var isTargetFound:Boolean;
				if (characters) {
					for each (var testChar:PJCharacter in characters) {
						char = testChar;
						if (char.alive) {
							isTargetFound = true;
							break;
						}
					}
				}
				if (isTargetFound) {
					break;
				}
			}
			if ($rayResult.lastPoint) {
				var tx:int =$rayResult.lastPoint.x * 32;
				var ty:int = $rayResult.lastPoint.y * 32;
				if (char) {
					tx = int(char.x / 32) * 32;
					ty = int(char.y / 32) * 32;
				}
				_isPouncing = true;
				//onPounceComplete(char);
				TweenLite.to(this, ($rayResult.path.length) * 0.05 , {x:tx, y:ty, overwrite:0, onComplete:onPounceComplete, onReverseComplete:onPounceComplete, onCompleteParams:[char]})
			} else {
				onPounceComplete(null);
			}
			
		}
		
		private function onPounceComplete($target:PJCharacter):void 
		{
			trace("onPounceComplete");
			_isPouncing = false;
			_isMoving = false;
			_isChargingPounce = false;
			if ($target) {
				$target.kill();
			}
			addTimer(0.3, (_world as PJWorld).checkForWaveDefeated, 1);
		}
		
		private function clearPounceEffect():void 
		{
			(_world as PJWorld).clearPounceEffects()
		}
		
		protected function pounceCharge ():void {
			if (!_pounceTimer) {
				_isChargingPounce = true;
				_pounceTimer = addTimer(0.2, onPounceCharge, 3);
			} else {
				if (_pounceTimer) {
					castPounce((_pounceTimer.max - _pounceTimer.repeat));
				}
			}
		}
		
		private function onPounceCharge():void 
		{
			
		}
		
		public function stun($time:Number):void 
		{
			/*
			_isStunned = true;
			_isChargingPounce = false;
			pounceCancel();
			if (!_stunTimer) {
				_stunTimer = addTimer($time, onStunComplete);
			} else {
				_stunTimer.repeat = _stunTimer.max;
				_stunTimer.alive = true;
			}
			_stunTimer.start();*/
		}
		
		protected function castPounce($distance:int):AxRayResult 
		{
			if ($distance <= 0) {
				return null;
			}
			_attackTarget.x = centerX;
			_attackTarget.y = centerY;
			var attackSource:AxPoint = new AxPoint(center.x,center.y);
			var pixelDistance:int = ($distance * 32) + 16;
			switch (_faceDir) {
				case DOWN:
					_attackTarget.y += pixelDistance;
					attackSource.y += 16;
				break;
				case UP:
					_attackTarget.y -= pixelDistance;
					attackSource.y -= 16;
				break;
				case LEFT:
					_attackTarget.x -= pixelDistance;
					attackSource.x -= 16;
				break;
				case RIGHT:
					_attackTarget.x += pixelDistance;
					attackSource.x += 16;
				break;
			}
			if (_faceDir != NONE) {
				var rayResult:AxRayResult = _world.castRay(attackSource, new AxPoint(_attackTarget.x, _attackTarget.y), 0);
				for each(var point:AxPoint in rayResult.path) {
					var visionView:AxGroup = PJWorld(_world).groupAttackZone;
					var temp:AxSprite = visionView.recycle() as AxSprite;
					if (!temp) {
						temp = new AxSprite (0,0);
						temp.load(Core.lib.int.img_attack_zone_tiles, 32, 32);
						temp.addAnimation("idle", [0, 1, 2], 10, false);
					}
					temp.x = point.x * 32
					temp.y = point.y * 32
					temp.animate("idle");
					//temp.frame =  3 + int((temp.totalFrames /100) * _playerDetectionLevel) 
					//temp.frame =  3 + int((temp.totalFrames /100) * _playerDetectionLevel) 
					visionView.add(temp);
					//temp.frame = 4;
				}
				return rayResult;
			} 
			return null;
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		override public function kill():void 
		{
			addTimer(1.0, Core.control.levelEnd, 1).start();
			super.kill();
		}
		
		private function onStunComplete():void 
		{
			_isStunned = false;
			stopFlicker();
		}
		
		override protected function isTileWalkable(nextTile:AxPoint):Boolean 
		{
			var isWalkable:Boolean = super.isTileWalkable(nextTile);
			var isBlocked:Boolean = false//(_world.getEntitiesInTile(nextTile, [PJCharacter]) != null);
			return isWalkable && !isBlocked;
		}
		
		override protected function move($dir:int):void 
		{
			super.move($dir);
		}
		
	}

}