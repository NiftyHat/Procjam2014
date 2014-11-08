package com.p3.apis.miniclip.debug 
{
	import com.bit101.components.List;
	import com.bit101.components.ListItem;
	import com.bit101.components.Window;
	import com.p3.apis.miniclip.MiniclipHandler;
	import com.p3.apis.miniclip.store.MiniclipStoreEvent;
	import com.p3.apis.miniclip.store.MiniclipStoreProduct;
	import com.p3.apis.miniclip.store.MiniclipStoreProductList;
	import com.p3.common.events.P3LogEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipDebug extends Sprite
	{
		
		protected var m_win_product:MiniclipDebugPanelProduct;
		protected var m_win_item:Window;
		protected var m_win_control:MiniclipDebugControlPanel;
		protected var m_win_log:MiniclipDebugWindowLog;
		protected var m_win_shop:MiniclipDebugShop;
		
		
		public function MiniclipDebug($startHidden:Boolean = false )
		{
			super();
			init();
			addListeners();
			addControlGroup();
			addShopGroup();
			if ($startHidden)
			{
				m_win_control.minimized = true;
				m_win_log.visible = false;
				m_win_shop.visible = false;
			}
		}
		
		private function addListeners():void 
		{
			MiniclipHandler.instance.addEventListener(Event.COMPLETE, onHandlerReady);
			MiniclipHandler.instance.addEventListener(ErrorEvent.ERROR, onError);
			MiniclipHandler.instance.addEventListener(P3LogEvent.LOG, onLog);
			MiniclipHandler.instance.store.addEventListener(MiniclipStoreEvent.ENABLED, onStoreReady);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onLog(e:P3LogEvent):void 
		{
			m_win_log.log(e.text);
		}
		
		private function onStoreReady(e:MiniclipStoreEvent):void 
		{
			//m_win_shop.visible = true;
			addShopGroup();
		}
		
		private function onHandlerReady(e:Event):void 
		{
			m_win_log.log("miniclip handler is ready to go!");
		}
		
		private function addShopGroup ():void
		{
			m_win_shop.visible = true;
		}
		
		private function addControlGroup ():void
		{
			m_win_control.visible = true;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			m_win_log.y =  this.stage.stageHeight - m_win_log.height;
			m_win_control.x = this.stage.stageWidth - m_win_control.width;
			m_win_shop.height = this.stage.stageHeight - m_win_log.height;
			//m_win_product.width = 200;
			//m_win_product.height = this.stage.stageHeight - m_win_log.height;
		}
		
		private function onError(e:ErrorEvent):void 
		{
			m_win_log.log(e.text);
		}
		
		private function init():void 
		{
			m_win_shop = new MiniclipDebugShop (this);
			m_win_shop.visible = false;
			m_win_control = new MiniclipDebugControlPanel (this);
			//m_win_control.visible = false;
			m_win_control.addEventListener(Event.OPEN, onControlOpen);
			m_win_control.addEventListener(Event.CLOSE, onControlClose);
			m_win_log = new MiniclipDebugWindowLog (this, 100, 400);
			//m_win_shop = new MiniclipDebugShop (this, 100);
			
		}
		
		private function onControlClose(e:Event):void 
		{
			m_win_control.minimized = true;
			m_win_shop.visible = false;
			m_win_log.visible = false;
		}
		
		private function onControlOpen(e:Event):void 
		{
			m_win_control.minimized = false;
			m_win_shop.visible = true;
			m_win_log.visible = true;
		}
		
		
		
	}

}