package com.astar{
	
	public class AStarMap {
		
		//these are the states available for each cell.
		public const CELL_FREE:uint = 0;
		public const CELL_FILLED:uint = 1;
		public const CELL_ORIGIN:uint = 2;
		public const CELL_DESTINATION:uint = 3;
		public const MAX_ITERATIONS:uint = 2000;
		
		public var gridWidth:uint;
		public var gridHeight:uint;
		
		private var originCell:Object;
		private var destinationCell:Object;
		private var currentCell:Object;
		
		private var openList:Array;
		private var closedList:Array;
		
		private var mapArray:Array;
		
		//grid sizes refer to the size in units of cell size, not pixel size.
		public function AStarMap(_gridWidth:int, _gridHeight:int):void {
			
			gridWidth = _gridWidth;
			gridHeight = _gridHeight;
			
			//define map
			mapArray = new Array();
			var xx:int = 0;
			var yy:int = 0;
			for(xx = 0; xx < gridWidth; xx++) {
				mapArray[xx] = new Array();
				for(yy = 0; yy < gridHeight; yy++) {					
					mapArray[xx][yy] = new Object();
					mapArray[xx][yy].cellType = CELL_FREE;					
					mapArray[xx][yy].parentCell = null;
					mapArray[xx][yy].g = 0;
					mapArray[xx][yy].f = 0;
					mapArray[xx][yy].x = xx;
					mapArray[xx][yy].y = yy;
				}
				
			}
			
			openList = new Array();
			closedList = new Array();
		}
		
		public function solve():Array {
			//count = 0;
			reset();
			//trace(destinationCell.x, destinationCell.y);
			var isSolved:Boolean = false;
			var iter:int = 0;
			
			isSolved = stepPathfinder();

			while(!isSolved) {
				isSolved = stepPathfinder();
				if(iter++ > MAX_ITERATIONS) return null;
			}

			//set pointer to last cell on list
			//if pointer is pointing to originCell, then finish
			//if pointer is not pointing at origin cell, then process, and set pointer to parent of current cell	
			var solutionPath:Array = new Array();
			var count:int = 0;
			var cellPointer:Object = closedList[closedList.length - 1];
			while(cellPointer != originCell) {
				if(count++ > 800) return null; //prevent a hang in case something goes awry
				solutionPath.push(cellPointer);				
				cellPointer = cellPointer.parentCell;					
			}
			
			return solutionPath;
				
		}

		private function stepPathfinder():Boolean {
			//trace(cnt++);
			if(currentCell == destinationCell) {
				closedList.push(destinationCell);
				return true;
			}
			
			//place current cell into openList
			openList.push(currentCell);	

			//----------------------------------------------------------------------------------------------------
			//place all legal adjacent squares into a temporary array
			//----------------------------------------------------------------------------------------------------
			
			//add legal adjacent cells from above to the open list
			var adjacentCell:Array = new Array();
			var arryPtr:Object;			
			
			for(var xx:int = -1; xx <= 1; xx++) {				
				for(var yy:int = -1; yy <= 1; yy++) {					
					if(!(xx == 0 && yy == 0)) { //this is the current cell, so skip it.
						if(currentCell.x + xx >= 0 && currentCell.y + yy >= 0 && currentCell.x + xx < gridWidth && currentCell.y + yy < gridHeight) {
							if(mapArray[currentCell.x + xx][currentCell.y + yy]) {
								
								arryPtr = mapArray[currentCell.x + xx][currentCell.y + yy];
								
								if(arryPtr.cellType != CELL_FILLED && closedList.indexOf(arryPtr) == -1) {
									
									//trace(mapArray[currentCell.x + xx][currentCell.y + yy]);
									adjacentCell.push(arryPtr);
								}								
							}
						}
					}					
				}						
			}
						
						
			var g:int;
			var h:int;

			for(var ii:int = 0; ii < adjacentCell.length; ii++) {
								
				g = currentCell.g + 1;
				
				h = ((Math.abs(adjacentCell[ii].x - destinationCell.x) + Math.abs(adjacentCell[ii].y - destinationCell.y))) * 0xFFFF;
				trace(h);
				if(openList.indexOf(adjacentCell[ii]) == -1) { //is cell already on the open list? - no									

					adjacentCell[ii].f = g + h;
					adjacentCell[ii].parentCell = currentCell;
					adjacentCell[ii].g = g + h;					
					openList.push(adjacentCell[ii]);

				} else { //is cell already on the open list? - yes
					
					if(adjacentCell[ii].g < currentCell.parentCell.g) {
						currentCell.parentCell = adjacentCell[ii];
						currentCell.g = adjacentCell[ii].g;
						currentCell.f = adjacentCell[ii].g + h;
						
					}
				}
			}
				
			//Remove current cell from openList and add to closedList.
			var indexOfCurrent = openList.indexOf(currentCell);
			closedList.push(currentCell);
			openList.splice(indexOfCurrent, 1);
			
			//Take the lowest scoring openList cell and make it the current cell.
			openList.sortOn("f", Array.NUMERIC | Array.DESCENDING);	
			
			if(openList.length == 0) return true;
			
			currentCell = openList.pop();			
			
			return false;
			
		}
		
		public function getCell(xx:int, yy:int):Object {
			
			return mapArray[xx][yy];
			
		}	
		
		//Sets individual cell state
		public function setCell(xx:int, yy:int, cellType:int):void {
			
			mapArray[xx][yy].cellType = cellType;
			
		}
		
		//Toggle cell between "filled" and "free" states
		public function toggleCell(cellX:int, cellY:int):void {
			
			if(mapArray[cellX][cellY].cellType == CELL_FILLED) mapArray[cellX][cellY].cellType = CELL_FREE;
			else if(mapArray[cellX][cellY].cellType == CELL_FREE) mapArray[cellX][cellY].cellType = CELL_FILLED;
			
		}
		
		//Sets origin and destination
		public function setEndPoints(originX:int, originY:int, destX:int, destY:int):void {
			
			originCell = mapArray[originX][originY];
			destinationCell = mapArray[destX][destY];
			
			originCell.cellType = CELL_ORIGIN;
			destinationCell.cellType = CELL_DESTINATION;
			
			currentCell = originCell;
			closedList.push(originCell);
			
		}
		
		//Resets algorithm without clearing cells
		public function reset():void {
			
			for(var xx = 0; xx < gridWidth; xx++) {
				for(var yy = 0; yy < gridHeight; yy++) {									
					mapArray[xx][yy].parentCell = null;
					mapArray[xx][yy].g = 0;
					mapArray[xx][yy].f = 0;
				}				
			}
			
			openList = new Array();
			closedList = new Array();
			
			currentCell = originCell;
			closedList.push(originCell);
			
		}
		
		//Sets all filled cells to free cells (does not affect origin or destination cells)
		public function clearMap():void {
			
			for(var xx = 0; xx < gridWidth; xx++) {
				//mapArray[xx] = new Array();
				for(var yy = 0; yy < gridHeight; yy++) {					
					//mapArray[xx][yy] = new Object();
					if(mapArray[xx][yy].cellType == CELL_FILLED) mapArray[xx][yy].cellType  = CELL_FREE;					
					mapArray[xx][yy].parentCell = null;
					mapArray[xx][yy].g = 0;
					mapArray[xx][yy].f = 0;
					mapArray[xx][yy].x = xx;
					mapArray[xx][yy].y = yy;
				}
				
			}
		}
		
	} //end class
	
}
	
