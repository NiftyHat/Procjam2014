package game.entities 
{
	import axengine.entities.AxPlayer;
	import axengine.world.AxWorld;
	import game.PJEntity;
	import org.axgl.Ax;
	import org.axgl.input.AxKey;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJPlayer extends PJEntity 
	{
		
		public function PJPlayer() 
		{
			super();
			addAnimation("walk_down", [0, 1, 2],4);
			addAnimation("walk_left", [3, 4, 5],4);
			addAnimation("walk_right", [6, 7, 8],4);
			addAnimation("walk_up", [9, 10, 11],4);
			addAnimation("idle_down", [1]);
			addAnimation("idle_left", [4]);
			addAnimation("idle_right", [7]);
			addAnimation("idle_up", [10]);
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world); 
			_libraryAssetName = "PLAYER";
			loadNativeGraphics();
		}
		
		override public function update():void 
		{
			super.update();
			if (Ax.keys.down(AxKey.DOWN)) {
				move(DOWN);
			}
			else if (Ax.keys.down(AxKey.UP)) {
				move(UP);
			}
			else if (Ax.keys.down(AxKey.LEFT)) {
				move(LEFT);
			}
			else if (Ax.keys.down(AxKey.RIGHT)) {
				move(RIGHT);
			}
			else {
				move(NONE);
			}
			if (_bIsMoving) {
				animate("walk" + _animSuffix);
			} else {
				animate("idle" + _animSuffix);
			}
		}
		
		override protected function move($dir:int):void 
		{
			super.move($dir);
		}
		
	}

}