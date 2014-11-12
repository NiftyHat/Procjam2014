package keith
{
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class ShadowPoint 
	{
		public var x:uint = 0;
		public var y:uint = 0;
		private var _intensity:Number = 0;
		
		public function ShadowPoint(x:uint, y:uint, intensity:Number) 
		{
			this.x = x;
			this.y = y;
			this.intensity = intensity;
			
		}
		
		public function get intensity():Number 
		{
			return _intensity;
		}
		
		public function set intensity(value:Number):void 
		{
			if (value > 1) value = 1;
			if (value < 0) value = 0;
			_intensity = value;
		}
		
	}

}