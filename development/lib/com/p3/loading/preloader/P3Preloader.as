package com.p3.loading.preloader 
{
	import com.p3.common.events.P3LogEvent;
	import com.p3.common.P3Colours;
	import com.p3.loading.bundles.events.P3AssetEvent;
	import com.p3.loading.bundles.helpers.P3ExternalAsset;
	import com.p3.loading.bundles.P3PreloaderBundle;
	import com.p3.loading.preloader.events.P3PreloaderEvent;
	import com.p3.utils.functions.P3FormatFileSize;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * P3Preloader
	 * Robust factory frame preloader with skinning and asset loading. Use the meta tag
	 * [Frame(factoryClass = "Preloader")]
	 * To add your own.
	 * @author Duncan Saunders;
	 * @version 2.5.0;
	 * 
	 * Implimentation Example - Loading a single asset
	 * 
	 *	override public function init():void 
	 *	{
	 *		super.init();
	 *		loadAsset("xml/game.xml", {onComplete:onIndexLoaded, name:"game.xml"})
	 *	}
	 * 
	 *  Retriving asset using callback
	 * 
	 * 	private function onIndexLoaded($content:P3ExternalAsset):void 
	 *	{
	 *		var index:XML = $content.rawContent
	 *		for each (var item:XML in index.LEVEL_DATA.*)
	 *		{
	 *			var key:String = item.ID.@key.toString()
	 *			loadAsset("xml/levels/" + key + ".xml", { onAllComplete:onLevelsLoaded} );
	 *		}
	 *	}
	 * 
	 * Retriving asset using key
	 * 
	 * 	private function onIndexLoaded():void 
	 *	{
	 *		var index:XML = getAsset("game.xml");
	 *		for each (var item:XML in index.LEVEL_DATA.*)
	 *		{
	 *			var key:String = item.ID.@key.toString()
	 *			loadAsset("xml/levels/" + key + ".xml", { onAllComplete:onLevelsLoaded} );
	 *		}
	 *	}
	 * 
	 *	private function onLevelsLoaded($content:Vector.<P3ExternalAsset>):void 
	 *	{
	 *		for each (var asset:P3ExternalAsset in $content)
	 *		{
	 *			var xml:XML = asset.rawContent;
	 *			for each (var area:XML in xml.AREAS.*)
	 *			{
	 *				loadAsset("xml/levels/" + xml.@key + "/" + area.toString() + ".xml", {onAllComplete:onAreasLoaded});
	 *			}
	 *			
	 *		}
	 *	}
	 */
	[Event(name = "preloadComplete", type = "com.p3.loading.preloader.events.P3PreloaderEvent")]
	/**
	  * dispatched when loading is complete. Use it for manual control on the preload skin like playing sounds/animtations
	  * @eventType com.p3.loading.preloader.events.P3PreloaderEvent
	  */
	[Event(name = "log", type = "com.p3.common.events.P3LogEvent")]
	 /**
	  * dispatch when the _assetsToLoad list is empty. Assigns the current list of loading assets to _content.
	  * @eventType com.p3.loading.preloader.events.P3PreloaderEvent
	  */
	[Event(name = "filesComplete", type = "com.p3.loading.preloader.events.P3PreloaderEvent")]
	/**
	 * dispatch when a single file is finished. Do manual dirty stuff here.
	 * @eventType com.p3.loading.preloader.events.P3PreloaderEvent
	 */
	[Event(name="fileComplete", type="com.p3.loading.preloader.events.P3PreloaderEvent")]
	public class P3Preloader extends MovieClip
	{
		protected static var _rootPath:String;
		protected static var _assetList:P3PreloaderBundle;
		
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		private var _percLoaded:uint;
		
		private var _timerMinimum:Timer;
		private var _timerOnComplete:Timer;
		
		protected var _minimumTime:Number = 0.8;
		protected var _waitOnComplete:Number  = 0;
		//protected var _
		
		protected var _mainClassName:String = "Main";
		
		private var _defaultSkin:P3PreloaderDefaultSkin;
		private var _initTime:int;
		
		private var _isTimerComplete:Boolean;
		private var _isLoadingComplete:Boolean;
		private var _isPaused:Boolean;
		private var _isDebug:Boolean;
		
		protected var _verbose:Boolean = true;
		protected var _logoVisible:Boolean = true;

		public static const VERSION:String = "2.5.0";
		
		public function P3Preloader() 
		{
			var e:Error = new Error()
			if (e && e.getStackTrace() && e.getStackTrace().search(/:[0-9]+]$/m) > -1)
			{
				_isDebug = true;
			}	
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//entry point
			preInit();
		}
		
		
		/**
		 * Pre setup the complete timer, minimum timer, creates the asset list. Prints the prelaoder size to the log.
		 */
		private function preInit ():void {
			var timerRepeatCount:int = _minimumTime * 50;
			var completeRepeatCount:int = _waitOnComplete * 50;
			var pre_bytes:int = stage.loaderInfo.bytesLoaded;
			
			_assetList = new P3PreloaderBundle ();
			_assetList.addEventListener(P3LogEvent.LOG, onAssetLoaderLog);
			_assetList.addEventListener(P3AssetEvent.ASSET_COMPLETE, onAssetComplete);
			_assetList.addEventListener(P3AssetEvent.ASSETS_COMPLETE, onAssetsComplete);
			_timerMinimum = new Timer (20, timerRepeatCount);
			if (completeRepeatCount > 0) _timerOnComplete = new Timer (20, completeRepeatCount);
			if (!_isPaused) _timerMinimum.start();
			
			_initTime = getTimer();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			started();
			init();
		}
		
		/**
		 * Overridable startup function. Put your own asset loading and graphics stuff in here.
		 */
		public function init ():void
		{
			update(0);
			var pre_bytes:int = stage.loaderInfo.bytesLoaded;
			log("[P3Preloader] - version " + VERSION);
			if (pre_bytes > 131072) log("[P3Preloader] - Preloader size " + P3FormatFileSize(pre_bytes), 0xFF0000);
			else if (_verbose) log("[P3Preloader] - Preloader size " + P3FormatFileSize(pre_bytes));
		}

		
		private function onAssetsComplete(e:P3AssetEvent):void 
		{
			
			dispatchEvent(e);
		}
		
		private function onAssetComplete(e:P3AssetEvent):void 
		{
			dispatchEvent(e);
		}
		
		private function onAssetLoaderLog(e:P3LogEvent):void 
		{
			if (_verbose) 
			{
				log("[P3Preloader] P3AssetList " + e.text, e.logCode);
			}
			else
			{
				if (e.logCode != P3Colours.COLOUR_LOG && e.logCode != P3Colours.COLOUR_INFO)
				{
					log("[P3Preloader] P3AssetList " + e.text, e.logCode);
				}
			}			
		}
		 
		 /**
		  * Wrapped load asset function for the assetList. See the asset list class itself for full docs.
		  * @param	$path - Path of the asset you want to load
		  * @param	$vars - Optional configuartion vars, onComplete, noAudit, name..ect ect
		  * @see com.p3.loading.preloader.structs.P3PreloaderAsset#loadAsset()
		  */
		public function loadAsset ($path:String, $vars:Object = null):void
		{
			_assetList.loadAsset($path, $vars);
		}
		
		 /**
		  * Wrapped load asset function for the assetList. See the asset list class itself for full docs.
		  * @param	$array - Array of strings for the files you want to load.
		  * @param	$vars - Optional configuartion vars, onComplete, noAudit, name..ect ect
	      * @see com.p3.loading.preloader.structs.P3PreloaderAsset#loadAssets()
		  */
		public function loadAssets ($array:Array, $vars:Object = null):void
		{
			_assetList.loadAssets($array, $vars);
		}
		
		/**
		 * Called when the loading is started so you can track stuff
		 */
		public function started ():void
		{
			
		}
		
		/**
		 * Called when the loading is finished, has a referance to the main for icky passing back and forth.
		 * Function is triggered after the main has been added to the display list.
		 */
		public function finished ($main:DisplayObject):void
		{
			
		}
		
		public function update ($perc:Number):void
		{
			if (!_defaultSkin) 
			{
				_defaultSkin = new P3PreloaderDefaultSkin ();
				_defaultSkin.logoVisible = _logoVisible;
				addChild(_defaultSkin);
			}
			else 
			{
				_defaultSkin.update($perc);
			}
		}
		
		/**
		 * Returns asset data for an asset.
		 * @param	$key stored location of the asset set in loadAsset either the path or the name.
		 * @return raw asset data. XML, ByteArray, Bitmap ect ect
		 */
		public function getAsset ($key:String):*
		{
			return _assetList.getAsset($key);
		}
		
		/**
		 * Pauses the preloader;
		 */
		public function pause():void {
			
			if (!_isPaused && _timerMinimum)
			{
				_timerMinimum.stop()
			}
			_isPaused = true;
		}
		
		/**
		 * Resumes the preloader.
		 */
		public function resume ():void
		{
			if (_isPaused && _timerMinimum)
			{
				_timerMinimum.start()
			}
			_isPaused = false;
			
		}
		
		private function onEnterFrame(e:Event):void
		{
			var loadingComplete:Boolean = (framesLoaded == totalFrames )
			if (loadingComplete && _isTimerComplete && _assetList.isComplete)
			{
				if (_timerOnComplete)
				{
					if (!_timerOnComplete.running)
					{
						_timerOnComplete.start();
					}
					else if (_timerOnComplete.currentCount == _timerOnComplete.repeatCount)
					{
						_timerOnComplete.stop();
						onComplete();
						return; 
					}
				}
				else
				{
					onComplete();
					return; 
				}
				
				
				//dispatchEvent(new P3PreloaderEvent (P3PreloaderEvent.PRELOAD_COMPLETE, true, false));
			}	
			else
			{
				updateBytes()
				var percLoaded:Number = 100 / _bytesTotal * _bytesLoaded;
				var maxPerc:Number = 100 / _timerMinimum.repeatCount * _timerMinimum.currentCount;
				if (percLoaded > maxPerc) percLoaded = maxPerc;
				_assetList.update();
				update(percLoaded);
				
			}
			if (!_isLoadingComplete && _timerMinimum.currentCount == _timerMinimum.repeatCount) 
			{
				_isTimerComplete = true;
				if (_assetList) _assetList.checkComplete();
			}
		}
		
		private function onComplete():void 
		{
			addMain();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (_defaultSkin) _defaultSkin.remove();
			_isLoadingComplete = true;
			destroy();
		}
		
		protected function destroy():void
		{
			_rootPath = null
			_timerMinimum = null;
			_mainClassName = null;
			_defaultSkin = null;			
		}
		
		private function addMain ():void
		{
			nextFrame();			
			var loadTime:int = (getTimer() - _initTime) / 100;
			log("[P3Preloader] - Preload complete (" + loadTime + "ms).");
			var main:Class = Class(getDefinitionByName(_mainClassName));
			if (main)
			{
				log("[P3Preloader] - Adding the main to stage and initilizing");
				_assetList.removeEventListener(P3LogEvent.LOG, onAssetLoaderLog);
				_assetList.removeEventListener(P3AssetEvent.ASSET_COMPLETE, onAssetComplete);
				_assetList.removeEventListener(P3AssetEvent.ASSETS_COMPLETE, onAssetsComplete);
				var app:DisplayObject = new main();
				parent.addChild(app);
				parent.swapChildren(app, this);
				dispatchEvent(new P3PreloaderEvent(P3PreloaderEvent.PRELOAD_COMPLETE, this, true));
				finished(app);
			}	
			else
			{
				log("[P3Preloader] Local - Failed to start, no main...");
			}
		}
		
		private function updateBytes ():void
		{
			_bytesTotal = _assetList.bytesTotal + stage.loaderInfo.bytesTotal;
			_bytesLoaded = _assetList.bytesLoaded + stage.loaderInfo.bytesLoaded;
		}
		
		protected function log($text:String, $colour:int = -1):void 
		{
			
			
			if (_defaultSkin)
			{
				if (_isDebug) _defaultSkin.addLogText($text, $colour);
			}
			trace($text)
		}
		
		static public function get assetList():P3PreloaderBundle 
		{
			return _assetList;
		}
		
		public static function get rootPath():String 
		{
			return _rootPath;
		}

		
				
	
		
	}

}