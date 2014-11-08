package axengine.events 
{
	import effects.EmitterEffect;
	import entities.Entity;
	import flash.events.Event;
	import org.axgl.particle.AxParticleCloud;
	import org.flixel.FlxEmitter;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxEmitterEvent extends Event 
	{
		static public const REMOVE_FROM_WORLD:String = "removeEmitterFromWorld";
		static public const ADD_TO_WORLD:String = "addEmitterToWorld";
		
		private var m_emmitter:AxParticleCloud;
		private var m_explode:Boolean;
		private var m_quantity:int;
		private var m_delay:Number = 0;
		
		public function AxEmitterEvent($type:String, $emitter:AxParticleCloud) 
		{ 
			m_emmitter = $emitter
			//m_delay = $delay;
			//m_explode = $explodes;
			//m_quantity = $quantity;
			super($type);
			
		} 
		
		public override function clone():Event 
		{ 
			return new EmitterEvent(type,m_emmitter);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EmitterEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get emmitter():AxEmitterEvent { return m_emmitter; }
		
		public function get explode():Boolean { return m_explode; }
		
		public function get delay():Number { return m_delay; }
		
		public function get quantity():int { return m_quantity; }
		
	}
	
}