 package axengine.util
{
        /**
         * ...
         * @author Duncan Saunders
         */
        public dynamic class AxRangedNumber
        {
                protected var _value:Number = 0;
                protected var _max:Number = Number.MAX_VALUE;
                protected var _min:Number = Number.MIN_VALUE;
				
				protected var _name:String;
               
                protected var _seed:int;
                protected var _precision:int = 2;
                protected var _decimalPlaces:Number = 100;
               
                public function AxRangedNumber($max:Number = 0, $min:Number = 0, $value:Number = 0, $name:String = null)
                {
                        init($value, $max, $min);
                        _seed = Math.random() * int.MAX_VALUE;
                        _decimalPlaces = Math.pow(10, _precision);
						_name = $name;
                }
               
                public function set precision ($precision:int):void {
                        _precision = $precision;
                        _decimalPlaces = Math.pow(10,_precision);
                }
               
                //returns a random number within the range of max and min;
                public function rand():Number
                {
                        _seed = (_seed * 16807) % 2147483647;
                        var perc:Number = (4.656612875245796924105750827168e-10) * _seed;
                        var randValue:Number = (_max - _min) * perc
                        return Math.round((_decimalPlaces * randValue)) / _decimalPlaces;
                }
				
				public function perc():Number {
					return 1.0 / max * value;
				}
               
                private function init($value:Number, $max:Number = 0,$min:Number = 0):void
                {
                        _max = $max;
                        _min = $min;           
                        if (_max < _min) _max = _min;
                        if (_min > _max) _min = _max;
                        value = $value;
                }
               
                public function get value():Number { return _value; }
               
                public function set value(value:Number):void
                {
					_value = value;
					if (_value < _min) _value = _min;
					if (_value > _max) _value = _max;
                }
               
                public function get max():Number { return _max; }
               
                public function set max(value:Number):void
                {
                        _max = value;
                        if (_max < _min) _max = _min;
                        if (_value > _max) _value = _max;
                }
               
                public function get min():Number { return _min; }
               
                public function set min(value:Number):void
                {
                        _min = value;
                        if (_min > _max) _min = _max;
                        if (_value < _min) _value = _min;
                }
				
				public function get name():String 
				{
					return _name;
				}
				
				public function set name(value:String):void 
				{
					_name = value;
				}
               
                public function toString ():String
                {
                        return "[Range :" + _min + " - " +_max + " Value:" + _value + "]";
                }

        }

} 