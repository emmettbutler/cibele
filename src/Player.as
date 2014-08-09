package{
    import org.flixel.*;

    public class Player extends PartyMember {
        [Embed(source="../assets/cib_walk.png")] private var ImgCibWalk:Class;
        public var runSpeed:Number = 5;
        public var dir:DHPoint;
        public var colliding:Boolean = false;

        public var img_height:Number = 357;
        public var dbgText:FlxText;

        public function Player(x:Number, y:Number):void{
            super(new DHPoint(x,y));
            loadGraphic(ImgCibWalk,false,false,126,134);
            FlxG.state.add(this);

            this.dbgText = new FlxText(x, y, 200, "");
            this.dbgText.color = 0xffffffff;
            FlxG.state.add(this.dbgText);

            this.dir = new DHPoint(0, 0);
        }

        override public function update():void{
            super.update();

            this.dbgText.text = this.pos.x + "x" + this.pos.y;
            this.dbgText.x = x;
            this.dbgText.y = y;

            if (FlxG.keys.LEFT || FlxG.keys.RIGHT || FlxG.keys.UP || FlxG.keys.DOWN) {
                if(FlxG.keys.LEFT) {
                    this.dir.x = -1 * runSpeed;
                }
                if(FlxG.keys.RIGHT){
                    this.dir.x = runSpeed;
                }
                if(FlxG.keys.UP){
                    this.dir.y = -1 * runSpeed;
                }
                if(FlxG.keys.DOWN){
                    this.dir.y = runSpeed;
                }
            } else {
                this.dir.x = 0;
                this.dir.y = 0;
            }

            if (!this.colliding) {
                this.x += this.dir.x;
                this.y += this.dir.y;
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

