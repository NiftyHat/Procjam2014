package game.entities 
{
	import axengine.entities.AxDynamicEntity;
	import axengine.entities.AxGameEntity;
	import axengine.world.AxWorld;
	import game.PJEntity;
	import org.axgl.render.AxColor;
	import org.axgl.text.AxFont;
	import org.axgl.text.AxText;
	
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
			health = $amount;
			if (health < 0) {
				destroy();
			}
			show(int((totalFrames - 1) / 100 * health))
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			setGold(50);
			loadNativeGraphics();
			addAnimation("idle", [0]);
			animate("idle");
			show(int((totalFrames - 1) / 100 * health))
		}
		
		override public function visualizeDamage($value:int):void 
		{
			//super.visualizeDamage($value);
			var textCounter:AxText = new AxText (center.x - 10, y- 32, AxFont.fromFont("alagard", false, 16),"-" + $value.toString(), 30, "center");
			textCounter.velocity.y -= 230;
			textCounter.color = new AxColor (1,1,0,1);
			//textCounter.velocity.x = (Math.random() * 200)  - 100;
			textCounter.acceleration.y = 150;
			textCounter.addTimer(1.0, textCounter.destroy)
			_world.add(textCounter)
		}
		
		override public function hurt($damage:int = 0, $source:AxGameEntity = null):void 
		{
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