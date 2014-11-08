/**
 * Usage:
 * var _cm:CustomContextMenu = new CustomContextMenu(this);  
 * this.contextMenu = _cm;
 * 
 * @author Adam H.
 */
package base.utils
{
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class CustomContextMenu 
	{
		private var main			:Main;
		//private var fps			:Stats;
		//private var signal_unlock	:Signal = new Signal();
		//private var signal_dev	:Signal = new Signal();
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function CustomContextMenu($main:*) 
		{
			main = $main;
			
			var _cm:ContextMenu = new ContextMenu();
			_cm.hideBuiltInItems();
			main.contextMenu = _cm;
			
			var _v:String = Version.Major + "." + Version.Minor + ".r" + Version.Revision;
			
			var _version:ContextMenuItem = new ContextMenuItem("Version: " + _v + ". By Playerthree");
			_version.enabled = false;			
			
			
			//var _fpsMenu:ContextMenuItem = new ContextMenuItem("FPS Counter");
			//_fpsMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onFPS);
			//_fpsMenu.separatorBefore = true;
			//_fpsMenu.enabled = true;
			
			//var _unlockMenu:ContextMenuItem = new ContextMenuItem("Unlock Levels");
			//_unlockMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onUnlockLevels);
			//_unlockMenu.enabled = true;
			//
			//var _devMenu:ContextMenuItem = new ContextMenuItem("Debug Mode");
			//_devMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onDebug);
			//_devMenu.enabled = true;	
			//
			//var _keysMenu:ContextMenuItem = new ContextMenuItem("Give Keys");
			//_keysMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onKeys);
			//_keysMenu.enabled = true;
			
			/*
			var _eraseData:ContextMenuItem = new ContextMenuItem("Erase Data");
			_eraseData.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onEraseData);
			_eraseData.enabled = true;		
			*/
			//_cm.customItems.push(_version, _unlockMenu, _fpsMenu, _devMenu, _eraseData);
			
			//if(main.tempDevMode)
				//_cm.customItems.push(_version, _fpsMenu, _unlockMenu, _devMenu, _keysMenu);
			//else
				_cm.customItems.push(_version);
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		/*
		private function onDev(e:ContextMenuEvent):void 
		{
			signal_dev.dispatch();
		}
		
		private function onFPS(e:ContextMenuEvent):void 
		{
			if (fps)
			{
				fps.destroy();
				main.removeChild(fps);
				fps = null;
			}
			else
			{
				fps = new Stats();
				main.addChild(fps);
				fps.x = Globals.stageWidth - fps.width;	
			}
		}
		
		private function onUnlockLevels(e:ContextMenuEvent):void 
		{
			NetData.inst.level_unlock = 9;
		}
		
		private function onDebug(e:ContextMenuEvent):void 
		{
			HE.isDebug = true;
		}
		
		private function onKeys(e:ContextMenuEvent):void 
		{
			PlayerData.inst.KEYS = 10;
		}
		*/
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		/*
		public function get _signal_unlock():Signal { return signal_unlock; }
		public function get _signal_dev():Signal { return signal_dev; }
		*/
		
	}

}
