package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.management.ScreenManager;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class IkuTursoBossTentacle extends GameObject {
        [Embed(source="/../assets/images/characters/ikuturso_boss_tentacle.png")] private var ImgBossTentacle:Class;

        public static const STATE_APPEARING:Number = 40;
        public static const STATE_STEADY:Number = 50;
        public static const STATE_DISAPPEARING:Number = 69;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_APPEARING] = "STATE_APPEARING";
            stateMap[STATE_STEADY] = "STATE_STEADY";
            stateMap[STATE_DISAPPEARING] = "STATE_DISAPPEARING";
            stateMap[STATE_NULL] = "STATE_NULL";
        }

        public var lifetimeSec:Number = 2;

        public function IkuTursoBossTentacle(pos:DHPoint) {
            super(pos);

            this.basePos = new DHPoint(0, 0);

            var frameRate:Number = 16;
            this.zSorted = true;

            this.loadGraphic(ImgBossTentacle, false, false, 435*.2, 1069*.2);
            this.addAnimation("appear",
                              [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                              frameRate, false);
            this.addAnimation("steady", [12, 13, 14, 15, 14, 13], frameRate, true);
            this.addAnimation("disappear",
                              [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
                              frameRate, false);

            this._state = STATE_NULL;
            this.visible = false;
            this.slug = "tentacle_" + (Math.random() * 100000).toString();
        }

        override public function toggleActive():void {
            this.active = this.isOnscreen();
        }

        public function appear():void {
            if (this.scale == null) {
                return;
            }
            this._state = STATE_APPEARING;
            this.play("appear");
            this.visible = true;
            this.slug = "tentacle_" + (Math.random() * 100000).toString();

            GlobalTimer.getInstance().setMark(
                "tentacle_has_appeared_" + this.slug,
                .8*GameSound.MSEC_PER_SEC,
                this.enterSteadyState
            );
        }

        public function enterSteadyState():void {
            if (this.scale == null) {
                return;
            }
            this._state = STATE_STEADY;
            this.play("steady");

            GlobalTimer.getInstance().setMark(
                "tentacle_lifetime_end_" + this.slug,
                lifetimeSec*GameSound.MSEC_PER_SEC,
                this.leaveSteadyState
            );
        }

        public function leaveSteadyState():void {
            if (this.scale == null) {
                return;
            }
            this._state = STATE_DISAPPEARING;
            this.play("disappear");

            GlobalTimer.getInstance().setMark(
                "tentacle_has_disappeared_" + this.slug,
                .8*GameSound.MSEC_PER_SEC,
                this.makeInactive
            );
        }

        public function makeInactive():void {
            if (this.scale == null) {
                return;
            }
            this._state = STATE_NULL;
            this.visible = false;
        }

        override public function update():void{
            super.update();

            this.basePos.x = this.pos.x + this.width / 2;
            this.basePos.y = this.pos.y + this.height;

            if(ScreenManager.getInstance().DEBUG) {
                this.debugText.text = this._state in IkuTursoBossTentacle.stateMap ? IkuTursoBossTentacle.stateMap[this._state] : "unknown";
            }
        }
    }
}
