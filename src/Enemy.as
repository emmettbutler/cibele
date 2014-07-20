package
{
    import org.flixel.*;

    public class Enemy extends GameObject {
        public var hitpoints:Number = 20;
        public var damage:Number = 2;

        public var STATE_IDLE:Number = 0;
        public var STATE_DAMAGED:Number = 1;
        public var STATE_ATTACK:Number = 2;
        public var STATE_TRACKING:Number = 3;
        public var state:Number = STATE_IDLE;
        public var debugText:FlxText;

        public function Enemy(pos:DHPoint) {
            super(pos);
            makeGraphic(10, 10, 0xff00ff00);
            debugText = new FlxText(pos.x, pos.y, 100, "");
            debugText.color = 0xff000000;
            FlxG.state.add(debugText);
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
            if(hitpoints < 0){
                FlxG.state.remove(this);
                this.destroy();
            }
        }

        override public function update():void{
            debugText.x = pos.x;
            debugText.y = pos.y;
            debugText.text = "HP: " + hitpoints;
        }
    }
}
