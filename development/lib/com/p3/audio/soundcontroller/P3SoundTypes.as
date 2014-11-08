package com.p3.audio.soundcontroller 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3SoundTypes
	{
		
		public static const BASIC:String = "basic";
		public static const UI_SOUND:String = "uiSound";
		public static const AMBIENT:String = "ambient";
		public static const ENVIROMENTAL:String = "enviromental";
		public static const LOCALIZED:String = "localized";
		
		public var xml:XML = 
		<data>
		<SOUNDS>
			<SOUND>
				<NAME>basic</NAME>
				<CLASS></CLASS>
				<RADIUS>250</RADIUS>
				<FALLOFF>0.4</FALLOFF>
				<MIN_VOLUME>0.05</MIN_VOLUME>
				<BASE_VOLUME>1</BASE_VOLUME>
			</SOUND>
			<SOUND>
				<NAME>uiSound</NAME>
				<CLASS></CLASS>
				<RADIUS>0</RADIUS>
				<FALLOFF>0.4</FALLOFF>
				<MIN_VOLUME>0.05</MIN_VOLUME>
				<BASE_VOLUME>1</BASE_VOLUME>
			</SOUND>
			<SOUND>
				<NAME>ambient</NAME>
				<CLASS></CLASS>
				<RADIUS>0</RADIUS>
				<FALLOFF>0.3</FALLOFF>
				<MIN_VOLUME>0.05</MIN_VOLUME>
				<BASE_VOLUME>0.5</BASE_VOLUME>
			</SOUND>
			<SOUND>
				<NAME>enviromental</NAME>
				<CLASS></CLASS>
				<GROUP></GROUP>
				<RADIUS>800</RADIUS>
				<FALLOFF>0.7</FALLOFF>
				<MIN_VOLUME>0.1</MIN_VOLUME>
				<BASE_VOLUME>0.8</BASE_VOLUME>
			</SOUND>
			<SOUND>
			<NAME>localized</NAME>
				<CLASS></CLASS>
				<GROUP></GROUP>
				<RADIUS>600</RADIUS>
				<FALLOFF>0.4</FALLOFF>
				<MIN_VOLUME>0.1</MIN_VOLUME>
				<BASE_VOLUME>0.4</BASE_VOLUME>
			</SOUND>
		</SOUNDS>
		</data>;

		public function extendSoundTypes($xml:XMLList):void
		{
			for each (var item:XML in $xml)
			{
				xml.SOUNDS.appendChild(item);
			}
		}
		
		public function getSoundType (id:String):XMLList
		{
			var ret:XMLList = xml.SOUNDS.*.(NAME == id);
			if (ret) return ret;
			else return xml.SOUNDS.*.(NAME == "basic");
		}
	}

}