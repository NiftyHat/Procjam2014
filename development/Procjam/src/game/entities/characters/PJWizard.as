package game.entities.characters 
{
	import axengine.entities.markers.AxMarkerStart;
	import axengine.util.ray.AxRayResult;
	import axengine.world.AxWorld;
	import game.entities.PJCharacter;
	import game.entities.PJFireball;
	import game.entities.PJPlayer;
	import game.PJEntity;
	import game.world.PJWorld;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxSprite;
	import org.axgl.util.AxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class PJWizard extends PJCharacter
	{
		private var _isOverwatch:Boolean;
		private var _lastOverwatchRadius:int;
		
		protected var _followTarget:PJEntity;
		protected var _overwatchRegion:Vector.<AxPoint>;
		protected var _overwatchTimer:AxTimer;
		protected var _shootTimer:AxTimer;
		
		public function PJWizard() 
		{
			_mMoveSpeed = 0.4;
			_libraryAssetName = "WIZARD";
			_isDebugPathfinding = true;
			_shootTimer = addTimer(1.0, onShootTimer, 0);
			_shootTimer.pause();
		}
		
		private function onShootTimer():void 
		{
			
			var player:PJPlayer = (_world.player as PJPlayer)
			if (player && player.alive) {
				var fireballCheck:AxRayResult = _world.castRay(this.center, player.center,0);
				if (!fireballCheck.blocked) {
					var shot:PJFireball = new PJFireball ();
					_world.addEntity(shot, centerX, centerY);
					shot.shootAtEntity(player, 80);
				}
			}
			_followTarget = null;
			if (!_isAlertMode) {
				_shootTimer.pause();
			}
		}
		
		private function onOverwatchTimer():void 
		{
			
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			loadNativeGraphics();
			generateAnims();
		}
		
		override public function update():void 
		{
			super.update();
			if (!alive) {
				destroy();
			}
			if (_shootTimer.active) {
				return;
			}
			if (!_followTarget) {
				var possibleTargets:Vector.<AxEntity> = _world.getEntitiesInRect(null, [PJThief]);
				if (possibleTargets && possibleTargets.length > 0) {
					for each (var item:PJThief in possibleTargets) {
					if (item.riskLevel >= 0 && !_followTarget) {
						item.riskLevel--;
						follow(item);
						break;
					}
					
					}
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
				
			} else {
				if (!_isMoving) {
					var dx: int = Math.abs(_followTarget.tileX - this.tileX);
					var dy: int =  Math.abs(_followTarget.tileY - this.tileY);
					if (dx > 1 || dy > 1) {
						pathToEntity(_followTarget);
						_isOverwatch = false;
					} else {
						_isOverwatch = true;
					}
				}
			}
			castVision();
		}
		
		override protected function castVision():void 
		{
			if (!_isOverwatch) {
				super.castVision();
				_lastOverwatchRadius = -1;
				if (_overwatchTimer) {
					_overwatchTimer.stop();
					_overwatchTimer = null;
				}
				
			} else {
				if (!_overwatchTimer)
				{
					_overwatchTimer = addTimer(0.3, onOverwatchTimer, 3);
				}
				var overwatchRadius:int = (_overwatchTimer.max - _overwatchTimer.repeat) + 1;
				var overwatchCircle:Vector.<AxPoint> = visionCircle(tileX, tileY, overwatchRadius);
				for each(var point:AxPoint in overwatchCircle) {
					
					
					if (_world && (_world.player as PJEntity).isOnTile(point.x, point.y)) {
						_playerDetectionLevel += 5;
					} 
					setDetectionLevel(_playerDetectionLevel);/*
					var visionView:AxGroup = PJWorld(_world).visionDebug;
					var temp:AxSprite = visionView.recycle() as AxSprite;
					if (!temp) {
						temp = new AxSprite (0,0);
						temp.load(Core.lib.int.img_vision_tiles, 32, 32);
						
					}
					temp.x = point.x * 32
					temp.y = point.y * 32
					temp.show(3);
					
					//temp.frame =  3 + int((temp.totalFrames /100) * _playerDetectionLevel) 
					visionView.add(temp);*/
				}
			}
			
		}
		
		override protected function setDetectionLevel($value:int):void 
		{
			super.setDetectionLevel($value);
			if (_playerDetectionLevel > 3) {
				if (!_shootTimer.active) {
					_shootTimer.start();
					_shootTimer.active = true;
				}
				
			}
		}
		
		protected function visionCircle(xp:Number, yp:Number, radius:Number):Vector.<AxPoint> {
			if (radius == _lastOverwatchRadius) {
				return _overwatchRegion;
			}
			_lastOverwatchRadius = radius;
			var xoff:int =0;
			var yoff:int = radius;
			var balance:int = -radius;
			var tiles:Vector.<AxPoint> = new Vector.<AxPoint>();		 
			while (xoff <= yoff) {
				 var p0:int = xp - xoff;
				 var p1:int = xp - yoff;
				 
				 var w0:int = xoff + xoff;
				 var w1:int = yoff + yoff;
				 tiles = tiles.concat(
				 hLine(p0, yp + yoff, w0),
				 hLine(p0, yp - yoff, w0),
				 
				 hLine(p1, yp + xoff, w1),
				 hLine(p1, yp - xoff, w1));
			   
				if ((balance += xoff++ + xoff)>= 0) {
					balance-=--yoff+yoff;
				}
			}
			_overwatchRegion = tiles;
			return tiles;
		}
		
		function hLine(xp:Number, yp:Number, w:Number):Vector.<AxPoint> {
			var line:Vector.<AxPoint> = new Vector.<AxPoint> ();
			for (var i:int = 0; i < w; i++) {
				line.push (new AxPoint(xp+i,yp));
			}
			return line;
		}
		
		public function follow($character:PJEntity):void {
			_followTarget = $character;
			pathToEntity($character);
		}
		
		override protected function onMoveComplete():void 
		{
			super.onMoveComplete();
			if (_followTarget) {
				//pathToEntity(_followTarget);
			} else {
				_path = null;
			}
		}
		
	}

}