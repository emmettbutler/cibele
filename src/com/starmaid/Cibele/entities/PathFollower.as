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

        private var _path:Path;
        private var _mapnodes:MapNodeContainer;
        private var _enemies:EnemyGroup;
        private var targetPathNode:PathNode, targetMapNode:MapNode;
        private var lastInViewTime:Number = 0, runSpeed:Number = 7;
        private var _bossRef:BossEnemy;
        private var closestEnemy:Enemy;
        private var playerRef:Player;
        private var disp:DHPoint;
        private var attackAnim:GameObject;

        public static const STATE_MOVE_TO_PATH_NODE:Number = 2;
        public static const STATE_IDLE_AT_PATH_NODE:Number = 3;
        public static const STATE_MOVE_TO_MAP_NODE:Number = 6;
        public static const STATE_IDLE_AT_MAP_NODE:Number = 7;
        public static const STATE_MOVE_TO_PLAYER:Number = 8;
        public static const ATTACK_RANGE:Number = 150;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_NULL] = "STATE_NULL";
            stateMap[STATE_MOVE_TO_PATH_NODE] = "STATE_MOVE_TO_PATH_NODE";
            stateMap[STATE_IDLE_AT_PATH_NODE] = "STATE_IDLE_AT_PATH_NODE";
            stateMap[STATE_AT_ENEMY] = "STATE_AT_ENEMY";
            stateMap[STATE_IN_ATTACK] = "STATE_IN_ATTACK";
            stateMap[STATE_MOVE_TO_ENEMY] = "STATE_MOVE_TO_ENEMY";
            stateMap[STATE_MOVE_TO_MAP_NODE] = "STATE_MOVE_TO_MAP_NODE";
            stateMap[STATE_IDLE_AT_MAP_NODE] = "STATE_IDLE_AT_MAP_NODE";
            stateMap[STATE_MOVE_TO_PLAYER] = "STATE_MOVE_TO_PLAYER";
        }

        public function PathFollower(pos:DHPoint) {
            super(pos);

            this.nameText.text = "Ichi";
            this.zSorted = true;
            this.basePos = new DHPoint(this.x, this.y + (this.height-10));
            this.debugText.color = 0xff444444;
            this.disp = new DHPoint(0, 0);
            this.attackRange = 90;
            this.attackSounds = new Array(SfxAttack1, SfxAttack2, SfxAttack3, SfxAttack4);

            this.setupSprites();
            this.setupFootsteps();

            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.pos", "ichi.pos");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.pathWalker.getStateString", "ichi.state");
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

        override public function addVisibleObjects():void {
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

            // maintain base position for y-axis based z-sorting
            this.basePos.x = this.x;
            this.basePos.y = this.y + (this.height - 10);
            this.attackAnim.basePos.x = this.attackAnim.x;
            this.attackAnim.basePos.y = this.attackAnim.y + (this.attackAnim.height - 10);
        }

        public function setTargetEnemy():void {
            if (this._bossRef != null && this._bossRef.bossHasAppeared) {
                this.targetEnemy = this._bossRef;
            } else {
                this.targetEnemy = this.closestEnemy;
            }
        }

        public function performPlayerWarpLogic():void {
            if (this.inViewOfPlayer()) {
                this.lastInViewTime = this.currentTime;
            }
            if (this.currentTime - this.lastInViewTime >= 7*GameSound.MSEC_PER_SEC) {
                this.warpToPlayer();
            }
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

            switch(this._state) {
                case STATE_MOVE_TO_PATH_NODE:
                    this.walk();
                    if (!this._path.hasNodes()) {
                        this._state = STATE_NULL;
                    } else {
                        disp = this.targetPathNode.pos.sub(this.pos);
                        if (disp._length() < 10) {
                            this._state = STATE_IDLE_AT_PATH_NODE;
                        } else {
                            this.dir = disp.normalized().mulScl(this.runSpeed);
                        }
                    }
                    if (this.enemyIsInAttackRange(this.targetEnemy)) {
                        this._state = STATE_AT_ENEMY;
                    } else if(this.enemyIsInMoveTowardsRange(this.targetEnemy)) {
                        if (this.targetEnemy.getAttackPos().sub(this.footPos)._length() > (this.targetEnemy is BossEnemy ? this.bossSightRange : this.sightRange))
                        {
                            this.moveToNextPathNode();
                        } else {
                            this.walkTarget = this.targetEnemy.getAttackPos();
                            this._state = STATE_MOVE_TO_ENEMY;
                        }
                    }
                    break;
                case STATE_MOVE_TO_MAP_NODE:
                    this.walk();
                    if (!this._mapnodes.hasNodes()) {
                        this._state = STATE_NULL;
                    } else {
                        disp = this.targetMapNode.pos.sub(this.pos);
                        if (disp._length() < 10) {
                            if(this.targetMapNode._type == MapNode.TYPE_PATH){
                                this._state = STATE_IDLE_AT_PATH_NODE;
                            } else if(this.targetMapNode._type == MapNode.TYPE_MAP){
                                this._state = STATE_IDLE_AT_MAP_NODE;
                            }
                            if (this.enemyIsInAttackRange(this.targetEnemy)) {
                                this._state = STATE_AT_ENEMY;
                            } else if(this.enemyIsInMoveTowardsRange(this.targetEnemy)) {
                                this.walkTarget = this.targetEnemy.getAttackPos();
                                this._state = STATE_MOVE_TO_ENEMY;
                            }
                        } else {
                            this.dir = disp.normalized().mulScl(this.runSpeed);
                        }
                    }
                    break;
                case STATE_IDLE_AT_PATH_NODE:
                    if(teamAttack()) {
                        this.attackPlayerTargetEnemy();
                    } else {
                        this.markCurrentNode();
                        if(this.playerIsInMovementRange()){
                            this.moveToNextPathNode();
                        } else if (this.enemyIsInAttackRange(this.targetEnemy)) {
                            this._state = STATE_AT_ENEMY;
                        } else if(this.enemyIsInMoveTowardsRange(this.targetEnemy)) {
                            this.walkTarget = this.targetEnemy.getAttackPos();
                            this._state = STATE_MOVE_TO_ENEMY;
                        }
                        this.dir = ZERO_POINT;
                    }
                    break;
                case STATE_IDLE_AT_MAP_NODE:
                    if(teamAttack()) {
                        this.attackPlayerTargetEnemy();
                    } else {
                        if(this.playerIsInMovementRange()){
                            this.moveToNextNode();
                        }
                        //if (this.enemyIsInAttackRange(this.targetEnemy)) {
                        //    this._state = STATE_AT_ENEMY;
                        //} else if(this.enemyIsInMoveTowardsRange(this.targetEnemy)) {
                        //    this._state = STATE_MOVE_TO_ENEMY;
                        //}
                        this.dir = ZERO_POINT;
                    }
                    break;
                case STATE_AT_ENEMY:
                    this.attack();
                    this.dir = ZERO_POINT;
                    break;
                case STATE_MOVE_TO_ENEMY:
                    this.walk();
                    this.walkTarget = this.targetEnemy.getAttackPos();
                    this.disp = this.walkTarget.sub(this.footPos).normalized();
                    this.dir = this.disp.mulScl(this.runSpeed);
                    if (this.enemyIsInAttackRange(this.targetEnemy)) {
                        this._state = STATE_AT_ENEMY;
                    } else if (this.targetEnemy.getAttackPos()
                        .sub(this.footPos)._length() >
                        (this.targetEnemy is BossEnemy ? this.bossSightRange : this.sightRange) && !this.teamAttack())
                    {
                        this.moveToNextNode();
                    }
                    break;
                case STATE_IN_ATTACK:
                    this.dir = ZERO_POINT;
                    break;
                case STATE_MOVE_TO_PLAYER:
                    this.walk();
                    this.disp = this.playerRef.pos.sub(this.footPos).normalized();
                    this.dir = this.disp.mulScl(this.runSpeed);
                    if (this.playerIsInMovementRange()) {
                        this.moveToNextNode();
                    }
                    break;
            }
        }

        override public function resolveStatePostAttack():void {
            super.resolveStatePostAttack();
            if (this.targetEnemy != null && !this.targetEnemy.dead && this.targetEnemy.visible == true)
            {
                if (this.enemyIsInAttackRange(this.targetEnemy))
                {
                    this._state = STATE_AT_ENEMY;
                } else {
                    this.walkTarget = this.targetEnemy.getAttackPos();
                    this._state = STATE_MOVE_TO_ENEMY;
                }
            } else {
                this.moveToNextNode();
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

        public function setPath(path:Path):void {
            this._path = path;
        }

        public function setMapNodes(nodes:MapNodeContainer):void {
            this._mapnodes = nodes;
        }

        public function setEnemyGroupReference(_group:EnemyGroup):void {
            this._enemies = _group;
        }

        public function moveToNextPathNode():void {
            this._path.advance();
            this.targetPathNode = this._path.currentNode;
            this._state = STATE_MOVE_TO_PATH_NODE;
        }

        public function moveToNextNode():void {
            this.targetMapNode = this._mapnodes.getClosestNode(this.pos, this.targetMapNode);
            if (this.targetMapNode == null) {
                return;
            }
            if(this.targetMapNode._type == MapNode.TYPE_MAP) {
                this._state = STATE_MOVE_TO_MAP_NODE;
                this.targetMapNode = this.targetMapNode;
            } else if(this.targetMapNode._type == MapNode.TYPE_PATH) {
                this._state = STATE_MOVE_TO_PATH_NODE;
                this.targetPathNode = this.targetMapNode as PathNode;
                this._path.setCurrentNode(this.targetPathNode);
            }
        }

        public function markCurrentNode():void{
            this.targetPathNode.mark();
        }

        public function setPlayerReference(pl:Player):void {
            this.playerRef = pl;
        }

        public function playerIsInMovementRange():Boolean {
            if (this.playerRef == null) { return false; }
            return this.playerRef.pos.sub(this.pos)._length() < 300;
        }

        public function inViewOfPlayer():Boolean {
            return !(this.playerRef.pos.sub(this.pos)._length() >
                    ScreenManager.getInstance().screenWidth / 2);
        }

        public function teamAttack():Boolean {
            return (inViewOfPlayer() && playerRef.inAttack() && playerRef.targetEnemy != null);
        }

        public function attackPlayerTargetEnemy():void {
            if(playerRef.targetEnemy != null) {
                this.targetEnemy = playerRef.targetEnemy;
                this._state = STATE_MOVE_TO_ENEMY;
            }
        }

        public function warpToPlayer():void {
            var dir:DHPoint = new DHPoint(this.playerRef.dir.x, this.playerRef.dir.y);
            var targetPoint:DHPoint = this.playerRef.pos.add(dir.normalized().mulScl(555));
            var warpNode:MapNode = this._mapnodes.getClosestNode(targetPoint, null, false);
            if (warpNode != null) {
                this.setPos(warpNode.pos);
            }
            this._state = STATE_MOVE_TO_PLAYER;
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
            return this._path;
        }
    }
}
