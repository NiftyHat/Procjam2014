package com.p3.apis.miniclip.store 
{
	import com.hurlant.util.der.Integer;
	import com.miniclip.gamemanager.currencies.CurrencyCurrency;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipStoreCurrency 
	{
		
		internal var _code:String;
		internal var _id:int;
		internal var _name:String;
		internal var _typeId:uint;
		
		public function MiniclipStoreCurrency() 
		{
			
		}
		
		public function fromCurrency ($currency:CurrencyCurrency):void
		{
			_code = $currency.code;
			_id = $currency.id;
			_name = $currency.name;
			_typeId = $currency.typeId;
		}
		
		public function toXML():XML
		{
			var xml:XML = new XML(<CURRENCY/>);
			xml.@code = _code;
			xml.@id = _id;
			xml.@name = _name;
			xml.@typeId = _typeId;
			return xml;
		}
		
		public function fromXML($xml:XML):void {
			var xml:XML = $xml;
			_code = xml.@code;
			_id = xml.@id;
			_name = xml.@name;
			_typeId = xml.typeId;
		}
		
		public function get code():String 
		{
			return _code;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get typeId():uint 
		{
			return _typeId;
		}
		
	}

}