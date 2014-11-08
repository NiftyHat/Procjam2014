/**
 * ...
 * @author Adam
 */

package com.p3.game.chatmapperapi 
{
	import flash.utils.Dictionary;
	
	public class ChatConversation 
	{
		private var _xml							:XML;
		private var _type							:String;
		private var _id								:int;
		private var _name							:String;
		private var _nodes							:Vector.<ChatNode>;
		private var _currNode						:ChatNode;
		private var _fields							:Dictionary;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function ChatConversation(xml:XML) 
		{
			_xml 	= xml;
			_id 	= xml.@ID;
			_name 	= xml.*.Field.(Title == "Title").Value.toString();
			
			var i:XML;
			
			_nodes = new Vector.<ChatNode>();
			for each (i in _xml..DialogEntry)
			{
				_nodes.push(new ChatNode(i));
			}			
			
			// FIELDS
			_fields = new Dictionary();
			for each (i in _xml.*.Field)
			{
				var name:String = i.Title.toString();
				var value:String = i.Value.toString();				
				_fields[name] = value;
			}
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function lookUpNode(searchID:int):ChatNode
		{
			if (searchID < 0) 
			{
				// log error.
				return null;
			}
			
			//_currNode = _nodes[searchID];
			var len:int = _nodes.length;
			for (var i:int = 0; i < len; i++) 
			{
				var node:ChatNode = _nodes[i];
				
				if (node.id == searchID)
				{
					_currNode = node;
					return _currNode;
				}
			}
			
			// log error.
			return null;
		}		
		
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
			return "[ChatConversation id=" + _id + " name=" + _name + "\n dialogues=" + _nodes+ "]";
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get nodes():Vector.<ChatNode> 
		{
			return _nodes;
		}
		
		public function get currNode():ChatNode 
		{
			return _currNode;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get xml():XML 
		{
			return _xml;
		}
		
		public function get fields():Dictionary 
		{
			return _fields;
		}
		
	}

}