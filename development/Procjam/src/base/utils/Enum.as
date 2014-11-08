package base.utils 
{
	import flash.utils.describeType;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class Enum extends Object
	{
		public static function InitEnumConstants(inType :*):void {
			 var type :XML = describeType(inType);
			for each (var constant :XML in type.constant)
			{
				inType[constant.@name].Text = constant.@name;
			}
		}
		
		public static function InitFromString (inType:*, string:String):Enum {
			if (inType[string]) return inType[string]
			else return null;
		}
		
	}
	

}