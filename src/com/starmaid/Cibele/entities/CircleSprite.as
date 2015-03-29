package com.starmaid.Cibele.entities {
    import flash.display.Sprite;

    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    public class CircleSprite extends GameObject {
        private var _radius:Number;

        public function CircleSprite(pos:DHPoint, radius:Number) {
            super(pos);

            this._radius = radius;
            this._draw();
        }

        public function get radius():Number {
            return this._radius;
        }

        public function set radius(r:Number):void {
            this._radius = r;
            this._draw();
        }

        public function _draw():void {
            this.makeGraphic(radius*2, radius*2, 0x00ffffff);

            var spr:Sprite = new Sprite();
            spr.graphics.beginFill(0xff0000, .1);
            spr.graphics.drawCircle(radius, radius, radius);
            this.framePixels.draw(spr);
        }
    }
}
