/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.encription
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	
	
	
	public class Encryption
	{
		
		private static const ENCRYPTION_TYPE		:String = "simple-des-ecb";
		private static const ENCRYPTION_KEY			:String = "wredat4E";
		private static var CIPHER_KEY				:ByteArray;
		
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		{
			CIPHER_KEY = Hex.toArray( Hex.fromString( ENCRYPTION_KEY ));
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/
		
		public static function encrypt( $text:String ):String
		{
			var data:ByteArray = Hex.toArray( Hex.fromString( $text ));
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher( ENCRYPTION_TYPE, CIPHER_KEY, pad );
			pad.setBlockSize(mode.getBlockSize());
			mode.encrypt( data );
			
			return Base64.encodeByteArray( data );
		}
		
		
		
		public static function decrypt( $text:String ):String
		{
			var data:ByteArray = Base64.decodeToByteArray( $text );
			var pad:IPad = new PKCS5 ;
			var mode:ICipher = Crypto.getCipher( ENCRYPTION_TYPE, CIPHER_KEY, pad );
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