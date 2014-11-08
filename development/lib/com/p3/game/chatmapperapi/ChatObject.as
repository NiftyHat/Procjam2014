/**
 * ...
 * @author Adam
 */

package com.p3.game.chatmapperapi 
{
	import flash.utils.Dictionary;
	
	public class ChatObject 
	{
		public static const ACTOR					:String = "actor";
		public static const ITEM					:String = "item";
		public static const LOCATION				:String = "location";
		
		private var _xml							:XML;
		private var _type							:String;
		private var _id								:int;
		private var _name							:String;
		private var _fields							:Dictionary;
		
		//public var fields							:Dictionary;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function ChatObject(xml:XML, type:String) 
		{
			_xml 	= xml;
			_type 	= type;
			_id 	= _xml.@ID;
			_name 	= _xml..Field.(Title == "Name").Value.toString();
			_name 	= _name.replace(/\s/g, "_");// replace "spaces" in name with "_".
			
			_fields = new Dictionary();
			for each (var i:XML in _xml.*.Field)
			{
				var name:String = i.Title.toString();
				var value:String = i.Value.toString();
				
				value = value.replace(/true/gi, "true");
				value = value.replace(/false/gi, "false");
				
				_fields[name] = value;			
			}
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		public function toString():String 
		{
			var fieldsDictStr:String = "{";
			for (var i:String in _fields)
			{
				fieldsDictStr += " " +i;
				fieldsDictStr += ":" + _fields[i];			
			}
			fieldsDictStr += "}";
			
			return "[ChatObject type=" + _type + " id=" + _id + " name=" + _name + " fields=" + fieldsDictStr + "]";
		}
		
		public function get xml():XML 			{	return _xml;	}
		
		public function get type():String 		{	return _type;	}
		
		public function get id():int 			{	return _id;		}
		
		public function get name():String 		{	return _name;	}
		
		public function get fields():Dictionary 
		{
			return _fields;
		}
		//
		//public function set fields(value:Dictionary):void 
		//{
			//_fields = value;
		//}
		
		//public function get fields():Dictionary {	return _fields;	}
	}

}