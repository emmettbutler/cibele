package {
    import flash.utils.Dictionary;

    public class GlobalTimer {
        public static var _instance:GlobalTimer = null;

        private var startTime:Number = -1;
        private var marks:Dictionary;
        private var totalPausedTime:Number = 0;
        private var pauseStart:Number = -1;

        private var paused:Boolean = false;

        public function GlobalTimer() {
            this.startTime = new Date().valueOf();
            this.marks = new Dictionary();
        }

        public function setMark(name:String, time:Number):void {
            // time to stop, start time, total pause between the two
            this.marks[name] = [time, new Date().valueOf(), 0];
        }

        public function hasPassed(name:String, start:Number=-1, end:Number=-1):Boolean {
            if (start == -1 || end == -1) {
                var thisMark:String, markData:Array;
                for (var key:Object in this.marks) {
                    thisMark = key as String;
                    if (thisMark == name) {
                        markData = this.marks[key];
                    }
                }
                start = markData[1];
                end = markData[0];
            }

            var cur:Number = new Date().valueOf();
            if (cur - start >= end) {
                return true;
            }
            return false;
        }

        public function pause():void {
            var cur:Number = new Date().valueOf();
            if (!this.paused) {
                this.pauseStart = cur;
            } else {
                this.totalPausedTime += cur - this.pauseStart;
            }

            var thisMark:String, markData:Array;
            for (var key:Object in this.marks) {
                thisMark = key as String;
                if (thisMark == name) {
                    markData = this.marks[key];
                    if (!this.hasPassed(markData[1], markData[0])) {
                        markData[2] += cur - this.pauseStart;
                    }
                }
            }

            this.paused = !this.paused;
        }

        public function getTotalTime():Number {
            return new Date().valueOf() - this.startTime;
        }

        public static function getInstance():GlobalTimer {
            if (_instance == null) {
                _instance = new GlobalTimer();
            }
            return _instance;
        }
    }
}
