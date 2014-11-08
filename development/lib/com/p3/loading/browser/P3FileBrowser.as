package com.p3.loading.browser
{
	import com.p3.loading.browser.P3FileBrowserEvent;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	/**
	 * SINGLETON CLASS
	 *
	 * @author Duncan Saunders
	 */
	[Event(name="loaded", type="com.p3.datastructures.P3FileBrowserEvent")]
	[Event(name="saved", type="com.p3.datastructures.P3FileBrowserEvent")]
	public class P3FileBrowser extends EventDispatcher 
	{
		
		/*---------------------------------------------------------------------------*\
		 *	BEGIN SINGLETON
		 *---------------------------------------------------------------------------*/
		 
		private static var _instance:P3FileBrowser
		private var _lastfile:String;
		
		public function P3FileBrowser() 
		{
			if (_instance) throw new Error ("only one instance of singleton allowed. Use FileSaver.ins to accsess it");
			init();
		}
		
		public static function get ins ():P3FileBrowser 
		{
			if (!_instance) _instance = new P3FileBrowser;
			return _instance;
		}
		
		/*---------------------------------------------------------------------------*\
		 * END SINGLETON
		 *---------------------------------------------------------------------------*/
		 
		private var m_fileReferance:FileReference;
		private var m_data_buffer:ByteArray;
		 
		public function init() :void 
		{
			//entry point!
		}
		
		public function browse (e:Event = null):void
		{
			if (!e) e = new MouseEvent (MouseEvent.CLICK);
			m_fileReferance = new FileReference;
			m_fileReferance.addEventListener(Event.SELECT, onBrowseComplete);
			m_fileReferance.browse();
		}
		
		private function onBrowseComplete(e:Event):void 
		{
			trace("browse complete");
			m_fileReferance.removeEventListener(Event.SELECT, onBrowseComplete);
			m_fileReferance.addEventListener(Event.COMPLETE, onFileLoaded);
			m_fileReferance.load();
		}	
		
		private function onFileLoaded(e:Event):void 
		{
			trace("load complete");
			m_fileReferance.removeEventListener(Event.COMPLETE, onFileLoaded);
			_lastfile = m_fileReferance.name
			m_data_buffer = m_fileReferance.data;
			dispatchEvent(new P3FileBrowserEvent (P3FileBrowserEvent.LOADED, m_fileReferance.data, m_fileReferance.name));
		}
		
		public function save (e:Event = null,data:* = null, $type:String = ""):void
		{
			if (!e) e = new MouseEvent (MouseEvent.CLICK);
			var name:String = "levelname" + $type;
			if (_lastfile) name = _lastfile;
			m_fileReferance = new FileReference;
			m_fileReferance.save(data, name);
			dispatchEvent(new P3FileBrowserEvent (P3FileBrowserEvent.SAVED, null));
		}
		
		public function dispose():void
		{
			m_data_buffer = null;
		}
		
		public function setFilename($file_name:String):void 
		{
			_lastfile = $file_name;
		}
		
		public function get data ():ByteArray { return m_data_buffer }
		public function get file ():String { return _lastfile };
	}
	
}