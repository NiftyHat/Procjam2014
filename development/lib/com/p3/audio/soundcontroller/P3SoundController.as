package com.p3.audio.soundcontroller 
{
	import com.p3.audio.soundcontroller.events.P3SoundEvent;
	import com.p3.audio.soundcontroller.objects.IP3SoundObject;
	import com.p3.audio.soundcontroller.objects.P3SoundObject;
	import com.p3.audio.soundcontroller.params.P3SoundParams;
	import com.p3.common.events.P3LogEvent;
	import flash.events.NetStatusEvent;

	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.utils.getQualifiedClassName;
	//namespace P3SoundInternal = "com.p3.soundinternal"
	
	
	/**
	 * Playerthree Sound Controller Singlton.
	 * Centralised control for all sound management. Now re-designed for maximum flexibility whilst keeping the
	 * amount of code users have to write to a minimum.
	 * 
	 * Supported features in 2.0 - One line sound/music playing, fading, volume control, mute control, pause control,
	 * settings caching, sound groups, random sound playing, initilization vars, extensible sound class, multi level control.
	 * 
	 * Depricated Stuff:- function playSoundClass() and playRandomSoundClass() should be taken out of use ASAP as they
	 * are clunky and kind of suck. Use playSound and use initilization vars.
	 * 
	 * Removed Stuff:- Dynamic sound objects. They where giving me a headache, I'll add them back in again later. The only
	 * sign of them right now is the '_loc' point.
	 * 
	 * HOW TO PLAY A SOUND
	 * P3SoundController.playSound(mySoundClass); // plays a sound
	 * P3SoundController.playSound(mySoundClass, {loops:2, fadeIn:0.5, volume:0.7}); //loops a sound twice and fades it to volume 0.7 over 0.5 seconds
	 * P3SoundController.playSound(mySoundClass, {group:"AMBIENT", manualPlay:true }); //creates a sound in the group "AMBIENT" that is stopped.
	 * P3SoundController.playSound(mySoundClass, {typeCast:P3CustomSoundClass, onComplete:someFunction}) //creates a P3CustomSoundClass with the sound on, calls someFunction when the sound finish playing
	 * P3SoundController.playRandomSound([myRandomSound1,myRandomSound2], {pan:-0.5}) //picks one sound from the array and plays it at pan -0.5;
	 * See the code comments for playSound for full dox.
	 * All play sound functions return a referance to the sound object for stuff like dynamic looping sounds and other junk.
	 * Sound parameters are all strictly defined in P3SoundParams. You can use instances of P3SoundParams for faster slicker initilization although it might make onCompletonCompleteParams go screwy.
	 * 
	 * HOW TO USE GROUPS
	 * P3SoundGroups allow for nested control of multiple sounds. So you can cluster lots of sounds of a single type in a group and control (pause,volume,mute, max) 
	 * them all together. You can either use P3SoundController.getSoundGroup("groupName") to get the group on a case by case basis or you can store a referance to it.
	 * All the universal XallSounds functions can be targeted at a specific group name too.
	 * ambientGroup:P3SoundGroup = P3SoundController.getGroup("AMBIENT");
	 * ambientGroup.volume = 0.3;
	 * P3SoundController.playSound(myAmbientSound, {group:"AMBIENT"});
	 * 
	 * The group functions are mostly wrapped funcitonality from the P3GroupList that does all the memory management. You can use _groupList.list to get all the sound
	 * groups to itterate through them all.
	 * 
	 * @author Duncan Saunders
	 */
	
	//TODO - Add a function to set a max overlapping sounds of a certain class, or for all sounds.
	public class P3SoundController extends EventDispatcher
	{
		//MAIN
		private var _groupList			:P3SoundGroupList;
		private var _muteInfo			:Object;
		private var _isMute				:Boolean;
		
		//MUSIC
		private var _music				:P3SoundObject;
		private var _musicLoopCB		:Function;
		
		//DYNAMIC SOUND
		private var _loc				:Point;
		private var _cacheObject		:Object;
		private var _sharedObject		:SharedObject;
		private var _autoFlushCache		:Boolean = false;
		private var _isFlushFailed 		:Boolean = false;
		
		//RONSEEL - Untill I can find a nicer way of handling group updates, debug needs to be on for them to dispatch.
		private var _debug				:Boolean = false;
		
		
		//SOUND GROUPS - Two built in soundgroups for handling internal sound/music functions. You can make as many extra as you want
		public static const SG_SOUNDS:String = "sounds";
		public static const SG_MUSIC:String = "music";
		
		public static const VERSION:String = "2.0.5";

		//---------------------------------------------------------------------
		//START SINGLETON
		//---------------------------------------------------------------------
		private static var _instance:P3SoundController = new P3SoundController;
		
		public function P3SoundController() 
		{
			if (_instance)  throw new Error("Singleton and can only be accessed through Singleton.instance");
			_sharedObject = SharedObject.getLocal("p3sound_setting");
			_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, onSharedObjectIOError);
			_groupList = new P3SoundGroupList ();
			
			
			trace("P3SoundController - version " + VERSION + " initilizing " + (_sharedObject.data.settings ? " with cached vars" : " without cached vars"));
			addSoundGroup(SG_MUSIC);
			addSoundGroup(SG_SOUNDS);
			loadCache();
			_cacheObject = { };
		}
		
		private function onSharedObjectIOError(e:NetStatusEvent):void 
		{
			if (e.info.code)
			{
				_isFlushFailed = (e.info.code == "NetConnection.Connect.Failed")
			}
			
			dispatchEvent(new P3LogEvent(P3LogEvent.LOG, e.info.toString()));
		}

		public static function get inst ():P3SoundController 
		{
			if (!_instance) _instance = new P3SoundController ();
			return _instance;
		}
		//---------------------------------------------------------------------
		//END SINGLTON
		//---------------------------------------------------------------------
		
		//---------------------------------------------------------------------
		//PUBLIC FUNCTIONS
		//---------------------------------------------------------------------
	
		/**
		 * 	Creates a P3SoundObject and plays it at standard volume and pan in the SG_SONDS group. By default sounds purge themselves from memory when they finish playing.
		 *  Playback Options: volume, fadeIn, loops, delay, startTime, pan
		 *  Callback: onComplete, onCompleteParams
		 *  Other Options: manualPlay, manualDestroy, url, context, typeCast, group;
		 * 
		 * 	 <li><b> volume : Number</b> Value between 1.0 and 0, volume to play the sound at</li>
		 * 	 <li><b> fadeIn : Number</b> Time in seconds to fade the sound in, non-negative</li>
		 * 	 <li><b> loops : int</b> Times to loop the sound, -1 means loop forever. Loops stop executing on destroy (not fade out)</li>
		 * 	 <li><b> delay : Number</b> Value greater than 0. Time in seconds to delay the playing the sound</li>
		 * 	 <li><b> startTime : Number</b> Value greater than 0. Start position of the playhead in seconds when playing back the sound.</li>
		 * 	 <li><b> pan : Number</b> Value between 1.0 and -1.0, pan the sound</li>
		 * 	 <li><b> group : String</b> Name of the sound group to add the sound to, use inst.getGroup($name) to retrive the group</li>
		 * 	 <li><b> manualPlay : Boolean</b> If true the sound won't play untill you call .play() on it or on the sound group it has been added to</li>
		 * 	 <li><b> manualDestroy : Boolean</b>	If true the sound won't call destroy when it has finished. Call it yourself to remove the sound object from memory</li>
		 * 	 <li><b> onComplete : Function</b>	Function to call when the sound completes, is called before destroy</li>
		 * 	 <li><b> onCompleteParams : Array</b>	Array of parameters to parse into the onComplete function</li>
		 * 	 <li><b> url : String</b> url of a sound you want to load in, the sound won't play untill it's done streaming</li>
		 * 	 <li><b> context : SoundLoaderContext</b> context for loading in, purely optional</li>
		 *   <li><b> typeCast : Class</b> Class of the object you want to cast the SoundObject to, if you are extending the base P3SoundObject class</li>
		 * @param	$class Either the class of the sound you want to play or an instance of a sound object.
		 * @param	$vars object containing custom initilize parameters like volume,fadeIn,fade_out,type_cast,group,loops,delay,startTime ect ect...
		 * @return a referance to the IP3SoundObject you created so you can manually mess with the sound, like changing volume
		 */
		public function playSound ($sound:*, $vars:Object = null):IP3SoundObject
		{
			var instance:*;
			if ($sound)
			{
				if ($sound is Class)
				{
					if ($sound) instance = new $sound;
					else instance = new Sound ();
				}
				else if ($sound is Sound)
				{
					 instance = $sound;
				}
			}		
			if (!(instance is Sound)) throw new Error ("You can only play Sound classes with Soundmanager!");
			$vars = ($vars != null) ? $vars : { };
			var typeCast:Class = ($vars.typeCast != null) ? $vars.typeCast : P3SoundObject;
			var groupName:String = ($vars.group != null) ? $vars.group : SG_SOUNDS;
			var soundGroup:P3SoundGroup = getSoundGroup(groupName);
			var sndObj:P3SoundObject = new typeCast ();

			if (soundGroup && (soundGroup.isMaxSounds || soundGroup.isPaused)) return null;
			
			sndObj.soundSource = instance;
			sndObj.key = getQualifiedClassName($sound);
			soundGroup.addSound(sndObj);
			sndObj.initVars($vars);
			
			
			sndObj.addEventListener(P3SoundEvent.COMPLETE, onSoundComplete);
			dispatchEvent(new P3SoundEvent(P3SoundEvent.GROUP_UPDATE, null));
			return sndObj;
		}
		
		/**
		 * Wrapper function that lets you play a sound randomly from an array. Might add distribution options to $vars
		 * @param	$classes An array of the sound classes you want to pick from.
		 * @param	$vars object containing custom initilize parameters like volume,fadeIn,fade_out,type_cast,group,loops,delay,startTime ect ect... See "playSound()" for full details
		 * @return a referance to the IP3SoundObject you created so you can manually mess with the sound, like changing volume
		 */
		public function playRandomSound ($classes:Array, $vars:Object = null):IP3SoundObject
		{
			var rnd:int = ($classes.length) * Math.random();
			var cls:* = $classes[rnd];
			//var cls:Class = $classes[rnd];
			//TODO - add distribution options to $vars. Add code hinting for vars.
			return playSound(cls, $vars);
		}
		
		/**
		 * Creates an eternally looping sound in the SG_MUSIC group. Crossfades music by defualt.
		 * @param	$class Class of the music you want to play or instanciated sound object.
		 * @param	$vars object containing custom initilize parameters like volume,fadeIn,fade_out,type_cast,group,loops,delay,startTime ect ect...
		 * @param	$crossfade set to false if you want to disable auto crossfading for whatever reason (like multiple music layers).
		 * @return a referance to the IP3SoundObject you created so you can manually mess with the sound, like changing volume
		 */
		public function playMusic ($music:*, $vars:Object = null, $crossfade:Boolean = true, $forceRestart:Boolean = false):IP3SoundObject
		{
			$vars = ($vars != null) ? $vars : { };
			if ($vars is int || $vars is Number)$vars = { };
			$vars.group = SG_MUSIC; 
			var music_group:P3SoundGroup = getSoundGroup(SG_MUSIC);
			if (!$vars.loops) $vars.loops = -1;
			if ($crossfade)
			{
				//assigns the new music fade in as the fade in rate of the new music so that it does some swanky cross fading;
				var fade_out:Number = 0;
				if ($vars.fadeIn) fade_out = $vars.fadeIn;
				stopAllSounds(fade_out, SG_MUSIC);
			}
			_music = playSound($music, $vars) as P3SoundObject;
			return _music;
		}
		
		/**
		 * Stops all sounds of that class. Very inefficiant. Use referances to returned IP3SoundObject instead.
		 * @param	$class Class of the sound you want to stop
		 * @param	$fadeOut Time in seconds to fade out sound. Default to 0 or no fade.
		 */
		public function stopSound($class:Class, $fadeOut:Number = 0):void
		{
			var key:String = getQualifiedClassName($class);
			for each (var group:P3SoundGroup in _groupList.list)
			{
				if (group)
				{
					for each (var sound:P3SoundObject in group.sounds)
					{
						if (!sound) continue;
						if (sound.key == key) sound.fadeOut($fadeOut);
					}
				}
			}
		}
		
		/**
		 * Stops the music that is currently playing
		 * @param	$fadeOut
		 */
		public function stopMusic($fadeOut:Number = 0):void 
		{
			var music_group:P3SoundGroup = getSoundGroup(SG_MUSIC);
			music_group.fadeOut($fadeOut);
		}
		
		/**
		 * Created a new sound group and adds it. Sound groups are keyed by the string you pass in. If you do
		 * addSoundGroup for a key that already excists you'll just get the already created group back.
		 * @param	$group_key identifier for the group. Unique per group. 
		 * 			P3SoundController.SG_SOUNDS and P3SoundController.SG_MUSIC are the built in groups.
		 * @param	$max_sounds max simultanious sounds for the group. Use it to prevent too many overlapping sounds.
		 * @return P3SoundGroup referance so you can store it and mess with the volume ect ect.
		 */
		public function addSoundGroup($group_key:String, $max_sounds:int = 0):P3SoundGroup 
		{
			var group:P3SoundGroup;
			if (_groupList.hasGroup($group_key))
			{
				if ($group_key == SG_MUSIC) trace("P3SoundController - the sound group " + $group_key + " is reserved for sound engine, use with caution");
				if ($group_key == SG_SOUNDS) trace("P3SoundController - the sound group " + $group_key + " is reserved for sound engine, use with caution");
				group = _groupList.getGroup($group_key);
			}
			else
			{
				group = _groupList.addGroup($group_key);
				dispatchEvent(new P3SoundEvent(P3SoundEvent.GROUP_UPDATE, null));
			}
			if ($max_sounds > 0) group.max = $max_sounds;
			return group;
		}
		
		/**
		 * Returns a group with the unique identifer $group_key. 
		 * If you have a lot of complex sound management to do then it's better to create a bunch of local
		 * referances to the groups so you don't have to keep looking them up using this function. 
		 * If no group excists it makes a new one; this is to preserve cache settings loading.
		 * @param	$group_key identifier for the group. Unique per group. 
		 * 			P3SoundController.SG_SOUNDS and P3SoundController.SG_MUSIC are the built in groups.
		 * @return P3SoundGroup referance so you can store it and mess with the volume ect ect.
		 */
		public function getSoundGroup($group_key:String):P3SoundGroup {
			return _groupList.getGroup($group_key);
		}
		
		/**
		 * Helper function for toggling mute on and off.
		 * @param	$state mute toggle status, true for mute, false for unmute.
		 */
		public function toggleMute($state:Boolean):void 
		{
			if ($state) muteAllSounds();
			else unmuteAllSounds();
		}

		/**
		 * Mutes all the sound in $groupKey, 
		 * If no group is specified it mutes all the sounds registered with the soundmanager  and sets global mute flag isMute
		 * @param	$groupKey unique identifier for the group you want to mute.
		 */
		public function muteAllSounds ($groupKey:String = null):void
		{
			var targetGroups:Vector.<P3SoundGroup> = getSpecifiedGroups($groupKey);
			if (!$groupKey) 
			{
				_isMute = true;
				if (_autoFlushCache && !_isFlushFailed) saveCache();
			}
			for each (var group:P3SoundGroup in targetGroups)
			{
				if (group)
				{
					group.mute();
				}
			}
		}
		
		/**
		 * unmutes all the sound in $groupKey, 
		 * If no group is specified it mutes all the sounds registered with the soundmanager and unsets global mute flag isMute
		 * @param	$groupKey unique identifier for the group you want to mute.
		 */
		public function unmuteAllSounds ($groupKey:String = null):void
		{
			var targetGroups:Vector.<P3SoundGroup> = getSpecifiedGroups($groupKey);
			if (!$groupKey) 
			{
				_isMute = false;
				if (_autoFlushCache) saveCache();
			}
			for each (var group:P3SoundGroup in targetGroups)
			{
				if (group)
				{
					group.unmute();
				}
			}
		}
		

		/**
		 * Stops all the sounds in $groupKey and fades them out for $time seconds.
		 * If no group is specified it stops all the sounds registered with the soundmanager.
		 * @param	$groupKey unique identifier for the group you want to stop.
		 */
		public function stopAllSounds($time:Number =0, $groupKey:String = null):void
		{
			var targetGroups:Vector.<P3SoundGroup> = getSpecifiedGroups($groupKey);
			for each (var group:P3SoundGroup in targetGroups)
			{
				if (group)
				{
					group.fadeOut($time);
				}
			}
		}
		
		/**
		 * Pauses all the sounds in $groupKey.
		 * If no group is specified it pauses all the sounds registered with the soundmanager.
		 * @param	$groupKey unique identifier for the group you want to stop.
		 */
		public function pauseAllSounds($groupKey:String = null):void
		{
			var targetGroups:Vector.<P3SoundGroup> = getSpecifiedGroups($groupKey);
			for each (var group:P3SoundGroup in targetGroups)
			{
				if (group)
				{
					group.pause();
				}
			}
		}

		/**
		 * Resumes all the sounds in $groupKey.
		 * If no group is specified it resumes all the sounds registered with the soundmanager.
		 * @param	$groupKey unique identifier for the group you want to stop.
		 */
		public function resumeAllSounds($groupKey:String = null):void
		{
			var targetGroups:Vector.<P3SoundGroup> = getSpecifiedGroups($groupKey);
			for each (var group:P3SoundGroup in targetGroups)
			{
				if (group)
				{
					group.resume();
				}
			}
		}
		
		/**
		 * Dump the sound manager status to the cache for reloading. Use $autoFlush false if you don't want a sharedObject to be made.
		 * @param	$autoFlush 
		 * @return a generic object that represents the save state of the sound controller
		 */
		public function saveCache($autoFlush:Boolean = true):Object
		{
			if (!_cacheObject) _cacheObject = { };
			var group:P3SoundGroup;
			var saveSettingsArray:Array = new Array ();
			_autoFlushCache = $autoFlush;
			for each (group in _groupList.list)
			{
				saveSettingsArray.push(group.saveSettings());
			}
			_cacheObject.groups = saveSettingsArray;
			_cacheObject.mute = _isMute;
			if ($autoFlush)
			{
				_sharedObject.data.settings = _cacheObject;
				var flushStatus:String = _sharedObject.flush(4096);
				trace("P3SoundController flush status " + flushStatus);
			}
			return _cacheObject;
		}

		/**
		 * Load the sound manager state. Either send nothing for a load from the sharedObject or pass in the saved cacheObject from saveCache
		 * @param	$object object that represents the save state of the sound controller
		 */
		public function loadCache($object:Object = null):void 
		{
			trace("loading");
			var group:P3SoundGroup;		
			//load stuff in
			if ($object) _cacheObject = $object;
			else _cacheObject = _sharedObject.data.settings;
			if (!_cacheObject) return;
			if (_cacheObject.groups)
			{
				var loadSettingsArray:Array = _cacheObject.groups;
				for each (var item:Object in loadSettingsArray)
				{
					group = getSoundGroup(item.key);
					group.loadSettings(item);
				}	
			}
			
			if (_cacheObject.mute) muteAllSounds();
			else unmuteAllSounds();
		}
		

		/**
		 * Internal helper function because I hate typing the same 4 lines of code over and over.
		 * If you screw with this it could have interesting consequences.
		 * If no group name is passed it returns ALL the groups.
		 * @param	$groupKey name of the group needed
		 * @return
		 */
		private function getSpecifiedGroups ($groupKey:String = null):Vector.<P3SoundGroup>
		{
			var targetGroups:Vector.<P3SoundGroup> = new Vector.<P3SoundGroup> ();
			if ($groupKey) targetGroups.push(getSoundGroup($groupKey));
			else targetGroups = _groupList.list;
			return targetGroups;
		}
		
		//EVENT HANDLERS
		
		/**
		 * Handles sound complete, orders the sound to destroy and purges from internal memory list.
		 * @param	e
		 */
		private function onSoundComplete(e:P3SoundEvent):void 
		{
			var sndObj:P3SoundObject = e.sound;
			if ( !sndObj.isManualDestroy)
			{
				sndObj.destroy();
				sndObj.removeEventListener(P3SoundEvent.COMPLETE, onSoundComplete);
			}
			if (_debug) dispatchEvent(new P3SoundEvent(P3SoundEvent.GROUP_UPDATE, null));
		}
		
		//GETTERS AND SETTERS
		
		public function get loc():Point { return _loc; }
		
		public function set loc(value:Point):void 
		{
			_loc = value;
		}
		
		public function get isMute():Boolean 
		{
			return _isMute;
		}
		
		//Added a boolean to check if music is currently playing.
		public function get isMusicPlaying ():Boolean
		{
			var music_group:P3SoundGroup = getSoundGroup(SG_MUSIC);
			for each (var sound:P3SoundObject in music_group.sounds)
			{
				if (sound.isPlaying && !sound.isFadingOut)
				{
					return true;
				}
			}
			return false;
		}
		
		
		//DEPRICATED
	
		/**
		 * OLD BULLSHIT. DON'T USE THESE ANY MORE OR THE GHOST OF BADGER WILL HAUNT YOU FOREVER
		 * @param	$class
		 * @param	$volume
		 * @param	$loops
		 * @param	$fade_in
		 * @param	$delay
		 * @param	$startTime
		 * @param	$location
		 * @param	$group
		 * @return
		 */
		public function playSoundClass($class:Class, $volume:Number = 1.0, $loops:int = 0, $fade_in:Number = 0, $delay:Number = 0, $startTime:Number = 0, $location:Point = null, $group:String = ""):IP3SoundObject
		{
			var vars:P3SoundParams = new P3SoundParams ();
			vars.volume = $volume;
			vars.fadeIn = $fade_in;
			vars.delay = $delay;
			vars.loops = $loops;
			vars.startTime = $startTime;
			vars.group = $group;
			return playSound ($class, vars);
		}
		
		/**
		 * OLD BULLSHIT. DON'T USE THESE ANY MORE OR THE GHOST OF BADGER WILL HAUNT YOU FOREVER
		 * @param	$class
		 * @param	$volume
		 * @param	$loops
		 * @param	$fade_in
		 * @param	$delay
		 * @param	$startTime
		 * @param	$location
		 * @param	$group
		 * @return
		 */
		public function playSoundRandomClass ($classes:Array,$volume:Number = 1.0, $loops:int = 0,$fade_in:Number = 0, $delay:Number = 0, $startTime:Number = 0, $location:Point = null, $type:String = ""):IP3SoundObject
		{
			var vars:P3SoundParams = new P3SoundParams ();
			vars.volume = $volume;
			vars.fadeIn = $fade_in;
			vars.delay = $delay;
			vars.loops = $loops;
			vars.startTime = $startTime;
			vars.group = $type;
			return playRandomSound ($classes, vars);
		}
		
		public function get soundGroup ():P3SoundGroup
		{
			return getSoundGroup(SG_SOUNDS);
		}
		
		public function get musicGroup ():P3SoundGroup
		{
			return getSoundGroup(SG_MUSIC);
		}
		
		public function get music():P3SoundObject 
		{
			return _music;
		}
	}
	
}