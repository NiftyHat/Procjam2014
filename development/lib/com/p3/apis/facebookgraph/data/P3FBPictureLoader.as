/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.data
{
	
	import com.p3.apis.facebookgraph.P3FacebookGraph;
	import com.p3.debug.mincomps.P3MinCompsLog;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	
	
	public class P3FBPictureLoader extends Sprite
	{
		
		public static const PICTURE_TYPE_SQUARE		:String = "square"
		public static const PICTURE_TYPE_SMALL		:String = "small"
		public static const PICTURE_TYPE_NORMAL		:String = "normal"
		public static const PICTURE_TYPE_LARGE		:String = "large"
			
		public static var PICTURE_TYPE				:String = P3FBPictureLoader.PICTURE_TYPE_SQUARE;
		
		
		private var _url							:String = "https://graph.facebook.com/";
		private var _loaded							:Boolean = false;
		private var _bm								:Bitmap;
		
		
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
*-------------------------------------------------*/	
		
		public function P3FBPictureLoader( $uid:String )
		{
			_url += $uid + "/picture?type=" + P3FBPictureLoader.PICTURE_TYPE_SQUARE;
			//P3MinCompsLog.inst.log( this + "URL: )
			
			init();
			
			super();
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		
		
/*-------------------------------------------------
* PUBLIC METHDOS
*-------------------------------------------------*/

		public function destroy():void
		{
			removeChild( _bm );
			_bm = null;
			_url = null;
			_loaded = false;
		}
		
		
		
/*-------------------------------------------------
* PRIVATE METHDOS
*-------------------------------------------------*/

		private function init():void
		{
			trace( this, "LOADING USER PICTURE" )
			var request:URLRequest = new URLRequest( _url )
			var context:LoaderContext = new LoaderContext ();
			context.checkPolicyFile = true;
			context.applicationDomain = ApplicationDomain.currentDomain;		
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadCompleteEventHandler, false, 0, true );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onLoadErrorEventHandler, false, 0, true );
			loader.load(request, context);
		}
		
		
		
/*-------------------------------------------------
* EVENT HANDLERS
*-------------------------------------------------*/

		private function onAddedToStageEventHandler( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStageEventHandler );
			init();
		}
		
		
		
		private function onLoadCompleteEventHandler( e:Event ):void
		{
			e.target.removeEventListener( Event.COMPLETE, onLoadCompleteEventHandler );
			e.target.removeEventListener( IOErrorEvent.IO_ERROR, onLoadErrorEventHandler );
			
			_loaded = true;
			
			_bm = e.target.content;
			
			addChild( _bm );
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		
		private function onLoadErrorEventHandler( e:IOErrorEvent ):void
		{
			e.target.removeEventListener( Event.COMPLETE, onLoadCompleteEventHandler );
			e.target.removeEventListener( IOErrorEvent.IO_ERROR, onLoadErrorEventHandler );
			
			_loaded = false;
			
			trace( this, "ERROR:", e )
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		
/*-------------------------------------------------
* GETTER / SETTERS
*-------------------------------------------------*/
		
		public function get url():String
		{
			return _url;
		}
		
		public function get bm():Bitmap 
		{
			return _bm;
		}
		
	}
}