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
		public var entity:AxEntity
		
		public function AxRayResult() 
		{
			point = new AxPoint;
		}
		
	}

}