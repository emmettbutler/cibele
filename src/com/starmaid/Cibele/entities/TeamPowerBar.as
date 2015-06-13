package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class TeamPowerBar extends Meter {
        public function TeamPowerBar(maxPoints:Number) {
            super(new DHPoint(0, 0), maxPoints, 200, 40);
            this._barFrame.scrollFactor = new DHPoint(0, 0);
            this._innerBar.scrollFactor = new DHPoint(0, 0);
            this._changeText.setFormat("NexaBold-Regular", 25, 0xff7c6e6a,
                                       "left");
            this._changeText.scrollFactor = new DHPoint(0, 0);
            this.setVisible(true);
        }

        override public function setPos(pos:DHPoint):void {
            super.setPos(new DHPoint(100 + (this._outerWidth / 2), 400));
        }
    }
}
