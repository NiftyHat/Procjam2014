/**
 * First attempt at managing the export from chat mapper. Theres a lot of object classes, these 
 * may not be needed as could be simply stored in an array. WIll look to simplify things later.
 * 
 * Call showConversation with the conversaation id. THis will dispatch an event with the conversation node as a param.
 * You can then access all the infor from the conversation node.
 * 
 * TODO: ChatMapper
 * - Implement "|" to split dialogue into separate ChatNodes.
 * - Do more with the scripting
 * - Parse "block" and "passthrough".
 * - Probable a whole lot more...
 * 
 * @usage: 
 * var chatmapper:ChatMapper = new Chatmapper();
 * chatmapper.addEventListener(ChatEvent.SHOW_DIALOGUE, onDialogue);
 * chatmapper.addEventListener(ChatEvent.SHOW_FINAL_DIALOGUE, onFinalDialogue);
 * chatmapper.addEventListener(ChatEvent.SHOW_DECISION, onDecision);
 * chatmapper.addEventListener(ChatEvent.FINISHED, onChatFinished);
 * chatmapper.addEventListener(ChatEvent.FAILED_CONDITIONS, onFailedConditions);
 * chatmapper.init(XML);
 * chatmapper.showConversation(1);
 * 
 * @author Adam
 * @version 00.00.01.
 * @date: 03.05.12.
 */



