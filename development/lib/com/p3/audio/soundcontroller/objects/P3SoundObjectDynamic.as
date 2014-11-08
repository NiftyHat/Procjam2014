package com.p3.audio.soundcontroller.objects 
{
	import com.p3.audio.soundcontroller.IP3SoundObject;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3SoundObjectDynamic extends P3SoundObject implements IP3SoundObject
	{
			
		public var location:Point;
		public var radius:uint = 300; //distance the sound travels untill falloff. (radius 0 means play everywhere)
		public var falloff:Number = 0.5; // percentage of radius where sound starts to fade.
		public var min_volume:Number = 0.1 // lowest point before the sound in auto-muted rather than being played.
		public var overrides:Boolean = false;
		public var base_volume:int;
		
		private var sqrt:Function = Math.sqrt;
		
		public function P3SoundObjectDynamic() 
		{

		}
		
		public function adjustVolumeForDistance ($camera:Point):void
		{
			if ($camera == null) return;
			if (channel == null) return;
			if (muted) 
			{
				if (channel) channel.soundTransform = new SoundTransform(0);
				return;
			}
			var dist:int = getDistance($camera, location);
			dist = sqrt(dist);
			if (dist > radius) 
			{
				if (volume > 0)
				{
					volume = 0;
					channel.soundTransform = new SoundTransform(volume);
				}
				
				return;
			}
			else
			{
				if (dist > fadepoint) 
				{	
				volume = 1 - (1 / (radius - fadepoint)) * (dist - fadepoint);
				if (volume < 0) volume = 0;
				if (channel)
				{
					if (volume < min_volume) volume = 0;
					channel.soundTransform = new SoundTransform(volume);
				}
				}
				else
				{
					volume = 1;
					channel.soundTransform = new SoundTransform(volume);
				}
			}
			/*
			*/
		}
		
		override public function setVolume ($value:Number):void
		{
			if (channel) channel.soundTransform = new SoundTransform ($value)
			volume = $value;
			
		}
				
		private function getDistance($p1:Point, $p2:Point):int 
		{
			var x_dist:int = ($p1.x - $p2.x) * ($p1.x - $p2.x);
			var y_dist:int =  ($p1.y - $p2.y) *  ($p1.y - $p2.y);
			return x_dist + y_dist;
		}
		
		public function get fadepoint():int
		{
			return radius - (radius * falloff);
		}
		

		
	}

}