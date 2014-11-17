package game 
{
	import base.Control;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import game.entities.characters.PJThief;
	import game.entities.characters.PJWizard;
	import game.ui.events.KillEvent;
	import org.axgl.Ax;
	import org.axgl.AxSprite;
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
		
		protected var _background:AxSprite;
		protected var _titleText:AxSprite;
		protected var _statsBackground:AxSprite;
		protected var _statsText:AxText;
		
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
			
			_background = new AxSprite (0, 0, Core.lib.int.img_game_over_bg);
			add(_background);
			_titleText = new AxSprite (42, 4, Core.lib.int.img_game_over_text);
			TweenLite.from(_titleText, 1.0, { delay:0.5, y: -200, ease:Elastic.easeOut } );
			_statsBackground = new AxSprite(16, 106);
			_statsBackground.create(244, 96, 0x66000000);
			_statsText = new AxText(28, 110, AxFont.fromFont("alagard", false, 18), "", 232);
			add(_background);
			add(_titleText);
			add(_statsBackground);
			add(_statsText);
			
			var countThieves:int = Core.control.score[KillEvent.KILLTYPE_THIEF];
			var countWizards:int = Core.control.score[KillEvent.KILLTYPE_WIZARD]
			var copy:String;
			if (Core.control.isWon) {
				copy = "You Won!";
			} else {
				copy = "You Lost!"
				copy += "\n Rouges Rubbed Out: " + countThieves.toString();
				copy += "\n Sexy Wizards Wasted: " +  countWizards.toString();
			}
			_statsText.text = copy;
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