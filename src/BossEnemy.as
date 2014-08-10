package
{
    import org.flixel.*;

    public class BossEnemy extends Enemy {
        [Embed(source="../assets/ikuturso_boss.png")] private var ImgBoss:Class;
        public function BossEnemy(pos:DHPoint) {
            super(pos);
            loadGraphic(ImgBoss, false, false, 300, 366);
            enemyType = "boss";
            hitpoints = 200;
            damage = 5;
        }

        override public function update():void{
            super.update();
            debugText.text = "BOSS";
        }
    }
}
