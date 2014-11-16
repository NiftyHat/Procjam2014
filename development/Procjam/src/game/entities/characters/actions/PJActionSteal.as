package game.entities.characters.actions 
{
	import com.greensock.TweenLite;
	import game.entities.PJCoinPile;
	import game.PJEntity;
	import game.world.PJWorld;
	import org.axgl.util.AxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class PJActionSteal extends PJAction
	{
		
		private var _targetTreasure:PJCoinPile;
		private var _completeDelay:int = 0;
		private var _isTransitionAnim:Boolean = false;
		private var _isStanding:Boolean = false;
		private var _isStealReady:Boolean = true;
		
		private static const CROUCHING:String = "crouching";
		private static const STEALING:String = "stealing";
		private static const STANDING:String = "standing";
		private static const STORING:String = "storing";
		private var _state:String;
		
		public function PJActionSteal() 
		{
			_state = CROUCHING;
		}
		
		override public function setEntity($entity:PJEntity):void
		{
			super.setEntity($entity);
			_entity.addAnimationCallback("steal_crouch", onStealCrouch);
			_entity.addAnimationCallback("steal_stand", onStealStand);
		}
		
		private function onStealStand():void 
		{
			_state = STORING;
		}
		
		private function onStealCrouch():void 
		{
			_state = STEALING;
		}
		
		public function setTarget($treasure:PJCoinPile) {
			_targetTreasure = $treasure;
		}
		
		override public function start($entity:PJEntity = null):void 
		{
			super.start($entity);
			_entity.animate("steal_start");
			_isTransitionAnim = true;
		}
		
		override public function update():void 
		{
			super.update();
			switch (_state) {
				case CROUCHING:
					_entity.animate("steal_crouch");
				break;
				case STEALING:
					if (_isStealReady) {
						_isStealReady = false;
						if (_targetTreasure && _targetTreasure.exists) {
							_targetTreasure.hurt(5);
							_completeDelay += 7;
							TweenLite.delayedCall(0.3, function():void {_isStealReady = true});
						} else {
							_state = STANDING;
							break;
						}	
					}
					_entity.animate("steal");
				break;
				case STANDING:
					_entity.animate("steal_stand");
				break;
				case STORING:
					if (_completeDelay > 0) {
						_entity.animate("steal_store");
						_completeDelay--;
					} else {
						end();
					}
				break;
			}
			/*
			if (!_targetTreasure) {
				
			}*/
		}
		
		override public function end():void 
		{
			super.end();
		}
		
	}

}