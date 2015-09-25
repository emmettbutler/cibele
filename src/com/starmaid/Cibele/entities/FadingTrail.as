package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class FadingTrail extends GameObject {
        public var sprites:Array;
        public var count:Number;
        public var interval:Number;
        public var target_:GameObject;

        public function FadingTrail(tar:GameObject) {
            super(ZERO_POINT);

            this.sprites = new Array();
            this.count = 4;
            this.interval = 300;
            this.target_ = tar;
            this.slug = "fadingtrail" + Math.random() * 10000000;
            this.setupSprites();

            GlobalTimer.getInstance().setMark(
                this.slug,
                this.interval,
                this.timerCallback,
                true
            );
        }

        public function setupSprites():void { }

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

        public function getNextPos():DHPoint {
            return this.target_.pos;
        }

        override public function update():void {
            super.update();

            for (var i:int = 0; i < this.sprites.length; i++) {
                this.sprites[i].update();
            }
        }

        public function placeStep():void {
            var cur:ExpiringGameObject, oldest:ExpiringGameObject;
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
            oldest.place(this.getNextPos());
            this.angleStep(oldest);
        }

        public function angleStep(spr:ExpiringGameObject):void {
            var theta:Number = Math.atan2(this.target_.dir.y, this.target_.dir.x);
            var deg:Number = theta * 180 / Math.PI;
            spr.angle = deg + 90;
        }
    }
}
