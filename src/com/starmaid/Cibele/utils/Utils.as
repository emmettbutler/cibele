package com.starmaid.Cibele.utils {
    public class Utils {
        public static function radToDeg(radians:Number):Number {
            return radians * 180 / Math.PI;
        }

        public static function degToRad(degrees:Number):Number {
            return degrees * Math.PI / 180;
        }

        public static function interpolate(normValue:Number, minimum:Number,
                                           maximum:Number):Number {
            return minimum + (maximum - minimum) * normValue;
        }
    }
}
