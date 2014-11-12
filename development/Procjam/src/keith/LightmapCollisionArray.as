package keith
{
	import de.polygonal.ds.HashMap;
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class LightmapCollisionArray 
	{
		private var hardCutOffVisibilityIndex:int;
		
		protected var mapData:Array = new Array();
		protected var _rows:uint = 0;
		protected var _cols:uint = 0
		
		protected var visMatrix:HashMap
		
		public function LightmapCollisionArray(hardCutOffVisibilityIndex:int = 1) 
		{
			this.hardCutOffVisibilityIndex = hardCutOffVisibilityIndex;
			visMatrix = new HashMap();
		}
		
		public function addVisibilityException(index:int, val:Number):void {
			visMatrix.set(index, val);
		}
		
		public function buildCollisions(inputStr:String, rows:uint, cols:uint):void {
			var valAtCel:int;
			var valInMat:Object;
			var dta:Array = inputStr.split("\n");
			var tdta:Array;
			
			_rows = rows;
			_cols = cols;
			
			for (var y:int = 0; y < rows; y++) {
				tdta = dta[y].split(","); ;
				
				mapData[y] = new Array();
				
				
				for (var x:int = 0; x < cols; x++) {
					
					valAtCel = tdta[x];
					valInMat = visMatrix.get(valAtCel)
					if (valInMat != null) mapData[y][x] = int(valInMat)
					else {
						mapData[y][x] = valAtCel >= hardCutOffVisibilityIndex ? 1 : 0;
						visMatrix.set(valAtCel, mapData[y][x]);
					}
				}
				
				
			}
			
		}
		
		public function getCollision(x:uint, y:uint):Boolean {
			if (x >= cols) return true
			if (y >= rows) return true;
			return mapData[y][x] == 1;
		}
		public function getLightStrength(x1:int, y1:int, x2:int, y2:int):Number {

			var light:Number = 1;
				
			var w:int = x2 - x1 ;
			var h:int = y2 - y1 ;
			var dx1:int = 0, dy1:int = 0, dx2:int = 0, dy2:int = 0 ;
			if (w<0) dx1 = -1 ; else if (w>0) dx1 = 1 ;
			if (h<0) dy1 = -1 ; else if (h>0) dy1 = 1 ;
			if (w<0) dx2 = -1 ; else if (w>0) dx2 = 1 ;
			var longest:int = Math.abs(w) ;
			var shortest:int = Math.abs(h) ;
			if (!(longest>shortest)) {
				longest = Math.abs(h) ;
				shortest = Math.abs(w) ;
				if (h<0) dy2 = -1 ; else if (h>0) dy2 = 1 ;
				dx2 = 0 ;            
			}
			var numerator:int = longest >> 1 ;
			for (var i:int=0;i<longest;i++) {
				light *= 1-mapData[y1][x1] ;
				numerator += shortest ;
				if (!(numerator<longest)) {
					numerator -= longest ;
					x1 += dx1 ;
					y1 += dy1 ;
				} else {
					x1 += dx2 ;
					y1 += dy2 ;
				}
				if (light < 0) return 0;
			}
			
			return light;

		}
		
		public function get rows():uint 
		{
			return _rows;
		}
		
		public function get cols():uint 
		{
			return _cols;
		}
		
	}

}