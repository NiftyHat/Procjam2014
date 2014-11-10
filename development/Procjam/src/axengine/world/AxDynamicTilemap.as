package axengine.world 
{
	import org.axgl.Ax;
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;
	import org.axgl.tilemap.AxTilemapSegment;
	
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
		
		/**
		 * Builds the tilemap from the data and tileset you pass.
		 * 
		 * @param mapString The comma separated list of tiles in the tilemap.
		 * @param graphic The tileset graphic.
		 * @param tileWidth The width of each tile in the tileset graphic.
		 * @param tileHeight The height of each tile in the tileset graphic.
		 * @param solidIndex The index of the first solid tile.
		 * @param segmentWidth The width of each tilemap segment, defaults to number of tiles that fit in Ax.viewWidth
		 * @param segmentWidth The height of each tilemap segment, defaults to number of tiles that fit in Ax.viewHeight
		 *
		 * @return The tilemap object.
		 */
		public function buildEmpty(sizeCols:int, sizeRows:int, graphic:Class, tileWidth:uint, tileHeight:uint, fillIndex:int = 0, solidIndex:uint = 1, segmentWidth:int = -1, segmentHeight:int = -1):AxTilemap {
			if (tileWidth == 0 || tileHeight == 0) {
				throw new Error("Tile size cannot be 0");
			} else if (segmentWidth == 0 || segmentHeight == 0) {
				throw new Error("Segment size cannot be 0");
			} else if (sizeCols == 0 || sizeRows == 0) {
				throw new Error ("Row/Col count cannot be zero");
			}
			
			setGraphic(graphic);
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			this.solidIndex = solidIndex;

			this.tilesetCols = Math.floor(texture.rawWidth / tileWidth);
			this.tilesetRows = Math.floor(texture.rawHeight / tileHeight);
			this.tiles = new Vector.<AxTile>;
			this.data = new Vector.<uint>;
			
			var x:uint, y:uint;
			
			this.rows = sizeCols;
			this.cols = sizeRows;
			
			var viewWidthInTiles:uint = Ax.viewWidth / tileWidth;
			var viewHeightInTiles:uint = Ax.viewHeight / tileHeight;
			// By default the segment size is the size of the map that fits on the screen at once, unless the size of the map is less than
			// 2 screens, in which it is the entire size of the map.
			this.segmentWidth = segmentWidth == -1 ? (cols < viewWidthInTiles * 2 ? cols : viewWidthInTiles) : segmentWidth;
			this.segmentHeight = segmentHeight == -1 ? (rows < viewHeightInTiles * 2 ? rows : viewHeightInTiles) : segmentHeight;
			this.segmentCols = Math.ceil(this.cols / this.segmentWidth);
			this.segmentRows = Math.ceil(this.rows / this.segmentHeight);
			this.segments = new Vector.<AxTilemapSegment>(this.segmentCols * this.segmentRows, true);
			
			for (y = 0; y < this.segmentRows; y++) {
				for (x = 0; x < this.segmentCols; x++) {
					var sw:uint = x == this.segmentCols - 1 && this.cols % this.segmentWidth != 0 ? this.cols % this.segmentWidth : this.segmentWidth;
					var sh:uint = y == this.segmentRows - 1 && this.rows % this.segmentHeight != 0 ? this.rows % this.segmentHeight : this.segmentHeight;
					this.segments[y * this.segmentCols + x] = new AxTilemapSegment(this, sw, sh);
				}
			}
			
			this.uvWidth = 1 / (texture.width / tileWidth);
			this.uvHeight = 1 / (texture.height / tileWidth);

			indexData = new Vector.<uint>;
			vertexData = new Vector.<Number>;
			
			for (y = 0; y < rows; y++) {
				for (x = 0; x < cols; x++) {
					var segmentRow:uint = y / this.segmentHeight;
					var segmentCol:uint = x / this.segmentWidth;
					var segmentOffset:uint = segmentRow * segmentCols + segmentCol;
					var segment:AxTilemapSegment = this.segments[segmentOffset];
					
					var tid:uint = fillIndex;
					if (tid == 0) {
						data.push(0);
						segment.bufferOffsets.push(-1);
						continue;
					}
					
					data.push(tid);
					segment.bufferOffsets.push(segment.bufferSize++);
					//tid -= 1;
					
					var tx:uint = x * tileWidth;
					var ty:uint = y * tileHeight;
					var u:Number = (tid % tilesetCols) * uvWidth;
					var v:Number = Math.floor(tid / tilesetCols) * uvHeight;
					
					segment.indexData.push(segment.index, segment.index + 1, segment.index + 2 , segment.index + 1 , segment.index + 2, segment.index + 3);
					segment.vertexData.push(
						tx, 				ty,					u,				v,
						tx + tileWidth,		ty,					u + uvWidth,	v,
						tx,					ty + tileHeight,	u,				v + uvHeight,
						tx + tileWidth,		ty + tileHeight,	u + uvWidth,	v + uvHeight
					);
					segment.index += 4;
				}
			}

			width = cols * tileWidth;
			height = rows * tileHeight;

			tiles.push(null);
			for (var i:uint = 1; i <= tilesetCols * tilesetRows; i++) { 
				var tile:AxTile = new AxTile(this, i + 1, tileWidth, tileHeight);
				tile.collision = i >= solidIndex ? ANY : NONE;
				tiles.push(tile);
			}
			
			return this;
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