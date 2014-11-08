package com.p3.apis.miniclip.store 
{
	import com.miniclip.gamemanager.currencies.CurrencyItem;
	import com.miniclip.gamemanager.currencies.CurrencyPrice;
	import com.p3.apis.miniclip.MiniclipHandler;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public dynamic class MiniclipStoreItem 
	{
		
		
		internal var m_id:int;
		internal var m_name:String = "";
		internal var m_description:String = "";
		internal var m_catagory:String = "";
		internal var m_enabled:int;
		internal var m_qty:int;
		internal var m_type:String = "";
		internal var m_max_qty:int;
		internal var m_item_code:String;
		
		internal var _prices:Vector.<MiniclipStorePrice>
		
		public function MiniclipStoreItem() 
		{
			
		}
		
		public function fromCurrencyItem($currencyItem:CurrencyItem):void
		{
			
			m_name = $currencyItem.name;
			m_id = $currencyItem.id;
			m_description = $currencyItem.description; 
			m_max_qty = $currencyItem.max_allowed;
			//m_qty = $currencyItem.quantity;
			m_catagory = $currencyItem.category
			m_type = $currencyItem.type;
			m_item_code = $currencyItem.item_code;
			_prices = new Vector.<MiniclipStorePrice>();
			for each (var currencyPrice:CurrencyPrice in $currencyItem.prices)
			{
				var newPrice:MiniclipStorePrice = new MiniclipStorePrice ();
				newPrice.fromCurrencyPrice(currencyPrice);
				_prices.push(newPrice);
			}
			//m_game_id = $currencyItem.gam
			//m_enabled = $currencyItem
		}
		
				
		public function fromXML ($xml:XML):void
		{
			
			var xml:XML = $xml;
			
			m_name = 		xml.ID.@name;
			m_id =			xml.ID.@id;
			
			m_qty = 		xml.COUNT.@quantity
			m_max_qty = 	xml.COUNT.@max_quantity;
			
			m_type = 		xml.INFO.@type;
			m_description = xml.INFO.@description;
			m_item_code =	xml.INFO.@item_code;
			m_catagory = xml.INFO.@catagory
			
			m_enabled = 	xml.STATE.@enabled;
			
			_prices = new Vector.<MiniclipStorePrice>();
			for each (var price:XML in xml.PRICE)
			{
				
				var newPrice:MiniclipStorePrice = new MiniclipStorePrice ();
				newPrice.fromXML(price);
				_prices.push(newPrice);
			}
		}
		
		public function fromObject ($object:Object):void
		{
			for (var prop:String in $object)
			{
				if ((this as Object).hasOwnProperty(prop))
				{
					if (this["m_" + prop] == null) 
					{
						MiniclipHandler.instance.store.logWarning("no prop " + " m_" + prop + " on MiniclipStoreItem");
					}
					else 
					{
						this["m_" + prop] = $object[prop];
					}
				}
				
			}
		}
		
				
		public function toXML():XML
		{
			var xml:XML = new XML (<ITEM></ITEM>);
			
			xml.ID.@name = m_name;
			xml.ID.@id = m_id;
			
			xml.COUNT.@max_quantity = m_max_qty;
			
			xml.INFO.@type = m_type;
			xml.INFO.@description = m_description;
			xml.INFO.@item_code = m_item_code;
			xml.INFO.@catagory = m_catagory;
			
			xml.STATE.@enabled = m_enabled;
			for each (var price:MiniclipStorePrice in _prices)
			{
				xml.appendChild(price.toXML());
			}
			return xml;
		}

		public function isMax ():Boolean
		{
			return m_qty < m_max_qty;
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
		
		public function get qty():int 
		{
			return m_qty;
		}
		
		public function get max_qty():int 
		{
			return m_max_qty;
		}
		

		
		public function get id():int 
		{
			return m_id;
		}
		
		public function set qty(value:int):void 
		{
			m_qty = value;
		}
		
		public function get type():String 
		{
			return m_type;
		}
		
		public function get item_code():String 
		{
			return m_item_code;
		}

		public function get credit_cost():Number
		{
			if (_prices && _prices.length > 0)
			{
				return _prices[0].amount;
			}
			return 0;
		}
		
		public function get catagory():String 
		{
			return m_catagory;
		}
		
		public function toString ():String
		{
			return printDebug();
		}
		
		public function printDebug():String 
		{
			var text:String = "";
			text += "name: " + m_name + "\n";
			text += "id: " + m_id + "\n";
			text += "quantity: " + m_qty + "\n";
			text += "max_quantity: " + m_max_qty + "\n";
			text += "description: " + m_description + "\n";
			text += "enabled: " + m_enabled + "\n";
			text += "type: " + m_type + "\n";
			//text += "prices "  + _prices;
			for each (var price:MiniclipStorePrice in _prices)
			{
				var curr:MiniclipStoreCurrency =  MiniclipHandler.instance.store.getCurrency(price.currencyId);
				if (curr) text += "cost " + curr.name +  ": " + price.display + "\n";
				else text += "cost " + price.currencyId +  ": " + price.display + "\n";
			}
			return text;
		}
		
	}

}