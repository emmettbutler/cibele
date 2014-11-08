package{
    import org.flixel.*;

    import flash.utils.Dictionary;

    public class Player extends PartyMember {
        [Embed(source="../assets/c_walk.png")] private var ImgCibWalk:Class;
        [Embed(source="../assets/click_anim.png")] private var ImgWalkTo:Class;
        [Embed(source="../assets/cib_attack.png")] private var ImgAttack:Class;
        [Embed(source="../assets/cib_shadow.png")] private var ImgShadow:Class;
        [Embed(source="../assets/cib_shadow_blue.png")] private var ImgShadowBlue:Class;
        [Embed(source="../assets/sfx_uigeneral.mp3")] private var SfxUI:Class;
        [Embed(source="../assets/sfx_protoattack1.mp3")] private var SfxAttack1:Class;
        [Embed(source="../assets/sfx_protoattack2.mp3")] private var SfxAttack2:Class;
        [Embed(source="../assets/sfx_protoattack3.mp3")] private var SfxAttack3:Class;
        [Embed(source="../assets/sfx_protoattack4.mp3")] private var SfxAttack4:Class;

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
        public var click_anim:GameObject;
        public var targetEnemy:Enemy;
        public var _mapnodes:MapNodeContainer;
        public var attack_sprite:GameObject;
        public var shadow_sprite:GameObject;
        public var enemy_dir:DHPoint;
        public var click_anim_lock:Boolean = false;
        public var cameraPos:GameObject;
        public var active_enemy:Boolean = false;
        public var upDownFootstepOffset:DHPoint;
        public var leftFootstepOffset:DHPoint;
        public var rightFootstepOffset:DHPoint;

        public static const STATE_WALK:Number = 2398476188;
        public static const STATE_WALK_HARD:Number = 23981333333;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_NULL] = "STATE_NULL";
            stateMap[STATE_AT_ENEMY] = "STATE_AT_ENEMY";
            stateMap[STATE_IN_ATTACK] = "STATE_IN_ATTACK";
            stateMap[STATE_MOVE_TO_ENEMY] = "STATE_MOVE_TO_ENEMY";
            stateMap[STATE_WALK] = "STATE_WALK";
            stateMap[STATE_WALK_HARD] = "STATE_WALK_HARD";
        }


        public function Player(x:Number, y:Number):void{
            super(new DHPoint(x, y));
            this.cameraPos = new GameObject(new DHPoint(x, y));

            this.nameText.text = "Cibele";
            this.tag = PartyMember.cib;

            this.zSorted = true;

            this.shadow_sprite = new GameObject(this.pos);
            this.shadow_sprite.loadGraphic(ImgShadow,false,false,70,42);
            this.shadow_sprite.alpha = .7;
            this.shadow_sprite.zSorted = true;

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

            this.click_anim = new GameObject(this.pos);
            this.attack_sprite = new GameObject(this.pos);
            this.attack_sprite.zSorted = true;

            this.hitboxOffset = new DHPoint(60, 100);
            this.hitboxDim = new DHPoint(40, 50);
            this.mapHitbox = new GameObject(this.pos);
            this.mapHitbox.makeGraphic(this.hitboxDim.x, this.hitboxDim.y,
                                       0xff000000);
            this.hitbox_rect = new FlxRect(this.pos.x, this.pos.y,
                                           this.mapHitbox.width,
                                           this.mapHitbox.height);

            this.lastPos = new DHPoint(this.pos.x, this.pos.y);
            this.upDownFootstepOffset = new DHPoint(70, this.height);
            this.leftFootstepOffset = new DHPoint(90, this.height-20);
            this.rightFootstepOffset = new DHPoint(40, this.height-20);
            this.footstepOffset = this.upDownFootstepOffset;
            this.walkTarget = new DHPoint(0, 0);

            this.basePos = new DHPoint(this.x, this.y + (this.height-10));
        }

        public function setMapNodes(nodes:MapNodeContainer):void {
            this._mapnodes = nodes;
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
                        this.active_enemy = false;
                        this.playUIGeneralSFX();
                    } else if (cur is Enemy) {
                        if (mouseWorldRect.overlaps(worldRect)) {
                            if(!this.active_enemy) {
                                this.active_enemy = true;
                                this.targetEnemy = cur as Enemy;
                                this.targetEnemy.activeTarget();
                                if(this.targetEnemy.dead) {
                                    this.targetEnemy = null;
                                }
                            }
                        } else {
                            (cur as Enemy).inactiveTarget();
                            this.active_enemy = false;
                        }
                    }
                }
            }

            if (ui_clicked) {
                return;
            }

            if (this.targetEnemy == null) {
                this.initWalk(worldPos);
            } else {
                this.walkTarget = this.targetEnemy.getAttackPos();
                this._state = STATE_MOVE_TO_ENEMY;
            }
            this.dir = this.walkTarget.sub(footPos).normalized();
            this.walkDistance = this.walkTarget.sub(footPos)._length();
        }

        public function setFacing(at_enemy:Boolean=false):void {
            if(!at_enemy){
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
            } else if(at_enemy == true && this.targetEnemy != null){
                this.enemy_dir = this.targetEnemy.pos.sub(footPos).normalized();
                if(Math.abs(this.enemy_dir.y) > Math.abs(this.enemy_dir.x)){
                    if(this.enemy_dir.y <= 0){
                        this.facing = UP;
                    } else {
                        this.facing = DOWN;
                    }
                } else {
                    if(this.enemy_dir.x >= 0){
                        this.facing = RIGHT;
                    } else {
                        this.facing = LEFT;
                    }
                }
            }
        }

        public function playUIGeneralSFX():void {
            SoundManager.getInstance().playSound(
                SfxUI, 1*GameSound.MSEC_PER_SEC, null, false, .3, GameSound.SFX,
                "" + Math.random()
            );
        }

        public function initWalk(worldPos:DHPoint):void {
            this._state = STATE_WALK;
            this.walkTarget = worldPos;
            if(!this.click_anim_lock) {
                this.click_anim_lock = true;
                this.click_anim.x = this.walkTarget.x -
                    this.click_anim.width/2;
                this.click_anim.y = this.walkTarget.y -
                    this.click_anim.height/2;
                this.click_anim.visible = true;
                this.click_anim.play("click");
            }
        }

        public function walk():void {
            this.walkDirection = walkTarget.sub(footPos).normalized();
            this.dir = this.walkDirection.mulScl(this.walkSpeed);
            if(this.facing == LEFT){
                this.play("walk_l");
                this.text_facing = "left";
                this.footstepOffset = this.leftFootstepOffset;
            } else if (this.facing == RIGHT){
                this.play("walk_r");
                this.text_facing = "right";
                this.footstepOffset = this.rightFootstepOffset;
            } else if(this.facing == UP){
                this.play("walk_u");
                this.text_facing = "up";
                this.footstepOffset = this.upDownFootstepOffset;
            } else if(this.facing == DOWN){
                this.play("walk_d");
                this.text_facing = "down";
                this.footstepOffset = this.upDownFootstepOffset;
            }
        }

        override public function addVisibleObjects():void {
            this.addAttackAnim();
            FlxG.state.add(this.shadow_sprite);
            FlxG.state.add(this);
            FlxG.state.add(this.nameText);
            FlxG.state.add(this.debugText);
        }

        public static function interpolate(normValue:Number, minimum:Number,
                                           maximum:Number):Number {
            return minimum + (maximum - minimum) * normValue;
        }

        override public function update():void{
            if(this.walkTarget != null) {
                this.cameraPos.x = interpolate(.1, this.cameraPos.x,
                                               this.pos.center(this).x);
                this.cameraPos.y = interpolate(.1, this.cameraPos.y,
                                               this.pos.center(this).y);
            }

            this.attack_sprite.x = this.x;
            this.attack_sprite.y = this.y-45;

            if(this.text_facing == "left") {
                this.shadow_sprite.x = this.pos.center(this).x - 15;
                this.shadow_sprite.y = this.pos.center(this).y + 50;
            } else if(this.text_facing == "right") {
                this.shadow_sprite.x = this.pos.center(this).x - 60;
                this.shadow_sprite.y = this.pos.center(this).y + 50;
            } else if(this.text_facing == "up") {
                this.shadow_sprite.x = this.pos.center(this).x - 35;
                this.shadow_sprite.y = this.pos.center(this).y + 50;
            } else if(this.text_facing == "down") {
                this.shadow_sprite.x = this.pos.center(this).x - 35;
                this.shadow_sprite.y = this.pos.center(this).y + 50;
            }

            this.hitbox_rect.x = this.pos.x;
            this.hitbox_rect.y = this.pos.y;

            this.basePos.y = this.y + (this.height-10);

            if(this._state != STATE_AT_ENEMY) {
                this.setFacing(false);
            }

            if (this._state == STATE_WALK || this._state == STATE_WALK_HARD) {
                this.walk();
                if(FlxG.mouse.pressed()) {
                    this.walkTarget = new DHPoint(FlxG.mouse.x, FlxG.mouse.y);
                } else if(FlxG.mouse.justReleased()) {
                    this.click_anim_lock = false;
                }
                if (this.walkTarget.sub(this.footPos)._length() < 10 && !FlxG.mouse.pressed()) {
                    this._state = STATE_IDLE;
                    this.dir = ZERO_POINT;
                } else if (this.walkTarget.sub(this.footPos)._length() < 100) {
                    this.dir = this.dir.mulScl(.7);
                }
            } else if (this._state == STATE_MOVE_TO_ENEMY) {
                if(this.targetEnemy != null) {
                    this.walkTarget = this.targetEnemy.getAttackPos();
                    this.walk();
                    if (this.enemyIsInAttackRange(this.targetEnemy)) {
                        this._state = STATE_AT_ENEMY;
                    }
                } else {
                    this.walk();
                }
            } else if (this._state == STATE_AT_ENEMY) {
                this.attack();
                this.dir = ZERO_POINT;
            } else if (this._state == STATE_IN_ATTACK) {
                this.setFacing(true);
                if (this.timeSinceLastAttack() > 100) {
                    this.resolveStatePostAttack();
                }
            } else if (this._state == STATE_IDLE) {
                this.setIdleAnim();
            }

            if(this._state != STATE_IN_ATTACK) {
                this.visible = true;
                this.shadow_sprite.visible = true;
                this.attack_sprite.visible = false;
            }

            if (this.colliding) {
                if (this.collisionDirection != null) {
                    if (this.collisionDirection[0] == 1 &&
                        this.collisionDirection[1] == 1 &&
                        this.collisionDirection[2] == 1 &&
                        this.collisionDirection[3] == 1 && this._mapnodes != null)
                    {
                        // stuck!
                        this._state = STATE_WALK_HARD;
                        this.walkTarget = this._mapnodes.getClosestNode(this.pos).pos;
                    } else if (this._state != STATE_WALK_HARD){
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
                    }
                }
            }

            if (!this.lastPos.eq(this.pos)) {
                this.lastPos = new DHPoint(this.pos.x, this.pos.y);
            }
            super.update();

            if(this.click_anim.frame == 10) {
                this.click_anim.visible = false;
                this.click_anim.play("idle");
            }
        }

        override public function resolveStatePostAttack():void {
            super.resolveStatePostAttack();
            if(this.visible == false) {
                if(this.attack_sprite.frame == 22) {
                    this.visible = true;
                    this.shadow_sprite.visible = true;
                    this.attack_sprite.visible = false;

                    if (this.targetEnemy != null && !this.targetEnemy.dead && this.targetEnemy.visible == true)
                    {
                        if(this.enemyIsInAttackRange(this.targetEnemy)) {
                            this._state = STATE_AT_ENEMY;
                        } else {
                            this.walkTarget = this.targetEnemy.getAttackPos();
                            this.walkDistance = this.walkTarget.sub(footPos)._length();
                            this._state = STATE_MOVE_TO_ENEMY;
                        }
                    } else {
                        this._state = STATE_IDLE;
                    }
                } else {
                    this._state = STATE_IN_ATTACK;
                }
            }
        }

        public function setIdleAnim():void {
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

        public function addAttackAnim():void {
            //this sprite is being used for walk target anim
            this.click_anim.loadGraphic(ImgWalkTo, true, false, 275*.7, 164*.7);
            this.click_anim.addAnimation("click",
                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 30, false);
            this.click_anim.addAnimation("idle", [0], 20, false);
            FlxG.state.add(this.click_anim);
            this.click_anim.visible = false;

            //test attack sprite
            this.attack_sprite.loadGraphic(ImgAttack,true,false,173,230);
            this.attack_sprite.addAnimation("attack",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22],10,false);
            FlxG.state.add(attack_sprite);
            this.attack_sprite.visible = false;
        }

        override public function setPos(pos:DHPoint):void {
            super.setPos(pos);

            this.mapHitbox.x = pos.x + this.hitboxOffset.x;
            this.mapHitbox.y = pos.y + this.hitboxOffset.y;
        }

        override public function attack():void {
            super.attack();
            if (this._state == STATE_IN_ATTACK) {
                this.attack_sprite.visible = true;
                this.visible = false;
                this.shadow_sprite.visible = false;
                this.attack_sprite.play("attack");

                var snd:Class = SfxAttack1;
                var rand:Number = Math.random() * 4;
                if (rand > 3) {
                    snd = SfxAttack2;
                } else if (rand > 2) {
                    snd = SfxAttack3;
                } else if (rand > 1) {
                    snd = SfxAttack4;
                }
                SoundManager.getInstance().playSound(
                    snd, 2*GameSound.MSEC_PER_SEC, null, false, .3, GameSound.SFX,
                    "" + Math.random()
                );
            }
        }

        public function isMoving():Boolean {
            return this._state == STATE_WALK || this._state == STATE_WALK_HARD;
        }

        public function setBlueShadow():void {
            this.shadow_sprite.loadGraphic(ImgShadow,false,false,70,42);
            this.shadow_sprite.alpha = .7;
        }
    }
}

