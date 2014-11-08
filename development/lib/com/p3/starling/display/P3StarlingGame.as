
/**
 * A base class that all Starling games can implement to start up.
 * @author Adam H.
 */
package com.p3.starling.display
{
	import starling.core.Starling;
	import starling.display.BlendMode;

	import com.p3.starling.loading.P3StarlingAssets;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
//	CONFIG::ANDROID
//	{
//	}
//	
//	CONFIG::IOS
//	{
//	}
	

	public class P3StarlingGame extends Sprite
	{
		protected var _starling:Starling;
		protected var _renderMode:String ;
		protected var _multiTouch:Boolean;
		protected var _handleLostContext:Boolean;
		protected var _enableErrorChecking:Boolean;
		protected var _defaultBlendMode:String;
		protected var _antiAliasing:Number;
		protected var _showFpsCounter:Boolean;
		protected var _viewport:Rectangle;
		protected var _isPortrait:Boolean;
		protected var _aspectRatio:Number=1;
		protected var _isLetterBox:Boolean;
		// BASE WIDTH is the stage with (480,320) that STARLING is set and its corordinates.
		protected var _baseWidth:int;
		protected var _baseHeight:int;
		// SCREEN WIDTH/HEIGHT is the dimension of the screen and what the VIEWPORT is set to.
		protected var screenWidth:int;
		protected var screenHeight:int;
		private var _scaleFactor : Number;

		/*-------------------------------------------------
		 * PUBLIC CONSTRUCTOR
		-------------------------------------------------*/
		public function P3StarlingGame()
		{			
			_renderMode = Context3DRenderMode.AUTO;
			// Context3DRenderMode.SOFTWARE.
			_defaultBlendMode = BlendMode.NONE;
			_antiAliasing = 1;

			addEventListener(Event.ADDED_TO_STAGE, added);
		}


		/*-------------------------------------------------
		 * PUBLIC FUNCTIONS
		-------------------------------------------------*/		

		/**
		 * Check to see if the game is running in portrait mode.
		 */
		protected function initScreenSize():void
		{
			stage.quality 	= StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align 	= StageAlign.TOP_LEFT;
			
			screenWidth = stage.stageWidth;
			screenHeight = stage.stageHeight;
			
			// I have turned these off becaise they pic up the MONITOR resolution when running in the simulator.
			CONFIG::MOBILE
			{
				screenWidth = stage.fullScreenWidth;
				screenHeight = stage.fullScreenHeight;
			}				
				
			_baseWidth 	= 320;
			_baseHeight = 480;			
			
			var tempBaseWidth:int = _baseWidth;
			var tempBaseHeight:int = _baseHeight;
			
			var isiPad:Boolean;
			_isPortrait = ( screenWidth < screenHeight) ? true:false;
			
			if (_isPortrait)
			{
				_baseWidth = Math.min(tempBaseHeight, tempBaseWidth);
				_baseHeight = Math.max(tempBaseHeight, tempBaseWidth);
				isiPad = (screenWidth == 768 || screenWidth == 1536);
			}
			else
			{
				_baseWidth = Math.max(tempBaseHeight, tempBaseWidth);
				_baseHeight = Math.min(tempBaseHeight, tempBaseWidth);
				isiPad = (screenHeight == 768 || screenHeight == 1536);
			}
			_aspectRatio = Math.min(_baseHeight, _baseWidth) / Math.max(_baseHeight, _baseWidth);
			
			_baseWidth = isiPad ? 512:480;
			_baseHeight = isiPad ? 384:320;			
			
			_viewport = new Rectangle(0, 0, screenWidth, screenHeight);
			
			if (_isPortrait)
				_scaleFactor = _viewport.height / _baseHeight;
			else
				_scaleFactor = _viewport.width / _baseWidth;
				
			P3StarlingAssets.inst.scaleFactor = _scaleFactor;
		}


		public function createLetterboxViewport():void
		{
			_isLetterBox = true;
			if (_isPortrait)
			{				
				_viewport.x = int(_baseWidth-480);				
				_baseWidth = 480;
				_viewport.width = _baseWidth*_scaleFactor;

			}
			else
			{
				_viewport.y =int(_baseHeight-320);				
				_baseHeight = 320;
				_viewport.height = _baseHeight*_scaleFactor;
			}
		}

		protected function startGame(gameClass:Class):void
		{
			Starling.multitouchEnabled = _multiTouch;
			// useful on mobile devices
			Starling.handleLostContext = _handleLostContext; // if false the bitmap will be disposed of from ram and kept in GPU.
			// not necessary on iOS. Saves a lot of memory!

			_starling = new Starling(gameClass, this.stage, _viewport, null, _renderMode);
			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onStarlingReady);

			stage.addEventListener(flash.events.Event.RESIZE, onResize, false, 0, true);

			if (_showFpsCounter)
			{
				Starling.current.showStats = true;
			}

			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			CONFIG::MOBILE
			{
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,          function (e:Event):void { _starling.start(); });            
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,        function (e:Event):void { _starling.stop(); });
			}			
		}


		 private function createStartupImage(viewPort:Rectangle, isHD:Boolean):void
		 {
		/*
		var sprite:Sprite = new Sprite();
            
		var background:Bitmap = isHD ?
		new AssetEmbeds_2x.Background() : new AssetEmbeds_1x.Background();
            
		var loadingIndicator:Bitmap = isHD ?
		new AssetEmbeds_2x.Loading() : new AssetEmbeds_1x.Loading();
            
		background.smoothing = true;
		sprite.addChild(background);
            
		loadingIndicator.smoothing = true;
		loadingIndicator.x = (background.width - loadingIndicator.width) / 2;
		loadingIndicator.y =  background.height * 0.75;
		sprite.addChild(loadingIndicator);
            
		sprite.x = viewPort.x;
		sprite.y = viewPort.y;
		sprite.width  = viewPort.width;
		sprite.height = viewPort.height;
            
		return sprite;

		 */
		}
		
		
		/*-------------------------------------------------
		 * PRIVATE FUNCTIONS
		-------------------------------------------------*/
		
		
		
		/*-------------------------------------------------
		 * EVENT HANDLING
		-------------------------------------------------*/
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);

			initScreenSize();
			if (_isLetterBox) 
				createLetterboxViewport();
		}


		private function onStarlingReady(event:Event):void
		{
			_starling.stage.stageWidth = _baseWidth;
			_starling.stage.stageHeight = _baseHeight;

			Starling.current.start();

			trace(this, "STARLING STAGE:", _starling.stage.stageWidth, _starling.stage.stageHeight, _starling.contentScaleFactor, Starling.current.context.driverInfo);
		}

		private function onResize(e:flash.events.Event):void
		{
			updateViewport(stage.stageWidth, stage.stageHeight);
		}


		private static function updateViewport($width:Number, $height:Number):void
		{
			/*
			var stage:starling.display.Stage = Starling.current.stage;
			Starling.current.viewPort = new Rectangle( 0, 0, $width, $height );
			
			trace("scale",scale);
			
			if ( !_isLetterboxed )
			{
			var scale:Number = Math.max(( $width / _baseWidth ), ( $height / _baseHeight ));
				
			_screenWidth = stage.stageWidth = ( $width / scale );
			_screenHeight = stage.stageHeight = ( $height / scale );
			_screenCenterX = stage.stageWidth * 0.5;
			_screenCenterY = stage.stageHeight * 0.5;
			}

			 */
		}
		
		
		
		
		
		
		
		
		// package
		// {
		// 
		// import flash.display.Sprite;
		// import flash.events.Event;
		// import flash.geom.Rectangle;
		// 
		// import starling.core.Starling;
		// 
		// public class Main extends Sprite
		// {
		// 
		// /**
		// * The width that the app is based on, this should be the lowest width such as 320 (iphone) or 384 (ipad) 
		// */
		// public static var _baseWidth			:Number = 384;
		// /**
		// * The height that the app is based on, this should be the lowest height such as 480 (iphone) or 512 (ipad)
		// */
		// public static var _baseHeight			:Number = 512;
		// 
		// /*-------------------------------------------------
		// * PUBLIC CONSTRUCTOR
		// *-------------------------------------------------*/	
		// 
		// public function Main()
		// {
		// if ( stage ) init()
		// else addEventListener( Event.ADDED_TO_STAGE, onAddedToStageEventHandler );
		// }
		// 
		// /*-------------------------------------------------
		// * PRIVATE METHDOS
		// *-------------------------------------------------*/
		// 
		// private function init():void
		// {
		//			//  Create the viewport to pass through to starling, this uses the full screen width and height of from the Flash Stage
		// var viewport:Rectangle = new Rectangle( 0, 0, stage.fullScreenWidth, stage.fullScreenHeight );
		// 
		//			//  Create starling, passing the Root Class to be created once starling has been initialised, 
		//			//  the Flash stage and the viewport we created above
		// var starling:Starling = new Starling( StarlingRootClass, stage, viewport, null, "auto" );
		// 
		//			//  I have then added an event listener to the stage to listen for Event.Resize so that we can update the viewport
		// stage.addEventListener( Event.RESIZE, onResizeEventHandler );
		// }
		// 
		// private function updateViewport( $width:Number, $height:Number ):void
		// {
		//			//  Resize the Starling viewport with the new width and height
		// Starling.current.viewPort = new Rectangle( 0, 0, $width, $height );
		// 
		// if ( !Starling.current &amp;&amp; !Starling.current.stage ) return;
		// 
		//			//  Get the scale based on the biggest percentage between the new width and the base width or the new height and the base height 
		// var scale:Number = Math.max(( $width / _baseWidth ), ( $height / _baseHeight ));
		// 
		//			//  Resize the starling stage based on the new width and height divided by the scale
		// Starling.current.stage.stageWidth = ( $width / scale )
		// Starling.current.stage.stageHeight = ( $height / scale )
		// }
		// 
		// /*-------------------------------------------------
		// * EVENT HANDLERS
		// *-------------------------------------------------*/
		// 
		// private function onAddedToStageEventHandler( e:Event ):void
		// {
		// removeEventListener( Event.ADDED_TO_STAGE, onAddedToStageEventHandler );
		// init();
		// }
		// 
		// private function onResizeEventHandler( e:Event ):void
		// {
		// updateViewport( stage.fullScreenWidth, stage.fullScreenHeight );
		// }
		// 
		// }
		// }

	}
}
