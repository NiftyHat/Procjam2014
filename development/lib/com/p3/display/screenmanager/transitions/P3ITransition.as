/**
 * ...
 * @author Adam
  * VERSION 0.0.1;
 * 
 * All transitions need to implement this interface.
 */

package com.p3.display.screenmanager.transitions
{	
	import com.p3.display.screenmanager.P3IScreen;
	import flash.display.Sprite;
	
	public interface P3ITransition 
	{	
		/**
		 * Called from the P3ScreenManager. Passes in all the variables that are needed
		 */
		function init(oldScreen:P3IScreen, screen:P3IScreen, display:Sprite, replace:Boolean, replaceGroups:Array, replaceAll:Boolean):void;		
		
		/**
		 * Called from the P3ScreenManager. Starts the transition in.
		 */
		function transitionIn():void
		
		/**
		 * Called from the P3ScreenManager. Starts the transition out.
		 */
		function transitionOut():void
		
		/**
		 * Called from the P3ScreenManager for any custom cleaning.
		 */
		function destroy():void	
		
		
		function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
		function removeEventListener (type:String, listener:Function, useCapture:Boolean = false):void;
		
	}	
}