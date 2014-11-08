package com.astar{
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getTimer;
	
	public class AStar extends Sprite {
		
		var map:AStarMap;
		var cellSize:int = 20;
		
		public function AStar() {
			
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}		
		
		public function initialize(evt:Event) {
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			map = new AStarMap(20, 20);
			map.setCell(2, 4, map.CELL_FILLED);
			map.setCell(3, 4, map.CELL_FILLED);
			map.setCell(4, 4, map.CELL_FILLED);
			map.setCell(5, 4, map.CELL_FILLED);
			map.setEndPoints(2, 18, 18, 18);
			drawMap();
		}
		
		public function keyDownHandler(evt:KeyboardEvent) {		
				
			if(evt.keyCode == 82) {
				map.clearMap();
				drawMap();
			}
				
			//32 = space
			if(evt.keyCode == 32) {

				var solution:Array = map.solve();

				drawMap();
				
				//trace along path array
				graphics.lineStyle(2, 0x222222);		
				var endCell:Object = solution[0];
				//graphics.drawCircle(endCell.x * cellSize + cellSize/2, endCell.y * cellSize + cellSize/2, 30);
				graphics.moveTo(endCell.x * cellSize + cellSize/2, endCell.y * cellSize + cellSize/2);
				graphics.lineTo(endCell.parentCell.x * cellSize + cellSize/2, endCell.parentCell.y * cellSize + cellSize/2);
				for each(var cell in solution) {
					//trace(cell.x * cellSize, cell.parentCell.x * cellSize);
					graphics.moveTo(cell.x * cellSize + cellSize/2, cell.y * cellSize + cellSize/2);
					graphics.lineTo(cell.parentCell.x * cellSize + cellSize/2, cell.parentCell.y * cellSize + cellSize/2);
				}			
				
			}				
			
		}
		
		public function mouseDownHandler(evt:MouseEvent) {	

			var xx:int = evt.stageX / cellSize;
			var yy:int = evt.stageY / cellSize;
			
			if(evt.shiftKey) { //erase cells
				map.setCell(xx, yy, map.CELL_FREE);
			} else { //fill cells
				map.setCell(xx, yy, map.CELL_FILLED);
			}	
				
			drawMap();
			
		}
		
		public function mouseMoveHandler(evt:MouseEvent) {	

			if(evt.buttonDown) {
				
				var xx:int = evt.stageX / cellSize;
				var yy:int = evt.stageY / cellSize;	
			
				if(evt.shiftKey) { //erase cells
					map.setCell(xx, yy, map.CELL_FREE);
				} else { //fill cells
					map.setCell(xx, yy, map.CELL_FILLED);
				}		
				
				drawMap();
				
			}		
		}
		
		private function drawMap() {
			//draw cells
			graphics.clear();
			for(var xx:int = 0; xx < map.gridWidth; xx++) {
				for(var yy:int = 0; yy < map.gridHeight; yy++) {
					if(map.getCell(xx,yy).cellType == map.CELL_FILLED) {
						fillRect(graphics, xx * cellSize, yy * cellSize, 0xAA0000);
					}
					if(map.getCell(xx,yy).cellType == map.CELL_ORIGIN) {
						fillRect(graphics, xx * cellSize, yy * cellSize, 0x00AA00);
					}
					if(map.getCell(xx,yy).cellType == map.CELL_DESTINATION) {
						fillRect(graphics, xx * cellSize, yy * cellSize, 0x0000AA);
						
					}
				}
			}
			
			//draw grid
			graphics.lineStyle(2, 0xDDDDDD);
			var ii:int = 0;
			for(ii = cellSize; ii < map.gridWidth * cellSize; ii += cellSize) {
				graphics.moveTo(ii, 0);
				graphics.lineTo(ii, map.gridHeight * cellSize);
			}
			for(ii = cellSize; ii < map.gridHeight * cellSize; ii += cellSize) {
				graphics.moveTo(0, ii);
				graphics.lineTo(map.gridWidth * cellSize, ii);
			}
			
			//draw outline
			graphics.lineStyle(2, 0xAAAAAA);
			graphics.moveTo(0, 0);
			graphics.lineTo(map.gridWidth * cellSize, 0);
			graphics.lineTo(map.gridWidth * cellSize, map.gridHeight * cellSize);
			graphics.lineTo(0, map.gridHeight * cellSize);
			graphics.lineTo(0,0);
			
		}
		
		private function fillRect(target:Graphics, cellX:int, cellY:int, color:int) {			
			target.lineStyle(2, color);
			target.moveTo(cellX + 2, cellY + 2);
			target.beginFill(color, 0.5);			
			target.drawRect(cellX + 2, cellY + 2, cellSize - 4, cellSize - 4);
			//target.drawCircle(cellX * cellSize, cellY * cellSize, 10);
			target.endFill();
		}		
	}
}