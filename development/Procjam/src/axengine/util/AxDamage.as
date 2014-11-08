package axengine.util 
{
	import org.axgl.AxEntity;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxDamage 
	{
		
		public var amount:int = 0;
		protected var _source:AxEntity;
		protected var _destination:AxEntity;
		
		public function AxDamage($amount:int,$source:AxEntity,$destination:AxEntity) 
		{
			amount = $amount;
			_source = $source;
			_destination = $destination;
		}
		
		public function get source():AxEntity 
		{
			return _source;
		}
		
		public function get destination():AxEntity 
		{
			return _destination;
		}
		
	}

}