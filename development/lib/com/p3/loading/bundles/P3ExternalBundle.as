package com.p3.loading.bundles 
{
	import com.p3.loading.bundles.events.P3AssetEvent;
	import com.p3.loading.bundles.helpers.P3ExternalAsset;
	import com.p3.loading.bundles.events.P3AssetEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * P3ExternalBundle
	 * @author Duncan Saunders
	 * @version 1.2.0
	 * 
	 * Bundle for loading external assets. Forked from the the preloader asset list code.
	 */
	
	 /**
	  * dispatch when the bundle wants to log something. Log events are handled internally in preloader
	  * @eventType com.p3.common.events.P3LogEvent
	  */
	[Event(name = "log", type = "com.p3.common.events.P3LogEvent")]
	 /**
	  * dispatch when the _assetsToLoad list is empty. Assigns the current list of loading assets to _content.
	  * @eventType com.p3.loading.preloader.events.P3AssetEvent
	  */
	[Event(name = "filesComplete", type = "com.p3.loading.bundles.events.P3AssetEvent")]
	/**
	 * dispatch when a single file is finished. Do manual dirty stuff here.
	 * @eventType com.p3.loading.preloader.events.P3AssetEvent
	 */
	[Event(name="fileComplete", type="com.p3.loading.bundles.events.P3AssetEvent")]
	public class P3ExternalBundle extends P3AssetBundle
	{
		private var _isComplete:Boolean;
		private var _isLoading:Boolean;
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		
		private var _assetsLoading:Vector.<P3ExternalAsset>;
		private var _assetsLoaded:Vector.<P3ExternalAsset>;
		private var _assetsToLoad:Vector.<P3ExternalAsset>;
		private var _assets:Vector.<P3ExternalAsset>
		private var _assetsDictionary:Dictionary;
		private var _maxConnections:int = 4;
		
		private var _content:Vector.<P3ExternalAsset>
		private var _waitForUpdate:Boolean = true;
		//private var _timerWaitForUpdate:Timer
		
		private var _callbackDictionary:Dictionary;
		private var _sizeDirty:Boolean;
		private var _rootDir:String = null;
		private var _updateTimer:Timer;
		

		public function P3ExternalBundle($root:String = null):void
		{
			_name = "P3ExternalBundle";
			_assetsLoading = new Vector.<P3ExternalAsset>;
			_assetsLoaded = new Vector.<P3ExternalAsset>;
			_assetsToLoad = new Vector.<P3ExternalAsset>;
			_assetsDictionary = new Dictionary ();
			_callbackDictionary = new Dictionary ();
			_rootDir = $root;
			_updateTimer = new Timer (50, 0);
			_updateTimer.addEventListener(TimerEvent.TIMER, onUpdateTimer);
			_updateTimer.start();
			//_timerWaitForUpdate = new Timer (20, 10);
		}
		
		private function onUpdateTimer(e:TimerEvent):void 
		{
			if (_isLoading) update()
		}
	
		
		public function startLoad():void
		{
			if (_assetsToLoad.length > 0)
			{
				_isLoading = true;
				_isComplete = false;
			}
			else
			{
				onLoadComplete();
			}
			
		}
		
		public function stopLoad():void 
		{
			_isLoading = false;
		}
		
		/**
		 * 	Loads an P3ExternalAsset with the supplied path.
		 * 
		 *   <li><b> name : String</b> String name of an asset for identification and nicer traces</li>
		 * 	 <li><b> group : String</b> Parameters for the onComplete fucntion</li>
		 * 	 <li><b> prependURL : String</b> Path to prepend to the asset url, not used for the asset key</li>
		 * 	 <li><b> estimateBytes : String</b> Estimated amount of bytes for nices loading animations</li>
		 *   <li><b> noAudit : Boolean</b> Stops the filesize audit from being run</li>
		 * 	 <li><b> onComplete : Function</b> Function co call when the object is done loading</li>
		 * 	 <li><b> onFail	: Function </b> Function co call if the file fails to load for some reason </li>
		 *   <li><b> onAllComplete : Function</b> Function co call when all the objects that are assigned this function are done loading</li>
		 **/
		public function loadAsset ($path:String, $vars:Object = null):void
		{
			//_timerWaitForUpdate.start();
			$vars = $vars ? $vars : { };
			_waitForUpdate = true;
			if (_rootDir) 
			{
				if ($vars.prependURL)$vars.prependURL = _rootDir + $vars.prependURL;
				else $vars.prependURL = _rootDir
			}
			if (_assetsToLoad.length <= 0) _content = new Vector.<P3ExternalAsset>
			var asset:P3ExternalAsset = new P3ExternalAsset ($path, $vars);
			_assetsToLoad.push(asset);
			indexAsset(asset);
		}
		
		/**
		 * See loadAsset for a full list of optional parameters.
		 * @param	$array
		 * @param	$vars
		 */
		public function loadAssets($array:Array, $vars:Object):void 
		{
			//_timerWaitForUpdate.start();
			_waitForUpdate = true;
			if (_assetsToLoad.length <= 0) _content = new Vector.<P3ExternalAsset>
			for each (var $path:String in $array)
			{
				var asset:P3ExternalAsset = new P3ExternalAsset ($path, $vars);
				_assetsToLoad.push(asset);
				indexAsset(asset);
			}
		}
		
		public function destroy ():void
		{
			var item:P3ExternalAsset;
			for each (item in _assetsDictionary)
			{
				if (item)
				{
					item.destroy();
					item.removeEventListener(P3AssetEvent.ASSET_COMPLETE, onAssetLoaded);
					item.removeEventListener(IOErrorEvent.IO_ERROR, onAssetLoadError);
					delete _assetsDictionary[item.path];
				}
			}
			_assetsLoading = null;
			_assetsLoaded = null;
			_assetsToLoad = null;
			_assetsDictionary = null;
			_content = null;
			_callbackDictionary = null;
		}
		
		private function addToCallbackList ($asset:P3ExternalAsset):void
		{
			if ($asset.onAllCompleteCallback == null || !$asset) return;
			var fileList:Vector.<P3ExternalAsset> = _callbackDictionary[$asset.onAllCompleteCallback];
			if (fileList) fileList.push($asset)
			else
			{
				fileList = new Vector.<P3ExternalAsset> ()
				fileList.push($asset)
				_callbackDictionary[$asset.onAllCompleteCallback] = fileList;
			}
		}
		
		private function checkCallbackList($asset:P3ExternalAsset):Vector.<P3ExternalAsset> 
		{
			var assetList:Vector.<P3ExternalAsset> = _callbackDictionary[$asset.onAllCompleteCallback];
			
			if (assetList)
			{
				for each (var asset:P3ExternalAsset in assetList)
				{
					if (!asset.isLoaded) return null;
				}
			}
			//if it passes remove the callback from the dictionary to make sure it doesn't get called again.
			delete _callbackDictionary[$asset.onAllCompleteCallback];
			return assetList;
		}
		
		public function update ():void
		{
			while (_assetsLoading.length < _maxConnections && _assetsToLoad.length > 0 && !_waitForUpdate)
			{
				var nextAsset:P3ExternalAsset = _assetsToLoad.shift();
				_assetsLoading.push(nextAsset);
				nextAsset.addEventListener(P3AssetEvent.ASSET_COMPLETE, onAssetLoaded);
				nextAsset.addEventListener(IOErrorEvent.IO_ERROR, onAssetLoadError);
				nextAsset.startLoad();
				_sizeDirty = true;
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
				//clear content
			}
			_waitForUpdate = false;
		}
		
		private function onAssetLoaded(e:P3AssetEvent):void 
		{
			var asset:P3ExternalAsset = P3ExternalAsset(e.target);
			var assetList:Vector.<P3ExternalAsset> = checkCallbackList(asset)
			_assetsLoaded = _assetsLoaded.concat(_assetsLoading.splice(_assetsLoading.indexOf(asset), 1));
			if (!_content) _content = new Vector.<P3ExternalAsset>;
			_content.push(asset);
			registerAsset(asset.path, asset);
			trace("loaded asset " + asset.name + "REMAINS =" + _assetsToLoad.length);
			if (asset.name) registerAsset(asset.name, asset)
			if (asset.onCompleteCallback != null) 
			{
				if (asset.onCompleteParams) asset.onCompleteCallback.apply(null, asset.onCompleteParams);
				else if (asset.onCompleteCallback.length == 1) asset.onCompleteCallback(asset);
				else asset.onCompleteCallback();
			}
			if (asset.onAllCompleteCallback != null)
			{
				if (assetList)
				{
					if (asset.onAllCompleteCallback.length == 1) asset.onAllCompleteCallback(assetList);
					else asset.onAllCompleteCallback();
				}
			}
			if (_assetsToLoad.length <= 0 && _assetsLoading.length == 0 ) 
			{
				//&& !_isComplete
				dispatchEvent(new P3AssetEvent(P3AssetEvent.ASSETS_COMPLETE, this));
				
				_isComplete = true;
				onLoadComplete();
			}
		}
		
		override public function getAsset($key:String):* 
		{
			var asset:P3ExternalAsset = super.getAsset($key);
			if (asset) 
			{
				var raw:* = asset.rawContent;
				if (raw is Class)
				{
					return new raw();
				}
				return raw
			}
			else return null;
			
		}
		
		public function getAssetReferance($key:String):* 
		{
			var asset:P3ExternalAsset = super.getAsset($key);
			if (asset) 
			{
				return asset;
			}
			return null;
		}
		
		public function loadBundle (assetBundle:P3AssetBundle):void
		{
			var list:Vector.<String> = assetBundle.getPaths();
			for each (var path:String in list)
			{
				loadAsset(path);
			}
			startLoad();
		}
				
		private function onAssetLoadError(e:IOErrorEvent):void 
		{
			var asset:P3ExternalAsset = P3ExternalAsset(e.target);
			_assetsLoading.splice(_assetsLoading.indexOf(asset), 1)
			_assetsDictionary[asset.path] = null;
			warning ("failed to load asset : " + asset.path);
			if (asset.onFailCallback != null)
			{
				if (asset.onFailParams) asset.onFailCallback.apply(null,asset.onFailParams)
				else if (asset.onFailCallback.length == 1) asset.onFailCallback()
				else asset.onFailCallback();
			}
			if (_assetsToLoad.length <= 0 && _assetsLoading.length == 0) 
			{
				dispatchEvent(new P3AssetEvent(P3AssetEvent.ASSETS_COMPLETE, this));
				
				_isComplete = true;
				onLoadComplete();
			}
		}
		
		private function indexAsset($asset:P3ExternalAsset):void 
		{
			var currAsset:P3ExternalAsset;
			currAsset = _assetsDictionary[$asset.path]
			if (currAsset)
			{
				log("replacing asset with path " + currAsset.path + " with asset " + $asset);
			}
			_assetsDictionary[$asset.path] = $asset;
			if ($asset.name)
			{
				if (currAsset)
				{
					log("replacing asset with key " + currAsset.name + " with asset " + $asset);
				}
				_assetsDictionary[$asset.name] = $asset;
			}
			if (!_assets) _assets = new Vector.<P3ExternalAsset>
			_assets.push($asset);
			$asset.addEventListener(P3AssetEvent.ASSET_AUDIT_COMPLETE, onAssetAuditDone);
			addToCallbackList($asset);
		}
		
		private function onAssetAuditDone(e:P3AssetEvent):void 
		{
			var asset:P3ExternalAsset = e.data;
			if (asset)
			{
				_bytesTotal += asset.bytesTotal
			}
		}
		
		public function checkComplete():void 
		{
			if (!_assetsToLoad) return;
			if (_assetsToLoad.length == 0 && _assetsLoading.length == 0) 
			{
				_isComplete = true;
			}
			else 
			{
				_isComplete = false;
			}
		}
		
		public function get isComplete ():Boolean
		{
			return _isComplete
		}
		
		public function get bytesLoaded():uint 
		{
			if (_sizeDirty)
			{
				_bytesLoaded = 0;
				for each (var item:P3ExternalAsset in _assets)
				{
					_bytesLoaded += item.bytesLoaded
				}
			}
			return _bytesLoaded;
		}
		
		public function get bytesTotal():uint 
		{
			
			return _bytesTotal;
		}

		public function get assets():Vector.<P3ExternalAsset>
		{
			return _assetsLoaded;
		}
		
		public function get content():Vector.<P3ExternalAsset> 
		{
			return _content;
		}
		
	}

}