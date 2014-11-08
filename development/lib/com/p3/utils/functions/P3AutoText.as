/**
 * Utility class to shrink "copy" to fit within textfields.
 * 
 * usage: AutoText.setText(textfiled, string);	or	AutoText.setHtml(textfiled, string)
 * 
 * TO work I "belive" the textfields need to be set to "single line" and can not have any auto-sizing...
 * 
 * @author Adam Holland
 */

package com.p3.utils.functions
{
	
import flash.text.TextField;
import flash.text.TextFormat;

public class P3AutoText
{
	
/*-------------------------------------------------
* PUBLIC CONSTRUCTOR
-------------------------------------------------*/

	public function P3AutoText()
	{
		
	}
	
/*-------------------------------------------------
* PUBLIC FUNCTIONS
-------------------------------------------------*/
	
	/**
	 * Shrinks the provided string to fit within the textfield.
	 * @param	textField : TextField to be shrunk.
	 * @param	str : String to go inside textfield.
	 */
	public static function setText(textField:TextField, str:String):void
	{
		var maxWidth:Number 	= Math.floor(textField.width) - 2;
		var maxHeight:Number 	= Math.floor(textField.height) - 2;
		var format:TextFormat 	= textField.getTextFormat();
		var baseSize:int 		= Number(format.size);
		
		textField.text = str;	
		
		if(textField.multiline == false)
		{
			baseSize += 1;
			format.size = baseSize;
			textField.setTextFormat(format);
			textField.wordWrap = false;
		}
		else
		{
			textField.wordWrap = true;
		}		
		
		while(textField.textWidth > maxWidth || textField.textHeight > maxHeight)
		{
			textField.y += 0.5
			baseSize -= 1;
			format.size = baseSize;
			textField.setTextFormat(format);
		}		
	}
	
	/**
	 * Shrinks the provided string to fit within the textfield.
	 * @param	textField : TextField to be shrunk.
	 * @param	str : String to go inside textfield.
	 */
	public static function setHtml(textField:TextField, str:String):void
	{
		textField.htmlText = str;
		
		var maxWidth:Number 	= Math.floor(textField.width) - 2;
		var maxHeight:Number 	= Math.floor(textField.height);
		var format:TextFormat 	= textField.getTextFormat();
		var baseSize:int 		= Number(format.size);		
		
		if(textField.multiline == false)
		{
			baseSize += 1;
			format.size = baseSize;
			textField.setTextFormat(format);
			textField.wordWrap = false;
		}
		else
		{
			textField.wordWrap = true;
		}		
		
		while(textField.textWidth > maxWidth || textField.textHeight > maxHeight)
		{
			textField.y += 0.5
			baseSize -= 1;
			format.size = baseSize;
			textField.setTextFormat(format);
		}
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