package utils.iterators 
{
	
	/**
	 * ...
	 * @author James Tarling
	 */
	public interface IIterator 
	{
		function reset():void;
		function next():*;
		function hasNext():Boolean;	
	}
	
}