package com.p3.utils {
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	/**
	 * AMFPHP Simple Remoting connection for AS3
	 * 
	 * @author Tom Jackson
	 * @since 8th Jan, 2007
	 */
	public class AMFPHP extends NetConnection {
		
		/**
		 * AMFPHP Constructor
		 *
		 * @param sURL		The path to the flash services gateway.php file
		 */
		public function AMFPHP( sURL : String ) {
			
			objectEncoding = ObjectEncoding.AMF0;
			if (sURL) connect(sURL);
			
		}
	}
}