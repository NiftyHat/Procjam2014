package axengine.entities 
{
	import axengine.entities.projectiles.AxProjectile;
	import org.axgl.Ax;
	import org.axgl.AxRect;
	import org.axgl.sound.AxSound;
	import org.axgl.util.AxTimer;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxDynamicEntity extends AxGameEntity
	{
		
		protected var m_hasTouch:Boolean = true;
		protected var m_hasTrigger:Boolean;
		protected var m_isTouched:Boolean = false;
		protected var m_isTriggered:Boolean = false;
		protected var _timerAllowTouch:AxTimer;
		protected var _timerAllowTrigger:AxTimer;
		protected var _isInitilizing:Boolean = true;
		protected var _player:AxDynamicEntity;
		protected var _isInvunerable:Boolean;
		protected var _isProjectileTarget:Boolean;
		
		
		public function AxDynamicEntity(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) 
		{
			_timerAllowTouch = addTimer(0.1, null, 1, 0);
			_timerAllowTrigger= addTimer(0.1, null, 1, 0);
			super(X, Y, SimpleGraphic);
		}
		

		
		override public function deserialize($xml:XML):void 
		{
			super.deserialize($xml);
			setPosition($xml.START.@x, $xml.START.@y)
			angle = $xml.ROTATION.@deg;
			width = $xml.SIZE.@width;
			height = $xml.SIZE.@height;
		}
		
		//---------------------------------------------
		//PHYSICS HANDLING
		//---------------------------------------------
		
		public function updatePhysics ():void
		{
			
		}
		
		public function enablePhysics ():void
		{
			updatePhysics();
		}
		
		public function disablePhysics ():void
		{
			velocity.x = 0;
			velocity.y = 0;
			drag.x = 0;
			acceleration.y = 0;
			acceleration.x = 0;
		}
		
		public function applyPhysics ():void
		{
			acceleration.y = _world.gravity;
		}
		
		public function removePhysics ():void
		{
		}
		
		//---------------------------------------------
		// TRIGGER STATE HANDLING
		//---------------------------------------------	
		
		override public function update():void 
		{
			
			if (this is AxPlayer) return super.update();
			if (m_isTouched && (!Ax.overlap(this, _player) || !_player.alive)) playerUntouched(_player);
			if (m_isTriggered) untrigger();
			if (m_isTriggered && !_timerAllowTrigger.running)
			{
				_timerAllowTrigger.start();
			}
			super.update();
			if (_isInitilizing) _isInitilizing = false;
		}
		
		protected function updateStats ():void 
		{
			
		}
		
		//---------------------------------------------
		// TRIGGER STATE HANDLING
		//---------------------------------------------	
		
		public function playerTouched ($player:AxDynamicEntity):Boolean
		{
			if (!m_hasTouch || m_isTouched  || $player == null) return false;
			_player = $player
			m_isTouched = true;
			
			onPlayerTouch(_player);
			return true;
		}

		public function playerUntouched ($player:AxDynamicEntity):Boolean
		{
			m_isTouched = false;
			onPlayerUntouch($player);
			return true;
		}
		
		public function trigger($player:AxPlayer):Boolean
		{
			//block trigger behavoir if already triggered, waiting to re-trigger or if fired by a null entity;
			if (!m_hasTrigger || m_isTriggered || _timerAllowTrigger.running || !$player) return false;
			m_isTriggered = true;
			onTrigger($player);
			return true;
		}
		
		public function untrigger():void
		{
			//$entity:Entity
			if (m_isTriggered)
			{
				m_isTriggered = false;
				onUntrigger();
			}
			
		}


		/**
		 * MARKED OVERRIDES
		 */
				
		protected function onInteract ($player:AxDynamicEntity):void
		{
			
		}
		
		protected function onPlayerTouch ($player:AxDynamicEntity):void
		{
			//color = 0xFFFF0000
		}
		
		protected function onPlayerUntouch ($player:AxDynamicEntity):void
		{
			//color = 0xFF00FF00
		}
		
		protected function onTrigger ($entity:AxGameEntity):void
		{
			
		}
		
		protected function onUntrigger():void
		{
			//$entity
		}
		

		public function playSound ($class:Class, $radius:int = 70, $pan:Boolean = true):void
		{
			var sound:AxSound = new AxSound ($class)
			sound.update();
			sound.play();
		}
		
		public function playRandomSound ($array:Array, $radius:int = 70, $pan:Boolean = true):void
		{
			var len:int = $array.length;
			var rnd:int = Math.random() * len;
			playSound($array[rnd], $radius, $pan);
		}
		
		public function onProjectileHit($projectile:AxProjectile):Boolean 
		{
			return true;
		}
		
		/**
		 * GETTERS AND SETTERS
		 */
		
		public function get hasTouch():Boolean { return m_hasTouch; }
		
		public function set hasTouch(value:Boolean):void 
		{
			m_hasTouch = value;
		}
		
		public function get hasTrigger():Boolean { return m_hasTrigger; }
		
		public function set hasTrigger(value:Boolean):void 
		{
			m_hasTrigger = value;
		}

		public function get isInitilizing():Boolean { return _isInitilizing; }
		
		public function get isInvunerable():Boolean 
		{
			return _isInvunerable;
		}
		
		public function get isProjectileTarget():Boolean 
		{
			return _isProjectileTarget;
		}
		
	}

}