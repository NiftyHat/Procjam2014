package com.p3.datastructures.cache 
{
	import com.p3.debug.mincomps.P3MinCompsLog;
	import flash.utils.describeType;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3CacheObject extends Object
	{
		private var _template:Object = { };
		protected namespace cacheVar = "chacheVar";
		
		public function P3CacheObject ()
		{
			super();
			updateTemplate();
		}
		
		public function updateTemplate():void
		{
			use namespace cacheVar;
			//trace("namespace test");
			var dt:XML = describeType(this)
			for each (var item:XML in dt.accessor)
			{
				var keyName:String = item.@name.toString();
				if (!_template.hasOwnProperty(keyName) && this.hasOwnProperty(keyName))
				{
					try
					{
						_template[keyName] = this.cacheVar::[keyName];
						
					}
					catch (e:Error)
					{
						continue;
					}
					
				}
			}
			//for (var key:String in this)
			//{
				//trace()
			//}
		}
		
		public function reset ():void
		{
			for (var key:String in _template)
			{
				//trace("SAVINGS " + key + " as " + m_template[key] );
				if (this.cacheVar::[key]) 
				{
					this.cacheVar::[key] = _template[key];
				}
			}
		}
		
		public function save():* 
		{
			var copy:* = {};
			for (var key:String in _template)
			{
				//trace("SAVINGS " + key + " as " + m_template[key] );
				if (this.cacheVar::[key]) 
				{
					_template[key] = this.cacheVar::[key];
				}
			}
			return _template;
		}
		
		public function load($object:*):void 
		{
			use namespace cacheVar;
			var source:* = $object;
			for (var key:String in source)
			{
				if (this.hasOwnProperty(key))
				{
					this.cacheVar::[key] = source[key];
				}
			}
		}
		
		public function get template():Object 
		{
			return _template;
		}
		
		public function set template(value:Object):void 
		{
			_template = value;
		}
		
	}

}