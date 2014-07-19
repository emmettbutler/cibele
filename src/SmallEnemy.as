package
{
    import org.flixel.*;

    public class SmallEnemy extends Enemy {
        public var hitpoints:Number = 20;
        public var damage:Number = 2;

        public var STATE_IDLE:Number = 0;
        public var STATE_DAMAGED:Number = 1;
        public var STATE_ATTACK:Number = 2;
        public var state:Number = STATE_IDLE;
        public var debugText:FlxText;

        public function SmallEnemy(pos:DHPoint) {
            super(pos);
            debugText = new FlxText(pos.x,pos.y-20,100,"");
            FlxG.state.add(debugText);
        }

        override public function update():void{
            debugText.x = pos.x;
            debugText.y = pos.y-20;
            debugText.text = hitpoints + "";

            if(state == STATE_DAMAGED){
                hitpoints -= damage;
                state = STATE_IDLE;
            }
        }
    }
}
