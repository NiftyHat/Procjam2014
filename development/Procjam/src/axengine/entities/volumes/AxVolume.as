package axengine.entities.volumes 
{
	import axengine.entities.AxDynamicEntity;
	import axengine.entities.AxGameEntity;
	import axengine.entities.AxPlayer;
	import axengine.world.AxWorld;
	import org.axgl.AxEntity;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxVolume extends AxDynamicEntity 
	{
		protected var DEBUG_COLOUR:int = 0x66660080
		
		public function AxVolume() 
		{
			super();
			solid = false;
			stationary = true;
			//_isAxisLocked = true;
			//_isCollision = false;
			//visible = Core.isDevMode;
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			drawBlockColour();
		}
		
		public function drawBlockColour ():void
		{
			var colour:uint = DEBUG_COLOUR;
			create(width, height, colour);
		}
		
		public function onEntityOverlap($enitity:AxEntity):void 
		{
			
		}
		
		public function onPlayerOverlap($player:AxDynamicEntity):void 
		{
			
		}
		
	}

}