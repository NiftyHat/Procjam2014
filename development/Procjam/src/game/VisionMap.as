package game 
{
	import de.polygonal.ds.Array2;
	import flash.utils.Dictionary;
	import keith.ShadowPoint;
	import keith.utils.collections.HashMap;
	import keith.utils.iterators.HashMapIterator;
	import keith.utils.iterators.IIterator;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxSprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VisionMap extends AxGroup 
	{
		private var _isDirty:Boolean;
		
		protected var lookup:Array2;
		
		protected var _lastTiles:Vector.<AxSprite>;
		protected var _entitiesLookup:Dictionary;
		
		public function VisionMap(x:Number=0, y:Number=0) 
		{
			super(x, y);
			_lastTiles = new Vector.<AxSprite> ();
			_entitiesLookup = new Dictionary ();
		}
		
		public function setSize(cols:int, rows:int):void {
			lookup = new Array2(cols, rows);
			for (var x:int = 0; x < cols; x++) {
				for (var y:int = 0; y < rows; y++) {
					var visionSquare:AxSprite = new AxSprite(x * 32, y * 32, Core.lib.int.img_vision_tiles, 32, 32);
					lookup.set(x, y, visionSquare);
					visionSquare.alpha = 0.7;
					visionSquare.visible = false;
					add(visionSquare);
				}
			}
		}
		
		public function clearVision():void {
			_isDirty = false;
			if (_lastTiles.length == 0) {
				return;
			}
			var len:int = _lastTiles.length;
			for (var i:int = len; i--; i >= 0) {
				var tile:AxSprite = _lastTiles[i];
				tile.visible = false;
			}
			_lastTiles.length = 0;
		}
		
		public function showVisionCone($points:HashMap,$entity:AxEntity):void {
			if (_entitiesLookup[$entity]) {
				clearVisionCone(_entitiesLookup[$entity]);
			}
			_entitiesLookup[$entity] = $points;
			var itterator:IIterator = $points.iterator();
			var pointData:ShadowPoint;
			while (pointData = itterator.next()) {
				showVision(pointData);
			}
		}
		
		public function showVision($point:ShadowPoint):void {
			var tile:AxSprite = lookup.get($point.x, $point.y) as AxSprite;
			tile.visible = true;			
		}
		
		public function clearVisionCone($points:HashMap):void {
			var pointData:ShadowPoint;
			var itterator:IIterator = $points.iterator();
			while (pointData = itterator.next()) {
				removeVision(pointData);
			}
		}
		
		private function removeVision($point:ShadowPoint):void 
		{
			var tile:AxSprite = lookup.get($point.x, $point.y) as AxSprite;
			tile.visible = false;
			tile.show(int(8 * $point.intensity));
		}
		
		public function isDirty():Boolean
		{
			return _isDirty;
		}
		
	}

}