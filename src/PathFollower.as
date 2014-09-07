package
{
    import org.flixel.*;

    import flash.utils.setTimeout;
    import flash.utils.Dictionary;

    public class PathFollower extends PartyMember
    {
        [Embed(source="../assets/ichi.png")] private var ImgIchi:Class;
        [Embed(source="../assets/fire_explosion.png")] private var ImgAttack:Class;
        public var _path:Path;
        public var _mapnodes:MapNodeContainer;
        public var _enemies:EnemyGroup;
        public var targetPathNode:PathNode, targetMapNode:MapNode;
        public var lastInViewTime:Number = 0;

        public var runSpeed:Number = 8;

        public var closestEnemy:Enemy;
        public var playerRef:Player;

        public var attackAnim:FlxSprite;

        public static const STATE_MOVE_TO_PATH_NODE:Number = 2;
        public static const STATE_IDLE_AT_PATH_NODE:Number = 3;
        public static const STATE_AT_ENEMY:Number = 4;
        public static const STATE_MOVE_TO_ENEMY:Number = 5;
        public static const STATE_MOVE_TO_MAP_NODE:Number = 6;
        public static const STATE_IDLE_AT_MAP_NODE:Number = 7;

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
        }

        public function PathFollower(pos:DHPoint) {
            super(pos);
            loadGraphic(ImgIchi, true, false, 72, 126);
            addAnimation("idle",[0],7,false);
            addAnimation("walk",[0],7,false);
            addAnimation("attack",[0,1],7,true);
            play("walk");
            this.targetPathNode = null;
            this._state = STATE_NULL;

            this.footstepOffset = new DHPoint(0, 0);
            this.attackRange = 90;
        }

        override public function update():void {
            super.update();

            //this.debugText.text = stateMap[this._state];

            this.closestEnemy = this.getClosestEnemy();
            if (this.inViewOfPlayer()) {
                lastInViewTime = this.currentTime;
            }
            if (this.shouldWarpToPlayer()) {
                this.warpToPlayer();
            }

            var disp:DHPoint;
            if (this._state == STATE_MOVE_TO_PATH_NODE) {
                play("walk");
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
                if (this.enemyIsInAttackRange(this.closestEnemy)) {
                    this._state = STATE_AT_ENEMY;
                } else if(this.enemyIsInMoveTowardsRange(this.closestEnemy)) {
                    this._state = STATE_MOVE_TO_ENEMY;
                }
            } else if (this._state == STATE_MOVE_TO_MAP_NODE) {
                play("walk");
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
                    } else {
                        this.dir = disp.normalized().mulScl(this.runSpeed);
                    }
                }
                if (this.enemyIsInAttackRange(this.closestEnemy)) {
                    this._state = STATE_AT_ENEMY;
                } else if(this.enemyIsInMoveTowardsRange(this.closestEnemy)) {
                    this._state = STATE_MOVE_TO_ENEMY;
                }
            } else if (this._state == STATE_IDLE_AT_PATH_NODE) {
                play("idle");
                this.markCurrentNode();
                if(this.playerIsInMovementRange()){
                    this.moveToNextPathNode();
                }
                if (this.enemyIsInAttackRange(this.closestEnemy)) {
                    this._state = STATE_AT_ENEMY;
                } else if(this.enemyIsInMoveTowardsRange(this.closestEnemy)) {
                    this._state = STATE_MOVE_TO_ENEMY;
                }
                this.dir = ZERO_POINT;
            } else if (this._state == STATE_IDLE_AT_MAP_NODE) {
                play("idle");
                if(this.playerIsInMovementRange()){
                    this.moveToNextNode();
                }
                //if (this.enemyIsInAttackRange(this.closestEnemy)) {
                //    this._state = STATE_AT_ENEMY;
                //} else if(this.enemyIsInMoveTowardsRange(this.closestEnemy)) {
                //    this._state = STATE_MOVE_TO_ENEMY;
                //}
                this.dir = ZERO_POINT;
            } else if (this._state == STATE_AT_ENEMY) {
                this.attack();
                this.dir = ZERO_POINT;
            } else if (this._state == STATE_MOVE_TO_ENEMY){
                play("walk");
                disp = this.closestEnemy.pos.sub(this.pos);
                this.dir = disp.normalized().mulScl(this.runSpeed);
                if (this.enemyIsInAttackRange(this.closestEnemy)) {
                    this._state = STATE_AT_ENEMY;
                }
            } else if (this._state == STATE_IN_ATTACK) {
                if (this.timeSinceLastAttack() > 500) {
                    this.resolveStatePostAttack();
                }
                this.dir = ZERO_POINT;
            }

            if(this.attackAnim.frame == 8) {
                attackAnim.play("idle");
                attackAnim.alpha = 0;
            }
        }

        public function tempAttackAnim():void {
            attackAnim = new FlxSprite(this.x, this.y);
            attackAnim.loadGraphic(ImgAttack, true, false, 1152/9, 128);
            attackAnim.addAnimation("attack", [0, 1, 2, 3, 4, 5, 6, 7, 8], 15, false);
            attackAnim.addAnimation("idle", [0], 15, false);
            FlxG.state.add(attackAnim);
            attackAnim.alpha = 0;
            attackAnim.play("idle");
        }

        public function resolveStatePostAttack():void {
            // TODO - which state were you in before attacking? go back to that one
            if (this.closestEnemy != null &&
                this.enemyIsInAttackRange(this.closestEnemy))
            {
                this._state = STATE_AT_ENEMY;
            } else {
                this._state = STATE_MOVE_TO_PATH_NODE;
            }
        }

        public function enemyIsInAttackRange(en:Enemy):Boolean {
            if (en == null) { return false; }
            return en.pos.sub(this.pos)._length() < this.attackRange;
        }

        public function enemyIsInMoveTowardsRange(en:Enemy):Boolean{
            if (en == null) { return false; }
            return en.pos.sub(this.pos)._length() < 280;
        }

        public function getClosestEnemy():Enemy {
            var shortest:Number = 99999999;
            var ret:Enemy = null;
            var disp:Number;
            var cur:Enemy;
            for (var i:int = 0; i < this._enemies.length(); i++) {
                cur = this._enemies.get_(i);
                disp = cur.pos.sub(this.pos)._length();
                if (disp < shortest && !cur.dead) {
                    shortest = disp;
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
            if(this.targetMapNode._type == MapNode.TYPE_PATH) {
                this._state = STATE_MOVE_TO_PATH_NODE;
                this.targetPathNode = this.targetMapNode as PathNode;
                this._path.setCurrentNode(this.targetPathNode);
            } else if(this.targetMapNode._type == MapNode.TYPE_MAP) {
                this._state = STATE_MOVE_TO_MAP_NODE;
                this.targetMapNode = this.targetMapNode;
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
                    ScreenManager.getInstance().screenWidth / 2 + 100);
        }

        public function warpToPlayer():void {
            var targetPoint:DHPoint = this.playerRef.pos.add(this.playerRef.dir.normalized().mulScl(555));
            var warpNode:MapNode = this._mapnodes.getClosestNode(targetPoint);
            this.setPos(warpNode.pos);
            this._state = STATE_IDLE_AT_MAP_NODE;
        }

        public function shouldWarpToPlayer():Boolean {
            return this.currentTime - this.lastInViewTime >= 7*1000;
        }

        override public function attack():void {
            super.attack();
            if (this._state == STATE_IN_ATTACK) {
                play("attack");
                attackAnim.x = this.x;
                attackAnim.y = this.y;
                attackAnim.alpha = 1;
                attackAnim.play("attack");
            }
        }
    }
}
