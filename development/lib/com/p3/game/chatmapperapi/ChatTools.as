/**
 * ChatTools.
 * This class contains a couple of STATIC methods that the CHatMapper uses.
 * It tests the ChatNodes for their conditions and parses (some of) the chatmapper
 * scripts.
 * 
 * Its all pretty ugly in here. A few regEx for filtering. Could be much nicer (someday).
 * 
 * TODO: Chatmapper ChatTools.
 * - Items still that do nothing - ACTORS, RELATIONSHIPS
 * - Implement Location based conditions and scripts.
 * - Implement "Passthrough" and "Block" for dialogues.
 * - Implement "Mutual Status" scripts
 * - Implement "Relationships".
 * - Proper Scripting. 1 to 1 with chat mapper.
 * 
 * @author Adam
 * @version 00.00.01.
 * @date: 03.05.12.
 */

package com.p3.game.chatmapperapi 
{
	
	public class ChatTools 
	{
		
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/
		
		public function ChatTools() 
		{
			
		}
		
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
		
		/**
		 * Tests the condition string to see if the nodes conditions have been met. Is so retruns true else returns false.
		 * @param	conditionsString
		 * @param	id
		 */
		static public function testConditions(node:ChatNode):Boolean
		{		
			var rawConditionsString:String = node.xml.ConditionsString.toString();	
			rawConditionsString = replaceOperators(rawConditionsString);
			
			var conditionsArr:Array = rawConditionsString.split("and ");
			
			if (conditionsArr.length > 0)
			{
				// ----------------------------
				//1. First collect conditions.
				// ----------------------------
				var dialogNotToBeDisplyedArr:Array = [];
				var dialogWasToBeDisplyedArr:Array = [];
				var itemConditionsArr		:Array = [];
				var uservarConditionsArr	:Array = [];
				
				for (var i:int = 0; i < conditionsArr.length; i++) 
				{					
					var conditionStr:String = conditionsArr[i];
					conditionStr = conditionStr.replace(/^\s*|\s*$/g, "");
					
					var rxDialog	:RegExp = /Dialog/g;
					var rxVariable	:RegExp = /Variable/g;
					var rxItem		:RegExp = /Item/g;
					
					
					// Test for a DIALOGUE condition.
					if (rxDialog.test(conditionStr))
					{
						var rxDialogID			:RegExp = /\d{1,9999}/g
						var rxNodeNotDisplayed	:RegExp = /\bDialog\b.*isNotEqualTo/gi;
						var rxNodeWasDisplayed	:RegExp = /\bDialog\b.*isEqualTo/gi;						
						var dialogID:int = int(conditionStr.match(rxDialogID)[0]);						
						
						if (rxNodeNotDisplayed.test(conditionStr))
							dialogNotToBeDisplyedArr.push(dialogID);
						
						if (rxNodeWasDisplayed.test(conditionStr))
							dialogWasToBeDisplyedArr.push(dialogID);
					}
					
					// Test for an ITEM condition.
					if (rxItem.test(conditionStr))
					{
						var rxItemName				:RegExp = /".*?"/g;// need to cut first +last character
						var rxItemVariable			:RegExp = /\..*?\s/g; // need to cut first +last character
						var rxItemOpperator			:RegExp = /\s\w+/; // need to cut first +last character
						var rxItemValue				:RegExp = /\s+\S*$/g;
						
						var itemName:String = String(conditionStr.match(rxItemName)[0]);
						itemName = itemName.substr(1, itemName.length - 2);		
						
						var itemVariable:String = String(conditionStr.match(rxItemVariable)[0])
						itemVariable = itemVariable.substr(1, itemVariable.length - 2);
						
						var itemOperator:String = String(conditionStr.match(rxItemOpperator)[0])
						itemOperator = itemOperator.substr(1, itemName.length - 1)
						
						var itemValue:String = String(conditionStr.match(rxItemValue)[0])
						itemValue = itemValue.substr(1, itemValue.length - 1);
						
						var itemObject:ScriptObject =  new ScriptObject();
						itemObject.name  	= itemName;
						itemObject.variable	= itemVariable;
						itemObject.operator	= itemOperator;
						itemObject.value	= itemValue;
						itemConditionsArr.push(itemObject);
						trace("Item:", itemObject);
					}
					
					// Test for a VARIBLE condition.
					if (rxVariable.test(conditionStr))
					{						
						var rxVarName				:RegExp = /".*?"/g;// need to cut first +last character
						var rxVarOpperator			:RegExp = /\s\w+/; // need to cut first +last character
						var rxVarValue				:RegExp = /\s+\S*$/g;
						
						var varName:String = String(conditionStr.match(rxVarName)[0]);
						varName = varName.substr(1, varName.length - 2);		
						
						var varOperator:String = String(conditionStr.match(rxVarOpperator)[0])
						varOperator = varOperator.substr(1, varOperator.length - 1)
						
						var varValue:String = String(conditionStr.match(rxVarValue)[0])
						varValue = varValue.substr(1, varValue.length - 1);
						
						var varObject:ScriptObject = new ScriptObject();
						varObject.name  	= varName;
						varObject.operator	= varOperator;
						varObject.value		= varValue;
						uservarConditionsArr.push(varObject);
						//trace(varObject);
					}				
				}
				
				// ----------------------------
				// 2. Run through conditions and check against them.
				// ----------------------------
				var checklist:Array = [];
				var nodeID:int;
				
				// Dialalogues.
				for (i = 0; i < dialogNotToBeDisplyedArr.length; i++) 
				{
					nodeID = dialogNotToBeDisplyedArr[i];
					if (ChatMapper.inst.currentConversation.lookUpNode(nodeID).status == ChatNode.SIM_STATUS_NOT_DISPLAYED)
						checklist.push(true);
					else
						checklist.push(false);
				}
				
				for (i = 0; i < dialogWasToBeDisplyedArr.length; i++) 
				{
					nodeID = dialogWasToBeDisplyedArr[i];
					if (ChatMapper.inst.currentConversation.lookUpNode(nodeID).status == ChatNode.SIM_STATUS_WAS_DISPLAYED)
						checklist.push(true);
					else
						checklist.push(false);	
				}
				
				var rxIsNumber:RegExp = /\d/g;
				var rxIsString:RegExp = /\D/g;
				
				// Items.			
				for (i = 0; i < itemConditionsArr.length; i++) 
				{				
					var itemCondition:ScriptObject = itemConditionsArr[i];
					var item:ChatObject = ChatMapper.inst.itemDict[itemCondition.name];					
					if (item)
					{						
						// Test for a number value.
						if (rxIsNumber.test(itemCondition.value))
						{
							var itemValue_Num:Number = Number(item.fields[itemCondition.variable]);						
							var itemCondition_Num:Number = Number(itemCondition.value);	
							if (ChatTools[itemCondition.operator](itemValue_Num, itemCondition_Num))
								checklist.push(true);
							else							
								checklist.push(false);							
						}					
						
						// Test for a string value.
						if (rxIsString.test(itemCondition.value))
						{							
							var itemValue_String:String 		= String(item.fields[itemCondition.variable]).toLowerCase();						
							var itemCondition_String:String 	= String(itemCondition.value).toLowerCase();
							
							
							trace("ITEM Condition=" + "|" + itemCondition.operator +"|" + itemValue_String + "|" + itemCondition_String + "|")
							
							if (ChatTools[itemCondition.operator](itemValue_String, itemCondition_String))
								checklist.push(true);
							else							
								checklist.push(false);
						}
					}
					else
					{
						trace("Error, couldn't find item:", itemCondition.name);
					}
				}	
				
				// UserVariables.				
				for (i = 0; i < uservarConditionsArr.length; i++) 
				{						
					var uservarCondition:ScriptObject = uservarConditionsArr[i];
					var uservar:* = ChatMapper.inst.userVariableDict[uservarCondition.name];
					
					if (uservar)
					{						
						// Test for a number value.
						if (rxIsNumber.test(uservarCondition.value))
						{
							var uservarValue_Num:Number = Number(uservar);						
							var uservarCondition_Num:Number = Number(uservarCondition.value);
							if (ChatTools[uservarCondition.operator](uservarValue_Num, uservarCondition_Num))
								checklist.push(true);
							else	
								checklist.push(false);
						}
						
						// Test for a string value.
						if (rxIsString.test(uservarCondition.value))
						{
							var uservarValue_String:String 		= String(uservar);						
							var uservarCondition_String:String 	= String(uservarCondition.value).toLowerCase();
							
							
							if (ChatTools[uservarCondition.operator](uservarValue_String, uservarCondition_String))
								checklist.push(true);
							else							
								checklist.push(false);
						}						
					}
					else
					{
						trace("Error, couldn't find uservar:", uservarCondition.name);
					}
				}
				
				// Finally, look for any "false" in conditions checklist.
				for (i = 0; i < checklist.length; i++) 
				{
					var conditionMet:Boolean = checklist[i];
					if (!conditionMet)
						return false;					
				}
			}
			return true;
		}		
		
		
		/**
		 * Scripts "assign" values to items. Thats all they do. This method returns an array containig the 
		 * script(s) for the user to do with as they will.
		 * @param	node
		 * @return Array - array of script strings.
		 */
		static public function runScripts(node:ChatNode):Vector.<String>
		{
			var returnVector:Vector.<String> = new Vector.<String>();
			
			var scriptObjectArr:Vector.<ScriptObject> = new Vector.<ScriptObject>();
			
			var rawScriptsString:String = node.xml.UserScript.toString();
			rawScriptsString = replaceOperators(rawScriptsString);
			
			var i:int;
			var scriptArr:Array = rawScriptsString.split("\n");						
			if (scriptArr.length > 0)
			{
				for (i = 0; i < scriptArr.length; i++) 
				{
					var script:String = scriptArr[i];
					returnVector.push(script);
					
					if (script.length > 0)
					{
						var rxScriptType				:RegExp = /\w+/;// need to cut first +last character
						var rxScriptName				:RegExp = /".*?"/g;// need to cut first +last character
						var rxScriptOpperator			:RegExp = /\s\w+/; // need to cut first +last character
						var rxScriptValue				:RegExp = /\s+\S*$/g;
						var rxScriptVariable			:RegExp = /\..*?\s/g; // need to cut first +last character
						
						var scriptType:String = String(script.match(rxScriptType)[0]);	
						
						var scriptName:String = String(script.match(rxScriptName)[0]);
						scriptName = scriptName.substr(1, scriptName.length - 2);		
						
						var scriptVariable:String = String(script.match(rxScriptVariable)[0])
						scriptVariable = scriptVariable.substr(1, scriptVariable.length - 2);
						
						var scriptOperator:String = String(script.match(rxScriptOpperator)[0])
						scriptOperator = scriptOperator.substr(1, scriptName.length - 1)
						
						var scriptValue:String = String(script.match(rxScriptValue)[0])
						scriptValue = scriptValue.substr(1, scriptValue.length - 1);
						
						var scriptObject:ScriptObject = new ScriptObject();
						scriptObject.name	  	= scriptName;
						scriptObject.type		= scriptType;
						scriptObject.variable	= scriptVariable;
						scriptObject.operator	= scriptOperator;
						scriptObject.value		= scriptValue;
						//trace(scriptObject);						
						scriptObjectArr.push(scriptObject);	
					}				
				}
			}
			
			for (i = 0; i < scriptObjectArr.length; i++) 
			{
				var scriptObj:ScriptObject = scriptObjectArr[i];
				switch(scriptObj.type)
				{
					case "Variable":
						ChatMapper.inst.userVariableDict[scriptObj.name] = scriptObj.value;
						break;
					case "Item":
						ChatMapper.inst.itemDict[scriptObj.name].fields[scriptObj.variable] = scriptObj.value;
						break;
					case "Location":
						ChatMapper.inst.locationDict[scriptObj.name].fields[scriptObj.variable] = scriptObj.value;
						break;
					case "Actor":
						ChatMapper.inst.actorDict[scriptObj.name].fields[scriptObj.variable] = scriptObj.value;
						break;
				}				
			}			
			return returnVector;			
		}
		
		
		/**
		 * Sorts the priority of the nodes links.
		 */
		static public function sortPriority(a:XML, b:XML):int 
		{
			var aValue:int = 0;
			var bValue:int = 0;				
			switch(a.@ConditionPriority.toString())
			{
				case "High":		aValue = 2;		break;
				case "AboveNormal":	aValue = 1;		break;
				case "Normal":		aValue = 0;		break;
				case "BelowNormal":	aValue = -1;	break;
				case "Low":			aValue = -2;	break;
				default:			aValue = 0;
			}
			switch(b.@ConditionPriority.toString())
			{
				case "High":		bValue = 2;		break;
				case "AboveNormal":	bValue = 1;		break;
				case "Normal":		bValue = 0;		break;
				case "BelowNormal":	bValue = -1;	break;
				case "Low":			bValue = -2;	break;
				default:			bValue = 0;
			}
			if (bValue > aValue)
				return 1;
			else if (bValue < aValue)
				return -1;
			else
				return 0;
		}
		
		static public function isEqualTo(val1:*, val2:*):Boolean
		{
			if (val1 == val2)	return true;
			else return false;
		}
		
		static public function isNotEqualTo(val1:*, val2:*):Boolean
		{
			if (val1 != val2)	return true;
			else return false;
		}
		
		static public function isGreaterThan(val1:*, val2:*):Boolean
		{
			if (val1 > val2)	return true;
			else return false;
		}
		
		static public function isLessThan(val1:*, val2:*):Boolean
		{
			if (val1 < val2)	return true;
			else return false;
		}
		
		static public function isGreaterOrEqualTo(val1:*, val2:*):Boolean
		{
			if (val1 >= val2)	return true;
			else return false;
		}
		
		static public function isLessOrEqualTo(val1:*, val2:*):Boolean
		{
			if (val1 <= val2)	return true;
			else return false;
		}
		
		static public function equals(val1:*, val2:*):*
		{
			val1 = val2;
			return val1;
		}
		
		
		static public function replaceOperators(string:String):String 
		{
			string = string.replace(/==/g, "isEqualTo");
			string = string.replace(/~=/g, "isNotEqualTo");
			string = string.replace(/>/g, "isGreaterThan");
			string = string.replace(/</g, "isLessThan");
			string = string.replace(/>=/g, "isGreaterOrEqualTo");
			string = string.replace(/<=/g, "isLessOrEqualTo");			
			string = string.replace(/=/g, "equals");
			
			string = string.replace(/\strue/gi, " true");
			string = string.replace(/\sfalse/gi, " false");
			
			return string;
		}
		
/*-------------------------------------------------
* PRIVATE FUNCTIONS
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* EVENT HANDLING
-------------------------------------------------*/
		
		
		
/*-------------------------------------------------
* GETTERS / SETTERS
-------------------------------------------------*/	
		
		
		
	}

}


internal class ScriptObject
{
	public var name:String;
	public var type:String;
	public var variable:String;
	public var operator:String;	
	public var value:*;
	
	public function toString():String
	{
		return "ScriptObject{ name=" + name + " type=" + type + " variable="+variable+" operator=" + operator + " value=" + value + " }"; 
	}
}
