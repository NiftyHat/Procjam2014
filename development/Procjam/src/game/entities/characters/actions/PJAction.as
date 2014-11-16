package game.entities.characters.actions 
{
	import game.PJEntity;
	import game.world.PJWorld;
	import org.axgl.AxEntity;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJAction extends AxEntity
	{
		
		protected var _entity:PJEntity;
		protected var _world:PJWorld;
		
		public function PJAction() 
		{
			
		}
		
		public function setEntity($entity:PJEntity):void {
			_entity = $entity;
			_world = _entity.world;
		}
		
		public function start($entity:PJEntity = null):void {
			if (!_entity) {
				_entity = $entity;
			}
			if (_entity) {
				_entity.onStartAction(this);
			} else {
				trace("PJAction WARNING : Actions should be bound to entities");
			}
		}
		
		public function end():void {
			if (_entity) {
				_entity.onEndAction(this); 
				_entity.clearAction();
			}
			
		}
		
	}

}