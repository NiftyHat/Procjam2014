package com.p3.apis.miniclip.store 
{
	import com.hurlant.util.der.Integer;
	import com.miniclip.gamemanager.currencies.CurrencyPrice;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipStorePrice 
	{
		
		protected var _amount:int;
		protected var _currencyId:int;
		protected var _display:String;
		
		public function MiniclipStorePrice() 
		{
			
		}
		
		internal function fromCurrencyPrice($currencyPrice:CurrencyPrice):void
		{
			_amount = $currencyPrice.amount;
			_currencyId = $currencyPrice.currencyId;
			_display = $currencyPrice.display;
		}
		
		internal function fromXML($xml:XML):void
		{
			var xml:XML = $xml;
			_currencyId = xml.@currencyId;
			_amount = xml.@amount;
			_display = xml.@diplay;
		}
		
		internal function toXML():XML
		{
			var xml:XML = new XML("<PRICE></PRICE>")
			xml.@currencyId = _currencyId;
			xml.@amount = _amount;
			xml.@diplay = _display;
			return xml;
		}
		
		public function toString():String
		{
			var ret:String
			ret = "";
			ret += "amount: " + _amount + "\n";
			ret +=  "id: " +_currencyId + "\n";
			ret +=  "display: " +_display + "\n";
			return ret;
		}
		
		public function get amount():int 
		{
			return _amount;
		}
		
		public function get currencyId():int 
		{
			return _currencyId;
		}
		
		public function get display():String 
		{
			return _display;
		}
		
	}

}