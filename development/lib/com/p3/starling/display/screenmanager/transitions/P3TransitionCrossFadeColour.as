/**
 * ...
 * @author 
 */

package com.p3.starling.display.screenmanager.transitions
{
	import com.p3.display.screenmanager.P3IScreen;
	import com.p3.display.screenmanager.P3ScreenManager;

	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class P3TransitionCrossFadeColour extends Sprite implements P3ITransition
	{
		private var _duration						:Number;
		private var _colour							:uint;
		private var _pause							:Number;
		private var _overlay						:Sprite;
		private var _pauseTimeout					:uint;		
		
		private var _oldScreen						:P3IScreen;
		private var _newScreen						:P3IScreen;
		private var _holder							:Sprite;
		private var _replace						:Boolean;
		private var _replaceGroups					:Array;
		private var _replaceAll						:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function P3TransitionCrossFadeColour(duration:Number = 1, colour:uint = 0x000000, pause:Number = 0) 
		{
			_pause = pause;
			_colour = colour;
			_duration = duration;
			
			_overlay = new Sprite();
			_overlay.graphics.beginFill(_colour);
			_overlay.graphics.drawRect(0, 0, P3ScreenManager.inst.display.stage.stageWidth, P3ScreenManager.inst.display.stage.stageHeight);
			_overlay.graphics.endFill();
			_overlay.alpha = 0;
			this.addChild(_overlay);
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		public function init(oldScreen:P3IScreen, newScreen:P3IScreen, holder:Sprite, replace:Boolean, replaceGroups:Array, replaceAll:Boolean):void 
		{			
			_oldScreen 	= oldScreen;
			_newScreen 	= newScreen;
			_holder		= holder;
			
			_replace 		= replace;
			_replaceGroups 	= replaceGroups;
			_replaceAll 	= replaceAll;
		}
		
		public function transitionIn():void
		{			
			TweenNano.to(_overlay, _duration * 0.5, {alpha:1, onComplete:onTransitionInComplete});
		}
		
		public function transitionOut():void
		{
			TweenNano.to(_overlay, _duration * 0.5, {alpha:0, onComplete:onTransitionOutComplete});
		}
			
		public function destroy():void 
		{
			clearTimeout(_pauseTimeout);
			_oldScreen = null;
			_newScreen = null;
			_holder = null;
			_overlay = null;
			_replaceGroups = [];
		}	
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function onTransitionInComplete():void 
		{
			_pauseTimeout = setTimeout(fireEvent, _pause * 1000, P3TransitionEvent.TRANSITION_IN_COMPLETE);
		}
		
		private function onTransitionOutComplete():void 
		{
			fireEvent(P3TransitionEvent.TRANSITION_OUT_COMPLETE);
		}
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		private function fireEvent(eventType:String):void
		{
			dispatchEvent(new P3TransitionEvent(eventType, _oldScreen, _newScreen, _holder, _replace, _replaceGroups, _replaceAll));
		}
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}

}