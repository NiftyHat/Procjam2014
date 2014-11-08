/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.testing
{
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import com.p3.apis.facebookgraph.data.P3FBPermissions;
	import com.p3.apis.facebookgraph.data.P3FBUser;
	import com.p3.apis.facebookgraph.events.P3FBEvent;
	import com.p3.apis.facebookgraph.interfaces.IP3FBGraph;
	import com.p3.apis.facebookgraph.online.P3FBOnline;
	import com.p3.apis.facebookgraph.P3FacebookGraph;
	import com.p3.apis.facebookgraph.P3FBJSON;
	import com.p3.debug.mincomps.P3MinCompsFunctionApply;
	import com.p3.debug.mincomps.P3MinCompsListItemIcon;
	import com.p3.debug.mincomps.P3MinCompsLog;
	import com.p3.display.ui.P3GridLayout;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	
	
	
	public class P3FBTestPanel
	{
		
		private static var 	_instance					:P3FBTestPanel;
		private static var 	_allowInstance				:Boolean;
		
		
		private var _width								:Number
		private var _height								:Number
		private var _stageRef							:Stage
			
		private var _container							:Window
		private var _loginBtn							:PushButton;
		private var _logoutBtn							:PushButton;
		private var _getFriendsBtn						:PushButton;
		private var _getHighscoresBtn					:PushButton;
		private var _getUserDetailsBtn					:PushButton;
		private var _getFriendsHighscoresBtn			:PushButton;
		private var _showFeedDialogBtn					:PushButton;
		private var _showRequestsDialogBtn				:PushButton;
		private var _funcSetScore						:P3MinCompsFunctionApply;
		private var _funcSetAchivement					:P3MinCompsFunctionApply;
		private var _funcGetFriendScores				:P3MinCompsFunctionApply;
		private var _funcGetUserDetails					:P3MinCompsFunctionApply;
		private var _gridButtons						:P3GridLayout;
		private var _gridSendifcator					:P3GridLayout;
		private var _console							:TextArea;
		private var _totalBtns							:Number = 8; 
		private var _listUsers							:List;
		
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBTestPanel()
		{
			if (!P3FBTestPanel._allowInstance) throw new Error("Error: Use P3FBTestWindow.inst instead of the new keyword.");
		}
		
		
		
		public static function get inst():P3FBTestPanel
		{
			if (P3FBTestPanel._instance == null)
			{
				P3FBTestPanel._allowInstance		= true;
				P3FBTestPanel._instance			= new P3FBTestPanel();
				P3FBTestPanel._allowInstance		= false;
			}
			return P3FBTestPanel._instance;
		}
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		public function init( $stageRef:Stage, $api:IP3FBGraph=null ):void
		{
			_stageRef = $stageRef
			_width = 580;
			_height = 380;
				
			
			
			create();
			positionAndSize();
			disableAll();
			
			//_sendSetScore.enabled = false;
			
			log( "Init" );
			
			P3FacebookGraph.inst.addEventListener( P3FBEvent.ERROR, onFBErrorEventHandler );
			P3FacebookGraph.inst.addEventListener( P3FBEvent.LOGGING_IN, onFBInitLogginInEventHandler );
			P3FacebookGraph.inst.addEventListener( P3FBEvent.LOGIN_COMPLETE, onFBInitLoginCompleteEventHandler );
			P3FacebookGraph.inst.addEventListener( P3FBEvent.LOGIN_FAILED, onFBInitLoginFailedEventHandler );
			P3FacebookGraph.inst.addEventListener( P3FBEvent.GOT_USER_INFO, onFBGotUserInfo);
			//P3FacebookGraph.inst.init( $api );
		}
		
		private function onFBGotUserInfo(e:P3FBEvent):void 
		{
			//updateUserList();
		}
		
		private function disableAll():void 
		{
			_loginBtn.enabled = false;
			_logoutBtn.enabled = false;
			_getUserDetailsBtn.enabled = false;
			_getFriendsBtn.enabled = false;
			_getHighscoresBtn.enabled = false;
			_getFriendsHighscoresBtn.enabled = false;
			_showFeedDialogBtn.enabled = false;
			_showRequestsDialogBtn.enabled = false;
			//_sendSetAchivement.enabled = false;
			//_sendSetScore.enabled = false;
			//_setGetFriendScores.enabled = false;
		}
		
		private function enableAll():void {
			_loginBtn.enabled = true;
			_logoutBtn.enabled = true;
			_getUserDetailsBtn.enabled = true;
			_getFriendsBtn.enabled = true;
			_getHighscoresBtn.enabled = true;
			_getFriendsHighscoresBtn.enabled = true;
			_showFeedDialogBtn.enabled = true;
			_showRequestsDialogBtn.enabled = true;
			_funcSetAchivement.enabled = true;
			_funcSetScore.enabled = true;
			_funcGetFriendScores.enabled = true;
		}
		
		
		public static function log( $text:String ):void
		{
			P3FBTestPanel.inst.log( $text );
		}
		
		
		
		public function log( $text:String ):void
		{
			if ( _console ) _console.text += $text + "\n\n";
		}
		
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/

		protected function create():void
		{
			_container = new Window( _stageRef, 10, 10, "Facebook Test Window" );
			_container.setSize( _width, _height );
			_container.draggable = true;
			_container.minimized = false;
			_container.hasCloseButton = false;
			_container.hasMinimizeButton = true;
			_container.shadow = true;
			
			
			//_gridButtons.setSize(2, 8);
			
			_loginBtn 					= new PushButton( null, 0, 0, "LOGIN", onLoginBtnClickEventHandler )
			_logoutBtn 					= new PushButton( null, 0, 0, "LOGOUT", onLogoutBtnClickEventHandler )
			_getUserDetailsBtn 			= new PushButton( null, 0, 0, "GET USER DETAILS", onGetUserDetailsBtnClickEventHandler )
			_getFriendsBtn 				= new PushButton( null, 0, 0, "GET FRIENDS", onGetFriendsBtnClickEventHandler )
			_getHighscoresBtn 			= new PushButton( null, 0, 0, "GET GLOBAL SCORES", onGetHighscoresBtnClickEventHandler )
			_getFriendsHighscoresBtn 	= new PushButton( null, 0, 0, "GET FRIENDS SCORES", onGetFriendsHighscoresBtnClickEventHandler )
			_showFeedDialogBtn 			= new PushButton( null, 0, 0, "SHOW FEED DIALOG", onShowFeedDialogBtnClickEventHandler )
			_showRequestsDialogBtn 		= new PushButton( null, 0, 0, "SHOW REQUESTS DIALOG", onShowRequestsDialogBtnClickEventHandler )
			_funcSetScore				= new P3MinCompsFunctionApply ("setScore", { score:4 }, onSetScoreButtonClick);
			_funcGetFriendScores 		= new P3MinCompsFunctionApply ("getScores", { friends:[], page:1, num:10 }, onSetScoreButtonClick);
			_funcSetAchivement			= new P3MinCompsFunctionApply ("setAchivement", { id:0 }, onSetAchvimentButtonClick);
			_funcGetUserDetails 		= new P3MinCompsFunctionApply ("getUserInfo", { uids:[] }, onGetUserDetailsButtonClick);
			_console 					= new TextArea(  );
			_listUsers					= new List ( null, 0, 0, null);
			
			P3FacebookGraph.inst.addEventListener(P3FBEvent.GOT_MYSELF, onGotMyself);
		}
		
		private function onGotMyself(e:P3FBEvent):void 
		{
			P3MinCompsLog.inst.log("Update myself");
			var vec :Vector.<P3FBUser> = new Vector.<P3FBUser> ();
			vec.push(P3FacebookGraph.userList.myself);
			updateUserList(vec);
		}
		
		private function updateUserList ($list:Vector.<P3FBUser> = null):void {
			if (!$list) $list = P3FacebookGraph.userList.friendUsers;
			P3MinCompsLog.inst.log("Update users list");
			_listUsers.removeAll();
			var list:Vector.<P3FBUser> = $list;
			var len:int = list.length;
			for (var i:int = 0; i < len; i++)
			{
				var user:P3FBUser = list[i];
				_listUsers.addItem( { label:"[" + user.name + "] - " + " R:" + user.rank, icon : user.picture_loader.bm} )
			}
			
			//for each (item in P3FacebookGraph.userList.globalUsers)
			//{
				//var user:P3FBUser = list[i];
				//_listUsers.addItem( { label:"[" + user.uid + "] - " + " R:" + user.rank, icon : user.picture_loader} )
				//
			//}
			
			
			P3MinCompsLog.inst.log(P3FacebookGraph.userList.toString());
		}
		
		private function onGetUserDetailsButtonClick($sendificator:P3MinCompsFunctionApply):void 
		{
			var sendificator:P3MinCompsFunctionApply = $sendificator;
			var functionName:String = sendificator.functionName;
			var params:Object = sendificator.paramsObject;
			var data:Array = ExternalInterface.call(P3FBOnline.JS_LOCAL_NAME + ".getUserInfo", params.uids)
			P3MinCompsLog.inst.log(params.uids.toString());
			for each (var item:* in data)
			{
				//P3MinCompsLog.inst.log("user id:" + item.id);
			}
			//P3FacebookGraph.inst.call(functionName, params);
		}
		
		private function onSetAchvimentButtonClick(e:MouseEvent):void 
		{
			
			
			//P3FacebookGraph.inst.call(functionName,);
		}
		
		private function onSetScoreButtonClick($sendificator:P3MinCompsFunctionApply):void 
		{
			var sendificator:P3MinCompsFunctionApply = $sendificator;
			var functionName:String = sendificator.functionName;
			var params:Object = sendificator.paramsObject;
			P3FacebookGraph.inst.call(functionName, params);
		}
		
		
		
		protected function positionAndSize():void
		{
			setPortrait();	
		}
		
		
		
		protected function setLandscape():void
		{
			var w:Number = ( _width - 30 ) * 0.3
			var h:Number = ( _height - 20 - ( 10 * _totalBtns )) / _totalBtns
			

			_loginBtn.width = w 
			_loginBtn.height = h
			
			_logoutBtn.width = w 
			_logoutBtn.height = h
			
			_getUserDetailsBtn.width = w 
			_getUserDetailsBtn.height = h
			
			_getFriendsBtn.width = w 
			_getFriendsBtn.height = h
			
			_getHighscoresBtn.width = w 
			_getHighscoresBtn.height = h
			
			_getFriendsHighscoresBtn.width = w 
			_getFriendsHighscoresBtn.height = h
			
			_showFeedDialogBtn.width = w 
			_showFeedDialogBtn.height = h
			
			_showRequestsDialogBtn.width = w ;
			_showRequestsDialogBtn.height = h;
		}
		
		
		
		protected function setPortrait():void
		{
			var w:Number = 180;
			var h:Number = 20;
			

			_loginBtn.width = w 
			_loginBtn.height = h
			

			_logoutBtn.width = w 
			_logoutBtn.height = h
			

			_getUserDetailsBtn.width = w 
			_getUserDetailsBtn.height = h

			_getFriendsBtn.width = w 
			_getFriendsBtn.height = h
			

			_getHighscoresBtn.width = w 
			_getHighscoresBtn.height = h
			
			_getFriendsHighscoresBtn.width = w 
			_getFriendsHighscoresBtn.height = h

			_showFeedDialogBtn.width = w 
			_showFeedDialogBtn.height = h
			
			_showRequestsDialogBtn.width = w 
			_showRequestsDialogBtn.height = h
			
			_gridButtons = new P3GridLayout (2, 10);
			_gridSendifcator = new P3GridLayout (1, 10);
			_container.addChild(_gridButtons);
			_container.addChild(_gridSendifcator);
			//_container.addChild();
			//_container.addChild();
			_gridButtons.addItems([_loginBtn, _logoutBtn, _getFriendsHighscoresBtn, _getHighscoresBtn, _showFeedDialogBtn, _showRequestsDialogBtn,_getFriendsBtn]); 
			_gridSendifcator.addItems([_funcSetScore, _funcGetFriendScores,_funcSetAchivement,_funcGetUserDetails])
			_gridSendifcator.y = _gridButtons.y + _gridButtons.height + 4;
			
			_listUsers.listItemClass = P3MinCompsListItemIcon;
			_listUsers.y = 4;
			_listUsers.width = 210;
			_listUsers.x = _container.width - _listUsers.width - 4;
			_listUsers.listItemHeight = 32;
			
			_container.addChild(_listUsers);
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

/******************************************************************************************************
 * Button event listeners
 *******************************************************************************************************/
		
		private function onLoginBtnClickEventHandler( e:Event ):void
		{
			log( "\n-------------------------------------------------------------------------------------\n" )
			log( "Click Login" )
			
			disableAll();
			
			P3FacebookGraph.inst.addEventListener( P3FBEvent.LOGIN_COMPLETE, onFBLoginCompleteEventHandler );
			P3FacebookGraph.inst.addEventListener( P3FBEvent.LOGIN_FAILED, onFBLoginFailedEventHandler );
			P3FacebookGraph.inst.login([ P3FBPermissions.EXTENDED_OFFLINE_ACCESS, P3FBPermissions.USER_EMAIL ]);
			
			e.preventDefault();
		}
		
		
		
		private function onLogoutBtnClickEventHandler( e:Event ):void
		{
			log( "\n-------------------------------------------------------------------------------------\n" )
			log( "Click Logout" )
			
			disableAll();
			_loginBtn.enabled = true;
			
			P3FacebookGraph.inst.addEventListener( P3FBEvent.LOGGED_OUT, onFBLoggedOutEventHandler );
			P3FacebookGraph.inst.logout();
			
			e.preventDefault();
		}
		
		
		
		private function onGetUserDetailsBtnClickEventHandler( e:Event ):void
		{
			log( "\n-------------------------------------------------------------------------------------\n" )
			log( "Click Get user details" )
			
			_getUserDetailsBtn.enabled = false;
			
			P3FacebookGraph.inst.addEventListener( P3FBEvent.GOT_MYSELF_RAW, onFBGotUserDetailsEventHandler );
			P3FacebookGraph.inst.getUserDetails()
			
			e.preventDefault();
		}
		
		
		
		private function onGetFriendsBtnClickEventHandler( e:Event ):void
		{
			log( "\n-------------------------------------------------------------------------------------\n" )
			log( "Click Get friends" )
			
			_getFriendsBtn.enabled = false;
			
			P3FacebookGraph.inst.addEventListener( P3FBEvent.GOT_FRIENDS, onFBGotFriendsEventHandler );
			P3FacebookGraph.inst.getFriends( true );
			
			e.preventDefault();
		}
		
		
		
		private function onGetHighscoresBtnClickEventHandler( e:Event ):void
		{
			log( "\n-------------------------------------------------------------------------------------\n" )
			log( "Click Get highscores" )
			
			_getHighscoresBtn.enabled = false;
			
			P3FacebookGraph.inst.addEventListener( P3FBEvent.GOT_GLOBAL_SCORES, onFBGotHighscoresEventHandler );
			P3FacebookGraph.inst.getScores();
			
			e.preventDefault();
		}
		
		
		
		private function onGetFriendsHighscoresBtnClickEventHandler( e:Event ):void
		{
			log( "\n-------------------------------------------------------------------------------------\n" )
			log( "Click Get friends highscores" )
			
			_getFriendsHighscoresBtn.enabled = false;
			
			var friends:Array = P3FacebookGraph.userList.friendsUIDs;
			
			if ( friends )
			{
				P3FacebookGraph.inst.addEventListener( P3FBEvent.GOT_FRIENDS_SCORES, onFBGotFriendsHighscoresEventHandler );
				P3FacebookGraph.inst.getFriendsScores( friends );
			}
			else
			{
				_getFriendsHighscoresBtn.enabled = true;
				P3MinCompsLog.inst.warn( "You currently have no friends, click on the Get Friends buttons before trying to get the users friends highscores" )
			}
			
			e.preventDefault();
		}
		
		
		
		private function onSetScoreBtnClickEventHandler( e:Event ):void
		{
			log( "\n-------------------------------------------------------------------------------------\n" )
			
			var score:int = ( Math.random() * 1000 ) + ( Math.random() * 1550 );
			log( "Click Set Score: "+ score )
			
			P3FacebookGraph.inst.addEventListener( P3FBEvent.SET_SCORE_COMPLETE, onFBSetScoreCompleteEventHandler );
			P3FacebookGraph.inst.setScore( score );
			
			e.preventDefault();
		}
		
		
		
		private function onShowFeedDialogBtnClickEventHandler( e:Event ):void
		{
			log( "\n-------------------------------------------------------------------------------------\n" )
			log( "Click Show feed Dialog" )
			
			var params:Object = {}
			//params.stage = _stageRef;
			params.description = "Hello world"
			params.name = P3FacebookGraph.userList.myself.name;
			
			P3FacebookGraph.inst.showFeedDialog( params );
			
			e.preventDefault();
		}
		
		
		
		private function onShowRequestsDialogBtnClickEventHandler( e:Event ):void
		{
			log( "\n-------------------------------------------------------------------------------------\n" )
			log( "Click Show requests Dialog" )
			
			var params:Object = {}
			//params.stage = _stageRef;
			params.id = "750110588";
			params.message = "Hello world";
			params.title = "A Title";
			
			P3FacebookGraph.inst.showRequestsDialog( params );
			
			e.preventDefault();
		}
		
		
		
		
/******************************************************************************************************
		 * Facebook event listeners
*******************************************************************************************************/
		
		private function onFBInitLogginInEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGGING_IN, onFBInitLogginInEventHandler );
			
			log( "FB is logging in..." )
			
			disableAll();
			
			e.preventDefault();
		}
		
		
		
		private function onFBInitLoginCompleteEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGIN_COMPLETE, onFBInitLoginCompleteEventHandler );
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGIN_FAILED, onFBInitLoginFailedEventHandler );
			
			onFBLoginCompleteEventHandler( e );
			
			_funcGetFriendScores.setParamsObject({ friends:P3FacebookGraph.userList.friendsUIDs, page:1, num:10 });
			
			e.preventDefault();
		}
		
		
		
		private function onFBInitLoginFailedEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGIN_COMPLETE, onFBInitLoginCompleteEventHandler );
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGIN_FAILED, onFBInitLoginFailedEventHandler );
		
			onFBLoginFailedEventHandler( e );
			
			e.preventDefault();
		}
		
		
		
		private function onFBLoginCompleteEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGIN_COMPLETE, onFBLoginCompleteEventHandler );
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGIN_FAILED, onFBLoginFailedEventHandler );
			
			//var details:String = P3FacebookGraph.userList.myself.print([ P3FBUser.UID, P3FBUser.NAME, P3FBUser.PICTURE ])
			//log( "FB is logged in" )
			//log( "User details:\n" + details );
			//
			enableAll();
			_loginBtn.enabled = false;
			
			e.preventDefault();
		}
		
		
		
		private function onFBLoginFailedEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGIN_COMPLETE, onFBLoginCompleteEventHandler );
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGIN_FAILED, onFBLoginFailedEventHandler );
		
			log( "FB is login has failed, there may not be an auth token or it may have expired!" )
			
			disableAll();
			_loginBtn.enabled = true;
			
			e.preventDefault();
		}
		
		
		
		private function onFBLoggedOutEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.LOGGED_OUT, onFBLoggedOutEventHandler );
		
			log( "FB has logged out" )
			
			disableAll();
			_loginBtn.enabled = true;
			
			e.preventDefault();
		}
		
		
		
		private function onFBGotUserDetailsEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.GOT_MYSELF_RAW, onFBGotUserDetailsEventHandler );
		
			var details:String = P3FacebookGraph.userList.myself.print([ P3FBUser.UID, P3FBUser.NAME, P3FBUser.PICTURE ])
			log( "FB has got myself" )
			log( "User details:\n" + details );
			
			_getUserDetailsBtn.enabled = true;
			
			e.preventDefault();
		}
		
		
		
		private function onFBGotFriendsEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.GOT_FRIENDS_SCORES, onFBGotFriendsEventHandler );
		
			P3MinCompsLog.inst.log( "FB has got users friends who have the app installed" )
			
			for ( var i:int=0; i< P3FacebookGraph.userList.friendUsers.length; i++ )
			{
				P3MinCompsLog.inst.log( "Friend "+i+":\n" + P3FacebookGraph.userList.friendUsers[i].print([ P3FBUser.UID, P3FBUser.NAME ]));
			}
			
			_getFriendsBtn.enabled = true;
			
			e.preventDefault();
		}
		
		
		
		private function onFBGotHighscoresEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.GOT_GLOBAL_SCORES, onFBGotHighscoresEventHandler );
		
			P3MinCompsLog.inst.log( "FB has got the highscores for the app" )
			
			trace( P3FBJSON.encode( e.data ))
			var len:int =  P3FacebookGraph.userList.globalUsers.length
			for ( var i:int=0; i< len; i++ )
			{
				P3MinCompsLog.inst.log( "User "+i+":\n" + P3FacebookGraph.userList.globalUsers[i].print([ P3FBUser.UID, P3FBUser.NAME, P3FBUser.RANK, P3FBUser.SCORE ]));
			}
			updateUserList(P3FacebookGraph.userList.globalUsers);
			_getHighscoresBtn.enabled = true;
			
			e.preventDefault();
		}
		
		
		
		private function onFBGotFriendsHighscoresEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.GOT_FRIENDS_SCORES, onFBGotFriendsHighscoresEventHandler );
		
			log( "FB has got the highscores for the users friends" )
			var len:int =  P3FacebookGraph.userList.friendUsers.length
			for ( var i:int=0; i< len; i++ )
			{
				P3MinCompsLog.inst.log( "User "+i+":\n" + P3FacebookGraph.userList.friendUsers[i].print([ P3FBUser.UID, P3FBUser.NAME, P3FBUser.RANK, P3FBUser.SCORE ]));
			}
			updateUserList(P3FacebookGraph.userList.friendUsers);
			_getFriendsHighscoresBtn.enabled = true;
			
			e.preventDefault();
		}
		
		
		
		private function onFBSetScoreCompleteEventHandler( e:P3FBEvent ):void
		{
			P3FacebookGraph.inst.removeEventListener( P3FBEvent.SET_SCORE_COMPLETE, onFBSetScoreCompleteEventHandler );
		
			log( "FB has set the users score" )
			
			
			e.preventDefault();
		}
		
		
		
		private function onFBErrorEventHandler( e:P3FBEvent ):void
		{
			log( "An Error has occured: " + P3FBJSON.encode( e.data.fail ))
			
			_loginBtn.enabled = false;
			_logoutBtn.enabled = true;
			_getUserDetailsBtn.enabled = true;
			_getHighscoresBtn.enabled = true;
			_getFriendsBtn.enabled = true;
			_getFriendsHighscoresBtn.enabled = true;
			
			e.preventDefault();
		}
		
		
		
/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
	}
}