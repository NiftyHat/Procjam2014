 package axengine.world.level
{
		import axengine.events.AxLevelEvent;
		import axengine.events.AxLibraryEvent;
		import de.polygonal.ds.HashMap;
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.ProgressEvent;
		
        /**
         * ...
         * @author Duncan Saunders
         */
        public class AxLevelContent extends EventDispatcher
        {
               
                private var m_index_xml:XML;
                private var m_wave_xml:XML;
                private var m_shared_assets_xml:XML;
                private var m_assets_xml:XML;
                private var m_area_keys:Vector.<String>
               
                protected var m_key:String;
               

                private var m_isLoading:Boolean;
                private var m_isLoaded:Boolean;
                private var m_index_url:String;
                private var m_enum_total:int;
               
                private var m_log:String = "";
               
                private var m_shared_asset_url:String;
				
				private var _firstAreaKey:String;
				private var m_area_map:HashMap;
				private var m_area_list:Vector.<AxLevelArea>;
               
                public var LEVEL_PATH:String = Core.PATH_LEVELS;
                public var WAVE_PATH:String = Core.PATH_XML + "waves/"
               
                //All levels require some sort of header that describes what areas they have even if it's recursive.
               
                public function AxLevelContent()
                {
                        m_area_map = new HashMap();
                        m_area_list = new Vector.<AxLevelArea>();
                        m_index_xml = new XML ();
                }
               
                private function startLoad ():void
                {
                       
                }
               
                public function loadLocal ():void
                {
                        if (m_isLoading) return;
                       
                }
               
                public function loadRemote ($key:String):void
                {
					if (m_isLoading) return;
					m_key = $key;
					m_index_url = LEVEL_PATH +  $key + ".xml";
					log (" is loading from file " + m_index_url);
					Core.lib.loadAsset(m_index_url);
					Core.lib.addEventListener(AxLibraryEvent.BUNDLE_LOADED, onIndexLoaded);
					Core.lib.startLoad();                  
                }
               
                private function onIndexLoaded(e:AxLibraryEvent):void
                {
					Core.lib.removeEventListener(AxLibraryEvent.BUNDLE_LOADED, onIndexLoaded);
					initLevelData();
                }
               
                private function initLevelData():void {
                        m_index_xml = Core.lib.getAsset(m_index_url)
                        log (" index is loaded; loading ASSETS and AREAS");
                        if (m_index_xml.hasOwnProperty("@sharedAssets"))
                        {
                                var sharedAssetsFile:String = m_index_xml.@sharedAssets.toString() + ".xml";
                                m_shared_asset_url = LEVEL_PATH + sharedAssetsFile;
                                if (!Core.lib.hasAsset(sharedAssetsFile))
                                {
									Core.lib.addEventListener(AxLibraryEvent.BUNDLE_LOADED, onSharedAssetsLoaded);
									Core.lib.loadAsset(m_shared_asset_url);
									return;
                                }
                                else
                                {
									m_shared_assets_xml = Core.lib.getAsset(sharedAssetsFile);
                                }
                        }
                        var mergedAssetList:XMLList = new XMLList(<ASSETS/>);
                        if (m_index_xml.hasOwnProperty("ASSETS"))
                        {
                                mergedAssetList.ASSETS += m_index_xml.ASSETS.*;
                        }
                        if (m_shared_assets_xml)
                        {
                                mergedAssetList.ASSETS += m_shared_assets_xml.*;
                        }
                        //var mergedAssets:XML = new XML(<ASSETS/>);
                        //mergedAssets.appendChild(mergedAssets);
                        loadAssets(XML(mergedAssetList));
                        loadAreas(m_index_xml.INDEX);
                        Core.lib.ext.addEventListener(ProgressEvent.PROGRESS, onAssetLoadingProgress);
                        Core.lib.addEventListener(AxLibraryEvent.BUNDLE_LOADED, onLevelLoaded);
                        Core.lib.startLoad();
                       
                }
               
                private function onSharedAssetsLoaded($event:Event):void
                {
					Core.lib.removeEventListener(AxLibraryEvent.BUNDLE_LOADED, onSharedAssetsLoaded);
					m_shared_assets_xml = Core.lib.getAsset(m_shared_asset_url);
					initLevelData();
                }
               
                private function onLevelLoaded(e:AxLibraryEvent):void
                {
					for each (var area_key:String in m_area_keys)
					{
							var xml:XML = Core.lib.getAsset(area_key);
							var area:AxLevelArea = new AxLevelArea(xml);
							addArea(area);
					}
					verifyContent();
					enumerateEntities();
					m_isLoaded = true;
					dispatchEvent(new Event(Event.COMPLETE));
					Core.lib.removeEventListener (AxLibraryEvent.BUNDLE_LOADED, onLevelLoaded);
					Core.lib.ext.removeEventListener(ProgressEvent.PROGRESS, onAssetLoadingProgress);
					Core.control.dispatchEvent(new AxLevelEvent(AxLevelEvent.LOAD_FINISHED, null));
                }
               
                public function addArea($area:AxLevelArea):void
                {
					if (m_area_list.length == 0) _firstAreaKey = $area.key;
                        m_area_list.push($area);
                        m_area_map.set($area.key, $area)
                }
               
                public function getArea ($key:String):AxLevelArea
                {
                        if (!$key && m_area_list && m_area_list.length > 0) return m_area_list[0];
                        return m_area_map.get($key) as AxLevelArea;
                }
               
                public function enumerateEntities ():void
                {
                        var enum:uint = m_enum_total;
                        for each (var area:AxLevelArea in m_area_list)
                        {
                                for each (var item:XML in area.xml.OBJECTS.*)
                                {
                                        if (!item.hasOwnProperty("@enum"))
                                        {
                                                item.@enum = enum
                                                enum++;
                                        }
                                        else trace(item.name() + " already enumerated with value " + item.@enum);
                                }
                        }
                        m_enum_total = enum;
                        trace("total enumerated objects " + m_enum_total);
                }      
               
                private function verifyContent():void
                {
                        // blah blah do checks here.
                }
               
                public function loadAreas ($area_list:XMLList):void
                {
                        m_area_keys = new Vector.<String>()
                        var isMultiFile:Boolean = !(m_index_xml.hasOwnProperty("AREA"));
                        for each (var areaXMLKey:XML in $area_list.AREA)
                        {
                                var areaKey:String = areaXMLKey.toString()
                                if (isMultiFile)
                                {
									loadAreaFile(LEVEL_PATH + m_key + "/" + areaKey + ".xml");
                                }
                                else
                                {
									var list:XMLList =  m_index_xml.AREA.(hasOwnProperty("@key") && @key == areaKey)
									var xml:XML = list[0];
									if (xml)
									{
										var area:AxLevelArea = new AxLevelArea(xml);
										addArea(area);
									}
                                }
                        }
                }
               
                private function loadAreaFile ($url:String):void
                {
                        m_area_keys.push($url);
                        Core.lib.loadAsset($url);
                }
               
                protected function loadAssets ($list:XML):void
                {
                        m_assets_xml = $list;
                        Core.lib.loadAssetBundle($list);
                }
               
                public function getAssetPath($name:String):String
                {
                        return m_assets_xml.child($name).@path;
                }
               
               
                private function onAssetLoadingProgress(e:ProgressEvent):void
                {
                        trace("loading progress " + (100 / e.bytesTotal) * e.bytesLoaded);
                }
               
                public function unload ():void
                {
                       
                }
               
                protected function log ($text:String):void
                {
                        trace("Level - " + m_key + $text + "\n" );
                        m_log += "Level - " + m_key + $text + "\n" ;
                }
               
                public function get isLoaded():Boolean
                {
                        return m_isLoaded;
                }
               
                public function get wave_xml():XML
                {
                        return m_wave_xml;
                }
				
				public function get firstAreaKey():String 
				{
					return _firstAreaKey;
				}
               
        }

} 