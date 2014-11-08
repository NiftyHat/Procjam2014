package axengine.util 
{
	import org.axgl.util.AxRange;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxPercRange extends AxRange 
	{
		
		public function AxPercRange(min:Number, max:Number) 
		{
			super(min, max);
			
		}
		
		public function perc($value:Number):Number {
			var range:int = max - min;
			if ($value > range) $value = range;
			if ($value < min) $value = min;
			var perc:Number = (1.0 / range ) * ($value - min);
			return perc;
		}
		
	}

}