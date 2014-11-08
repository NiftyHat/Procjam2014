/**
 * ..
 * 
 * Requires compiler config options.
 * 
 * -define=CONFIG::IOS,false
 * -define=CONFIG::ANDROID,true
 * 
 * .
 * @author Adam H
 */
package com.p3.starling.loading
{
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.XMLLoader;
	import org.osflash.signals.Signal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	import flash.media.Sound;
	import flash.utils.Dictionary;

	CONFIG::MOBILE
	{
		import flash.filesystem.File;
	}

	public class P3StarlingAssets extends EventDispatcher
	{
		static private var 	_instance:P3StarlingAssets;
		static private var 	_allowInstance:Boolean;
		static private const TEXTURE:String = "_image";
		static private const DATA:String = "_xml";
		static private const GLYPH:String = "_glyph";
		static private const FNT:String = "_fnt";
		public var signalComplete:Signal;
		public var signalError:Signal;
		private var loadedDict:Dictionary = new Dictionary();
		private var loadedAudioDict:Dictionary = new Dictionary();
		private var fontsDict:Dictionary = new Dictionary();
		private var texturesDict:Dictionary = new Dictionary();
		private var textureAtlasDict:Dictionary = new Dictionary();
		private var _localLoad:Boolean;
		private var _loaderMax:LoaderMax;
		private var _scaleFactor:Number = 1;

		/*-------------------------------------------------
		 * PUBLIC CONSTRUCTOR
		-------------------------------------------------*/
		public function P3StarlingAssets()
		{
			if (!P3StarlingAssets._allowInstance) throw new Error("Error: Use P3StarlingAssets.inst instead of the new keyword.");
		}

		public static function get inst():P3StarlingAssets
		{
			if (P3StarlingAssets._instance == null)
			{
				P3StarlingAssets._allowInstance = true;
				P3StarlingAssets._instance = new P3StarlingAssets();
				P3StarlingAssets._allowInstance = false;
			}
			return P3StarlingAssets._instance;
		}

		/*-------------------------------------------------
		 * PUBLIC FUNCTIONS
		-------------------------------------------------*/
		/**
		 * Creats an instance if LoaderMax for loading.
		 * TODO: Remove the dependancy on LoaderMax.
		 */
		public function initLoader():void
		{
			signalComplete = new Signal();
			signalError = new Signal();
			
			_loaderMax = new LoaderMax({name:"P3StarlingAssets", onComplete:onLoadComplete, onError:onLoadError});
			_loaderMax.maxConnections = 1;
		}

		/**
		 * Loads the Spritesheet and data. This will prefix the file name with the 'path' and the 'folder'. 
		 * It will also suffix 'Texture' to the image and 'Data' to the XML.
		 * TODO: set up folder so it can be dynamically set and also the same for the suffixes.		 * 
		 */
		public function preloadSpriteSheet(sheetName:String, path:String = ""):void
		{
			var suffix:String = "_x" + _scaleFactor;
			var xmlURL:String = sheetName + suffix + ".xml";
			var imageURL:String = sheetName + suffix + ".png";

			CONFIG::MOBILE
			{
				var file:File;

				// XML
				file = flash.filesystem.File.applicationDirectory.resolvePath(path + xmlURL);
				if (!file.exists)
				{
					file = flash.filesystem.File.applicationStorageDirectory.resolvePath(path + xmlURL);
					if (!file.exists) throw new Error("File is not available: " + file.url);
				}
				_loaderMax.append(new XMLLoader(file.url, {name:sheetName + DATA}));

				// IMAGE
				file = flash.filesystem.File.applicationDirectory.resolvePath(path + imageURL);
				if (!file.exists)
				{
					file = flash.filesystem.File.applicationStorageDirectory.resolvePath(path + imageURL);
					if (!file.exists) throw new Error("File is not available: " + file.url);
				}
				_loaderMax.append(new ImageLoader(file.url, {name:sheetName + TEXTURE}));
				return;
			}

			trace(this, "Preload Image:", path + xmlURL);

			_loaderMax.append(new XMLLoader(path + xmlURL, {name:sheetName + DATA}));
			_loaderMax.append(new ImageLoader(path + imageURL, {name:sheetName + TEXTURE}));
		}

		/**
		 * Loads the Spritesheet and data. This will prefix the file name with the 'path' and the 'folder'. 
		 * It will also suffix 'Texture' to the image and 'Data' to the XML.
		 * TODO: set up folder so it can be dynamically set and also the same for the suffixes.		 * 
		 */
		public function preloadFont(name:String, size:int, path:String = ""):void
		{
			var fontName:String = name + "_" + String(size * _scaleFactor);

			CONFIG::MOBILE
			{
				var file:flash.filesystem.File;

				// XML
				file = flash.filesystem.File.applicationDirectory.resolvePath(path + fontName + ".fnt");
				if (!file.exists)
				{
					file = flash.filesystem.File.applicationStorageDirectory.resolvePath(path + fontName + ".fnt");
					if (!file.exists) throw new Error("File is not available: " + file.url);
				}
				_loaderMax.append(new XMLLoader(file.url, {name:fontName + FNT}));

				// IMAGE
				file = flash.filesystem.File.applicationDirectory.resolvePath(path + fontName + ".png");
				if (!file.exists)
				{
					file = flash.filesystem.File.applicationStorageDirectory.resolvePath(path + fontName + ".png");
					if (!file.exists) throw new Error("File is not available: " + file.url);
				}
				_loaderMax.append(new ImageLoader(file.url, {name:fontName + GLYPH}));
				return;
			}

			_loaderMax.append(new ImageLoader(path + fontName + ".png", {name:fontName + GLYPH}));
			_loaderMax.append(new XMLLoader(path + fontName + ".fnt", {name:fontName + FNT}));

			trace("preloadFont", fontName);
		}

		public function preloadAudio(name:String, path:String = ""):void
		{
			CONFIG::MOBILE
			{
				var file:flash.filesystem.File;

				// XML
				file = flash.filesystem.File.applicationDirectory.resolvePath(path + name + ".mp3");
				if (!file.exists)
				{
					file = flash.filesystem.File.applicationStorageDirectory.resolvePath(path + name + ".mp3");
					if (!file.exists) throw new Error("File is not available: " + file.url);
				}
				_loaderMax.append(new MP3Loader(file.url, {name:name, autoPlay:false}));
				return;
			}

			_loaderMax.append(new MP3Loader(path + name + ".mp3", {name:name, autoPlay:false}));
			trace("preloadAudio", name);
		}

		/**
		 * Load all the prloaded assets. If this is running on mobile it does nothing as the files are already loaded.
		 */
		public function load():void
		{
			if (!_localLoad) _loaderMax.load();
		}

		/**
		 * Returns a texture
		 * @param	name
		 * @return
		 */
		public function getTexture(name:String, mipmaps:Boolean = false):Texture
		{
			var textureName:String = String(name + TEXTURE).toLowerCase();
			if (loadedDict[textureName] != undefined)
			{
				if (texturesDict[textureName] == undefined)
				{
					trace("[Assets] New texture created:", textureName);
					var bitmap:Bitmap = loadedDict[textureName];
					var texture:Texture = Texture.fromBitmap(bitmap, mipmaps, false, _scaleFactor);
					texturesDict[textureName] = texture;
				}
				return texturesDict[textureName];
			}
			else throw new Error("Resource not defined: " + textureName);
		}

		/**
		 * Returns a texture atlas.
		 * @param	nameTexture
		 * @param	nameData
		 * @return
		 */
		public function getTextureAtlas(name:String, mipmaps:Boolean = false):TextureAtlas
		{
			var textureName:String = String(name + TEXTURE).toLowerCase();
			var dataName:String = String(name + DATA).toLowerCase();
			if (loadedDict[textureName] != undefined)
			{
				if (textureAtlasDict[textureName] == undefined)
				{
					var texture:Texture = getTexture(name, mipmaps);
					var data:XML = loadedDict[dataName];
					var textureAtlas:TextureAtlas = new TextureAtlas(texture, data);
					textureAtlasDict[textureName] = textureAtlas;
				}
				return textureAtlasDict[textureName];
			}
			else throw new Error("Resource name is not defined: " + name);
		}

		/**
		 * Registers the font with the with the Starling Textfield. Note: The font must be preloaded first.
		 * @param	name	:String The name of the font that was "preloaded".
		 * @param	name	:int The font size, used for the name.
		 * @param refLabel :String the reference you will use for this font.
		 */
		public function registerFont(name:String, size:int, refLabel:String):void
		{
			var fontName:String = String(name + "_" + String(size * _scaleFactor) + GLYPH);
			var fontData:String = String(name + "_" + String(size * _scaleFactor) + FNT);

			if (loadedDict[fontName] != undefined)
			{
				var font:Texture = Texture.fromBitmap(loadedDict[fontName]);
				fontsDict[refLabel] = new BitmapFont(font, loadedDict[fontData]);
				TextField.registerBitmapFont(fontsDict[refLabel], refLabel);
				// trace("REGISTERED Font:", fontsDict[refLabel], refLabel);
			}
		}

		/**
		 * Returns a bitmap data
		 */
		public function getBitmapFont(fontRef:String):BitmapFont
		{
			if (!fontsDict[fontRef])
				throw Error(new Error("The bitmap font does not exist:", fontRef));
			else
				return fontsDict[fontRef];
		}

		/**
		 * Returns a bitmap data
		 */
		public function getBitmapData(name:String):BitmapData
		{
			if (loadedDict[name] != undefined)
			{
				var bitmap:Bitmap = loadedDict[name];
				var bitmapData:BitmapData = bitmap.bitmapData;
				return bitmapData;
			}
			else throw new Error("Resource name is not defined: " + name);
		}

		/**
		 * Returns a sound.
		 */
		public function getAudio(name:String):Sound
		{
			return loadedAudioDict[name];
		}
		
		/*-------------------------------------------------
		 * PRIVATE FUNCTIONS
		-------------------------------------------------*/
		/*-------------------------------------------------
		 * EVENT HANDLING
		-------------------------------------------------*/
		/**
		 * Saves the loaded data to the 'loadedDict'.
		 */
		private function onLoadComplete(event:LoaderEvent):void
		{
			for each (var i:* in _loaderMax.getChildren())
			{
				var name:String = i.name;
				if (i is XMLLoader)
					loadedDict[name] = LoaderMax.getContent(name) as XML;
				else if (i is MP3Loader)
				{
					loadedAudioDict[name] = LoaderMax.getContent(name) as Sound;
				}
				else
					loadedDict[name] = LoaderMax.getContent(name).rawContent as Bitmap;
			}
			_loaderMax.dispose(true);
			signalComplete.dispatch();
		}

		private function onLoadError(event:LoaderEvent):void
		{
			trace(this, "error");
			signalError.dispatch();
		}

		/*-------------------------------------------------
		 * GETTERS / SETTERS
		-------------------------------------------------*/
		public function get scaleFactor():Number
		{
			return _scaleFactor;
		}

		public function set scaleFactor(scaleFactor:Number):void
		{
			if (scaleFactor < 2) scaleFactor = 1;
			else scaleFactor = 2;
			_scaleFactor = scaleFactor;
		}
	}
}