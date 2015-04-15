package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;

    public class UIElement extends GameObject {
        private var _anchor:DHPoint;
        public var alerting:Boolean = false;

        public function UIElement(x:Number, y:Number) {
            this._anchor = new DHPoint(x, y);
            super(this._anchor);
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

        public function set anchor(pt:DHPoint):void {
            this._anchor = pt;
        }

        override public function toggleActive():void {
            if (!this.active) {
                this.active = true;
            }
        }

        override public function update():void {
            super.update();
            if (this.alerting) {
                this.y = this._anchor.y + 10 * Math.sin(.01 * GlobalTimer.getInstance().pausingTimer());
            } else {
                this.y = this._anchor.y;
            }
        }
    }
}
