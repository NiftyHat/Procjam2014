package game.entities 
{
	import axengine.entities.AxPlayer;
	import axengine.world.AxWorld;
	import be.dauntless.astar.core.AstarPath;
	import flash.geom.Point;
	import game.ai.PathCallbackRequest;
	import game.PJEntity;
	import game.world.PJWorld;
	import org.axgl.Ax;
	import org.axgl.input.AxKey;
	import org.axgl.util.AxTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJPlayer extends PJEntity 
	{
	
		protected var _stunTimer:AxTimer;
		protected var _isStunned:Boolean = false;
		
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
			_mMoveSpeed = 0.25;
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
			if (_isStunned) {
				return;
			}
			if (Ax.keys.down(AxKey.Z)) {
			} 
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
		
		public function stun($time:Number):void 
		{
			startFlicker();
			_isStunned = true;
			if (!_stunTimer) {
				_stunTimer = addTimer($time, onStunComplete);
			} else {
				_stunTimer.repeat = 0;
				_stunTimer.alive = true;
			}
			_stunTimer.start();
		}
		
		private function onStunComplete():void 
		{
			_isStunned = false;
			stopFlicker();
		}
		
		override protected function move($dir:int):void 
		{
			super.move($dir);
		}
		
	}

}