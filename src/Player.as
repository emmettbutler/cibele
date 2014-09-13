package{
    import org.flixel.*;

    public class Player extends PartyMember {
        [Embed(source="../assets/c_walk.png")] private var ImgCibWalk:Class;
        [Embed(source="../assets/splash_sprites.png")] private var ImgAttack:Class;

        private var walkDistance:Number = 0;
        private var walkTarget:DHPoint;
        private var walkDirection:DHPoint = null;
        private var footPos:DHPoint;
        private var walkSpeed:Number = 8;
        private var walking:Boolean = false;
        public var colliding:Boolean = false;
        public var hitbox_rect:FlxRect;
        public var lastPos:DHPoint;
        public var mapHitbox:FlxSprite;
        public var hitboxOffset:DHPoint, hitboxDim:DHPoint;
        public var collisionDirection:Array;
        public var popupmgr:PopUpManager;
        public var inhibitY:Boolean = false, inhibitX:Boolean = false;
        public var splash_sprites:FlxSprite;

        public function Player(x:Number, y:Number):void{
            super(new DHPoint(x, y));

            loadGraphic(ImgCibWalk, true, false, 143, 150);
            addAnimation("walk_u",
                [0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10], 20, false);
            addAnimation("walk_d",
                [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21], 20, false);
            addAnimation("walk_l",
                [35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22],
                20, false);
            addAnimation("walk_r",
                [49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36],
                20, false);
            addAnimation("idle", [11], 7, false);
            addAnimation("attack", [0, 1], 7, true);

            this.hitboxOffset = new DHPoint(60, 100);
            this.hitboxDim = new DHPoint(40, 50);
            this.mapHitbox = new FlxSprite(x, y);
            this.mapHitbox.makeGraphic(this.hitboxDim.x, this.hitboxDim.y, 0xffff0000);
            this.hitbox_rect = new FlxRect(this.pos.x, this.pos.y,
                                           this.mapHitbox.width,
                                           this.mapHitbox.height);

            this.lastPos = new DHPoint(this.pos.x, this.pos.y);
            this.footstepOffset = new DHPoint(80, this.height);
            this.walkTarget = new DHPoint(0, 0);
        }

        override public function update():void{
            this.hitbox_rect.x = this.pos.x;
            this.hitbox_rect.y = this.pos.y;

            footPos = new DHPoint(this.pos.x + this.width/2,
                                  this.pos.y + this.height);

            if(FlxG.mouse.justPressed()){
                this.walkTarget = new DHPoint(FlxG.mouse.x, FlxG.mouse.y);
                this.walking = true;
                this.walkDistance = walkTarget.sub(footPos)._length();
                this.dir = walkTarget.sub(footPos).normalized();
                this.splash_sprites.x = this.walkTarget.x - this.splash_sprites.width/2;
                this.splash_sprites.y = this.walkTarget.y - this.splash_sprites.height/2;
                this.splash_sprites.alpha = 1;
                this.splash_sprites.play("attack");
            }

            if(this.walking) {
                this.walkDirection = walkTarget.sub(footPos).normalized();
                this.dir = this.walkDirection.mulScl(this.walkSpeed);
                if(this.facing == LEFT){
                    this.play("walk_l");
                } else if (this.facing == RIGHT){
                    this.play("walk_r");
                } else if(this.facing == UP){
                    this.play("walk_u");
                } else if(this.facing == DOWN){
                    this.play("walk_d");
                }
            }

            if (this.walkTarget.sub(this.footPos)._length() < 10) {
                this.walking = false;
                this.dir.x = 0;
                this.dir.y = 0;
            }

            if(walkDirection != null){
                if(Math.abs(walkDirection.y) > Math.abs(walkDirection.x)){
                    if(walkDirection.y < 0){
                        this.facing = UP;
                    } else {
                        this.facing = DOWN;
                    }
                } else {
                    if(walkDirection.x > 0){
                        this.facing = RIGHT;
                    } else {
                        this.facing = LEFT;
                    }
                }
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

            if (this.splash_sprites != null) {
                if (this._state == STATE_IN_ATTACK) {
                    this.splash_sprites.x = this.pos.x;
                    this.splash_sprites.y = this.pos.y;
                    if (timeSinceLastAttack() > 100) {
                        play("idle");
                        this._state = STATE_IDLE;
                    }
                } else {
                    if(this.splash_sprites.frame == 8) {
                        this.splash_sprites.alpha = 0;
                        this.splash_sprites.play("idle");
                    }
                }
            }
        }

        public function addAttackAnim():void {
            this.splash_sprites = new FlxSprite(this.x, this.y);
            this.splash_sprites.loadGraphic(ImgAttack, true, false, 640/10, 64);
            this.splash_sprites.addAnimation("attack",
                [0, 1, 2, 3, 4, 5, 6, 7, 8], 15, false);
            this.splash_sprites.addAnimation("idle", [0], 20, false);
            FlxG.state.add(this.splash_sprites);
            this.splash_sprites.alpha = 0;
        }

        override public function setPos(pos:DHPoint):void {
            super.setPos(pos);

            this.mapHitbox.x = pos.x + this.hitboxOffset.x;
            this.mapHitbox.y = pos.y + this.hitboxOffset.y;
        }

        override public function attack():void {
            super.attack();
            if (this._state == STATE_IN_ATTACK) {
                this.splash_sprites.alpha = 1;
                this.splash_sprites.play("attack");
                play("attack");
            }
        }
    }
}

