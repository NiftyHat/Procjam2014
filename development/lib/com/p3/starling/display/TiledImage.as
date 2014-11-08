/**
 * Quick and dirty Tiled image class, only works on construction and only works horizontally.
 * 
 * @author Adam
 */
package com.p3.starling.display
{
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.display.Sprite;

	/**
	 * @author Adam H.
	 */
	public class TiledImage extends Sprite
	{
		public function TiledImage(texture:Texture, width:int, height:int)
		{			
			var tiledWidth:int = width;
//			var tiledHeight:int = height;			
			var xpos:int = 0;
			
			var image:Image = new Image(texture);
			var imageWidth:int = image.width;
			addChild(image);
						
			while(xpos < tiledWidth)
			{
				xpos += imageWidth;
				var image2:Image = new Image(texture);
				image2.x = xpos;
				addChild(image2);
			}
		}
	}
}
