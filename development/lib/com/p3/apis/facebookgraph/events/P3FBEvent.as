/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.events
{
	
	import flash.events.Event;
	
	
	
	public class P3FBEvent extends Event
	{
		
		/**
		 * Dispached when Facebook is begining to log the user in
		 */
		public static const LOGGING_IN				:String			= "facebook_logging_in";
		
		/**
		 * Dispached when the User has been logged into Facebook
		 */
		public static const LOGIN_COMPLETE			:String			= "facebook_login_complete";
		
		/**
		 * Dispached when Facebook login has failed, either because the user has canceled it or because of an error
		 */
		public static const LOGIN_FAILED			:String			= "facebook_login_failed";
		
		/**
		 * Dispached when the User has been logged out of Facebook
		 */
		public static const LOGGED_OUT				:String			= "facebook_logged_out";
		
		/**
		 * Dispached when the Users friend data has been recieved
		 */
		public static const GOT_FRIENDS				:String			= "facebook_got_friends";
		
		/**
		 * Dispached when the Users friend data has been recieved
		 */
		public static const GOT_USER_INFO			:String			= "facebook_got_user_info";
		
		
		/**
		 * Dispached when the Users data has been recieved
		 */
		public static const GOT_MYSELF_RAW				:String		= "facebook_got_myself_raw";
		
		/**
		 * Dispached when the Users data has been recieved along with the facepic
		 */
		public static const GOT_MYSELF				:String			= "facebook_got_myself";
		
		/**
		 * Dispached when an custom API call has retrieved its data and is ready for collection. The data will be passed in with the dispactched event.
		 */
//		public static const GOT_API_RESULT			:String			= "facebook_got_api_result";
		
		/**
		 * Dispached when an error has occured, this could be because of an connection error, malformed data, or a failed Facebook call
		 */
		public static const ERROR					:String			= "facebook_error";
		
		/**
		 * Dispatched when the User is being checked into the server 
		 */
		public static const CHECKING_IN				:String			= "net_checking_in";
		
		/**
		 * Dispatched when the User has been checked into the server and is ready to recive calls 
		 */		
		public static const CHECKED_IN				:String			= "net_checked_in";
		
		/**
		 * Dispached when the Users friends highscores have been retrieved, but facepics not loaded
		 */
		public static const GOT_FRIENDS_SCORES_RAW	:String			= "net_got_friends_scores_raw";
		
		/**
		 * Dispached when the global highscores have been retrieved, but facepics not loaded
		 */
		public static const GOT_GLOBAL_SCORES_RAW	:String			= "net_got_global_scores_raw";
		
		/**
		 * Dispached when the Users friends highscores have been retrieved & facepics have loaded
		 */
		public static const GOT_FRIENDS_SCORES		:String			= "net_got_friends_scores";
		
		/**
		 * Dispached when the global highscores have been retrieved & facepics have loaded
		 */
		public static const GOT_GLOBAL_SCORES		:String			= "net_got_global_scores";
		
		/**
		 * Dispached when an custom DATA call has retrieved its data and is ready for collection. The data will be passed in with the dispactched event.
		 */
		public static const GOT_CUSTOM_CALL			:String			= "net_got_custom_call_result";
		
		/**
		 * Dispatched when the users score has been set 
		 */		
		public static const SET_SCORE_COMPLETE		:String			= "net_set_score_complete";
		
		/**
		 * Logging events describe additional info about fb sent/recived info. The 'data' is a string that can be printed in the log, consisting .text and .type ("send","recived","error").
		 */
		public static const LOG						:String 		= "facebook_log";
		
		
		static public const FACEPIC_FRIENDS_LOADED:String = "facepic_FriendsLoaded";
		static public const FACEPIC_GLOBALS_LOADED:String = "facepic_GlobalsLoaded";
		static public const FACEPIC_MYSELF_LOADED:String = "facepic_MyselfLoaded";
		
		
		private var _data		:Object
		private var _error		:Object
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBEvent( $type:String, $data:Object=null, $error:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			_data = $data;
			_error = $error;
			
			super( $type, $bubbles, $cancelable );
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		public override function clone():Event 
		{ 
			return new P3FBEvent( type, data, error, bubbles, cancelable );
		} 
		
		
		
		public override function toString():String 
		{ 
			return formatToString( "P3FBEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/

/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
		/**
		 * Get the passed data from the event
		 * 
		 * @return - Object
		 */
		public function get data():Object { return _data; }
		
		/**
		 * Get the error from an event, this should be be null unless the data is null
		 * 
		 * @return 
		 */
		public function get error():Object { return _error; }
		
	}
}