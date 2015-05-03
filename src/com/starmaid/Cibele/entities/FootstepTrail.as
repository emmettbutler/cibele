package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;

    public class FootstepTrail extends GameObject {
        public var sprites:Array;
        public var count:Number;
        public var interval:Number, lastTick:Number;
        public var target_:PartyMember;

        public function FootstepTrail(tar:PartyMember) {
            super(ZERO_POINT);

            this.sprites = new Array();
            this.count = 17;
            this.interval = 300;
            this.lastTick = 0;
            this.target_ = tar;
            this.slug = "footsteptrail" + Math.random() * 10000000;

            var spr:Footstep;
            for (var i:int = 0; i < this.count; i++) {
                if(this.target_ is Player) {
                    spr = new Footstep(Footstep.BLUE);
                } else {
                    spr = new Footstep(Footstep.PURPLE);
                }

                this.sprites.push(spr);
            }

            GlobalTimer.getInstance().setMark(
                this.slug,
                this.interval,
                this.timerCallback,
                true
            );
        }

        public function timerCallback():void {
            if (!this.target_.dir.eq(ZERO_POINT)) {
                this.placeStep();
            }

            GlobalTimer.getInstance().setMark(
                this.slug,
                this.interval,
                this.timerCallback,
                true
            );
        }

        override public function update():void {
            super.update();

            for (var i:int = 0; i < this.sprites.length; i++) {
                this.sprites[i].update();
            }
        }

        public function placeStep():void {
            var cur:Footstep, oldest:Footstep;
            for (var i:int = 0; i < this.sprites.length; i++) {
                cur = this.sprites[i];
                if (oldest == null || cur.age > oldest.age) {
                    oldest = cur;
                }
            }
            if (oldest.scale == null) {
                return;
            }
            oldest.scale.x = -1;
            cur.scale.x = 1;
            oldest.place(this.target_.pos.add(this.target_.footstepOffset));
            this.angleStep(oldest);
        }

        public function angleStep(spr:Footstep):void {
            var theta:Number = Math.atan2(this.target_.dir.y, this.target_.dir.x);
            var deg:Number = theta * 180 / Math.PI;
            spr.angle = deg + 90;
        }
    }
}
