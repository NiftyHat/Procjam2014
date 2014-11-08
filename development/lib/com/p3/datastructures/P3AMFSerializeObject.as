package com.p3.datastructures 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3AMFSerializeObject
	{
		
		protected var m_class_def:Class;
		protected var m_template:Object = { };
		
		public function P3AMFSerializeObject() 
		{
			m_class_def = Object(this).constructor
		}
		
		public function addSavedProperty($name:String, $default:*):void
		{
			if (hasProperty($name))
			{
				m_template[$name] = $default;
			}
			
		}
		
		private function hasProperty ($name:String):Boolean
		{
			try
			{
				this[$name]
			}
			catch (e:Error)
			{
				//trace(e);
				return false;
			}
			return true;
		}
		
		public function save():Object 
		{
			var copy:* = {};
			for (var key:String in m_template)
			{
				//trace("WRITING " + key);
				if (hasProperty(key)) m_template[key] = this[key];
			}
			return m_template;
		}
		
		public function load($object:Object):void 
		{
			var source:* = $object;
			for (var key:String in source)
			{
				if (hasProperty(key))
				{
					this[key] = source[key];
				}
			}
		}
		
	}

}