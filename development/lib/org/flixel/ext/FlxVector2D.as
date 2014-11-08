package org.flixel.ext 
{
	import flash.geom.Point;
	import org.flixel.FlxPoint;
	/**
	 * A basic 2-dimensional vector class.
	 */
	public class FlxVector2D extends FlxPoint
	{
		
		//================ INSTANCE FUNCTIONS
		public function FlxVector2D(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function getPoint():FlxPoint
		{
			return new FlxPoint(x, y); 
		}
		
		public function getSquaredMagnitude():Number
		{
			return Math.pow(x, 2) + Math.pow(y, 2);
		}
		
		public function getMagnitude():Number
		{
			return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
		}
		
		public function getNormalized():FlxVector2D
		{
			var mag:Number = getMagnitude();
			var vec:FlxVector2D = new FlxVector2D(x / mag, y / mag);
			return vec;
		}
		
		public function normalize():void
		{
			var mag:Number = getMagnitude();
			x /= mag;
			y /= mag;
		}

		public function addBy(other:FlxVector2D):void
		{
			x += other.x;
			y += other.y;
		}
		
		public function subtractBy(other:FlxVector2D):void
		{
			x -= other.x;
			y -= other.y;
		}
		
		public function multiplyBy(num:Number):void
		{
			x *= num;
			y *= num;
		}
		
		public function scaleBy(other:FlxVector2D):void
		{
			x *= other.x;
			y *= other.y;
		}
		
		public function getPerpendicularLeft():FlxVector2D
		{
			return new FlxVector2D(-y, x);
		}
		
		public function getPerpendicularRight():FlxVector2D
		{
			return new FlxVector2D(y, -x);
		}
		
		public static function bresenhamLine(start:FlxVector2D, end:FlxVector2D):Array 
		{
		var points:Array = [];//the array of all the points on the line
		var steep:Boolean = Math.abs(end.y-start.y) > Math.abs(end.x-start.x);
				var swapped:Boolean = false;
		if (steep)
		{
			start = swap(start.x,start.y);//reflecting the line
			end = swap(end.x,end.y);
		}
		if (start.x > end.x)
		{ //make sure the line goes downward
			var t:Number = start.x;
			start.x = end.x;
			end.x = t;
			t = start.y;
			start.y = end.y;
			end.y = t;
			swapped = true;
		}
		var deltax:Number = end.x-start.x;//x slope
		var deltay:Number = Math.abs(end.y-start.y); //y slope, positive because the lines always go down
		var error:Number = deltax/2; //error is used instead of tracking the y values.
		var ystep:Number;
		var y:Number = start.y;
		if(start.y < end.y) ystep = 1;
		else ystep = -1;
		for (var x:int = start.x; x < end.x; x++)
		{
			//for each point
			if (steep)
				{
				points.push(new FlxPoint(y,x));//if its steep, push flipped version
				} 
			else 
				{
				points.push(new FlxPoint(x,y));//push normal
				}
			error -= deltay;//change the error
			if (error < 0)
			{
			y += ystep;//if the error is too much, adjust the ystep
			error += deltax;
			}
		}
		if(swapped) points.reverse();
		return points;
		}
		 
		private static function swap(x:Number, y:Number):FlxVector2D 
		{
			return new FlxVector2D(y,x)
		}

		//================ STATIC FUNCTIONS
		public static function add(a:FlxVector2D, b:FlxVector2D):FlxVector2D
		{
			var vec:FlxVector2D = new FlxVector2D(a.x + b.x, a.y + b.y);
			return vec;
		}
		
		public static function subtract(a:FlxVector2D, b:FlxVector2D):FlxVector2D
		{
			var vec:FlxVector2D = new FlxVector2D(a.x - b.x, a.y - b.y);
			return vec;
		}
		
		// multiply each component by the other FlxVector2D
		public static function scale(a:FlxVector2D, b:FlxVector2D):FlxVector2D
		{
			var vec:FlxVector2D = new FlxVector2D(a.x * b.x, a.y * b.y);
			return vec;
		}
		
		// return the dot product of a and b
		// HOW TO USE:
		// the dot product is a Number ranging from -1.0 to +1.0
		// if the dot product is > 0.0, the vectors point in a similar direction
		// if the dot product is < 0.0, the vectors point in opposite directions
		// can even use +/- 0.5 or 0.75 etc to guesstimate how similar the direction of the vectors are
		// general use would be like if (FlxVector2D.dot(dir, otherDir) > 0.5) // we point mainly in the same direction
		public static function dot(a:FlxVector2D, b:FlxVector2D):Number
		{
			return (a.x * b.x + a.y * b.y);
		}
	}
	
}