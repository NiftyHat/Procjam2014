package keith.utils 
{
	
	/**
	 * ...
	 * @author James Tarling
	 */
	public interface IArrayData 
	{
		function getAt(index:int):*;
		function indexOf(value:*):int;
		function count():int;
		function cloneData ():Array;
		function toString ():String;
	}
	
}