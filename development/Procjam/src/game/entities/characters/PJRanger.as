package game.entities.characters 
{
	import axengine.world.AxWorld;
	import game.entities.PJCharacter;
	import game.PJEntity;
	import org.axgl.AxEntity;
	/**
	 * ...
	 * @author ...
	 */
	public class PJRanger extends PJCharacter
	{
		private var _isOverwatch:Boolean;
		
		protected var _followTarget:PJEntity;
		
		public function PJRanger() 
		{
			_mMoveSpeed = 0.4;
			_libraryAssetName = "CHAR_RANGER";
			_isDebugPathfinding = true;
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
			
			if (!_followTarget) {
				var possibleTargets:Vector.<AxEntity> = _world.getEntitiesInRect(null, [PJThief]);
				for each (var item:PJThief in possibleTargets) {
					if (item.riskLevel >= 0) {
						item.riskLevel--;
						follow(item);
					}
					
				}
			} else {
				if (!_bIsMoving) {
					var dx: int = Math.abs(_followTarget.tileX - this.tileX);
					var dy: int =  Math.abs(_followTarget.tileY - this.tileY);
					if (dx > 1 || dy > 1) {
						pathToEntity(_followTarget);
					} else {
						
					}
					
				}
			}
			castVision();
		}
		
		override protected function castVision():void 
		{
			if (!_isOverwatch) {
				super.castVision();
			} else {
				
			}
			
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