package axengine.state
{
	import axengine.entities.AxPlayer;
	import axengine.entities.markers.AxMarkerStart;
	import com.p3.loading.preloader.P3Preloader;
	import com.p3.utils.functions.P3BytesToXML;
	import org.axgl.Ax;
	import org.axgl.AxState;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxInitState extends AxState
	{
		
		public function AxInitState()
		{
			super();
		}
		
		public function loadXML ():void
		{
			//Core.xml.anims = getXMLFile('animations.xml');
			//Core.xml.assets = getXMLFile('assets.xml');
			Core.xml.copy = getXMLFile('copy.xml');
			Core.xml.game = getXMLFile('game.xml');
			Core.xml.levels = getXMLFile('levels.xml');
			//Core.xml.missions = getXMLFile('missions.xml');
			//Core.xml.convo = getXMLFile('scripts.xml');
			Core.xml.init();
		}
		
		override public function create():void
		{
			super.create();
			loadXML();
			Core.control.init();
			registerClasses();
			Ax.background.red = 0.5;
			Ax.background.blue = 0.5;
			Ax.background.green = 0.5;
			Core.control.initLevelData();
			Core.control.startNewGame();
		}
		
		protected function registerClasses():void
		{
			Core.registry.registerClass(AxPlayer, "PLAYER");
			Core.registry.registerClass(AxMarkerStart, "MARKER_START");
		}
		
		//TODO - wrap this function inside the Library.
		public function getXMLFile ($name:String):XML
		{
			var loadedAsset:* = P3Preloader.assetList.getAsset($name)
			if (loadedAsset) return new XML(loadedAsset);
			loadedAsset = P3BytesToXML(Core.lib.getAsset("xml/" + $name))
			return loadedAsset;
		}
		
	}

}