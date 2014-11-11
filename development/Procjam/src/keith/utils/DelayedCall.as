package utils 
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * It delays the call to a specific function
	 * @author James Tarling
	 */
	public class DelayedCall
	{
		/**
		 * The timer to be used for the specific time.
		 */
		private var timer:Timer;
		/**
		 *  Arguments to be used in the function to be delayed.
		 */
		private var args:Array;
		/**
		 * The function to be called after a time
		 */
		private var method:Function;
		/**
		 * The scope to be applied during the call
		 */
		private var scope:*;
		
		/**
		 * Constructor 
		 * @param scope The scope to be applied during the call
		 * @param method The function to be called after a time
		 * @param delay The delay in milliseconds
		 * @param args Arguments to be used in the function to be delayed.
		 * 
		 */
		public function DelayedCall(scope:*, method:Function, delay:Number, ...args) 
		{
			this.scope = scope;
			this.method = method;
			this.args = args;
			
			timer = new Timer(delay, 0);
			timer.addEventListener(TimerEvent.TIMER, complete);
			timer.start();
		}
		
		/**
		 * This listener will be called when the timer is triggered 
		 * @param e The event to trigger this function
		 * 
		 */
		private function complete(e:Event):void 
		{
			timer.stop();
			method.apply (scope, args);
			dispose();
		}
		/**
		 * It cancels the call to the delayed function 
		 * 
		 */
		public function cancel():void
		{
			if (timer) timer.stop ();
			dispose ();
		}
		/**
		 * It clean the memory used for this object 
		 * 
		 */
		private function dispose ():void 
		{
			timer = null;
			method = null;
			scope = null;
			args = null;
		}
	}

}