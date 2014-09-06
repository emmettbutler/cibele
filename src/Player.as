package{
    import org.flixel.*;

    public class Player extends PartyMember {
        [Embed(source="../assets/c_walk.png")] private var ImgCibWalk:Class;

        public var runSpeed:Number = 4;
        public var colliding:Boolean = false;
        public var hitbox_rect:FlxRect;
        public var lastPos:DHPoint;
        public var mapHitbox:FlxSprite;
        public var hitboxOffset:DHPoint, hitboxDim:DHPoint;
        public var collisionDirection:Array;

        public function Player(x:Number, y:Number):void{
            super(new DHPoint(x, y));

            loadGraphic(ImgCibWalk, true, false, 4032/28, 150);
            addAnimation("walk_l", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 20, false);
            addAnimation("walk_r", [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], 20, false);
            addAnimation("idle", [11], 7, false);
            addAnimation("attack", [0, 1], 7, true);

            this.hitboxOffset = new DHPoint(60, 100);
            this.hitboxDim = new DHPoint(40, 50);
            this.mapHitbox = new FlxSprite(x, y);
            this.mapHitbox.makeGraphic(this.hitboxDim.x, this.hitboxDim.y, 0xffff0000);
            this.hitbox_rect = new FlxRect(this.pos.x, this.pos.y, this.mapHitbox.width, this.mapHitbox.height);

            this.lastPos = new DHPoint(this.pos.x, this.pos.y);
            this.footstepOffset = new DHPoint(80, this.height);
        }

        override public function update():void{
            this.hitbox_rect.x = this.pos.x;
            this.hitbox_rect.y = this.pos.y;

            if (FlxG.keys.LEFT || FlxG.keys.RIGHT || FlxG.keys.UP || FlxG.keys.DOWN) {
                if(FlxG.keys.LEFT || FlxG.keys.RIGHT) {
                    if(FlxG.keys.LEFT) {
                        play("walk_l");
                        this.dir.x = -1 * runSpeed;
                        this.offset.x = 63;
                        this.hitboxOffset.x = 10;
                        this.footstepOffset.x = 2;
                    }
                    if(FlxG.keys.RIGHT){
                        play("walk_r");
                        this.dir.x = runSpeed;
                        this.offset.x = 0;
                        this.hitboxOffset.x = 30;
                        this.footstepOffset.x = 20;
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
                play("idle");
            }

            if (this.colliding) {
                if (this.collisionDirection != null) {
                    if (this.dir.x > 0 && this.collisionDirection[1] == 1) {
                        // right
                        this.dir.x = 0;
                    } else if (this.dir.x < 0 && this.collisionDirection[0] == 1) {
                        // left
                        this.dir.x = 0;
                    }
                    if (this.dir.y > 0 && this.collisionDirection[3] == 1) {
                        // down
                        this.dir.y = 0;
                    } else if (this.dir.y < 0 && this.collisionDirection[2] == 1) {
                        // up
                        this.dir.y = 0;
                    }
                } else {
                    this.dir = this.lastPos.sub(this.pos).mulScl(1.1);
                }
            }

            if (!this.lastPos.eq(this.pos)) {
                this.lastPos = new DHPoint(this.pos.x, this.pos.y);
            }
            super.update();

            if(FlxG.keys.justPressed("SPACE")){
                this.attack();
            }
            if(FlxG.keys.justPressed("N")) {
                this.emote();
            }

            if (this._state == STATE_IN_ATTACK) {
                if (timeSinceLastAttack() > 100) {
                    play("idle");
                    this._state = STATE_IDLE;
                }
            }
        }

        public function emote():void {
            new Emote(this.pos);
        }

        override public function setPos(pos:DHPoint):void {
            super.setPos(pos);

            this.mapHitbox.x = pos.x + this.hitboxOffset.x;
            this.mapHitbox.y = pos.y + this.hitboxOffset.y;
        }

        override public function attack():void {
            super.attack();
            if (this._state == STATE_IN_ATTACK) {
                play("attack");
            }
        }
    }
}

