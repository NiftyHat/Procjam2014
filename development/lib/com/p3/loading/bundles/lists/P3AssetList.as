package com.p3.loading.bundles.lists 
{
	/**
	 * And asset list is just a bunch of paths to asset resources with no referance to the data.
	 * It's inteded to be passed into libraries as lists of assets you want the library to load.
	 * Asset lists use XML as their native format.
	 * @author Duncan Saunders
	 */
	public class P3AssetList 
	{
		
		protected var m_xml:XML;

		public function P3AssetList() 
		{
			
		}
		
		public function addAsset ($path:String, $name:String = null):void
		{
			var name:String = $name;
			if (!name)
			{
				name = $path.split("/").pop();
				name = name.split(".")[0];
				//name = name.toUpperCase();
			}
			var string:String = "<" + name.toUpperCase() + " path=\"" + $path +  "\"/>"
			var newNode:XML = new XML (string);
			if (!m_xml) m_xml = new XML ("<data></data>");
			var checkNode:XML = m_xml.child(name)[0]
			if (checkNode)
			{
				trace ("warning element " + checkNode.toXMLString());
				trace ("replaced with " + newNode.toXMLString());
				checkNode = newNode;
			}
			else
			{
				m_xml.appendChild(newNode);
			}
		}
		
		public function setXML ($xml:XML):void
		{
			m_xml = $xml;
		}
		
		public function get xml():XML 
		{
			return m_xml;
		}
		
	}

}