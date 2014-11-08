/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.mobile
{
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
	
	public class P3FBMobileWindow
	{
		
		protected var webView			:StageWebView;
		protected var loginRequest		:URLRequest;
		protected var redirectUri		:String
		protected var url				:String
		
		protected var callback			:Object
		
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBMobileWindow( $callback:Function=null )
		{
			callback = $callback;
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		public function open( $params:Object, $webView:StageWebView, $appID:String, $display:String="touch" ):void 
		{
			this.webView = $webView;
			this.redirectUri = $params.redirect_uri;
			this.url = $params.dialog;
			
			loginRequest = new URLRequest();
			loginRequest.method = URLRequestMethod.GET;
			loginRequest.url = this.url +"?"+ formatData( $appID, this.redirectUri, $params, $display );
			
			showWindow( loginRequest );
		}
		
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/

		protected function showWindow( $req:URLRequest ):void 
		{
			webView.addEventListener( Event.COMPLETE, onLocationChangeEventHandler );
			webView.addEventListener( LocationChangeEvent.LOCATION_CHANGE, onLocationChangeEventHandler );
			
			webView.loadURL( $req.url );
		}
		
		
		
		protected function formatData( $appID:String, $redirect_uri:String, $options:Object, $display:String ):URLVariables 
		{
			var vars:URLVariables = new URLVariables();
			vars.app_id 		= $appID;
			vars.redirect_uri 	= $redirect_uri;
			vars.display 		= $display;
			vars.type 			= 'user_agent';
			
			if ( $options.message ) 		vars.message = $options.message;
			if ( $options.to ) 				vars.to = $options.to;
			if ( $options.filters ) 		vars.filters = $options.filters;
			if ( $options.data ) 			vars.data = $options.data;
			if ( $options.title ) 			vars.title = $options.title;
			if ( $options.link ) 			vars.link = $options.link;
			if ( $options.picture )			vars.picture = $options.picture;
			if ( $options.source ) 			vars.source = $options.source;
			if ( $options.name )			vars.name = $options.name;
			if ( $options.caption )			vars.caption = $options.caption;
			if ( $options.description )		vars.description = $options.description;
			if ( $options.properties ) 		vars.properties = $options.properties;
			if ( $options.actions ) 		vars.actions = $options.actions;
			if ( $options.ref )				vars.ref = $options.ref;
			
			return vars;
		}
		
		
		
		/**
		 *
		 * Obtains the query string from the current HTML location
		 * and returns its values in a URLVariables instance.
		 *
		 */
		public function getURLVariables( $url:String ):URLVariables 
		{
			var params:String;
			
			if (url.indexOf('#') != -1) 
			{
				params = url.slice( url.indexOf( '#' ) + 1 );
			} 
			else if ( url.indexOf('?') != -1 ) 
			{
				params = url.slice( url.indexOf( '?' ) + 1 );
			}
			
			var vars:URLVariables = new URLVariables();
			vars.decode( params );
			return vars;
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

		private function onLocationChangeEventHandler( e:Event ):void
		{
			var location:String = webView.location;
			
			if ( location.indexOf( redirectUri ) == 0 )
			{
				webView.removeEventListener(Event.COMPLETE, onLocationChangeEventHandler);
				webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, onLocationChangeEventHandler);
				webView.dispose();
				webView=null;
				
				if ( callback ) callback( getURLVariables( location ));
			}
		}
		
		
		
/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
	}
}