package com.p3.apis.miniclip.debug 
{
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import com.p3.apis.miniclip.MiniclipHandler;
	import com.p3.apis.miniclip.store.MiniclipStoreEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipDebugControlPanel extends Window 
	{
		
		protected var m_btnLogin:PushButton;
		protected var m_btnLogout:PushButton;
		protected var m_lghtIsLoggedIn:IndicatorLight;
		protected var m_lghtIsMiniclip:IndicatorLight;
		protected var m_creditBalance:Label;
		protected var m_isClosed:Boolean;
		
		public function MiniclipDebugControlPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Miniclip Control") 
		{
			//init();
			super(parent, x, y, title)
			width = 140
			MiniclipHandler.instance.addEventListener(Event.COMPLETE, onComplete);
			hasCloseButton = true;
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseClicked);
			
		}
		
		private function onCloseClicked(e:MouseEvent):void 
		{
			m_isClosed =  !m_isClosed;
			if (m_isClosed) dispatchEvent(new Event(Event.CLOSE));
			else dispatchEvent(new Event(Event.OPEN));
			
		}
		
		private function onBalanceUpdate(e:MiniclipStoreEvent):void 
		{
			//m_creditBalance.text =  "Credits :" + MiniclipHandler.instance.store.balance;
		}
		

		
		override protected function init():void 
		{
			super.init();
			height = 100;
			width = 200;
			m_btnLogout = new PushButton (this, 0, 20, "Logout", onClickLogout);
			m_btnLogout.width = 60;
			m_btnLogin = new PushButton (this, 0, 0, "Login", onClickLogin);
			m_btnLogin.width = 60;
			m_lghtIsLoggedIn = new IndicatorLight (this, 70, 24, 0x00ff00, "Logged On");
			m_lghtIsMiniclip = new IndicatorLight (this, 70, 4, 0x00ff00, "Miniclip");
		
		}
		
		private function onClickLogout($event:MouseEvent = null):void 
		{
			MiniclipHandler.instance.logout();
		}

		private function onClickLogin(e:MouseEvent = null):void 
		{
			
			MiniclipHandler.instance.login();
		}
		
		private function onComplete(e:Event):void 
		{
			m_lghtIsMiniclip.isLit = MiniclipHandler.instance.isMiniclip;
			m_lghtIsLoggedIn.isLit = MiniclipHandler.instance.isLoggedIn;
		}
		
		override public function get minimized():Boolean 
		{
			return super.minimized;
		}
		
		override public function set minimized(value:Boolean):void 
		{
			super.minimized = value;
		}
		
	}

}