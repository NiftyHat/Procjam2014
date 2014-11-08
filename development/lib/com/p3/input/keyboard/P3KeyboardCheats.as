package com.p3.input.keyboard 
{
	import com.p3.input.keyboard.P3Keyboard;
	import flash.utils.Dictionary;
	
	/**
	 * Automatated cheat handler, takes in an unlock patter; once the unlock pattern is entered functions added
	 * through bindCheatKey will be called when the corrisponding key is pressed. Needs to be init with stage referance.
	 * The full list of key bindings is in the P3KeyboardClass. Example usage
	 * @usage
	 * P3KeyboardCheats.init(stage);
	 * P3KeyboardCheats.bindUnlockKeys(["ONE","CONTROL","SHIFT"]);
	 * P3KeyboardCheats.bindCheatKey("ONE", callbackFunction, [_someParameter]);
	 * 
	 * @author Duncan Saunders - PlayerThree 2012
	 */
	public class P3KeyboardCheats
	{
		
		protected var m_isLocked:Boolean = true;
		protected var m_unlock_keys:Array;
		protected var m_keys:P3Keyboard;
		protected var m_cheat_map:Dictionary;
		protected var m_cheat_map_index:Vector.<String>
		
		public function P3KeyboardCheats($keys:P3Keyboard = null) 
		{
			if (!$keys) m_keys = P3Keyboard.inst;
			else m_keys = $keys;
			m_cheat_map = new Dictionary ();
			m_cheat_map_index = new Vector.<String>();
		}
		
		public function bindUnlockKeys ($keys:Array):void 
		{
			m_unlock_keys = $keys.slice();
		}
		
		public function bindCheatKey ($key:String, $callback:Function, $params:Array = null):void
		{
			var cheatBinding:CheatBinding = new CheatBinding($key, $callback, $params);
			if (m_cheat_map[$key] == null || m_cheat_map[$key] == undefined)
			{
				m_cheat_map_index.push($key);
			}
			m_cheat_map[$key] = cheatBinding;
		
		}
		
		public function update():void
		{
			var key:String;
			if (m_isLocked)
			{
				if (m_unlock_keys)
				{
					for each (key in m_unlock_keys)
					{
						if (!m_keys.pressed(key))
						{
							return;
						}
					}
					unlock();
				}
			}
			else
			{
				if (m_cheat_map_index.length > 0)
				{
					for each (key in m_cheat_map_index)
					{
						if (m_keys.justPressed(key))
						{
							runCheat(key);
						}
					}
				}
			}
		}
		
		private function runCheat($key:String):void 
		{
			if (m_cheat_map[$key] != null && m_cheat_map[$key] != undefined)
			{
				var cheatBinding:CheatBinding = m_cheat_map[$key]
				cheatBinding.run();
			}
		}
		
		private function unlock():void 
		{
			trace("cheat mode unlocked");
			m_isLocked = false;
		}
		
	}

}
	internal class CheatBinding 
	{
		protected var key:String;
		protected var func:Function;
		protected var params:Array;
		
		function CheatBinding ($key:String,$func:Function, $params:Array = null):void
		{
			key = $key;
			func = $func;
			params = $params;
		}
		
		public function run ():void
		{
			if (params) func.apply(null, params);
			else func();
		}
	}