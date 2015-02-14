package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    public class HallwayTile extends GameObject {
        [Embed(source="/../assets/images/worlds/Single Animated tile.png")] private var ImgTile:Class;
        [Embed(source="/../assets/images/worlds/DarkTile.png")] private var ImgTileDark:Class;
        [Embed(source="/../assets/images/worlds/singletile.jpg")] private var ImgTileSingle:Class;

        public static const STATE_APPEARING:Number = 2394859384987;

        public function HallwayTile(pos:DHPoint, dim:DHPoint) {
            super(pos);

            var rand:Number = Math.floor(Math.random()*3);
            if(rand == 0) {
                this.loadGraphic(ImgTile, true, false, dim.x, dim.y);
                this.addAnimation("run", [0, 1, 2, 3, 4, 5], 12, true);
                this.play("run");
            } else if(rand == 1) {
                this.loadGraphic(ImgTileSingle, true, false, dim.x, dim.y);
            } else if(rand == 2) {
                this.loadGraphic(ImgTileDark, true, false, dim.x, dim.y);
            }

            rand = Math.floor(Math.random()*2);
            if(rand == 0) {
                this.angle = 0;
            } else if(rand == 1) {
                this.angle = 180;
            }

            this.visible = false;
            this.alpha = 0;
        }

        override public function update():void {
            super.update();

            if (!this.onScreen()) {
                this.active = false;
            } else {
                this.active = true;
            }

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
            if (this.scale != null) {
                this._state = STATE_APPEARING;
                if (Math.random() * 2 > 1) {
                    //this.play("run");
                } else {
                    this.active = false;
                }
            }
        }
    }
}
