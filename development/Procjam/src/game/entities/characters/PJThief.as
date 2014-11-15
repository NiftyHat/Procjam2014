package game.entities.characters 
{
	import axengine.entities.markers.AxMarkerStart;
	import axengine.util.ray.AxRayResult;
	import axengine.world.AxWorld;
	import com.greensock.TweenLite;
	import game.entities.PJCharacter;
	import game.entities.PJCoinPile;
	import game.entities.PJPlayer;
	import game.PJEntity;
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxPoint;
	import org.axgl.AxU;
	import org.axgl.util.AxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class PJThief extends PJCharacter
	{
		
		protected var _targetTreasure:PJCoinPile;
		protected var _stealTimer:AxTimer;
		
		
		public function PJThief() 
		{
			_mMoveSpeed = 0.2;
			_isForceBack = false;
			_isForceFront = true;
			_libraryAssetName = "THIEF";
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			loadNativeGraphics();
			_stealTimer = addTimer(0.3, onStealTimerComplete, 0);
			_stealTimer.pause();
		}
		
		private function onStealTimerComplete():void 
		{
			if (_targetTreasure && alive) {
				if (isOnEntity(_targetTreasure)) {
					_targetTreasure.hurt(10);
				} else {
					_stealTimer.pause();
				}
				
			}
		}
		
		protected function clearTarget():void {
			if (_targetTreasure) {
				_targetTreasure.isClaimed = false
				_targetTreasure = null;
			}
		}
		
		override public function kill():void 
		{
			Core.control.score["THIEF"] += 1;
			super.kill();
			clearTarget();
		}
		
		override public function update():void 
		{
			super.update();
			if (!alive) {
				if (_targetTreasure) {
					clearTarget();
				}
				return;
			}
			if (_isAlertMode) {
				_mMoveSpeed = 0.23;
				if (!_isMoving) {
					detectEscapeRoute();
				}
			} 
			else 
			{
				_mMoveSpeed = 0.5;
				if (!_isMoving) 
				{
					if (_targetTreasure && _targetTreasure.alive && isOnEntity(_targetTreasure)) {
						_stealTimer.start();
					} else {
						detectTreasure();
					}
				}
			}
			
			castVision();
		}
		
		override protected function onJustSeenPlayer(pJPlayer:PJPlayer):void 
		{
			super.onJustSeenPlayer(pJPlayer);
			if (_tweenMove) {
				_tweenMove.reverse();
				_isMoving = false;
			}
			_path = null;
			clearTarget();
			//pJPlayer.stun(2);
			detectEscapeRoute();
			
		}
		
		public function detectEscapeRoute():void {
			
			var escapeRoutes:Object = {
				up:new AxPoint(centerX, centerY - 256),
				down: new AxPoint(centerX, centerY + 256),
				left: new AxPoint(centerX - 256, centerY),
				right: new AxPoint(centerX + 256, centerY)
			}
			var player:PJPlayer = _world.player as PJPlayer;
			var difX:int = centerX - _world.player.centerX;
			var difY:int = centerY - _world.player.centerY;
			var target:AxPoint = new AxPoint (centerX, centerY);
			if (Math.abs(difX) > Math.abs(difY)) {
				if (difX < 0) {
					delete escapeRoutes ["right"]
				} else {
					delete escapeRoutes ["left"]
				}
			} else {
				if (difY < 0) {
					delete escapeRoutes ["down"]
				} else {
					delete escapeRoutes ["up"]
				}
			}
			var bestRoute:AxRayResult;
			for (var dir:String in escapeRoutes) {
				
				var currEscapePoint:AxPoint = escapeRoutes[dir];
				trace(dir, currEscapePoint);
				var rayResult:AxRayResult = _world.castRay(getCenterPoint() , currEscapePoint, 0);
				if (!bestRoute || (rayResult.lastPoint && (rayResult.path.length >= bestRoute.path.length))) {
					bestRoute = rayResult;
				}
			}
			pathToTile(bestRoute.lastPoint.x , bestRoute.lastPoint.y);
		}
		
		public function distanceFrom ($entity:PJEntity):int {
			var dx:int = (centerX - $entity.centerX);
			var dy:int = (centerY - $entity.centerY);
			var dist:int = Math.sqrt ((dx * dx) + (dy * dy));
			return dist;
		}
	
		public function detectTreasure():void {
			if (_targetTreasure) {
				_targetTreasure.isClaimed = false;
			}
			var treasure_list:Vector.<AxEntity> = _world.getEntitiesInRect(null, [PJCoinPile]);
			var bestTreasure:PJCoinPile;
			var bestDistance:int = int.MAX_VALUE;
			for each (var item:PJCoinPile in treasure_list) {
				
				if (item.alive && !item.isClaimed) {
					var distance:int = distanceFrom(item)
					if (!bestTreasure || distance < bestDistance) {
						bestTreasure = item;
						bestDistance = distance;
					}
				}
			}
			if (bestTreasure) {
				_targetTreasure = bestTreasure;
				bestTreasure.isClaimed = true;
				pathToTile(bestTreasure.tileX, bestTreasure.tileY);
			} else {
				var startMarkers:Vector.<AxEntity> = _world.getEntitiesInRect(null, [AxMarkerStart]);
				if (startMarkers.length > 0) {
					var marker:AxMarkerStart = startMarkers[0] as AxMarkerStart;
					if (isOnTile(int(marker.x) / 32, int(marker.y) / 32)) {
						destroy();
					} else {
						pathToTile(marker.x / 32, marker.y / 32);
					}
					
				}
			}
			
		}
		
	}

}