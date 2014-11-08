package com.p3.loading.bundles 
{

	import adobe.crypto.SHA1;
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * Asset bundle that uses the FZip library to store and load assets.
	 * Pass in the bytes of the zip when you create the bundle and call load to init it. Parsing
	 * very large zips may cause slowdown as it has to unpack all the assets.
	 * @author Duncan Saunders
	 */
	public class P3ZipBundle extends P3AssetBundle 
	{
		
		protected var _fZip:FZip = new FZip ();
		protected var _hash:String = "";
		protected var _bytes:ByteArray;
		
		public function P3ZipBundle($bytes:ByteArray = null):void
		{
			super();
			_name = "P3ZipBundle";
			_bytes = $bytes
		}
		
		override public function load():void 
		{
			makeHash(_bytes);
			_fZip.addEventListener(Event.COMPLETE, onZipLoaded);
			_fZip.loadBytes(_bytes);
			super.load();
		} 
		
		private function makeHash(bytes:ByteArray):void 
		{
			var hashBytes:ByteArray = new ByteArray();
			var offset:int = 8;
			if (offset > bytes.length)  offset = bytes.length;
			hashBytes.writeBytes(_bytes, offset,bytes.length - offset)
			_hash = SHA1.hashBytes(hashBytes) //.encodeByteArray();
		}
		
		public function loadBytes($bytes:ByteArray):void
		{
			_bytes = $bytes
			makeHash(_bytes);
			_fZip.addEventListener(Event.COMPLETE, onZipLoaded);
			_fZip.loadBytes($bytes);
			super.load();
		}
	
		private function onZipLoaded(e:Event):void 
		{
			var len:int = _fZip.getFileCount()
			for (var i:int = 0; i < len; i++)
			{
				var file:FZipFile = _fZip.getFileAt(i);

				if (file.filename.indexOf(".png") != -1 || 
						file.filename.indexOf(".jpg") != -1 || 
						file.filename.indexOf(".swf") != -1 ||
						file.filename.indexOf(".gif") != -1)
						{
							var loader:Loader = new Loader ();
							loader.loadBytes(file.content);
							loader.name = file.filename;
							loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSubloadComplete);
						}
						else if (file.filename.indexOf(".txt") != -1)
						{
							file.content.position = 0;
							_map[file.filename] = file.content.readUTFBytes(file.content.length)
						}
						else if (file.filename.indexOf(".xml") != -1)
						{
							file.content.position = 0;
							_map[file.filename] = new XML(file.content.readUTFBytes(file.content.length));
						}
						else
						{
							_map[file.filename] = file.content;
						}
			}
			onLoadComplete();
		}
		
		private function onSubloadComplete(e:Event):void 
		{
			var loader:LoaderInfo = LoaderInfo(e.target);
			//m_map[loader.loader.name] = loader.content;
			registerAsset(loader.loader.name, loader.content);
			
		}
		
		/**
		 * Returns the file data in the zip at the supplied $key path.
		 * Images - DisplayObject
		 * Txt/XML - Raw String.
		 * All Others - ByteArray
		 * @param	$key
		 * @return
		 */
		override public function getAsset($key:String):* 
		{
			return super.getAsset($key);
		}
		
		override public function hasAsset($path:String):Boolean 
		{
			return super.hasAsset($path);
		}
		
		public function getHash ():String
		{
			return _hash;
		}
	}

}