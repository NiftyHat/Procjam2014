package com.p3.debug.mincomps 
{
	import com.bit101.components.HScrollBar;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.VScrollBar;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3MinCompsScrollPane extends ScrollPane
	{
		
		public function P3MinCompsScrollPane(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			
		}
		
		public function get vScrollbar():VScrollBar 
		{
			return _vScrollbar;
		}
		
		public function get hScrollbar():HScrollBar 
		{
			return _hScrollbar;
		}
		
		
	}

}