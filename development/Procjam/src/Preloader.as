package  
{
	import com.p3.loading.preloader.P3Preloader;
	import com.p3.utils.P3Globals;
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class Preloader extends P3Preloader 
	{
		
		public function Preloader() 
		{
			super();
			_logoVisible = false;
			_minimumTime = 0.01;
		}
		
		override public function init():void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			super.init();
			P3Globals.init(stage);
			loadAsset ('copy.xml', {prependURL: P3Globals.path + "assets/xml/"});
			loadAsset ('assets.xml', {prependURL:P3Globals.path + "assets/xml/levels/"});
			loadAsset ('game.xml', {prependURL:P3Globals.path + "assets/xml/"});
			loadAsset ('scripts.xml', {prependURL:P3Globals.path + "assets/xml/"});
			loadAsset ('animations.xml', {prependURL:P3Globals.path + "assets/xml/"});
			loadAsset ('missions.xml', {prependURL:P3Globals.path + "assets/xml/"});
			loadAsset ('levels.xml', { prependURL:P3Globals.path + "assets/xml/" } );
			loadAsset ('level01.xml', { prependURL:P3Globals.path + "assets/xml/levels/" } );
			loadAsset ('area_00.xml', {prependURL:P3Globals.path + "assets/xml/levels/level01/"});
		}
		
	}

}