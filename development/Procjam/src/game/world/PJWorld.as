package game.world 
{
	import axengine.entities.enemies.AxEnemy;
	import org.axgl.AxPoint;
	import axengine.entities.AxDynamicEntity;
	import axengine.util.ray.AxRayResult;
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
	import flash.geom.Point;
	import game.ai.PathCallbackRequest;
	import game.entities.PJCharacter;
	import game.entities.PJCoinPile;
	import game.entities.PJPlayer;
	import game.PJEntity;
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxSprite;
	import org.axgl.input.AxInput;
	import org.axgl.input.AxMouse;
	import org.axgl.text.AxText;
	import org.axgl.tilemap.AxTilemap;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJWorld extends AxWorld 
	{
		private var _aStarSolver:Astar;
		private var _aStarDebug:AxGroup;
		protected var _navigationMap:Map;
		protected var _visionDebug:AxGroup;
		protected var _groupAttackZone:AxGroup;
		protected var _soundDebug:AxGroup;
		
		public function PJWorld(x:Number=0, y:Number=0) 
		{
			super(x, y);
			add(new AxText(0, 0,  null, "Ax World"));
			m_level = new AxLevel ();
			m_level.init("level");
			m_level.loadData();
			_player = new PJPlayer();
			Core.control.score = 0;
		}
		
		public function checkForWin():void {
			var characters:Vector.<AxEntity> = getEntitiesInRect(null, [PJCharacter]);
			if (characters && characters.length > 0) {
					for each (var character:PJCharacter in characters) {
					if (character.alive) {
						return;
					}
				}
				Core.control.levelEnd(true);
			}
		}
		
		public function checkForLost():void {
			var treasures:Vector.<AxEntity> = getEntitiesInRect(null, [PJCoinPile]);
			if (treasures && treasures.length > 0) {
					for each (var treasure:PJCoinPile in treasures) {
					if (treasure.active) {
						return;
					}
				}
				Core.control.levelEnd(false);
			}
		}
		
		override public function update():void 
		{
			if (_visionDebug) {
				for each (var entity:AxEntity in _visionDebug.members) {
					entity.destroy();
				}
			}
			m_group_entities.sort("y");
			super.update();
			checkForLost();
		}
		
		public function clearPounceEffects():void {
			if (_groupAttackZone) {
				for each (var entity:AxEntity in _visionDebug.members) {
					entity.destroy();
				}
			}
			_groupAttackZone.clear();
		}
		
		override protected function init():void 
		{
			_aStarDebug = new AxGroup();
			_visionDebug = new AxGroup();
			_groupAttackZone = new AxGroup();

			super.init();
			//m_groups.unshift(_visionDebug);
			m_groups.splice(2, 0, _groupAttackZone);
			m_groups.splice(2, 0, _visionDebug);
			add(_aStarDebug);
			
		}
		
		override protected function initGroups():void 
		{
			super.initGroups();
		}
		
		override public function deserializeTiles($xml:XMLList):void 
		{
			super.deserializeTiles($xml);
			initAStarMap();
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
		
		public function get visionDebug():AxGroup 
		{
			return _visionDebug;
		}
		
		public function get groupAttackZone():AxGroup 
		{
			return _groupAttackZone;
		}
		
	}

}