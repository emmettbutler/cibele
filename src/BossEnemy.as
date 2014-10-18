package
{
    import org.flixel.*;

    public class BossEnemy extends Enemy {
        [Embed(source="../assets/boss1.png")] private var ImgBoss:Class;

        public function BossEnemy(pos:DHPoint) {
            super(pos);
            loadGraphic(ImgBoss, false, false, 5613/11, 600);
            enemyType = "boss";
            hitpoints = 300;
            damage = 0;

            addAnimation("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 12, true);
            play("run");
        }

        override public function update():void{
            super.update();
            if (this.playerDisp._length() > 208 ||
                this.playerDisp._length() < 10)
            {
                this._state = STATE_IDLE;
            } else {
                this._state = STATE_TRACKING;
            }
            this.disp = this.player.footPos.sub(this.pos.add(new DHPoint(this.width, this.height/2)));
            this.dir = this.disp.normalized().mulScl(2);
        }
    }
}
