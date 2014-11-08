/**
 * All method calls are called from the ScreenManager.
 *
 * @author Adam H
 */

package com.p3.starling.display.screenmanager
{
	public interface P3IScreen
	{

/*-------------------------------------------------
 * PUBLIC FUNCTIONS
 -------------------------------------------------*/

		/**
		 * Called once the screen has be added to the display.
		 */
		function init():void

		/**
		 * Called when the screen has animated in and is ready to use.
		 */
		function start():void

		/**
		 * Called once the screen has been added to the stage after "init".
		 */
		function transitionIn():void;

		/**
		 * Called once When the screen is being removed.
		 */
		function transitionOut():void;

		/**
		 * Called once When the transition 'in' is complete.
		 */
//		function transitionInComplete():void;

		/**
		 * Called once When the transition 'out' is complete.
		 */
//		function transitionOutComplete():void;

		/**
		 * Called once the screen has animated out and is ready to be removed.
		 */
		function dispose():void;

		/**
		 * Not used by default but can be used to setup and update.
		 */
		function update(delta:Number = 0):void;

		function addEventListener(eventType:String, onCurrentScreenTransitionsOutComplete:Function):void;
		function removeEventListener(eventType:String, method:Function):void;


/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/

		/**
		 * The group the screen belongs too.
		 */
		function set groupName(value:String):void
		function get groupName():String;

		/**
		 * If the screen is ready to be used.
		 */
		function get isReady():Boolean;

		function set transitionOject(value:P3ScreenObject):void
		function get transitionOject():P3ScreenObject


		/**
		 * Name of the screen
		 */
		function get name():String;
		function set name(value:String):void;

		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function set alpha($value:Number):void
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
	}
}
