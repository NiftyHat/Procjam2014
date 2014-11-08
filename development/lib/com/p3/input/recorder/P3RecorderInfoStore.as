package com.p3.input.recorder 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class P3RecorderInfoStore
	{
		private var m_data_type:Class;
		public var input_data:Vector.<P3RecorderInfo>;
		public var vars:Object = { }
		protected var m_currPosition:uint;
		
		public function P3RecorderInfoStore($data_type:Class = null) 
		{
			m_data_type = $data_type;
			m_currPosition = 0;
			input_data = new Vector.<P3RecorderInfo>
		}
		
		public function save():ByteArray 
		{
			var bytes:ByteArray = new ByteArray ();
			var len:int = input_data.length;
			vars.lenght = len;
			bytes.writeObject(vars);
			for (var i:int = 0; i < len; i++)
			{
				var obj:Object = input_data[i].save()
				bytes.writeObject(obj);
			}
			//bytes.deflate();
			return bytes;
		}
		
		public function load($bytes:ByteArray):void
		{
			var bytes:ByteArray = $bytes;
			//bytes.inflate();
			bytes.position = 0;
			try
			{
				vars = bytes.readObject();
			}
			catch (e:Error)
			{
				trace("Error loading save, either no data or format has changed too much");
				return;
			}
			var len:int = vars.lenght;
			input_data = new Vector.<P3RecorderInfo> (vars.length - 1);
			for (var i:int = 0; i < len; i++)
			{
				var save_data:P3RecorderInfo = new m_data_type();
				var obj:Object = bytes.readObject()
				if (!save_data) 
				{
					trace("no save data object, does you class impliment P3RecorderInfo?");
				}
				if (obj)
				{
					save_data.load(obj);
					input_data[i] = (save_data);
				}
				
			}
		}
		
		public function writeData($data:P3RecorderInfo):void 
		{
			if (!m_data_type) m_data_type = $data.getClass();
			input_data.push($data);
		}
		
		public function flush ():void
		{
			//input_data.reverse();
		}
		
		public function readData($position:int):P3RecorderInfo
		{
			m_currPosition = $position;
			return input_data[m_currPosition];
		}
		
		/* INTERFACE com.p3.input.recorder.IRecorderData */
		
		public function get isFinished ():Boolean
		{
			return m_currPosition >= input_data.length - 1;
		}
	}

}