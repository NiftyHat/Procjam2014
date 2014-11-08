 package axengine.world.level
{
        import com.p3.utils.functions.P3BytesToXML;
        import flash.utils.ByteArray;
        import org.flixel.FlxBasic;
        import org.flixel.FlxGroup;
        import org.flixel.FlxObject;
        /**
         * ...
         * @author Duncan Saunders
         */
        public class AxLevelArea
        {
                private var m_key:String;
                private var m_xml:XML;
               
                public function AxLevelArea($xml:XML):void
                {
                        m_xml = $xml;
                        m_key = m_xml.@key.toString();
                }
               
                public function toString ():String
                {
                        return "[Area" + " Name: " + m_key + " Size:" + m_xml.length() + "]";
                }
               
                public function get xml():XML { return m_xml; }
               
                public function get key():String { return m_key; }
        }

}
