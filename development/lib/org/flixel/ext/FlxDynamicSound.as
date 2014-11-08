package org.flixel.ext 
{
	import flash.events.Event;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class FlxDynamicSound extends FlxSound
	{
		
		private var m_cbOnComplete:Function;
		private var m_cbOnCompleteArgs:Array;
		private var _camera:FlxCamera;
		
		public function FlxDynamicSound() 
		{
			
		}
		
		override public function play(ForceRestart:Boolean = false):void 
		{
			FlxG.sounds.add(this);
			super.play(ForceRestart);
		}
		
		public function setCBOnComplete ($function:Function, $args:Array = null):void
		{
			m_cbOnComplete = $function;
			m_cbOnCompleteArgs = $args;
		}
		
		override protected function stopped(event:Event = null):void 
		{
			if (m_cbOnComplete != null) m_cbOnComplete.call(m_cbOnCompleteArgs);
			super.stopped(event);
		}
		
		public function proxyCamera (Target:FlxObject,Radius:Number,Pan:Boolean=true, Camera:FlxCamera =null):void
		{
			_target = Target;
			_camera = Camera;
			_camera = FlxG.camera;
			_radius = Radius;
			_pan = Pan;
			update();
			updateTransform();
		}
		
		//override public function play(ForceRestart:Boolean = false):void 
		//{
			//FlxG.sounds.add(this);
			//super.play(ForceRestart);
		//}
		
		override public function destroy():void 
		{
			super.destroy();
			_camera = null;
		}
		
		override public function update():void 
		{
			var radial:Number = 1.0;
			var fade:Number = 1.0;
			if(_camera != null)
			{
				var cam_point:FlxPoint = new FlxPoint (_camera.scroll.x + (FlxG.width * 0.5), _camera.scroll.y + (FlxG.height * 0.5))
				if (_target)radial = _radius / FlxU.getDistance(cam_point, new FlxPoint(_target.x + _target.width * 0.5, _target.y  + _target.height * 0.5));
				else (radial = 0);
				//trace(cam_point.x, cam_point.y);
				//trace(_target.x + _target.width * 0.5, _target.y  + _target.height * 0.5);
				//trace("radial " + radial);
				if(radial < 0.1) radial = 0;
				if(radial > 1) radial = 1;
				if(_pan)
				{
					var d:Number = (_camera.scroll.x-_target.x)/_radius;
					if(d < -1) d = -1;
					else if(d > 1) d = 1;
					_transform.pan = d;
				}
			}
			if(_fadeOutTimer > 0)
			{
				_fadeOutTimer -= FlxG.elapsed;
				if(_fadeOutTimer <= 0)
				{
					if(_pauseOnFadeOut)
						pause();
					else
						stop();
				}
				fade = _fadeOutTimer/_fadeOutTotal;
				if(fade < 0) fade = 0;
			}
			else if(_fadeInTimer > 0)
			{
				_fadeInTimer -= FlxG.elapsed;
				fade = _fadeInTimer/_fadeInTotal;
				if(fade < 0) fade = 0;
				fade = 1 - fade;
			}
			
			_volumeAdjust = radial*fade;
			updateTransform();
			
			if((_transform.volume > 0) && (_channel != null))
			{
				amplitudeLeft = _channel.leftPeak/_transform.volume;
				amplitudeRight = _channel.rightPeak/_transform.volume;
				amplitude = (amplitudeLeft+amplitudeRight)*0.5;
			}
		}
		
		/**
		 * Call after adjusting the volume to update the sound channel's settings.
		 */
		internal function updateTransform():void
		{
			_transform.volume = (FlxG.mute?0:1)*FlxG.volume*_volume*_volumeAdjust;
			if(_channel != null)
				_channel.soundTransform = _transform;
		}
		
	}

}