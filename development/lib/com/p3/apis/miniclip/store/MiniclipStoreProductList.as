package com.p3.apis.miniclip.store 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipStoreProductList 
	{
		
		protected var m_items_vec:Vector.<MiniclipStoreProduct>;
		protected var m_items_dict:Dictionary;
		
		public function MiniclipStoreProductList() 
		{
			m_items_vec = new Vector.<MiniclipStoreProduct> ();
			m_items_dict = new Dictionary ();
		}
		
		internal function addProduct ($product:MiniclipStoreProduct):void
		{
			if (!$product) 
			{
				trace ("Miniclip Store WARNING: " + " null referance for product " + $product);
				return
			}
			if (hasItemAtID($product.id)) 
			{
				trace ("Miniclip Store WARNING: " + " already has product "  + $product + "aborting");
				return;
				//m_items_vec.splice(m_items_vec.indexOf(m_items_dict[$product.id]), 1);
			}
			//if (m_items_vec.length < $product.id) m_items_vec.length = $product.id
			m_items_dict[$product.id] = $product;
			m_items_vec.push($product);
		}
		
		internal function addRawProduct ($raw_data:Object):void
		{
			var id:int = $raw_data.id;
			var productAtID:MiniclipStoreProduct = getProductByID (id);
			if (productAtID)
			{
				productAtID.deserialize($raw_data);
			}
			else
			{
				var newProduct:MiniclipStoreProduct = new MiniclipStoreProduct ()
				newProduct.deserialize($raw_data);
				addProduct(newProduct);
			}
		}
		
		public function getProductByID ($id:int):MiniclipStoreProduct
		{
			if (!hasItemAtID($id)) 
			{
				trace ("Miniclip Store WARNING: " + " no product at id: " + $id);
				return null;
			}
			return m_items_dict[$id];
		}
		
		public function getAllProducts ():Vector.<MiniclipStoreProduct>
		{
			return m_items_vec;
		}
		
		public function hasItemAtID ($id:int):Boolean
		{
			return m_items_dict[$id] != null && m_items_dict[$id] != undefined;
		}
		
		

	}

}