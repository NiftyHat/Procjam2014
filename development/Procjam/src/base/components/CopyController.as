package base.components 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class CopyController 
	{
		
		protected var _copyDictionary:Dictionary;
		protected var _lang:String;
		
		private var _lipsum:String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et orci vel felis congue viverra a vitae eros. Etiam magna mi, commodo at lobortis quis, aliquam nec eros. Quisque facilisis augue libero, in iaculis mi. Donec est lectus, bibendum eget placerat non, fringilla sed ante. Integer dapibus metus at risus porta blandit rutrum justo eleifend. Maecenas blandit lorem nec urna rhoncus lacinia. Sed vestibulum libero porta augue rutrum eget pulvinar massa congue. Vestibulum nec mi dolor. Curabitur arcu massa, facilisis non tristique sit amet, bibendum cursus ligula. Nullam eget convallis orci."
		
		public function CopyController() 
		{
			_copyDictionary = new Dictionary ();
			//setLanguage();
		}
		
		protected function parseXML ($xml:XML):void
		{
			if (!$xml) return;
			for each (var item:XML in $xml.*)
			{
				
				var key:String = item.name();
				var copy:String = item.toString();
				if (copy)
				{
					if (_copyDictionary[key])
					{
						trace("warning, overwriting " + _copyDictionary[key] + " with copy " + copy);
					}
					_copyDictionary[key] = item.toString();
				}
				else if (item.length() > 1)
				{
					parseXML($xml);
					continue;
				}
			}
		}
		
		public function setLanguage($key:String = "en"):void
		{
			_lang = $key;
			if (!Core.xml.copy) 
			{
				trace("no copy to use");
				return;
			}
			if (Core.xml.copy.length() == 0) 
			{
				trace("copy file is empty");
				return;
			}
			parseXML(Core.xml.copy);
		}
		
		public function lipsum():String
		{
			return _lipsum;
		}
		
		public function read($key:String):String
		{	
			if (!_lang) setLanguage();
			if (_copyDictionary[$key])
			{
				return _copyDictionary[$key];
			}
			return "<"  + $key + ">";
		}
		
	}

}