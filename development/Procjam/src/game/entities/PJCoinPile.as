package game.entities 
{
	import axengine.entities.AxDynamicEntity;
	import axengine.entities.AxGameEntity;
	import axengine.world.AxWorld;
	import game.PJEntity;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJCoinPile extends PJEntity 
	{
		
		public var isClaimed:Boolean = false;
		
		public function PJCoinPile(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			
			_libraryAssetName = "COIN_PILE";
			
		}
		
		public function setGold($amount:int):void {
			health = 10 + (Math.random() * 90);
			if (health < 0) {
				destroy();
			}
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			loadNativeGraphics();
			addAnimation("idle", [0]);
			animate("idle");
			show(int((totalFrames - 1) / 100 * health))
		}
		
		override public function hurt($damage:int = 0, $source:AxGameEntity = null):void 
		{
			if ($damage < health) {
				Core.control.score -= $damage;
			} else {
				Core.control.score -= health;
			}
			show(int((totalFrames - 1) / 100 * health))
			super.hurt($damage, $source);
		}
		
		override public function kill():void 
		{
			super.kill();
			destroy();
		}
		
	}

}