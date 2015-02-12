package {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;

    public class UIElement extends GameObject {
        private var anchor:DHPoint;
        public var alerting:Boolean = false;

        public function UIElement(x:Number, y:Number) {
            this.anchor = new DHPoint(x, y);
            super(this.anchor);
        }

        public static function fromPoint(pos:DHPoint):UIElement {
            return new UIElement(pos.x, pos.y);
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
