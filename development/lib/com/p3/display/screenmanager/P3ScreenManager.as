/**
 * ...
 * @author ADAM
 * @version 1.0.2
 * @usage 
 * 
 * P3ScreenManager.inst.init(displayObject);
 * 
 * P3ScreenManager.inst.addScreenGroup("game", 0);
 * P3ScreenManager.inst.addScreenGroup("ui", 1);
 * 
 * P3ScreenManager.inst.addScreen(Screen, {group:"groupname", replace:true, replaceGroups:["group1", "group2"], replaceAll:false, transition:P3ITransition);
 * 		
 */
 
package com.p3.display.screenmanager
{
	import com.p3.display.screenmanager.transitions.P3ITransition;
	import com.p3.display.screenmanager.transitions.P3TransitionEvent;
	import com.p3.display.screenmanager.P3IScreen;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class P3ScreenManager
	{		
		private static var 	_instance				:P3ScreenManager;
		private static var 	_allowInstance			:Boolean;
		
		private const DEFAULT_GROUP					:String = "default";		
		
		private var _display						:Sprite;
		private var _groups							:Dictionary;		
		private var _transitionsArr					:Array;
		
		private var _replace						:Boolean;
		private var _replaceAll						:Boolean;
		private var _replaceGroups					:Array;	
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
	
		public function P3ScreenManager() 
		{
			if (!P3ScreenManager._allowInstance)
			{
				throw new Error("Error: Use P3ScreenManager.inst instead of the new keyword.");
			}
			
			_display 	 = new Sprite();
			_groups		 = new Dictionary(true);		
			_transitionsArr = [];		
		}	
		
		public static function get inst():P3ScreenManager
		{
			if (P3ScreenManager._instance == null)
			{
				P3ScreenManager._allowInstance	= true;
				P3ScreenManager._instance		= new P3ScreenManager();
				P3ScreenManager._allowInstance	= false;
			}
			return P3ScreenManager._instance;
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Added the screenmanagers display to the supplied displayObject.
		 * You can however add the display manually in you class.
		 * @param	sceneHolder
		 */
		public function init(displayObject:DisplayObjectContainer):void 
		{
			displayObject.addChild(_display);
		}
		
		/**
		 * Creates a P3ScreenGroup. This is used to layer and organise screens. e.g. separate UI from game screens.
		 * @param	groupName:String
		 * @param	depth:int		
		 */
		public function addScreenGroup(groupName:String, depth:int = 0):void
		{			
			groupName = groupName.toLowerCase();
			
			if (depth > _display.numChildren) 
				depth = _display.numChildren;
			
			if (!_groups[groupName])
			{
				var screenGroup:P3ScreenGroup = new P3ScreenGroup(groupName);
				_groups[groupName] = screenGroup;
				
				if (depth == _display.numChildren)
					_display.addChild(screenGroup.display);
				else
					_display.addChildAt(screenGroup.display, depth);
			}
			else
			{
				trace(this + " The group already exists: " + groupName);
			}
		}
		
		/**
		 * Adds a screen the the P3ScreenManager with the followinf optional parameters.
		 * 
		 *	<li><b> replace : Boolean</b> replaces all the screen in the same group as the new screen.
		 *	<li><b> replaceAll : Boolean</b> replaces all the other screens.
		 *	<li><b> replaceGroups : Array</b> replaces all the screens in the specified groups.		 * 
		 * 	<li><b> group : String</b> The name of the group the screen is attached.</li>
		 * 	<li><b> transition : P3ITransition</b> The tranisiton for the screens</li>		
		 */
		public function addScreen(screen:P3IScreen, vars:Object = null):void
		{

			vars = (vars != null) ? vars : { };
			var groupName:String 	= (vars.group != null) ? vars.group : DEFAULT_GROUP;
			var replace:Boolean 	= (vars.replace != null) ? vars.replace : true;
			var replaceGroups:Array	= (vars.replaceGroups != null) ? vars.replaceGroups : [];
			var replaceAll:Boolean 	= (vars.replaceAll != null) ? vars.replaceAll : false;
		
			var transition:P3ITransition = vars.transition;				
			
			groupName = groupName.toLowerCase();
			screen.groupName = groupName;
			
			var depth:int = getHighestDepth();			
			if (groupName == DEFAULT_GROUP)
				depth = 0;			
			
			if (!_groups[groupName]) 
				addScreenGroup(groupName, depth);				
			
			if (transition)
				transitionScreens(transition, screen, replace, replaceGroups, replaceAll);
			else
				displayScreen(screen, replace, replaceGroups, replaceAll);		
		}
		
		/**
		 * Removes the screen from the screenmanager.
		 * @param	screen
		 */
		public function removeScreen(screen:P3IScreen):void
		{
			(_groups[screen.groupName] as P3ScreenGroup).removeScreen(screen);
		}
		
		/**
		 * Removes a P3ScreenGroup from the P3ScreenManager.
		 * @param	groupName:String - name of the group to be removed.
		 */
		public function removeScreenGroup(groupName:String):void
		{
			(_groups[groupName] as P3ScreenGroup).destroy();
			_groups[groupName] = null;
		}
		
		/**
		 * Returns the highest depth of the P3ScreenManager.
		 * @return
		 */
		public function getHighestDepth():int
		{
			return _display.numChildren;
		}
		
		/**
		 * Returns the depth of the supplied group.
		 * @param	groupName:String - name of the group.
		 * @return
		 */
		public function getScreenGroupDepth(groupName:String):int 
		{
			return(_display.getChildIndex((_groups[groupName] as P3ScreenGroup).display));
		}		
		
		/**
		 * Garbage Collection
		 */
		public function destroy():void
		{
			for each (var transition:P3ITransition in _transitionsArr) 
			{
				transition.removeEventListener(P3TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
				transition.removeEventListener(P3TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			}
			
			for each (var group:P3ScreenGroup in _groups) 
			{
				group.destroy();
			}
			_groups	 = null;	
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Displays the screen.
		 */
		private function displayScreen(screen:P3IScreen, replace:Boolean, replaceGroups:Array, replaceAll:Boolean):void
		{
			// replace screen in new screens group.
			if (replace)
			{
				(_groups[screen.groupName] as P3ScreenGroup).replaceScreens();
			}
			
			// replace all screens or replace all screen in specified groups.
			if (replaceAll)
			{
				for each (var replaceAllGroup:P3ScreenGroup in _groups) 
				{
					replaceAllGroup.replaceScreens();
				}
			}
			else if (replaceGroups)
			{
				
				
				var len:int = replaceGroups.length;
				if (len > 0)
				{		
					for (var i:int = 0; i < len; i++) 
					{
						var group:P3ScreenGroup = _groups[replaceGroups[i]];
						group.replaceScreens();
					}
				}
			}
			
			// add the new screen to the group
			(_groups[screen.groupName] as P3ScreenGroup).addScreen(screen);
		}
		
		/**
		 * Starts the transition between screen if a transition is present.
		 */
		private function transitionScreens(transition:P3ITransition, screen:P3IScreen, replace:Boolean, replaceGroups:Array, replaceAll:Boolean):void
		{
			var screenGroup:P3ScreenGroup = _groups[screen.groupName];
			var oldScreen:P3IScreen = screenGroup.currentScreen;
			
			_transitionsArr.push(transition);
			transition.init(oldScreen, screen, screenGroup.display, replace, replaceGroups, replaceAll);			
			transition.addEventListener(P3TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete, false, 0, true);
			transition.addEventListener(P3TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete, false, 0, true);
			transition.transitionIn();			
			
			_display.addChildAt(transition as Sprite, getScreenGroupDepth(screen.groupName)+1);
		}				
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		/**
		 * Called from the transition when it has finished its transition in.
		 * @param	e
		 */
		private function onTransitionInComplete(e:P3TransitionEvent):void 
		{
			displayScreen(e.newScreen, e.replace, e.replaceGroups, e.replaceAll);			
			(e.target as P3ITransition).transitionOut();
		}
		
		/**
		 * Called from the transition when it has finished its transition out.
		 * @param	e
		 */
		private function onTransitionOutComplete(e:P3TransitionEvent):void 
		{
			(e.target as P3ITransition).removeEventListener(P3TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
			(e.target as P3ITransition).removeEventListener(P3TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			(e.target as P3ITransition).destroy();
			_display.removeChild(e.target as Sprite);
			_transitionsArr.splice(_transitionsArr.indexOf(e.target), 1);
		}
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
	
		public function get display():Sprite 
		{
			return _display;
		}
		
	}	
}












