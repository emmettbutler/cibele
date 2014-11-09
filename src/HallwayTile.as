package {
    public class HallwayTile extends GameObject {
        [Embed(source="../assets/Single Animated tile.png")] private var ImgTile:Class;

        public static const STATE_APPEARING:Number = 2394859384987;

        public function HallwayTile(pos:DHPoint, dim:DHPoint) {
            super(pos);
            this.loadGraphic(ImgTile, true, false, dim.x, dim.y);
            this.addAnimation("run", [0, 1, 2, 3, 4, 5], 12, true);
            this.play("run");
            this.active = false;
            this.visible = false;
            this.alpha = 0;
        }

        override public function update():void {
            super.update();

            if (this._state == STATE_APPEARING) {
                if (!this.visible) {
                    this.visible = true;
                }
                if (this.alpha < 1) {
                    this.alpha += .06;
                } else {
                    this._state = STATE_IDLE;
                }
            }
        }

        public function appear():void {
            this._state = STATE_APPEARING;
        }
    }
}
