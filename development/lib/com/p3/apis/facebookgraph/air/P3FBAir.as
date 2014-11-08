/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.air
{
	
	import com.milkmangames.nativeextensions.GoViral;
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	import com.p3.apis.facebookgraph.P3FBAbstract;
	import com.p3.apis.facebookgraph.controllers.P3FBRequestController;
	import com.p3.apis.facebookgraph.data.P3FBUser;
	import com.p3.apis.facebookgraph.data.P3FBUserList;
	import com.p3.apis.facebookgraph.events.P3FBEvent;
	import com.p3.apis.facebookgraph.interfaces.IP3FBGraph;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
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
	[Event(name="net_got_custom_call", 					type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	[Event(name="net_set_score_complete", 				type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	
	
	
	
	public class P3FBAir extends P3FBAbstract implements IP3FBGraph
	{	
		
		private static var _TOKEN						:String;
		
		private var _appID								:String
		private var _appOrigin							:String
		private var _dataURL							:String
		private var _requests							:P3FBRequestController;
		private var _fb_inst							:GoViral
		
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBAir( $appID:String, $appOrigin:String, $dataUrl:String ) 
		{
			_appID = $appID;
			_appOrigin = $appOrigin;
			_dataURL = $dataUrl;
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
			
//			INITALIZE FACEBOOK MOBILE AND DISPATCH THE LOGGING IN EVENT
			dispatchEvent( new P3FBEvent( P3FBEvent.LOGGING_IN ));
			
			GoViral.create()
			_fb_inst = GoViral.goViral
			_fb_inst.initFacebook( _appID );
			
			onFacebookLoginComplete( null );
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
			_fb_inst.addEventListener( GVFacebookEvent.FB_LOGGED_IN, onFacebookLoginComplete );
			_fb_inst.addEventListener( GVFacebookEvent.FB_LOGIN_CANCELED, onFacebookLoginCanceled );
			_fb_inst.addEventListener( GVFacebookEvent.FB_LOGIN_FAILED, onFacebookLoginCanceled );
			
			_fb_inst.authenticateWithFacebook( $permissions.toString());
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
//			CALL FACEBOOK MOBILE TO LOGOUT
			_fb_inst.addEventListener( GVFacebookEvent.FB_LOGGED_OUT, onFacebookLogoutComplete );
			_fb_inst.logoutFacebook();
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
			_fb_inst.addEventListener( GVFacebookEvent.FB_REQUEST_FAILED, onFacebookRequestFailedEventHandler );
			_fb_inst.addEventListener( GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookGetUserDetailsComplete );
			_fb_inst.requestMyFacebookProfile()
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
			
			_fb_inst.addEventListener( GVFacebookEvent.FB_REQUEST_FAILED, onFacebookRequestFailedEventHandler );
			_fb_inst.addEventListener( GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookGetUserFriendsComplete );
			_fb_inst.requestFacebookFriends({ fields:[ "installed", "name", "id" ]}) 
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
		 * <li><strong>app_id&#42</strong> - Your application's identifier. Required, but automatically specified by most SDKs.</li>
		 * <li><strong>redirect_uri&#42</strong> - The URL to redirect to after the user clicks a button on the dialog. Required, but automatically specified by most SDKs.</li>
		 * <li><strong>display</strong> - The display mode in which to render the dialog. The default is page on the www subdomain. display=wap is currently not supported. This is automatically specified by most SDKs.</li>
		 * <li><strong>from</strong> - The ID or username of the user posting the message. If this is unspecified, it defaults to the current user. If specified, it must be the ID of the user or of a page that the user administers.</li>
		 
		 * <li><strong>to</strong> - The ID or username of the profile that this story will be published to. If this is unspecified, it defaults to the the value of from.</li>
		 * <li><strong>link</strong> - The link attached to this post</li>
		 * <li><strong>picture</strong> - The URL of a picture attached to this post. The picture must be at least 50px by 50px and have a maximum aspect ratio of 3:1</li>
		 * <li><strong>source</strong> - The URL of a media file (e.g., a SWF or video file) attached to this post. If both source and picture are specified, only source is used.</li>
		 * <li><strong>name</strong> - The name of the link attachment.</li>
		 * <li><strong>caption</strong> - The caption of the link (appears beneath the link name).</li>
		 * <li><strong>description</strong> - The description of the link (appears beneath the link caption).</li>
		 * <li><strong>properties</strong> - A JSON object of key/value pairs which will appear in the stream attachment beneath the description, with each property on its own line. Keys must be strings, and values can be either strings or JSON objects with the keys text and href.</li>
		 * <li><strong>actions</strong> - A JSON array of action links which will appear next to the "Comment" and "Like" link under posts. Each action link should be represented as a JSON object with keys name and link.</li>
		 * <li><strong>ref</strong> - A text reference for the category of feed post. This category is used in Facebook Insights to help you measure the performance of different types of post.</li>
		 * </ul>
		 */
		public function showFeedDialog( $params:Object=null ):void
		{
			var name:String 		= ( $params.name ) ? $params.name : "";
			var caption:String 		= ( $params.caption ) ? $params.caption : "";
			var message:String 		= ( $params.message ) ? $params.message : "";
			var description:String 	= ( $params.description ) ? $params.description : "";
			var link:String 		= ( $params.link ) ? $params.link : "";
			var picture:String 		= ( $params.picture ) ? $params.picture : "";
			
			_fb_inst.showFacebookFeedDialog( name, caption, message, description, link, picture );
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
//			var message:String 	= ( $params.message ) ? $params.message : "";
//			var title:String 	= ( $params.title ) ? $params.title : "";
//			var data:String 	= ( $params.data ) ? $params.data : "";
//			var filters:String 	= ( $params.filters ) ? $params.filters : "";
//			var to:String 		= ( $params.to ) ? $params.to : "";
//			
			_fb_inst.showFacebookRequestDialog( $params.message, $params.title, $params.data, $params.filters, $params.to );
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
		public function getScores( $page:Number=1, $limit:Number=10, $type:String="DESC" ):void
		{
//			CALL THE ELECTROSTAR SERVER TO GET THE SCORES
			_requests.addRequest( "getGlobalScores", { page:$page, limit:$limit, type:$type });
		}
		
		public function getFriendsScores( $friends:Array=null, $page:Number=1, $limit:Number=10, $type:String="DESC" ):void
		{
//			CALL THE ELECTROSTAR SERVER TO GET THE SCORES
			_requests.addRequest( "getFriendsScores", { friends:$friends, page:$page, limit:$limit, type:$type });
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
		
		
		public function call( $function:String, $data:Object=null ):void
		{
			trace( this, "CALL:", $function )
			_requests.addRequest( $function, $data );
		}
		
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/

		/**
		 * Check the user into the Electrostar service made by Andy.<br />
		 * <br />
		 * This dispatches the P3FBEvent.CHECKING_IN event<br />
		 * <br />
		 * This call needs to be made once the user has logged into Facebook so that 
		 * their details can be passed through and an Access Token can be retrieved.
		 */
		private function checkIn():void
		{
//			DISPATCH THE CHECKING IN EVENT
			dispatchEvent( new P3FBEvent( P3FBEvent.CHECKING_IN ));
			
//			CALL THE ELECTROSTAR SERVICE TO CHECK THE USER IN AND GET AN ACCESS TOKEN
			_requests.addRequest( "checkIn", { user_id:userList.myself.uid, user_name:userList.myself.name, user_email:userList.myself.email });
		}
		
		
		
		/**
		 * Facebook has been initalized and the user is either logged in or not. If the user is logged 
		 * in a P3FBEvent.LOGIN_COMPLETE event is dispatched otherwise a P3FBEvent.LOGIN_FAILED event 
		 * is dispatched so that we know what is going on.<br />
		 * <br />
		 * If the user has been logged in successfully then their details are accessable and is added 
		 * to the P3FBUserList as "myself".  
		 * 
		 * @param $response
		 * @param $fail
		 */
		private function onFacebookLoginComplete( e:GVFacebookEvent ):void
		{
			if (e)
			{
				e.preventDefault()
				_fb_inst.removeEventListener( GVFacebookEvent.FB_LOGGED_IN, onFacebookLoginComplete );
				_fb_inst.removeEventListener( GVFacebookEvent.FB_LOGIN_CANCELED, onFacebookLoginCanceled );
				_fb_inst.removeEventListener( GVFacebookEvent.FB_LOGIN_FAILED, onFacebookLoginCanceled );
			}
			
//			IF A RESPONSE IS AVAILABLE
			if ( _fb_inst.isFacebookAuthenticated())
			{
//				LOGGED IN IS TRUE
				_isLoggedIn = true;
				
//				GET MYSELF AND ADD IT TO THE USER LIST
				getUserDetails();
			}
			else
			{
//				LOGGED IN IS FALSE
				_isLoggedIn = false;
				
//				DISPATCH THE LOGIN FAILED EVENT AND PASS THROUGH THE FAIL
				dispatchEvent( new P3FBEvent( P3FBEvent.LOGIN_FAILED ))
			}
		}
		
		
		private function onFacebookLoginCanceled( e:GVFacebookEvent ):void
		{
			if (e)
			{
				e.preventDefault()
				_fb_inst.removeEventListener( GVFacebookEvent.FB_LOGGED_IN, onFacebookLoginComplete );
				_fb_inst.removeEventListener( GVFacebookEvent.FB_LOGIN_CANCELED, onFacebookLoginCanceled );
				_fb_inst.removeEventListener( GVFacebookEvent.FB_LOGIN_FAILED, onFacebookLoginCanceled );
			}
			
//			LOGGED IN IS FALSE
			_isLoggedIn = false;
			
//			DISPATCH THE LOGIN FAILED EVENT AND PASS THROUGH THE FAIL
			dispatchEvent( new P3FBEvent( P3FBEvent.LOGIN_FAILED ))
		}
		
		
		
		/**
		 * Facebook has successfully been logged out<br />
		 * <br />
		 * This dispatches the P3FBEvent.LOGGED_OUT event.
		 * 
		 * @param $response
		 */
		private function onFacebookLogoutComplete( e:GVFacebookEvent ):void
		{
			if (e)
			{
				e.preventDefault()
				_fb_inst.addEventListener( GVFacebookEvent.FB_LOGGED_OUT, onFacebookLogoutComplete );
			}
			
//			CLEAR ANY DATA IN THE USERLIST
			userList.clear();
			
//			SET LOGGED IN TO FALSE
			_isLoggedIn = false;
			
//			DISPATCH THE LOGGED OUT EVENT
			dispatchEvent( new P3FBEvent( P3FBEvent.LOGGED_OUT ))
		}
		
		
		
		/**
		 * Facebook has retrieved the user details. If there is a response then a P3FBEvent.GOT_MYSELF 
		 * event is dispatched, otherwise a P3FBEvent.ERROR event is dispatched with the fail object.
		 * 
		 * @param $response
		 * @param $fail
		 */
		private function onFacebookGetUserDetailsComplete( e:GVFacebookEvent ):void
		{
			_fb_inst.removeEventListener( GVFacebookEvent.FB_REQUEST_FAILED, onFacebookRequestFailedEventHandler );
			_fb_inst.removeEventListener( GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookGetUserDetailsComplete );
			
			var response:Object = e.data
			
//			IF A RESPONSE IS AVAILABLE
			if ( response )
			{
//				ADD THE USER DETAILS TO MYSELF
				if ( userList.myself )
					userList.myself.parseUser( response );
				else
					userList.addMyself( new P3FBUser( response ));
				
//				DISPATCH THE LOGIN COMPLETE EVENT
				dispatchEvent( new P3FBEvent( P3FBEvent.LOGIN_COMPLETE ))
				
//				DISPATCH THE GOT MYSELF EVENT
				dispatchEvent( new P3FBEvent( P3FBEvent.GOT_MYSELF_RAW ))
				
//				CHECK THE USER IN TO THE ELECTROSTAR SERVICE
				checkIn()
			}
			else
			{
//				DISPATCH THE FAIL EVENT AND PASS THE FAIL OBJECT
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, response ))
			}
		}
		
		
		
		
		/**
		 * Facebook has retrieved the users friends and adds them to the user list as friends<br />
		 * <br />
		 * This dispatches the P3FBEvent.GOT_FRIENDS event on complete or a P3FBEvent.ERROR event on a fail
		 * 
		 * @param $response
		 * @param $fail
		 */
		private function onFacebookGetUserFriendsComplete( e:GVFacebookEvent ):void
		{
			_fb_inst.removeEventListener( GVFacebookEvent.FB_REQUEST_FAILED, onFacebookRequestFailedEventHandler );
			_fb_inst.removeEventListener( GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookGetUserFriendsComplete );
			
			var response:Object = e.data
			if ( response )
			{
				var friends:Array = response.data as Array;
				for ( var i:int=0; i < friends.length; i++ )
				{
					if ( friends[i].hasOwnProperty( "installed" ))
					userList.addFriendUser( friends[i] )
				}
				
				dispatchEvent( new P3FBEvent( P3FBEvent.GOT_FRIENDS ))
			}
			else
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, response ))
			}
		}
		
		
		
		/**
		 * Request data makes the calls to the Electrostar service and cues them up if needed
		 * 
		 * @param $function
		 * @param $data
		 */
		private function requestData( $function:String, $data:Object=null ):void
		{
			trace( this, "REQUEST DATA:", $function )
			
//			SETS UP THE VARIABLES TO SEND
			var vars:URLVariables = new URLVariables()
			vars.method = $function
			vars.args = createData( $data );
			vars.timestamp = timestamp
			
//			CREATES A URL REQUEST
			var request:URLRequest = new URLRequest( _dataURL )
			request.data = vars
			request.method = URLRequestMethod.POST;
			
//			trace( this, "REQUEST:", request.url )
//			trace( this, "DATA:", vars.toString() )
				
//			CREATES THE LOADER AND LOADES THE REQUEST
			var loader:URLLoader = new URLLoader()
			loader.addEventListener( IOErrorEvent.IO_ERROR, onDataLoadErrorEventHandler );
			loader.addEventListener( Event.COMPLETE, onDataLoadCompleteEventHandler );
			loader.load( request );
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

		private function onFacebookRequestFailedEventHandler( e:GVFacebookEvent ):void
		{
			_fb_inst.removeEventListener( GVFacebookEvent.FB_REQUEST_FAILED, onFacebookRequestFailedEventHandler );
			_fb_inst.removeEventListener( GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookGetUserFriendsComplete );
			_fb_inst.removeEventListener( GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookGetUserDetailsComplete );
			
			
			dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, e ));
			e.preventDefault()
		}

		private function onDataLoadErrorEventHandler( e:IOErrorEvent ):void
		{
			dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, e ));
			e.preventDefault()
		}
		
		

		private function onDataLoadCompleteEventHandler( e:Event ):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader
			loader.removeEventListener( Event.COMPLETE, onDataLoadCompleteEventHandler );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, onDataLoadErrorEventHandler );
			
			var json:Object = getData( loader.data );
			
			trace( this, "REQUEST COMPLETE:", json.method )
			switch( json.method )
			{
				case "checkIn" :				handleCheckIn( json.data, json.error );					break;
				case "getGlobalScores" :		handleScores( json.data, json.error, true );			break;
				case "getFriendsScores" :		handleScores( json.data, json.error, false );			break;
				case "setScore" :				handleSetScore( json.data, json.error );				break;
				default :						handleCustomCall( json );								break;
			}
			
			_requests.nextReq();
			e.preventDefault()
		}
		
		
		
/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
	}
}