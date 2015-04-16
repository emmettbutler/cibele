package com.starmaid.Cibele.management {
    import org.flixel.*;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    public class LevelTracker {
        public static const LVL_IT:String = "it";
        public static const LVL_EU:String = "eu";
        public static const LVL_HI:String = "hi";
        private var cur_level:String = LVL_IT;

        private var saveFile:File
        private static const SAVE_FILE_NAME:String = "cibele_progress";

        public function LevelTracker() {
            this.saveFile = File.applicationStorageDirectory.resolvePath(
                SAVE_FILE_NAME);
        }

        public function get level():String {
            return this.cur_level;
        }

        public function set level(lvl:String):void {
            this.cur_level = lvl;
            this.saveProgress();
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

        private function saveProgress():void {
            var str:FileStream = new FileStream();
            str.open(this.saveFile, FileMode.WRITE);
            str.writeUTFBytes(this.cur_level);
            str.close();
        }

        public function loadProgress():void {
            var str:FileStream = new FileStream();
            if (!ScreenManager.getInstance().SAVES || !this.saveFile.exists) {
                return;
            }
            str.open(this.saveFile, FileMode.READ);
            var fileContents:String = str.readUTFBytes(this.saveFile.size);
            str.close();

            if (fileContents == LVL_IT) {
                this.cur_level = LVL_IT;
            } else if (fileContents == LVL_EU) {
                this.cur_level = LVL_EU;
            } else if (fileContents == LVL_HI) {
                this.cur_level = LVL_HI;
            }
        }
    }
}
