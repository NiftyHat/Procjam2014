package game 
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import org.axgl.Ax;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.AxU;
	import org.axgl.input.AxKey;
	import org.axgl.text.AxFont;
	import org.axgl.text.AxText;
	/**
	 * ...
	 * @author ...
	 */
	public class PJTitleState extends AxState
	{
		
		protected var _background:AxSprite;
		protected var _title:AxSprite;
		protected var _subtitle:AxSprite;
		protected var _strapline:AxSprite;
		protected var _byline:AxSprite;
		
		protected var _prompt:AxText;
		
		public function PJTitleState() 
		{
			Ax.camera.fadeOut(0.1);
		}
		
		override public function create():void 
		{
			super.create();
			Ax.camera.fadeIn(1.0);
			_title = new AxSprite(48, 18, Core.lib.int.img_title_text);
			_background = new AxSprite(0, 0, Core.lib.int.img_game_start);
			_subtitle = new AxSprite (202, 136, Core.lib.int.img_subtitle_text);
			_strapline = new AxSprite (180, 172, Core.lib.int.img_subtitle_strapline);
			_byline = new AxSprite (648, 2, Core.lib.int.img_byline_text);
			_subtitle.alpha = 0;
			_strapline.alpha = 0;
			_byline.alpha = 0;
			TweenLite.to(_subtitle, 0.6, { delay: 2.2, alpha:1 } );
			TweenLite.to(_strapline, 0.4, { delay: 2.7, alpha:1 } );
			TweenLite.delayedCall(2.25, effectFlash);
			TweenLite.from(_title, 1.5, { delay:0.6, ease:Elastic.easeOut, y: -200 } );
			_prompt = new AxText (0, 0, AxFont.fromFont("alagard", false, 40), "Press Space to Start", Ax.viewWidth, "center");
			_prompt.y = 520;
			
			add(_background);
			add(_title);
			add(_subtitle);
			add(_strapline);
			add(_prompt);
			add(_byline);
			_prompt.visible = false;
		}
		
		private function effectFlash():void 
		{
			Ax.camera.flash(0.1);
			_prompt.visible = true;
			_prompt.text = "Push Space to MURDER"
			TweenLite.delayedCall(0.15, effectFlashEnd);
			_byline.alpha = 1.0;
		}
		
		private function effectFlashEnd():void 
		{
			Ax.camera.flash(0.1)
			_prompt.text = "Push Space to Start";
			TweenLite.delayedCall((Math.random() * 2) + 3.5, effectFlash);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Ax.keys.pressed(AxKey.SPACE)) {
				TweenLite.killTweensOf(_background);
				TweenLite.killTweensOf(_title);
				TweenLite.killTweensOf(_subtitle);
				TweenLite.killTweensOf(_strapline);
				TweenLite.killTweensOf(_byline);
				TweenLite.killDelayedCallsTo(effectFlash);
				TweenLite.killDelayedCallsTo(effectFlashEnd);
				Ax.switchState(new PJGameState());
			}
		}
		
	}

}