package {
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class PathFollower extends PartyMember
    {
        [Embed(source="../assets/images/characters/Sprite_Ichi_Walk_Cycle.png")] private var ImgIchi:Class;
        [Embed(source="../assets/images/characters/Ichi_attack sprite.png")] private var ImgIchiAttack:Class;
        [Embed(source="../assets/images/characters/cib_shadow.png")] private var ImgShadow:Class;
        [Embed(source="../assets/audio/effects/sfx_protoattack1.mp3")] private var SfxAttack1:Class;
        [Embed(source="../assets/audio/effects/sfx_protoattack2.mp3")] private var SfxAttack2:Class;
        [Embed(source="../assets/audio/effects/sfx_protoattack3.mp3")] private var SfxAttack3:Class;
        [Embed(source="../assets/audio/effects/sfx_protoattack4.mp3")] private var SfxAttack4:Class;

        public var _path:Path;
        public var _mapnodes:MapNodeContainer;
        public var _enemies:EnemyGroup;
        public var targetPathNode:PathNode, targetMapNode:MapNode;
        public var lastInViewTime:Number = 0;

        public var runSpeed:Number = 8;
        public var bossRef:BossEnemy;

        public var closestEnemy:Enemy;
        public var playerRef:Player;
        public var walkTarget:DHPoint;
        public var disp:DHPoint;
        public var upDownFootstepOffset:DHPoint;
        public var leftRightFootstepOffset:DHPoint;

        public var attackAnim:GameObject;

        public static const STATE_MOVE_TO_PATH_NODE:Number = 2;
        public static const STATE_IDLE_AT_PATH_NODE:Number = 3;
        public static const STATE_MOVE_TO_MAP_NODE:Number = 6;
        public static const STATE_IDLE_AT_MAP_NODE:Number = 7;
        public static const STATE_MOVE_TO_PLAYER:Number = 8;

        public var shadow_sprite:GameObject;

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
            this.shadow_sprite = new GameObject(this.pos);
            this.shadow_sprite.zSorted = true;
            this.shadow_sprite.loadGraphic(ImgShadow,false,false,70,42);
            this.shadow_sprite.alpha = .7;

            this.tag = PartyMember.ichi;

            this.basePos = new DHPoint(this.x, this.y + (this.height-10));

            this.zSorted = true;

            loadGraphic(ImgIchi, true, false, 151, 175);

            addAnimation("walk_u", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, false);
            addAnimation("idle_u", [0], 20, false);
            addAnimation("walk_l",
                [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24],
                20, false);
            addAnimation("idle_l", [10], 20, false);
            addAnimation("walk_r",
                [25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
                20, false);
            addAnimation("idle_r", [25], 20, false);
            addAnimation("walk_d",
                [39, 40, 41, 42, 43, 44, 45, 46, 47, 48],
                20, false);
            addAnimation("idle_d", [39], 20, false);
            this.targetPathNode = null;
            this._state = STATE_NULL;

            this.upDownFootstepOffset = new DHPoint(70, this.height);
            this.leftRightFootstepOffset = new DHPoint(90, this.height-20);
            this.footstepOffset = this.upDownFootstepOffset;

            this.attackRange = 90;

            this.walkTarget = new DHPoint(0, 0);
            this.disp = new DHPoint(0, 0);

            this.debugText.color = 0xff444444;
        }

        override public function addVisibleObjects():void {
            FlxG.state.add(this);
            this.addAttackAnim();
            FlxG.state.add(this.shadow_sprite);
            FlxG.state.add(this.nameText);
        }

        public function walk():void {
            if(this.facing == LEFT){
                this.play("walk_l");
                this.footstepOffset = this.leftRightFootstepOffset;
            } else if (this.facing == RIGHT){
                this.play("walk_r");
                this.footstepOffset = this.leftRightFootstepOffset;
            } else if(this.facing == UP){
                this.play("walk_u");
                this.footstepOffset = this.upDownFootstepOffset;
            } else if(this.facing == DOWN){
                this.play("walk_d");
                this.footstepOffset = this.upDownFootstepOffset;
            }
        }

        public function setFacing():void {
            if(this.dir != null && this.dir._length() > 2){
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

        override public function update():void {
            super.update();

            if (ScreenManager.getInstance().DEBUG) {
                this.debugText.text = PathFollower.stateMap[this._state];
            }

            if(this.facing == LEFT) {
                this.shadow_sprite.x = this.pos.center(this).x - 15;
                this.shadow_sprite.y = this.pos.center(this).y + 60;
            } else if(this.facing == RIGHT) {
                this.shadow_sprite.x = this.pos.center(this).x - 35;
                this.shadow_sprite.y = this.pos.center(this).y + 60;
            } else if(this.facing == UP) {
                this.shadow_sprite.x = this.pos.center(this).x - 35;
                this.shadow_sprite.y = this.pos.center(this).y + 60;
            } else if(this.facing == DOWN) {
                this.shadow_sprite.x = this.pos.center(this).x - 35;
                this.shadow_sprite.y = this.pos.center(this).y + 60;
            }

            this.basePos.y = this.y + (this.height - 10);
            this.attackAnim.basePos.y = this.attackAnim.y + (this.attackAnim.height - 10);

            this.closestEnemy = this.getClosestEnemy();
            if (this.bossRef != null && this.bossRef.bossHasAppeared) {
                this.targetEnemy = this.bossRef;
            } else {
                this.targetEnemy = this.closestEnemy;
            }
            if (this.inViewOfPlayer()) {
                lastInViewTime = this.currentTime;
            }
            if (this.shouldWarpToPlayer()) {
                this.warpToPlayer();
            }

            this.setFacing();

            if (this._state == STATE_MOVE_TO_PATH_NODE) {
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
                    this.targetEnemy.activeTarget();
                } else if(this.enemyIsInMoveTowardsRange(this.targetEnemy)) {
                    if (this.targetEnemy.getAttackPos().sub(this.footPos)._length() > (this.targetEnemy is BossEnemy ? this.bossSightRange : this.sightRange))
                    {
                        //TODO write moveToNextMapNode since
                        //path node could be weirdly far...
                        this.moveToNextPathNode();
                    } else {
                        this.walkTarget = this.targetEnemy.getAttackPos();
                        this._state = STATE_MOVE_TO_ENEMY;
                    }
                }
            } else if (this._state == STATE_MOVE_TO_MAP_NODE) {
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
                            this.targetEnemy.activeTarget();
                        } else if(this.enemyIsInMoveTowardsRange(this.targetEnemy)) {
                            this.walkTarget = this.targetEnemy.getAttackPos();
                            this._state = STATE_MOVE_TO_ENEMY;
                        }
                    } else {
                        this.dir = disp.normalized().mulScl(this.runSpeed);
                    }
                }
            } else if (this._state == STATE_IDLE_AT_PATH_NODE) {
                if(teamAttack()) {
                    this.attackPlayerTargetEnemy();
                } else {
                    this.markCurrentNode();
                    if(this.playerIsInMovementRange()){
                        this.moveToNextPathNode();
                    } else if (this.enemyIsInAttackRange(this.targetEnemy)) {
                        this._state = STATE_AT_ENEMY;
                        this.targetEnemy.activeTarget();
                    } else if(this.enemyIsInMoveTowardsRange(this.targetEnemy)) {
                        this.walkTarget = this.targetEnemy.getAttackPos();
                        this._state = STATE_MOVE_TO_ENEMY;
                    }
                    this.dir = ZERO_POINT;
                }
            } else if (this._state == STATE_IDLE_AT_MAP_NODE) {
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
            } else if (this._state == STATE_AT_ENEMY) {
                this.attack();
                this.dir = ZERO_POINT;
            } else if (this._state == STATE_MOVE_TO_ENEMY){
                this.walk();
                this.walkTarget = this.targetEnemy.getAttackPos();
                this.disp = this.walkTarget.sub(this.footPos).normalized();
                this.dir = this.disp.mulScl(this.runSpeed);
                if (this.enemyIsInAttackRange(this.targetEnemy)) {
                    this._state = STATE_AT_ENEMY;
                    this.targetEnemy.activeTarget();
                } else if (this.targetEnemy.getAttackPos()
                    .sub(this.footPos)._length() >
                    (this.targetEnemy is BossEnemy ? this.bossSightRange : this.sightRange) && !this.teamAttack())
                {
                    this.moveToNextNode();
                }
            } else if (this._state == STATE_IN_ATTACK) {
                if (this.attackAnim.frame >= 20) {
                    this.resolveStatePostAttack();
                }
                this.dir = ZERO_POINT;
            } else if (this._state == STATE_MOVE_TO_PLAYER) {
                this.walk();
                this.disp = this.playerRef.pos.sub(this.footPos).normalized();
                this.dir = this.disp.mulScl(this.runSpeed);
                if (this.playerIsInMovementRange()) {
                    this.moveToNextNode();
                }
            }

            if(this.attackAnim.frame >= 20) {
                attackAnim.play("idle");
                attackAnim.visible = false;
                this.visible = true;
            }
        }

        public function addAttackAnim():void {
            attackAnim = new GameObject(this.pos);
            attackAnim.loadGraphic(ImgIchiAttack, true, false, 99, 175);
            attackAnim.addAnimation("attack", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20], 15, false);
            attackAnim.addAnimation("idle", [0], 15, false);
            attackAnim.zSorted = true;
            attackAnim.basePos = new DHPoint(0, 0);
            FlxG.state.add(attackAnim);
            attackAnim.visible = false;
        }

        override public function resolveStatePostAttack():void {
            super.resolveStatePostAttack();
            // TODO - which state were you in before attacking? go back to that one
            if (this.targetEnemy != null && !this.targetEnemy.dead && this.targetEnemy.visible == true)
            {
                if (this.enemyIsInAttackRange(this.targetEnemy))
                {
                    this._state = STATE_AT_ENEMY;
                    this.targetEnemy.activeTarget();
                } else {
                    this.walkTarget = this.targetEnemy.getAttackPos();
                    this._state = STATE_MOVE_TO_ENEMY;
                }
            } else {
                this.moveToNextNode();
            }
        }

        public function getClosestEnemy():Enemy {
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
            return ret;
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
            //if (dir.x == 0 && dir.y == 0) {
            //    dir.x = 10;
            //    dir.y = 10;
            //}
            //TODO if you're standing still for too long, he should walk to you
            var targetPoint:DHPoint = this.playerRef.pos.add(dir.normalized().mulScl(555));
            var warpNode:MapNode = this._mapnodes.getClosestNode(targetPoint, null, false);
            if (warpNode != null) {
                this.setPos(warpNode.pos);
            }
            this._state = STATE_MOVE_TO_PLAYER;
            this.targetEnemy.inactiveTarget();
        }

        public function shouldWarpToPlayer():Boolean {
            return this.currentTime - this.lastInViewTime >= 7*1000;
        }

        override public function attack():void {
            super.attack();
            if (this._state == STATE_IN_ATTACK) {
                play("attack");
                attackAnim.x = this.x + 20;
                attackAnim.y = this.y;
                attackAnim.visible = true;
                attackAnim.play("attack");
                this.visible = false;

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
    }
}
