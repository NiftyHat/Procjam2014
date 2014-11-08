package axengine.ui.bar 
{
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class AxBarHorizontal extends AxBar
	{
		
		public function AxBarHorizontal($barWidth:int = 100, $barHeight:int = 6, $color:uint = 0xFF004080, $minValue:Number = 0, $maxValue:Number = 100)
		{
			super($barWidth, $barHeight, $color, $minValue, $maxValue);
		}
		
		override public function update():void 
		{
			super.update();
			scale.x = _range.perc(_value);
		}
		
		
		
	}

}