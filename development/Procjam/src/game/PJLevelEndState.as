package game 
{
	import base.Control;
	import org.axgl.Ax;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;
	import org.axgl.text.AxFont;
	import org.axgl.text.AxText;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJLevelEndState extends AxState 
	{
		
		public function PJLevelEndState() 
		{
			super();
			
		}
		
		override public function create():void 
		{
			super.create();
			Ax.camera.follow(null);
			Ax.camera.x = 0;
			Ax.camera.y = 0;
			var copy:String;
			if (Core.control.isWon) {
				copy = "You Won! \n Gold Lost " + Math.abs(Core.control.score);
			} else {
				copy = "You Lost!";
			}
			add(new AxText(0, Ax.viewHeight * 0.5 , AxFont.fromFont("alagard", false, 32), copy, Ax.viewWidth, "center"));
		}
		
		override public function update():void 
		{
			super.update();
			if (Ax.keys.released(AxKey.SPACE)) {
				Ax.switchState(new PJGameState());
			}
		}
		
	}

}