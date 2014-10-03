package{
    import org.flixel.*;

    public class Player extends PartyMember {
        [Embed(source="../assets/c_walk.png")] private var ImgCibWalk:Class;
        [Embed(source="../assets/splash_sprites.png")] private var ImgWalkTo:Class;
        [Embed(source="../assets/testattack.png")] private var ImgAttack:Class;
        [Embed(source="../assets/cib_shadow.png")] private var ImgShadow:Class;

        private var walkDistance:Number = 0;
        private var walkTarget:DHPoint;
        private var walkDirection:DHPoint = null;
        private var walkSpeed:Number = 8;
        private var walking:Boolean = false;
        public var colliding:Boolean = false;
        public var hitbox_rect:FlxRect;
        public var lastPos:DHPoint;
        public var mapHitbox:GameObject;
        public var hitboxOffset:DHPoint, hitboxDim:DHPoint;
        public var collisionDirection:Array;
        public var popupmgr:PopUpManager;
        public var inhibitY:Boolean = false, inhibitX:Boolean = false;
        public var splash_sprites:GameObject;
        public var targetEnemy:Enemy;
        public var attack_sprite:GameObject;
        public var shadow_sprite:GameObject;

        public static const STATE_WALK:Number = 2398476188;

        public function Player(x:Number, y:Number):void{
            super(new DHPoint(x, y));

            this.nameText.text = "Cibele";

            this.zSorted = true;

            this.shadow_sprite = new GameObject(this.pos);
            this.shadow_sprite.loadGraphic(ImgShadow,false,false,41,14);

            loadGraphic(ImgCibWalk, true, false, 143, 150);
            addAnimation("walk_u",
                [0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10], 20, false);
            addAnimation("idle_u", [9], 20, false);
            addAnimation("walk_d",
                [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21], 20, false);
            addAnimation("idle_d", [12], 20, false);
            addAnimation("walk_l",
                [35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22],
                20, false);
            addAnimation("idle_l", [26], 20, false);
            addAnimation("walk_r",
                [49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36],
                20, false);
            addAnimation("idle_r", [40], 20, false);
            addAnimation("idle", [11], 7, false);
            addAnimation("attack", [0, 1], 7, true);

            this.splash_sprites = new GameObject(this.pos);
            this.attack_sprite = new GameObject(this.pos);

            this.hitboxOffset = new DHPoint(60, 100);
            this.hitboxDim = new DHPoint(40, 50);
            this.mapHitbox = new GameObject(this.pos);
            this.mapHitbox.makeGraphic(this.hitboxDim.x, this.hitboxDim.y,
                                       0xffff0000);
            this.hitbox_rect = new FlxRect(this.pos.x, this.pos.y,
                                           this.mapHitbox.width,
                                           this.mapHitbox.height);

            this.lastPos = new DHPoint(this.pos.x, this.pos.y);
            this.footstepOffset = new DHPoint(80, this.height);
            this.walkTarget = new DHPoint(0, 0);

            this.shadow_sprite.x = this.x + (this.width/3);
            this.shadow_sprite.y = this.y + (this.height-10);
            this.shadow_sprite.zSorted = true;

            this.basePos = new DHPoint(this.x, this.y + (this.height-10));
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint,
                                      group:Array=null):void
        {
            this.targetEnemy = null;
            var ui_clicked:Boolean = false;
            if (group != null) {
                var cur:GameObject, screenRect:FlxRect, worldRect:FlxRect;
                var mouseScreenRect:FlxRect = new FlxRect(screenPos.x, screenPos.y,
                                                          5, 5);
                var mouseWorldRect:FlxRect = new FlxRect(worldPos.x, worldPos.y,
                                                         5, 5);
                var curScreenPos:DHPoint = new DHPoint(0, 0);
                for (var i:int = 0; i < group.length; i++) {
                    cur = group[i];
                    cur.getScreenXY(curScreenPos);
                    screenRect = new FlxRect(curScreenPos.x, curScreenPos.y,
                                             cur.width, cur.height);
                    worldRect = new FlxRect(cur.x, cur.y,
                                            cur.width, cur.height);
                    if (mouseScreenRect.overlaps(screenRect) &&
                        cur is UIElement && cur.visible)
                    {
                        ui_clicked = true;
                    } else if (mouseWorldRect.overlaps(worldRect) &&
                        cur is Enemy)
                    {
                        this.targetEnemy = cur as Enemy;
                        if(this.targetEnemy.dead) {
                            this.targetEnemy = null;
                        }
                    }
                }
            }

            if (ui_clicked) {
                return;
            }

            if (this.targetEnemy == null) {
                this._state = STATE_WALK;
                this.walkTarget = worldPos;
                this.splash_sprites.x = this.walkTarget.x -
                    this.splash_sprites.width/2;
                this.splash_sprites.y = this.walkTarget.y -
                    this.splash_sprites.height/2;
                this.splash_sprites.alpha = 1;
                this.splash_sprites.play("attack");
            } else {
                this.walkTarget = this.targetEnemy.pos.center(this.targetEnemy, true);
                this._state = STATE_MOVE_TO_ENEMY;
            }
            this.dir = this.walkTarget.sub(footPos).normalized();
            this.walkDistance = this.walkTarget.sub(footPos)._length();
        }

        public function setFacing():void {
            if(this.dir != null){
                if(Math.abs(this.dir.y) > Math.abs(this.dir.x)){
                    if(this.dir.y <= 0){
                        this.facing = UP;
                    } else {
                        this.facing = DOWN;
                    }
                } else {
                    if(this.dir.x >= 0){
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
                this.text_facing = "left";
                this.shadow_sprite.x = this.x + (this.width/2);
                this.shadow_sprite.y = this.y + (this.height-10);
            } else if (this.facing == RIGHT){
                this.play("walk_r");
                this.text_facing = "right";
                this.shadow_sprite.x = this.x + (this.width/4);
                this.shadow_sprite.y = this.y + (this.height-10);
            } else if(this.facing == UP){
                this.play("walk_u");
                this.text_facing = "up";
                this.shadow_sprite.x = this.x + (this.width/3);
                this.shadow_sprite.y = this.y + (this.height-10);
            } else if(this.facing == DOWN){
                this.play("walk_d");
                this.text_facing = "down";
                this.shadow_sprite.x = this.x + (this.width/3);
                this.shadow_sprite.y = this.y + (this.height-10);
            }
        }

        override public function addVisibleObjects():void {
            this.addAttackAnim();
            FlxG.state.add(this.shadow_sprite);
            FlxG.state.add(this);
            FlxG.state.add(this.nameText);
            FlxG.state.add(this.debugText);
        }

        override public function update():void{
            this.hitbox_rect.x = this.pos.x;
            this.hitbox_rect.y = this.pos.y;

            this.basePos.y = this.y + (this.height-10);

            this.setFacing();

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
            } else if (this._state == STATE_IDLE) {
                if(this.text_facing == "up") {
                    this.play("idle_u");
                } else if(this.text_facing == "down") {
                    this.play("idle_d");
                } else if(this.text_facing == "left") {
                    this.play("idle_l");
                } else if(this.text_facing == "right") {
                    this.play("idle_r");
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
                    //this.dir = this.lastPos.sub(this.pos).mulScl(1.1);
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
            if (this.targetEnemy != null && !this.targetEnemy.dead && this.targetEnemy.visible == true){
                if(this.enemyIsInAttackRange(this.targetEnemy)) {
                    this._state = STATE_AT_ENEMY;
                } else {
                    this.walkTarget = this.targetEnemy.pos.center(this.targetEnemy, true);
                    this.dir = this.walkTarget.sub(footPos).normalized();
                    this.walkDistance = this.walkTarget.sub(footPos)._length();
                    this._state = STATE_MOVE_TO_ENEMY;
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
            this.attack_sprite.loadGraphic(ImgAttack,true,false,692/5,140);
            this.attack_sprite.addAnimation("attack",[0,1,2,3,4],10,false);
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
            }
        }
    }
}

