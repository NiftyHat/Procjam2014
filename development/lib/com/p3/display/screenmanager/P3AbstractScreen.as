/**
 * ...
 * @author Adam
 * VERSION 1.0.0;
 */

package com.p3.display.screenmanager
{	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.events.MouseEvent;
	
	public class P3AbstractScreen extends Sprite implements P3IScreen
	{
		private var _name							:String;
		private var _groupName						:String;
		private var _priority						:int;
		private var _isLoaded						:Boolean
		private var _buttonsArr						:Array;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function P3AbstractScreen(name:String = "") 
		{
			this.name = name
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/

		/**
		 * Called from the P3ScreenManager. Can be overridden to "start" the screen when it is loaded.
		 */
		public function load():void 
		{
			_isLoaded = true;
		}
		
		/**
		 * Called from the P3ScreenManager. Can be overridden to "unload" the screen when it is unloaded.
		 */
		public function unload():void 
		{
			_isLoaded = false;
			removeButtons();
		}		
		
		/**
		 * Called when the screen is added to the Stage. Can be overridden to "initialise" the screen when it is added.
		 */
		public function init():void
		{
			// Does nothing but can be used to instantiate stuff.
		}		
		
		/**
		 * Pass in a movieclip to create a "simple button"
		 * @param	button
		 * @param	clickCallback
		 * @param	rolloverCallback
		 * @param	rolloutCallback
		 */
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
		
		/**
		 * Remove a button from the screen.
		 * @param	button
		 */
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
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Removes the button interactivity on "Unload".
		 */
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
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/		
		
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}
		
		/**
		 * Button CLick method, calls a callback if provided or dispatched the mouseEvent.
		 * @param	e
		 */
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
		
		/**
		 * Button Over method, calls a callback if provided or dispatched the mouseEvent.
		 * @param	e
		 */
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
		
		/**
		 * Button Out method, calls a callback if provided or dispatched the mouseEvent.
		 * @param	e
		 */
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
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/			
		
		public function get isLoaded():Boolean		{	return _isLoaded;	}		
		
		public function get groupName():String	 	{	return _groupName;	}
		public function set groupName(value:String):void 
		{	
			_groupName = value;	
		}
		
		public function get priority():int 			{	return _priority;		}		
		public function set priority(value:int):void 
		{
			_priority = value;
		}		
		
		
	}
}