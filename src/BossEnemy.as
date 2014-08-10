package
{
    import org.flixel.*;

    public class BossEnemy extends Enemy {
        public function BossEnemy(pos:DHPoint) {
            super(pos);
            makeGraphic(300, 300, 0xffff0000);
            enemyType = "boss";
        }

        override public function update():void{
            super.update();
            debugText.text = "BOSS";
        }

        override public function takeDamage(p:PartyMember):void{
            hitpoints -= 0;
        }
    }
}
