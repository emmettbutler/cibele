package
{
    import org.flixel.*;

    public class SmallEnemy extends Enemy {

        public function SmallEnemy(new_pos:DHPoint) {
            super(new_pos);
            pos = new DHPoint(new_pos.x,new_pos.y);
            debugText = new FlxText(pos.x,pos.y-20,100,"");
            debugText.color = 0xffffffff;
            FlxG.state.add(debugText);
        }

        override public function update():void{
            super.update();
            pos.x = x;
            pos.y = y;
        }
    }
}
