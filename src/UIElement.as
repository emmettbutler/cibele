package {
    import org.flixel.*;

    public class UIElement extends GameObject {
        private var anchor:DHPoint;

        public function UIElement(x:Number, y:Number) {
            this.anchor = new DHPoint(x, y);
            super(this.anchor);
        }

        public function alert():void {
            this.y = this.anchor.y + 30 * Math.sin(.01 * GlobalTimer.getInstance().pausingTimer());
        }
    }
}
