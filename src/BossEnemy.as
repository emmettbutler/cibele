package
{
    import org.flixel.*;

    public class BossEnemy extends Enemy {
        public function BossEnemy(pos:DHPoint) {
            super(pos);
        }

        override public function update():void{
            debugText.text = "BOSS";
        }

        override public function takeDamage(p:PartyMember):void{
            hitpoints -= 0;
        }
    }
}
