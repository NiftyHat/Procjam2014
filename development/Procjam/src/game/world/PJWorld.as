package game.world 
{
	import axengine.entities.AxGameEntity;
	import axengine.entities.markers.AxMarkerStart;
	import axengine.world.AxDynamicTilemap;
	import axengine.world.AxWorld;
	import axengine.world.level.AxLevel;
	import be.dauntless.astar.basic2d.analyzers.FullClippingAnalyzer;
	import be.dauntless.astar.basic2d.analyzers.WalkableAnalyzer;
	import be.dauntless.astar.basic2d.BasicTile;
	import be.dauntless.astar.basic2d.Map;
	import be.dauntless.astar.core.Astar;
	import be.dauntless.astar.core.AstarEvent;
	import be.dauntless.astar.core.AstarPath;
	import com.greensock.TweenLite;
	import de.polygonal.math.PM_PRNG;
	import flash.geom.Point;
	import game.ai.PathCallbackRequest;
	import game.deco.PJGravestone;
	import game.entities.characters.PJThief;
	import game.entities.characters.PJWizard;
	import game.entities.PJCharacter;
	import game.entities.PJCoinPile;
	import game.entities.PJPlayer;
	import game.entities.PJProjectile;
	import game.ui.events.GoldEvent;
	import game.VisionMap;
	import keith.ConvertToAxTileMaps;
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxRect;
	import org.axgl.text.AxText;
	import org.axgl.tilemap.AxTilemap;
	import utils.Shuffle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJWorld extends AxWorld 
	{
		private var _aStarSolver:Astar;
		private var _aStarDebug:AxGroup;
		private var _emptyTiles:Array;
		private var generator:ConvertToAxTileMaps;
		private var _visionMap:VisionMap;
		protected var _navigationMap:Map;
		protected var _groupAttackZone:AxGroup;
		protected var _soundDebug:AxGroup;
		protected var _seed:int = Math.random() * int.MAX_VALUE;
		protected var _difficulty:int = 1;
		
		public function PJWorld(x:Number=0, y:Number=0) 
		{
			super(x, y);
			_emptyTiles = [];
			add(new AxText(0, 0,  null, "Ax World"));
			m_level = new AxLevel ();
			m_level.init("level");
			m_level.loadData();
			_player = new PJPlayer();
		}
		
		public function checkForWaveDefeated():void {
			var characters:Vector.<AxEntity> = getEntitiesInRect(null, [PJCharacter]);
			if (characters && characters.length > 0) {
				var character:PJCharacter
					for each (character in characters) {
					if (character.exists && character.alive) {
						return;
					}
				}
				_difficulty += 1;
				for each (character in characters) {
					
					var grave:PJGravestone = new PJGravestone (character);
					addEntity(grave,character.x, character.y);
					character.destroy();
				}
				generateEnemies(new AxPoint(2,2));
			}
		}
		
		public function checkForLost():void {
			if (!_player.exists) {
				Core.control.levelEnd(false);
				return;
			}
			var treasures:Vector.<AxEntity> = getEntitiesInRect(null, [PJCoinPile]);
			if (treasures && treasures.length > 0) {
					var totalGold:int = 0;
					for each (var treasure:PJCoinPile in treasures) {
					if (treasure.active) {
						totalGold += treasure.health;
					}
				}
				if (totalGold <= 0) {
					Core.control.levelEnd(false);
				}
				Core.control.dispatchEvent(new GoldEvent(GoldEvent.SET_DUNGEON_CURRENT_GOLD_TO,totalGold));
			}
			
		}
		
		override public function update():void 
		{
			if (_visionMap && _visionMap.isDirty()) {
				_visionMap.clearVision();
			}
			m_group_entities.sort("y");
			super.update();
			checkForLost();
			
		}
		
		public function clearPounceEffects():void {
			if (_groupAttackZone) {
				for each (var entity:AxEntity in _groupAttackZone.members) {
					entity.destroy();
				}
			}
			_groupAttackZone.clear();
		}
		
		override protected function init():void 
		{
			_aStarDebug = new AxGroup();
			_groupAttackZone = new AxGroup();
			_visionMap = new VisionMap (0, 0);
			add(_visionMap);

			super.init();
			//m_groups.unshift(_visionDebug);
			m_groups.splice(2, 0, _groupAttackZone);
			m_groups.splice(2, 0, _visionMap);
			add(_aStarDebug);
			
		}
		
		override protected function initGroups():void 
		{
			super.initGroups();
		}
		
		override public function deserializeEntities($xml:XMLList):void 
		{
			//super.deserializeEntities($xml);
			var startMarker:AxMarkerStart = new AxMarkerStart();
			addEntity(startMarker, 32, 32);
			
		}
		
		override public function deserializeTiles($xml:XMLList):void 
		{
			//super.deserializeTiles($xml);
			generator = new ConvertToAxTileMaps();
			generator.generate(10, 5, _seed);
			
			var floor:AxTilemap = generator.getFloorGeometry();
			m_group_bg.add(floor);
			var walls:AxDynamicTilemap = generator.getWallGeometry();
			m_collision_map = walls;
			
			
			//Shadowcaster.castShadows(walls, 2, 2, 5, Shadowcaster.CONE_NORTH);
			Ax.camera.bounds = new AxRect(0,0,walls.width,walls.height)
			m_group_collision.add(walls);
			m_group_bg.add(walls);
			initAStarMap();
			
			_visionMap.setSize(m_collision_map.cols, m_collision_map.rows);
			
			
			generateEnemies();
			generateGold();
		}
		
		private function generateGold():void 
		{
			var pr:PM_PRNG = new PM_PRNG();
			pr.seed = _seed;
			var emptyTiles:Array  = _emptyTiles.slice();
			Shuffle.array(emptyTiles, _seed);
			var totalGoldValue:int = 500;
			var minPiles:int = 8;
			var maxPiles:int = 15;
			var goldPileCount:int = pr.nextIntRange(minPiles, maxPiles);
			Core.control.dispatchEvent(new GoldEvent(GoldEvent.SET_DUNGEON_TOTAL_GOLD_TO, totalGoldValue));
			while (totalGoldValue > 0 && emptyTiles.length > 0 && goldPileCount > 0) {
				var gold:PJCoinPile = new PJCoinPile();
				var tile:AxPoint = emptyTiles.pop();
				var pileValue:int = (totalGoldValue / goldPileCount) + pr.nextIntRange(-40, 40);
				totalGoldValue -= pileValue;
				if (totalGoldValue < 0) {
					pileValue += totalGoldValue;
					totalGoldValue = 0;
				}
				gold.setGold(pileValue);
				gold.x = tile.x * 32;
				gold.y = tile.y * 32;
				goldPileCount--;
				addEntity(gold);
			}
		}
		
		override public function addEntity(e:AxGameEntity, $x_pos:int = 0, $y_pos:int = 0):void 
		{
			if (e is PJProjectile) {
				m_group_projectiles.add(e);
			}
			if (e is PJCharacter) {
				(e as PJCharacter).lightmap = generator.getLightmap();
			}
			super.addEntity(e, $x_pos, $y_pos);
		}
		
		public function generateEnemies ($tile:AxPoint = null ):void {
			var pr:PM_PRNG = new PM_PRNG();
			pr.seed = _seed;
			var numThieves:int = pr.nextIntRange(_difficulty , _difficulty * 1.5);
			var numRangers:int = pr.nextIntRange(_difficulty, _difficulty * 1.2 );
			
			var startingTiles:Array = getSpawningTiles();
			Shuffle.array(startingTiles, _seed);
			while (numThieves > 0 && startingTiles.length > 0) {
				var thief:PJThief = new PJThief ();
				var startTileIndex:int = pr.nextIntRange(0, startingTiles.length - 1)
				var startingTile:AxPoint = startingTiles.splice(startTileIndex, 1)[0];
				if ($tile) {
					startingTile = $tile;
				}
				thief.x = startingTile.x * 32;
				thief.y = startingTile.y * 32;
				TweenLite.delayedCall((0.25 * numThieves)  + 0.1, addEntity, [thief]);
				numThieves--;
				if (numRangers > 0) {
					numRangers--;
					var wizard:PJWizard = new PJWizard ();
					var startTileIndex:int = pr.nextIntRange(0, startingTiles.length - 1)
					var startingTile:AxPoint = startingTiles.splice(startTileIndex, 1)[0];
					if ($tile) {
						startingTile = $tile;
					}
					wizard.x = startingTile.x * 32;
					wizard.y = startingTile.y * 32;
					addEntity(wizard);
					TweenLite.delayedCall((0.25 * numRangers) + 0.1, addEntity, [wizard]);
				}
			}
		}
		
		public function getSpawningTiles ():Array {
			var startAreaSize:int = 15;
			var spawningTiles:Array = [];
			for (var x:int = 5; x < startAreaSize; x++) {
				for (var y:int = 5; y < startAreaSize; y++) {
					if (m_collision_map.getTileAt(x,y) == null){
						spawningTiles.push(new AxPoint(x, y));
					}
				}
			}
			
			return spawningTiles;
		}
	
		
		public function getAStarPath ($startTile:Point, $endTile:Point, $callback:Function , $params:Array = null, $debug:Boolean = false):void {
			var request:PathCallbackRequest = new PathCallbackRequest ($startTile, $endTile, _navigationMap);
 			request.callback = $callback;
			request.params = $params;
			request.debug = $debug;
			_aStarSolver.getPath(request);
		}

		protected function initAStarMap ():void {
			_navigationMap = new Map(collision_map.cols, collision_map.rows, 1);
			_navigationMap.heuristic = Map.DIAGONAL_HEURISTIC;
			for (var y:int = 0; y < collision_map.rows; y++) {
				for (var x:int = 0; x < collision_map.cols; x++) {
					var tileIndex:int = collision_map.getTileIndexAt(x, y); 
					_navigationMap.setTile(new BasicTile(1, new Point(x, y), (tileIndex <= 0)));
					if (tileIndex <= 0 && x> 10 && y > 10) {
						
						_emptyTiles.push(new AxPoint(x,y));
					}
					
				}
			}
			_aStarSolver = new Astar();
			_aStarSolver.addEventListener(AstarEvent.PATH_FOUND, onPathFound);
			_aStarSolver.addEventListener(AstarEvent.PATH_NOT_FOUND, onPathNotFound);
			_aStarSolver.addAnalyzer(new WalkableAnalyzer());
			_aStarSolver.addAnalyzer(new FullClippingAnalyzer());
		}
		
		override public function destroy():void 
		{
			super.destroy();
			m_level.destroy();
			m_level = null;
			_aStarSolver.removeEventListener(AstarEvent.PATH_FOUND, onPathFound);
			_aStarSolver.removeEventListener(AstarEvent.PATH_NOT_FOUND, onPathNotFound);
		}
		
		private function onPathFound(event : AstarEvent) : void
		{
			var result:AstarPath = event.result;
			var request:PathCallbackRequest = event.request as PathCallbackRequest;
			if (request && request.callback != null) {
				if (!request.params) {
					request.params = []
				}
				request.params.unshift(result);
				if (request.callback.length > 0) {
					request.callback.apply(null, request.params);
				} else {
					request.callback();
				}
			}
			//
			if (request.debug) {
				_aStarDebug.clear(true);
				for(var i:int = 0; i<event.result.path.length;i++)
				{
					
					var next:Point = ((event.result.path[i] as BasicTile).getPosition());
					var temp:AxText = new AxText (next.x * 32, next.y * 32, null, "P" + i, 16, "center");
					_aStarDebug.add(temp);
				}
			}
			
		}
		
		private function onPathNotFound(event : AstarEvent) : void
		{
			trace("path not found");
		}
		
		public function get groupAttackZone():AxGroup 
		{
			return _groupAttackZone;
		}
		
		public function get visionMap():VisionMap 
		{
			return _visionMap;
		}
		
	}

}