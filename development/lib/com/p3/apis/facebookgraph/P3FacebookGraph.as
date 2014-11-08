package com.p3.apis.facebookgraph
{
	
	import com.p3.apis.facebookgraph.data.P3FBUserList;
	import com.p3.apis.facebookgraph.events.P3FBEvent;
	import com.p3.apis.facebookgraph.interfaces.IP3FBGraph;
	import com.p3.apis.facebookgraph.online.P3FBOnline;
	import flash.system.Security;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	
	
	
	[Event(name="facebook_logging_in", 					type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="facebook_login_complete", 				type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="facebook_login_failed", 				type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="facebook_logged_out", 					type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="facebook_got_friends", 				type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="facebook_got_myself", 					type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="facebook_got_api_result", 				type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="facebook_error", 						type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="net_checking_in", 						type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="net_checked_in", 						type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="net_got_friends_scores", 				type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name = "net_got_global_scores", 				type = "com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="net_set_score_complete", 				type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="facebook_log", 						type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	
	
	/**
	 * DEPEDANCIES
	 * actionsjson.swc - ActionJSON library, faster JSON in FP10 and native support for FP11+
	 * as3crypto.swc - hurlant cryptography library, used for encryption mode.
	 * OPTIONAL
	 * MinimalComps_0_9_10.swc - for debugger.
	 * 
	 * The P3FacebookGraph is a controller for one of currently two facebook apis, one for 
	 * Online and the other for Mobile.<br />
	 * <br />
	 * This class is a singleton so you should use P3FacebookGraph.inst.<br />
	 * <br />
	 * You will need to call P3FacebookGraph.inst.init() to set up the API before any calls are made. 
	 * With P3FBMobile you will need to set up P3FBMobileVars before calling P3FacebookGraph.inst.init()
	 * This is to set up any variables required before Facebook initalizes.<br />
	 * <br />
	 * Once you make the call to P3FacebookGraph.inst.init() a check will be made to see if you are logged 
	 * into facebook or have previously been logged in to see if the user has a valid access token.<br />
	 * <br />
	 * The Online version uses External interface calls to handle all of the facebook data. 
	 * This enables Andy to log the user into facebook before the app is loaded.<br />
	 * <br />
	 * The Mobile version currenly uses the AS3 Facebook Api which can be found here: 
	 * <a href='http://code.google.com/p/facebook-actionscript-api'>http://code.google.com/p/facebook-actionscript-api/</a> <br />
	 * <br />
	 * It may get an overhal at some point to use a Native Extension and implement the 
	 * IOS and Android Facebook APIs. This is because the AS3 Api is a little buggie.<br />
	 * <br />
	 * 
	 * @author Duncan Saunders (was Chris Andrews)
	 */
	public class P3FacebookGraph extends EventDispatcher
	{
		
		private static var 	_instance					:P3FacebookGraph;
		private static var 	_allowInstance				:Boolean;
		
		private var api									:IP3FBGraph;
		
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FacebookGraph()
		{
			if (!P3FacebookGraph._allowInstance) throw new Error("Error: Use P3FacebookGraph.inst instead of the new keyword.");
		}
		
		
		
		public static function get inst():P3FacebookGraph
		{
			if (P3FacebookGraph._instance == null)
			{
				P3FacebookGraph._allowInstance		= true;
				P3FacebookGraph._instance			= new P3FacebookGraph();
				P3FacebookGraph._allowInstance		= false;
			}
			return P3FacebookGraph._instance;
		}
		
		
				
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		/**
		 * Initalise the P3FacebookGraph controller passing in the required API to use.<br />
		 * <br />
		 * This sets the api if one is defined, sets up the event listeners and initalises the api.<br />
		 * <br />
		 * You should set the following event listeners before calling init():<br />
		 * <ul>
		 * 	 <li>P3FBEvent.FB_LOGGING_IN</li>
		 * 	 <li>P3FBEvent.FB_LOGIN_COMPLETE</li>
		 *	 <li>P3FBEvent.FB_LOGIN_FAILED</li>
		 *	 <li>P3FBEvent.FB_CHECKING_IN</li>
		 *	 <li>P3FBEvent.FB_CHECKED_IN</li>
		 * </ul>
		 * This is so that you can capture if the user gets automatically logged in by the API.<br />
		 * <br />
		 * @param $api - An instance of the interface IP3FBGraph, if this is null then the P3FBOnline API is used instead.
		 */
		public function init( $api:IP3FBGraph=null ):void
		{
//			IF THE API HASNT BEEN SET THEN SET IT TO THE DEFAULT API
			this.api = ( $api ) ? $api : new P3FBOnline();
			
			Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
            Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");    
						
//			ADD THE API EVENT HANDLERS
			addApiEventHandlers();
			
//			INITALIZE THE API
			this.api.init();
		}
		
		
		/**
		 * Check the user into the Electrostar service made by Andy.<br />
		 * <br />
		 * This dispatches the P3FBEvent.CHECKING_IN event<br />
		 * <br />
		 * This call needs to be made once the user has logged into Facebook so that 
		 * their details can be passed through and an Access Token can be retrieved.
		 */
		public function checkin():void
		{
			api.checkin();
		}
		
		
		/**
		 * Log the user into facebook, this function required you to pass permissions these can be found within 
		 * P3FBPermissions and description of what each one is. If you dont require any permissions then you can 
		 * just pass an empty array.<br />
		 * <br />
		 * The following events will be dispatched:
		 * <ul>
		 * 	 <li>P3FBEvent.FB_LOGIN_COMPLETE</li>
		 *	 <li>P3FBEvent.FB_LOGIN_FAILED</li>
		 * </ul>
		 * 
		 * @param $permissions - An Array of Permissions from P3FBPermissions.
		 */
		public function login( $permissions:Array ):void
		{
			api.login( $permissions );
		}
		
		
		/**
		 * Log the user out of facebook <br />
		 * <br />
		 * The following events will be dispatched:
		 * <ul>
		 * 	 <li>P3FBEvent.FB_LOGGED_OUT</li>
		 * </ul>
		 * 
		 */
		public function logout():void
		{
			api.logout();
		}
		
				
		/**
		 * If you need to get the user details you can call this function.<br />
		 * <br />
		 * <strong>NOTE:</strong><br />
		 * The user details are automatically returned and stored when the user is logged in.
		 * 
		 */
		public function getUserDetails():void
		{
			api.getUserDetails();
		}
		
			
		/**
		 * Get a list of the users friends, you can specify wether you would like the friends 
		 * who have installed the app or all of the users friends. There is limited details available 
		 * unless you have used permissions when loggin the user in. This function isn't avalible
		 * or needed in the FBOnline wrapper as FBHub already populates a list with the uids.
		 * 
		 * @param $app - This is a boolean set to true to get the users who have installed the app, 
		 * false to get all of the users friends
		 */
		public function getFriends( $app:Boolean ):void
		{
			api.getFriends( $app );
		}
		
		
		/**
		 * Get the highscores for the app, this is a basic function which may or may not be used. It is 
		 * primarilly used for small projects which just need a global and friends highscores and setting 
		 * a score.<br />
		 * <br />
		 * The user needs to be checked in for this function to be called<br/>
		 * 
		 * @param $users - List of UID's you want scores for. Specify null for all users.
		 * @param $page - Allows for paginated results, starts at 1 not 0
		 * @param $limit - The max number of results per page, pass 0 for everything
		 * @param $type - Either ASC (lower score best) or DESC (highest score best), depending on the scoring type of the game
		 */
		public function getScores($users:Array = null, $page:Number = 1, $limit:Number = 10, $type:String = "DESC" ):void
		{
			api.getScores($users, $page, $limit, $type );
		}
		
		
		/**
		 * Get the highscores for the app, this is a basic function which may or may not be used. It is 
		 * primarilly used for small projects which just need a global and friends highscores and setting 
		 * a score.<br />
		 * <br />
		 * The user needs to be checked in for this function to be called<br/>
		 * 
		 * @param $friends - An Array of friend IDs, specify null for all friends.
		 * @param $page - Allows for paginated results, starts at 1 not 0
		 * @param $limit - The max number of results per page, pass 0 for everything
		 * @param $type - Either ASC (lower score best) or DESC (highest score best), depending on the scoring type of the game
		 */
		public function getFriendsScores( $friends:Array=null, $page:Number=1, $limit:Number=10, $type:String="DESC" ):void
		{
			api.getFriendsScores( $friends, $page, $limit, $type );
		}
		
		
		/**
		 * Send the Users score to the server so that it can be stored within the database, the user needs 
		 * to be checked in for this function to be called<br />
		 * 
		 * @param $score - The Users score
		 * @param $type - ASC or DESC, default is DESC so if the users score is higher than the current it will be stored
		 */
		public function setScore( $score:Number, $type:String="DESC" ):void
		{
			api.setScore( $score, $type );
		}
		
		
		/**
		 * Show a Facebook Feed Dialog, this allows you to post a message, a score, a link etc to the users 
		 * Facebook timeline.<br />
		 * <br />
		 * More details about the feed Dialog can be found here:<br />
		 * http://developers.facebook.com/docs/reference/dialogs/feed/<br />
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 * 
		 * @param $params - An object containing the following paramaters (NOTE that some of these are required(&#42)):
		 * <ul>
		 * <li><strong>link</strong> - The link attached to this post</li>
		 * <li><strong>picture</strong> - The URL of a picture attached to this post. The picture must be at least 50px by 50px and have a maximum aspect ratio of 3:1</li>
		 * <li><strong>source</strong> - The URL of a media file (e.g., a SWF or video file) attached to this post. If both source and picture are specified, only source is used.</li>
		 * <li><strong>name</strong> - The name of the link attachment.</li>
		 * <li><strong>caption</strong> - The caption of the link (appears beneath the link name).</li>
		 * <li><strong>description</strong> - The description of the link (appears beneath the link caption).</li>
		 * </ul>
		 */
		public function showFeedDialog( $params:Object=null ):void
		{
			api.showFeedDialog( $params );
		}
		
		
		/**
		 * Show a Facebook App Request Dialog, this allows you invite your friends to install the app.<br />
		 * <br />
		 * More details about the requests Dialog can be found here:<br />
		 * https://developers.facebook.com/docs/reference/dialogs/requests/<br />
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 * 
		 * @param $params - An object containing the following paramaters
		 * <ul>
		 * <li><strong>message</strong> - The Request string the receiving user will see. It appears as a request posed by the sending user. The maximum length is 255 characters. The message value is not displayed in Notifications and can only be viewed on the Apps and Games Dashboard. Invites (requests where the recipient has not installed the app) do not display this value.</li>
		 * <li><strong>title</strong> - Optional, the title for the Dialog. Maximum length is 50 characters.</li>
		 * </ul>
		 */
		public function showRequestsDialog( $params:Object ):void
		{
			api.showRequestsDialog( $params );
		}
		
		
		public function setAchivement ($id:int):void
		{
			api.setAchivement($id);
		}
		
		private function getAchivements ():void
		{
			api.getAchivements();
		}
		
		
		
		public function call( $function:String, $data:Object=null ):void
		{
			api.call( $function, $data );
		}
		
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/

		private function addApiEventHandlers():void
		{
			this.api.addEventListener( P3FBEvent.ERROR, onFBApiEventHandler );
//			this.api.addEventListener( P3FBEvent.GOT_API_RESULT, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.GOT_FRIENDS, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.GOT_FRIENDS_SCORES, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.GOT_GLOBAL_SCORES, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.GOT_MYSELF_RAW, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.GOT_CUSTOM_CALL, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.LOGGED_OUT, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.LOGGING_IN, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.LOGIN_COMPLETE, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.LOGIN_FAILED, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.CHECKED_IN, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.CHECKING_IN, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.SET_SCORE_COMPLETE, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.GOT_USER_INFO, onFBApiEventHandler );
			this.api.addEventListener( P3FBEvent.LOG, onFBApiEventHandler );
		}
		
		
		
		private function removeApiEventHandlers():void
		{
			this.api.removeEventListener( P3FBEvent.ERROR, onFBApiEventHandler );
//			this.api.removeEventListener( P3FBEvent.GOT_API_RESULT, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.GOT_FRIENDS, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.GOT_FRIENDS_SCORES, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.GOT_GLOBAL_SCORES, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.GOT_MYSELF_RAW, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.GOT_CUSTOM_CALL, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.LOGGED_OUT, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.LOGGING_IN, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.LOGIN_COMPLETE, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.LOGIN_FAILED, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.CHECKED_IN, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.CHECKING_IN, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.SET_SCORE_COMPLETE, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.GOT_USER_INFO, onFBApiEventHandler );
			this.api.removeEventListener( P3FBEvent.LOG, onFBApiEventHandler );
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

		private function onFBApiEventHandler( e:P3FBEvent ):void
		{
			dispatchEvent( e );
			e.preventDefault();
		}
		
		
		
/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
		/**
		 * Get the user list from the API
		 * 
		 * @return - P3FBUserList
		 */
		public static function get userList():P3FBUserList
		{
			return P3FacebookGraph.inst.userList
		}
		
		
		/**
		 * Get the user list from the API
		 * 
		 * @return - P3FBUserList
		 */
		public function get userList():P3FBUserList
		{
			return this.api.userList
		}
		
		
		public function get isLoggedIn():Boolean
		{
			return api.isLoggedIn;
		}
	}
}