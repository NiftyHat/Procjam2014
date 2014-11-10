package axengine.entities
{
	import axengine.util.AxAnimationAsset;
	import axengine.util.AxEventListenerInfo;
	import axengine.util.AxGraphicAsset;
	import axengine.world.AxWorld;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import org.axgl.AxPoint;
	import org.axgl.AxSprite;
	import org.axgl.render.AxColor;
	import org.axgl.text.AxFont;
	import org.axgl.text.AxText;
	import org.axgl.util.AxAnimation;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxGameEntity extends AxSprite
	{
		
		public var name:String = "AxGameEntity";
		
		protected var _libraryAssetName:String;
		protected var _enum:int = 1;
		protected var _classID:String;
		
		protected var _startX:int;
		protected var _startY:int;
		protected var _hasStart:Boolean;
		
		//protected var _isEditorVisible:Boolean = true;
		protected var _guid:String;
		protected var _linkID:int;
		protected var _isRotating:Boolean
		
		protected var _oldVelocity:AxPoint;
		protected var _isCollision:Boolean = true;
		protected var _world:AxWorld;
		protected var _depth:int = 0;
		
		protected var _eventBus:EventDispatcher;
		protected var _isForceBack:Boolean = false;
		protected var _isForceFront:Boolean = false;
		protected var _eventListeners:Vector.<AxEventListenerInfo>
		
		public var health:int = 1;
		public var alive:Boolean;
		protected var _maxHealth:int = 100;
		
		private var _centerPoint:AxPoint;
		private var _lastFrameDamage:int;
		
		
		public function AxGameEntity(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null)
		{
			super(X, Y, SimpleGraphic);
			drag.x = 100;
			health = 1;
			_oldVelocity = new AxPoint();
			_eventListeners = new Vector.<AxEventListenerInfo>();
			_classID = getClassID();
			_centerPoint = new AxPoint ();
			name = _classID;
		}
		
		/**
		 * Handy function for reviving game objects.
		 * Resets their existence flags and position.
		 *
		 * @param	X	The new X position of this object.
		 * @param	Y	The new Y position of this object.
		 */
		public function reset(X:Number,Y:Number):void
		{
			revive();
			touching = NONE;
			alive = true;
			//wasTouching = NONE;
			x = X;
			y = Y;
			velocity.x = 0;
			velocity.y = 0;
		}
		
		public function init($world:AxWorld):void
		{
			alive = true;
			_world = $world;
			_eventBus = $world.eventBus;
		}

		public function deserialize ($xml:XML):void
		{
			for each (var prop:XML in $xml.PROPS.*)
			{
				var p_name:String = prop.name()
				if (p_name in this)
				{
					//trace("Serialized prop " + name + ":" + p_name + " as " + prop);
					this[p_name] = prop;
				}
				else
				{
					//trace("WARNING: Serialized object " + this.name + " has no property " + p_name);
					continue;
				}
			}
			x = $xml.START.@x;
			y = $xml.START.@y;
			angle = $xml.ROTATION.@deg;
			width = $xml.SIZE.@width;
			height = $xml.SIZE.@height;
			_guid = $xml.ID.@guid;
			_linkID = $xml.ID.@link_id;
			_enum = $xml.@enum;
			_libraryAssetName = $xml.name();
		}
		
		public function loadAnimations ():void
		{
			var anims_xml:XML = Core.xml.getAnimationsXML(_libraryAssetName);
			if (anims_xml)
			{
				for each (var anim:XML in anims_xml.*)
				{
					addXMLAnimation(anim);
				}
			}
		}
		
		  public function addAssetAnimation ($animation:AxAnimationAsset):void
			{
					var name:String = $animation.name
					var frames:Array =  $animation.frames;
					var rate:int  = $animation.fps;
					var looping:Boolean  = $animation.looped;
					addAnimation(name, frames, rate, looping);
			}
			
		override public function addAnimation(Name:String, Frames:Array, FrameRate:uint = 0, Looped:Boolean = true, Callback:Function = null):AxSprite
		{
			for each (var anim:AxAnimation in animations)
			{
				if (anim.name == Name)
				{
					anim.frames = Vector.<uint>(Frames);
					anim.looped = Looped;
					if (FrameRate > 0) anim.framerate = FrameRate;
					return this;
				}
			}
			return super.addAnimation(Name, Frames, FrameRate, Looped, Callback);
		}
		
		/**
		 * Retroactive assignment of callback to an animation. Added so you can put callback on library stuff. Null name adds the callback to ALL animations.
		 * @param	Name
		 * @param	Callback
		 */
		public function addAnimationCallback(Name:String, Callback:Function):AxGameEntity {
			for each (var anim:AxAnimation in animations)
			{
				if (!Name) {
					anim.callback = Callback;
				}
				else (anim.name == Name)
				{
					anim.callback = Callback;
					return this;
				}
			}
			return null;
		}
		

		public function addXMLAnimation ($anim_xml:XML):void
		{
			var name:String = $anim_xml.@name
			var frames:Array =  $anim_xml.@frames.toString().split(",")
			var rate:int  = int($anim_xml.@rate)
			var looping:Boolean  = $anim_xml.@looping == "true" ?  true : false;
			addAnimation(name, frames, rate, looping);
		}
		//public function addAnimation(name:String, frames:Array, framerate:uint = 15, looped:Boolean = true, callback:Function = null):AxSprite {
		public function hurt($damage:int = 0, $source:AxGameEntity = null):void {
			health -= $damage;
			_lastFrameDamage += $damage;
			if (health < 0) {
				_lastFrameDamage += health
			}
			if (health <= 0 && alive) {
				kill();
			}
		}
		
		public function visualizeDamage($value:int):void {
			var textCounter:AxText = new AxText (center.x, y- 10, AxFont.fromFont("alagard", false, 16), $value.toString(), 30, "center");
			textCounter.velocity.y -= 130;
			textCounter.color = new AxColor (1,0,0,1);
			textCounter.velocity.x = (Math.random() * 200)  - 100;
			textCounter.acceleration.y = 350;
			textCounter.addTimer(1.0, textCounter.destroy)
			_world.add(textCounter)
		}
		
		override public function update():void
		{
			super.update();
			if (_lastFrameDamage > 0) {
				visualizeDamage(_lastFrameDamage)
				_lastFrameDamage = 0;
			}
			_oldVelocity.x = velocity.x;
			_oldVelocity.y = velocity.y;
			if (health <= 0) onDeath();
		}
		
		protected function onDeath():void
		{
			alive = false;
		}
		
		public function setPosition ($x:int, $y:int):void
		{
			x = $x;
			y = $y;
			recordStartPos();
		}
		
		public function serialize ():XML
		{
			
			//override me.
			return null;
		}
		
		protected function recordStartPos():void
		{
			_startX = x;
			_startY = y;
			_hasStart = true;
		}
				
		  public function loadNativeGraphics (Animated:Boolean = true, Reverse:Boolean = false, Width:uint = 0, Height:uint = 0, Unique:Boolean = false):void
			{
				var graphic_asset:AxGraphicAsset = Core.lib.getGraphicAsset(_libraryAssetName);
				if (Width == 0) Width = graphic_asset.width;
				if (Height == 0) Height = graphic_asset.height;
				load(graphic_asset.asset, Width, Height);
				width = graphic_asset.bounds.width;
				height = graphic_asset.bounds.height;
				pivot.x = graphic_asset.anchor.x;
				pivot.y = graphic_asset.anchor.y;
				offset.x = graphic_asset.bounds.x;
				offset.y = graphic_asset.bounds.y;
				if (graphic_asset.isAnimated)
				{
						for each (var anim:AxAnimationAsset in graphic_asset.animations)
						{
								addAssetAnimation(anim);
						}
				}
			}
		
		public function delayedKill($time:Number):void
		{
			addTimer($time, kill, 1);
			//TODO - new timer class.
			//m_ftx_delayed_death.start($time, 1 , kill);
		}
		
		public function clone ():AxGameEntity
		{
			trace("Write a custom clone method for each unique entity!");
			var construct:Class = Object(this).constuctor//(getDefinitionByName(getQualifiedClassName(this)) as Class);
			return new construct();
		}
		
		public function overrideXMLName ($name:String):void
		{
			_libraryAssetName = $name;
		}
		
		public function get tooltip ():String
		{
			return name;
		}
		
		public function kill():void
		{
			alive = false;
			if (_lastFrameDamage > 0) {
				visualizeDamage(_lastFrameDamage)
				_lastFrameDamage = 0;
			}
			active = false;
		}
		
		//Event stuff
		
		public function addEventListener ($name:String, $callback:Function):void
		{
			if (!_eventBus)
			{
				throw new Error ("no event bus to listen too, make sure AxWorld has an assigned m_eventBus");
			}
			var info:AxEventListenerInfo = new AxEventListenerInfo();
			info.name = $name;
			info.callback = $callback;
			_eventBus.addEventListener($name, $callback);
			_eventListeners.push(info);
		}
		
		public function dispatchEvent ($event:Event):void
		{
			if (!_eventBus)
			{
				throw new Error ("no event bus to dispatch on, make sure World has an assigned m_eventBus");
			}
			_eventBus.dispatchEvent($event);
		}
		
		public function removeEventListeners ():void
		{
			if (!_eventBus)
			{
				throw new Error ("no event bus to dispatch on, make sure World has an assigned m_eventBus");
			}
			for each (var item:AxEventListenerInfo in _eventListeners)
			{
				_eventBus.removeEventListener(item.name, item.callback);
			}
		}
		
		public function getCenterPoint ():AxPoint
		{
			_centerPoint.x = centerX;
			_centerPoint.y = centerY;
			return _centerPoint;
		}
		
		internal function getClassID ():String
		{
			var fullClass:String = getQualifiedClassName(this);
			return String(fullClass.split("::").pop()).toUpperCase()
		}
		
		public function get isCollision():Boolean { return _isCollision; }
		
		public function get guid():String { return _guid; }
		
		public function get centerX():int { return x + width * 0.5 };
		
		public function get centerY():int { return y+ height * 0.5 };
		
		public function get linkID():int { return _linkID; }
		
		public function get isRotating():Boolean { return _isRotating; }
		
		public function get depth():int { return _depth; }
		
		public function get startX():int { return _startX; }
		
		public function get startY():int { return _startY; }
		
		public function get oldVelocity():AxPoint { return _oldVelocity; }
		
		public function get enum():int { return _enum; }
	
		public function get isWorld ():Boolean { return _world != null };

		public function get classID():String { return _classID; }
		
		public function get isForceBack():Boolean { return _isForceBack; }
		
		public function get isForceFront():Boolean { return _isForceFront; }
		
		public function get maxHealth():int
		{
			return _maxHealth;
		}
		
		public function set maxHealth(value:int):void
		{
			_maxHealth = value;
		}
		
		
	}

}