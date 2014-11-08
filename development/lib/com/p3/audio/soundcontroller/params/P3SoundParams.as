package com.p3.audio.soundcontroller.params 
{
	import com.p3.audio.soundcontroller.objects.P3SoundObject;
	import com.p3.audio.soundcontroller.P3SoundController;
	import flash.media.SoundLoaderContext;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public dynamic class P3SoundParams 
	{
		
		//target group
		public var group:String = P3SoundController.SG_SOUNDS;
		//volume to play sound at
		public var volume:Number = 1.0;
		// number of time to loop the sound. -1 is loop forever
		public var loops:int = 0;
		// time in seconds to fade the sound in.
		public var fadeIn:Number = 0;
		// Not really used thing. Ignore this, nothing to see here.
		public var fadeOut:Number = 0;
		// Time to delay the start of the sound in seconds.
		public var delay:Number = 0;
		// Offset for the playhead from the start of the sound.
		public var startTime:Number = 0;
		// Class of the sound object to fabricate. Must extend P3SoundObject.
		public var typeCast:Class = P3SoundObject;
		// Pan offset for the sound, between -1.0 and 1.0
		public var pan:Number = 0;
		// function to call when the sound completes
		public var onCompleteCallback:Function;
		// parameters to parse to the oncomplete function. Will probably break if you reuse the ParamsObject.
		public var onCompleteParams:Array;
		// bool, true if you don't want the sound to play as soon as you make it.
		public var manualPlay:Boolean = false;
		// bool, true if you don't want the sound to destroy itself when the sound is complete.
		public var manualDestroy:Boolean = false;
		//string url of a sound to stream in.
		public var url:String = "";
		//context, optional param to provider loader context for the sound loader if you are doing some wacky cross domain stuff.
		public var context:SoundLoaderContext;
		
		public function P3SoundParams() 
		{
			
		}
		
	}

}