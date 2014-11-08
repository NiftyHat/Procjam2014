/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.interfaces
{
	import com.p3.apis.facebookgraph.data.P3FBUserList;
	
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	public interface IP3FBGraph extends IEventDispatcher
	{
		/**
		 * Initalise the API.<br />
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong> 
		 */
		function init():void;
		
		/**
		 * Check the application into the server to retrieve the Token
		 */
		function checkin():void;
		
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
		function login( $permissions:Array ):void;
		
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
		function logout():void;
		
		/**
		 * If you need to get the user details you can call this function.<br />
		 * <br />
		 * <strong>NOTE:</strong><br />
		 * The user details are automatically returned and stored when the user is logged in.
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 */
		function getUserDetails():void;
		
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
		function getFriends( $isAppUser:Boolean ):void;
		
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
		function getScores( $users:Array, $page:Number=1, $limit:Number=10, $type:String="DESC" ):void;
		
		/**
		 * Get the users friends highscores for the app, this is a basic function which may or may not be used. It is 
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
		function getFriendsScores( $friends:Array=null, $page:Number=1, $limit:Number=10, $type:String="DESC" ):void;
		
		/**
		 * Send the Users score to the server so that it can be stored within the database, the user needs 
		 * to be checked in for this function to be called<br />
		 * <br />
		 * <strong>This should only be called from P3FacebookGraph</strong>
		 * 
		 * @param $score - The Users score
		 * @param $type - ASC or DESC, default is DESC so if the users score is higher than the current it will be stored
		 */
		function setScore( $score:Number, $type:String="DESC" ):void
		
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
		function showFeedDialog( $params:Object=null ):void
			
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
		function showRequestsDialog( $params:Object ):void
			
		/**
		 * Set achivement for the app, the achivement with $id is set as complete
		 * @param	$id - the id of the achivement to toggle as done.
		 */
		function setAchivement($id:int):void;
		
		/**
		 * Gets achivements for the app
		 * @param	$id
		 */
		function getAchivements():void;
			
		function call( $function:String, $data:Object=null ):void
		
		
			
			
		/**
		 * Get the user list
		 * 
		 * @return - P3FBUserList
		 */
		function get userList():P3FBUserList
			
			
		function get isLoggedIn():Boolean
			
	}
}
