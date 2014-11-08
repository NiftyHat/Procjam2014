package com.p3.input.recorder
{
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.Window;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	[Event(name = "tickReplay", type = "com.P3.input.recorder.P3RecorderEvent")]
	public class P3Recorder extends EventDispatcher
	{
		private var m_isRunning:Boolean = false;
		private var m_isRecording:Boolean = false;
		private var m_currTick:Number = 0;
		private var m_currTickOffset:Number = 0;
		
		private var m_replayData:P3RecorderInfoStore;
		private var m_position:uint;
		
		public function P3Recorder($info_class:Class) 
		{
			m_replayData = new P3RecorderInfoStore ($info_class);
		}
		
		public function record ():void {
			//if (m_debug_window) m_debug_window.setLightColour(0xFF0000);
			m_position = 0;
			m_isRecording = true;
			m_isRunning = true;
		}
		
		public function start ($data:P3RecorderInfoStore = null):void {
			if ($data) m_replayData = $data
			//if (m_debug_window) m_debug_window.setLightColour(0x00FF00);
			m_position = 0;
			m_isRecording = false;
			m_isRunning = true;
		}
		
		public function stop():void {
			if (m_isRecording)
			{
				m_replayData.flush();
			}
			m_position = 0;
			m_isRunning = false;
			m_isRecording = false;
			
		}
		
		public function load ($bytes:ByteArray):void
		{
			if (!$bytes) return;
			$bytes.position = 0;
			m_replayData.load($bytes);
		}
		
		public function save ():ByteArray
		{
			return m_replayData.save()
		}
		
		public function update($time:Number, data:P3RecorderInfo):void
		{
			
			if (!m_isRunning) 
			{
				m_position = 0;
				m_currTickOffset = $time;
				return;
			}
			if (m_position > uint.MAX_VALUE)
			{
				trace("WARNING P3Recorder can't record more than " + uint.MAX_VALUE + " values in the playback info");
				stop();
				return;
			}
			m_currTick = $time - m_currTickOffset;
			//trace("tick" + m_currTick);
			if (!m_isRecording)
			{
				if (!m_replayData.isFinished)
				{
					var nextStepData:P3RecorderInfo = m_replayData.readData(m_position);
					
					if (m_currTick >= nextStepData.getTimestamp())
					{
						playbackData(nextStepData)
						m_position++;
					}	
				}
				else
				{
					stop();
				}
			}
			else
			{
				recordData(data)
			}
		}
		
		private function recordData($data:P3RecorderInfo):void 
		{
			if (!$data) return;
			$data.setTimestamp(m_currTick);
			m_replayData.writeData($data);
		}
		
		private function playbackData($readData:P3RecorderInfo):void 
		{
			dispatchEvent(new P3RecorderEvent(P3RecorderEvent.TICK_REPLAY, $readData));
		}
		
		public function getVars():Object
		{
			return m_replayData.vars;
		}
		
	}
}		
