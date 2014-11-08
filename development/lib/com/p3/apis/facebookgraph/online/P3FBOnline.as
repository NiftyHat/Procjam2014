/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.online
{
	
	import com.p3.apis.facebookgraph.data.P3FBUser;
	import com.p3.apis.facebookgraph.data.P3FBUserList;
	import com.p3.apis.facebookgraph.events.P3FBEvent;
	import com.p3.apis.facebookgraph.interfaces.IP3FBGraph;
	import com.p3.apis.facebookgraph.P3FBAbstract;
	import com.p3.apis.facebookgraph.P3FBJSON;
	import com.p3.debug.mincomps.P3MinCompsLog;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.external.ExternalInterface;
	
	
	
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
	[Event(name = "facebook_got_user_info", 			type = "com.p3.apis.facebookgraph.events.P3FBEvent")]
	
	public class P3FBOnline extends P3FBAbstract implements IP3FBGraph
	{
		
		
		public static const JS_LOCAL_NAME:String = "FBLocal";
		public static const JS_REMOTE_NAME:String = "fbremote";
		private var _isFBHub:Boolean;
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBOnline( $flashVars:Object=null ) 
		{
			_userList = new P3FBUserList();
			
			if ( !$flashVars ) 
			{
				dispatchEvent(new P3FBEvent (P3FBEvent.LOG, { text:"no flash vars, won't work!" } ));
				trace("no flash vars, won't work!")
				return;
			}
			if ( $flashVars.user_id )
			{
				var myself:P3FBUser = new P3FBUser();
				//this FB id is probably wrong. Need to fix.
				myself.setProps( $flashVars.user_id, $flashVars.user_name, $flashVars.user_email );
				var func:Function;
				func = function (e:Event):void { dispatchEvent(new P3FBEvent( P3FBEvent.GOT_MYSELF, null)) }
				myself.picture_loader.addEventListener(Event.COMPLETE, func);
				_userList.addMyself( myself );
				//FACEPICTURE LOADER CHECK
				
				//logging.
				dispatchEvent(new P3FBEvent (P3FBEvent.LOG, { text:"my uid is :" + myself.uid } ));
				trace(P3FBEvent.LOG, { text:"my uid is :" + myself.uid } );
			}
			if ( $flashVars.user_friends )
			{
				var friends:Array = ( $flashVars.user_friends is Array ) ? $flashVars.user_friends : String( $flashVars.user_friends ).split( "," );
				for ( var i:int=0; i<friends.length; i++ )
				{
					_userList.addFriendUser({ "uid":friends[i] });
				}
				dispatchEvent(new P3FBEvent (P3FBEvent.LOG, { text:"my friends uids is :" + friends } ));
				trace("my friends uids is :" + friends)
			}
		}
		
		private function updateUserDetails():void 
		{
			//e.stopImmediatePropagation();
			//var globalUIDS:Array = ;
			getUserInfo(userList.globalUIDs, true);
			getUserInfo(userList.friendsUIDs, true);
			//removeEventListener(P3FBEvent.GOT_GLOBAL_SCORES, handleGlobalScores);
			//dispatchEvent(e);
			//addEventListener(P3FBEvent.GOT_GLOBAL_SCORES, handleGlobalScores);
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
			if ( ExternalInterface.available )
			{
				ExternalInterface.addCallback( "jsResponse", onJSRemoteResponse );
				ExternalInterface.addCallback( "jsLocalResponse", onJSLocalResponse);
				_isFBHub = ExternalInterface.call(JS_REMOTE_NAME + ".hello");		
				if (!_isFBHub) handleError("Couldn't reach " + JS_REMOTE_NAME +  " services, check if " + JS_REMOTE_NAME + " javascript is on page");
				checkin();
			}
			else
			{
				handleError( "[P3FacebookGraph] - EXTERNAL INTERFACE IS NOT AVAILABLE", true);
				//trace( this, "EXTERNAL INTERFACE IS NOT AVAILABLE" );
			}
		}

		override protected function onUserListUpdate ():void
		{
			updateUserDetails();
		}
		
		/**
		 * Check into FBHub and set up the accsess token. Shouldn't need to be called manually, since it gets
		 * called by the init() function.
		 */
		override public function checkin():void
		{
			if ( userList.myself && userList.myself.uid )
			{
//				DISPATCH THE CHECKING IN EVENT
				dispatchEvent( new P3FBEvent( P3FBEvent.CHECKING_IN ));
				dispatchEvent( new P3FBEvent( P3FBEvent.LOGGING_IN ))
			
				_isLoggedIn = true;
				_isCheckedIn = true;
				
				//var username:String = ( userList.myself.username == "" ) ? userList.myself.name : userList.myself.username
				//
				//if ( userList.myself.uid == "" ) 	callFB( "showError", "No user ID can be found!" );
				//if ( userList.myself.email == "" ) 	callFB( "showError", "No user EMAIL can be found!" );
				//if ( username == "" ) 				callFB( "showError", "No user NAME or USERNAME can be found!" );
				
				//removed useless arguements.
				call( "checkIn", {user_id:userList.myself.uid});
			}
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
		public function getScores( $user_ids:Array, $page:Number=1, $limit:Number=10, $type:String="DESC" ):void
		{
			call( "getScores", { user_ids:$user_ids, page:$page, limit:$limit, type:$type })
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
			if (!$friends) $friends = _userList.friendsUIDs;
			call( "getScores", { friends:$friends, page:$page, limit:$limit, type:$type })
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
			call( "setScore", { score:$score, type:$type });
		}
		
		
		
		public function call( $function:String, $data:Object=null ):void
		{
			if ( !available )
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, "Either user is not signed in or External Interface is not available!" ))
				return;
			}
			
			var data:Object = new Object();
			data.method = $function
			data.args = createData( $data );
			data.timestamp = timestamp
			
			dispatchEvent(new P3FBEvent (P3FBEvent.LOG, {text:$function + "( " + P3FBJSON.encode($data) + ")", type:"send"}));
			ExternalInterface.call( JS_REMOTE_NAME + ".render", data );
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
			callFB( "logIn", { permissions:$permissions })
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
			
			callFB( "logOut" )			
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
			P3MinCompsLog.inst.warn("getUserDetails()");
			P3MinCompsLog.inst.log(userList.myself.toString());
			P3MinCompsLog.inst.log(userList.toString());
			getUserInfo([userList.myself.uid]);
			_userList.addMyself(userList.getUserByID(_userList.myself.uid));
		}
		
		//public function getUserDetails():void
		//{
			//var details:Object = callFB( "getUserInfo", [_userList.myself.uid] )
			//details= details[0][_userList.myself.uid]
			//if (details.id) _userList.addMyself(new P3FBUser (details));
		//}
		
		/**
		 * Gets the details for a set of users specified an array of UID's
		 * @param	$userIDs
		 * @return
		 */	
		public function getUserInfo ($userIDs:Array, $global:Boolean = false):void
		{
			var len:int = $userIDs.length;
			for (var i:int = 0; i < len; i++)
			{
				var uid:String = $userIDs[i]
				if (_userList.hasUserDetails(uid))
				{
					P3MinCompsLog.inst.warn("Already got all the info for uid: " + uid)
					$userIDs.splice(i,1)
				}
			}
			//if ($userIDs.length == 0) P3MinCompsLog.inst.warn("Already got all the info for " uid)
			var ret:* = callFB("getUserInfo", $userIDs);
			var details:Object;
			//var dummy:Object = {method:"getUserInfo", data:details}
			if (ret is String)
			{
				P3MinCompsLog.inst.error("getUserInfo returned a string, what the heck?!")
				P3MinCompsLog.inst.info(ret);
				return;
			}
			if (ret is Object)
			{
				for (var user:String in ret)
				{
					details = ret[user];
					if (details.id)
					{
						if (_userList.isFriend(details.id))_userList.addFriendUser(details);
						_userList.addGlobalUser(details);
					}
				}
				
				
			}
			dispatchEvent(new P3FBEvent(P3FBEvent.GOT_USER_INFO, null, null));
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
			trace( this, "WARNING!!! GET FRIENDS CANNOT BE CALLED FROM THE ONLINE API!" ) 
			getUserInfo(_userList.friendsUIDs, false);
			dispatchEvent(new P3FBEvent(P3FBEvent.GOT_FRIENDS, null, null));
//			callFB( "getFriends", $isAppUser )
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
			callFB( "showFeedDialog", $params )
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
		 * <li><strong>to</strong> - The ID or username of the profile that this story will be published to. If this is unspecified, it defaults to the the value of from.</li>
		 * <li><strong>message</strong> - The Request string the receiving user will see. It appears as a request posed by the sending user. The maximum length is 255 characters. The message value is not displayed in Notifications and can only be viewed on the Apps and Games Dashboard. Invites (requests where the recipient has not installed the app) do not display this value.</li>
		 * <li><strong>title</strong> - Optional, the title for the Dialog. Maximum length is 50 characters.</li>
		 * </ul>
		 */
		public function showRequestsDialog( $params:Object ):void
		{
			callFB( "showRequestsDialog", $params )
		}
		
		/* INTERFACE com.p3.apis.facebookgraph.interfaces.IP3FBGraph */
		/**
		 * Not yet in use. For sending a reciving achivements.
		 * @param	$id
		 */
		public function setAchivement($id:int):void 
		{
			
		}
		
		/**
		 * Not yet in use. For sending a reciving achivements.
		 * @param	$id
		 */
		public function getAchivements():void 
		{
			
		}
		
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/

		private function callFB( $functionName:String, $params:Object=null ):*
		{
			if ( !available )
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, "Either user is not signed in or External Interface is not available!" ))
				return;
			}
			dispatchEvent(new P3FBEvent (P3FBEvent.LOG, { text:JS_LOCAL_NAME + "." + $functionName + "(" + P3FBJSON.encode($params) + ")", type:"send" } ))
			var object:* = ExternalInterface.call( JS_LOCAL_NAME + "." + $functionName,  $params);
			dispatchEvent(new P3FBEvent (P3FBEvent.LOG, { text:JS_LOCAL_NAME + "." + $functionName + "(" + P3FBJSON.encode(object) + ")", type:"recived" } ))
			return object;
			//trace(friendsInfo);
		}

		
		override protected function handleCheckIn($response:Object, $fail:Object):void 
		{
			super.handleCheckIn($response, $fail);
			//getUserDetails();
			getFriends(true);
		}
		
		private function onJSRemoteResponse( $response:String ):void
		{
			var json:Object = getData( $response );
			var method:String = json.method
			handleLogging(json);
			switch( String(method))
			{
				case "checkIn" :					
				case "logIn" :						handleCheckIn( json.data, json.error );					
													dispatchEvent( new P3FBEvent( P3FBEvent.LOGIN_COMPLETE ));	break;									
				case "logOut" :						handleLogout( json.data );									break;
				case "getUserInfo" :				handleUserDetails( json.data, json.error );					break;
				case "getFriends" :					handleUserFriends( json.data, json.error );					break;
				case "getScores" :					handleScores( json.data, json.error, true );				break;
				//case "getFriendsScores" :			handleScores( json.data, json.error , false );				break;
				default :							handleCustomCall( json );									break;
			}
		}
		
		override protected function handleScores($response:Object, $fail:Object, $global:Boolean):void 
		{
			super.handleScores($response, $fail, $global);
			
		}
		
		override protected function handleUserFriends($response:Object, $fail:Object):void 
		{
			//super.handleUserFriends($response, $fail);
		}
		
		private function handleLogging($response:Object):void 
		{
			var copy:Object = $response.data;
			var out:String = $response.method + "\n{ \n";
			if (copy)
			{
				for (var param:String in copy)
				{
					if (copy[param] is String && copy[param] == "")
					{
						continue;
					}
					out += param + ":" + copy[param].toString() + " \n";
				}
			}
			
			
			out += " }";
			dispatchEvent(new P3FBEvent(P3FBEvent.LOG, { text:out, type:"recived"} ));
		}
		
				
		private function onJSLocalResponse():void 
		{
			
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
		public function get available():Boolean
		{
			return ( ExternalInterface.available && _isLoggedIn )
		}
		
		
		
		
	}
}