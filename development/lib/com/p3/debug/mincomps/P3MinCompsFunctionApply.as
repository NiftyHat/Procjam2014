 package com.p3.debug.mincomps 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.ListItem;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.ime.CompositionAttributeRange;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3MinCompsFunctionApply extends Panel
	{
		
		private var _button:PushButton;
		private var _inputs:Vector.<ComponentTypeInfo>;
		private var _functionName:String = "Sendificate"
		private var _paramNames:Array;
		private var _params:Array;
		private var _paramsObject:Object;
		private var _onSendificateCallback:Function;
		
		/**
		 * "int", "string", "bool";
		 * @param	$params
		 */
		public function P3MinCompsFunctionApply($functionName:String = "Sendificate", $paramsObject:Object = null, $cbOnSendificate:Function = null) 
		{
			super();
			_paramsObject = $paramsObject;
			_functionName = $functionName;
			_onSendificateCallback = $cbOnSendificate;
			//addEventListener(Event.COMPLETE, $cbOnSendificate);
			width = 0;
			height = 34;
			create();
		}
		
		private function create():void 
		{
			//_inputs = new Vector.<ComponentTypeInfo> ();
			_button = new PushButton (this, 2, 2, _functionName, onClickSendificate);
			_button.height = 30;
			_button.width = 150;
			setParamsObject(_paramsObject);
			
			
		}
		
		public function setParamsObject($paramsObject:Object):void 
		{
			clearInputs();
			_paramsObject = $paramsObject;
			var xPos:int = _button.width + 4; 
			var param:String;
			var paramsList:Array = new Array;
			for (param in _paramsObject)
			{
				paramsList.push(param);
			}
			paramsList.sort();
			for each (param in paramsList)
			{
				
				var paramName:String = param;
				var paramData:* = _paramsObject[param];
				var paramType:Class = Object(paramData).constructor;
				var label:Label =  new Label (this, xPos - 2, 0);
				var labelString:String = paramName;
				var newComponent:Component;
				//newItem.
				switch (paramType)
				{
					case int:
						newComponent = new NumericStepper (this, xPos, 16);
						(newComponent as NumericStepper).value = paramData;
						labelString = "int: " + labelString
						break;
					case String:
						newComponent = new InputText (this, xPos, 16, paramData);
						labelString = "String: " + labelString
						break;
					case Boolean:
						newComponent = new CheckBox (this, xPos, 16);
						newComponent.width = 80;
						(newComponent as CheckBox).selected = paramData;
						labelString = "Bool: " + labelString
						break;
					case Number:
						if (paramData < int.MAX_VALUE && paramData == int(paramData))
						{
							newComponent = new NumericStepper (this, xPos, 16);
							(newComponent as NumericStepper).value = paramData;
							labelString = "int: " + labelString
						}
						else
						{
							newComponent = new InputText (this, xPos, 16, paramData,onEditNumber); 
							labelString = "Double: " + labelString;
							
						}
						break;
					default:
						newComponent = new P3MinCompsJSONPopout (this, xPos, 14, paramData);
						newComponent.width = 140;
						//newComponent.height = 100;
						labelString = getQualifiedClassName(paramType) + ": "  + labelString;
						break;
				}
				
				label.text = labelString;
				//
				_inputs.push (new ComponentTypeInfo(newComponent, paramType, paramName));
				xPos += newComponent.width + 2;
				width = xPos;
			}
		}
		
		private function clearInputs():void 
		{
			for each (var item:ComponentTypeInfo in _inputs)
			{
				if (item.comp.parent)item.comp.parent.removeChild(item.comp);
			}
			_inputs = new Vector.<ComponentTypeInfo> ();
		}
		
		private function onEditNumber(e:Event):void 
		{
			var input:InputText = e.target as InputText;
			input.text = input.text.replace(/\D/g, "")
		}
		
		private function onClickSendificate(e:MouseEvent):void 
		{
			collectParams();
			//var event:Event = new Event(Event.COMPLETE);
			//dispatchEvent(event);
			if (_onSendificateCallback != null && _onSendificateCallback != null)
			{
				if (_onSendificateCallback.length == 1)_onSendificateCallback(this);
			else _onSendificateCallback();
			}
			
			
		}
		
		private function collectParams():void 
		{
			//_params = new Array ();
			for each (var info:ComponentTypeInfo in _inputs)
			{
				var comp:Component = info.comp;
				var paramName:String = info.paramName;
				if (comp is InputText)
				{
					if (info.type == String)
					{
						_paramsObject[paramName] = String((comp as InputText).text)
					}
					else
					{
						_paramsObject[paramName] = Number((comp as InputText).text);
					}
					
				}
				if (comp is NumericStepper)
				{
					_paramsObject[paramName] = int((comp as NumericStepper).value);
				}
				if (comp is CheckBox)
				{
					_paramsObject[paramName] = Boolean((comp as CheckBox).selected);
				}
				if (comp is P3MinCompsJSONPopout && (comp as P3MinCompsJSONPopout).data)
				{
					_paramsObject[paramName] = (comp as P3MinCompsJSONPopout).data
				}
			}
		}
		
		public function get paramsObject():Object 
		{
			return _paramsObject;
		}
		
		public function get functionName():String 
		{
			return _functionName;
		}

		
	}
	
	

}
import com.bit101.components.Component;
internal class ComponentTypeInfo
	{
		public var comp:Component;
		public var type:Class;
		public var paramName:String;
		
		public function ComponentTypeInfo ($comp:Component, $type:Class, $paramName:String)
		{
			comp = $comp;
			type = $type;
			paramName = $paramName;
		}
	}