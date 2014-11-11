package keith
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class WangGenerator 
	{
		protected static var width:int;
		protected static var height:int;
		
		protected static var maze:Vector.<Vector.<int>>
		protected static var hedges:Vector.<Vector.<Boolean>>
		protected static var vedges:Vector.<Vector.<Boolean>>
		protected static var corners:Vector.<Vector.<Boolean>>
		
		protected static var convertedToAscii:Vector.<Vector.<String>>
		
		public function WangGenerator() 
		{
			
		}
		
		public static function buildMaze(perlinNoise:BitmapData, seed:int, threshold:int):Vector.<Vector.<int>> {
			var height:int = perlinNoise.height;
			var width:int = perlinNoise.width;
			
			threshold = (threshold << 16) | (threshold << 8) | (threshold)
			
			var j:int;
			var i:int;
			
			maze = new Vector.<Vector.<int>>(height);
			
			// Build a random array of on/off states in a 2D Array
			for (i = 0; i < height; i++) {
				maze[i] = new Vector.<int>(width)
				
				for (j = 0; j < width; j++) {
					maze[i][j] = perlinNoise.getPixel(j, i) >= threshold ? 1 : 0;
				}
			}
			
			// Build a list of horizontal and vertical edges of these cels. If either cel is ON, set the edge to ON
			hedges = new Vector.<Vector.<Boolean>>(height);
			vedges = new Vector.<Vector.<Boolean>>(height - 1);
			for (i = 0; i < height; i++) {
				hedges[i] = new Vector.<Boolean>();
				for (j = 0; j < width - 1; j++) {
					hedges[i][j] = maze[i][j] || maze[i][j + 1];
				}
			}
			for (i = 0; i < height-1; i++) {
				vedges[i] = new Vector.<Boolean>();
				for (j = 0; j < width; j++) {
					vedges[i][j] = maze[i][j] || maze[i + 1][j];
				}
			}
			
			// Build an array of corners of these cels. Set them to ON if the edges they are connected to are ALL ON
			corners = new Vector.<Vector.<Boolean>>(height-1)
			for (i = 0; i < height - 1; i++) {
				corners[i] = new Vector.<Boolean>()
				for (j = 0; j < width - 1; j++ ) {
					corners[i][j] = vedges[i][j] && vedges[i][j+1] && hedges[i][j] && hedges[i+1][j]
				}
			}
			
			// Build the bitcalculator for the tiles. Clockwise from the top, eight diections (1 - 128, 255 varients)
			var value:int;
			for (i = 0; i < height; i++) {
				var allowT:Boolean = i != 0;
				var allowB:Boolean = i != height-1;
				
				for (j = 0; j < width; j++) {
					var allowL:Boolean = j != 0;
					var allowR:Boolean = j != width - 1;
					
					value = 0;
					if (allowT)	value += 			vedges[i - 1][j] 	? 1  : 0;	//T
					if (allowR)	value += 			hedges[i][j] 		? 4  : 0;	//R
					if (allowB)	value += 			vedges[i][j] 		? 16 : 0;	//B
					if (allowL)	value +=		 	hedges[i][j - 1] 	? 64 : 0;	//L
					
					
					if (allowT && allowR) value +=	corners[i - 1][j]	? 2  : 0	//TR
					if (allowB && allowR) value += 	corners[i][j]		? 8  : 0	//BR
					if (allowB && allowL) value +=	corners[i][j - 1]	? 32 : 0	//BL
					if (allowT && allowL) value +=	corners[i -1][j - 1]? 128: 0	//TL
					
					maze[i][j] = value;
				}
			}
			
			return maze;
		}
		
		
	}

}