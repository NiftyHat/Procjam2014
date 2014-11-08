/**
 * ...
 * @author Adam
 * VERSION 1.0.0;
 */
package com.p3.starling.display.screenmanager
{
	import starling.display.Sprite;
	import starling.events.Event;

	public class P3AbstractScreen extends Sprite implements P3IScreen
	{
		private var _name							:String;
		private var _groupName						:String;
		private var _isReady						:Boolean;
		private var _transitionObject				:P3ScreenObject;

//		private var _buttonsArr						:Array;

/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function P3AbstractScreen(name:String = "") 
		{
			_name = name;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/


		/**
		 * Called from the screenManager when it has added the screen to the display.
		 */
		public function init():void
		{
			_isReady = true;
			// Does nothing but can be used to instantiate stuff.
		}


		/**
		 * Called from the P3ScreenManager. Can be overridden to "unload" the screen when it is unloaded.
		 */
		public function transitionIn():void
		{
			transitionInComplete();
		}


		/**
		 * Called from the ScreenManager when the screen is too be removed.
		 */
		public function transitionOut():void
		{
			transitionOutComplete();
		}


		/**
		 * Called from the screenManager once the screen has been added and its transition is complete.
		 */
		public function start():void
		{
			_isReady = true;
		}


		/**
		 * Called from the screenManager when it has removed it from the display.
		 */
		override public function dispose():void
		{
			_isReady = false;
			super.dispose();
		}


		/**
		 * Can be used to set up an update loop. Need to be manually set up.
		 * @param delta
		 */
		public function update(delta:Number = 0):void
		{
		}


		/**
		 * Needs to be called to complete the transition "in"
		 */
		protected function transitionInComplete():void
		{
			dispatchEvent(new Event(P3ScreenManager.TRANSITION_IN_COMPLETE));
		}


		/**
		 * Needs to be called to complete the transition "in"
		 */
		protected function transitionOutComplete():void
		{
			dispatchEvent(new Event(P3ScreenManager.TRANSITION_OUT_COMPLETE));
		}
		
		/**
		 * Pass in a movieclip to create a "simple button"
		 * @param	button
		 * @param	clickCallback
		 * @param	rolloverCallback
		 * @param	rolloutCallback
		 */
		/*
		protected function addButton(button:MovieClip, clickCallback:Function = null, rolloverCallback:Function = null, rolloutCallback:Function = null):void
		{

			button.clickCallback 	= clickCallback;
			button.rolloverCallback = rolloverCallback;
			button.rolloutCallback 	= rolloutCallback;
			
			button.mouseChildren = false;
			button.buttonMode = true;				
			button.addEventListener(MouseEvent.CLICK,		onButtonClick, false, 0, true);
			button.addEventListener(MouseEvent.ROLL_OVER,	onButtonOver, false, 0, true);
			button.addEventListener(MouseEvent.ROLL_OUT,	onButtonOut, false, 0, true);	
				
			if (!_buttonsArr)
				_buttonsArr = [];
			
			_buttonsArr.push(button);
		}
		*/

		/**
		 * Remove a button from the screen.
		 * @param	button
		 */
		/*
		protected function removeButton(button:MovieClip):void
		{
			var id:int = _buttonsArr.indexOf(button)
			if (id >= 0)
			{
				button.buttonMode = false;				
				button.removeEventListener(MouseEvent.CLICK,		onButtonClick);
				button.removeEventListener(MouseEvent.ROLL_OVER,	onButtonOver);
				button.removeEventListener(MouseEvent.ROLL_OUT,		onButtonOut);
				_buttonsArr.splice(id, 1);
			}
		}
        */


/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Removes the button interactivity on "Unload".
		 */
		/*
		private function removeButtons():void
		{
			for each(var _btn:MovieClip in _buttonsArr)
			{
				_btn.removeEventListener(MouseEvent.CLICK,		onButtonClick);
				_btn.removeEventListener(MouseEvent.ROLL_OVER,	onButtonOver);
				_btn.removeEventListener(MouseEvent.ROLL_OUT,	onButtonOut);
				_btn = null;
			}
			_buttonsArr = [];
		}
		*/

/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		


		
		/**
		 * Button CLick method, calls a callback if provided or dispatched the mouseEvent.
		 * @param	e
		 */
			/*
		protected function onButtonClick(e:MouseEvent):void
		{
			var _btn:MovieClip = e.currentTarget as MovieClip;
			var _callback:Function = _btn.clickCallback;
			if (_callback != null)
			{
				if (_callback.length == 0) _callback();
				else _callback(_btn);
				
			}
			else
				_btn.dispatchEvent(e);
		}
			*/

		/**
		 * Button Over method, calls a callback if provided or dispatched the mouseEvent.
		 * @param	e
		 */
			/*
		protected function onButtonOver(e:MouseEvent):void
		{
			var _btn:MovieClip = e.currentTarget as MovieClip;
			var _callback:Function = _btn.rolloverCallback;
			if (_callback != null)
			{
				if (_callback.length == 0) _callback();
				else _callback(_btn)
			}
			else
			{
				var _lablesArr:Array = _btn.currentLabels;
				for each(var _lable:FrameLabel in _lablesArr)
				{
					if (_lable.name == "over")	_btn.gotoAndStop(_lable.name);
				}
			}
		}
			*/

		/**
		 * Button Out method, calls a callback if provided or dispatched the mouseEvent.
		 * @param	e
		 */
			/*
		protected function onButtonOut(e:MouseEvent):void
		{
			var _btn:MovieClip = e.currentTarget as MovieClip;
			var _callback:Function = _btn.rolloutCallback;
			if (_callback != null)
			{
				if (_callback.length == 0) _callback();
				else _callback(_btn)
			}
			else
			{
				var _lablesArr:Array = _btn.currentLabels;
				for each(var _lable:FrameLabel in _lablesArr)
				{
					if (_lable.name == "out")	_btn.gotoAndStop(_lable.name);
				}
			}
		}
			*/

/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/			

		public function get groupName():String	 	{	return _groupName;	}
		public function set groupName(value:String):void 
		{	
			_groupName = value;	
		}

		public function get isReady():Boolean
		{
			return _isReady;
		}

		public function set transitionOject(value:P3ScreenObject):void
		{
			_transitionObject = value;
		}

		public function get transitionOject():P3ScreenObject
		{
			return _transitionObject;
		}


	}
}