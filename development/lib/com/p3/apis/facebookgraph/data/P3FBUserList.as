/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.data
{
	
	import com.p3.apis.facebookgraph.events.P3FBEvent;
	import com.p3.debug.mincomps.P3MinCompsLog;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	
	/**
	 * Dispatched when all the fb pics are loaded for globals
	 */
	[Event(name = "userListGlobalsLoaded", type = "com.p3.apis.facebookgraph.events.P3FBEvent")]
	
	/**
	 * Dispatched when all the fb pics are loaded for friends
	 */
	[Event(name="userListFriendsLoaded", type="com.p3.apis.facebookgraph.events.P3FBEvent")]
	public class P3FBUserList extends EventDispatcher
	{
		
		private var _uids_global			:Vector.<String>
		private var _uids_friends			:Vector.<String>
		private var _myself					:P3FBUser
		private var _user_dict_friends		:Dictionary
		private var _user_dict_global		:Dictionary
		
		private var _loadingFriendsCount	:int;
		private var _loadingGlobalsCount	:int;
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBUserList()
		{
			init();
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/
		
		/**
		 * Add a users Facebook friend.<br /> 
		 * This adds the friend to the friends ids 
		 * vector and adds them to the user dictionary
		 * 
		 * @param $user
		 */		
		public function addFriendUser( $user:Object ):void 
		{
			var id:String = ( $user.id ) ? $user.id : $user.uid
			var user:P3FBUser = _user_dict_friends[ id ]
			if ( user )
			{
				user.parseUser( $user );
			}
			else
			{
				user = new P3FBUser( );
				user.parseUser( $user );
				//picture loading check.
				user.picture_loader.addEventListener(Event.COMPLETE, onFriendPictureLoaded);
				_loadingFriendsCount++;
				P3MinCompsLog.inst.warn("loading friends count " + _loadingFriendsCount);
				_uids_friends.push( user.uid );
				_user_dict_friends[ user.uid ] = user;
			}
		}
		
		private function onFriendPictureLoaded(e:Event):void 
		{
			_loadingFriendsCount--;
			P3MinCompsLog.inst.warn("loading friends count " + _loadingFriendsCount);
			if (_loadingFriendsCount <= 0)
			{
				_loadingFriendsCount = 0;
				dispatchEvent(new P3FBEvent(P3FBEvent.FACEPIC_FRIENDS_LOADED));
			}
		}
		
		
		
		/**
		 * Add a global user.
		 * This adds the user to the global ids vector 
		 * and adds them to the user dictionary
		 * 
		 * @param $user
		 */		
		public function addGlobalUser( $user:Object ):void 
		{
			var id:String = ( $user.id ) ? $user.id : $user.uid
			var user:P3FBUser = _user_dict_global[ id ]
			
			if ( user )
			{
				user.parseUser( $user );
			}
			else
			{
				user = new P3FBUser();
				user.parseUser( $user );
				//picture loading check.
				user.picture_loader.addEventListener(Event.COMPLETE, onGlobalPictureLoaded);
				_loadingGlobalsCount++;
				P3MinCompsLog.inst.warn("loading globals count " + _loadingGlobalsCount);
				_uids_global.push( user.uid );
				_user_dict_global[ user.uid ] = user;
			}
			
		}
		
		private function onGlobalPictureLoaded(e:Event):void 
		{
			_loadingGlobalsCount--;
			P3MinCompsLog.inst.warn("loading globals count " + _loadingGlobalsCount);
			if (_loadingGlobalsCount <= 0)
			{
				_loadingGlobalsCount = 0;
				dispatchEvent(new P3FBEvent(P3FBEvent.FACEPIC_GLOBALS_LOADED));
			}
		}
		
		
		
		/**
		 * Add the user as myself - The user who has logged into facebook
		 * 
		 * @param $user
		 */
		public function addMyself( $user:P3FBUser ):void 
		{
			_myself = $user;
			if ( _user_dict_friends[ $user.uid ] )
			{
				
			}
			else
			{
				_uids_friends.push( _myself.uid );
				_user_dict_friends[ _myself.uid ] = _myself;
			}
		}
		
		
		
		/**
		 * Get a user using their Facebook UID
		 * 
		 * @param $uid
		 * @return 
		 */
		public function getUserByID( $uid:String, $friend:Boolean=false ):P3FBUser
		{
			if ( $friend )
			{
				if ( _user_dict_friends[ $uid ] != undefined ) 
					return _user_dict_friends[ $uid ];
			}
			else
			{
				if ( _user_dict_global[ $uid ] != undefined ) 
					return _user_dict_global[ $uid ];				
			}
			return null; 
		}
		
		
		
		public function isFriend( $uid:String ):Boolean
		{
			for ( var i:int = 0; i<_uids_friends.length; i++ )
			{
				if ( $uid == _uids_friends[i] )
					return true;
			}
			return false;
		}
		
		
		
		
		public function destroy():void
		{
			for ( var i:int=0; i<_uids_friends.length; i++ )
			{
				_uids_friends[i] = null;
			}
			
			for ( i=0; i<_uids_global.length; i++ )
			{
				_uids_global[i] = null;
			}
			
			var key:String
			for each ( key in _user_dict_friends )
			{
				if ( _user_dict_friends[ key ])
					_user_dict_friends[ key ].destroy();
				_user_dict_friends[ key ] = null;
			}
			
			for each ( key in _user_dict_global )
			{
				if ( _user_dict_global[ key ])
					_user_dict_global[ key ].destroy();
				_user_dict_global[ key ] = null;
			}
			
			_uids_friends = null;
			_uids_global = null;
			_user_dict_friends = null;
			_user_dict_global = null;
		}
		
		
		
		
		public function clear():void
		{
			destroy();
			init();
		}
		
		override public function toString ():String
		{
			return "P3FBUserList" + _uids_global;
		}
		
		public function hasUserDetails($uid:String):Boolean
		{
			if ( _user_dict_friends[ $uid ] != undefined &&  _user_dict_friends[ $uid ].name ) 
					return true;
			if ( _user_dict_global[ $uid ] != undefined  &&  _user_dict_global[ $uid ].name) 
					return true;	
			return false;
		}
		
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/

		private function init():void
		{
			_uids_friends = new Vector.<String>();
			_uids_global = new Vector.<String>();
			_user_dict_global = new Dictionary();
			_user_dict_friends = new Dictionary();
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
		/**
		 * Get a list of all of the global users
		 * 
		 * @return 
		 */
		public function get globalUsers():Vector.<P3FBUser>
		{
			var list:Vector.<P3FBUser> = new Vector.<P3FBUser>();
			for each ( var uid:String in _uids_global )
			{
				if ( _user_dict_global[ uid ]) 
					list.push( _user_dict_global[ uid ]);
			}
			list.sort(sortByRank);
			return list;
		}

		
		
		
		/**
		 * Get a list of the users friends
		 * 
		 * @return 
		 */		
		public function get friendUsers():Vector.<P3FBUser>
		{
			var list:Vector.<P3FBUser> = new Vector.<P3FBUser>();
			for each ( var uid:String in _uids_friends )
			{
				if ( _user_dict_friends[ uid ]) 
					list.push( _user_dict_friends[ uid ]);
					
				
			}
			list.sort(sortByRank);
			return list;
		}
		
				
		private function sortByRank(a:P3FBUser,b:P3FBUser):int 
		{
			if (a.rank > b.rank) return 1;
			else if (a.rank < b.rank) return -1;
			else return 0;
		}
		
		/**
		 * Get an array containing the users friends UIDs
		 * 
		 * @return 
		 */
		public function get friendsUIDs():Array
		{
			var friends:Vector.<P3FBUser> = friendUsers;
			var uids:Array = new Array();
			
			for each ( var item:P3FBUser in friends )
			{
				if (item.uid) uids.push ( item.uid );
			}
			if ( uids.length == 0 ) 
				return null;
			else
				return uids;
		}
		
		/**
		 * Get an array containing the users friends UIDs
		 * 
		 * @return 
		 */
		public function get globalUIDs():Array
		{
			var global:Vector.<P3FBUser> = globalUsers;
			var uids:Array = new Array();
			
			for each ( var item:P3FBUser in global )
			{
				if (item.uid) uids.push ( item.uid );
			}
			if ( uids.length == 0 ) 
				return null;
			else
				return uids;
		}
		
		
		
		/**
		 * Get the user who is playing the app / game
		 * 
		 * @return 
		 */
		public function get myself():P3FBUser
		{
			return _myself;
		}
		
		public function get uids_global():Vector.<String> 
		{
			return _uids_global;
		}
		
		public function get loadingFriendsCount():int 
		{
			return _loadingFriendsCount;
		}
		
		public function get loadingGlobalsCount():int 
		{
			return _loadingGlobalsCount;
		}
		
		
	}
}