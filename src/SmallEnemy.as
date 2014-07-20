package
{
    import org.flixel.*;

    public class SmallEnemy extends Enemy {
        public var hitpoints:Number = 20;
        public var damage:Number = 2;

        public var STATE_IDLE:Number = 0;
        public var STATE_DAMAGED:Number = 1;
        public var STATE_ATTACK:Number = 2;
        public var STATE_TRACKING:Number = 3;
        public var state:Number = STATE_IDLE;
        public var debugText:FlxText;

        public function SmallEnemy(new_pos:DHPoint) {
            super(new_pos);
            pos = new DHPoint(new_pos.x,new_pos.y);
            debugText = new FlxText(pos.x,pos.y-20,100,"");
            debugText.color = 0xffffffff;
            FlxG.state.add(debugText);
        }

        override public function update():void{
            pos.x = x;
            pos.y = y;

            if(hitpoints < 0){
                FlxG.state.remove(this);
                this.destroy();
            }
        }

        public function playerTracking(p:Player):void{
            var disp:DHPoint = p.pos.sub(this.pos);
            this.setPos(disp.normalized().add(this.pos));
        }

        public function setPos(pos:DHPoint):void {
            this.pos = pos;
            this.x = pos.x;
            this.y = pos.y;
        }

        public function takeDamage():void{
            hitpoints -= 20;
        }
    }
}
