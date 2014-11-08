/**
 * ...
 * @author Adam
  * VERSION 0.0.1;
 */

package com.p3.display.screenmanager.transitions 
{
	import com.p3.display.screenmanager.P3IScreen;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class P3TransitionEvent extends Event 
	{
		public static const TRANSITION_IN_COMPLETE	:String = "transition_in_complete";
		public static const TRANSITION_OUT_COMPLETE	:String = "transition_out_complete";	
		
		public var newScreen						:P3IScreen;
		public var oldScreen						:P3IScreen;
		public var holder							:Sprite
		public var replace							:Boolean;
		public var replaceGroups					:Array;
		public var replaceAll						:Boolean;
		
		public function P3TransitionEvent(type:String, oldScreen:P3IScreen, newScreen:P3IScreen, holder:Sprite, replace:Boolean, replaceGroups:Array, replaceAll:Boolean, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.oldScreen 		= oldScreen;
			this.newScreen 		= newScreen;
			this.holder 		= holder;
			this.replace 		= replace;
			this.replaceGroups 	= replaceGroups;
			this.replaceAll 	= replaceAll;
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new P3TransitionEvent(type, oldScreen, newScreen, holder, replace, replaceGroups, replaceAll, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("P3TransitionEvent", "type", "oldScreen", "newScreen", "holder", "replace", "replaceGroups", "replaceAll", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}	
}