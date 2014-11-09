package
{
    import org.flixel.*;

    public class BossEnemy extends Enemy {
        [Embed(source="../assets/boss1.png")] private var ImgBoss:Class;

        public var hasAppeared:Boolean = false;

        public function BossEnemy(pos:DHPoint) {
            super(pos);
            loadGraphic(ImgBoss, false, false, 5613/11, 600);
            enemyType = "boss";
            hitpoints = 600;
            sightRange = 750;
            damage = .5;
            use_active_highlighter = false;
            this.canEscape = true;
            //this.attackOffset = new DHPoint(-200, -1 * (this.height / 3));
            this.attackOffset = new DHPoint(0,0);
            this.recoilPower = 0;
            this.alpha = 0;

            addAnimation("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 12, true);
            play("run");
        }

        override public function update():void{
            super.update();
            if(this.dead) {
                this.die();
            } else if (this.hitpoints < 10) {
                this.hitpoints = 200;
            } else if(!this.dead && this.alpha < 1 && this.hasAppeared) {
                this.alpha += .01;
            }
        }

        override public function die():void {
            if(this.alpha > 0) {
                this.alpha -= .01;
            } else {
                this.alpha = 0;
            }

        }
    }
}
