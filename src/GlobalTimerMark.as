package {
    import org.flixel.*;

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

        public function timeRemaining():Number {
            var cur:Number = new Date().valueOf();
            return this.end - (cur - this.start - this.pauseTime);
        }

        public function timeIsUp():Boolean {
            return this.timeRemaining() <= 0;
        }

        public function finish():void {
            this.finished = true;
            if (this.callback != null) {
                this.callback();
            }
        }

        public function update():void {
            if (!GlobalTimer.getInstance().isPaused() && this.timeIsUp()) {
                this.finish();
            }
        }

        public function pause(cur:Number, pauseStart:Number=-1):void {
            if (pauseStart != -1) {
                this.pauseTime += cur - pauseStart;
            }
        }
    }
}
