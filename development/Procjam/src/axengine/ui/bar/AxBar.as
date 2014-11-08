package axengine.ui.bar 
{
	import axengine.util.AxPercRange;
	import org.axgl.AxSprite;
	import org.axgl.util.AxRange;
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxBar extends AxSprite
	{
		protected var _range:AxPercRange;
		protected var _barColor:uint;
		protected var _barWidth:int;
		protected var _barHeight:int;
		protected var _value:Number = 0;
		
		public function AxBar($barWidth:int = 10, $barHeight:int = 10, $color:uint = 0xFF004080, $minValue:Number = 0, $maxValue:Number = 100)
		{
			_barWidth = $barWidth;
			_barHeight = $barHeight;
			_barColor = $color;
			_range = new AxPercRange ($minValue, $maxValue)
			redrawBarGraphics();
		}
		
		protected function redrawBarGraphics():void {
			create(_barWidth, _barHeight, _barColor);
			//override thise
		}
		
		public function setValue($value:Number):void {
			_value = $value;
			if (_value > _range.max) _value = _range.max;
			if (_value < _range.min) _value = _range.min;
		}
		
		public function setMax($max:Number):void {
			_range.max = $max;
		}
		
		public function setMin($min:Number):void {
			_range.min = $min;
		}
		
		public function setBarColor($color:uint):void {
			_barColor = $color;
		}
		
		public function get range():AxRange 
		{
			return _range;
		}
		
		public function get barWidth():int 
		{
			return _barWidth;
		}
		
		public function get barHeight():int 
		{
			return _barHeight;
		}
		
		override public function draw():void 
		{
			super.draw();
		}
		
	}

}