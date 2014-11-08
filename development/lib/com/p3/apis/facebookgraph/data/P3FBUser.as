/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.data
{
	import flash.events.Event;
	
	
	
	public class P3FBUser extends Object
	{
		
		public static const ID					:String 		= "id";
		public static const UID					:String 		= "uid";
		public static const FIRST_NAME			:String 		= "first_name";
		public static const MIDDLE_NAME			:String 		= "middle_name";
		public static const LAST_NAME			:String 		= "last_name";
		public static const NAME				:String 		= "name";
		public static const USERNAME			:String 		= "username";
		public static const BIRTHDAY			:String 		= "birthday"
		public static const LOCALE				:String 		= "locale";
		public static const PROFILE_LINK		:String 		= "link";
		public static const PICTURE				:String 		= "picture";
		public static const GENDER				:String 		= "gender";
		public static const INSTALLED			:String 		= "installed";
		public static const EMAIL				:String 		= "email";
		public static const SCORE				:String 		= "score";
		public static const RANK				:String 		= "rank";
		
		public static var fb_user_fields		:String			= UID +","+ NAME +","+ USERNAME;
		
		
		
		
		
		private var _name						:String 		= "";
		private var _username					:String 		= "";
		private var _first_name					:String 		= "";
		private var _middle_name				:String 		= "";
		private var _last_name					:String 		= "";
		private var _locale						:String 		= "";
		private var _birthday					:String 		= "";
		private var _gender						:String 		= "";
		private var _profile_link				:String 		= "";
		private var _picture					:String 		= "";
		private var _uid						:String 		= "";
		private var _email						:String 		= "";
		private var _installed					:Boolean 		= false;
		private var _score						:Number 		= 0;
		private var _rank						:Number 		= 0;
		private var _props						:Object 		= {};
		
		private var _picture_loader				:P3FBPictureLoader
		private var _isPictureLoaded			:Boolean
		
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBUser( $user:Object=null )
		{
			if ( $user ) parseUser( $user );
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		public function parseUser( $user:Object ):void
		{
			_uid 				= ( $user[ UID ] ) ? $user[ UID ] : $user[ ID ];
			_name 				= ( $user[ NAME ] ) ? $user[ NAME ] : _name;
			_first_name			= ( $user[ FIRST_NAME ] ) ? $user[ FIRST_NAME ] : _first_name;
			_middle_name		= ( $user[ MIDDLE_NAME ] ) ? $user[ MIDDLE_NAME ] : _middle_name;
			_last_name			= ( $user[ LAST_NAME ] ) ? $user[ LAST_NAME ] : _last_name;
			_username			= ( $user[ USERNAME ] ) ? $user[ USERNAME ] : _username;
			_locale				= ( $user[ LOCALE ] ) ? $user[ LOCALE ] : _locale;
			_birthday			= ( $user[ BIRTHDAY ] ) ? $user[ BIRTHDAY ] : _birthday;
			_gender				= ( $user[ GENDER ] ) ? $user[ GENDER ] : _gender;
			_profile_link		= ( $user[ PROFILE_LINK ] ) ? $user[ PROFILE_LINK ] : _profile_link;
			_email				= ( $user[ EMAIL ] ) ? $user[ EMAIL ] : _email;
			_installed			= ( $user[ INSTALLED ] ) ? $user[ INSTALLED ] : _installed;
			_score				= ( $user[ SCORE ] ) ? $user[ SCORE ] : _score;
			_rank				= ( $user[ RANK ] ) ? $user[ RANK ] : _rank;
			createUserPicture();
		}
		
		
		
		public function setProps( $uid:String, $name:String, $email:String ):void
		{
			_uid = $uid
			_name = $name
			_email = $email
			
			createUserPicture();
		}
		
		
		
		public function addScoreRank( $score:Number, $rank:Number ):void
		{
			_score = $score
			_rank = $rank;
		}
		
		
		
		public function destroy():void
		{
			_uid 				= null;
			_name 				= null;
			_first_name			= null;
			_middle_name		= null;
			_last_name			= null;
			_username			= null;
			_locale				= null;
			_birthday			= null;
			_gender				= null;
			_profile_link		= null;
			_picture			= null;
			_email				= null;
			_score				= 0;
			_rank				= 0;
			_props				= null;
			_installed			= false;
		}
		
		
		
		public function print( $values:Array ):String
		{
			var text:String = "{";
			
			for ( var i:int=0; i<$values.length; i++ )
			{
				text += String( $values[i] ).toUpperCase() + ": " + this[$values[i]];
			}
			
			text = text.substr( 0, text.length - 1 ) + "}";
			
			return text;
		}
		
		public function toString ():String
		{
			return "P3FBUser" + print ([UID,NAME,SCORE])
		}
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/

		private function createUserPicture():void
		{
			if (!_picture_loader) _picture_loader = new P3FBPictureLoader( _uid );
			_picture = _picture_loader.url
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
		public function get name():String { return _name; }
//		public function set name(value:String):void { _name = value; }
		
		public function get username():String { return _username; }
//		public function set username(value:String):void { _username = value; }
		
		public function get first_name():String { return _first_name; }
//		public function set first_name(value:String):void { _first_name = value; }
		
		public function get middle_name():String { return _middle_name; }
//		public function set middle_name(value:String):void { _middle_name = value; }
		
		public function get last_name():String { return _last_name; }
//		public function set last_name(value:String):void { _last_name = value; }
		
		public function get locale():String { return _locale; }
//		public function set locale(value:String):void { _locale = value; }
		
		public function get birthday():String { return _birthday; }
//		public function set birthday(value:String):void { _birthday = value; }
		
		public function get gender():String { return _gender; }
//		public function set gender(value:String):void { _gender = value; }
		
		public function get profile_link():String { return _profile_link; }
//		public function set profile_link(value:String):void { _profile_link = value; }
		
		public function get picture():String { return _picture; }
//		public function set picture(value:String):void { _picture = value; }
		
		public function get uid():String { return _uid; }
//		public function set uid(value:String):void { _uid = value; }
		
		public function get installed():Boolean { return _installed; }
//		public function set installed(value:Boolean):void { _installed = value; }
		
		public function get score():Number { return _score; }
//		public function set score(value:Number):void { _score = value; }
		
		public function get rank():Number { return _rank; }
//		public function set rank(value:Number):void { _rank = value; }
		
		public function get picture_loader():P3FBPictureLoader { return _picture_loader; }
		
		public function get email():String { return _email; }
		public function set email(value:String):void { _email = value; }
		
		public function get props():Object { return _props; }
		public function set props(value:Object):void { _props = value; }
		
		public function get isPictureLoaded():Boolean {return _isPictureLoaded;}

		
		
	}
}