package com.starmaid.Cibele.management {
    import org.flixel.*;

    public class LevelTracker {
        public static const LVL_IT:String = "it";
        public static const LVL_EU:String = "eu";
        public static const LVL_HI:String = "hi";
        private var cur_level:String = LVL_IT;

        public function LevelTracker() {
        }

        public function get level():String {
            return this.cur_level;
        }

        public function set level(lvl:String):void {
            this.cur_level = lvl;
        }

        public function it():Boolean {
            return this.cur_level == LVL_IT;
        }

        public function eu():Boolean {
            return this.cur_level == LVL_EU;
        }

        public function hi():Boolean {
            return this.cur_level == LVL_HI;
        }
    }
}
