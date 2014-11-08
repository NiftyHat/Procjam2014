package axengine.entities.markers 
{
	import axengine.events.AxEntityEvent;
	import axengine.world.AxWorld;
	import base.components.Library;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxMarkerStart extends AxMarker
	{
		
		
		public function AxMarkerStart() 
		{
			super(Core.lib.int.img_mt_template);
			visible = false;
			p_linked_id = -1;
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			Core.control.dispatchEvent(new AxEntityEvent(AxEntityEvent.SET_PLAYER_START, this));
		}
		
		
	}

}