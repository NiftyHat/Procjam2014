/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.mobile
{
	
	import com.facebook.graph.FacebookMobile;
	import com.p3.apis.facebookgraph.P3FBAbstract;
	import com.p3.apis.facebookgraph.P3FacebookGraph;
	import com.p3.apis.facebookgraph.controllers.P3FBRequestController;
	import com.p3.apis.facebookgraph.data.P3FBUserList;
	import com.p3.apis.facebookgraph.events.P3FBEvent;
	import com.p3.apis.facebookgraph.interfaces.IP3FBGraph;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
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
	[Event(name="net_got_global_scores", 				type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="net_set_score_complete", 				type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	
	
	
	
	public class P3FBMobile extends P3FBAbstract implements IP3FBGraph
	{	
		
		private var _appID								:String
		private var _appOrigin							:String
		private var _stage								:Stage
		private var _dataURL							:String
		private var _requests							:P3FBRequestController;
		private var _permissions						:Array
		
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBMobile( $appID:String, $stage:Stage, $appOrigin:String, $dataUrl:String, $permissions:Array ) 
		{
			_appID = $appID;
			_appOrigin = $appOrigin;
			_stage = $stage;
			_dataURL = $dataUrl;
			_permissions = $permissions;
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		/**
		 * Initalise the API.<br />
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong> 
		 */
		public function init():void
		{
//			SETUP THE REQUIRED VARIABLES
			_isLoggedIn = false;
			_isCheckedIn = false;
			_userList = new P3FBUserList();
			_requests = new P3FBRequestController( requestData );
			
//			CHECKIN TO THE SERVER
//			checkin();
			
//			DISPATCH THE LOGGING IN EVENT
			dispatchEvent( new P3FBEvent( P3FBEvent.LOGGING_IN ))
			
			FacebookMobile.init( _appID, handleLogin );
		}
		
		
		/**
		 * Check the user into the Electrostar service made by Andy.<br />
		 * <br />
		 * This dispatches the P3FBEvent.CHECKING_IN event<br />
		 * <br />
		 * This call needs to be made once the user has logged into Facebook so that 
		 * their details can be passed through and an Access Token can be retrieved.
		 */
		override public function checkin():void
		{
//			DISPATCH THE CHECKING IN EVENT
			dispatchEvent( new P3FBEvent( P3FBEvent.CHECKING_IN ));
			
			_isCheckedIn = true;
			
//			CALL THE ELECTROSTAR SERVICE TO CHECK THE USER IN AND GET AN ACCESS TOKEN
			if ( userList.myself && userList.myself.uid )
			{
				var username:String = ( userList.myself.username == "" ) ? userList.myself.name : userList.myself.username
				_requests.addRequest( "checkIn", { user_id:userList.myself.uid, user_name:username, user_email:userList.myself.email, platform:"mobile" });
			}
			else
			{
				_isCheckedIn = false;
			}
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
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong> 
		 * 
		 * @param $permissions - An Array of Permissions from P3FBPermissions.
		 */
		public function login( $permissions:Array ):void
		{
			_permissions = $permissions;
//			CALL FACEBOOK MOBILE TO LOGIN
//			authorize( _appID, _permissions );
			FacebookMobile.login( handleLogin, _stage, $permissions );
		}
		
		
		/**
		 * Log the user out of facebook <br />
		 * <br />
		 * The following events will be dispatched:
		 * <ul>
		 * 	 <li>P3FBEvent.FB_LOGGED_OUT</li>
		 * </ul>
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong> 
		 * 
		 */
		public function logout():void
		{
//			SET LOGGED IN TO FALSE
			_isLoggedIn = false;
			
//			CALL FACEBOOK MOBILE TO LOGOUT
			FacebookMobile.logout( handleLogout, _appOrigin );
		}
		
		
		/**
		 * If you need to get the user details you can call this function.<br />
		 * <br />
		 * <strong>NOTE:</strong><br />
		 * The user details are automatically returned and stored when the user is logged in.
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 */
		public function getUserDetails():void
		{
//			MAKE A FACEBOOK API CALL THROUGH FACEBOOK MOBILE
			FacebookMobile.api( "/me", handleUserDetails );
		}
		
		
		/**
		 * Get a list of the users friends, you can specify wether you would like the friends 
		 * who have installed the app or all of the users friends. There is limited details available 
		 * unless you have used permissions when loggin the user in.<br />
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 * 
		 * @param $app - This is a boolean set to true to get the users who have installed the app, 
		 * false to get all of the users friends
		 */
		public function getFriends( $isAppUser:Boolean ):void
		{
//			CREATE THE FACEBOOK QUERY STRING TO MAKE A FQL QUERY
//			var fql:String = "SELECT "+ P3FBUser.fb_user_fields +" FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = 515430537) AND is_app_user = " + (($isAppUser) ? "1" : "0");
			var fql:String = "SELECT uid FROM user WHERE has_added_app=1 and uid IN (SELECT uid2 FROM friend WHERE uid1=me())";
			
//			CALL FACEBOOK MOBILE AND MAKE A FQL QUERY
			FacebookMobile.fqlQuery( fql, handleUserFriends );
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
//			ADD SOME DEFAULTS TO THE PARAMS
			$params.from = P3FacebookGraph.userList.myself.uid;
			$params.dialog = "http://www.facebook.com/dialog/feed";
			if ( !$params.redirect_uri ) $params.redirect_uri = _appOrigin;
			
//			CREATE THE STAGE WEB VIEW FOR THE MOBILE WINDOW
			var webView:StageWebView = new StageWebView();
			webView.viewPort = new Rectangle( 0, 0, _stage.stageWidth, _stage.stageHeight )
			webView.stage = _stage;
			
//			CRAETE THE WINDOW AND OPEN IT
			var window:P3FBMobileWindow = new P3FBMobileWindow();
			window.open( $params, webView, _appID );
		}
		
		
		/**
		 * Show a Facebook App Request Dialog, this allows you invite your friends to install the app.<br />
		 * <br />
		 * More details about the requests Dialog can be found here:<br />
		 * https://developers.facebook.com/docs/reference/dialogs/requests/<br />
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 * 
		 * @param $params - An object containing the following paramaters (NOTE that some of these are required(&#42)):
		 * <ul>
		 * <li><strong>app_id&#42</strong> - Your application's identifier. Required, but automatically specified by most SDKs.</li>
		 * <li><strong>redirect_uri&#42</strong> - The URL to redirect to after the user clicks a button on the dialog. Required, but automatically specified by most SDKs.</li>
		 * <li><strong>message</strong> - The Request string the receiving user will see. It appears as a request posed by the sending user. The maximum length is 255 characters. The message value is not displayed in Notifications and can only be viewed on the Apps and Games Dashboard. Invites (requests where the recipient has not installed the app) do not display this value.</li>
		 * <li><strong>to</strong> - A user ID or username. This may or may not be a friend of the user. If this is specified, the user will not have a choice of recipients. If this is omitted, the user will see a Multi Friend Selector and will be able to select a maximum of 50 recipients. (Due to URL length restrictions, the maximum number of recipients is 25 in IE7/IE8 when using a non-iframe dialog.)</li>
		 * <li><strong>filters</strong> - Optional, default is '', which shows a Multi Friend Selector that includes the ability for a user to browse all friends, but also filter to friends using the application and friends not using the application. Can also be all, app_users and app_non_users. This controls what set of friends the user sees if a Multi Friend Selector is shown. If all, app_users ,or app_non_users is specified, the user will only be able to see users in that list and will not be able to filter to another list. Additionally, an application can suggest custom filters as dictionaries with a name key and a user_ids key, which respectively have values that are a string and a list of user IDs. name is the name of the custom filter that will show in the selector. user_ids is the list of friends to include, in the order they are to appear.<br />
		 *		<ul>
		 * 			<li><strong>Example #1</strong> - [{name: 'Neighbors', user_ids: [1, 2, 3]}, {name: 'Other Set', user_ids: [4,5,6]}]</li>
		 *			<li><strong>Example #2</strong> - ['app_users']</li>
		 * 		</ul></li>
		 * <li><strong>data</strong> - Optional, additional data you may pass for tracking. This will be stored as part of the request objects created. The maximum length is 255 characters.</li>
		 * <li><strong>title</strong> - Optional, the title for the Dialog. Maximum length is 50 characters.</li>
		 * </ul>
		 */
		public function showRequestsDialog( $params:Object ):void
		{
//			ADD SOME DEFAULTS TO THE PARAMS
			$params.dialog = "http://www.facebook.com/dialog/apprequests";
			if ( !$params.redirect_uri ) $params.redirect_uri = _appOrigin;
			
//			CREATE THE STAGE WEB VIEW FOR THE MOBILE WINDOW
			var webView:StageWebView = new StageWebView();
			webView.viewPort = new Rectangle( 0, 0, _stage.stageWidth, _stage.stageHeight )
			webView.stage = _stage;
			
//			CREATE THE NEW MOBILE WINDOW AND OPEN IT
			var window:P3FBMobileWindow = new P3FBMobileWindow();
			window.open( $params, webView, _appID );
		}
		
		
		/**
		 * Get the highscores for the app, this is a basic function which may or may not be used. It is 
		 * primarilly used for small projects which just need a global and friends highscores and setting 
		 * a score.<br />
		 * <br />
		 * The user needs to be checked in for this function to be called<br/>
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 * 
		 * @param $page - Allows for paginated results, starts at 1 not 0
		 * @param $limit - The max number of results per page, pass 0 for everything
		 * @param $type - Either ASC (lower score best) or DESC (highest score best), depending on the scoring type of the game
		 */
		public function getScores( $page:Number=1, $limit:Number=10, $type:String="DESC" ):void
		{
//			CALL THE ELECTROSTAR SERVER TO GET THE SCORES
			_requests.addRequest( "getGlobalScores", { page:$page, limit:$limit, type:$type });
		}
		
		
		/**
		 * Get the highscores for the app, this is a basic function which may or may not be used. It is 
		 * primarilly used for small projects which just need a global and friends highscores and setting 
		 * a score.<br />
		 * <br />
		 * The user needs to be checked in for this function to be called<br/>
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 * 
		 * @param $friends - An Array of friend IDs
		 * @param $page - Allows for paginated results, starts at 1 not 0
		 * @param $limit - The max number of results per page, pass 0 for everything
		 * @param $type - Either ASC (lower score best) or DESC (highest score best), depending on the scoring type of the game
		 */
		public function getFriendsScores( $friends:Array=null, $page:Number=1, $limit:Number=10, $type:String="DESC" ):void
		{
//			CALL THE ELECTROSTAR SERVER TO GET THE SCORES
			_requests.addRequest( "getFriendsScores", { friends:$friends, page:$page, limit:$limit, type:$type });
		}
		
		
		
		public function call( $function:String, $data:Object=null ):void
		{
//			CALL THE ELECTROSTAR SERVER TO GET THE SCORES
			_requests.addRequest( $function, $data );			
		}
		
		
		/**
		 * Send the Users score to the server so that it can be stored within the database, the user needs 
		 * to be checked in for this function to be called<br />
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 * 
		 * @param $score - The Users score
		 * @param $type - ASC or DESC, default is DESC so if the users score is higher than the current it will be stored
		 */
		public function setScore( $score:Number, $type:String="DESC" ):void
		{
//			CALL THE ELECTROSTAR SERVER TO SET THE SCORE
			_requests.addRequest( "setScore", { score:$score, type:$type });
		}
		
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/
		
		/**
		 * Request data makes the calls to the Electrostar service and cues them up if needed
		 * 
		 * @param $function
		 * @param $data
		 */
		private function requestData( $function:String, $data:Object=null ):void
		{
//			SETS UP THE VARIABLES TO SEND
			var vars:URLVariables = new URLVariables()
			vars.method = $function
			vars.args = createData( $data );
			vars.timestamp = timestamp
			
//			CREATES A URL REQUEST
			var request:URLRequest = new URLRequest( _dataURL )
			request.data = vars
			request.method = URLRequestMethod.POST;
				
//			CREATES THE LOADER AND LOADES THE REQUEST
			var loader:URLLoader = new URLLoader()
			loader.addEventListener( IOErrorEvent.IO_ERROR, onDataLoadErrorEventHandler );
			loader.addEventListener( Event.COMPLETE, onDataLoadCompleteEventHandler );
			loader.load( request );
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

		private function onDataLoadErrorEventHandler( e:IOErrorEvent ):void
		{
			dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, e ));
		}
		
		

		private function onDataLoadCompleteEventHandler( e:Event ):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader
			loader.removeEventListener( Event.COMPLETE, onDataLoadCompleteEventHandler );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, onDataLoadErrorEventHandler );
			
			var json:Object = getData( loader.data );
			
			switch( json.method )
			{
				case "checkIn" :				handleCheckIn( json.data, json.error );					break;
				case "getGlobalScores" :		handleScores( json.data, json.error, true );			break;
				case "getFriendsScores" :		handleScores( json.data, json.error, false );			break;
				case "setScore" :				handleSetScore( json.data, json.error );				break;
				default :						handleCustomCall( json );								break;
			}
			
			_requests.nextReq();
		}
		

		
/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
	}
}