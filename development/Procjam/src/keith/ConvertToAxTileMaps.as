package keith 
{
	import axengine.world.AxDynamicTilemap;
	import flash.display.BitmapData;
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class ConvertToAxTileMaps 
	{
		
		[Embed(source="../../../../design/tiles/tilesheet.png")]
		public static const WALLS_TILES:Class;
		[Embed(source="../../../../design/tiles/floorsheet.png")]
		public static const FLOOR_TILES:Class;
		
		public static const CORRIDOR:String = "░";
		public static const SOLIDWALL:String = "█";
		public static const OPENSPACE:String = " ";
		
		public static const TILE_BLANK:int = 0;
		public static const TILE_SOLID:int = 13;
		public static const TILE_BRICK_NORTH:int = 3;
		public static const TILE_BRICK_EAST:int = 4;
		public static const TILE_BRICK_SOUTH:int = 1;
		public static const TILE_BRICK_WEST:int = 2;
		public static const TILE_BRICK_NE:int = 5;
		public static const TILE_BRICK_NW:int = 6;
		public static const TILE_BRICK_SW:int = 7;
		public static const TILE_BRICK_SE:int = 8;
		public static const TILE_BRICK_SW_INVERT:int = 9;
		public static const TILE_BRICK_SE_INVERT:int = 10;
		public static const TILE_BRICK_NW_INVERT:int = 11;
		public static const TILE_BRICK_NE_INVERT:int = 12;
		/*
		public static const TILE_DIRT_NORTH:int = 16;
		public static const TILE_DIRT_EAST:int = 17;
		public static const TILE_DIRT_SOUTH:int = 14;
		public static const TILE_DIRT_WEST:int = 15;
		public static const TILE_DIRT_NE:int = 19;
		public static const TILE_DIRT_NW:int = 18;
		public static const TILE_DIRT_SW:int = 21;
		public static const TILE_DIRT_SE:int = 20;
		public static const TILE_DIRT_SW_INVERT:int = 22;
		public static const TILE_DIRT_SE_INVERT:int = 23;
		public static const TILE_DIRT_NW_INVERT:int = 24;
		public static const TILE_DIRT_NE_INVERT:int = 25;
		*/
		
		private var wallGeometry:AxDynamicTilemap;
		private var floorGeometry:AxTilemap;
		
		private var floorTiler:LimitedSetTiler
		
		public function ConvertToAxTileMaps() 
		{
			var GRN:int = 1;
			var RED:int = 2;
			var BLU:int = 3;
			var YLW:int = 4;
			
			floorTiler = new LimitedSetTiler();
			floorTiler.addTile(new WangTile(0, RED, YLW, GRN, BLU));
			floorTiler.addTile(new WangTile(1, GRN, YLW, RED, BLU));
			floorTiler.addTile(new WangTile(2, RED, BLU, RED, YLW));
			floorTiler.addTile(new WangTile(3, GRN, RED, GRN, YLW));
			floorTiler.addTile(new WangTile(4, RED, YLW, GRN, RED));
			floorTiler.addTile(new WangTile(5, GRN, BLU, RED, RED));
			floorTiler.addTile(new WangTile(6, RED, RED, GRN, BLU));
			floorTiler.addTile(new WangTile(7, RED, RED, RED, BLU));
			floorTiler.addTile(new WangTile(8, GRN, RED, RED, YLW));
			floorTiler.addTile(new WangTile(9, RED, BLU, GRN, YLW));
			floorTiler.addTile(new WangTile(10,GRN, BLU, GRN, RED));
			floorTiler.addTile(new WangTile(11,GRN, YLW, RED, RED));
		}
		
		public function getWallGeometry():AxDynamicTilemap {
			return wallGeometry;
		}
		public function getFloorGeometry():AxTilemap {
			return floorGeometry;
		}
		
		public function generate(width:int, height:int, seed:int):void {
			var i:int, j:int;
			
			// Generate the Geometry
			var noise:BitmapData = new BitmapData(width, height, false, 0);
			noise.noise(seed, 0, 255, 7, true)
			noise.setPixel(0, 0, 0xffffff);
			noise.setPixel(1, 1, 0);
			noise.setPixel(0, 1, 0);
			noise.setPixel(1, 1, 0);
			
			var _geometry = DungeonFromWangAlgorithm.convertFromWang(WangGenerator.buildMaze(noise, seed, 190), DungeonFromWangAlgorithm.matrix52, DungeonFromWangAlgorithm.matrix5);
			var geometryArray:Array = _geometry.split("\n");
			
			var wallsString:String = ""
			var floorsString:String = ""
			
			
			for (i = 0; i < geometryArray.length; i++) {
				geometryArray[i] = geometryArray[i].split("");
			}
			
			var floorMatrix:Vector.<Vector.<int>> = floorTiler.build(geometryArray[0].length, geometryArray.length);
			
			geometryArray[1][1] = CORRIDOR;
			geometryArray[1][2] = CORRIDOR;
			geometryArray[2][1] = CORRIDOR;
			
			var tileAtN:String
			var tileAtNE:String
			var tileAtE:String
			var tileAtSE:String
			var tileAtS:String
			var tileAtSW:String
			var tileAtW:String
			var tileAtNW:String
			
			var isTop:Boolean;
			var isBtm:Boolean;
			var isLft:Boolean
			var isRght:Boolean
			
			var addTile:int;
			var floortile:int
			
			for (i = 0; i < geometryArray.length; i++) {
				
				isTop = i == 0
				isBtm = i == geometryArray.length - 1;
				
				if (!isTop) {
					wallsString += "\n";
					floorsString += "\n";
				}
				
				for (j = 0; j < geometryArray[i].length; j++) {
					
					isLft = j == 0;
					isRght = j == geometryArray[i].length - 1;
					
					if (!isLft) {
						wallsString += ",";
						floorsString += ",";
					}
					tileAtN 	= isTop 			? SOLIDWALL : geometryArray[i - 1][j	];
					tileAtE 	= isRght			? SOLIDWALL : geometryArray[i	 ][j + 1];
					tileAtS 	= isBtm 			? SOLIDWALL : geometryArray[i + 1][j	];
					tileAtW 	= isLft 			? SOLIDWALL : geometryArray[i	 ][j - 1];
					
					tileAtNW	= isTop || isLft	? SOLIDWALL : geometryArray[i - 1][j - 1]
					tileAtNE	= isTop || isRght	? SOLIDWALL : geometryArray[i - 1][j + 1]
					tileAtSW	= isBtm	|| isLft	? SOLIDWALL : geometryArray[i + 1][j - 1]
					tileAtSE	= isBtm || isRght	? SOLIDWALL : geometryArray[i + 1][j + 1]
						
					if (geometryArray[i][j] == SOLIDWALL) {
						addTile = TILE_SOLID;
						floortile = 0;
						
						
						var processOfElimination:int = int(tileAtN == SOLIDWALL) + int(tileAtE == SOLIDWALL) + int(tileAtS == SOLIDWALL) + int(tileAtW == SOLIDWALL) 
													+  int(tileAtNW == SOLIDWALL) + int(tileAtNE == SOLIDWALL) + int(tileAtSE == SOLIDWALL) + int(tileAtSW == SOLIDWALL)
						
						switch(8-processOfElimination) {
							case 1:
								// Regular Corner - analyse the one corner
								if (tileAtNE != SOLIDWALL) {
									addTile = TILE_BRICK_SE;
									floortile = floorMatrix[i][j] +(geometryArray[i-1][j+1] == CORRIDOR ? 14 : 1);
									break;
								} else if (tileAtSE != SOLIDWALL) {
									addTile = TILE_BRICK_NE;
									floortile = floorMatrix[i][j] +(geometryArray[i+1][j+1] == CORRIDOR ? 14 : 1);
									break;
								} else if (tileAtSW != SOLIDWALL) {
									addTile = TILE_BRICK_NW
									floortile = floorMatrix[i][j] +(geometryArray[i+1][j-1] == CORRIDOR ? 14 : 1);
									break;
								} else if (tileAtNW != SOLIDWALL) {
									addTile = TILE_BRICK_SW
									floortile = floorMatrix[i][j] +(geometryArray[i-1][j-1] == CORRIDOR ? 14 : 1);
									break;
								}
								// Or single straight!
							case 5:
							case 4:
							case 3:
								// Inset Corner
								if (tileAtN != SOLIDWALL && tileAtNE != SOLIDWALL && tileAtE != SOLIDWALL) {
									addTile = TILE_BRICK_SE_INVERT;
									floortile = floorMatrix[i][j] +(geometryArray[i-1][j+1] == CORRIDOR ? 14 : 1);
								} else if (tileAtNW != SOLIDWALL && tileAtN != SOLIDWALL && tileAtW != SOLIDWALL) {
									addTile = TILE_BRICK_SW_INVERT;
									floortile = floorMatrix[i][j] +(geometryArray[i-1][j-1] == CORRIDOR ? 14 : 1);
								} else if (tileAtW != SOLIDWALL && tileAtSW != SOLIDWALL && tileAtS != SOLIDWALL) {
									addTile = TILE_BRICK_NE_INVERT;
									floortile = floorMatrix[i][j] +(geometryArray[i+1][j-1] == CORRIDOR ? 14 : 1);
								} else if (tileAtS != SOLIDWALL && tileAtSE != SOLIDWALL && tileAtE != SOLIDWALL) {
									addTile = TILE_BRICK_NW_INVERT;
									floortile = floorMatrix[i][j] +(geometryArray[i+1][j+1] == CORRIDOR ? 14 : 1);
								}
								if(addTile != TILE_SOLID) break
								// Or straight
							case 2:
								// Straight - analyse the middles
								if (tileAtN != SOLIDWALL) {
									addTile = TILE_BRICK_NORTH
									floortile = floorMatrix[i][j] +(geometryArray[i-1][j] == CORRIDOR ? 14 : 1);
								} else if (tileAtE != SOLIDWALL) {
									addTile = TILE_BRICK_EAST;
									floortile = floorMatrix[i][j] +(geometryArray[i][j+1] == CORRIDOR ? 14 : 1);
								} else if (tileAtS != SOLIDWALL) {
									addTile = TILE_BRICK_SOUTH
									floortile = floorMatrix[i][j] +(geometryArray[i+1][j] == CORRIDOR ? 14 : 1);
								} else if (tileAtW != SOLIDWALL) {
									addTile = TILE_BRICK_WEST;
									floortile = floorMatrix[i][j] +(geometryArray[i][j-1] == CORRIDOR ? 14 : 1);
								}
								break;
							
						}
						floorsString += floortile;
					} else {
						addTile = TILE_BLANK;
						floorsString += floorMatrix[i][j] +(geometryArray[i][j] == CORRIDOR && !(tileAtN == OPENSPACE || tileAtE == OPENSPACE || tileAtW == OPENSPACE || tileAtS == OPENSPACE ) ? 14 : 1);
					}
					
					
					wallsString += addTile;
					
				}
			}
			
			
			wallGeometry = new AxDynamicTilemap(0, 0);
			wallGeometry.build(wallsString, WALLS_TILES, 32, 32, 1);
			
			floorGeometry = new AxTilemap(0, 0);
			floorGeometry.build(floorsString, FLOOR_TILES, 32, 32, 99);
			
		}
		
	}

}