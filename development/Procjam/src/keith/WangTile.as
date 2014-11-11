package keith
{
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class WangTile 
	{
		
		public var id:int;
		public var leftSet:int;
		public var rightSet:int;
		public var bottomSet:int;
		public var topSet:int;
		
		public function WangTile(id:int, top:int, right:int, bottom:int, left:int ) 
		{
			this.id = id;
			this.topSet = top;
			this.rightSet = right;
			this.bottomSet = bottom;
			this.leftSet = left;
		}
		
		
		
	}

}