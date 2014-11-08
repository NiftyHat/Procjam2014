package base.components 
{
	import com.p3.loading.bundles.P3ExternalBundle;
	import com.p3.loading.bundles.P3InternalBundle;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class Library 
	{
		
		protected var m_int:P3InternalBundle;
		protected var m_ext:P3ExternalBundle;
		
		public function Library() 
		{
			m_int = new P3InternalBundle ();
			m_ext = new P3ExternalBundle ("");
		}
		
		public function getAsset($name:String):* 
		{
			if (m_int.hasAsset($name)) {
				return m_int.getAsset($name);
			}
			else if (m_ext.hasAsset($name)) {
				return m_ext.getAsset($name)
			}
			else {
				trace("can't find asset " + $name);
				return null;
			}
		}
		
		public function get int():P3InternalBundle 
		{
			return m_int;
		}
		
		public function get ext():P3ExternalBundle 
		{
			return m_ext;
		}
		
		//public function get zip():P3ZipBundle 
		//{
			//return m_zip;
		//}
		

	}

}