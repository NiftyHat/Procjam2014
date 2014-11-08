package axengine.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxLibraryEvent extends Event 
	{
		static public const BUNDLE_LOADED:String = "bundleLoaded";
		static public const ASSET_LOADED:String = "assetLoaded";
		
		protected var m_asset:*
		
		public function AxLibraryEvent($type:String, $asset:*) 
		{ 
			super($type, false, false);
		} 
		
		public override function clone():Event 
		{ 
			return new AxLibraryEvent(type, m_asset);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LibraryEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get asset():* { return m_asset; }
		
	}
	
}