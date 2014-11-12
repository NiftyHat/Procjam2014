package keith
{
	import de.polygonal.ds.HashMap
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class Shadowcaster 
	{
		
		// PORTED PYTHON CODE STARTS HERE! =======================================================>
		
		// Multipliers for transforming coordinates to other octants:
		public static const mult:Array = [
//Octants = 	NNE	NEE	SEE	SSE	SSW	SWW	NWW	NNW	
			[	-1, 0,	0, -1,  1,  0, 	0, 	1],
			[	0, 	-1,	-1, 0,  0,  1, 	1, 	0],
			[ 	0,  1,	-1, 0,  0, 	-1, 1, 	0],
			[ 	1,  0,	0,	-1, -1, 0, 	0, 	1]
		
		];
		
		public static const CONE_NORTH:int = 129;
		public static const CONE_EAST:int = 6;
		public static const CONE_SOUTH:int = 24;
		public static const CONE_WEST:int = 96;
		public static const CONE_NORTH_EAST:int = 3;
		public static const CONE_SOUTH_EAST:int = 12;
		public static const CONE_SOUTH_WEST:int = 48;
		public static const CONE_NORTH_WEST:int = 192;
		
		public static const HALF_NORTH:int = 195;
		public static const HALF_EAST:int = 15;
		public static const HALF_SOUTH:int = 60;
		public static const HALF_WEST:int = 140;
		public static const HALF_NORTH_EAST:int = 135;
		public static const HALF_SOUTH_EAST:int = 30;
		public static const HALF_SOUTH_WEST:int = 120;
		public static const HALF_NORTH_WEST:int = 225;
		
		public static const PERIPHERAL_NORTH:int = 255 - CONE_SOUTH
		public static const PERIPHERAL_EAST:int = 255 - CONE_WEST
		public static const PERIPHERAL_SOUTH:int = 255 - CONE_NORTH
		public static const PERIPHERAL_WEST:int = 255 - CONE_EAST
		public static const PERIPHERAL_NORTH_EAST:int = 255 - CONE_EAST
		public static const PERIPHERAL_SOUTH_EAST:int = 255 - CONE_EAST
		public static const PERIPHERAL_SOUTH_WEST:int = 255 - CONE_EAST
		public static const PERIPHERAL_NORTH_WEST:int = 255 - CONE_SOUTH_EAST
		
		public static const FULL_CIRLCE:int = 255
		
		protected static var light:Array = [];
		
		protected static function blocked(tileMap:LightmapCollisionArray, x:int, y:int):Boolean{
			return x < 0 || y < 0 || x > tileMap.cols || y > tileMap.rows || tileMap.getCollision(x,y);
		}
		
		
		protected static function cast_light(vec:HashMap, tileMap:LightmapCollisionArray, cx:Number, cy:Number, row:Number, start:Number, end:Number, radius:Number, xx:Number, xy:Number, yx:Number, yy:Number, id:Number, hardFalloffForLight:Boolean):HashMap{
		
			// "Recursive lightcasting function"
			
			var new_start:Number;
			var j:int = row;
			if(start < end) return vec;

			var radius_squared:Number = radius * radius;

			while(true) {
				
				var dx:Number = -j - 1;
				var dy:Number = -j;
				var block:Boolean = false;
				while(dx <= 0){
					dx++;
					// Translate the dx, dy coordinates into map coordinates:

					var X:int = cx + dx * xx + dy * xy;
					var Y:int = cy + dx * yx + dy * yy;

					// l_slope and r_slope store the slopes of the left and right
					// extremities of the square we're considering:

					var l_slope:Number = (dx - 0.5) / (dy + 0.5);
					var r_slope:Number = (dx + 0.5) / (dy - 0.5);

					if(start < r_slope) continue;

					else if(end > l_slope) break;

					else{
					// Our light beam is touching this square; light it:
						if ((dx * dx + dy * dy < radius_squared) || radius == -1) {
							var n:String = X + "," + Y;
							var intsity:Number = tileMap.getLightStrength(cx, cy, X, Y)
							if (hardFalloffForLight) {
								intsity = (radius!= -1 ?  1-((dx * dx + dy * dy) / radius_squared) : 1)
							} else
							intsity = intsity * (radius!= -1 ?  1-((dx * dx + dy * dy) / radius_squared) : 1)
							if (intsity < 0) intsity = 0;
							if (vec.get(n) == null || vec.get(n).intensity <  intsity ) vec.set(n, new ShadowPoint(X, Y, intsity))
						} else continue
						if(block){
							// we're scanning a row of blocked squares:
							if(blocked(tileMap, X, Y)){
								new_start = r_slope;
								continue;
							} else{
								block = false;
								start = new_start;
							}
						} else {
							if(blocked(tileMap, X, Y) && (j < radius || radius == -1)){
								// This is a blocking square, start a child scan:
								block = true;
								cast_light(vec, tileMap, cx, cy, j+1, start, l_slope, radius, xx, xy, yx, yy, id+1, hardFalloffForLight)
								new_start = r_slope;
							}
						}
					}
				}
				// Row is scanned; do next row unless last square was blocked:
				if (block) break;
				j++;
				if (j >= radius && radius != -1) break;
			}
			
			return vec;
		}
		
		public static function castShadows(tileMap:LightmapCollisionArray, x:Number, y:Number, radius:int, sightMap:int = 255, preexistingHash:HashMap = null, hardFalloffForLight:Boolean = false):HashMap{
			// "Calculate lit squares from the given location and radius"
			var m:HashMap = preexistingHash == null ? new HashMap() : preexistingHash;
			
			m.set(x + "," + y, new ShadowPoint(x, y, 1));
			
			for (var i:int = 0; i < 8; i++) {
				if(Math.pow(2, i) & (sightMap)) cast_light(m, tileMap, x, y, 1, 1.0, 0.0, radius, mult[0][i], mult[1][i], mult[2][i], mult[3][i], 0, hardFalloffForLight);
			}
			
			return m;
		}		
		
		
	}
	
	

}