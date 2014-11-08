package axengine.entities 
{
	import axengine.entities.pickups.AxPickup;
	import axengine.world.AxWorld;
	import org.axgl.AxPoint;

	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxPlayer extends AxDynamicEntity 
	{		
		
		protected var _isInteracting:Boolean;
		
		public function AxPlayer() 
		{
			super(0, 0);
		}
		
		override public function init($world:AxWorld):void 
		{
			
			//_libraryAssetName = "PLAYER";
			//loadNativeGraphics();
			super.init($world);
		}
		
		public function collectPickup($pickup:AxPickup):void 
		{
			$pickup.onCollected(this);
			
		}
		
		public function get isInteracting():Boolean 
		{
			return _isInteracting;
		}
	}

}