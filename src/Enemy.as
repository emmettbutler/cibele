package
{
    import org.flixel.*;

    public class Enemy extends GameObject {
        [Embed(source="../assets/ikuturso_enemy_1.png")] private var ImgIT1:Class;
        public var hitpoints:Number = 20;
        public var damage:Number = 2;

        public var STATE_IDLE:Number = 0;
        public var STATE_DAMAGED:Number = 1;
        public var STATE_ATTACK:Number = 2;
        public var STATE_TRACKING:Number = 3;
        public var state:Number = STATE_IDLE;
        public var debugText:FlxText;
        public var dead:Boolean = false;

        public function Enemy(pos:DHPoint) {
            super(pos);
            loadGraphic(ImgIT1,false,false,151,104);
            debugText = new FlxText(pos.x, pos.y, 100, "");
            debugText.color = 0xff0000ff;
            FlxG.state.add(debugText);
        }

        public function playerTracking(p:Player):void{
            var disp:DHPoint = p.pos.sub(this.pos);
            this.setPos(disp.normalized().add(this.pos));
        }

        public function takeDamage():void{
            hitpoints -= 20;
            if(hitpoints < 0){
                FlxG.state.remove(this);
                FlxG.state.remove(this.debugText);
                this.dead = true;
                this.destroy();
            }
        }

        override public function update():void{
            debugText.x = pos.x;
            debugText.y = pos.y-10;
            debugText.text = "HP: " + hitpoints;
        }
    }
}
