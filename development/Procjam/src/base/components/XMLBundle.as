package base.components 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class XMLBundle 
	{
		
		public var copy:XML;
		public var game:XML;
		public var config:XML;
		public var entities:XML;
		public var dialogue:XML;
		public var levels:XML;
		public var anims:XML;
		
		public function XMLBundle() 
		{
			
		}
		
		public function init():void 
		{
			
		}
		
		public function getLevelHeaderXML($key:String):XML 
		{
			return XML(levels.*.(ID.@key == $key));
		}
		
		public function getAnimationsXML ($name:String):XML
		{
			if (!anims) return null;
			var xml_list:XMLList = anims.child($name).ANIMS;
			if (!xml_list || xml_list.length() == 0) 
			{
				//trace("no anims for " + $name);
				return null;
			}
			return XML(xml_list);
		}
		
	}

}