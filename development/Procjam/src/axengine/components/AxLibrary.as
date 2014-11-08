 package axengine.components
{
		import assets.InternalAssets;
		import axengine.events.AxLibraryEvent;
		import axengine.util.AxGraphicAsset;
		import base.events.UIEvent;
		import com.p3.loading.bundles.P3ExternalBundle;
		import com.p3.loading.bundles.P3PreloaderBundle;
		import com.p3.loading.preloader.P3Preloader;
		import com.p3.utils.P3Globals;
		import flash.display.Bitmap;
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.utils.ByteArray;
		import flash.utils.Timer;
		import org.flixel.ext.FlxExternal;
		import org.flixel.FlxG;
        //import base.events.DataEvent;
        /**
         * ...
         * @author Duncan Saunders
         */
       
         /**
          * Dispatched when a set of assets (or single asset) has finished loading.
          */
        [Event(name="bundleLoaded", type="base.events.LibraryEvent")]
        public class AxLibrary extends EventDispatcher
        {
                              
				protected var m_int:InternalAssets;
                protected var m_ext:P3ExternalBundle;
                protected var m_pre:P3PreloaderBundle;
                protected var m_bundle:XML;
                protected var m_externalUpdate:Timer = new Timer (20, 0);

                public function AxLibrary()
                {
                        FlxG.log("init axLibrary");
                        var external_path:String = P3Globals.path + "assets/"
                        m_int = new InternalAssets ();
                        m_ext = new P3ExternalBundle (external_path); //

                        m_pre = P3Preloader.assetList;
                        m_int.load();
                        //m_ext.load();
                        
                }
               
                public function getMusic($name:String):void
                {
                        //var class_str:String = MUSIC_CLASS_PATH + $name
                        //return getDefinitionByName(class_str) as Class;
                }
               
                public function getGraphicAsset ($name:String, $useDefault:Boolean = true):AxGraphicAsset
                {
					var xml:XML = m_bundle.child($name)[0]
					if (xml)
					{
							var asset:AxGraphicAsset = new AxGraphicAsset ()
							asset.deserialize(xml);
							return asset;
					}
					if ($useDefault) return new AxGraphicAsset ();
					return null;
                }
				
               
                public function getAsset($path:String):*
                {
                        //if ($path.indexOf("mp3") != -1) trace("get asset " + $path);
                        var asset:*
                        if (m_pre && m_pre.getAsset($path))
                        {
                                asset = m_pre.getAsset($path)
                                if (asset is Bitmap && asset.bitmapData && asset.bitmapData!=null)
                                {
                                        return asset.bitmapData;
                                }
                                else
                                {
                                        return asset;
                                }                              
                        }
                        else if (m_ext.getAsset($path))
                        {
                                asset = m_ext.getAsset($path)
                                if (asset is Bitmap && asset.bitmapData && asset.bitmapData!=null)
                                {
                                       return asset.bitmapData;
                                }
                                else
                                {
                                        return asset;
                                }                              
                        }
                        else if (m_int.getAsset($path))
                        {
                                return m_int.getAsset($path);
                        }
                        else
                        {
                                trace("suggested asset key:")
                                trace("[Embed(source=" + $path + ")]");
                                //Core.control.level.dumpLog();
                                //throw new Error ("asset with key " + $path + " doesn't excist in the resources, did you load or embed it?");
                                Core.control.dispatchEvent(new UIEvent(UIEvent.SHOW_WARNING, "asset with key " + $path + " doesn't excist in the resources, did you load or embed it?"));
                        }
                        return null;
                }
               
               
                public function loadAsset ($path:String):void
                {
                        var key:String = $path;
                        if (m_int.hasAsset(key))
                        {
                                trace ("int asset " + key);
                                dispatchEvent(new AxLibraryEvent(AxLibraryEvent.ASSET_LOADED,m_int.getAsset(key)));
                        }
                        else
                        {
                                trace ("loading asset " + key);
                                m_ext.loadAsset(key);
                                //startLoad();
                        }
                }
               
                public function loadAssetBundle ($bundle:XML):void
                {
                        var key:String;
                        var item:XML
                        m_bundle = $bundle;
                        for each (item in $bundle.*)
                        {
                                trace("load item " + item.toXMLString());
                                if (item.hasOwnProperty("@path"))
                                {
                                        key = item.@path;
                                        if (!m_int.hasAsset(key))
                                        {
                                                m_ext.loadAsset(key);
                                        }
                                        //
                                }
                                else
                                {
                                        trace("no path found");
                                }
                               
                        }
                        startLoad();
                }
               
                public function loadMusicPackage($key:String):void
                {
                        if (!m_int.hasAsset($key))
                        {
                                m_ext.loadAsset($key);
                                startLoad();
                        }
                }
               
                public function startLoad ():void
                {
					m_ext.removeEventListener(Event.COMPLETE, onAssetBundleLoaded);
					m_ext.addEventListener(Event.COMPLETE, onAssetBundleLoaded);
					m_ext.startLoad();
                }
               
                public function hasAsset($path:String):Boolean
                {
                        if (m_ext.hasAsset($path) || m_pre.hasAsset($path) || m_int.hasAsset($path)) return true;
                        return false;
                }
               
                private function onAssetBundleLoaded(e:Event):void
                {
					dispatchEvent(new AxLibraryEvent(AxLibraryEvent.BUNDLE_LOADED, null));
                }
               
                public function get int():InternalAssets { return m_int; }
               
                public function get ext():P3ExternalBundle { return m_ext; }
               
                public function get pre():P3PreloaderBundle
                {
                        return m_pre;
                }
               
        }

} 