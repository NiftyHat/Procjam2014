package axengine.util.ray 
{
	import org.axgl.AxEntity;
	import org.axgl.AxPoint;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxRayResult 
	{
		
		public var point:AxPoint;
		public var path:Vector.<AxPoint>;
		public var entity:AxEntity;
		public var blocked:Boolean;
		
		public function AxRayResult() 
		{
			point = new AxPoint;
		}
		
		public function get lastPoint ():AxPoint {
			if (path && path.length > 0) {
				return path[path.length - 1];
			}
			return null;
		}
		
	}

}