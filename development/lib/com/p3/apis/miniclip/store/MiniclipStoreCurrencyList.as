package com.p3.apis.miniclip.store 
{
	import com.miniclip.gamemanager.currencies.CurrencyCurrency;
	import com.p3.apis.miniclip.MiniclipHandler;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class MiniclipStoreCurrencyList 
	{
		
		protected var _currencies_vec:Vector.<MiniclipStoreCurrency>;
		
		public function MiniclipStoreCurrencyList() 
		{
			_currencies_vec = new Vector.<MiniclipStoreCurrency> ();
		}
		
		internal function addRawCurrency ($currency:CurrencyCurrency):void
		{
			var newCurrency:MiniclipStoreCurrency = new MiniclipStoreCurrency ();
			newCurrency.fromCurrency($currency);
			addCurrency(newCurrency);
		}
		
		internal function addCurrency ($currency:MiniclipStoreCurrency):void
		{
			if ($currency.id >= _currencies_vec.length)
			{
				_currencies_vec.length = $currency.id;
			}
			if (hasItemAtID($currency.id)) 
			{
				var targetCurrency:MiniclipStoreCurrency = getCurrencyByID($currency.id);
				MiniclipHandler.instance.store.logWarning("already has currency with id " + targetCurrency.id + " called " + targetCurrency.name);
			}
			_currencies_vec[$currency.id] = $currency;
		}
		
		public function getCurrencyByID ($id:int):MiniclipStoreCurrency
		{
			if (!hasItemAtID($id)) 
			{
				return null;
			}
			return _currencies_vec[$id];
		}
		
		public function getAllItems ():Vector.<MiniclipStoreCurrency>
		{
			return _currencies_vec;
		}

		public function hasItemAtID ($id:int):Boolean
		{
			if ($id >= _currencies_vec.length -1) return false;
			return _currencies_vec[$id];
		}
		
	}

}