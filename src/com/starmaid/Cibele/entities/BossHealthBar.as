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
                                       "center");
            this._changeText.scrollFactor = new DHPoint(0, 0);
        }

        override public function setPos(pos:DHPoint):void {
            var screenPos:DHPoint = new DHPoint(
                ScreenManager.getInstance().screenWidth / 2 - this._outerWidth / 2,
                ScreenManager.getInstance().screenHeight - 200
            );
            super.setPos(screenPos);
        }

        override public function setVisible(v:Boolean):void {
            if (!this.isVisible()) {
                super.setVisible(true);
            }
        }
    }
}
