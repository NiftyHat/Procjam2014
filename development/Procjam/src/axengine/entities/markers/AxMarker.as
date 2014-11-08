package axengine.entities.markers 
{
	import axengine.entities.AxDynamicEntity;
	import axengine.entities.AxPlayer;

	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxMarker extends AxDynamicEntity
	{
		
		public var p_linked_id:int = -3;
	

		public function AxMarker(SimpleGraphic:Class = null) 
		{
			if (SimpleGraphic == null) 
			{
				//SimpleGraphic == Core.lib.getAsset("graphics/editor_stuff/mt_template.png");
				SimpleGraphic = Core.lib.int.img_mt_template;
			}
			super(0, 0, SimpleGraphic);
			m_hasTouch = true;
			_isCollision = false;
			//move = true;
			//m_isAxisLocked = true;
			//visible = Core.isDevMode;
			name = "Marker";
		}
		
		public function setJustUsed ($player:AxDynamicEntity):void
		{
			_player = $player;
			_timerAllowTouch.start();
			m_isTouched = true;
		}
		
		override public function toString():String 
		{
			return super.toString() + " x: " + x + " y:" + y;
		}
		
		public function get linked_id():int { return p_linked_id; }

	}

}