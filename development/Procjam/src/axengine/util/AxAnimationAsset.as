package axengine.util
{
        /**
         * ...
         * @author Duncan Saunders
         */
        public class AxAnimationAsset
        {
                //animnum="0" fps="10.000" name="idle" numframes="2" looped="true" frames="0,0"
                protected var _name:String;
                protected var _index:int;
                protected var _frames:Array;
                protected var _fps:Number;
                protected var _numFrames:int;
                protected var _looped:Boolean;
               
                public function AxAnimationAsset()
                {
                        _name = "Anim Name";
                        _index = 0;
                        _frames = [0];
                        _fps = 10;
                        _numFrames = 1;
                        _looped = false;
                }
               
                               
                public function deserialize ($xml:XML):void
                {
                        _name = $xml.@name.toString();
                        _index = int($xml.@animnum);
                        var tempArray:Array =  $xml.@frames.toString().split(",");
                        if (tempArray.length > 0)
                        {
                                _frames = convertStringToInt(tempArray);
                        }
                        _fps = Number($xml.@fps);
                        _numFrames = int($xml.@numframes);
                        _looped = toBoolean($xml.@looped.toString())
                }
               
                public static function toBoolean (p_string : String, isExact : Boolean = false):Boolean {
                        if (p_string == "true") return true;
                        return false;
                }
               
                public function convertStringToInt($source:Array):Array
                {
                        $source.every(everyConvertToInt);
                        return $source;
                }
               
                private function everyConvertToInt(arrayItem:*,index:int, array:Array):Boolean
                {
                        array[index] = int(arrayItem);
						return true;
                }
               
                public function get name():String
                {
                        return _name;
                }
               
                public function get index():int
                {
                        return _index;
                }
               
                public function get frames():Array
                {
                        return _frames;
                }
               
                public function get fps():Number
                {
                        return _fps;
                }
               
                public function get numFrames():int
                {
                        return _numFrames;
                }
               
                public function get looped():Boolean
                {
                        return _looped;
                }
               
        }

}
