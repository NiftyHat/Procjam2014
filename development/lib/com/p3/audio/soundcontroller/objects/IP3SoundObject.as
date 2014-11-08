package com.p3.audio.soundcontroller.objects 
{
	import flash.media.SoundChannel;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public interface IP3SoundObject 
	{
		function play ($force_restart:Boolean = false):SoundChannel;
		function stop ():void;
		function pause ():void
		function resume ():void;
		function update ():void;
		function mute ():void;
		function unmute ():void;
		function fadeOut (time:Number = 1, $callback:Function = null, $autoDestroy:Boolean = true):void
		function fadeIn (time:Number = 1, $callback:Function = null):void
		function destroy ():void
		function setVolume ($value:Number):void
	}
	
}