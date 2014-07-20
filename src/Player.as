package{
    import org.flixel.*;

    public class Player extends PartyMember {
        [Embed(source="../assets/cib_walk.png")] private var ImgCibWalk:Class;
        public var runSpeed:Number = 5;

        public var lastAttackTime:Number = 0;

        public var img_height:Number = 357;
        public var dbgText:FlxText;

        public function Player(x:Number, y:Number):void{
            super(new DHPoint(x,y));
            loadGraphic(ImgCibWalk,false,false,126,134);
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
            if(FlxG.keys.justPressed("SPACE")){
                this.attack();
            }

            if (this._state == STATE_IN_ATTACK) {
                if (timeSinceLastAttack() > 100) {
                    this._state = STATE_IDLE;
                }
            }
        }

        public function timeSinceLastAttack():Number {
            return this.currentTime - this.lastAttackTime;
        }

        public function canAttack():Boolean {
            return this.timeSinceLastAttack() > 2*MSEC_PER_SEC;
        }

        public function attack():void {
            if (this.canAttack()) {
                this._state = STATE_IN_ATTACK;
                this.lastAttackTime = this.currentTime;
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

