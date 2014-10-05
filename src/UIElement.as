package {
    import org.flixel.*;

    public class UIElement extends GameObject {
        private var anchor:DHPoint;
        public var alerting:Boolean = false;

        public function UIElement(x:Number, y:Number) {
            this.anchor = new DHPoint(x, y);
            super(this.anchor);
        }

        override public function update():void {
            super.update();
            if (this.alerting) {
                this.y = this.anchor.y + 30 * Math.sin(.01 * GlobalTimer.getInstance().pausingTimer());
            } else {
                this.y = this.anchor.y;
            }
        }
    }
}
