package{
    import org.flixel.*;

    public class Player extends PartyMember {
        [Embed(source="../assets/cib_walk.png")] private var ImgCibWalk:Class;
        public var runSpeed:Number = 5;
        public var colliding:Boolean = false;
        public var lastPos:DHPoint;
        public var mapHitbox:FlxSprite;
        public var hitboxOffset:DHPoint, hitboxDim:DHPoint;

        public var dbgText:FlxText;

        public function Player(x:Number, y:Number):void{
            super(new DHPoint(x, y));

            loadGraphic(ImgCibWalk, false, false, 126, 134);

            this.hitboxOffset = new DHPoint(60, 80);
            this.hitboxDim = new DHPoint(40, 50);
            this.mapHitbox = new FlxSprite(x, y);
            this.mapHitbox.makeGraphic(this.hitboxDim.x, this.hitboxDim.y, 0xffff0000);

            this.dbgText = new FlxText(x, y, 200, "");
            this.dbgText.color = 0xffffffff;
            FlxG.state.add(this.dbgText);

            this.lastPos = new DHPoint(this.pos.x, this.pos.y);
            this.footstepOffset = new DHPoint(80, this.height);
        }

        override public function update():void{
            if (FlxG.keys.LEFT || FlxG.keys.RIGHT || FlxG.keys.UP || FlxG.keys.DOWN) {
                if(FlxG.keys.LEFT || FlxG.keys.RIGHT) {
                    if(FlxG.keys.LEFT) {
                        this.dir.x = -1 * runSpeed;
                        this.scale.x = 1;
                    }
                    if(FlxG.keys.RIGHT){
                        this.dir.x = runSpeed;
                        this.scale.x = -1;
                    }
                } else {
                    this.dir.x = 0;
                }

                if(FlxG.keys.UP || FlxG.keys.DOWN) {
                    if(FlxG.keys.UP){
                        this.dir.y = -1 * runSpeed;
                    }
                    if(FlxG.keys.DOWN){
                        this.dir.y = runSpeed;
                    }
                } else {
                    this.dir.y = 0;
                }
            } else {
                this.dir.x = 0;
                this.dir.y = 0;
            }

            if (this.colliding) {
                this.dir = this.lastPos.sub(this.pos).mulScl(1.1);
            }

            if (!this.lastPos.eq(this.pos)) {
                this.lastPos = new DHPoint(this.pos.x, this.pos.y);
            }
            super.update();

            if(FlxG.keys.justPressed("SPACE")){
                this.attack();
            }

            if (this._state == STATE_IN_ATTACK) {
                if (timeSinceLastAttack() > 100) {
                    this._state = STATE_IDLE;
                }
            }
        }

        override public function setPos(pos:DHPoint):void {
            super.setPos(pos);

            this.mapHitbox.x = pos.x + this.hitboxOffset.x;
            this.mapHitbox.y = pos.y + this.hitboxOffset.y;
        }
    }
}

