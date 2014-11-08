package axengine.util 
{
	import flash.utils.getQualifiedClassName;
	import org.axgl.AxEntity;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxEntMode 
	{
		
		protected var _cbOnModeUpdate:Function;
		protected var _cbOnModeUpdateArray:Array;
		protected var _cbOnModeEnter:Function;
		protected var _cbOnModeEnterArray:Array;
		protected var _cbOnModeExit:Function;
		protected var _cbOnModeExitArray:Array;
		protected var _target:AxEntity;
		protected var _name:String;
		
		protected var _state:int;
		
		public static const ENTER:int = 0;
		public static const RUNNING:int = 1;
		public static const EXIT:int = 2;
		
		public function AxEntMode($cbUpdate:Function = null, $cbEnter:Function = null, $cbExit:Function = null) 
		{
			_cbOnModeUpdate = $cbUpdate;
			_cbOnModeEnter = $cbEnter;
			_cbOnModeExit = $cbExit;
			if (!_name) {
				_name = getQualifiedClassName(this).split("::").pop();
			}
		}
		
		public function enter():void {
			_state = ENTER;
			var func:Function = _cbOnModeEnter;
			var arry:Array = _cbOnModeEnterArray;
			if (func != null) {
				if (func.length == 0) {
					func();
				} else if (arry) {
					func.apply(arry);
				}
			}
			
		}
		
		public function update():void {
			_state = RUNNING;
			var func:Function = _cbOnModeUpdate;
			var arry:Array = _cbOnModeUpdateArray;
			if (func != null) {
				if (func.length == 0) {
					func();
				} else if (arry) {
					func.apply(arry);
				}
			}
		}
		
		public function exit():void {
			_state = EXIT;
			var func:Function = _cbOnModeExit;
			var arry:Array = _cbOnModeExitArray;
			if (func != null) {
				if (func.length == 0) {
					func();
				} else if (arry) {
					func.apply(arry);
				}
			}
		}
		
		public function get target():AxEntity 
		{
			return _target;
		}
		
		public function get state():int 
		{
			return _state;
		}
		
	}

}