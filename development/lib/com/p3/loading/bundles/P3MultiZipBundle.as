package com.p3.loading.bundles 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3MultiZipBundle extends P3AssetBundle 
	{
		
		protected var m_zip_dictionary:Dictionary = new Dictionary ();
		protected var m_zip_vector:Vector.<P3ZipBundle> = new Vector.<P3ZipBundle> ();
		
		public function P3MultiZipBundle() 
		{
			super();
			
		}
		
		public function addZip ($zip_bundle:P3ZipBundle):void
		{
			var hash:String  = $zip_bundle.getHash()
			var currentZip:P3ZipBundle = m_zip_dictionary[hash]
			if (currentZip)
			{
				trace("P3MultiZipBundle ERROR - hash collision " + hash);
				return;
			}
			trace("P3MultiZipBundle - adding new data with hash " + hash);
			m_zip_vector.push($zip_bundle);
			m_zip_dictionary[hash] = $zip_bundle;
		}
		
		override public function getAsset($path:String):* 
		{
			for each (var bundle:P3ZipBundle in m_zip_vector)
			{
				if (bundle.hasAsset($path)) return bundle.getAsset($path);
			}
		}
		
		override public function hasAsset($path:String):Boolean 
		{
			for each (var bundle:P3ZipBundle in m_zip_vector)
			{
				if (bundle.hasAsset($path)) return true;
			}
			return false;
		}
		
	}

}