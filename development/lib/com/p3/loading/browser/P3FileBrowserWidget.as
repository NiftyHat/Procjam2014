package com.p3.loading.browser 
{
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * Mini display widget for the file browser that make it easier to load stuff in using less code.
	 * Has a critical depedancy on Mincomps
	 * * @author Duncan Saunders
	 */
	public class P3FileBrowserWidget extends Window 
	{
		
		protected var m_btn_load:PushButton
		protected var m_btn_save:PushButton;
		
		public function P3FileBrowserWidget($target:MovieClip) 
		{
			super($target, 0, 0, "Loading Widget");
			m_btn_load = new PushButton (this, 0, 0, "Load", onClickLoad);
			m_btn_save = new PushButton (this, 0, 0, "Save", onClickSave);
			_hasCloseButton = true;
		}
		
		private function onClickSave(e:MouseEvent, $data:*, $type:String):void 
		{
			P3FileBrowser.ins.save(e, $data, $type);
		}
		
		private function onClickLoad(e:MouseEvent):void 
		{
			P3FileBrowser.ins.browse(e);
		}
		
	}

}