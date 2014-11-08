package org.flixel.plugin.eventbus 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class SignalBus 
	{
		
		var m_map:Dictionary;
		
		public function SignalBus() 
		{
			
		}
		
		public function dispatchSignal ($signal:Signal):void
		{
			
		}
		
		public function addSignalListener ($name:String, $function:Function):void
		{
			m_map[$name]
		}
		
	}

}