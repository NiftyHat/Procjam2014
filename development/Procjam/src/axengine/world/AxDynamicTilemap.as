package axengine.world 
{
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxDynamicTilemap extends AxTilemap 
	{
		
		public function AxDynamicTilemap(x:Number=0, y:Number=0) 
		{
			super(x, y);
			
		}
		
		public function tileHasCollision (X:int, Y:int):Boolean
		{
			if (X < 0) X = 0;
			if (Y < 0) Y = 0;
			var tID:uint = getTileIndexAt(X,Y)
			if (tID >= solidIndex) return true;
			else return false;
		}
		
		public function get boundsWidth():int {
			return cols * tileWidth;
		}
		
		public function get boundsHeight():int {
			return rows * tileHeight;
		}
		
	}

}