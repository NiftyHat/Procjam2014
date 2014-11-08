/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.controllers
{
	
	
	
	public class P3FBRequestController
	{
		
		private var reqCallback				:Function
		private var requests				:Array
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBRequestController( $reqCallback:Function )
		{
			reqCallback = $reqCallback;
			requests = new Array();
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		public function addRequest( $function:String, $data:Object=null ):void
		{
			requests.push({ func:$function, data:$data })
			if ( requests.length == 1 )
			{
				var req:Object = requests.shift()
				reqCallback( req.func, req.data );
			}
		}
		
		
		
		public function nextReq():void
		{
			if ( requests.length > 0 )
			{
				var req:Object = requests.shift();
				reqCallback( req.func, req.data );
			}
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