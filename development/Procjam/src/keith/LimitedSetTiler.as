package keith
{
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class LimitedSetTiler 
	{
		
		private var library:Vector.<WangTile>
		
		
		public function LimitedSetTiler() 
		{
			library = new Vector.<WangTile>()
		}
		
		public function addTile(wangTile:WangTile):void {
			library.push(wangTile)
		}
		
		public function build(width:int, height:int):Vector.<Vector.<int>> {
			var j:int;
			var i:int;
			var wangVector:Vector.<Vector.<WangTile>> = new Vector.<Vector.<WangTile>>(height);
			for (i = 0; i < wangVector.length; i++) {
				wangVector[i] = new Vector.<WangTile>(width);
				for (j = 0; j < width; j++) {
					wangVector[i][j] = null;
				}
			}
			
			
			function drawWang(x:int, y:int, ban:Vector.<int> = null):Boolean {
				var i:int;
				if (ban == null) {
					ban = new Vector.<int>();
				}
				
				wangVector[y][x] = null;
				
				var wangAtLeft:int = 	x == 0 ? -1 : 			wangVector[y][x - 1] == null ? -1 : wangVector[y][x - 1].rightSet
				var wangAtTop:int = 	y == 0 ? -1 : 			wangVector[y - 1][x] == null ? -1 : wangVector[y - 1][x].bottomSet
				
				var legal:Vector.<WangTile> = library.slice();
				if (wangAtLeft != -1)	for (i = legal.length -1; i >= 0; i--) { if (legal[i].leftSet != wangAtLeft) legal.splice(i, 1);}  
				if (wangAtTop != -1) 	for (i = legal.length -1; i >= 0; i--) { if (legal[i].topSet != wangAtTop) legal.splice(i, 1); }  
				
				for (j = 0; j < ban.length; j++){
					for (i = legal.length -1; i >= 0; i--) {
						if (legal[i].id == ban[j]) {
							legal.splice(i, 1);
						} 
						
					}
				}
				
				
				if (legal.length == 0) {
					wangVector[y][x] = null;
					return false;
				}
				
				wangVector[y][x] = legal[int(Math.random() * legal.length)]
				
				var valid:Boolean = true;
				var banSelf:Vector.<int> = new Vector.<int>(); banSelf.push(wangVector[y][x].id);
				if (x != width - 1) valid = drawWang(x + 1, y, banSelf);
				if (!valid) {
					ban.push(wangVector[y][x].id);
					return drawWang(x, y, ban);
				}
				
				if (x == 0 && y != height - 1 ) {
					valid = valid && drawWang(x, y + 1, banSelf);
					if (!valid) {
						ban.push(wangVector[y][x].id);
						return drawWang(x, y, ban);
					}
				}
				
				return true;
				
			}
			
			drawWang(0, 0, new Vector.<int>());
			
			var returnVector:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(height);
			for (i = 0; i < returnVector.length; i++) {
				returnVector[i] = new Vector.<int>(width);
				for (j = 0; j < width; j++) {
					if (wangVector[i][j]) returnVector[i][j] = wangVector[i][j].id;
					else return build(width, height);
				}
			}
			
			return returnVector
		}
		
	}

}