package{
    import org.flixel.*;

    public class Player extends PartyMember {
        [Embed(source="../assets/c_walk.png")] private var ImgCibWalk:Class;
        [Embed(source="../assets/splash_sprites.png")] private var ImgWalkTo:Class;
        [Embed(source="../assets/testattack.png")] private var ImgAttack:Class;

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
        public var targetEnemy:Enemy;
        public var attack_sprite:FlxSprite;

        public static const STATE_WALK:Number = 2398476188;

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

            this.splash_sprites = new FlxSprite(this.x, this.y);
            this.attack_sprite = new FlxSprite(this.x, this.y);

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

        public function clickCallback(pos:DHPoint, group:Array=null):void {
            this.targetEnemy = null;
            if (group != null) {
                var cur:GameObject, rect:FlxRect;
                var mouseRect:FlxRect = new FlxRect(pos.x, pos.y, 5, 5);
                for (var i:int = 0; i < group.length; i++) {
                    cur = group[i];
                    rect = new FlxRect(cur.x, cur.y, cur.width, cur.height);
                    if (cur is Enemy) {
                        if (mouseRect.overlaps(rect)) {
                            this.targetEnemy = cur as Enemy;
                            break;
                        }
                    }
                }
            }

            if (this.targetEnemy == null) {
                this._state = STATE_WALK;
                this.walkTarget = new DHPoint(FlxG.mouse.x, FlxG.mouse.y);
                this.splash_sprites.x = this.walkTarget.x - this.splash_sprites.width/2;
                this.splash_sprites.y = this.walkTarget.y - this.splash_sprites.height/2;
                this.splash_sprites.alpha = 1;
                this.splash_sprites.play("attack");
            } else {
                this._state = STATE_MOVE_TO_ENEMY;
                this.walkTarget = this.targetEnemy.pos;
                this.splash_sprites.alpha = 1;
                this.splash_sprites.play("attack");
            }
            this.dir = this.walkTarget.sub(footPos).normalized();
            this.walkDistance = this.walkTarget.sub(footPos)._length();
        }

        public function setFacing():void {
            if(this.dir != null){
                if(Math.abs(this.dir.y) > Math.abs(this.dir.x)){
                    if(this.dir.y < 0){
                        this.facing = UP;
                    } else {
                        this.facing = DOWN;
                    }
                } else {
                    if(this.dir.x > 0){
                        this.facing = RIGHT;
                    } else {
                        this.facing = LEFT;
                    }
                }
            }
        }

        public function walk():void {
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

        override public function update():void{
            this.hitbox_rect.x = this.pos.x;
            this.hitbox_rect.y = this.pos.y;

            this.setFacing();
            this.footPos = new DHPoint(this.pos.x + this.width/2,
                                  this.pos.y + this.height);

            if (this._state == STATE_WALK) {
                this.walk();
                if (this.walkTarget.sub(this.footPos)._length() < 10) {
                    this._state = STATE_IDLE;
                    this.dir = ZERO_POINT;
                }
            } else if (this._state == STATE_MOVE_TO_ENEMY) {
                this.walk();
                if (this.enemyIsInAttackRange(this.targetEnemy)) {
                    this._state = STATE_AT_ENEMY;
                }
            } else if (this._state == STATE_AT_ENEMY) {
                this.attack();
                this.dir = ZERO_POINT;
            } else if (this._state == STATE_IN_ATTACK) {
                this.attack_sprite.x = this.pos.x;
                this.attack_sprite.y = this.pos.y;
                if (this.timeSinceLastAttack() > 100) {
                    this.resolveStatePostAttack();
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

            if(this.splash_sprites.frame == 8) {
                this.splash_sprites.alpha = 0;
                this.splash_sprites.play("idle");
            }
            if(this.attack_sprite.frame == 3) {
                this.attack_sprite.alpha = 0;
            }
        }

        override public function resolveStatePostAttack():void {
            super.resolveStatePostAttack();
            if (this.targetEnemy != null && !this.targetEnemy.dead){
                if(this.enemyIsInAttackRange(this.targetEnemy)) {
                    this._state = STATE_AT_ENEMY;
                } else {
                    this._state = STATE_MOVE_TO_ENEMY;;
                }
            } else {
                this._state = STATE_IDLE;
            }
        }

        public function addAttackAnim():void {
            //this sprite is being used for walk target anim
            this.splash_sprites.loadGraphic(ImgWalkTo, true, false, 640/10, 64);
            this.splash_sprites.addAnimation("attack",
                [0, 1, 2, 3, 4, 5, 6, 7, 8], 15, false);
            this.splash_sprites.addAnimation("idle", [0], 20, false);
            FlxG.state.add(this.splash_sprites);
            this.splash_sprites.alpha = 0;

            //test attack sprite
            this.attack_sprite.loadGraphic(ImgAttack,true,false,454/6,95);
            this.attack_sprite.addAnimation("attack",[0,1,2,3,4,5],10,false);
            FlxG.state.add(attack_sprite);
            this.attack_sprite.alpha = 0;
        }

        override public function setPos(pos:DHPoint):void {
            super.setPos(pos);

            this.mapHitbox.x = pos.x + this.hitboxOffset.x;
            this.mapHitbox.y = pos.y + this.hitboxOffset.y;
        }

        override public function attack():void {
            super.attack();
            if (this._state == STATE_IN_ATTACK) {
                this.attack_sprite.alpha = 1;
                this.attack_sprite.play("attack");
                play("attack");
            }
        }
    }
}

