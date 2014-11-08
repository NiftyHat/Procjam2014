package axengine.world.level 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxLevel
	{
			protected var _key:String;
			protected var _index:int;
		   
			protected var _isLocked:Boolean = true;
		   
			protected var _isLoaded:Boolean = true;
		   
			protected var _score:Number = 0;
			protected var _background_colour:int = 0x000000;
		   
			protected var _header:AxLevelHeader;
			protected var _content:AxLevelContent;
			protected var _area:AxLevelArea;
		   
		   
			public function AxLevel()
			{
				super();
				_header = new AxLevelHeader ();
				_content = new AxLevelContent ();
			}
		
			/* INTERFACE base.interfaces.ISerializedObject */
		   
			public function init($key:String):void
			{
				_key = $key;
				_header.init($key);
			}
		   
			public function loadData():void
			{
				_content.loadRemote(_key);
			}
		   
		   
			public function toString():String
			{
				return _header.name + _area.key;
			}
		   
			public function destroy():void
			{
				   
			}
		   
			public function setArea($key:String):void
			{
				_area = _content.getArea($key);
			}
		   
			public function getArea($key:String = null):AxLevelArea
			{
				_area = _content.getArea($key);
				return _area;
			}
		   
			public function getAssetPath($name:String):String
			{
				return _content.getAssetPath($name);
			}
		   
		   
			public function get header():AxLevelHeader { return _header; }

			public function get score():Number { return _score; }

			public function get content():AxLevelContent { return _content; }
		   
			public function get background_colour():int { return _background_colour; }
		   
			public function get isLoaded():Boolean { return _isLoaded; }
		   
			public function get area():AxLevelArea 
			{ 
				if (!_area) _area = getArea(_content.firstAreaKey);
				return _area; 
			
			}
		   
			public function get key():String { return _key; }
		   
			public function get index():int { return _index; }
		   
			public function set score(value:Number):void
			{
				_score = value;
			}
		   
			public function get isLocked():Boolean
			{
				return false;
			}
		   
    }

}