package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.management.Path;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.DebugConsoleManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.EnemyGroup;
    import com.starmaid.Cibele.utils.MapNodeContainer;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.states.PathEditorState;
    import com.starmaid.Cibele.states.LevelMapState;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class PathFollower extends PartyMember {
        [Embed(source="/../assets/images/characters/Sprite_Ichi_Walk_Cycle.png")] private var ImgIchi:Class;
        [Embed(source="/../assets/images/characters/Ichi_attack sprite.png")] private var ImgIchiAttack:Class;
        [Embed(source="/../assets/audio/effects/sfx_protoattack1.mp3")] private var SfxAttack1:Class;
        [Embed(source="/../assets/audio/effects/sfx_protoattack2.mp3")] private var SfxAttack2:Class;
        [Embed(source="/../assets/audio/effects/sfx_protoattack3.mp3")] private var SfxAttack3:Class;
        [Embed(source="/../assets/audio/effects/sfx_protoattack4.mp3")] private var SfxAttack4:Class;

        private var _precon_path:Path;
        private var _enemies:EnemyGroup;
        private var targetNode:MapNode;
        private var runSpeed:Number = 7;
        private var _bossRef:BossEnemy;
        private var closestEnemy:Enemy;
        private var playerRef:Player;
        private var attackAnim:GameObject;
        public var disp:DHPoint, playerPosAtLastWarp:DHPoint;

        private static const TARGET_PLAYER:Number = 1;
        private static const TARGET_ENEMY:Number = 2;
        private static const TARGET_NODE:Number = 3;
        private static const TARGET_NONE:Number = 0;
        private var _cur_target_type:Number;

        private static const MARK_PLAYER_MOVE:String = "pmovemark";

        public static const STATE_IDLE:Number = 7;
        public static const ATTACK_RANGE:Number = 150;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_NULL] = "STATE_NULL";
            stateMap[STATE_WALK] = "STATE_WALK";
            stateMap[STATE_AT_ENEMY] = "STATE_AT_ENEMY";
            stateMap[STATE_IN_ATTACK] = "STATE_IN_ATTACK";
            stateMap[STATE_IDLE] = "STATE_IDLE";

            public static var targetTypeMap:Dictionary = new Dictionary();
            targetTypeMap[TARGET_PLAYER] = "TARGET_PLAYER";
            targetTypeMap[TARGET_ENEMY] = "TARGET_ENEMY";
            targetTypeMap[TARGET_NODE] = "TARGET_NODE";
            targetTypeMap[TARGET_NONE] = "TARGET_NONE";
        }

        public function PathFollower(pos:DHPoint) {
            super(pos);

            this.sightRange = 800;
            this.nameText.text = "Ichi";
            this.slug = "PathFollower";
            this.zSorted = true;
            this.basePos = new DHPoint(this.x, this.y + (this.height-10));
            this.debugText.color = 0xff444444;
            this.disp = new DHPoint(0, 0);
            this.attackRange = 90;
            this.attackSounds = new Array(SfxAttack1, SfxAttack2, SfxAttack3, SfxAttack4);

            this.setupSprites();
            this.setupFootsteps();
            this.setupDebugSprites();

            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.pos", "ichi.pos");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.getStateString", "ichi.state");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.getTargetTypeString", "ichi.targetType");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.isAtTarget", "ichi.isAtTarget");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.disp._length", "ichi.disp");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.walkTarget", "ichi.walkTarget");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.hasCurPath", "ichi.hasPath");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.inAttack", "ichi.inAttack");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.sightRange", "ichi.sightRange");
        }

        override public function setupFootsteps():void {
            this.footstepOffsets.up = new DHPoint(70, this.height);
            this.footstepOffsets.down = this.footstepOffsets.up;
            this.footstepOffsets.left = new DHPoint(90, this.height-20);
            this.footstepOffsets.right = this.footstepOffsets.left;
            this.footstepOffset = this.footstepOffsets.up as DHPoint;
        }

        override public function setupSprites():void {
            // base sprite
            this.loadGraphic(ImgIchi, true, false, 151, 175);
            this.addAnimation("walk_u", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, false);
            this.addAnimation("idle_u", [0], 20, false);
            this.addAnimation("walk_l",
                [24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10],
                20, false);
            this.addAnimation("idle_l", [10], 20, false);
            this.addAnimation("walk_r",
                [38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25],
                20, false);
            this.addAnimation("idle_r", [25], 20, false);
            this.addAnimation("walk_d",
                [39, 40, 41, 42, 43, 44, 45, 46, 47, 48],
                20, false);
            this.addAnimation("idle_d", [39], 20, false);

            // attack animation
            this.attackAnim = new GameObject(this.pos);
            this.attackAnim.loadGraphic(ImgIchiAttack, true, false, 99, 175);
            this.attackAnim.addAnimation("attack",
                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
                15, false);
            this.attackAnim.addAnimation("reverse_attack",
                [20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
                15, false);
            this.attackAnim.addAnimation("idle", [0], 15, false);
            this.attackAnim.zSorted = true;
            this.attackAnim.basePos = new DHPoint(0, 0);
            this.attackAnim.visible = false;

            this.buildShadowSprite();
        }

        public function getStateString():String {
            return PathFollower.stateMap[this._state] == null ? "unknown" : PathFollower.stateMap[this._state];
        }

        public function getTargetTypeString():String {
            return PathFollower.targetTypeMap[this._cur_target_type] == null ? "unknown" : PathFollower.targetTypeMap[this._cur_target_type];
        }

        override public function addVisibleObjects():void {
            super.addVisibleObjects();
            FlxG.state.add(this);
            FlxG.state.add(this.attackAnim);
            FlxG.state.add(this.shadow_sprite);
            FlxG.state.add(this.nameText);
        }

        public function walk():void {
            switch(this.facing) {
                case LEFT:
                    this.play("walk_l");
                    break;
                case RIGHT:
                    this.play("walk_r");
                    break;
                case UP:
                    this.play("walk_u");
                    break;
                case DOWN:
                    this.play("walk_d");
                    break;
            }
            this.footstepOffset = this.footstepOffsets[this.text_facing] as DHPoint;
        }

        public function setFacing():void {
            if(this.dir != null && this.dir._length() > 2){
                if(Math.abs(this.dir.y) > Math.abs(this.dir.x)){
                    if(this.dir.y <= 0){
                        this.facing = UP;
                        this.text_facing = "up";
                    } else {
                        this.facing = DOWN;
                        this.text_facing = "down";
                    }
                } else {
                    if(this.dir.x >= 0){
                        this.facing = RIGHT;
                        this.text_facing = "right";
                    } else {
                        this.facing = LEFT;
                        this.text_facing = "left";
                    }
                }
            }
        }

        public function setAuxPositions():void {
            // set shadow sprite position based on facing
            switch(this.facing) {
                case LEFT:
                    this.shadow_sprite.x = this.pos.center(this).x - 15;
                    this.shadow_sprite.y = this.pos.center(this).y + 60;
                    break;
                case RIGHT:
                    this.shadow_sprite.x = this.pos.center(this).x - 35;
                    this.shadow_sprite.y = this.pos.center(this).y + 60;
                    break;
                case UP:
                    this.shadow_sprite.x = this.pos.center(this).x - 35;
                    this.shadow_sprite.y = this.pos.center(this).y + 60;
                    break;
                case DOWN:
                    this.shadow_sprite.x = this.pos.center(this).x - 35;
                    this.shadow_sprite.y = this.pos.center(this).y + 60;
                    break;
            }

            // maintain base positions for y-axis based z-sorting
            this.basePos.x = this.x;
            this.basePos.y = this.y + (this.height - 10);
            this.attackAnim.basePos.x = this.attackAnim.x;
            this.attackAnim.basePos.y = this.attackAnim.y + (this.attackAnim.height - 10);
        }

        public function setTargetEnemy():void {
            if (this._bossRef != null && this._bossRef.bossHasAppeared) {
                this.targetEnemy = this._bossRef;
            } else if(this.playerIsAttacking() && !this.playerRef.targetEnemy.dead) {
                this.targetEnemy = this.playerRef.targetEnemy;
            } else {
                this.targetEnemy = this.closestEnemy;
            }
        }

        public function performPlayerWarpLogic():void {
            if (!this.inViewOfPlayer()) {
                GlobalTimer.getInstance().setMark("inview", 7*GameSound.MSEC_PER_SEC);
            } else {
                GlobalTimer.getInstance().deleteMark("inview");
            }
            if (GlobalTimer.getInstance().hasPassed("inview")) {
                GlobalTimer.getInstance().deleteMark("inview");
                // when deciding whether to warp, only do it if the player is not
                // in the same position as it was at the time of the last warp
                if(this.playerHasMovedSinceLastWarp()) {
                    this.warpToPlayer();
                    this.playerPosAtLastWarp = this.playerRef.pos;
                }
            }
        }

        public function playerHasMovedSinceLastWarp():Boolean {
            return this.playerPosAtLastWarp.sub(this.playerRef.pos)._length() > 200;
        }

        public function isAtTarget():Boolean {
            switch (this._cur_target_type) {
                case TARGET_PLAYER:
                    return this.playerIsInMovementRange();
                case TARGET_ENEMY:
                    return this.enemyIsInAttackRange(this.targetEnemy);
                case TARGET_NODE:
                    return this.finalTarget.sub(this.footPos)._length() < 10;
                default:
                    return false;
            }
        }

        public function doAtTargetState():void {
            switch (this._cur_target_type) {
                case TARGET_PLAYER:
                    this.moveToNearestPathNode();
                    break;
                case TARGET_ENEMY:
                    this._state = STATE_AT_ENEMY;
                    break;
                case TARGET_NODE:
                    this.enterIdleState();
                    break;
            }
        }

        override public function toggleActive(player:Player):void {
            this.active = true;
        }

        public function updateFinalTarget():void {
            switch (this._cur_target_type) {
                case TARGET_PLAYER:
                    this.finalTarget = this.playerRef.pos;
                    break;
                case TARGET_ENEMY:
                    this.finalTarget = this.targetEnemy.getAttackPos();
                    break;
                case TARGET_NODE:
                    break;
            }
        }

        public function inAttack():Boolean {
            return (this._state == STATE_IN_ATTACK || this._state == STATE_AT_ENEMY);
        }

        public function isMovingToEnemy():Boolean {
            return (this._state == STATE_WALK && this._cur_target_type == TARGET_ENEMY);
        }

        public function doMovementState():void {
            if (this.isAtTarget()) {
                this.doAtTargetState();
            } else if (this.walkTarget.sub(this.footPos)._length() < 10) {
                if (this._cur_path != null) {
                    this._cur_path.advance();
                    if (this._cur_path.isAtFirstNode()) {
                        var destinationDisp:Number = this.footPos.sub(this.finalTarget)._length();
                        if (destinationDisp > 100) {
                            this.walkTarget = this.finalTarget;
                        }
                        this._cur_path = null;
                    } else {
                        this.walkTarget = this._cur_path.currentNode.pos;
                    }
                } else {
                    this.enterIdleState();
                }
            }
        }

        public function playerWaitHasTimedOut():Boolean {
            return GlobalTimer.getInstance().hasPassed(MARK_PLAYER_MOVE);
        }

        override public function update():void {
            super.update();

            // don't run the PathFollower while in edit mode
            if((FlxG.state as PathEditorState).editorMode == PathEditorState.MODE_EDIT) {
                return;
            }

            this.setFacing();
            this.setAuxPositions();
            this.setClosestEnemy();
            this.setTargetEnemy();
            this.performPlayerWarpLogic();
            this.disp = this.walkTarget.sub(this.footPos);

            switch(this._state) {
                case STATE_WALK:
                    this.updateFinalTarget();
                    this.walk();
                    this.dir = disp.normalized().mulScl(this.runSpeed);
                    this.doMovementState();
                    this.evaluateEnemyDistance();
                    break;

                case STATE_IDLE:
                    this.dir = ZERO_POINT;
                    if(this.playerIsInMovementRange() || this.playerWaitHasTimedOut()) {
                        this.moveToNextPathNode();
                    }
                    this.evaluateEnemyDistance();
                    break;

                case STATE_AT_ENEMY:
                    this.attack();
                    this.dir = ZERO_POINT;
                    break;

                case STATE_IN_ATTACK:
                    this.dir = ZERO_POINT;
                    break;
            }
        }

        public function evaluateEnemyDistance():Boolean {
            // don't move to offscreen enemies unless the player is moving
            if (!this.targetEnemy.isOnscreen()) {
                if (this.playerRef.dir.x == this.playerRef.dir.y == 0) {
                    return false;
                }
            }
            if (this.enemyIsInAttackRange(this.targetEnemy)) {
                this._state = STATE_AT_ENEMY;
                return true;
            } else if(this.enemyIsInMoveTowardsRange(this.targetEnemy)) {
                if (!this.isMovingToEnemy()) {
                    this.initWalk(this.targetEnemy.getAttackPos());
                    this._cur_target_type = TARGET_ENEMY;
                }
                return true;
            }
            return false;
        }

        public function enterIdleState():void {
            this._state = STATE_IDLE;
            GlobalTimer.getInstance().setMark(MARK_PLAYER_MOVE, (Math.random()*3)*GameSound.MSEC_PER_SEC, null, true);
            this.setNearestPathNodeCurrent();
        }

        override public function resolveStatePostAttack():void {
            super.resolveStatePostAttack();
            if (!this.evaluateEnemyDistance()) {
                this.enterIdleState();
            }
            this.attackAnim.visible = false;
            this.visible = true;
        }

        public function setClosestEnemy():void {
            var shortest:Number = 99999999;
            var ret:Enemy = null;
            var en_disp:Number;
            var cur:Enemy;
            for (var i:int = 0; i < this._enemies.length(); i++) {
                cur = this._enemies.get_(i);
                en_disp = cur.pos.sub(this.pos)._length();
                if (en_disp < shortest && !cur.dead) {
                    shortest = en_disp;
                    ret = cur;
                }
            }
            this.closestEnemy = ret;
        }

        public function set precon_path(path:Path):void {
            this._precon_path = path;
        }

        public function setEnemyGroupReference(_group:EnemyGroup):void {
            this._enemies = _group;
        }

        public function moveToNextPathNode():void {
            this._precon_path.advance();
            this.targetNode = this._precon_path.currentNode;
            this.initWalk(this.targetNode.pos);
            this._cur_target_type = TARGET_NODE;
        }

        public function setNearestPathNodeCurrent():MapNode {
            var n:MapNode = this._precon_path.getClosestNode(this.footPos);
            this._precon_path.setCurrentNode(this.targetNode as PathNode);
            return n;
        }

        public function moveToNearestPathNode():void {
            this.targetNode = this.setNearestPathNodeCurrent();
            this.initWalk(this.targetNode.pos);
            this._cur_target_type = TARGET_NODE;
        }

        public function moveToNextNode():void {
            this.targetNode = this._mapnodes.getClosestNode(this.pos, this.targetNode);
            if (this.targetNode == null) {
                return;
            }
            this.initWalk(this.targetNode.pos);
            this._cur_target_type = TARGET_NODE;
            if(this.targetNode._type == MapNode.TYPE_PATH) {
                this._precon_path.setCurrentNode(this.targetNode as PathNode);
            }
        }

        public function setPlayerReference(pl:Player):void {
            this.playerRef = pl;
            this.playerPosAtLastWarp = this.playerRef.pos;
        }

        public function playerIsInMovementRange():Boolean {
            if (this.playerRef == null) { return false; }
            return this.playerRef.pos.sub(this.pos)._length() < 300;
        }

        public function inViewOfPlayer():Boolean {
            return !(this.playerRef.pos.sub(this.pos)._length() >
                    ScreenManager.getInstance().screenWidth);
        }

        public function playerIsAttacking():Boolean {
            return (inViewOfPlayer() && playerRef.inAttack() && playerRef.targetEnemy != null);
        }

        public function warpToPlayer():void {
            var dir:DHPoint = new DHPoint(this.playerRef.dir.x, this.playerRef.dir.y);
            var targetPoint:DHPoint = this.playerRef.pos.add(dir.normalized()
                .mulScl(ScreenManager.getInstance().screenWidth));
            var warpNode:MapNode = this._mapnodes.getClosestNode(targetPoint, null, false);
            if (warpNode != null) {
                this.setPos(warpNode.pos.sub(this.footPos.sub(this.pos)));
            }
            this.initWalk(this.playerRef.footPos);
            this._cur_target_type = TARGET_PLAYER;
            this.attackAnim.visible = false;
            this.visible = true;
        }

        public function reverseAttackAnim():void {
            // since this is called asynchronously, don't do it if we've switched states
            if (!(FlxG.state is LevelMapState)) {
                return;
            }
            this.attackAnim.play("reverse_attack");
            GlobalTimer.getInstance().setMark(
                "attack anim stuff reverse", 1*GameSound.MSEC_PER_SEC,
                this.resolveStatePostAttack, true
            );
        }

        override public function attack():void {
            super.attack();
            if (this._state == STATE_IN_ATTACK) {
                GlobalTimer.getInstance().setMark(
                    "attack anim stuff", 1*GameSound.MSEC_PER_SEC,
                    this.reverseAttackAnim, true
                );
                this.attackAnim.x = this.x + 20;
                this.attackAnim.y = this.y;
                this.attackAnim.visible = true;
                this.attackAnim.play("attack");
                this.visible = false;

                if(this.inViewOfPlayer()) {
                    this.playAttackSound();
                }
            }
        }

        public function set bossRef(ref:BossEnemy):void {
            this._bossRef = ref;
        }

        public function get pathRef():Path {
            return this._precon_path;
        }
    }
}
