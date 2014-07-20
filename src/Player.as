package{
    import org.flixel.*;

    public class Player extends GameObject {
        public var runSpeed:Number = 10;

        public var STATE_IDLE:Number = 0;
        public var STATE_ATTACK:Number = 1;
        public var state:Number = STATE_IDLE;

        public var lastAttackTime:Number = 0;

        public var img_height:Number = 357;
        public var dbgText:FlxText;

        public function Player(x:Number, y:Number):void{
            super(new DHPoint(x,y));
            makeGraphic(50, 50, 0xffff0000);
            FlxG.state.add(this);

            this.dbgText = new FlxText(x, y, 200, "");
            this.dbgText.color = 0xffffffff;
            FlxG.state.add(this.dbgText);

            /*addAnimation("run", [2,3], 14, true);
            addAnimation("runFront", [0,1], 14, true);
            addAnimation("standing", [0]);
            addAnimation("runBack", [4,5], 14, true);
            addAnimation("standingBack", [4]);
            play("standingBack");*/
        }

        override public function update():void{
            super.update();
            pos.x = x;
            pos.y = y;

            this.dbgText.text = this.pos.x + "x" + this.pos.y;
            this.dbgText.x = x;
            this.dbgText.y = y;
            //borderCollide();

            if(FlxG.keys.LEFT) {
                x -= runSpeed;
                //play("run");
            }
            if(FlxG.keys.RIGHT){
                x += runSpeed;
                //play("run");
            }
            if(FlxG.keys.UP){
                y -= runSpeed;
                //play("runBack");
            }
            if(FlxG.keys.DOWN){
                y += runSpeed;
                //play("runFront");
            }
            if(FlxG.keys.justPressed("UP")){
                //play("standingBack");
            }
            if(FlxG.keys.justPressed("DOWN")){
                //play("standing");
            }

            if (state == STATE_ATTACK) {
                if (timeSinceLastAttack() > 100) {
                    state = STATE_IDLE;
                }
            }
        }

        public function timeSinceLastAttack():Number {
            return this.currentTime - this.lastAttackTime;
        }

        public function canAttack():Boolean {
            return this.timeSinceLastAttack() > 2*MSEC_PER_SEC;
        }

        public function attack(e:Enemy):void {
            if(pos.sub(e.pos)._length() < 100){
                if (this.canAttack()) {
                    this.state = STATE_ATTACK;
                    e.takeDamage();
                    this.lastAttackTime = this.currentTime;
                }
            }
        }

        public function borderCollide():void{
            if(this.x >= FlxG.width - width) {
                this.x = FlxG.width - width;
            }
            if(this.x <= 0) {
                this.x = 0;
            }
            if(this.y >= (FlxG.height - ((FlxG.height-img_height)/2)) - height) {
                this.y = (FlxG.height - ((FlxG.height-img_height)/2)) - height;
            }
            if(this.y <= (0 + ((FlxG.height-img_height)/2))) {
                this.y = (0 + ((FlxG.height-img_height)/2));
            }
        }
    }
}

