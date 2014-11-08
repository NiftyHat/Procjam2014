package com.p3.loading.bundles 
{
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3AssetManager 
	{
		
		private var _listBundles:Vector.<P3AssetBundle>;
		private var _length:int = 0;
		protected var _rootPath:String = "";
		protected var _external:P3ExternalBundle;
		protected var _isConstructClasses:Boolean;
		
		/**
		 * Manager for P3AssetBundles. Use addBundle to put them in and then call get asset
		 * to search through all the bundles together to get the asset you want.
		 * EXAMPLE:
			var manager:P3AssetManager = new P3AssetManager ();
			var ext:P3ExternalBundle = new P3ExternalBundle ("assets/");
			var int:P3InternalBundle = new P3InternalBundle ();
			manager.addBundle(ext);
			manager.addBundle(int);
			manager.addBundle(P3Preloader.assetList);
			manager.getAsset("assets/myImage.png");
			manager.setRoot("assets");
			manager.getAsset("myImage.png");
		 */
		public function P3AssetManager($rootPath:String = null) 
		{
			_rootPath = $rootPath;
			_listBundles = new Vector.<P3AssetBundle> ();
			_external = new P3ExternalBundle (_rootPath);
			addBundle(_external);
		}
		
		
		/**
		 * Adds a new asset bundle to the manager. getAsset itterated through all the bundles so
		 * if you add a lot of them it will dramatically slow down your asset processing time.
		 * @param	$newBundle
		 */
		public function addBundle($bundle:P3AssetBundle):void
		{
			_listBundles.push($bundle);
			_length++;
		}
		
		/**
		 * Removes an asset bundle from the manager.
		 * @param	$bundle
		 */
		public function removeBundle ($bundle:P3AssetBundle):void
		{
			_listBundles.splice(_listBundles.indexOf($bundle), 1);
			_length--;
		}
		
		/**
		 * Gets an asset with the supplied key. Prepends _rootPath if it is set.
		 * @param	$key
		 * @return
		 */
		public function getAsset ($key:String):*
		{
			var asset:*
			for (var i:int = 0; i < _length; i++)
			{
				var bundle:P3AssetBundle = _listBundles[i];
				asset = bundle.getAsset(_rootPath + $key)
				if (asset) 
				{
					return processAsset($key, asset);
				}
			}
			return null;
		}
		
		
		private function processAsset($key:String,$asset:*):*
		{
			var asset:* = $asset;
			if (_isConstructClasses && $asset is Class)
			{
				if (_isConstructClasses)
				{
					var filename:String = $key.split("/").pop();
					var cls:Class = asset as Class
					if (cls)
					{
						if (filename.indexOf(".txt") != -1)
						{
							var bytes:ByteArray = new cls();
							bytes.position = 0;
							return bytes.readUTFBytes(bytes.length);
						}
						else if (filename.indexOf(".xml") != -1)
						{
							var bytes:ByteArray = new cls();
							bytes.position = 0;
							return new XML(bytes.readUTFBytes(bytes.length));
						}
						else
						{
							return new cls();
						}
					}
				}
			}
			return asset;
		}
		
		/**
		 * Check to see if an asset is in the library. Prepends _rootPath if it is set.
		 * @param	$key
		 */
		public function hasAsset ($key:String):Boolean
		{
			for (var i:int = _length; i > 0; i--)
			{
				var bundle:P3AssetBundle = _listBundles[i];
				if (bundle.hasAsset(_rootPath + $key)) return true;
			}
			return false;
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
		 *   <li><b> onAllComplete : Function</b> Function co call when all the objects that are assigned this function are done loading</li>
		 **/
		public function loadAsset ($path:String, $vars:Object = null):void
		{
			_external.loadAsset($path, $vars);
		}
		
		/**
		 * See loadAsset for a full list of optional parameters.
		 * @param	$array
		 * @param	$vars
		 */
		public function loadAssets($array:Array, $vars:Object):void 
		{
			_external.loadAssets($array, $vars);
		}
		
		/**
		 * test function to check all bundles are returning the same class for getAsset.
		 * @param	$asset
		 */
		protected function testBundles ($key:String):void
		{
			var asset:*
			trace("///////////////////////////ASSET TEST:" + $key + "///////////////////////////");
			for (var i:int = 0; i < _length; i++)
			{
				var bundle:P3AssetBundle = _listBundles[i];
				asset = bundle.getAsset($key) //_rootPath + 
				if (asset) 
				{
					asset = processAsset($key, asset);
					trace(bundle.name + " asset result [" + getQualifiedClassName(asset) + "] path " + $key);
				}
			}
			//trace(_external.name  + " asset result [" + getQualifiedClassName(_external.getAsset($assetPath))+ "] path " + $assetPath);
		}
		
		/**
		 * Sets a root path, which is prepended to all asset keys when they are checked using getAsset/hasAsset.
		 * @param	$path
		 */
		public function setRoot ($path:String):void
		{
			_rootPath = $path;
		}
		
		public function get external():P3ExternalBundle 
		{
			return _external;
		}
		
	}

}