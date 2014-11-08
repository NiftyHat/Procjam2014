package com.p3.encryption 
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.CBCMode;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.IVMode;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	
	
	public class P3TripleDes
	{
		
		private static const ENCRYPTION_TYPE		:String = "3des-cbc";
		private static var ENCRYPTION_KEY			:String = "chuzak7mA9rErEdr64Ruy7kU";
		private static var IV_KEY		 			:String = "vEbREvu4";
		private static var CIPHER_KEY				:ByteArray;
		private static var IV						:ByteArray;
		
		// define("KEY_24_BIT", "chuzak7mA9rErEdr64Ruy7kU");
		// define("KEY_8_BIT", "vEbREvu4");
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		{
			CIPHER_KEY = Hex.toArray( Hex.fromString( ENCRYPTION_KEY )); 
			IV = Hex.toArray( Hex.fromString( IV_KEY )); 
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		public static function setKey ($key:String):void
		{
			ENCRYPTION_KEY = $key
		}
		
		public static function encrypt( $text:String ):String
		{
			var data:ByteArray = Hex.toArray( Hex.fromString( $text ));
			var pad:IPad = new PKCS5 ();
			var mode:ICipher = Crypto.getCipher( ENCRYPTION_TYPE, CIPHER_KEY, pad );
			(mode as CBCMode).IV = IV;
			pad.setBlockSize(mode.getBlockSize());
			mode.encrypt( data );
			
			return Base64.encodeByteArray( data );
		}
		
		
		
		public static function decrypt( $text:String ):String
		{
			var data:ByteArray = Base64.decodeToByteArray( $text );
			var pad:IPad = new PKCS5 ();
			var mode:ICipher = Crypto.getCipher( ENCRYPTION_TYPE, CIPHER_KEY, pad );
			(mode as CBCMode).IV = IV;
			pad.setBlockSize( mode.getBlockSize());
			mode.decrypt( data );
			return Hex.toString( Hex.fromArray( data ));
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
		
	}

}