/**
 * ...
 * @author 
 */

package com.p3.starling.display.screenmanager.transitions
{
	import com.p3.display.screenmanager.P3IScreen;

	import flash.display.Sprite;

	public class P3TransitionFadeIn extends Sprite implements P3ITransition
	{
		private var _duration						:Number;
		
		private var _oldScreen						:P3IScreen;
		private var _newScreen						:P3IScreen;
		private var _holder							:Sprite;
		private var _replace						:Boolean;
		private var _replaceGroups					:Array;
		private var _replaceAll						:Boolean;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function P3TransitionFadeIn(duration:Number = 1) 
		{
			_duration = duration;
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
			_newScreen.alpha = 0;
			onTransitionInComplete();
			
		}
		
		public function transitionOut():void
		{
			TweenNano.to(_newScreen, _duration, { alpha:1, onComplete:onTransitionOutComplete } );
		}
			
		public function destroy():void 
		{
			_oldScreen = null;
			_newScreen = null;
			_holder = null;
			_replaceGroups = [;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		private function onTransitionInComplete():void 
		{
			fireEvent(P3TransitionEvent.TRANSITION_IN_COMPLETE);
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