package com.p3.game.chatmapperapi
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;	
	
	[Event(name="dialogue", type="com.p3.game.chatmapper.ChatEvent")] 
	[Event(name="decision", type="com.p3.game.chatmapper.ChatEvent")] 
	[Event(name="finished", type="com.p3.game.chatmapper.ChatEvent")] 
	
	public class ChatMapper extends EventDispatcher 
	{			
		private static var 	instance				:ChatMapper;
		private static var 	allowInstance			:Boolean;
		
		public var isDebug							:Boolean;
		
		public var conversationDict					:Dictionary;
		public var locationDict						:Dictionary;
		public var itemDict							:Dictionary;
		public var actorDict						:Dictionary;		
		public var userVariableDict					:Dictionary;
		
		private var _xml							:XML;
		private var _currentConversation			:ChatConversation;
		private var _conversationID					:int;		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

		public function ChatMapper() 
		{		
			if (!ChatMapper.allowInstance)
			{
				throw new Error("Error: Use ChatMapper.inst instead of the 'new' keyword.");
			}		
		}
		
		public static function get inst():ChatMapper
		{
			if (ChatMapper.instance == null)
			{
				ChatMapper.allowInstance	= true;
				ChatMapper.instance		= new ChatMapper();
				ChatMapper.allowInstance	= false;
			}
			return ChatMapper.instance;
		}	

/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Parses the supplied xml into converstations with chatnodes and chatobjects.
		 * @param	xml:XML exported from Chat-Mapper.
		 */
		public function init(xml:XML):void
		{
			_xml = xml;
			parseXML();
		}
		
		
		/**
		 * Selects the conversation based upon the ID and then will call showDialogue() 
		 * method to dispatch the events related to displaying the dialogue.
		 * @param	id
		 */
		//public function showConversation(id:int = 1):void
		public function showConversation(id:int = 0):void
		{			
			_conversationID = id;
			_currentConversation = conversationDict[_conversationID];
			if (_currentConversation) 
				showDialogue();
			else
				throw new Error("There is not Conversation. The 'ID' supplied is probably wrong.");
		}
		
		
		/**
		 * This is the mega method. It finds the node based upon the "id", check if the node has a sinle link or is a "group".
		 * It then checks the node links (regardless of the number) fro their conditions. If met adds the lnk node to a list.
		 * The node itself is then checked, if it passes its conditions it can be dispatched. If it is singuar a "DIALOGUE" is
		 * dispathced, if a group, a "DECISION" is dispatched and if it is the final node a "FINAL_DIALOGUE" is dispatched.
		 * 
		 * @param	id: the id the next dialogue/chatnode.
		 */
		public function showDialogue(id:int = 1):void
		{
			var node:ChatNode = _currentConversation.lookUpNode(id);			
			if (node)
			{	
				// 1. Run custom scripts. Dispatch this for user cusomisation.
				var scripts:Vector.<String> = ChatTools.runScripts(node);
				dispatchEvent(new ChatEvent(ChatEvent.SCRIPT, node, null, scripts));
				
				// 2. CHeck links for condititions.
				var linkNodes:Vector.<ChatNode> = new Vector.<ChatNode>();
				for (var i:int = 0; i < node.links.length; i++) 
				{
					var linkNode:ChatNode = _currentConversation.lookUpNode(node.links[i]);
					if (ChatTools.testConditions(linkNode))
					{
						linkNodes.push(linkNode);
					}			
				}
				
				// 3. Check if node is a group/decision or not.
				if (ChatTools.testConditions(node))
				{
					if (!node.isGroup)
					{
						if (linkNodes.length > 0)
						{
							dispatchEvent(new ChatEvent(ChatEvent.SHOW_DIALOGUE, node, linkNodes));
						}
						else						
						{
							if(isDebug)	trace(this + " Final dialogue node. No link nodes found or conditions met. FINAL_DIALOGUE.");
							dispatchEvent(new ChatEvent(ChatEvent.SHOW_FINAL_DIALOGUE, node, linkNodes));								
						}
					}
					else
					{					
						if (linkNodes.length > 0)
						{	
							dispatchEvent(new ChatEvent(ChatEvent.SHOW_DECISION, node, linkNodes));
						}
						else
						{
							if(isDebug)	trace(this + " No link nodes found or conditions met. FINISHED.");
							dispatchEvent(new ChatEvent(ChatEvent.FINISHED, node, linkNodes));
						}
					}					
				}
				else
				{
					if(isDebug)	trace(this + " The Node that is meant to be displayed failed to pass its conditions. THis should not happen " + "and is either an error in the Dialogue Tree in chatmapper or you are doing someting that The ChatMapper api cant handle.", node);
					dispatchEvent(new ChatEvent(ChatEvent.FAILED_CONDITIONS, node, linkNodes));
				}				
				node.activate();
			}
			else
			{
				if(isDebug)	trace(this + " No Node");
				dispatchEvent(new ChatEvent(ChatEvent.FINISHED));
			}			
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
		/**
		 * Creates vectors of objects fromthe XML.
		 */
		private function parseXML():void 
		{
			actorDict 			= new Dictionary();
			itemDict 			= new Dictionary();
			locationDict 		= new Dictionary();
			conversationDict 	= new Dictionary();
			userVariableDict 	= new Dictionary();
			
			var i:XML;	
			
			for each (i in _xml..Actor)			
			{	
				var actor:ChatObject = new ChatObject(i, ChatObject.ACTOR);
				//actorDict[actor.name] = actor;
				actorDict[actor.id] = actor;
			}
			
			for each (i in _xml..Item)			
			{	
				var item:ChatObject = new ChatObject(i, ChatObject.ITEM);
				itemDict[item.name] = item;
			}
			
			for each (i in _xml..Location)			
			{	
				var location:ChatObject = new ChatObject(i, ChatObject.LOCATION);
				locationDict[location.name] = location;
			}
			
			for each (i in _xml..Conversation)			
			{	
				var conversation:ChatConversation = new ChatConversation(i);
				conversationDict[conversation.id] = conversation;
			}			
			
			for each (i in _xml..UserVariable)
			{	
				var userVariableName:String = i..Field.(Title == "Name").Value.toString();
				var userVariableType:String = i..Field.(Title == "Initial Value").@Type.toString();				
				if (userVariableType == "Number")
				{
					var userVariableValueNum:Number = Number(i..Field.(Title == "Initial Value").Value);
					userVariableDict[userVariableName] = userVariableValueNum;
				}
				else if (userVariableType == "Text")
				{
					var userVariableValueStr:String = i..Field.(Title == "Initial Value").Value.toString();
					userVariableDict[userVariableName] = userVariableValueStr;
				}
			}
		}		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/			
		
		public function get xml():XML 	{	return _xml;	}
		public function get currentConversation():ChatConversation 		{			return _currentConversation;		}
		
		public function get conversationID():int 	{	return _conversationID;	}
		public function get conversationTotal():int 	
		{	
			var n:int = 0;
			for (var i:* in conversationDict)
			{
				n++;
			}
			return n;
		}
		
		
	}
	
}