package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;

    public class IkuTursoBossTentacle extends GameObject {
        [Embed(source="/../assets/images/characters/ikuturso_boss_tentacle.png")] private var ImgBossTentacle:Class;

        public static const STATE_APPEARING:Number = 40;
        public static const STATE_STEADY:Number = 50;
        public static const STATE_DISAPPEARING:Number = 69;

        public var lifetimeSec:Number = 2;

        public function IkuTursoBossTentacle(pos:DHPoint) {
            super(pos);

            var frameRate:Number = 12;
            this.zSorted = true;

            this.loadGraphic(ImgBossTentacle, false, false, 435*.2, 1069*.2);
            this.addAnimation("appear",
                              [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                              frameRate, true);
            this.addAnimation("steady", [12, 13, 14, 15, 14, 13], frameRate, true);
            this.addAnimation("disappear",
                              [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
                              frameRate, true);

            FlxG.state.add(this);

            this._state = STATE_APPEARING;

            this.slug = "tentacle_" + (Math.random() * 100000).toString();

            var that:IkuTursoBossTentacle = this;
            GlobalTimer.getInstance().setMark(
                "tentacle_has_appeared_" + that.slug,
                1*GameSound.MSEC_PER_SEC,
                function():void {
                    that._state = STATE_STEADY;

                    GlobalTimer.getInstance().setMark(
                        "tentacle_lifetime_end_" + that.slug,
                        lifetimeSec*GameSound.MSEC_PER_SEC,
                        function():void {
                            that._state = STATE_DISAPPEARING;

                            GlobalTimer.getInstance().setMark(
                                "tentacle_has_disappeared_" + that.slug,
                                1*GameSound.MSEC_PER_SEC,
                                function():void {
                                    that.active = false;
                                    FlxG.state.remove(that);
                                }
                            );
                        }
                    );
                }
            );
        }

        override public function update():void{
            super.update();

            if(this._state == STATE_STEADY) {
                this.play("steady");
            } else if(this._state == STATE_APPEARING){
                this.play("appear");
            } else if(this._state == STATE_DISAPPEARING){
                this.play("disappear");
            }
        }
    }
}
