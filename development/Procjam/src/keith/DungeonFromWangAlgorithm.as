package keith
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class DungeonFromWangAlgorithm 
	{
		
		public static const CORRIDOR:String = "░";
		public static const SOLIDWALL:String = "█";
		public static const OPENSPACE:String = " ";
		
		public static const matrix5:Array = [[128,	128,	1,		2,		2],
											 [128,	128,	1,		2,		2],
											 [64,	64,		85,		4,		4],
											 [32,	32,		16,		8,		8],
											 [32,	32,		16,		8,		8]]
		
		public static const matrix52:Array =[[128,	129,	1,		3,		2],
											 [192,	85,		85,		85,		6],
											 [64,	85,		255,	85,		4],
											 [96,	85,		85,		85,		12],
											 [32,	48,		16,		24,		8]]
											 
		public static const matrix3:Array = [[128, 1, 2],
											 [64,  255,  4],
											 [32,  16,  8]]
		
		
		public function DungeonFromWangAlgorithm() 
		{
			
		}
		
		public static function convertFromWang(wangTiles:Vector.<Vector.<int>>, roomMatrix:Array, corridorMatrix:Array):String {
			
			function isCorridor(wang:int):Boolean 
			{
				return wang == 1 || wang == 4 || wang == 16 || wang == 64 || wang == 17 || wang == 68 || wang == 5 || wang == 20 || wang == 80 || wang == 65
				
			}
			
			var returnStr:String = "";
			var i:int, j:int, x:int, y:int;
			var wang:int
			// FOurs
			for (i = 0; i < wangTiles.length; i ++) {
				for (y = 0; y < roomMatrix.length; y++){
					for (j = 0; j < wangTiles[i].length; j++) {
						wang = int(wangTiles[i][j]);
						if(isCorridor(wang)){
							for (x = 0; x < corridorMatrix[y].length; x++) {
								
								returnStr += wang & corridorMatrix[y][x] ?  "░": "█";
							}
						} else {
							for (x = 0; x < roomMatrix[y].length; x++) {
								
								returnStr += wang & roomMatrix[y][x] ?  " ": "█";
							}
						}
					}
					returnStr += "\n";
				}
			}
			returnStr = returnStr.substr(0, returnStr.length - 1);
			
			returnStr = secondPass(returnStr);
			returnStr = deorphanCorridors(returnStr);
			
			return returnStr;
		}
		
		
		static private function secondPass(returnStr:String):String 
		{
			// Sort function for the local objects to join corridor ends to each other
			function sortPairs(obj1:Object, obj2:Object):int {
				if (obj1.x != obj2.x) return obj1.x < obj2.x ? -1 : 1;
				if (obj2.y != obj2.y) return obj1.y < obj2.y ? -1 : 1;
				
				var dist1:Number = Point.distance(obj1.a, obj1.b)
				var dist2:Number = Point.distance(obj2.a, obj2.b)
				
				if (dist1 != dist2) return dist1 < dist2 ? -1 : 1;
				return 0;
			}
			
			// Specific Flood Fill algorithm to find corridor endings and groups
			function flood(x:int, y:int):void {
				if (floodArray[y][x] == "█" || floodArray[y][x] == currentGroup) return;
				if (splitArray[y][x] == "░") {
					// Add any corridor ends to the corridor groups...
					var t:Boolean = splitArray[y - 1][x] != "█";
					var r:Boolean = splitArray[y][x + 1] != "█";
					var b:Boolean = splitArray[y + 1][x] != "█";
					var l:Boolean = splitArray[y][x - 1] != "█";
					if (int(t)+int(r)+int(b)+int(l) == 1) corridorEndPoints[currentGroup].push( new Point(x, y));
				}
				
				floodArray[y][x] = currentGroup;
				if (x != floodArray[y].length-1) 	flood(x + 1, y);
				if (x!=0)							flood(x - 1, y);
				if (y!=floodArray.length-1)  		flood(x, y + 1);
				if (y!=0)							flood(x, y - 1);
				
			}
			
			function fixedFlood(floodArray:Array, splitArray:Array, x:int, y:int, currentGroup:int, corridorEndPoints:Array ):void {
				if (floodArray[y][x] == "█" || floodArray[y][x] == currentGroup) return;
				
				var queue:Vector.<Point> = new Vector.<Point>();
				queue.push(new Point(x, y));
				
				var loop:int = 0;
				while (queue.length) {
					loop++
					var pt:Point = queue.shift();
					if (floodArray[pt.y][pt.x] == currentGroup || floodArray[pt.y][pt.x] == "█") continue;
					x = pt.x;
					y = pt.y;
					
					if (splitArray[y][x] == "░") {
						// Add any corridor ends to the corridor groups...
						var t:Boolean = splitArray[y - 1][x] != "█";
						var r:Boolean = splitArray[y][x + 1] != "█";
						var b:Boolean = splitArray[y + 1][x] != "█";
						var l:Boolean = splitArray[y][x - 1] != "█";
						if (int(t)+int(r)+int(b)+int(l) == 1) corridorEndPoints[currentGroup].push( new Point(x, y));
					}
					floodArray[y][x] = currentGroup;
					var w:int = x;
					var e:int = x;
					// West Loop
					while (true) {
						w--;
						if (w == 0 || splitArray[y][w] == "█") break;
						floodArray[y][w] = currentGroup;
					}
					// East Loop
					while (true) {
						e++;
						if (e == splitArray[y].length || splitArray[y][e] == "█") break;
						floodArray[y][e] = currentGroup;
					}
					for (var i:int = w; i < e; i++) {
						var n:String = y == 0 ? "█" : floodArray[y-1][i].toString()
						var s:String = y == floodArray.length ? "█" : floodArray[y+1][i].toString()
						if (!(n == "█" || n == currentGroup.toString())) {
							queue.push(new Point(i, pt.y - 1));
						}
						if (!(s == "█" || s == currentGroup.toString())) {
							queue.push(new Point(i, pt.y + 1));
						}
					}
					
					
					
				}
			}
			
			// Attempt to join two corridor endings to each other
			function attemptToJoin(pt1:Point, pt2:Point):Boolean {
				var hld:Point;
				if (pt1.x == pt2.x) {
					// Vertical Join
					if (pt2.y < pt1.y) {
						hld = pt2.clone();
						pt2 = pt1.clone();
						pt1 = hld.clone();
					}
					hld = new Point(pt1.x, pt1.y+1)
					while (hld.y != pt2.y) {
						if (hld.y >= splitArray.length-1) return false;
						if (splitArray[hld.y][hld.x] != "█") return false;
						hld.y++;
					}
					hld = new Point(pt1.x, pt1.y)
					while (hld.y != pt2.y) {
						hld.y++;
						splitArray[hld.y][hld.x] = "░";
					}
					
				} else {
					// Horizontal Join
					if (pt2.x < pt1.x) {
						hld = pt2.clone();
						pt2 = pt1.clone();
						pt1 = hld.clone();
					}
					hld = new Point(pt1.x+1, pt1.y)
					while (hld.x != pt2.x) {
						if (hld.x >= splitArray[hld.y].length -1) return false;
						if (splitArray[hld.y][hld.x] != "█") return false;
						hld.x++;
					}
					hld = new Point(pt1.x, pt1.y)
					while (hld.x != pt2.x) {
						hld.x++;
						splitArray[hld.y][hld.x] = "░";
					}
				}
				
				return true;
			}
			
			
			var i:int, j:int, currentGroup:int = -1, a:int, b:int;
			
			var splitArray:Array = returnStr.split("\n");
			var floodArray:Array = new Array();
			
			var corridorEndPoints:Array = new Array();
			
			// Split our string into an Array again...
			for (i = 0; i < splitArray.length; i++) {
				splitArray[i] = splitArray[i].split("");
				floodArray[i] = splitArray[i].slice();
			}
			var levelWidth:int = splitArray[0].length
			
			for (i = 0; i < floodArray.length; i++) {
				for (j = 0; j < floodArray[i].length; j++) {
					if (floodArray[i][j] == " " || floodArray[i][j] == "░") {
						
						currentGroup++;
						corridorEndPoints.push(new Array());
						
						//flood(j, i);
						fixedFlood(floodArray,  splitArray, j, i, currentGroup,corridorEndPoints);
					}
				}
			}
			
			if (currentGroup > 1) {
				var pairs:Vector.<Object> = new Vector.<Object>();
				
				for (a = 0; a < corridorEndPoints.length; a++) {
					for (i = 0; i < corridorEndPoints[a].length; i++){
						var ap:Point = corridorEndPoints[a][i]
						for (b = a+1; b < corridorEndPoints.length; b++) {
							for (j = 0; j < corridorEndPoints[b].length; j++) {
								var bp:Point = corridorEndPoints[b][j]
								if (ap.x == bp.x || ap.y == bp.y) {
									pairs.push({"a":ap, "b":bp, "x":a,"y":b})
								}
							}
						}
					}
				}
				pairs = pairs.sort(sortPairs);
				pairs = pairs.reverse();
				
				var finalStr:String = ""
				
				while (pairs.length) {
					var itm:Object = pairs.pop()
					attemptToJoin(itm.a, itm.b)
				}
				
				finalStr = "";
				for (var y:int = 0; y < splitArray.length; y++) {
					
					for (var x:int = 0; x < splitArray[y].length; x++) {
						finalStr+=splitArray[y][x]
					}
					finalStr += "\n";
				}
				finalStr = finalStr.substr(0, finalStr.length - 1);
				
				
				if (finalStr != returnStr) return secondPass(finalStr);
				else trace("Warning, unjoined areas");
			}
			return returnStr;
		}
		
		static protected function deorphanCorridors(returnStr:String):String 
		{
			var splitArray:Array = returnStr.split("\n");
			var i:int, j:int, x:int, y:int;
			
			var corridorEndPoints:Array = new Array();
			
			// Split our string into an Array again...
			for (y = 0; y < splitArray.length; y++) {
				splitArray[y] = splitArray[y].split("");
			}
			for (y = 0; y < splitArray.length; y++) {
				for (x = 0; x < splitArray[y].length; x++) {
					if (splitArray[y][x] == "░") {
						// Add any corridor ends to the corridor groups...
						var t:Boolean = splitArray[y - 1][x] != "█";
						var r:Boolean = splitArray[y][x + 1] != "█";
						var b:Boolean = splitArray[y + 1][x] != "█";
						var l:Boolean = splitArray[y][x - 1] != "█";
						if (int(t)+int(r)+int(b)+int(l) <= 1) corridorEndPoints.push( new Point(x, y));
					}
				}
			}
			
			if (corridorEndPoints.length == 0) return returnStr;
			
			var finalStr:String = "";
			
			for (i = 0; i < corridorEndPoints.length; i++) { 
				var pt:Point = corridorEndPoints[i]
				var maxScan:int = 20;
				
				var left:int = splitArray[pt.y][pt.x - 1] != "█" ? maxScan: 0;
				var right:int = splitArray[pt.y][pt.x + 1] != "█" ? maxScan : 0;
				var top:int = splitArray[pt.y -1][pt.x] != "█" ? maxScan : 0;
				var btm:int = splitArray[pt.y +1][pt.x] != "█" ? maxScan : 0;
				
				//Leftscan
				x = pt.x-1; y = pt.y;
				while (true && left < maxScan) {
					if (x == 0) {
						left = maxScan;
						break;
					}
					if (splitArray[y][x] != "█") break;
					x--;
					left++;
					
				}
				//Topscan
				x = pt.x; y = pt.y-1;
				while (true && top < maxScan) {
					if (y == 0) {
						top = maxScan;
						break;
					}
					if (splitArray[y][x] != "█") break;
					y--;
					top++;
					
				}
				//Rightscan
				x = pt.x+1; y = pt.y;
				while (true && right < maxScan) {
					if (x == splitArray[y].length) {
						right = maxScan;
					}
					if (splitArray[y][x] != "█") break;
					x++;
					right++;
					
				}
				//Bottomscan
				x = pt.x; y = pt.y+1;
				while (true && btm < maxScan) {
					if (y == splitArray.length) {
						btm = maxScan;
						break;
					}
					if (splitArray[y][x] != "█") break;
					y++;
					btm++;
					
				}
				
				if (left >= maxScan && right >= maxScan && top >= maxScan && btm >= maxScan) continue;
				for (j = 0; j < maxScan; j++) {
					var found:Boolean = false;
					
					if (left == j) {
						found = true;
						while(left > 0){
							splitArray[pt.y][pt.x - left] = "░"
							left--;
						}
					}
					
					if (right == j) {
						found = true;
						while(right > 0){
							splitArray[pt.y][pt.x + right] = "░"
							right--;
						}
					}
					
					if (top == j) {
						found = true;
						while(top > 0){
							splitArray[pt.y - top][pt.x] = "░"
							top--;
						}
					}
					
					if (btm == j) {
						found = true;
						while(btm > 0){
							splitArray[pt.y + btm][pt.x] = "░"
							btm--;
						}
					}
					
					if (found) break;
					
				}
				
			}
			
			for (y = 0; y < splitArray.length; y++) {
				
				for (x = 0; x < splitArray[y].length; x++) {
					finalStr+=splitArray[y][x]
				}
				finalStr += "\n";
			}
			finalStr = finalStr.substr(0, finalStr.length - 1);
			
			if (finalStr != returnStr) deorphanCorridors(finalStr);
			
			return finalStr
		}
		
		
	}

}