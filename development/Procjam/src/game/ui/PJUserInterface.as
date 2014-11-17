package game.ui 
{
	import com.greensock.TweenLite;
	import flash.display3D.Context3DBlendFactor;
	import game.ui.events.GoldEvent;
	import game.ui.events.KillEvent;
	import org.axgl.Ax;
	import org.axgl.AxCloud;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxSprite;
	import org.axgl.render.AxBlendMode;
	import org.axgl.text.AxText;
	/**
	 * ...
	 * @author Keith Evans @ heatknives.com
	 */
	public class PJUserInterface extends AxGroup
	{
		[Embed(source="../../../../../design/UI/bar_dead.png")]
		public static const GRAPHIC_GOLDMETER_DEAD_AREA:Class;
		
		[Embed(source="../../../../../design/UI/bar_live.png")]
		public static const GRAPHIC_GOLDMETER_LIVE_AREA:Class;
		
		[Embed(source="../../../../../design/UI/goldmeter.png")]
		public static const GRAPHIC_GOLDMETER_DECAL:Class;
		
		[Embed(source="../../../../../design/UI/mask.png")]
		public static const GRAPHIC_GOLDMETER_MASK:Class;
		
		[Embed(source="../../../../../design/UI/pointer.png")]
		public static const GRAPHIC_POINTER:Class;
		
		[Embed(source="../../../../../design/UI/vignette.png")]
		public static const GRAPHIC_VIGNETTE:Class;
		
		
		
		private static const MAX_GOLD_POINTER_Y:int = 106
		private static const MIN_GOLD_POINTER_Y:int = 584
		
		
		private var _goldCurrent:int;
		private var _goldMax:int;
		
		private var _goldmeterBG:AxSprite;
		private var _goldmeterFG:AxSprite;
		private var _goldmeterPointer:AxSprite;
		private var _goldmeterFrame:AxSprite;
		private var _vignette:AxSprite;
		
		private var trapQ:AxSprite;
		private var trapW:AxSprite;
		private var trapE:AxSprite;
		private var trapR:AxSprite;
		
		private var killcount:int = 0;
		
		private var tombstoneGroup:AxCloud;
		private var killCounter:AxText
		
		
		public function PJUserInterface() 
		{
			super();
			createState();
		}
		
		public function createState():void {
			noScroll();
			
			// Black fading vignette
			_vignette = new AxSprite(0, 0, GRAPHIC_VIGNETTE);
			add(_vignette);
			
			// Gooooldmeter
			_goldmeterFG = new AxSprite(728, 106, null);
			_goldmeterFG.create(36, 482, 0xffffd52e)
			add(_goldmeterFG);
			_goldmeterFrame = new AxSprite(692, 0, GRAPHIC_GOLDMETER_DECAL);
			add(_goldmeterFrame);
			
			// Pointer
			_goldmeterPointer = new AxSprite(670, 86, GRAPHIC_POINTER);
			add(_goldmeterPointer);
			
			// Tombstones!
			tombstoneGroup = new AxCloud(7, 560);
			add(tombstoneGroup);
			killCounter = new AxText(7, 580, null, "0 KILLS");
			add(killCounter);
			
			Core.control.addEventListener(GoldEvent.SET_DUNGEON_CURRENT_GOLD_TO, oe_currentGold);
			Core.control.addEventListener(GoldEvent.SET_DUNGEON_TOTAL_GOLD_TO, oe_maxGold);
			Core.control.addEventListener(KillEvent.REGISTER_KILL, oe_registerKill);
		}
		
		private function oe_currentGold(e:GoldEvent):void 
		{
			goldCurrent = e.value;
		}
		
		private function oe_maxGold(e:GoldEvent):void 
		{
			goldMax = e.value;
		}
		
		private function oe_registerKill(e:KillEvent):void 
		{
			addTombstone(e.killType);
		}
		
		public function addListeners():void {
			//Core.control.addEventListener(UIEvent.SET_GOLD_MAX
		}
		
		public function set goldMax(value:int):void {
			_goldMax = value;
			_goldCurrent = value;
			redrawGoldPosition(true);
		}
		
		public function set goldCurrent(value:int):void {
			_goldCurrent = value;
			redrawGoldPosition(false);
			
		}
		
		private function redrawGoldPosition(instant:Boolean = false):void 
		{
			
			if (_goldMax <= 0) _goldMax = 1;
			
			if (_goldCurrent < 0) _goldCurrent = 0;
			else if (_goldCurrent > _goldMax) _goldCurrent = _goldMax;
			
			var ratio:Number = (_goldCurrent / _goldMax)
			var targetY:Number = ratio * (MAX_GOLD_POINTER_Y - MIN_GOLD_POINTER_Y) + MIN_GOLD_POINTER_Y
			
			
			if (instant) {
				_goldmeterPointer.y = targetY - _goldmeterPointer.height*.5;;
				_goldmeterFG.scale.y = ratio
				_goldmeterFG.y = targetY
			} else {
				
				TweenLite.killTweensOf(_goldmeterFG);
				TweenLite.killTweensOf(_goldmeterFG.scale);
				TweenLite.killTweensOf(_goldmeterPointer);
				
				TweenLite.to(_goldmeterFG, 1, {y: targetY } );
				TweenLite.to(_goldmeterFG.scale, 1, { y:ratio} );
				TweenLite.to(_goldmeterPointer, 1, { y: targetY - _goldmeterPointer.height*.5 } );
			}
		}
		
		public function addTombstone(type:String):void {
			var frame:int = 9;
			
			switch(type) {
				case "THIEF":
					frame = Math.random() * 3;
					break;
				case "WIZARD":
					frame = Math.random() * 3 + 3;
					break;
				case "BESERKER":
					frame = Math.random() * 3 + 6;
					break;
			}
			
			var newTomb:AxSprite = new AxSprite(tombstoneGroup.members.length * 23, 0, Core.lib.int.img_tombstones, 22, 32)
			newTomb.show(frame)
			tombstoneGroup.add(newTomb);
			killcount++;
			
			killCounter.text = killcount+" KILLS";
			
			repositionTombstones();
		}
		
		private function repositionTombstones():void 
		{
			while (tombstoneGroup.members.length > 50) {
				var spr:AxSprite = tombstoneGroup.members.splice(0, 1)[0];
				spr.removeParent();
				spr.destroy();
			}
			if(tombstoneGroup.members.length < 25){
				for (var i:int = 0; i < tombstoneGroup.members.length; i++) {
					tombstoneGroup.members[i].x = 23 * i;
				}
				killCounter.x = i * 23 +15
			} else {
				for (var i:int = 0; i < tombstoneGroup.members.length; i++) {
					tombstoneGroup.members[i].x = 12 * i;
					tombstoneGroup.members[i].y = i % 2 ? 8 : 0;
				}
				
				killCounter.x = i * 12  +20;
			}
			
		}
		
		override public function destroy():void 
		{
			Core.control.removeEventListener(GoldEvent.SET_DUNGEON_CURRENT_GOLD_TO, oe_currentGold);
			Core.control.removeEventListener(GoldEvent.SET_DUNGEON_TOTAL_GOLD_TO, oe_maxGold);
			Core.control.removeEventListener(KillEvent.REGISTER_KILL, oe_registerKill);
			super.destroy();
		}
		
	}

}