package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.Utils;
    import com.starmaid.Cibele.management.Path;
    import com.starmaid.Cibele.management.DebugConsoleManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.BackgroundLoader;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.states.LevelMapState;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.Deque;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.UIElement;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class Player extends PartyMember {
        [Embed(source="/../assets/images/ui/click_anim.png")] private var ImgWalkTo:Class;
        [Embed(source="/../assets/images/characters/c_walk.png")] private var ImgCibWalk:Class;
        [Embed(source="/../assets/images/characters/cib_attack.png")] private var ImgAttack:Class;
        [Embed(source="/../assets/images/characters/cib_shadow_blue.png")] private var ImgShadowBlue:Class;
        [Embed(source="/../assets/audio/effects/sfx_cibattack.mp3")] private var SfxAttack1:Class;
        [Embed(source="/../assets/audio/effects/sfx_cibattack2.mp3")] private var SfxAttack2:Class;

        private var walkSpeed:Number = 7, mouseDownTime:Number;
        private var hitboxOffset:DHPoint,
                    hitboxDim:DHPoint;
        private var click_anim:GameObject, attack_sprite:GameObject;
        private var click_anim_lock:Boolean = false, clickWait:Boolean,
                    mouseHeld:Boolean = false, attack_sound_lock:Boolean = false;
        private var _bgLoaderRef:BackgroundLoader;

        public var colliding:Boolean = false;
        public var mapHitbox:GameObject, cameraPos:GameObject;
        public var collisionDirection:Array, lastPositions:Deque;

        public static var _particleType:Number = PartyMember.PARTICLE_CIBELE;
        public static var _slug:String = "Player";

        public static const STATE_WALK_HARD:Number = 23981333333;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_NULL] = "STATE_NULL";
            stateMap[STATE_IDLE] = "STATE_IDLE";
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
            this.particleType = _particleType;
            this.slug = _slug;

            this.zSorted = true;

            this.buildShadowSprite();

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

            this.attack_sprite = new GameObject(this.pos);
            this.attack_sprite.zSorted = true;
            this.attack_sprite.basePos = new DHPoint(0, 0);
            this.attack_sprite.loadGraphic(ImgAttack,true,false,173,230);
            this.attack_sprite.addAnimation("attack",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22],13,false);
            this.attack_sprite.addAnimation("reverse_attack",[22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0],13,false);
            this.attack_sprite.visible = false;

            this.click_anim = new GameObject(this.pos);
            this.click_anim.loadGraphic(ImgWalkTo, true, false, 275*.7, 164*.7);
            this.click_anim.addAnimation("click",
                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 30, false);
            this.click_anim.addAnimation("idle", [0], 20, false);
            this.click_anim.visible = false;

            this.hitboxOffset = new DHPoint(60, 100);
            this.hitboxDim = new DHPoint(40, 50);
            this.mapHitbox = new GameObject(this.pos);
            this.mapHitbox.makeGraphic(this.hitboxDim.x, this.hitboxDim.y,
                                       0xff000000);

            this.setupFootsteps();
            this.setupParticles();
            this.attackSounds = new Array(SfxAttack1, SfxAttack2);

            this.finalTarget = new DHPoint(0, 0);
            this.debugText.color = 0xff444444;

            this.basePos = new DHPoint(this.x, this.y + (this.height-10));
            this.lastPositions = new Deque(3);
            GlobalTimer.getInstance().setMark("trail_update",
                .1*GameSound.MSEC_PER_SEC, this.pushPos, true);

            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.player.pos", "player.pos");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.player.getStateString", "player.state");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.player.getWalkTarget", "player.walkTarget");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.player.getFinalTarget", "player.finalTarget");
        }

        override public function setupFootsteps():void {
            this.footstepOffsets.up = new DHPoint(70, this.height);
            this.footstepOffsets.down = this.footstepOffsets.up;
            this.footstepOffsets.left = new DHPoint(90, this.height-20);
            this.footstepOffsets.right = new DHPoint(40, this.height-20);
            this.footstepOffset = this.footstepOffsets.up as DHPoint;
        }

        public function set bgLoaderRef(ref:BackgroundLoader):void {
            this._bgLoaderRef = ref;
        }

        public function getStateString():String {
            return Player.stateMap[this._state] == null ? "unknown" : Player.stateMap[this._state];
        }

        public function getWalkTarget():DHPoint {
            return this.walkTarget;
        }

        public function getFinalTarget():DHPoint {
            return this.finalTarget;
        }

        override public function toggleActive():void {
            if (!this.active) {
                this.active = true;
            }
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint,
                                      group:Array=null):void
        {
            var ui_clicked:Boolean = false, got_enemy:Boolean = false,
                prevTargetEnemy:Enemy = null;

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
                        SoundManager.getInstance().playUIGeneralSFX();
                    } else if (cur is Enemy) {
                        if(this._state == STATE_IN_ATTACK) {
                            return;
                        }
                        if (mouseWorldRect.overlaps(worldRect) && !(cur as Enemy).isDead()) {
                            if(!got_enemy) {
                                got_enemy = true;
                                prevTargetEnemy = this.targetEnemy;
                                this.targetEnemy = cur as Enemy;
                            }
                        } else {
                            (cur as Enemy).inactiveTarget();
                        }
                    }
                }
            }

            if(this._state == STATE_IN_ATTACK) {
                return;
            }

            if (ui_clicked) {
                return;
            }

            // don't react to held mouse button
            if (new Date().valueOf() - this.mouseDownTime > 1*GameSound.MSEC_PER_SEC) {
                return;
            }

            this.initWalk(worldPos);
            if (got_enemy && this.targetEnemy != null && !this.targetEnemy.isDead()) {
                this._state = STATE_MOVE_TO_ENEMY;
                this.targetEnemy.activeTarget();
            }
            if (prevTargetEnemy != null) {
                prevTargetEnemy.inactiveTarget();
            }

            this.clickWait = true;
            if(!this.click_anim_lock) {
                this.click_anim_lock = true;
                this.click_anim.x = this.finalTarget.x -
                    this.click_anim.width/2;
                this.click_anim.y = this.finalTarget.y -
                    this.click_anim.height/2;
                this.click_anim.visible = true;
                this.click_anim.play("click");
            }
            GlobalTimer.getInstance().setMark("clickwait",
                .4*GameSound.MSEC_PER_SEC, function():void {
                    clickWait = false;
                    click_anim_lock = false;
                }, true);
        }

        public function setFacing(at_enemy:Boolean=false):void {
            if(!at_enemy){
                if(this.dir != null){
                    if(Math.abs(this.dir.y) > Math.abs(this.dir.x)){
                        if(this.dir.y < 0){
                            this.facing = UP;
                        } else if (this.dir.y > 0){
                            this.facing = DOWN;
                        }
                    } else if (Math.abs(this.dir.y) < Math.abs(this.dir.x)) {
                        if(this.dir.x > 0){
                            this.facing = RIGHT;
                        } else if (this.dir.x < 0){
                            this.facing = LEFT;
                        }
                    }
                }
            } else if(at_enemy == true && this.targetEnemy != null){
                 var enemy_dir:DHPoint = this.targetEnemy.pos.sub(footPos).normalized();
                if(Math.abs(enemy_dir.y) > Math.abs(enemy_dir.x)){
                    if(enemy_dir.y <= 0){
                        this.facing = UP;
                    } else {
                        this.facing = DOWN;
                    }
                } else {
                    if(enemy_dir.x >= 0){
                        this.facing = RIGHT;
                    } else {
                        this.facing = LEFT;
                    }
                }
            }
        }


        public function walk():void {
            var walkDirection:DHPoint = walkTarget.sub(footPos).normalized();
            this.dir = walkDirection.mulScl(this.walkSpeed);
            switch(this.facing) {
                case LEFT:
                    this.play("walk_l");
                    this.footstepOffset = this.footstepOffsets.left as DHPoint;
                    break;
                case RIGHT:
                    this.play("walk_r");
                    this.footstepOffset = this.footstepOffsets.right as DHPoint;
                    break;
                case UP:
                    this.play("walk_u");
                    this.footstepOffset = this.footstepOffsets.up as DHPoint;
                    break;
                case DOWN:
                    this.play("walk_d");
                    this.footstepOffset = this.footstepOffsets.down as DHPoint;
                    break;
            }
        }

        override public function addVisibleObjects():void {
            super.addVisibleObjects();
            FlxG.state.add(this.click_anim);
            FlxG.state.add(this.attack_sprite);
            FlxG.state.add(this.shadow_sprite);
            FlxG.state.add(this);
            FlxG.state.add(this.nameText);
            FlxG.state.add(this.debugText);
        }

        public function doMovementState():void {
            if (this.finalTarget.sub(this.footPos)._length() < 10 && !FlxG.mouse.pressed()) {
                this._state = STATE_IDLE;
                this.dir = ZERO_POINT;
            } else if (this.walkTarget.sub(this.footPos)._length() < 10 && !FlxG.mouse.pressed()) {
                if (_cur_path == null) {
                    if (this.inAttack()) {
                        this.initWalk(this.targetEnemy.getAttackPos());
                        this._state = STATE_MOVE_TO_ENEMY;
                    } else {
                        this._state = STATE_IDLE;
                        this.dir = ZERO_POINT;
                    }
                } else {
                    this._cur_path.advance();

                    if (this._cur_path.isAtFirstNode()) {
                        var destinationDisp:Number = this.footPos.sub(this.finalTarget)._length();
                        if (destinationDisp > 100) {
                            this.walkTarget = this.finalTarget;
                        } else {
                            // end the path early to avoid jerky movements at the end
                            this.finalTarget = this.footPos;
                        }
                        this._cur_path = null;
                    } else {
                        this.walkTarget = this._cur_path.currentNode.pos;
                    }
                }
            } else if (this.finalTarget.sub(this.footPos)._length() < 100) {
                this.dir = this.dir.mulScl(.7);
            }
            if (!this.positionDeltaOverThreshold() && !this.clickWait
                && !this.mouseHeld && !this.inAttack())
            {
                this._state = STATE_IDLE;
                this.dir = ZERO_POINT;
                this._cur_path = null;
            }
        }

        override public function update():void{
            if (FlxG.mouse.justPressed()) {
                this.mouseDownTime = new Date().valueOf();
            }
            if(this.walkTarget != null) {
                this.cameraPos.x = Utils.interpolate(.1, this.cameraPos.x,
                                               this.pos.center(this).x);
                this.cameraPos.y = Utils.interpolate(.1, this.cameraPos.y,
                                               this.pos.center(this).y);
            }

            if (ScreenManager.getInstance().DEBUG) {
                this.debugText.text = this.getStateString() +
                    "\nposition: " + this.pos.x + "x" + this.pos.y +
                    "\nwalkTarget: " + this.walkTarget.x + "x" + this.walkTarget.y +
                    "\nfinalTarget: " + this.finalTarget.x + "x" + this.finalTarget.y;
                if (this._cur_path != null) {
                    this.debugText.text += "\nisAtFirstNode: " + this._cur_path.isAtFirstNode();
                }
            }

            this.attack_sprite.x = this.x;
            this.attack_sprite.y = this.y - 45;

            if(this.facing == LEFT) {
                this.shadow_sprite.x = this.pos.center(this).x - 15;
                this.shadow_sprite.y = this.pos.center(this).y + 50;
            } else if(this.facing == RIGHT) {
                this.shadow_sprite.x = this.pos.center(this).x - 60;
                this.shadow_sprite.y = this.pos.center(this).y + 50;
            } else if(this.facing == UP) {
                this.shadow_sprite.x = this.pos.center(this).x - 35;
                this.shadow_sprite.y = this.pos.center(this).y + 50;
            } else if(this.facing == DOWN) {
                this.shadow_sprite.x = this.pos.center(this).x - 35;
                this.shadow_sprite.y = this.pos.center(this).y + 50;
            }

            this.basePos.y = this.y + (this.height - 10);
            this.attack_sprite.basePos.y = this.attack_sprite.y + (this.attack_sprite.height - 10);

            if(this._state != STATE_AT_ENEMY) {
                this.setFacing(false);
            }

            var timeDiff:Number = new Date().valueOf() - this.mouseDownTime;
            if (FlxG.mouse.pressed() && timeDiff > .5*GameSound.MSEC_PER_SEC && timeDiff < 1.5*GameSound.MSEC_PER_SEC) {
                this.initWalk(new DHPoint(FlxG.mouse.x, FlxG.mouse.y), false);
                this.mouseHeld = true;
            }
            if (this.mouseHeld && !FlxG.mouse.pressed()) {
                this.mouseHeld = false;
            }

            if (this._state == STATE_WALK || this._state == STATE_WALK_HARD) {
                this.walk();
                if(this.mouseHeld) {
                    this.walkTarget = new DHPoint(FlxG.mouse.x, FlxG.mouse.y);
                } else if(FlxG.mouse.justReleased()) {
                    this.click_anim_lock = false;
                }
                this.doMovementState();
            } else if (this._state == STATE_MOVE_TO_ENEMY) {
                if(this.targetEnemy != null) {
                    this.finalTarget = this.targetEnemy.getAttackPos();
                    this.doMovementState();
                    if (this.enemyIsInAttackRange(this.targetEnemy)) {
                        this._state = STATE_AT_ENEMY;
                    }
                }
                this.walk();
            } else if (this._state == STATE_AT_ENEMY) {
                this.attack();
                this.dir = ZERO_POINT;
            } else if (this._state == STATE_IN_ATTACK) {
                this.setFacing(true);
            } else if (this._state == STATE_IDLE) {
                this.setIdleAnim();
            }

            if(this._state != STATE_IN_ATTACK) {
                this.visible = true;
                this.shadow_sprite.visible = true;
                this.attack_sprite.visible = false;
            }

            if (this._bgLoaderRef != null) {
                this._bgLoaderRef.shouldCollide = this._cur_path == null &&
                    (this._state == STATE_MOVE_TO_ENEMY ||
                     this._state == STATE_WALK);
            }

            if (this._cur_path == null && this.colliding) {
                if (this.collisionDirection != null) {
                    if (this.collisionDirection[0] == 1 &&
                        this.collisionDirection[1] == 1 &&
                        this.collisionDirection[2] == 1 &&
                        this.collisionDirection[3] == 1)
                    {
                        // stuck!
                        this._state = STATE_WALK_HARD;
                        var closest:MapNode = this._mapnodes.getClosestNode(this.pos);
                        if (this._mapnodes != null && closest != null) {
                            this.walkTarget = closest.pos;
                        } else {
                            var _screen:ScreenManager = ScreenManager.getInstance();
                            this.walkTarget = new DHPoint(_screen.screenWidth/2, this.y);
                        }
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

            super.update();

            if(this.click_anim.frame == 10) {
                this.click_anim.visible = false;
                this.click_anim.play("idle");
            }
        }

        public function pushPos():void {
            this.lastPositions.push(new DHPoint(this.pos.x, this.pos.y));
            GlobalTimer.getInstance().setMark("trail_update",
                .1*GameSound.MSEC_PER_SEC, this.pushPos, true);
        }

        public function positionDeltaOverThreshold():Boolean {
            var pa:DHPoint = this.lastPositions[0];
            var pb:DHPoint = this.lastPositions[this.lastPositions.length - 1];
            return pa.sub(pb)._length() > 5;
        }

        override public function resolveStatePostAttack():void {
            if (!(FlxG.state is LevelMapState)) {
                return;
            }
            super.resolveStatePostAttack();

            this.attack_sound_lock = false;

            if (this.targetEnemy != null && !this.targetEnemy.isDead())
            {
                if(this.enemyIsInAttackRange(this.targetEnemy)) {
                    this._state = STATE_AT_ENEMY;
                } else {
                    this.initWalk(this.targetEnemy.getAttackPos());
                    this._state = STATE_MOVE_TO_ENEMY;
                }
            } else {
                if (this.targetEnemy != null) {
                    if (this.targetEnemy.isDead()) {
                        this.targetEnemy = null;
                    }
                }
                this._state = STATE_IDLE;
            }
        }

        public function setIdleAnim():void {
            if(this.facing == UP) {
                this.play("idle_u");
            } else if(this.facing == DOWN) {
                this.play("idle_d");
            } else if(this.facing == LEFT) {
                this.play("idle_l");
            } else if(this.facing == RIGHT) {
                this.play("idle_r");
            }
        }

        public function inAttack():Boolean {
            return (this._state == STATE_IN_ATTACK || this._state == STATE_AT_ENEMY || this._state == STATE_MOVE_TO_ENEMY);
        }

        public function addAttackAnim():void {
        }

        override public function setPos(pos:DHPoint):void {
            super.setPos(pos);

            this.mapHitbox.x = pos.x + this.hitboxOffset.x;
            this.mapHitbox.y = pos.y + this.hitboxOffset.y;
        }

        public function playReverseAttack():void {
            if (!(FlxG.state is LevelMapState)) {
                return;
            }
            this.attack_sprite.play("reverse_attack");
            GlobalTimer.getInstance().setMark("attack_finished_reverse",
                    (23.0/13.0)*GameSound.MSEC_PER_SEC, function():void {
                        resolveStatePostAttack();
                    }, true);
        }

        override public function attack():void {
            super.attack();
            if (this._state == STATE_IN_ATTACK) {
                this.attack_sprite.visible = true;
                this.visible = false;
                this.shadow_sprite.visible = false;
                this.attack_sprite.play("attack");
                GlobalTimer.getInstance().setMark("attack_finished",
                    (23.0/13.0)*GameSound.MSEC_PER_SEC, function():void {
                        playReverseAttack();
                    }, true);

                if (!this.attack_sound_lock) {
                    this.playAttackSound();
                    this.attack_sound_lock = true;
                }
            }
        }

        public function isMoving():Boolean {
            return this._state == STATE_WALK || this._state == STATE_WALK_HARD;
        }

    }
}
