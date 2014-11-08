package axengine.events 
{
	import axengine.entities.AxGameEntity;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxEntityEvent extends Event 
	{
		//TODO = restructure the SPAWNED_PLAYER code.
		static public const SPAWNED_PLAYER:String = "spawnedPlayer";
		static public const REMOVE_FROM_WORLD:String = "removeFromWorld";
		static public const ADD_TO_WORLD:String = "addToWorld";
		
		static public const SET_LEVEL_FINISH:String = "setLevelFinish";
		static public const SET_PLAYER_AREA:String = "setPlayerArea";
		static public const SET_PLAYER_CHECKPOINT:String = "setPlayerCheckpoint";
		static public const SET_PLAYER_START:String = "setPlayerStart";
		static public const SET_CAMERA_FOCUS:String = "setCameraFocus";
		static public const MOVE_TO_RANDOM_AREA:String = "moveToRandomArea";
		
		private var _entity:AxGameEntity
		
		public function AxEntityEvent($type:String,$self:AxGameEntity) 
		{ 
			_entity = $self
			super($type, false , false);
		} 
		
		public override function clone():Event 
		{ 
			return new AxEntityEvent(type, _entity);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AxEntityEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get entity():AxGameEntity { return _entity; }
		
	}
	
}