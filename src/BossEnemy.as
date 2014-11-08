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
            damage = 1;
            use_active_highlighter = false;
            this.canEscape = true;
            //this.attackOffset = new DHPoint(-200, -1 * (this.height / 3));
            this.attackOffset = new DHPoint(0,0);
            this.recoilPower = 0;

            addAnimation("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 12, true);
            play("run");
        }

        override public function update():void{
            super.update();
        }

        override public function die():void {
        }
    }
}
