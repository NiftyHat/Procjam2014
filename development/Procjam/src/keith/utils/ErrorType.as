package utils
{
	/**
	 * This class defiens different type of errors for the communications
	 * @author James Tarling
	 */
	public class ErrorType
	{
		/**
		 * The bet was rejected.
		 */
		public static const BET_REJECTED:ErrorType = new ErrorType("betRejected");
		/**
		 * Some error happened in the authentication
		 */
		public static const AUTHENTICATION:ErrorType = new ErrorType("authentication");		
		/**
		 * Some error happened in the information
		 */
		public static const INFORMATION:ErrorType = new ErrorType("information");
		/**
		 * Some error happened in the program
		 */
		public static const PROGRAM_ERROR:ErrorType = new ErrorType("programError");
		/**
		 * The time out error was dispatched in the communications
		 */
		public static const TIMED_OUT:ErrorType = new ErrorType("timedOut");
		/**
		 * The request was malformed
		 */
		public static const MALFORMED:ErrorType = new ErrorType("malformed");
		/**
		 * An Input/OutPut happened
		 */
		public static const IO:ErrorType = new ErrorType ("io");
		
		/**
		 * The string representing the error
		 */
		private var value:String;
		
		/**
		 * The code for the error
		 */
		public var code:String = "";
		/**
		 * The message for the error
		 */
		public var msg:String = "";
		
		/**
		 * Constructor
		 * @param value The type odf error
		 * 
		 */
		public function ErrorType(value:String) 
		{
			this.value = value;
		}
		
		/**
		 * It returns the String defining the error
		 * @return  
		 * 
		 */
		public function toString():String 
		{
			return value.toString();
		}
	}

}