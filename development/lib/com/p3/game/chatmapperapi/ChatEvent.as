/**
 * ...
 * @author Adam
 */

package com.p3.game.chatmapperapi 
{
	import flash.events.Event;
	
	
	public class ChatEvent extends Event 
	{
		public static const SHOW_DIALOGUE			:String = "show_dialogue";
		public static const SHOW_DECISION			:String = "show_decision";
		static public const SHOW_FINAL_DIALOGUE		:String = "show_final_dialogue";
		public static const FINISHED				:String = "finished";// dont think we need this...
		static public const FAILED_CONDITIONS		:String = "failed_conditions";
		static public const SCRIPT					:String = "script";
		
		private var _node			:ChatNode;
		private var _linkNodes		:Vector.<ChatNode>;
		private var _scripts		:Vector.<String>;
		
		public function ChatEvent(type:String, node:ChatNode = null, linkNodes:Vector.<ChatNode> = null, scripts:Vector.<String> = null, bubbles:Boolean = false, cancelable:Boolean = false) 		
		{ 
			_node 		= node;
			_linkNodes 	= linkNodes;
			_scripts	= scripts
			super(type, bubbles, cancelable);			
		} 
		
		public override function clone():Event 
		{ 
			return new ChatEvent(type, node, linkNodes, _scripts, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ChatEvent", "type", "node", "linkNodes", "scripts", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * Returns the ChatNode. This containd the dialogue etc...
		 */
		public function get node():ChatNode
		{
			return _node;
		}
		
		/**
		 * Returns a list of ChatNode. These are available for decissions. 
		 * Use "menutext" to access their decision copy.
		 */
		public function get linkNodes():Vector.<ChatNode>
		{
			return _linkNodes;
		}
		
		
		/**
		 * Returns a list of scripts that are on the ChatNode. These are process automatically but you could do custom parsing based upon them which is why they are available.
		 * Use "menutext" to access their decision copy.
		 */
		public function get scripts():Vector.<String>
		{
			return _scripts;
		}
		
		
	}
	
}