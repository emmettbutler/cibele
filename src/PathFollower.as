package
{
    import org.flixel.*;

    import flash.utils.setTimeout;
    import flash.utils.Dictionary;

    public class PathFollower extends PartyMember
    {
        public var _path:Path;
        public var _enemies:EnemyGroup;
        public var targetNode:PathNode;
        public var pathComplete:Boolean = false;

        public var runSpeed:Number = 6;

        public var closestEnemy:Enemy;

        public static const STATE_MOVE_TO_NODE:Number = 2;
        public static const STATE_IDLE_AT_NODE:Number = 3;
        public static const STATE_AT_ENEMY:Number = 4;
        public static const STATE_MOVE_TO_ENEMY:Number = 5;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_NULL] = "STATE_NULL";
            stateMap[STATE_MOVE_TO_NODE] = "STATE_MOVE_TO_NODE";
            stateMap[STATE_IDLE_AT_NODE] = "STATE_IDLE_AT_NODE";
            stateMap[STATE_AT_ENEMY] = "STATE_AT_ENEMY";
            stateMap[STATE_IN_ATTACK] = "STATE_IN_ATTACK";
            stateMap[STATE_MOVE_TO_ENEMY] = "STATE_MOVE_TO_ENEMY";
        }

        public var dbgText:FlxText;

        public function PathFollower(pos:DHPoint) {
            super(pos);
            makeGraphic(50, 50, 0xffff0000);
            this.targetNode = null;
            this._state = STATE_NULL;

            this.dbgText = new FlxText(100, 100, 100, "");
            this.dbgText.color = 0xff000000;
            FlxG.state.add(this.dbgText);
        }

        override public function update():void {
            super.update();
            this.closestEnemy = this.getClosestEnemy();
            dbgText.x = this.x;
            dbgText.y = this.y-20;

            this.dbgText.text = stateMap[this._state] + "\n"
                                + this.canAttack();

            var disp:DHPoint;
            if (this._state == STATE_MOVE_TO_NODE) {
                if (!this._path.hasNodes()) {
                    this._state = STATE_NULL;
                } else {
                    disp = this.targetNode.pos.sub(this.pos);
                    if (disp._length() < 10) {
                        this._state = STATE_IDLE_AT_NODE;
                    } else {
                        this.setPos(disp.normalized().mulScl(this.runSpeed).add(this.pos));
                    }
                }
                if (this.enemyIsInAttackRange(this.closestEnemy)) {
                    this._state = STATE_AT_ENEMY;
                } else if(this.enemyIsInMoveTowardsRange(this.closestEnemy)) {
                    this._state = STATE_MOVE_TO_ENEMY;
                }
            } else if (this._state == STATE_IDLE_AT_NODE) {
                this.markCurrentNode();
                this.moveToNextNode();
                if (this.enemyIsInAttackRange(this.closestEnemy)) {
                    this._state = STATE_AT_ENEMY;
                } else if(this.enemyIsInMoveTowardsRange(this.closestEnemy)) {
                    this._state = STATE_MOVE_TO_ENEMY;
                }
            } else if (this._state == STATE_AT_ENEMY) {
                this.attack();
            } else if (this._state == STATE_MOVE_TO_ENEMY){
                disp = this.closestEnemy.pos.sub(this.pos);
                this.setPos(disp.normalized().mulScl(this.runSpeed).add(this.pos));
                if (this.enemyIsInAttackRange(this.closestEnemy)) {
                    this._state = STATE_AT_ENEMY;
                }
            } else if (this._state == STATE_IN_ATTACK) {
                if (this.timeSinceLastAttack() > 500) {
                    this.resolveStatePostAttack();
                    this.makeGraphic(10, 10, 0xffff0000);
                }
            }
        }

        public function resolveStatePostAttack():void {
            if (this.closestEnemy != null && this.enemyIsInAttackRange(this.closestEnemy))
            {
                this._state = STATE_AT_ENEMY;
            } else {
                this._state = STATE_MOVE_TO_NODE;
            }
        }

        public function enemyIsInAttackRange(en:Enemy):Boolean {
            if (en == null) { return false; }
            return en.pos.sub(this.pos)._length() < 150;
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

        override public function attack():void {
            super.attack();
            if (this._state == STATE_IN_ATTACK) {
                this.makeGraphic(10, 10, 0xffffff00);
            }
        }

        public function setPath(path:Path):void {
            this._path = path;
        }

        public function setEnemyGroupReference(_group:EnemyGroup):void {
            this._enemies = _group;
        }

        public function moveToNextNode():void {
            this._path.advance();
            this.targetNode = this._path.currentNode;
            this._state = STATE_MOVE_TO_NODE;
        }

        public function markCurrentNode():void{
            this.targetNode.mark();
            pathComplete = _path.isPathComplete();
        }
    }
}
