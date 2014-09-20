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

        public function setMark(name:String, time:Number,
                                callback:Function=null):void {
            this.marks[name] = new GlobalTimerMark(name, time, new Date().valueOf(),
                                                   0, callback);
        }

        public function hasPassed(name:String):Boolean {
            return this.marks[name].finished;

            var markData:GlobalTimerMark = this.marks[name];
            start = markData.start;
            end = markData.end;

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
                var markData:GlobalTimerMark;
                for (var key:Object in this.marks) {
                    markData = this.marks[key as String];
                    if (!markData.finished) {
                        markData.pauseTime += cur - this.pauseStart;
                    }
                }
            }

            this.paused = !this.paused;
        }

        public function getTotalTime():Number {
            return new Date().valueOf() - this.startTime;
        }

        public function update():void {
            for (var key:Object in this.marks) {
                (this.marks[key as String] as GlobalTimerMark).update();
            }
        }

        public static function getInstance():GlobalTimer {
            if (_instance == null) {
                _instance = new GlobalTimer();
            }
            return _instance;
        }
    }
}
