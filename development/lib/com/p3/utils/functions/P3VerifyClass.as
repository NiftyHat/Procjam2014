package com.p3.utils.functions 
{
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public function P3VerifyClass ($className:String):Boolean
	{
		var className:String =  $className
		var cls:Class
		if (className == "" ) 
		{
			trace("no string for class name");
			return false;
		}
		if (className == null) 
		{
			trace("class name cannot be null");
			return false;
		}
		if (Capabilities.isDebugger)
		{
			try
			{
				cls = getDefinitionByName(className) as Class
			}
			catch (e:Error)
			{
				trace("couldn't construct source class for: " + className + " make sure the path is correct and the swc is fully embeded with include all or the class is included in your application ");
				trace(e.message);
				return false;
			}
			return true;
		}
		else
		{
			cls = getDefinitionByName(className) as Class
			if (cls) return true;
			return false;
		}
		
		
	}
}