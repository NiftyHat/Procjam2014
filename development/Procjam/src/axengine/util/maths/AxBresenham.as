package axengine.util.maths {
	import org.axgl.AxPoint;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxBresenham {
		
		static public function getLine(p0:AxPoint, p1:AxPoint):Array {
			var touched:Array = [];
			
			var x0:int = p0.x;
			var y0:int = p0.y;
			var x1:int = p1.x;
			var y1:int = p1.y;
			
			var steep:Boolean = Math.abs(y1 - y0) > Math.abs(x1 - x0);
			
			if (steep) {
				 x0 = p0.y;
				 y0 = p0.x;
				 x1 = p1.y;
				 y1 = p1.x;
			}
			
			if (x0 > x1) {
				var x0_old:int = x0;
				var y0_old:int = y0;
				
				x0 = x1;
				x1 = x0_old;
				y0 = y1;
				y1 = y0_old;
			}
			
			var deltax:int = x1 - x0;
			var deltay:int = Math.abs(y1 - y0);
			var error:int = deltax / 2;
			var ystep:int;
			var y:int = y0;
			
			if (y0 < y1) {
				ystep = 1;
			} else {
				ystep = -1;
			}
			
			for (var x:int = x0; x <= x1;++x) {
				 if (steep) {
					 touched.push(new AxPoint(y, x));
				 } else {
					 touched.push(new AxPoint(x, y));
				 }
				 error = error - deltay;
				 if (error < 0) {
					 y = y + ystep;
					 error = error + deltax;
				 }
			}
			
			return touched;
		}
	}

}