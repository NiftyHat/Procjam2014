package com.p3.apis.miniclip.debug 
{
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipDebugWindowLog extends Window
	{
		private var m_text_dump:TextArea;
		
		public function MiniclipDebugWindowLog(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Window")  
		{
			super(parent, x, y, title)
			width = 640;
			height = 120;
			//super();
			addArea();
		}
		
		private function addArea():void 
		{
			m_text_dump = new TextArea (this as DisplayObjectContainer, 80, 2, "Miniclip debbugger V0.0001" + "\n")
			m_text_dump.x = 0;
			m_text_dump.editable = false;
			//m_text_dump
			m_text_dump.width = width - 4;
			m_text_dump.height = 96;
			
		}
		
		public function log($string:String):void {
			m_text_dump.text += $string + "\n"; 
			
		}
		
		
	}

}