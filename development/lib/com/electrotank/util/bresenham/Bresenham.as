package com.electrotank.util.bresenham {
	import flash.geom.Point;
	
	public class Bresenham{
		
		/*
		 function line(x0, x1, y0, y1)
			 boolean steep := abs(y1 - y0) > abs(x1 - x0)
			 if steep then
				 swap(x0, y0)
				 swap(x1, y1)
			 if x0 > x1 then
				 swap(x0, x1)
				 swap(y0, y1)
			 int deltax := x1 - x0
			 int deltay := abs(y1 - y0)
			 int error := deltax / 2
			 int ystep
			 int y := y0
			 if y0 < y1 then ystep := 1 else ystep := -1
			 for x from x0 to x1
				 if steep then plot(y,x) else plot(x,y)
				 error := error - deltay
				 if error < 0 then
					 y := y + ystep
					 error := error + deltax
		http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm

		 */
		static public function determineTouchedTiles(p0:Point, p1:Point):Array {
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
					 touched.push(new Point(y, x));
				 } else {
					 touched.push(new Point(x, y));
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