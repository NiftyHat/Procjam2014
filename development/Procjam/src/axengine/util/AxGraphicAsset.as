package axengine.util
{
	import org.axgl.Ax;
	import org.axgl.AxPoint;
	import org.axgl.AxRect;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxGraphicAsset
        {
                protected var _asset:*;
                protected var _width:int;
                protected var _height:int;
                protected var _bounds:AxRect;
                protected var _anchor:AxPoint;
                protected var _animations:Vector.<AxAnimationAsset>;
                protected var _isAnimated:Boolean;
               
                public function AxGraphicAsset()
                {
                        _asset = Core.lib.int.img_no_asset;
                        _width = 40;
                        _height = 40;
                        _anchor = new AxPoint ();
                        _bounds = new AxRect ();
                }
               
                public function deserialize ($xml:XML):void
                {
                        _asset = Core.lib.getAsset($xml.@path);
                        _width = $xml.SIZE.@width;
                        _height = $xml.SIZE.@height;
                        _bounds.x = $xml.BOUNDS.@x;
                        _bounds.y = $xml.BOUNDS.@y;
                        _bounds.width = $xml.BOUNDS.@width;
                        _bounds.height = $xml.BOUNDS.@height;
                        _anchor.x = $xml.ANCHOR.@x;
                        _anchor.y = $xml.ANCHOR.@y;
                        _isAnimated = ($xml.ANIMS.*.length() > 0)
                        if (_isAnimated)
                        {
                                _animations = new Vector.<AxAnimationAsset> ();
                                for each (var item:XML in $xml.ANIMS.*)
                                {
                                        var animation:AxAnimationAsset = new AxAnimationAsset ();
                                        animation.deserialize(item);
                                        _animations.push(animation);
                                }
                        }
                }
               
                public function get width():int { return _width; }
               
                public function get height():int { return _height; }
               
                public function get bounds():AxRect { return _bounds; }
               
                public function get asset():* { return _asset; }
               
                public function get isAnimated():Boolean
                {
                        return _isAnimated;
                }
               
                public function get animations():Vector.<AxAnimationAsset>
                {
                        return _animations;
                }
               
                public function get anchor():AxPoint
                {
                        return _anchor;
                }
               
        }

}