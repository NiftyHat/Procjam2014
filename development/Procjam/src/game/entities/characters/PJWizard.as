package game.entities.characters 
{
	import axengine.entities.markers.AxMarkerStart;
	import axengine.util.ray.AxRayResult;
	import axengine.world.AxWorld;
	import game.entities.PJCharacter;
	import game.entities.PJFireball;
	import game.entities.PJPlayer;
	import game.PJEntity;
	import game.util.EnumShadowType;
	import game.world.PJWorld;
	import keith.Shadowcaster;
	import keith.ShadowPoint;
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
			_mMoveSpeed = 0.5;
			_libraryAssetName = "WIZARD";
			_isDebugPathfinding = true;
			_shootTimer = addTimer(1.0, onShootTimer, 0);
			_shootTimer.pause();
		}
		
		override public function loadNativeGraphics(Animated:Boolean = true, Reverse:Boolean = false, Width:uint = 0, Height:uint = 0, Unique:Boolean = false):void 
		{
			super.loadNativeGraphics(Animated, Reverse, Width, Height, Unique);
		}
		
		override public function kill():void 
		{
			Core.control.score["WIZARD"] += 1;
			super.kill();
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
			follow(null);
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
		}
		
		override public function update():void 
		{
			super.update();
			if (!alive) {
				destroy();
			}
			
			if (_isOverwatch && _overwatchTimer){
				var overwatchSize:int = 3 + 3 - int(_overwatchTimer.perc * 3); 
				if (_followTarget) {
					switch(_followTarget.faceDir) {
					case UP:
						face(DOWN);
					break;
					case DOWN:
						face(UP);
					break;
					case LEFT:
						face(RIGHT);
					break;
					case RIGHT:
						face(LEFT);
					break;
				}
				}
				
				castVision(EnumShadowType.HALF, overwatchSize);
			} else {
				castVision();
			}
			
			if (_playerDetectionLevel > 5) 
			{
				//I'VE SEEN THE PLAYER, QUICK, DO SOMETHIGN!
				if (!_shootTimer.active) {
					_shootTimer.start();
					_shootTimer.active = true;
				}
			} 
			else if (!_shootTimer.active) {
				if (!_followTarget) {
					var possibleTargets:Vector.<AxEntity> = _world.getEntitiesInRect(null, [PJThief]);
					if (possibleTargets && possibleTargets.length > 0) {
						for each (var item:PJThief in possibleTargets) {
							if (item.riskLevel >= 0 && !_followTarget && item.alive) {
								item.riskLevel--;
								follow(item);
								break;
							}
						}
					}
					if (!_followTarget)
					{
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
							_overwatchTimer = null;
						} else {
							if (!_overwatchTimer)
							{
								_overwatchTimer = addTimer(0.1, onOverwatchAdvance, 8);
								_overwatchTimer.start();
								_isOverwatch = true;
							}
							
						}
					}
				}
			}
			
			
		}
		
		private function onOverwatchAdvance():void 
		{
			
		}
		
		override protected function setDetectionLevel($value:int):void 
		{
			super.setDetectionLevel($value);
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
		
		private function hLine(xp:Number, yp:Number, w:Number):Vector.<AxPoint> {
			var line:Vector.<AxPoint> = new Vector.<AxPoint> ();
			for (var i:int = 0; i < w; i++) {
				line.push (new AxPoint(xp+i,yp));
			}
			return line;
		}
		
		public function follow($character:PJEntity):void {
			if (_followTarget) {
				if (_followTarget is PJThief) {
					(_followTarget as PJThief).riskLevel++;
				}
			}
			_followTarget = $character;
			if (_followTarget) {
				pathToEntity(_followTarget);
			}
			
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