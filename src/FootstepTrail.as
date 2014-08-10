package {
    import org.flixel.*;

    public class FootstepTrail extends GameObject {
        public var sprites:Array;
        public var count:Number;
        public var interval:Number, lastTick:Number;
        public var target_:PartyMember;

        public function FootstepTrail(tar:PartyMember) {
            super(ZERO_POINT);

            this.sprites = new Array();
            this.count = 20;
            this.interval = 100;
            this.lastTick = 0;
            this.target_ = tar;

            var spr:Footstep;
            for (var i:int = 0; i < this.count; i++) {
                spr = new Footstep();
                this.sprites.push(spr);
            }
        }

        override public function update():void {
            super.update();

            for (var i:int = 0; i < this.sprites.length; i++) {
                this.sprites[i].update();
            }
            if (!this.target_.dir.eq(ZERO_POINT)
                && this.timeAlive - this.lastTick > this.interval)
            {
                this.lastTick = this.timeAlive;
                this.placeStep();
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
            oldest.setPos(this.target_.pos.add(this.target_.footstepOffset));
            this.angleStep(oldest);
        }

        public function angleStep(spr:Footstep):void {
            var theta:Number = Math.atan2(this.target_.dir.y, this.target_.dir.x);
            var deg:Number = theta * 180 / Math.PI;
            spr.angle = deg + 90;
        }
    }
}
