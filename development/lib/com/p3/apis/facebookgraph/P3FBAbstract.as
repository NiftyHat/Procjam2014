/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph
{
	import com.p3.apis.facebookgraph.data.P3FBUser;
	import com.p3.apis.facebookgraph.data.P3FBUserList;
	import com.p3.apis.facebookgraph.encription.Encryption;
	import com.p3.apis.facebookgraph.events.P3FBEvent;
	import com.p3.debug.mincomps.P3MinCompsLog;
	import flash.events.Event;
	
	import flash.events.EventDispatcher;
	
	
	
	public class P3FBAbstract extends EventDispatcher
	{
		
		protected var _TOKEN				:String;
		protected var _userList				:P3FBUserList
		protected var _isLoggedIn			:Boolean = false;
		protected var _isCheckedIn			:Boolean = false;
		protected var _encryption			:Boolean = false;
		
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBAbstract()
		{
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		public function checkin():void
		{
			trace( this, "ERROR! CHECKIN NEEDS TO BE OVERRIDDEN!!" )
		}
		
		
/*-------------------------------------------------
* PROTECTED METHDOS
*-------------------------------------------------*/

		/**
		 * This handels the user checkin and dispatches the P3FBEvent.CHECKED_IN event
		 * 
		 * @param $response
		 * @param $fail
		 */
		protected function handleCheckIn( $response:Object, $fail:Object ):void
		{
			traceResponse( $response, $fail )
			//populate user info
			_userList.friendsUIDs
			if ( $response )
			{
				_isCheckedIn = true;
				dispatchEvent( new P3FBEvent( P3FBEvent.CHECKED_IN, $response ));
			}
			else
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, $fail ));
			}
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
		protected function handleLogin( $response:Object, $fail:Object ):void
		{
			traceResponse( $response, $fail )
			
//			IF A RESPONSE IS AVAILABLE
			if ( $response )
			{
//				LOGGED IN IS TRUE
				_isLoggedIn = true;
				
//				CREATE A NEW USER AS MYSELF AND ADD IT TO THE USER LIST
				userList.addMyself( new P3FBUser( $response.user ));
				
//				DISPATCH THE LOGIN COMPLETE EVENT
				dispatchEvent( new P3FBEvent( P3FBEvent.LOGIN_COMPLETE, $response ))
				
//				CHECK THE USER IN TO THE ELECTROSTAR SERVICE
				checkin()
			}
			else
			{
//				LOGGED IN IS FALSE
				_isLoggedIn = false;
				
//				DISPATCH THE LOGIN FAILED EVENT AND PASS THROUGH THE FAIL
				dispatchEvent( new P3FBEvent( P3FBEvent.LOGIN_FAILED, null, $fail ))
			}
		}
		
		
		/**
		 * Facebook has successfully been logged out<br />
		 * <br />
		 * This dispatches the P3FBEvent.LOGGED_OUT event.
		 * 
		 * @param $response
		 */
		protected function handleLogout( $response:Object ):void
		{
			traceResponse( $response )
			
//			CLEAR ANY DATA IN THE USERLIST
			userList.clear();
			
//			SET LOGGED IN TO FALSE
			_isLoggedIn = false;
			
//			DISPATCH THE LOGGED OUT EVENT
			dispatchEvent( new P3FBEvent( P3FBEvent.LOGGED_OUT, $response ))
		}
		
		
		/**
		 * Facebook has retrieved the user details. If there is a response then a P3FBEvent.GOT_MYSELF 
		 * event is dispatched, otherwise a P3FBEvent.ERROR event is dispatched with the fail object.
		 * 
		 * @param $response
		 * @param $fail
		 */
		protected function handleUserDetails( $response:Object, $fail:Object ):void
		{
			traceResponse( $response, $fail )
			
//			IF A RESPONSE IS AVAILABLE
			if ( $response )
			{
//				ADD THE USER DETAILS TO MYSELF
				if ( userList.myself )
					userList.myself.parseUser( $response );
				else
					userList.addMyself( new P3FBUser( $response ));
				
//				DISPATCH THE GOT MYSELF EVENT
				dispatchEvent( new P3FBEvent( P3FBEvent.GOT_MYSELF_RAW, $response ))

			}
			else
			{
//				DISPATCH THE FAIL EVENT AND PASS THE FAIL OBJECT
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, $fail ))
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
		protected function handleUserFriends( $response:Object, $fail:Object ):void
		{
			traceResponse( $response, $fail )
			
			if ( $response )
			{
				var friends			:Array = $response as Array;
				for ( var i:int=0; i < friends.length; i++ )
				{
					userList.addFriendUser( friends[i] )
				}
				
				dispatchEvent( new P3FBEvent( P3FBEvent.GOT_FRIENDS, $response ))
			}
			else
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, $fail ))
			}
		}
		
		
		/**
		 * Facebook has finished the extended permissions request, this function just takes care of any errors 
		 * which may occur if the user hits cancel.<br />
		 * <br />
		 * This dispatched the P3FBEvent.ERROR event and passes through the fail object
		 * 
		 * @param $response
		 * @param $fail
		 */
		protected function handleExtendedPermissionsRequest( $response:Object, $fail:Object ):void
		{
			traceResponse( $response, $fail )
			
//			IF FAIL IS AVAILABLE
			if ( $fail )
			{
//				DISPATCH THE ERROR EVENT
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, $fail ))
			}
		}
		
		
		/**
		 * Handel the scores response from the Electrostar service, this will check to see if the scores 
		 * are global scores or friends scores and add the data to the appripriate user in the user list.<br />
		 * <br />
		 * This will dispatch the P3FBEvent.GOT_GLOBAL_SCORES event or P3FBEvent.GOT_FRIENDS_SCORES or a P3FBEvent.ERROR event.
		 * 
		 * @param $response
		 * @param $fail
		 */
		protected function handleScores( $response:Object, $fail:Object, $global:Boolean ):void
		{
			traceResponse( $response, $fail )
			var containsGlobal:Boolean
			if ( $response )
			{
				if ( $response.user )
					userList.myself.addScoreRank( $response.user.score, $response.user.rank );
				
				var scores:Array = $response.scores as Array;
				var user:P3FBUser
				var i:int
				var uid:String;
				var ids_list:Array = [];
				var func:Function;
				for each (var details:Object in scores)
				{
					uid = details.id
					if (_userList.isFriend(uid) || _userList.myself.uid == uid)
					{
						_userList.addFriendUser(details)
					}
					else
					{
						containsGlobal = true;
					}
					_userList.addGlobalUser(details)
				}
				onUserListUpdate();
				if (containsGlobal)
				{
					//this.user
					func = function (e:P3FBEvent):void 
					{
						dispatchEvent( new P3FBEvent( P3FBEvent.GOT_GLOBAL_SCORES, $response ))
						userList.removeEventListener(P3FBEvent.FACEPIC_GLOBALS_LOADED, func);
						
					}
					if (_userList.loadingGlobalsCount > 0) {
						_userList.addEventListener(P3FBEvent.FACEPIC_GLOBALS_LOADED, func);
					}
					else 
					{
						dispatchEvent( new P3FBEvent( P3FBEvent.GOT_GLOBAL_SCORES, $response))
					}
					dispatchEvent( new P3FBEvent( P3FBEvent.GOT_GLOBAL_SCORES_RAW, $response ))
				}
				else {
					func = function (e:P3FBEvent):void 
					{
						dispatchEvent( new P3FBEvent( P3FBEvent.GOT_FRIENDS_SCORES, $response ))
						_userList.removeEventListener(P3FBEvent.FACEPIC_FRIENDS_LOADED, func);
					}
					if (_userList.loadingFriendsCount > 0)
					{
						_userList.addEventListener(P3FBEvent.FACEPIC_FRIENDS_LOADED, func);
					}
					else 
					{
						dispatchEvent( new P3FBEvent( P3FBEvent.GOT_FRIENDS_SCORES, $response ))
					}
					dispatchEvent( new P3FBEvent( P3FBEvent.GOT_FRIENDS_SCORES_RAW, $response ))
				}
			}
			else
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, $fail ));
			}
		}
		
		protected function onUserListUpdate():void 
		{
			//override me!
		}
		
		
		/**
		 * This just captures if the set score is complete or it has failed. This dispatches 
		 * the P3FBEvent.SET_SCORE_COMPLETE event or the P3FBEvent.ERROR event.
		 * 
		 * @param $response
		 * @param $fail
		 */
		protected function handleSetScore( $response:Object, $fail:Object ):void
		{
			traceResponse( $response, $fail )
			
			if ( $response )
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.SET_SCORE_COMPLETE, $response ))
			}
			else
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, $fail ));
			}
		}
		
		
		
		protected function handleCustomCall( $response:Object ):void
		{
			traceResponse( $response, $response.error )
			
			trace( this, "GOT CUSTOM CALL:", $response.method )
			if ( $response.data )
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.GOT_CUSTOM_CALL, $response ))
			}
			else
			{
				dispatchEvent( new P3FBEvent( P3FBEvent.ERROR, null, $response.error ));
			}
		}
		
		
		/**
		 * Creates the arguments which are sent to the electrostar service, this adds the access token, 
		 * converts the data to json and then encripts it ready to be sent
		 * 
		 * @param $data
		 * @return 
		 */
		protected function createData( $data:Object ):String
		{
			if ( !$data ) 	$data = new Object()
			$data.token = _TOKEN;
			
			var json:String = P3FBJSON.encode( $data );
			var encripted:String = ( _encryption ) ? Encryption.encrypt( json ) : json;
			
			return encripted;
		}
		
		
		
		/**
		 * Get the data from the loaded data, this will decrypt the data as well and set the access token to the new token
		 * 
		 * @param $data
		 * @return 
		 */
		protected function getData( $data:String ):Object
		{
			var json:Object = P3FBJSON.decode( $data ); 
			var decriptedData:String = ( _encryption ) ? Encryption.decrypt( json.data ) : json.data;
			json.data = ( decriptedData !== "" ) ? P3FBJSON.decode( decriptedData ) : {};
			
			if ( json.data.token )
				_TOKEN = json.data.token;
			
			return json;
		}
		
		
		
		protected function traceResponse( $response:Object, $fail:Object=null ):void
		{
			var enc:String
			if ( $response )
			{
				
				enc= P3FBJSON.encode( $response )
				dispatchEvent(new P3FBEvent (P3FBEvent.LOG, {text:enc, type:"recive"}));
				trace( this, "RESPONSE:",enc )
			}
			else if ( $fail )
			{
				
				enc = P3FBJSON.encode( $fail )
				dispatchEvent(new P3FBEvent (P3FBEvent.LOG, {text:enc, type:"error"}));
				trace( this, "FAIL:",enc )
				//trace( this, "FAIL:", P3FBJSON.encode( $fail ))
			}
		}
		
		
		protected function handleError( $errorText:String, $fatal:Boolean = false):void
		{
			trace($errorText);
			dispatchEvent(new P3FBEvent(P3FBEvent.LOG, { text:$errorText, type:"error" } ));
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/
		
/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
		
		public function get isLoggedIn():Boolean
		{
			return _isLoggedIn
		}
		
		
		public function get timestamp():String
		{
			var time:Date = new Date;
			return time.valueOf().toString();
		}
		
		/**
		 * Get the user list
		 * 
		 * @return - P3FBUserList
		 */
		public function get userList():P3FBUserList
		{
			return _userList
		}
		
		public function get encryption():Boolean 
		{
			return _encryption;
		}
		
		public function set encryption(value:Boolean):void 
		{
			_encryption = value;
		}
	}
}