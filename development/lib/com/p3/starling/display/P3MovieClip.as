
/**
 * ...
 * @author Adam H
 * TODO - set the default frame - currently does not display anthing unless an animation is told to play.
 */
package com.p3.starling.display
{
	import starling.display.Stage;
	import flash.utils.Dictionary;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;


	public class P3MovieClip extends Sprite
	{
		private var _juggler:Juggler;
		private var _animations:Dictionary;
		private var _currAnimation:MovieClip;
		private var _currFrame:int;
		private var _width:int;
		private var _height:int;
		public var _currFrameLabel:String;

		/*-------------------------------------------------
		 * PUBLIC CONSTRUCTOR
		-------------------------------------------------*/
		public function P3MovieClip(juggler:Juggler)
		{
			_juggler = (juggler ? juggler:Starling.juggler);
			_animations = new Dictionary();
			_currFrame = 0;
			_width = 0;
			_height = 0;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}


		/*-------------------------------------------------
		 * PUBLIC FUNCTIONS
		-------------------------------------------------*/
		public function addAnimation(animationName:String, frames:Vector.<Texture>, fps:int=15, loop:Boolean=true, currentFrame:int=0, autoPlay:Boolean = true):MovieClip
		{
			if (frames.length <= 0) trace("WARNING: MovieClip2.addAnimation(): Frame vector needs to contain frames.");

			var animation:MovieClip=new MovieClip(frames, fps);
			animation.loop = loop;
			animation.currentFrame = currentFrame;
			animation.smoothing = TextureSmoothing.BILINEAR;
			animation.addEventListener(Event.COMPLETE, onAnimationComplete);
			_animations[animationName] = animation;
			_currAnimation = animation;			

			if (_width < animation.width) _width = animation.width;
			if (_height < animation.height) _height = animation.height;

			return _currAnimation;
		}


		public function gotoAndPlay(animationName:String):MovieClip
		{
			// TODO - HACK, this should not be called if animations does not exist.
			if (_animations && _animations[animationName])
			{
				if (_currAnimation)
				{
					if (_currAnimation == _animations[animationName])
					{
						_currAnimation.stop();
						_currAnimation.currentFrame = 0;
						_currAnimation.play();
						return _currAnimation;
					}
					else
					{
						_juggler.remove(_currAnimation);
						removeChild(_currAnimation);
						_currAnimation = null;
					}
				}

				_currAnimation = _animations[animationName];
				_currAnimation.currentFrame = 0;
				_currFrameLabel = animationName;
				addChild(_currAnimation);
				_juggler.add(_currAnimation);

				_currAnimation.play();
				return _currAnimation;
			}
			return(null);
		}


		override public function dispose():void
		{
			_animations = new Dictionary();
			_animations = null;

			if (_currAnimation)
			{
				_currAnimation.dispose();
				_currAnimation = null;
			}
			super.dispose();
		}


		/*
		public function play():void
		{
		if(_currAnimation)
		{
		addChild(_currAnimation);
		_currAnimation.play();
		}
		}

		public function pause():void
		{
		if(_currAnimation)
		{
		_currAnimation.pause();
		}
		}

		public function stop():void
		{
		if(_currAnimation)
		{
		_currAnimation.pause();
		}
		}
		 */
		/*-------------------------------------------------
		 * PRIVATE FUNCTIONS
		-------------------------------------------------*/
		/*-------------------------------------------------
		 * EVENT HANDLING
		-------------------------------------------------*/
		/**
		 * If you have specified animations, this will automatically play the last one.
		 * */
		private function onAddedToStage(event:Event):void
		{
			if (_currAnimation && !this.contains(_currAnimation))
			{
				addChild(_currAnimation);
				_juggler.add(_currAnimation);
				_currAnimation.play();
			}
		}


		private function onAnimationComplete(event:Event):void
		{
			dispatchEvent(event);
		}


		/*-------------------------------------------------
		 * GETTERS / SETTERS
		-------------------------------------------------*/
		public function get juggler():Juggler
		{
			return _juggler;
		}


		public function set currentFrame(currentFrame:int):void
		{
			_currFrame = currentFrame;
		}


		public function get currentFrame():int
		{
			return _currFrame;
		}


		public function set currentFrameLabel(currentFrameLabel:String):void
		{
			_currFrameLabel = currentFrameLabel;
		}


		public function get currentFrameLabel():String
		{
			return _currFrameLabel;
		}


		override public function get width():Number
		{
			return _width;
		}


		override public function get height():Number
		{
			return _height;
		}
	}
}