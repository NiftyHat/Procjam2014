package com.p3.apis.miniclip
{
	import com.miniclip.events.AuthenticationEvent;
	import com.miniclip.events.AwardsEvent;
	import com.miniclip.events.GameManagerEvent;
	import com.miniclip.events.HighscoreEvent;
	import com.miniclip.MiniclipGameManager;
	import com.p3.apis.miniclip.store.MiniclipStoreHandler;
	import com.p3.common.events.P3LogEvent;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * Wrapper for Miniclip API
	 *
	 * inits game
	 *
	 * show / post highscores
	 * give awards
	 *
	 *
	 * @author Mark Dooney
	 */
	//[Event(name="complete",type="flash.events.Event")]
	//[Event(name="error",type="flash.events.ErrorEvent")]
	
	/** This is an ASDoc comment */
	[Event(name="complete", type="flash.events.Event")] 
	[Event(name = "error", type = "flash.events.ErrorEvent")]
	/**
	 * Dispatches when the user is logged in. Good for showing usability of shop stuff
	 */
	[Event(name="connect", type="flash.events.Event")]
	public class MiniclipHandler extends EventDispatcher
	{
		
		/** Access for singleton  */
		public static function get instance():MiniclipHandler
		{
			ErrorEvent.ERROR
			return _instance;
		}
		
		/** Stores returned data from giveAward() */
		public var awardsDataObject:Object;
		protected var debugger:MovieClip
		
		/** Stores user data */
		public var userDataObject:Object;
		
		/** Store referance */
		protected var m_store:MiniclipStoreHandler= new MiniclipStoreHandler();
		protected var m_isLoggedIn:Boolean;
		protected var m_isMiniclip:Boolean;
		
		/** url for the miniclip website */
		static protected const URL_MINICLIP:String = "http://www.miniclip.com";
		
		/**:::IMPORTANT:::
		 * Initialisation MUST happen before game is started / Initialised
		 * ---------------------------------------------------------------
		 * Event.COMPLETE dispatched when all ready
		 *
		 *
		 * @param stage Reference to swf stage
		 * @param invalidLocationCallback (Optional) Called if game is loaded from invalid location :: Else never dispatches Event.COMPLETE
		 */
		public function init(stage:Stage, invalidLocationCallback:Function = null):void
		{
			//m_store 
			if (invalidLocationCallback != null)
				this.invalidLocationCallback = invalidLocationCallback;
			MiniclipGameManager.addEventListener(GameManagerEvent.READY, onMiniclipReady);
			MiniclipGameManager.init(stage);
			
		//
			
		}
		
		/** Show miniclip highscores table for specific level
		 *
		 * @param levelId Specific level, leave as 0 for global scores
		 * */
		public function showScores(levelId:int = 0):void
		{
			MiniclipGameManager.services.addEventListener(HighscoreEvent.CLOSE, onScoresClosed);
			MiniclipGameManager.services.showHighscores(levelId);
		}
		
		/** Post a score to miniclip and show highscores table
		 *
		 * @param score The player's score
		 * @param levelId Specific level, leave as 0 for global scores
		 * */
		public function postScore(score:int, index:int, name:String = ""):void
		{
			MiniclipGameManager.services.addEventListener(HighscoreEvent.CLOSE, onScoresClosed);
			MiniclipGameManager.services.saveHighscore(score, index, name);
		}
		
		/** Give miniclip award -- n.b. Awards are created + managed by Miniclip
		 * If callbacks for FAIL & ERROR are not supplied, Event.COMPLETE is always returned
		 * returned data is stored in "awardsDataObject" in all cases
		 *
		 * @param awardId Id of earned award
		 * @param failCallback Function to call if award fails - normally because user already has it
		 * @param errorCallback Function to call if an Error occurs - normally a server problem
		 * */
		public function giveAward(awardId:uint, failCallback:Function = null, errorCallback:Function = null):void
		{
			if (failCallback != null)
				awardsFailCallback = failCallback;
			if (errorCallback != null)
				awardsErrorCallback = errorCallback;
			
			MiniclipGameManager.services.addEventListener(AwardsEvent.SUCCESS, onAwardsResponse);
			MiniclipGameManager.services.addEventListener(AwardsEvent.FAIL, onAwardsResponse);
			MiniclipGameManager.services.addEventListener(AwardsEvent.ERROR, onAwardsResponse);
			
			MiniclipGameManager.services.giveAward(awardId);
		}
		
		/** Track miniclip events
		 * Tracking IDs are supplied by Miniclip
		 *
		 * @param trackingId Event to track;
		 */
		public function track(trackingId:String):void
		{
			if (MiniclipGameManager.services)
				MiniclipGameManager.services.trackAds(trackingId);
			else
				trace("Must be on miniclip to use MiniClip tracking");
		}
		
		/** Check if user is logged in
		 *
		 * populates userDetails on completion
		 *
		 */
		public function isUserLoggedIn():void
		{
			MiniclipGameManager.services.addEventListener(AuthenticationEvent.USER_DETAILS, onUserDetailsReceived);
			MiniclipGameManager.player.isLoggedIn();
		}
		
		/** Retrieve user details
		 *
		 * populates userDetails on completion
		 *
		 */
		public function getUserDetails():void
		{
			MiniclipGameManager.services.addEventListener(AuthenticationEvent.USER_DETAILS, onUserDetailsReceived);
			MiniclipGameManager.player.getUserDetails();
		}
		
		/** Opens the miniclip website
		 *
		 * opens the miniclip website, default to open in a new tab
		 *
		 */
		public function openMiniclipSite($new_tab:Boolean = true):void
		{
			if ($new_tab)
				navigateToURL(new URLRequest(URL_MINICLIP), "_blank");
			else
				navigateToURL(new URLRequest(URL_MINICLIP), "_self");
		
		}
		
		public function login():void
		{
			MiniclipGameManager.addEventListener(AuthenticationEvent.LOGIN, onPlayerLogin);
			
			MiniclipGameManager.player.login(false, true, true);
			if (MiniclipGameManager.player.isAlreadyLoggedIn())
			{
				dispatchEvent(new P3LogEvent(P3LogEvent.LOG, "login was called and the player was already logged in :("));
				m_isLoggedIn = true;
			}			
		}
		
		public function logout():void {
			MiniclipGameManager.addEventListener(AuthenticationEvent.LOGOUT, onPlayerLogout);
			MiniclipGameManager.player.logout();
		}
		

		
		/*
		 * ***************************************************
		 *                 --== Private ==--
		 * ***************************************************
		 */
		
		/* Singleton bumf */
		private static var _instance:MiniclipHandler = new MiniclipHandler;
		
		public function MiniclipHandler()
		{
			if (_instance)
				throw new Error("ERROR :: Singleton class -- Access via MiniclipHandler.instance");
		}
		
		public function logError($text:String):void 
		{
			if (this.hasEventListener(ErrorEvent.ERROR)) dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false,$text));
		}
		
		/* Callbacks from methods with multiple return possibilities */
		private var invalidLocationCallback:Function;
		private var awardsFailCallback:Function;
		private var awardsErrorCallback:Function;
		
		/* --== Events ==-- */
		private function allDone():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/* Highscores closed */
		private function onScoresClosed(e:HighscoreEvent):void
		{
			//MiniclipGameManager.services.addEventListener
			MiniclipGameManager.services.removeEventListener(HighscoreEvent.CLOSE, onScoresClosed);
			allDone();
		}
		
		/* Handle user details */
		private function onUserDetailsReceived(e:AuthenticationEvent):void
		{
			MiniclipGameManager.services.removeEventListener(AuthenticationEvent.USER_DETAILS, onUserDetailsReceived);
			if (!userDataObject) m_store.init();
			userDataObject = MiniclipGameManager.player.userDetails;
			
			dispatchEvent(e);
			allDone();
		}
		
		/* Handle awards */
		private function onAwardsResponse(e:AwardsEvent):void
		{
			awardsDataObject = e.data;
			
			if (e.type == AwardsEvent.SUCCESS)
			{
				allDone();
			}
			else if (e.type == AwardsEvent.FAIL)
			{
				awardsFailCallback != null ? awardsFailCallback() : allDone();
			}
			else if (e.type == AwardsEvent.ERROR)
			{
				awardsErrorCallback != null ? awardsErrorCallback() : allDone();
			}
		}
		
		/* Game Manager is ready */
		private function onMiniclipReady(e:GameManagerEvent):void
		{
			MiniclipGameManager.removeEventListener(GameManagerEvent.READY, onMiniclipReady);
			trace("miniclip is ready!");
			if (MiniclipGameManager.services.validateLocation()) //
			{
				trace("setting up store!");
				MiniclipGameManager.addEventListener(GameManagerEvent.GAME_READY, onGameReady);
				
				m_isMiniclip = true;
			}
			else
			{
				if (invalidLocationCallback != null)
					invalidLocationCallback();
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "invalid location"));
			}
		}
		
		/* Game itself is ready */
		private function onGameReady(e:GameManagerEvent):void
		{
			dispatchEvent(new P3LogEvent(P3LogEvent.LOG, "game is ready!"));
			MiniclipGameManager.removeEventListener(GameManagerEvent.GAME_READY, onGameReady);
			if (MiniclipGameManager.player.isAlreadyLoggedIn())
			{
				dispatchEvent(new P3LogEvent(P3LogEvent.LOG, "player is already logged in"));
				getUserDetails();
				m_isLoggedIn = true;	
			}
			else
			{
				dispatchEvent(new P3LogEvent(P3LogEvent.LOG, "player is not already logged in"));
				m_store.init();
				allDone();
			}
			
		}
		
		private function onPlayerLogin(e:AuthenticationEvent):void
		{
			m_isLoggedIn = true;
			allDone();
			//m_store.init();
		}
		
		private function onPlayerLogout(e:AuthenticationEvent):void 
		{
			m_isLoggedIn = false;
			allDone();
		}
		
		public function get store():MiniclipStoreHandler
		{
			return m_store;
		}
		
		public function get isLoggedIn():Boolean
		{
			return m_isLoggedIn;
		}
		
		public function get isMiniclip():Boolean
		{
			return m_isMiniclip;
		}
	
	}

}