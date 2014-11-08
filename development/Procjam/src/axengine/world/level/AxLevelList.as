package axengine.world.level 
{
	import axengine.events.AxLevelEvent;
	import flash.globalization.StringTools;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxLevelList 
	{
		
		protected var _map:Dictionary;
		protected var _vec:Vector.<AxLevel>
		
		public function AxLevelList() 
		{
			reset();
		}
		
		private function reset():void 
		{
			_map = new Dictionary ();
			_vec = new Vector.<AxLevel> ();
		}
		
		public function add($axLevel:AxLevel):AxLevel { 
			
			var key:String = $axLevel.key
			var curLevel:AxLevel = _map[key];
			if (curLevel) {
				trace("already has level at " + key);
				return curLevel;
			}
			_map[key] = $axLevel;
			_vec.push($axLevel);
			return $axLevel;
		}
		
		private final function getByKey($key:String):AxLevel {
			var key:String = $key;
			var curLevel:AxLevel = _map[key];
			if (curLevel) return curLevel;
			trace ("no AxLevel at key: "  + key);
			return null;
		}
		
		private final function getByID($id:uint):AxLevel {
			var id:int = $id;
			if (id < 0) {
				id = 0;
			}
			if (id > _vec.length) {
				trace("id " + $id + " is out of range")
				return null;
			}
			var curLevel:AxLevel = _vec[id];
			if (curLevel) return curLevel;
			trace ("no AxLevel at id: "  + id);
			return null;
		}
		
		public function get ($key:String):AxLevel {
			var key:String = $key;
			var regexp_word:RegExp = /\D/
			if (key.match(regexp_word)) {
				return getByKey(key);
			}
			var id:int = int(key);
			return getByID(id);
		}
		
	}

}