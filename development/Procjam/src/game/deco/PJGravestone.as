package game.deco 
{
	import axengine.world.AxWorld;
	import game.PJEntity;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJGravestone extends PJEntity 
	{
		
		public function PJGravestone(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			_libraryAssetName = "GRAVE";
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			loadNativeGraphics(false);
		}
		
	}

}