
/**
 * P3ScreenGroup is a class that holds a list of screens in a specific group.
 * This is where the magic happens.
 */
package com.p3.starling.display.screenmanager
{
	import starling.display.Sprite;
	import starling.events.Event;

	public class P3ScreenGroup
	{
		private var _name:String;
		private var _depth:int;
		private var _display:Sprite;
		private var _screens:Vector.<P3IScreen>;
		private var _currentScreen:P3IScreen;

		/*-------------------------------------------------
		 * PUBLIC CONSTRUCTOR
		-------------------------------------------------*/
		public function P3ScreenGroup(name:String, depth:int)
		{
			_name = name;
			_depth = depth;
			_screens = new Vector.<P3IScreen>();
			_display = new Sprite();
			_display.name = _name;
		}


		/*-------------------------------------------------
		 * PUBLIC FUNCTIONS
		-------------------------------------------------*/
		/**
		 * Adds the screen to the group and its display
		 * @param screen
		 */
		public function addScreen(screenTransitionObject:P3ScreenObject):void
		{
			if (screenTransitionObject.replace && _currentScreen)
			{
				_currentScreen.transitionOject = screenTransitionObject;
				_currentScreen.addEventListener(P3ScreenManager.TRANSITION_OUT_COMPLETE, onCurrentScreenTransitionsOutComplete);
				_currentScreen.transitionOut();
			}
			else
			{
				displayScreen(screenTransitionObject.screen);
			}
		}


		/**
		 * Removes the supplied screen.
		 * @param	screen
		 */
		public function removeScreen(screen:P3IScreen, animateOut:Boolean):void
		{
			if (animateOut)
			{
				screen.addEventListener(P3ScreenManager.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
				screen.transitionOut();
			}
			else
			{
				destroyScreen(screen);
			}
		}


		/**
		 * removeAllScreens screens.
		 */
		public function removeAllScreens(animateOut:Boolean):void
		{
			for each (var screen:P3IScreen in _screens)
			{
				if (animateOut)
				{
					screen.addEventListener(P3ScreenManager.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
					screen.transitionOut();
				}
				else
				{
					destroyScreen(screen);
				}
			}
			_screens = new Vector.<P3IScreen>();
		}
		
		/**
		 * Returns a screen based upoin its name.
		 */
		public function getScreen(name:String):P3IScreen
		{
			var len:int = _screens.length;
			for (var i : int = 0; i < len; i++) 
			{
				var screen:P3IScreen = _screens[i];
				if(screen.name == name)
					break;
			}
			return screen;
		}


		public function dispose():void
		{
			for each (var screen:P3IScreen in _screens)
			{
				destroyScreen(screen);
			}
			_screens = new Vector.<P3IScreen>();
			_display = null;
		}


		public function update(delta:Number=0.0):void
		{
			var len:int=_screens.length;
			for (var i:int=0; i < len; i++)
			{
				var screen:P3IScreen=_screens[i];
				screen.update(delta);
			}
		}


		/*-------------------------------------------------
		 * PRIVATE FUNCTIONS
		-------------------------------------------------*/
		private function destroyScreen(screen:P3IScreen):void
		{
			var index:int=_screens.indexOf(screen);
			if (index != -1)
			{
				_screens.splice(index, 1);
			}

			if (_currentScreen == screen)
				_currentScreen = null;

			if (_display.contains(screen as Sprite))
				_display.removeChild(screen as Sprite);

			screen.dispose();
			screen = null;
		}


		private  function displayScreen(screen:P3IScreen):void
		{
			_screens.push(screen);
			_display.addChild(screen as Sprite);
			_currentScreen = screen;
			_currentScreen.init();
			_currentScreen.addEventListener(P3ScreenManager.TRANSITION_IN_COMPLETE, onTransitionInComplete);
			_currentScreen.transitionIn();
		}


		/*-------------------------------------------------
		 * EVENT HANDLING
		-------------------------------------------------*/
		private function onTransitionInComplete(event:Event):void
		{
			_currentScreen.removeEventListener(P3ScreenManager.TRANSITION_IN_COMPLETE, onTransitionInComplete);
			_currentScreen.start();
		}


		private function onTransitionOutComplete(event:Event):void
		{
			var screen:P3IScreen=(event.target as P3IScreen);
			screen.removeEventListener(P3ScreenManager.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			destroyScreen(screen);
		}


		private function onCurrentScreenTransitionsOutComplete(e:Event):void
		{
			var transitionObject:P3ScreenObject=_currentScreen.transitionOject;

			// clear old screen
			// if(_display.contains(_currentScreen as Sprite))
			// {
			_display.removeChild(_currentScreen as Sprite);
			_screens.splice(_screens.indexOf(_currentScreen), 1);
			// }

			_currentScreen.removeEventListener(P3ScreenManager.TRANSITION_OUT_COMPLETE, onCurrentScreenTransitionsOutComplete);
			_currentScreen.dispose();
			_currentScreen = null;

			// add new screem
			displayScreen(transitionObject.screen);
		}


		/*-------------------------------------------------
		 * GETTERS / SETTERS
		-------------------------------------------------*/
		public function get currentScreen():P3IScreen
		{
			return _currentScreen;
		}


		public function get depth():int
		{
			return _depth;
		}


		public function get display():Sprite
		{
			return _display;
		}


		public function get name():String
		{
			return _name;
		}


		public function toString():String
		{
			return "P3ScreenGroup{_name=" + String(_name) + ",_depth=" + String(_depth) + ",_display=" + String(_display) + ",_screens=" + String(_screens) + ",_currentScreen=" + String(_currentScreen) + "}";
		}


		
	}
}
