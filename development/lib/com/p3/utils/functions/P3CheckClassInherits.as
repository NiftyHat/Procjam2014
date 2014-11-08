package com.p3.utils.functions 
{
	
	/**
	 * Utility function compares two classes and returns true if the first class is inherits from the second.
	 * @author Duncan Saunders
	 */
	public function P3CheckClassInherits($checkedClass:Class,$parentClass:Class):Boolean
	{
		var classA:Class = $parentClass;
		var classB:Class = $checkedClass;
		return classA.prototype.isPrototypeOf(classB.prototype)
	}
	
}