/**
 * ...
 * @author Adam
 * VERSION 1.0.0;
 */

package com.p3.display.screenmanager
{	
	public interface P3IScreen
	{			
		/**
		 * Load all of the data and graphics that this scene needs to function.
		 */
		function load() :void;
		
		/**
		 * Unload everything that the garbage collector won't unload itself, including graphics.
		 */
		function unload() :void;

		
		/**
		 * Called when the screen has been added to the displaylist. (After "load").
		 */
		function init() :void;
		
		/**
		 * The group the screen belongs too.
		 */
		function set groupName(value:String):void 
		function get groupName():String;
		
		
		
		/**
		 * If the screen has been loaded.
		 */
		function get isLoaded():Boolean;
		
		
		function get name():String;
		
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