package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.management.ScreenManager;

    import org.flixel.*;

    public class UIElement extends GameObject {
        private var _anchor:DHPoint, _rightBottomDisp:DHPoint;
        public var alerting:Boolean = false;

        public function UIElement(x:Number, y:Number) {
            this._anchor = new DHPoint(x, y);
            super(this._anchor);
            var _btr:DHPoint = new DHPoint(
                ScreenManager.getInstance().screenWidth,
                ScreenManager.getInstance().screenHeight
            );
            this._rightBottomDisp = _btr.sub(this.pos);
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

        public function updatePos():void {
            var _btr:DHPoint = new DHPoint(
                ScreenManager.getInstance().screenWidth,
                ScreenManager.getInstance().screenHeight
            );
            var newPos:DHPoint = _btr.sub(this._rightBottomDisp);
            newPos.x = Math.max(5, newPos.x);
            newPos.y = Math.max(5, newPos.y);
            this.setPos(newPos);
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
