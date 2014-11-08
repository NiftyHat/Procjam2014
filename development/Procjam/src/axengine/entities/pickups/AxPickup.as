package axengine.entities.pickups 
{
	import axengine.entities.AxDynamicEntity;
	import axengine.entities.AxPlayer;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxPickup extends AxDynamicEntity 
	{
		
		protected var _isPickupOnTouch:Boolean;
		protected var _isDestroyOnPickup:Boolean;
		
		protected var _isStackable:Boolean;
		protected var _value:int = 1;
		protected var _usedSlots:int = 1;
		
		public function AxPickup(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			_isCollision = false;
			solid = true;
			_isPickupOnTouch = true;
			_isDestroyOnPickup = true;
		}
		
		public function onPlayerOverlap($player:AxDynamicEntity):void {
			if (_isPickupOnTouch) {
				//$player.collectPickup(this);
			}
		}
		
		public function onCollected($entity:AxDynamicEntity):void {
			if (_isDestroyOnPickup) {
				destroy();
			}
		}
		
		public function get isStackable():Boolean 
		{
			return _isStackable;
		}
		
		public function get value():int 
		{
			return _value;
		}
		
		public function set value(value:int):void 
		{
			_value = value;
		}
		
		public function get usedSlots():int 
		{
			return _usedSlots;
		}
		
	}

}