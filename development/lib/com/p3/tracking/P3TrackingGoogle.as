package com.p3.tracking
{
	import com.google.analytics.GATracker;
	import com.p3.utils.functions.P3PadNumber;
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3TrackingGoogle 
	{
		
		//BEGIN SINGLETON
		
		private static var 	_inst				:P3TrackingGoogle = new P3TrackingGoogle ();		
		
		public function P3TrackingGoogle()
		{
			if (_inst)  throw new Error("P3TrackingGoogle and can only be accessed through P3TrackingGoogle.inst");
		}
		
		public static function get inst ():P3TrackingGoogle 
		{
			return _inst;
		}
		
		//END SINGLETON
		
		protected var 		_tracker			:GATracker;
		protected var 		_accountID			:String;
		protected var 		_stageRef			:Stage;
		protected var 		_sharedObject		:SharedObject;
		protected var 		_gameLabel			:String;
		protected var		_gamePrefix			:String = "";	
		
		protected var			_log			:Boolean;
		protected static const 	LOG_PRE			:String = "P3GoogleWrapper - "
		
		protected static const TRACK_LEVEL			:String = "level"
		protected static const TRACK_START			:String = "play"
		protected static const TRACK_END			:String = "complete"
		protected static const TRACK_GAME_END		:String = "gameEnd"
		protected static const TRACK_VIEW			:String = "view";
		protected static const TRACK_SKIP			:String = "skip";
		protected static const TRACK_USER			:String = "user";
		protected static const TRACK_TOKEN			:String = "token";
		protected static const TRACK_DOMAIN			:String = "domain";
		protected static const TRACK_GAME_COMPLETE	:String = "gameComplete";
		
		/**
		 * Initialized the tracking singleton. You MUST init the tracking before you can use it.
		 * @param	$stageRef - Refance to the stage, required
		 * @param	$accountId - Google tracking code in the form of UA-XXXXXXXX-X, ask gravy if you don't have one
		 * @param	$gamelabel - Lable that indentifies your game in tracking, prefix with "game/" for domains with other content
		 * @param	$gamePrefix - 2-6 letter prefix for the game to make tracking easier per domain.
		 * @param	$debugMode - Enables big ass google tracking panel, be wary when using this.
		 */
		public function init ($stageRef:Stage, $accountId:String, $gamelabel:String, $gamePrefix:String = null, $debugMode:Boolean = false):void
		{
			_accountID = $accountId;
			_gameLabel = $gamelabel;
			_stageRef = $stageRef
			_sharedObject = SharedObject.getLocal("p3_track");
			if (!_accountID)
			{
				trace(this, "YOU NEED AN ACCOUNT ID");
				return;
			}
			if (_tracker) return 
			_tracker = new GATracker (_stageRef, _accountID, "AS3", $debugMode);
			log("Tracking init!");
		}
		
/******************************************************************
* PAGE VIEW TRACKING
*******************************************************************/

		/**
		 * Event to send when the game has reached the title screen
		 */
		public function trackGameLoaded ():void
		{
			sendGamePage(_gameLabel + "_title");
		}

		/**
		 * Track when a player starts a level (pageview track the amount of time spent on the page.
		 * @param	$level Level id starting at 1;
		 */
		public function trackLevelStart ($level:int = 0):void
		{
			sendGamePage(TRACK_LEVEL + P3PadNumber($level + 1,2) + "_" + TRACK_START );
		}
		
		
		public function trackGameEnd ($reason:String = ""):void
		{
			sendGameEvent(TRACK_GAME_END, TRACK_GAME_END, true);
			sendGamePage(TRACK_GAME_END  + "_" + $reason);
		}

		public function trackView ($screen:String = "", $changePage:Boolean = false):void
		{
			if($changePage) sendGamePage("frontend"  + "_" + $screen);
			sendGameEvent(TRACK_VIEW,$screen);
		}
		
		
/******************************************************************
* EVENT TRACKING
*******************************************************************/
		
		public function trackLevelEnd ($level:int = 0, $time_ms:int = 1):void
		{
			var time:int = $time_ms / 1000;
			sendGameEvent(TRACK_LEVEL + P3PadNumber($level + 1,2) + "_" + TRACK_END,"",false,time);
		}
		
		public function trackSkip($screen_name:String = ""):void
		{
			sendGameEvent(TRACK_SKIP,$screen_name);
		}
		
		public function trackDomain ():void
		{
			var lc:LocalConnection = new LocalConnection ();
			var domain:String = lc.domain
			log("got domain as " + domain)
			sendGameEvent(TRACK_DOMAIN, domain);
		}
		
		public function trackGameComplete ():void
		{
			sendGameEvent(TRACK_GAME_COMPLETE, TRACK_GAME_COMPLETE, true);
		}
	
		public function trackPlayerGender ($gender:String):void
		{
			if (!$gender) return;
			sendGameEvent(TRACK_USER, TRACK_USER + "gender: " + $gender, true);
		}
		
		public function trackURLTokens ():void
		{
			if (!ExternalInterface.available) return;
			var url:String = ExternalInterface.call('window.location.href.toString');
			log("got url as " + url)
			if (url.indexOf("file://") != -1) 
			{
				log("no local tokens");
				return;
			}
			var i:int = url.search(/\?/g) 
			log ("split index = " + i);
			var tokens:String = url.slice (i);
			log("got tokens as " + tokens)
			var token_list:Array = tokens.split("\?");
			for each (var item:String in token_list)
			{
				var dat:Array = item.split("=");
				log("split token is " + dat);
				if(item.length > 1) sendGameEvent(TRACK_TOKEN + dat[0], dat[1]);
			}
		}
		
		public function sendGameEvent ($action:String, $label:String = "", $trackOnce:Boolean = false, $value:int = 1):void
		{
			if ($label == "") $label = $action;
			if ($trackOnce)
			{
				if (_sharedObject.data[$action]) return;
				else _sharedObject.data[$action] = true;
				
			}
			sendEvent(_gameLabel, _gamePrefix + $action, _gamePrefix + $label,$value);
		}
		
		public function sendGamePage ($page:String):void
		{
			if (_gameLabel) sendPage("/" +_gameLabel + "/" + $page);
			else sendPage("/" + $page);
			
		}
		
		public function sendPage ($url:String):void
		{
			if (!_tracker) 
			{
				log("You must init the tracker to use it!"); 
				return;
			}
			_tracker.trackPageview($url);
			log("Tracking pageview [ url:" + $url + "]");
		}
		
		public function sendEvent ($catagory:String, $action:String, $label:String = "", $value:Number = 1):void
		{
			var isTracked:Boolean
			if (!_tracker) 
			{
				log("You must init the tracker to use it!"); 
				return;
			}
			if ($label == "") $label = $action;
			_tracker.trackEvent($catagory, $action, $label, $value)
			if (!isTracked) log("failed to track event...");
			else log("Tracking event [ Catagory:" + $catagory + " Action:" + $action + " Label:" + $label + "]");
		}
		
		//replacement for trace so output from this class don't make as much mess;
		protected function log (text:String):void
		{
			if (_log) trace(LOG_PRE + text);
		}
		
		/**
		 * @param	$label - Lable that indentifies your game in tracking, prefix with "game/" for domains with other content
		 */
		public function setGameLabel ($label:String):void
		{
			_gameLabel = $label;
		}
		
		/**
		 * @param	$prefix - 2-6 letter prefix for the game to make tracking easier per domain.
		 */
		public function setGamePrefix ($prefix:String = ""):void
		{
			if ($prefix.length > 6) log ("game prefix is very long, consider using something shorter");
			_gamePrefix = $prefix + "_"
		}
		
		/**
		 * @param	$log - Enable or disable logging mode for debug.
		 */
		public function setLog ($log:Boolean):void
		{
			_log = $log;
		}
		
		
	}
	
}