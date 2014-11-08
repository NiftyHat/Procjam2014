package com.p3.loading 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3FileAudit extends EventDispatcher
	{
		
		private var _request:URLRequest;
		private var _auditStream:URLLoader;
		private var _fullPath:String;
		//private var _totalBytesAudit:Number;
		private var _bytesTotal:Number;
		private var _auditedSize:Boolean;
		
		public function P3FileAudit($path:String) 
		{
			_fullPath = $path;
			//start();
			//P3PreloaderAsset
		}
		
		public function startAudit ():void
		{
			if (!_auditStream)
			{
				_auditStream = new URLLoader();
				_auditStream.addEventListener(ProgressEvent.PROGRESS, onAuditStatus, false, 0, true);
				_auditStream.addEventListener(Event.COMPLETE, onAuditStatus, false, 0, true);
				_auditStream.addEventListener(IOErrorEvent.IO_ERROR, onAuditStatus, false, 0);

				var request:URLRequest = new URLRequest(_fullPath);
				setRequestURL(request, _fullPath);
				_auditStream.load(request);  
			}
			
		}
		
		private function setRequestURL(request:URLRequest, $url:String):void 
		{
			request.url = $url;
		}
		
		private function stopAudit ():void
		{
			//dispatchEvent(new P3PreloaderEvent(P3PreloaderEvent.ASSET_AUDIT_COMPLETE, this));
			_auditStream.removeEventListener(ProgressEvent.PROGRESS, onAuditStatus);
			_auditStream.removeEventListener(Event.COMPLETE, onAuditStatus);
			_auditStream.removeEventListener("ioError", onAuditStatus);
			_auditStream.removeEventListener("securityError", onAuditStatus);
			try {
					_auditStream.close();
				} catch (error:Error) {
					
				}
				_auditStream = null;
		}

		private function onAuditStatus($event:Event):void 
		{
			//dispatchEvent(new P3PreloaderEvent(P3PreloaderEvent.ASSET_AUDIT_COMPLETE, this));
			if ($event is ProgressEvent) 
			{
				_bytesTotal = ($event as ProgressEvent).bytesTotal;
				dispatchEvent(new Event(Event.COMPLETE));
			} 
			else if ($event.type == "ioError" || $event.type == "securityError") 
			{
				errorHandle($event as ErrorEvent);
				return;
			} 
			else 
			{	
			}
			_auditedSize = true;
			stopAudit();
			
		}
		
		private function errorHandle($event:ErrorEvent):void 
		{
			trace($event.text);
		}
		
	}

}