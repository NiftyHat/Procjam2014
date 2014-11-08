
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
 
 
package com.p3.starling.display.screenmanager
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	import com.p3.display.screenmanager.transitions.P3ITransition;
	import com.p3.display.screenmanager.transitions.P3TransitionEvent;

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class P3ScreenManager
	{
		static public const TRANSITION_IN_COMPLETE:String="TRANSITION_IN_COMPLETE";
		static public const TRANSITION_OUT_COMPLETE:String="TRANSITION_OUT_COMPLETE";
		static public var enableLogging:Boolean;
		static private var 	_instance:P3ScreenManager;
		static private var 	_allowInstance:Boolean;
		private const DEFAULT_GROUP:String="default";
		private var _display:Sprite;
		private var _groups:Dictionary;
		private var _transitionsArr:Array;
		private var _highestGroupDepth:int;

		/*-------------------------------------------------
		 * PUBLIC CONSTRUCTOR
		-------------------------------------------------*/
		public function P3ScreenManager()
		{
			if (!P3ScreenManager._allowInstance)
			{
				throw new Error("Error: Use P3ScreenManager.inst instead of the new keyword.");
			}

			_display = new Sprite();
			_groups = new Dictionary(true);
			_transitionsArr = [];
			_highestGroupDepth = 0;
		}


		public static function get inst():P3ScreenManager
		{
			if (P3ScreenManager._instance == null)
			{
				P3ScreenManager._allowInstance = true;
				P3ScreenManager._instance = new P3ScreenManager();
				P3ScreenManager._allowInstance = false;
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
		public function addScreenGroup(groupName:String, depth:int=-1):void
		{
			groupName = groupName.toLowerCase();

			if (depth > _highestGroupDepth)
				_highestGroupDepth = depth;

			if (depth == -1)
			{
				depth = _highestGroupDepth;
				_highestGroupDepth++;
			}

			if (!_groups[groupName])
			{
				var screenGroup:P3ScreenGroup=new P3ScreenGroup(groupName, depth);
				_groups[groupName] = screenGroup;

				var tempArr:Vector.<P3ScreenGroup>=new <P3ScreenGroup>[];
				for each (var o:P3ScreenGroup in _groups)
				{
					tempArr.push(o);
				}
				tempArr.sort(sortGroupDepths);
				for (var i:int=0; i < tempArr.length; i++)
				{
					_display.addChild(tempArr[i].display);
				}
			}
			else
			{
				trace(this + " The group already exists: " + groupName);
			}

			if (P3ScreenManager.enableLogging)
				trace(this, "Group created: " + groupName + " > " + _groups[groupName]);
		}


		/**
		 * Adds a screen the the P3ScreenManager with the followinf optional parameters.
		 *
		 * 	<li><b> name : String = ClassName</b> The name of the screen is attached.</li>
		 * 	<li><b> group : String = DEFAULT</b> The name of the group the screen is attached.</li>
		 *	<li><b> replace : Boolean = true</b> replaces all the screen in the same group as the new screen.</li>
		 *	<li><b> replaceAll : Boolean = false</b> replaces all the other screens.</li>
		 *	<li><b> replaceGroups : Array = []</b> replaces all the screens in the specified groups.</li>
		 * 	<li><b> animateOut : Bool = true</b> If an old screen is to be replaced, it's animateOut method will be called</li>
		 * 	<li><b> transition : P3ITransition = false</b> The tranisiton for the screens</li>
		 */
		public function addScreen(screen:P3IScreen, vars:Object=null):void
		{
			var dynamicName:String;
			if(!screen.name)
			{
				dynamicName = getQualifiedClassName(screen);
				dynamicName = String(dynamicName.split("::").pop());
			}
			else
			{
				dynamicName = screen.name;
			}
			
			
			if (vars !== P3ScreenObject)
			{
				vars = (vars != null) ? vars:{};
				var groupName:String=(vars.group != null) ? vars.group:DEFAULT_GROUP;
				var name:String=(vars.name != null) ? vars.name:dynamicName;
				var replace:Boolean=(vars.replace != null) ? vars.replace:true;
				var replaceGroups:Array=(vars.replaceGroups != null) ? vars.replaceGroups:null;
				var replaceAll:Boolean=(vars.replaceAll != null) ? vars.replaceAll:false;
				var animateOut:Boolean=(vars.animateOut != null) ? vars.animateOut:true;
				groupName = groupName.toLowerCase();

				var screenObject:P3ScreenObject=new P3ScreenObject();
				screenObject.screen = screen;
				screenObject.name = name;
				screenObject.groupName = groupName;
				screenObject.replace = replace;
				screenObject.replaceGroups = replaceGroups;
				screenObject.replaceAll = replaceAll;
				screenObject.animateOut = animateOut;
			}
			// var transition:P3ITransition = vars.transition;

			if(screen.name && screen.name != name)
			{
				trace("Warning: " + this + " Screen already has a name: " + screen.name + " now becoming " + name);
				screen.name = name;
			}
			else
			{
				screen.name = name;
			}
			
			if(!screen.groupName)	screen.groupName = groupName;

			var depth:int=getHighestDepth();
			if (groupName == DEFAULT_GROUP)
				depth = 0;

			if (!_groups[groupName])
				addScreenGroup(groupName, depth);

			displayScreen(screen, screenObject);
		}


		/**
		 * Removes the screen from the screenmanager.
		 * @param	screen
		 */
		public function removeScreen(screen:P3IScreen, animateOut:Boolean=false):void
		{
			(_groups[screen.groupName] as P3ScreenGroup).removeScreen(screen, animateOut);
		}


		/**
		 * Removes a P3ScreenGroup from the P3ScreenManager.
		 * @param	groupName:String - name of the group to be removed.
		 */
		public function removeScreenGroup(groupName:String):void
		{
			(_groups[groupName] as P3ScreenGroup).dispose();
			delete _groups[groupName];
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
		 * Returns a Screen based upon its name.
		 * @param	name:String - This is the string name of the screen, if you have not set this, it will be he same as the class name..
		 * @param	groupName:String - If not specified, it will loop through all the groups and remove the first occurance.
		 */
		public function getScreen(name:String, groupName:String = ""):P3IScreen
		{
			var screen:P3IScreen;
			if(groupName.length == 0)
			{
				// look in all groups for the screen
				for each (var i : P3ScreenGroup in _groups) 
				{
					screen = i.getScreen(name);
					if(screen)
					{
						trace(this, "Found Screen in Group:" + i.name);
						return screen;
						break;
					}
				}
				trace(this, "Did not find screen.");
				return null;
			}
			else
			{
				var group:P3ScreenGroup = _groups[groupName];
				if(group)	
				{			
					screen = group.getScreen(name);
					return screen;
				}
				else
				{
					return null;
				}
			}
		}

		/**
		 * Garbage Collection
		 */
		public function dispose():void
		{
			// for each (var transition:P3ITransition in _transitionsArr)
			// {
			// transition.removeEventListener(P3TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
			// transition.removeEventListener(P3TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			// }

			for each (var group:P3ScreenGroup in _groups)
			{
				group.dispose();
			}
			_groups = null;
		}


		/**
		 * Updates all the screens.
		 */
		public function update(delta:Number=0.0):void
		{
			for each (var group:P3ScreenGroup in _groups)
			{
				group.update(delta);
			}
		}


		/*-------------------------------------------------
		 * PRIVATE FUNCTIONS
		-------------------------------------------------*/
		/**
		 * Sorts the groups based upon their depths.
		 * @param groupA
		 * @param groupB
		 * @return
		 */
		private function sortGroupDepths(groupA:P3ScreenGroup, groupB:P3ScreenGroup):int
		{
			if (groupA.depth > groupB.depth)
				return 1;
			else if (groupA.depth <= groupB.depth)
				return -1;
			else
				return 0;
		}


		/**
		 * Displays the screen.
		 */
		private function displayScreen(screen:P3IScreen, screenTransitionObject:P3ScreenObject):void
		{
			// replace all screens or replace all screen in specified groups.
			if (screenTransitionObject.replaceAll)
			{
				for each (var replaceAllGroup:P3ScreenGroup in _groups)
				{
					replaceAllGroup.removeAllScreens(screenTransitionObject.animateOut);
				}
			}
			else if (screenTransitionObject.replaceGroups && screenTransitionObject.replaceGroups.length > 0)
			{
				var len:int=screenTransitionObject.replaceGroups.length;
				if (len > 0)
				{
					for (var i:int=0; i < len; i++)
					{
						var group:P3ScreenGroup=_groups[screenTransitionObject.replaceGroups[i]];
						group.removeAllScreens(screenTransitionObject.animateOut);
					}
				}
			}

			(_groups[screenTransitionObject.groupName] as P3ScreenGroup).addScreen(screenTransitionObject);
		}


		/**
		 * Starts the transition between screen if a transition is present.
		 */
		private function transitionScreens(transition:P3ITransition, screen:P3IScreen, replace:Boolean, replaceGroups:Array, replaceAll:Boolean):void
		{
			// var screenGroup:P3ScreenGroup = _groups[screen.groupName];
			// var oldScreen:P3IScreen = screenGroup.currentScreen;
			//
			// _transitionsArr.push(transition);
			// transition.init(oldScreen, screen, screenGroup.display, replace, replaceGroups, replaceAll);
			// transition.addEventListener(P3TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete, false, 0, true);
			// transition.addEventListener(P3TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete, false, 0, true);
			// transition.transitionIn();
			//
			// _display.addChildAt(transition as Sprite, getScreenGroupDepth(screen.groupName)+1);
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
			// displayScreen(e.newScreen, e.replace, e.replaceGroups, e.replaceAll);
			// (e.target as P3ITransition).transitionOut();
		}


		/**
		 * Called from the transition when it has finished its transition out.
		 * @param	e
		 */
		private function onTransitionOutComplete(e:P3TransitionEvent):void
		{
			// (e.target as P3ITransition).removeEventListener(P3TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
			// (e.target as P3ITransition).removeEventListener(P3TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			// (e.target as P3ITransition).destroy();
			// _display.removeChild(e.target as Sprite);
			// _transitionsArr.splice(_transitionsArr.indexOf(e.target), 1);
		}


		/*-------------------------------------------------
		 * GETTERS / SETTERS
		-------------------------------------------------*/
		public function get display():Sprite
		{
			return _display;
		}


		public function get highestDepth():int
		{
			return _highestGroupDepth;
		}
	}
}












