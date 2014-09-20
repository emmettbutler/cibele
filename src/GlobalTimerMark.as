package {
    public class GlobalTimerMark {
        public var start:Number, end:Number, pauseTime:Number;
        public var callback:Function;
        public var name:String;
        public var finished:Boolean;

        public function GlobalTimerMark(name:String, start:Number, end:Number,
                                        pauseTime:Number, callback:Function) {
            this.name = name;
            this.start = start;
            this.end = end;
            this.pauseTime = pauseTime;
            this.callback = callback;
            this.finished = new Date().valueOf() - this.start >= this.end;
        }

        public function timeIsUp():void {
            var cur:Number = new Date().valueOf();
            if (cur - this.start - this.pauseTime >= this.end) {
                return true;
            }
            return false;
        }

        public function finish():void {
            this.finished = true;
            if (this.callback != null) {
                this.callback();
            }
        }

        public function update():void {
            if (this.timeIsUp()) {
                this.finish();
            }
        }
    }
}
