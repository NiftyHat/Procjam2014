package com.p3.input.recorder 
{
	import com.p3.datastructures.P3AMFSerializeObject;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public dynamic class P3RecorderInfo extends P3AMFSerializeObject
	{
		
		public var m_timestamp:Number
		
		public function P3RecorderInfo() 
		{
			addSavedProperty("m_timestamp", 0);
		}
		
		/* INTERFACE com.p3.input.recorder.P3RecorderInfo */

		public function setTimestamp($number:Number):void 
		{
			m_timestamp = $number;
		}
		
		public function getTimestamp():Number 
		{
			return m_timestamp;
		}
		
		public function getClass():Class 
		{
			return m_class_def;
		}
		
		
		

		
	}

}