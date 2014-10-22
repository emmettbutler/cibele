package {
    import org.flixel.*;

    public class BouncingText extends FlxText {
        private var anchor:DHPoint;
        public var alerting:Boolean = false;

        public function BouncingText(x:Number, y:Number, width:Number, t:String) {
            this.anchor = new DHPoint(x, y);
            super(x, y, width, t);
        }

        public function alertOn():void {
            this.alerting = true;
        }

        public function alertOff():void {
            this.alerting = false;
        }

        override public function update():void {
            super.update();
            if (this.alerting) {
                this.y = this.anchor.y + 10 * Math.sin(.01 * GlobalTimer.getInstance().pausingTimer());
            } else {
                this.y = this.anchor.y;
            }
        }
    }
}
