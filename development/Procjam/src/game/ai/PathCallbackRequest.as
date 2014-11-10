package game.ai 
{
	import be.dauntless.astar.basic2d.Map;
	import be.dauntless.astar.core.IAstarTile;
	import be.dauntless.astar.core.PathRequest;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class PathCallbackRequest extends PathRequest
	{
		
		public var callback:Function;
		public var params:Array;
		
		public function PathCallbackRequest($start : Point, $end : Point, $map : Map, $priority : uint = 10) 
		{
			var start:IAstarTile = IAstarTile( $map.getTileAt($start))
			var end:IAstarTile = IAstarTile($map.getTileAt($end))
			super(start, end, $map, priority);
			
		}
		
	}

}