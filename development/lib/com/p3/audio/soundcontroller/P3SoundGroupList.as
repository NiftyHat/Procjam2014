package com.p3.audio.soundcontroller 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Duncan Saunders - PlayerThree 2012
	 */
	public class P3SoundGroupList 
	{
		
		private var _groupDictionary	:Dictionary = new Dictionary ();
		private var _groupVec			:Vector.<P3SoundGroup>;
		
		public function P3SoundGroupList() 
		{
			_groupDictionary = new Dictionary ();
			_groupVec = new Vector.<P3SoundGroup>;
		}
		
		
		public function addGroup ($key:String):P3SoundGroup
		{
			var key:String = $key;
			var stored_group:P3SoundGroup = _groupDictionary[key];
			if (stored_group != null)
			{
				trace("P3SoundManager - Group already exists");
				return stored_group;
			}
			stored_group = new P3SoundGroup (key);
			_groupDictionary[stored_group.key] = stored_group;
			_groupVec.push(stored_group);
			return stored_group;
		}
		
		public function hasGroup($key:String):Boolean
		{
			var stored_group:P3SoundGroup = _groupDictionary[$key];
			return (stored_group != null);
		}
		
		public function getGroup($key:String):P3SoundGroup
		{
			var stored_group:P3SoundGroup = _groupDictionary[$key];
			if (stored_group == null)
			{
				trace("P3SoundManager - No group with key [" + $key +  "] , making a new one!");
				return addGroup($key);
			}
			return stored_group;
		}
		
		public function get list ():Vector.<P3SoundGroup>
		{
			return _groupVec;
		}
		
	}

}