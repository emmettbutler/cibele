package com.starmaid.Cibele.utils {
    import org.flixel.*;

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

        public function isPaused():Boolean {
            return this.paused;
        }

        public function setMark(name:String, time:Number,
                                callback:Function=null,
                                overwrite:Boolean=false):void
        {
            var existing:GlobalTimerMark = this.marks[name];
            if (existing != null && !overwrite) {
                return;
            }
            delete this.marks[name];
            this.marks[name] = new GlobalTimerMark(name, time,
                                                   new Date().valueOf(),
                                                   0, callback);
        }

        public function deleteMark(name:String):void {
            var existing:GlobalTimerMark = this.marks[name];
            if(existing == null) {
                return;
            } else {
                delete this.marks[name];
            }
        }

        public function timeRemaining(name:String):Number {
            return this.marks[name].timeRemaining();
        }

        public function timeElapsed(name:String):Number {
            return this.marks[name].timeElapsed();
        }

        public function hasPassed(name:String):Boolean {
            var mark:GlobalTimerMark = this.marks[name];
            if (mark != null) {
                return mark.finished;
            }
            return false;
        }

        public function resume():void {
            var cur:Number = new Date().valueOf();
            this.totalPausedTime += cur - this.pauseStart;
            for (var key:Object in this.marks) {
                this.marks[key].pause(cur, this.pauseStart);
            }
            this.paused = false;
        }

        public function pause():void {
            var cur:Number = new Date().valueOf();
            this.pauseStart = cur;
            for (var key:Object in this.marks) {
                this.marks[key].pause(cur, -1);
            }
            this.paused = true;
        }

        public function pausingTimer():Number {
            if (this.paused) {
                return this.pauseStart;
            }
            return this.getTotalTime();
        }

        public function getTotalTime():Number {
            return new Date().valueOf() - this.startTime - this.totalPausedTime;
        }

        public function update():void {
            var curMark:GlobalTimerMark;
            for (var key:Object in this.marks) {
                curMark = this.marks[key as String];
                curMark.update();
            }
        }

        public static function resetInstance():void {
            _instance = new GlobalTimer();
        }


        public static function getInstance():GlobalTimer {
            if (_instance == null) {
                _instance = new GlobalTimer();
            }
            return _instance;
        }
    }
}
