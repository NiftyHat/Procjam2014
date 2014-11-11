package utils 
{
	/**
	 * ...
	 * @author James Tarling
	 */
	public class Enum
	{
		private var value:*;
		
		public function Enum(value:*) 
		{
			this.value = value;
		}
		
		public function toString():String {
			return value.toString();
		}
		
	}

}