package axengine.state 
{
	import flash.ui.Mouse;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import screens.basic.BasicScreen;
	import screens.InitScreen;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxMenuState extends FlxState 
	{
		
		private var m_initMenu:Class; 
		
		public function AxMenuState($initMenu:Class = null) 
		{
			m_initMenu = $initMenu;
		}
		
		override public function create():void 
		{
			//FlxG.log(Core.lib.int);
			if (!m_initMenu) m_initMenu = InitScreen;
			FlxG.stage.addChildAt(Core.screen_manager.getDisplay,1);
			Core.control.switchScreen(new m_initMenu);
			Mouse.show();
			super.create();
		}
		
		override public function destroy():void 
		{
			//while (Core.screen_manager.getCurrentScreen)
			//{
				//
			//}
			Core.screen_manager.addScreen(new BasicScreen, true)//new SmokeTransition);
			//Core.screen_manager.destroy();
			//if (FlxG.stage.contains(Core.screen_manager.getDisplay)) FlxG.stage.removeChild(Core.screen_manager.getDisplay);
			//Mouse.hide();
			super.destroy();
		}
		
	}

}