/**
 * P3ScreenGroup is a class that holds a list of screens in a specific group. 
 * It is internal to the SceneManager and access should not be needed...
*/


package com.p3.display.screenmanager 
{
	import flash.display.Sprite;
	
	public class P3ScreenGroup 
	{
		public var display							:Sprite;
		public var screens							:Vector.<P3IScreen>;
		public var groupName						:String;
		
		private var _currentScreen					:P3IScreen;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function P3ScreenGroup(groupName:String)
		{
			this.groupName 	= groupName;		
			screens = new Vector.<P3IScreen>();
			display = new Sprite();
			display.name = groupName;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Adds the screen to the group and its display.
		 * @param	screen
		 * @param	replace
		 */
		public function addScreen(screen:P3IScreen):void
		{
			screens.push(screen);
			screen.load();
			display.addChild(screen as Sprite);
			_currentScreen = screen;
		}
		
		/**
		 * Removes the supplied screen.
		 * @param	screen
		 */
		public function removeScreen(screen:P3IScreen):void
		{
			var index:int = screens.indexOf(screen);			
			if (index != -1)
			{
				destroyScreen(screen);
				screens.splice(index, 1);
			}
		}
		
		/**
		 * Replaces screens based on priority
		 * @param	priority
		 */
		public function replaceScreens():void 
		{
			for each (var screen:P3IScreen in screens) 
			{
				destroyScreen(screen);
			}
			screens = new Vector.<P3IScreen>();
		}	
		
		public function destroy():void
		{
			for each (var screen:P3IScreen in screens) 
			{
				destroyScreen(screen);
			}
			screens = new Vector.<P3IScreen>();
			display = null;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function destroyScreen(screen:P3IScreen):void
		{
			if (_currentScreen == screen)
				_currentScreen = null;
				
			if(display.contains(screen as Sprite))
				display.removeChild(screen as Sprite);
				
			screen.unload();			
			screen = null;
		}
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		public function get currentScreen():P3IScreen 
		{
			return _currentScreen;
		}
		
	}

}
