package game.world 
{
	import axengine.world.AxWorld;
	import axengine.world.level.AxLevel;
	import game.entities.PJPlayer;
	import org.axgl.text.AxText;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJWorld extends AxWorld 
	{
		
		public function PJWorld(x:Number=0, y:Number=0) 
		{
			super(x, y);
			add(new AxText(0, 0,  null, "Ax World"));
			m_level = new AxLevel ();
			m_level.init("level");
			m_level.loadData();
			_player = new PJPlayer();
		}
		
		override protected function init():void 
		{
			super.init();
			//_player = new PJPlayer();
			//addEntity(_player);
			initGroups();
		}

		override public function update():void 
		{
			super.update(); 
			trace(_player.x, _player.y);
		}
		
	}

}