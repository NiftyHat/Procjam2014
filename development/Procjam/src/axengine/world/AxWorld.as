package axengine.world
{
	import axengine.entities.AxDynamicEntity;
	import axengine.entities.AxGameEntity;
	import axengine.entities.AxPlayer;
	import axengine.entities.enemies.AxEnemy;
	import axengine.entities.markers.AxMarker;
	import axengine.entities.pickups.AxPickup;
	import axengine.entities.projectiles.AxProjectile;
	import axengine.entities.volumes.AxVolume;
	import axengine.events.AxEntityEvent;
	import axengine.events.AxLevelEvent;
	import axengine.util.ray.AxRayResult;
	import axengine.world.level.AxLevel;
	import axengine.world.level.AxLevelArea;
	import base.events.GameEvent;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import game.entities.PJCharacter;
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxModel;
	import org.axgl.AxPoint;
	import org.axgl.AxRect;
	import org.axgl.AxSprite;
	import org.axgl.camera.AxCamera;
	import org.axgl.collision.AxCollider;
	import org.axgl.collision.AxCollisionGroup;
	import org.axgl.collision.AxGrid;
	import org.axgl.particle.AxParticleCloud;
	import org.axgl.tilemap.AxTilemap;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxWorld extends AxGroup
	{
		protected var m_level:AxLevel;
		protected var _player:AxDynamicEntity;
		
		public static var OBJECT_COLLISION:AxCollisionGroup// = new AxGrid();
		
		protected var m_entitys:Vector.<AxGameEntity>
		protected var m_groups:Vector.<AxGroup>
		protected var m_tilemaps:Vector.<AxDynamicTilemap>
		protected var m_collision_map:AxDynamicTilemap;
		
		protected var m_group_bg:AxGroup = new AxGroup ();
		protected var m_group_entities:AxGroup = new AxGroup ();
		protected var m_group_collision:AxGroup = new AxGroup ();
		private var m_group_pickups:AxGroup = new AxGroup ();
		private var m_group_overlay:AxGroup = new AxGroup ();
		private var m_group_effects:AxGroup = new AxGroup (500);
		protected var m_group_enemies:AxGroup = new AxGroup ();
		private var m_group_main:AxGroup = new AxGroup ();
		private var m_group_fg:AxGroup = new AxGroup ();
		private var m_group_volumes:AxGroup = new AxGroup ();
		private var m_group_parallax:AxGroup = new AxGroup ();
		private var m_bg_block:AxGameEntity = new AxGameEntity();
		protected var m_isPlayerAdded:Boolean;
		protected var m_group_projectiles:AxGroup = new AxGroup ();
		
		//CHECKPOINT STUFF;
		private var m_last_link_id:int = -1;
		private var _timerManager:AxEntity;
		//private var m_last_checkpoint:MarkerCheckpoint;
		private var m_last_checkpoint_guid:String;
		private var m_last_player_facing:uint;
		
		private var m_isPaused:Boolean;
		protected var m_isSwitchingAreas:Boolean;
		private var m_gravity:int = 335;
		protected var m_eventBus:EventDispatcher;
		
		
		public function AxWorld(x:Number=0, y:Number=0)
		{
			super(x, y);
			m_eventBus = Core.control;
			scroll.x = scroll.y = 1;
			addListeners();
			init();
		}
		
		public function pause ():void
		{
			trace("world paused!");
			_timerManager.active = false;
			m_isPaused = true;
		}
		
		public function unpause ():void
		{
			_timerManager.active = true;
			trace("world unpaused!");
			m_isPaused = false;
		}
		
		protected function init():void
		{
			m_entitys = new Vector.<AxGameEntity>()
			m_groups = new Vector.<AxGroup>;
			m_bg_block = new AxGameEntity ();
			m_bg_block.scroll.x = m_bg_block.scroll.y = 0;
			//m_group_parallax.add(m_bg_block);
			m_groups.push(m_group_parallax);
			m_groups.push(m_group_bg);
			m_groups.push(m_group_entities);
			m_groups.push(m_group_projectiles);
			m_groups.push(m_group_collision);
			m_groups.push(m_group_pickups);
			m_groups.push(m_group_volumes);
			
			m_groups.push(m_group_main);
			m_groups.push(m_group_fg);
			//m_groups.push(m_group_enemies);
			m_groups.push(m_group_effects);
			m_groups.push(m_group_overlay);
		}
		
		public function addOverlay($axSprite:AxGroup):void {
			m_group_overlay.add($axSprite);
		}
		
		override public function update():void
		{
			
			if (m_isPaused) return;
			super.update();
			
			if (_player)
			{
				Ax.overlap(_player, m_group_entities, onPlayerEntityOverlap, OBJECT_COLLISION);
				//Ax.overlap(_player, m_group_volumes, onPlayerVolumeOverlap, OBJECT_COLLISION);
				//Ax.overlap(_player, m_group_pickups, onPlayerPickupOverlap, OBJECT_COLLISION);
				
				//Ax.overlap(m_group_projectiles, m_group_entities, onProjectileHitEntity, OBJECT_COLLISION);
				//Ax.overlap(m_group_projectiles, _player, onProjectileHitEntity, OBJECT_COLLISION);
				Ax.collide(m_group_projectiles, m_group_collision, null, OBJECT_COLLISION);
				
				//Ax.collide(m_group_effects, m_group_collision,null,OBJECT_COLLISION);
				//Ax.collide(m_group_enemies, m_group_collision, null, OBJECT_COLLISION);
			} else {
				trace("no player");
			}
						
		}
		
		private function onPlayerPickupOverlap($player:AxDynamicEntity, $pickup:AxPickup):void
		{
			$pickup.onPlayerOverlap($player);
		}
		
		private function onProjectileHitCollision($projectile:AxProjectile, $entity:AxModel):void
		{
			if ($entity != $projectile.source)
			{
				//$projectile.kill();
			}
		}
		
		private function onProjectileHitEntity($projectile:AxProjectile, $entity:AxDynamicEntity):void
		{
			if ($entity.isProjectileTarget && $projectile.source != $entity) {
				$projectile.onHitEntity($entity);
			}
			
		}
		
		public function collisionCheck($rect:AxEntity):Boolean {
			$rect.phased = true;
			$rect.solid = true;
			return Ax.overlap($rect, m_collision_map);
		}
		
		
		
		private function addListeners():void
		{
			trace("add listners");
			Core.control.addEventListener(AxEntityEvent.ADD_TO_WORLD, onAddEntity);
			//PLAYER INIT POSITION
			Core.control.addEventListener(AxEntityEvent.SET_PLAYER_AREA, onSetPlayerArea);
			Core.control.addEventListener(AxEntityEvent.SET_PLAYER_START, onSetPlayerStart);
			Core.control.addEventListener(AxEntityEvent.REMOVE_FROM_WORLD, onRemoveEntity);
			//Core.control.addEventListener(AxEntityEvent.SET_PLAYER_CHECKPOINT, onSetPlayerCheckpoint);
			//GAME CORE
			Core.control.addEventListener(AxLevelEvent.LOAD_FINISHED, onLevelLoaded);
			Core.control.addEventListener(AxLevelEvent.END, onLevelEnd);
			Core.control.addEventListener(AxLevelEvent.RESTART, onLevelRestart);
			//ENTITIES
			Core.control.addEventListener(AxEntityEvent.SET_LEVEL_FINISH, onLevelFinish);
			Core.control.addEventListener(AxEntityEvent.SET_CAMERA_FOCUS, onSetCameraFocus);
			//EFFECTS
			//Core.control.addEventListener(EmitterEvent.ADD_TO_WORLD, onAddEmitter);
			//Core.control.addEventListener(EmitterEvent.REMOVE_FROM_WORLD, onRemoveEmitter);
		}
		
		private function removeListeners():void
		{
			Core.control.removeEventListener(AxEntityEvent.ADD_TO_WORLD, onAddEntity);
			//PLAYER INIT POSITION
			Core.control.removeEventListener(AxEntityEvent.SET_PLAYER_AREA, onSetPlayerArea);
			Core.control.removeEventListener(AxEntityEvent.SET_PLAYER_START, onSetPlayerStart);
			Core.control.removeEventListener(AxEntityEvent.REMOVE_FROM_WORLD, onRemoveEntity);
			//Core.control.removeEventListener(AxEntityEvent.SET_PLAYER_CHECKPOINT, onSetPlayerCheckpoint);
			//GAME CORE
			Core.control.removeEventListener(AxLevelEvent.LOAD_FINISHED, onLevelLoaded);
			Core.control.removeEventListener(AxLevelEvent.END, onLevelEnd);
			Core.control.removeEventListener(AxLevelEvent.RESTART, onLevelRestart);
			//ENTITIES
			Core.control.removeEventListener(AxEntityEvent.SET_LEVEL_FINISH, onLevelFinish);
			Core.control.removeEventListener(AxEntityEvent.SET_CAMERA_FOCUS, onSetCameraFocus);
			//EFFECTS
			//Core.control.removeEventListener(EmitterEvent.ADD_TO_WORLD, onAddEmitter);
			//Core.control.removeEventListener(EmitterEvent.REMOVE_FROM_WORLD, onRemoveEmitter);
		}
		
		private function onLevelRestart(e:AxLevelEvent):void
		{
			
		}
		
		private function onLevelEnd(e:AxLevelEvent):void
		{
			
		}
		
		private function onSetCameraFocus(e:AxEntityEvent):void
		{
			Ax.camera.follow(e.entity);
		}
		
		private function onAddEntity(e:AxEntityEvent):void
		{
			addEntity(e.entity);
		}
		
		private function onPlayerEntityOverlap($player:AxDynamicEntity,$entity:AxDynamicEntity):void
		{
			$entity.playerTouched($player);
			/*
			if ($player.isInteracting)
			{
				$entity.trigger($player);
			}*/
		}
		
		private function onPlayerVolumeOverlap($player:AxDynamicEntity,$volume:AxVolume):void
		{
			//trace("foo");
			$volume.onPlayerOverlap($player);
		}
		
		/*
		private function onRemoveEmitter(e:EmitterEvent):void
		{
			//var emitter:AxParticleCloud = e.emmitter;
			//m_group_effects.remove(emitter, true)
			//emitter.destroy();
		}
		
		private function onAddEmitter(e:EmitterEvent):void
		{
			//var emitter:AxParticleCloud = e.emmitter;
			//addEmitter(emitter);
			//emitter.
			//e.emmitter.start(emitter.explode, emitter.lifespan, emitter.frequency);
		}
		
		private function addEffect($effect:FlxSprite):void
		{
			//if (m_group_effects.members.length == m_group_effects.maxSize)
			//{
			//	m_group_effects.remove(m_group_effects.getFirstDead(), true);
			//}
			//m_group_effects.add($effect);
		}
		
		private function addEmitter($emitter:FlxEmitter):void
		{
			//m_group_effects.add($emitter);
		}*/
		
		private function onLevelLoaded ($e:AxLevelEvent = null):void
		{
			if (!m_level.area)
			{
				Core.control.levelEnd(false);
				trace("no more areas!");
				return;
			}
			trace("-------------------------------------------");
			trace("level loaded " + m_level.toString());
			trace("-------------------------------------------");
			Ax.stage2D.focus = Ax.stage2D;
			m_isSwitchingAreas = false;
			initGroups();
			//setBGColour(m_level.background_colour);
			//Ax.camera.worldBounds.height = 0;
			addArea(m_level.area);
			//addPlayer(m_player, 0, 0);
			//swapPlayerToFront();
			//Core.control.dispatchEvent(new UIEvent (UIEvent.UPDATE_AREA, m_level));
		}
		
		public function getClimbSpot (X:int, Y:int, $count:int = 0):Point
		{
			var count:int = $count;
			var tile_x:int = int(X / 16);
			var tile_y:int = int(Y / 16);
			//trace("check tile " + tile_x, tile_y + " for grab point");
			while (count > 0)
			{
				tile_y = int(Y / 16) - count;
				if (!m_collision_map.tileHasCollision(tile_x, tile_y)) {
					count--;
					continue
				}
				if (m_collision_map.tileHasCollision(tile_x, tile_y -1 )) {
					count--;
					continue
				}
				if (m_collision_map.tileHasCollision(tile_x, tile_y -2 )) {
					count--;
					continue
				}
				if (m_collision_map.tileHasCollision(tile_x, tile_y -3 )) {
					count--;
					continue
				}
				return new Point (tile_x * 16, (tile_y - 1) * 16);
				count--;
			}
			return null;
		}
		
		protected function addArea($area:AxLevelArea):void
		{
			if (!_player) {
				var cls:Class = Core.registry.getClass("PLAYER");
				if (!cls) cls = AxPlayer;
				_player = new cls();
			}
			deserializeTiles($area.xml.LAYERS.*)
			deserializeEntities($area.xml.OBJECTS.*)
		}
		
		private function swapPlayerToFront():void
		{
			m_group_entities.sort("depth");
		}
		
		public function deserializeTiles ($xml:XMLList):void
		{
			m_tilemaps = new Vector.<AxDynamicTilemap>();
			var isCollision:Boolean
			var isBehind:Boolean = true;
			var isFront:Boolean = false;
			var bounds_width:int = 0;
			var bounds_height:int = 0;
			for each (var item:XML in $xml)
			{
				
				var new_tiles:AxDynamicTilemap = new AxDynamicTilemap ();
				isCollision = (item.@collide == "true")
				isFront = (item.@isFront == "true")
				//new_tiles.scroll.x = item.@sf_x;
				//new_tiles.scroll.y = item.@sf_y;
				var graphics:* = Core.lib.getAsset(item.@tile_path)
				new_tiles.build(item.toString(), graphics, item.@tile_width, item.@tile_height, 1);
				m_tilemaps.push(new_tiles);
				if (isCollision)
				{
					m_collision_map = new_tiles;
					isBehind = true;
					//m_group_main.add(new_tiles);
					m_group_collision.add(m_collision_map);
					if (new_tiles.boundsWidth > bounds_width) bounds_width = new_tiles.boundsWidth;
					if (new_tiles.boundsHeight > bounds_height) bounds_height = new_tiles.boundsHeight;
				}
				if (isBehind)
				{
					m_group_bg.add(new_tiles);
				}
				if (isFront)
				{
					m_group_fg.add(new_tiles);
				}
				//trace("deserializing layer:- " + item.@depth + " collision: " + isCollision + " tp" + item.@tile_path);
				
				//TODO - re_write slopey tiles to make their handling internal.
				//new_tiles.setSlopesRight(Core.xml.game.TILE_DATA.*.(@key == item.@tile_path).RIGHT_SLOPES.toString());
				//new_tiles.setSlopesLeft(Core.xml.game.TILE_DATA.*.(@key == item.@tile_path).LEFT_SLOPES.toString());
				//new_tiles.updateSlopes();
				
				//Ax.camera.worldBounds.width = bounds_width;
				//Ax.camera.worldBounds.height = bounds_height;
				
				//if (new_tiles.width > FlxG.worldBounds.width)
				//add(new_tiles);
				
			}
			if (!OBJECT_COLLISION) OBJECT_COLLISION = new AxGrid (bounds_width, bounds_height);
			//Ax.camera.bounds.width = Ax.camera.worldBounds.width;
			//Ax.camera.bounds.height = Ax.camera.worldBounds.height;
		}
		
		public function deserializeEntities ($xml:XMLList):void
		{

			var ent_start:AxPoint = new AxPoint ();
			var ent_class_string:String;
			var ent_class_def:*;
			var ent_class:Class;
			var ent_image_path:String;
			var ent_inst:AxGameEntity;
			deserialize: for each (var item:XML in $xml)
			{
				ent_class_string = item.CLASS.@name;
				if (!Core.registry.hasClass(ent_class_string))
				{
					trace ("WARNING: class '" + ent_class_string + "' hasn't been registered :( :( :(")
					continue;
				}
				ent_class_def = Core.registry.getClass(ent_class_string);
				if (ent_class_def == null)
				{
					trace (("No matching import or class name for " + ent_class_string))
					continue;
				}
				ent_image_path = m_level.getAssetPath(item.name());
				item.@asset_path = ent_image_path;

				ent_inst = new (ent_class_def as Class);
				ent_inst.deserialize(item);

				addEntity(ent_inst);
			}
		}
		
		public function addEntity (e:AxGameEntity, $x_pos:int = 0, $y_pos:int = 0):void
		{
			var target_group:AxGroup;
			target_group = m_group_entities;
			if ($x_pos != 0 || $y_pos != 0)
			{
				e.setPosition($x_pos,$y_pos)
			}
			if (e.isForceBack) {
				target_group = m_group_bg;
			}
			else if (e.isForceFront)
			{
				target_group = m_group_fg;
			}
			if (e is AxVolume) {
				target_group = m_group_volumes;
			}
			if (e is AxProjectile) {
				target_group = m_group_projectiles;
			}
			if (e is AxPickup) {
				target_group = m_group_pickups;
			}
			target_group.add(e);
			m_entitys.push(e);
			e.init(this);
			//if (e.isCollision) m_group_collision.add(e); //e.isCollision &&
		}
		
		private function addPlayer (p:AxDynamicEntity, $x_pos:int = 0, $y_pos:int = 0):void
		{
			if (m_isPlayerAdded)
			{
				trace("player already added!");
				return;
			}
			m_isPlayerAdded = true;
			p.reset($x_pos, $y_pos);
			p.facing = AxEntity.RIGHT;
			addEntity(p, $x_pos, $y_pos)
			trace("adding player @ " + $x_pos, $y_pos);
			Core.control.dispatchEvent(new AxEntityEvent(AxEntityEvent.SPAWNED_PLAYER,p))
			if (Ax.camera.target is AxDynamicEntity || !Ax.camera.target) {
				Ax.camera.follow(p);
			}
			if (p) {
				_player = p;
			}
			m_last_player_facing = uint.MAX_VALUE;
		}
		/*
		public function checkForPlayerInRect(los_rect:FlxRect):Player
		{
			if (!m_player) return null;
			if (m_player.center_x > los_rect.left && m_player.center_x < los_rect.right
				&& m_player.center_y < los_rect.bottom && m_player.center_y > los_rect.top)
				{
					return m_player;
				}
			return null;
		}
		
		public function checkForEntityInRect(los_rect:FlxRect, $class_list:Array = null):Vector.<Entity>
		{
			//TODO - should tie this in with Flixel and use .overlap with collision box.
			if (!m_entitys) return null;
			var results:Vector.<Entity> = new Vector.<Entity>()
			for each (var entity:Entity in m_entitys)
			{
				if (entity.center_x > los_rect.left && entity.center_x < los_rect.right
				&& entity.center_y < los_rect.bottom && entity.center_y > los_rect.top)
				{
					if (!entity.exists) continue;
					if ($class_list)
					for each (var class_type:Class in $class_list)
					{
						if (entity is class_type) results.push(entity);
					}
					else
					{
						results.push(entity);
					}
					
				}
			}
			if (results.length == 0) return null;
			return results;
		}*/
		
		public function loadLevel($level:AxLevel):void
		{
			m_level = $level;
		}
		
		protected function initGroups ():void
		{
			var len:int = m_groups.length -1;
			for (var i:int = 0; i <= len; i++)
			{
				var $group:AxGroup = m_groups[i];
				$group.exists = true;
				if ($group != m_group_collision) add($group);
			}
			
		}
		
		protected function clearGroups ():void
		{
			for each(var $group:AxGroup in m_groups)
			{
				$group.clear();
				remove($group);
			}
			if (_player)
			{
				remove(_player);
			}
			m_entitys = new Vector.<AxGameEntity>();
			m_tilemaps = new Vector.<AxDynamicTilemap>();
			init();
		}
		
		private function onRemoveEntity(e:AxEntityEvent):void
		{
			removeEntity(e.entity);
		}
		
		public function removeEntity (e:AxGameEntity):void
		{
			m_group_entities.remove(e);
			if (e.isCollision) m_group_collision.remove(e);
		}
		
		
		
		/*
		public function addWeatherEffect ($weatherEffect:WeatherEffect):void
		{
			$weatherEffect.enable();
		}
		
		public function setBGColour ($colour:uint):void
		{
			m_bg_block.makeGraphic(FlxG.width, FlxG.height, $colour);
		}
		
		private function onSetPlayerCheckpoint (event:EntityEvent):void
		{
			var m:MarkerCheckpoint = MarkerCheckpoint(event.entity);
			if (m_last_checkpoint)
			{
				m_last_checkpoint.switchOff();
			}
			m_last_checkpoint = m;
			m_last_checkpoint_guid = m_last_checkpoint.guid;
			m_last_link_id = -2;
			m_last_checkpoint.switchOn();
		}
		*/
		private function onSetPlayerArea(e:AxEntityEvent):void
		{
		/*
			var m:MarkerTeleport = MarkerTeleport(e.entity);
			trace("caught player set area from" + m);
			m_last_checkpoint = null;
			m_last_checkpoint_guid = null;
			switchArea(m.target , m.linked_id);
			*/
		}
		
		
		private function onSetPlayerStart(event:AxEntityEvent):void
		{
			var marker:AxMarker = AxMarker(event.entity);
			if (m_last_checkpoint_guid && event.entity.guid && event.entity.guid == m_last_checkpoint_guid)
			{
				marker.p_linked_id = -2
				marker.setJustUsed(_player);
			}
			if (marker.linked_id == m_last_link_id)
			{
				m_last_link_id = marker.linked_id;
				//if (!(marker is MarkerCheckpoint)) marker.setJustUsed(m_player);
				addPlayer(_player, marker.x,marker.y - _player.height);
			}
			
		}
		
		
		private function onLevelFinish(e:AxEntityEvent):void
		{
			Ax.camera.fade(0xFF000000, 1.0, Core.control.levelEnd);
		}
		
		override public function destroy():void
		{
			removeListeners();
			m_level.destroy();
			_player.destroy();
		}
		
		
		
		public function switchArea($key:String, $linked_id:int):void
		{
			m_isSwitchingAreas = true;
			m_isPlayerAdded = false;
			clearGroups();
			m_last_link_id = $linked_id;
			m_level.setArea($key);
			addArea(m_level.area);
			initGroups();
		}
		
		public function checkForPlayerInRect($rect:AxRect):Boolean
		{
			if ($rect.overlaps(_player)) {
				return true;
			}
			return false;
		}
		
		protected function clampPointToPlaySpace($point:AxPoint):AxPoint {
			if ($point.x > Ax.camera.bounds.width) {
				$point.x = Ax.camera.bounds.width
			}
			if ($point.x < 0) {
				$point.x = 0
			}
			if ($point.y > Ax.camera.bounds.height) {
				$point.y=Ax.camera.bounds.height
			}
			if ($point.y < 0) {
				$point.y = 0;
			}
			return $point;
		}
		
		public function castRay($start:AxPoint, $end:AxPoint, $getEntities:int):AxRayResult {
			clampPointToPlaySpace($start);
			clampPointToPlaySpace($end);
			var points:Vector.<AxPoint> = efla($start.x, $start.y, $end.x, $end.y);
			var len:int = points.length - 1;
			var col:AxEntity = new AxEntity (0, 0);
			col.width = 3;
			col.height = 3;
			col.solid = true;
			var overlaps:Boolean;
			var result:AxRayResult = new AxRayResult();
			result.point.x = points[points.length - 1].x;
			result.point.y =  points[points.length - 1].y;
			result.path = new Vector.<AxPoint>();
			result.blocked = false;
			for (var i:int = 0; i < len; i++) {
				var point:AxPoint = points[i];
				var tileX:int = int(point.x / 32);
				var tileY:int = int(point.y / 32);
				
				//col.x = point.x;
				//col.y = point.y;
				overlaps = m_collision_map.getTileAtPixelCoordinates(point.x, point.y) != null;
				if (overlaps) {
					result.point.x = point.x; 
					result.point.y =  point.y;
					result.blocked = true;
					return result;
				} 
				if (result.path.length == 0) {
					result.path.push(new AxPoint(tileX, tileY));
				} else {
					var lastTile:AxPoint = result.path[result.path.length -1]
					if (tileX != lastTile.x || tileY != lastTile.y && !m_collision_map.tileHasCollision(tileX,tileY)) {
						result.path.push(new AxPoint(tileX, tileY));
					}
				}
			}
			return result;
		}
		
		private function onCheckRay($souce:AxEntity, $target:AxEntity ):Boolean
		{
			return false;
			//trace($target);
		}
		
		/**
		 * Extreamly fast line algorithm.
		 * @param	x
		 * @param	y
		 * @param	x2
		 * @param	y2
		 * @return
		 */
		private function efla(x:int, y:int, x2:int, y2:int):Vector.<AxPoint>
		{
		  var shortLen:int = y2-y;
		  var longLen:int = x2 - x;
		  var vec:Vector.<AxPoint> = new Vector.<AxPoint>;

		  if((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31))
		  {
		  shortLen ^= longLen;
		  longLen ^= shortLen;
		  shortLen ^= longLen;

		  var yLonger:Boolean = true;
		  }
		  else
		 {
		  yLonger = false;
		 }

		  var inc:int = longLen < 0 ? -1 : 1;

		  var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;

		  if (yLonger)
		  {
			for (var i:int = 0; i != longLen; i += inc)
			{
			  //this.bit.setPixel(x + i * multDiff, y + i, color);
			  vec.push(new AxPoint(int(x + i * multDiff), y + i));
			}
		  }
		  else
		  {
			for (i = 0; i != longLen; i += inc)
			{
			  //this.bit.setPixel(x + i, y + i * multDiff, color);
			  vec.push(new AxPoint(int(x + i), y + i  * multDiff));
			}
		  }
		  //vec.reverse();
		  return vec;
		}

		public function getEntitiesInRect($rect:AxRect, $classTypes:Array = null):Vector.<AxEntity>
		{
			if (!m_entitys) return null;
			var results:Vector.<AxEntity> = new Vector.<AxEntity>()
			for each (var entity:AxEntity in m_entitys)
			{
				var classType:Class
				if ($rect && entity.center.x > $rect.left && entity.center.x < $rect.right
				&& entity.center.y < $rect.bottom && entity.center.y > $rect.top)
				{
					if (!entity.exists) continue;
					if ($classTypes){
						for each (classType in $classTypes)
						{
							if (entity is classType) results.push(entity);
						}
					} else {
						results.push(entity);
					}
					
				} else {
					if ($classTypes){
						for each (classType in $classTypes)
						{
							if (entity is classType) results.push(entity);
						}
					}
				}
			}
			if (results.length == 0) return null;
			return results;
		}
		
		public function getEntitiesInTile($tilePoint:AxPoint, $classTypes:Array):Vector.<AxEntity> 
		{
			if (!m_entitys) return null;
			var results:Vector.<AxEntity> = new Vector.<AxEntity>()
			for each (var entity:AxEntity in m_entitys)
			{
				var tx = $tilePoint.x * 32;
				var ty = $tilePoint.y * 32;
				var classType:Class
				if ($tilePoint && entity.center.x > tx && entity.center.x < tx + 32
				&& entity.center.y < ty + 32 && entity.center.y > ty)
				{
					if (!entity.exists) continue;
					if ($classTypes){
						for each (classType in $classTypes)
						{
							if (entity is classType) results.push(entity);
						}
					} else {
						results.push(entity);
					}
				} 
			}
			if (results.length == 0) return null;
			return results;
		}
		
		public function get collision_map():AxDynamicTilemap { return m_collision_map; }
		
		public function get player():AxDynamicEntity { return _player; }
		
		public function get level():AxLevel { return m_level; }
		
		public function get gravity():int { return m_gravity; }
		
		public function get isSwitchingAreas():Boolean { return m_isSwitchingAreas; }
		
		public function get eventBus():EventDispatcher { return m_eventBus; }
		
	}

}