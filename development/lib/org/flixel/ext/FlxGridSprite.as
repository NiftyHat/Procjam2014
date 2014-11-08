package org.flixel.ext 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flixel.* ;
	
	/**
	 * Creates a 9-grid style sprite that stretches
	 * @author David Grace
	 */
	public class FlxGridSprite extends FlxObject 
	{
		protected var _sourceImage:BitmapData ;
		
		protected var _grid:FlxRect ;
		
		protected var _scaledImage:BitmapData ;
		
		protected var _flashRect:Rectangle ;
		
		protected var _smoothing:Boolean ;
		
		protected var _color:uint = 0xFFFFFF ;
		
		protected var _alpha:Number = 1.0 ;
		
		protected var _ct:ColorTransform ;
		
		protected var _flashPoint:Point;
		
		/**
		 * Creates the grid sprite using the 9-slice grid given
		 * 
		 * @param	X				Left coord to draw the sprite
		 * @param	Y				Top coord to draw the sprite
		 * @param	Width			Total width of the sprite
		 * @param	Height			Total height of the sprite
		 * @param	BitmapClass		The image class to use
		 * @param	Grid			A FlxRect that contains the grid demarks
		 * @param	Smoothing		Smooth when we scale the individual pieces?
		 */
		public function FlxGridSprite(X:Number, Y:Number, Width:Number, Height:Number, BitmapClass:Class, Grid:FlxRect, Smoothing:Boolean = false) 
		{
			super(X, Y, Width, Height);
			
			_flashPoint = new Point (0,0);
			
			_sourceImage = FlxG.addBitmap (BitmapClass) ;
			
			_grid = Grid ;
			
			_flashRect = new Rectangle (0, 0, width, height) ;	
			
			_smoothing = Smoothing ;
			
			buildScaledImage() ;
		}
		
		public function get smoothing():Boolean
		{
			return _smoothing ;
		}
		
		public function set smoothing(v:Boolean):void
		{
			_smoothing = v ;
			buildScaledImage() ;
		}
		
		public function set color(v:uint):void
		{
			_color = v ;
			buildScaledImage() ;
		}
		
		public function get color():uint
		{
			return _color ;
		}

		public function set alpha(v:Number):void
		{
			if(v > 1) v = 1;
			if(v < 0) v = 0;
			if(v == _alpha) return;
			_alpha = v;
			buildScaledImage() ;
		}
		
		public function get alpha():Number
		{
			return _alpha ;
		}
		
		/**
		 * Called whenever we need to rebuild the scaled bitmap that is rendered.
		 * 
		 * Do this after you modify the width/height of this sprite.
		 */
		public function buildScaledImage():void
		{
			if (_scaledImage)
				_scaledImage.dispose() ;
				
			_scaledImage = new BitmapData (width, height, true, 0x0) ;
			
			var rows : Array = [0, _grid.top, _grid.bottom, _sourceImage.height];
			var cols : Array = [0, _grid.left, _grid.right, _sourceImage.width];
			
			var dRows : Array = [0, _grid.top, height - (_sourceImage.height - _grid.bottom), height];
			var dCols : Array = [0, _grid.left, width - (_sourceImage.width - _grid.right), width];

			var origin : Rectangle;
			var draw : Rectangle;
			var mat : Matrix = new Matrix();
			var ct:ColorTransform ;

			if (_color > 0 || alpha != 1.0)
			{
				ct = new ColorTransform(Number(_color >> 16 & 0xFF) / 255,
										Number(_color >> 8 & 0xff) / 255,
										Number(_color & 0xff) / 255,
										_alpha) ;
			} else
				ct = null ;
			
			for (var cx : int = 0;cx < 3; cx++)
				for (var cy : int = 0 ; cy < 3; cy++)
				{
					origin = new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
					draw = new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
					mat.identity();
					mat.a = draw.width / origin.width;
					mat.d = draw.height / origin.height;
					mat.tx = draw.x - origin.x * mat.a;
					mat.ty = draw.y - origin.y * mat.d;
					_scaledImage.draw(_sourceImage, mat, ct, null, draw, _smoothing) ;
				}
				
			_flashRect = new Rectangle (0, 0, width, height) ;
		}
		
		override public function draw():void
		{
			if(cameras == null)
				cameras = FlxG.cameras;
			var camera:FlxCamera;
			var i:uint = 0;
			var l:uint = cameras.length;
			while(i < l)
			{
				camera = cameras[i++];
				if(!onScreen(camera))
					continue;
				_point.x = x - int(camera.scroll.x*scrollFactor.x);
				_point.y = y - int(camera.scroll.y*scrollFactor.y);
				_point.x += (_point.x > 0)?0.0000001:-0.0000001;
				_point.y += (_point.y > 0)?0.0000001:-0.0000001;
				_flashPoint.x = _point.x ;
				_flashPoint.y = _point.y ;
				//FlxG.camera.buffer.copyPixels (_scaledImage, _flashRect, _flashPoint, null, null, true) ;
				camera.buffer.copyPixels(_scaledImage, _flashRect, _flashPoint, null, null, true);
			}
			super.draw();
		}
		
		override public function destroy():void
		{
			super.destroy() ;
			_scaledImage.dispose() ;
		}
		
	}
}