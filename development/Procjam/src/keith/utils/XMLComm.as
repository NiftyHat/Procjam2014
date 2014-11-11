package utils
{
	import utils.DelayedCall;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import org.osflash.signals.Signal;
	
	
	/**
	 * This class handles the very low level of the communications for XML Requests
	 * @author James Tarling
	 */
	public class XMLComm
	{
		/**
		 * The URLRequest to user for the request
		 */
		private var request:URLRequest;
		/**
		 * The time to define how much to wait for a response
		 */
		private var timeoutLength:int;
		/**
		 *  A class to force to have delays in a call to the backend
		 */
		private var timeOutDelay:DelayedCall;
		/**
		 *  The loader for sending the request
		 */
		private var loader:URLLoader;
		/**
		 * It defines the different type of errors.
		 */
		private var _errorType:ErrorType;
		/**
		 * The response data from 3rd parties for the request
		 */
		private var _responseData:XML;
		
		/**
		 * Signal to trigger the time out error.
		 */
		private var _timeOutSignal:Signal;
		/**
		 * Signal to trigger errors
		 */
		private var _errorSignal:Signal;
		/**
		 * Signal to trigger when the request was procesed. 
		 */
		private var _loadedSignal:Signal;
		
		/**
		 * Constructor for the XML Communications 
		 * @param requestData The Data formatted into XML
		 * @param url The url where to send the request
		 * @param timeoutLength The timeout for this request
		 * 
		 */
		public function XMLComm (requestData:XML, 
									url:String,
									timeoutLength:int = -1) 
		{
			super ();
			this.timeoutLength = timeoutLength;
			
			request = new URLRequest(url);
			request.contentType = "text/xml";
			request.data = requestData;
			request.method = URLRequestMethod.POST;
			
			_timeOutSignal = new Signal(XMLComm);
			_errorSignal = new Signal(XMLComm, ErrorType);
			_loadedSignal = new Signal(XMLComm);
		}

		/**
		 * It sends the request.  
		 * 
		 */
		public function send ():void 
		{	
			if (timeoutLength > - 1) timeOutDelay = new DelayedCall (this, timedOut, timeoutLength * 1000);
			
			//trace("shared.gts.service.XMLComm.send");
			//trace(request.data);
			
			loader = new URLLoader(  );
			loader.addEventListener ( Event.COMPLETE, loaderComplete );
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioError); 
			loader.load( request );
		}
		
		/**
		 *  It returns the XML Response
		 * @return XML Response
		 * 
		 */
		public function get response ():XML 
		{
			return _responseData;
		}
		
		/**
		 * It returns the Error type if that exists 
		 * @return  The Error type
		 * 
		 */
		public function get errorType ():ErrorType 
		{
			return _errorType;
		}
		
		public function get timeOutSignal():Signal 
		{
			return _timeOutSignal;
		}
		
		public function get errorSignal():Signal 
		{
			return _errorSignal;
		}
		
		public function get loadedSignal():Signal 
		{
			return _loadedSignal;
		}
		
		/**
		 * This listener is triggered by the Loader when the response from the server is ready 
		 * @param e The event
		 * 
		 */
		private function loaderComplete(e:Event):void 
		{
			cancelTimeout ();
			
			var loader:URLLoader = URLLoader(e.target);
			_responseData = new XML (loader.data);
			trace("shared.gts.service.XMLComm.loaderComplete");
			trace(_responseData);
			
			
			var name:* = _responseData.name;
			if (!name)
			{
				sendErrorEvent (ErrorType.MALFORMED);
			} else {
				loadedSignal.dispatch(this, _responseData);
			}
		}
		
		/**
		 * This listener is triggered by the Loader is some error input/output happens
		 * @param e The input/output error
		 * 
		 */
		private function ioError(e:IOErrorEvent):void 
		{
			cancelTimeout ();
		
			sendErrorEvent (ErrorType.IO);
		}
		
		/**
		 * It dispatches an error if this happens 
		 * @param _errorType The type of the error to be dispatched
		 * 
		 */
		private function sendErrorEvent (_errorType:ErrorType):void
		{
			this._errorType = _errorType;
			
			errorSignal.dispatch(this, _errorType);
		}
		
		/**
		 * It triggers the timeOut 
		 * 
		 */
		private function timedOut():void
		{
			loader.close ();			
			timeOutSignal.dispatch(this);
		}
		
		/**
		 * 	It cancels the timeout Call
		 * 
		 */
		private function cancelTimeout ():void 
		{
			if (timeOutDelay) timeOutDelay.cancel ();
		}
	}

}