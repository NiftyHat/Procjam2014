package axengine.world.level 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxLevelHeader 
	{
		protected var m_key:String = "unknown";
		protected var m_name:String = "unknown";
		protected var m_style:String = "unknown";
		protected var m_source:String = "???";
		protected var m_index:int = 0;
		
		protected var m_unlock_req:String;
		
		//DEV STUFF;
		protected var m_author:String = "unknown";
		protected var m_development:String;
		
		public function AxLevelHeader() 
		{
			
		}
		
		public function init($key:String):void
		{
			var xml:XML = Core.xml.getLevelHeaderXML($key)
			m_key = xml.ID.@key.toString();
			m_name = xml.ID.@name.toString();
			m_index = int(xml.ID.@index);
		}
		
		public function get key():String { return m_key; }
		
		public function get name():String { return m_name; }
		
		public function get index():int { return m_index; }
		
		public function get unlock_req():String { return m_unlock_req; }
		
		public function get author():String { return m_author; }
		
		public function get development():String { return m_development; }	

		
	}

}