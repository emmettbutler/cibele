package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.management.ScreenManager;

    import org.flixel.*;

    public class FallingObject extends GameObject {
        private var that:FallingObject;
        private var parentState:GameState;

        public function FallingObject(pos:DHPoint) {
            super(pos);
            this.scrollFactor = new DHPoint(0, 0);
            this.parentState = FlxG.state as GameState;
            this.setFallDir();
        }

        public function setFallDir():void {
            that = this;
            GlobalTimer.getInstance().setMark(
                "falling object " + Math.random() * 10000,
                (Math.random() * 90) * GameSound.MSEC_PER_SEC,
                function():void {
                    if (FlxG.state != that.parentState) {
                        return;
                    }
                    that.dir = new DHPoint(0, 4 + Math.random() * 3);
                }
            );
        }

        override public function toggleActive():void {
            this.active = true;
        }

        override public function update():void {
            super.update();

            if (this.pos.y >= ScreenManager.getInstance().screenHeight) {
                this.setPos(new DHPoint(
                    Math.random() * (ScreenManager.getInstance().screenWidth - this.frameWidth),
                    -1 * this.frameHeight
                ));
                this.setFallDir();
            }
        }
    }
}
