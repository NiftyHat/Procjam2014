/**
 * ...
 * @author Adam
 */

package com.p3.game.chatmapperapi 
{
	import flash.utils.Dictionary;
	
	public class ChatNode
	{
		public static const SIM_STATUS_WAS_DISPLAYED :String = "WasDisplayed";
		public static const SIM_STATUS_NOT_DISPLAYED :String = "notDisplayed";
		
		public var status							:String;
		
		private var _xml							:XML;
		private var _id								:int;
		private var _fields							:Dictionary;
		private var _links							:Vector.<Number>;
		private var _isGroup						:Boolean;
		private var _dialogue						:String;		
		private var _menutext						:String;		
		private var _title							:String;
		private var _actor							:String;
		private var _conversant						:String;
		private var _audiofiles						:String;		
		private var _conversationID					:int;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function ChatNode(xml:XML) 
		{
			_xml = xml;	
			status = SIM_STATUS_NOT_DISPLAYED;
			
			parseXML();			
		}		
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/	
		
		/** 
		 * Sets the display status to "WasDisplayed" when a node is used.
		 */ 
		public function activate():void 
		{
			status = ChatNode.SIM_STATUS_WAS_DISPLAYED;
		}		
		
		public function destroy():void
		{
			_fields = new Dictionary();
			_links = new Vector.<Number>();
			_xml = null;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Extracts the xml for easier reference. Stores all the "Fields" in the "_fields" dictionary. 
		 * Also stores the core values to tehir own varibles.
		 */
		private function parseXML():void 
		{			
			_id 			= int(xml.@ID);
			_conversationID	= int(_xml.@ConversationID);			
			if (_xml.@IsGroup == "true") _isGroup = true;				
			
			// FIELDS - these will be in all  dialogues so can be saved for easy reference.
			// They will also be added to the "fields" dictionary as well as custom fields.
			_title 		= _xml.*.Field.(Title == "Title").Value.toString();
			_actor		= _xml.*.Field.(Title == "Actor").Value.toString();
			_conversant	= _xml.*.Field.(Title == "Conversant").Value.toString();
			_dialogue	= _xml.*.Field.(Title == "Dialogue Text").Value.toString();
			_menutext	= _xml.*.Field.(Title == "Menu Text").Value.toString();
			_audiofiles = _xml.*.Field.(Title == "Audio Files").Value.toString();
			
			var i:XML;
			
			// FIELDS
			_fields = new Dictionary();
			for each (i in _xml.*.Field)
			{
				var name:String = i.Title.toString();
				var value:String = i.Value.toString();	
				_fields[name] = value;			
				//trace("FIELD- name:"+ name, ", value:"+ value);
			}
			
			// LINKS
			_links = new Vector.<Number>();			
			for each (i in _xml.*.Link)
			{
				if(int(i.@DestinationConvoID) == _conversationID)
					_links.push(int(i.@DestinationDialogID));
			}				
			// Sort link priority
			if (_links.length > 1)
			{
				var childNodes:Vector.<XML> = new Vector.<XML>();
				for (var j:int = 0; j < _links.length; j++) 
				{
					var linkID:int = _links[j];				
					//var childXML:XML = ChatMapper.inst.xml..Conversation[_xml.@ConversationID - 1].DialogEntries.DialogEntry.(@ID == linkID)[0];
					var childXML:XML = ChatMapper.inst.xml..Conversation.(attribute("ID") == _xml.@ConversationID).DialogEntries.DialogEntry.(attribute("ID") == linkID)[0];
					childNodes.push(childXML);
				}
				
				if(childNodes.length >0)
					childNodes.sort(ChatTools.sortPriority);				
				
				_links = new Vector.<Number>();
				for each (i in childNodes)
				{
					_links.push(int(i.@ID));
				}
			}
		}		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		/** The ChatNodes ID	*/
		public function get id():int 		
		{	
			return _id;	
		}		
		
		/** The raw "DialogEntry" xml from the Chat Mapper export.	*/
		public function get xml():XML 		{	return _xml;	
		}
		
		/** The string/copy that the Actor is saying 	*/
		public function get dialogue():String 		
		{	
			return _dialogue;	
		}	
		
		/** The string to be used when displaying a decision option 	*/
		public function get menutext():String 		
		{	
			return _menutext;	
		}
		
		/** If true means the Node represents a group of child nodes that the user will have to choose from.	*/		
		public function get isGroup():Boolean 		
		{	
			return _isGroup;	
		}
		
		/** A list/vector of node ID's that the ChatNode can potentially link too.	*/
		public function get links():Vector.<Number> 	
		{	
			return _links;	
		}
		
		/** The is the title of the ChatNode, not really needed but can help debug	*/
		public function get title():String 	
		{	
			return _title;	
		}
		
		/** This returns a Dictionary of all the node 'fields'/properties. Here is where you will find the custom ones too.	 */
		public function get fields():Dictionary 		
		{			
			return _fields;		
		}		
		
		/** The name of the actor who is speaking */
		public function get actor():String 		
		{			
			return _actor;		
		}
		
		/** The name of the recipient of the conversation */
		public function get conversant():String 		
		{	
			return _conversant;		
		}
		
		/** Url of the audio files */
		public function get audiofiles():String 		
		{	
			return _audiofiles;		
		}
		
		/** The conversation ID */
		public function get conversationID():int 	
		{	
			return _conversationID;		
		}		
		
		
		public function toString():String 
		{
			return "[ChatNode id=" + id + " status=" + status + " isGroup=" + isGroup + " links=" + links + " menutext=" + menutext + " title=" + title + " dialogue=" + dialogue +"]";
		}
		
		public function fieldsToString():String 
		{
			var str:String = "[ChatNode] fields= {";
			for (var i:* in _fields)
			{
				str += i;
				str += ":" + _fields[i] + ", ";
			}
			str = str.substr(0, str.length - 1);
			str += "}";
			return str;
		}
		
	}

}