package com.p3.apis.miniclip.store 
{
	import com.p3.apis.miniclip.MiniclipHandler;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public dynamic class MiniclipStoreProduct 
	{
		
		internal var m_id:int;
		internal var m_name:String = "";
		internal var m_type:int;
		internal var m_description:String = "";
		internal var m_enabled:int;
		internal var m_game_id:int;
		internal var m_credit_cost:int;
		internal var m_items:Vector.<MiniclipStoreItem>;
		internal var m_display_order:int;
		internal var m_metadata:String = "";
		
		public function MiniclipStoreProduct() 
		{
			
		}
		
		public function deserialize ($object:Object):void
		{
			var copy_items:Array;
			m_items = new Vector.<MiniclipStoreItem> ();
			if ($object.items)
			{
				copy_items = $object.items;
				$object.items = null;
				delete $object.items;
			}
			for (var prop:String in $object)
			{
				if (!prop != "items") 
				{
					if (this["m_" + prop] == null) 
					{
						MiniclipHandler.instance.store.logWarning("no prop " + " m_" + prop + " on MiniclipStoreProduct");
					}
					else 
					{
						this["m_" + prop] = $object[prop];
					}
					
				}
			}
			for each(var item:Object in copy_items)
			{
				var newItem:MiniclipStoreItem = new MiniclipStoreItem ();
				newItem.deserialize(item);
				m_items.push(newItem);
				
				//MiniclipHandler.instance.store.items.addItem(m_items[m_items.length-1]);
			}
		}
		
		public function get isEnabled ():Boolean
		{
			return m_enabled == 1;
		}
		
		public function get id():int 
		{
			return m_id;
		}
		
		public function get name():String 
		{
			return m_name;
		}
		
		public function get description():String 
		{
			return m_description;
		}
		
		public function get enabled():int 
		{
			return m_enabled;
		}
		
		public function get game_id():int 
		{
			return m_game_id;
		}
		
		public function get items():Vector.<MiniclipStoreItem> 
		{
			return m_items;
		}
		
		public function get credit_cost():int 
		{
			return m_credit_cost;
		}
		
		public function get metadata():String 
		{
			return m_metadata;
		}
		
		public function get type():int 
		{
			return m_type;
		}
		
		public function toXML():XML
		{
			var xml:XML = new XML (<PRODUCT></PRODUCT>);
			xml.ID.@name = m_name;
			xml.ID.@product_id = m_id;
			xml.ID.@game_id = m_game_id;
			xml.INFO.@type = m_type;
			xml.INFO.@description = m_description;
			xml.INFO.@credit_cost = m_credit_cost;
			xml.INFO.@description = m_description;
			xml.STATE.@enabled = m_enabled;
			xml.METADATA = m_metadata;
			xml.ITEMS = <ITEMS></ITEMS>;
			for each (var item:MiniclipStoreItem in m_items)
			{
				xml.ITEMS.appendChild(item.toXML());
			}
			return xml;
		}
		
		public function fromXML ($xml:XML):void
		{
			var xml:XML = $xml;
			m_name = xml.ID.@name;
			m_id = xml.ID.@product_id;
			m_game_id = xml.ID.@game_id;
			m_type = xml.INFO.@type;
			m_description = xml.INFO.@description;
			m_credit_cost = xml.INFO.@credit_cost;
			m_description = xml.INFO.@description;
			m_enabled = xml.STATE.@enabled;
			m_metadata = xml.METADATA.toString();
			for each (var item:XML in xml.ITEMS.*)
			{
				var newItem:MiniclipStoreItem = new MiniclipStoreItem ()
				newItem.fromXML(item);
				if (!m_items) m_items = new Vector.<MiniclipStoreItem>
				m_items.push(newItem);
				//MiniclipHandler.instance.store.items.addItem(newItem);
			}
		}
		
		public function toString():String
		{
			var ret:String = "[ " +m_name + " id:" + m_id + " credits:" + m_credit_cost + " ]";
			return ret;
		}
		
		public function printDebug():String 
		{
			var text:String = "";
			text += "name: " + m_name + "\n";
			text += "type:" + m_type + "\n";
			text += "id: " + m_id + "\n";
			text += "description: " + m_description + "\n";
			text += "enabled: " + m_enabled + "\n";
			text += "game_id: " + m_game_id + "\n";
			text += "items:" + m_items.length.toString() + "\n";
			text += "credit_cost: " + m_credit_cost;
			text += "m_metadata: " + m_metadata;
			return text;
		}
		
	}

}