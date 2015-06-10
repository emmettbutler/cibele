package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.ScreenManager;

    import org.flixel.*;

    public class BossHealthBar extends HealthBar {
        public function BossHealthBar(maxPoints:Number) {
            super(new DHPoint(0, 0),
                  maxPoints,
                  ScreenManager.getInstance().screenWidth * .7,
                  10
            );
            this._barFrame.scrollFactor = new DHPoint(0, 0);
            this._attackIcon.scrollFactor = new DHPoint(0, 0);
            this._innerBar.scrollFactor = new DHPoint(0, 0);
            this._changeText.setFormat("NexaBold-Regular", 25, 0xff7c6e6a,
                                       "left");
            this._changeText.scrollFactor = new DHPoint(0, 0);

            this.setVisible(false);
        }

        override public function setPos(pos:DHPoint):void {
            var screenPos:DHPoint = new DHPoint(
                ScreenManager.getInstance().screenWidth / 2,
                ScreenManager.getInstance().screenHeight - 150
            );
            super.setPos(screenPos);
        }
    }
}
