package  
{
	import axengine.components.AxControl;
	import axengine.components.AxLibrary;
	import base.components.*;
	import base.Control;
	import com.p3.audio.soundcontroller.P3SoundController;
	import com.p3.debug.mincomps.P3MinCompsLog;
	import com.p3.display.screenmanager.P3ScreenManager;
	import com.p3.game.chatmapperapi.ChatMapper;
	import com.p3.utils.P3Globals;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class Core 
	{
		
		private static var _control:AxControl;
		private static var _sound:P3SoundController;
		private static var _screens:P3ScreenManager;
		private static var _lib:AxLibrary;
		private static var _registry:ClassRegistry;
		private static var _xml:XMLBundle;
		private static var _cache:LocalCache;
		private static var _net:Net;
		private static var _initOnce:Boolean;
		private static var _log:P3MinCompsLog;
		private static var _copy:CopyController;
		
		static public const PATH_ASSETS:String = "assets/";
		static public const PATH_XML:String = "assets/xml";
		static public const PATH_MUSIC:String = "music/";
		static public const PATH_LEVELS:String = "xml/levels/";
		
		public function Core() 
		{
			
		}
		
		public static function init():void
		{
			if (_initOnce) return;
			_initOnce = true;
			_log = P3MinCompsLog.inst;
			_xml = new XMLBundle ();
			_control = new AxControl();
			_screens = P3ScreenManager.inst;
			_sound = P3SoundController.inst;
			_registry = new ClassRegistry();
			_lib = new AxLibrary ();
			_cache = new LocalCache ();
			_net = new Net ();		
			_copy = new CopyController ();
		}
		
		static public function get control():AxControl 
		{
			return _control;
		}
		
		static public function get sound():P3SoundController 
		{
			return _sound;
		}
		
		static public function get screens():P3ScreenManager 
		{
			return _screens;
		}
		
		static public function get lib():AxLibrary 
		{
			return _lib;
		}
		
		static public function get registry():ClassRegistry 
		{
			return _registry;
		}
		
		static public function get xml():XMLBundle 
		{
			return _xml;
		}
		
		static public function get cache():LocalCache 
		{
			return _cache;
		}
		
		static public function get net():Net 
		{
			return _net;
		}
		
		static public function get log():P3MinCompsLog 
		{
			return _log;
		}
		
		static public function get copy():CopyController 
		{
			return _copy;
		}
		
	}

}