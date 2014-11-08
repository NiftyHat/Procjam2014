package com.p3.debug.mincomps 
{
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import mx.core.ButtonAsset;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3MinCompsRevisionNotes extends MovieClip
	{
		
		private var _window:Window;
		private var _textArea:TextArea;
		private var _buttonFoward:PushButton;
		private var _buttonBackward:PushButton;
		private var _buttonClose:PushButton;
		private const GUTTER:int = 3;

		protected var _notesXML:XMLList;
		protected var _currNote:XML;
		
		public function P3MinCompsRevisionNotes($notesXML:XMLList = null) 
		{
			
			_window = new Window (this, 0, 0, "Revision Notes");
			_textArea = new TextArea ();
			_buttonBackward = new PushButton (null, 0, 0, "<< Older", onClickBackward);
			_buttonFoward = new PushButton (null, 0, 0, "Newer >>", onClickFoward);
			_buttonClose = new PushButton (null, 0, 0, "Close", onClickClose);
			_buttonBackward.width = 60;
			_buttonFoward.width = 60;
			setNotesXML($notesXML);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		private function onClickBackward(e:MouseEvent):void 
		{
			setNote(_notesXML[_currNote.childIndex() + 1] as XML)
		}
		
		private function onClickFoward(e:MouseEvent):void 
		{
			setNote(_notesXML[_currNote.childIndex() - 1]  as XML)
		}
		
		public function setNotesXML($notesXML:XMLList):void
		{
			_notesXML = $notesXML;
			if (_notesXML) setNote(_notesXML[0]);
		}
		
		private function onClickClose(e:MouseEvent = null):void 
		{
			close();
		}
		
		private function close():void
		{
			if (parent) parent.removeChild(this);
			_window.removeEventListener(Event.CLOSE, onWindowClosed);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_window.setSize(stage.stageWidth * 0.8, stage.stageHeight * 0.8);
			_window.x = stage.stageWidth * 0.1;
			_window.y = stage.stageHeight * 0.1;
			_window.hasCloseButton = true;
			_window.addEventListener(Event.CLOSE, onWindowClosed);
			_textArea.width = _window.width - GUTTER - 2;
			_textArea.x = GUTTER;
			_textArea.height = _window.height - 45 - GUTTER;
			_textArea.y = GUTTER;
			_buttonBackward.x = _textArea.x;
			_buttonFoward.x = _textArea.width + _textArea.x - _buttonFoward.width;
			_buttonClose.x =  (_textArea.width * 0.5)  + _textArea.x  - (_buttonClose.width * 0.5);
			_buttonClose.y = _buttonFoward.y = _buttonBackward.y = _textArea.height + _textArea.y + GUTTER;
			_window.addChild(_textArea);
			_window.addChild(_buttonBackward);
			_window.addChild(_buttonFoward);
			_window.addChild(_buttonClose);
		}
		
		private function onWindowClosed(e:Event):void 
		{
			close();
		}
		
		private function setNote($xml:XML):void 
		{
			if (!$xml) return;
			_currNote = $xml;
			_textArea.text = "Release Notes \n";
			_textArea.text += _currNote.toString();
			_textArea.draw();
		}
		
	}

}