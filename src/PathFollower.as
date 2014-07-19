package
{
    import org.flixel.*;

    import flash.utils.setTimeout;
    import flash.utils.Dictionary;

    public class PathFollower extends GameObject
    {
        public var _path:Path;
        public var _enemies:EnemyGroup;
        public var targetNode:PathNode;

        public var closestEnemy:Enemy;
        public var lastAttackTime:Number = -1;

        public var _state:Number;
        public static const STATE_NULL:Number = 0;
        public static const STATE_MOVE_TO_NODE:Number = 1;
        public static const STATE_IDLE_AT_NODE:Number = 2;
        public static const STATE_AT_ENEMY:Number = 3;
        public static const STATE_IN_ATTACK:Number = 4;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_NULL] = "STATE_NULL";
            stateMap[STATE_MOVE_TO_NODE] = "STATE_MOVE_TO_NODE";
            stateMap[STATE_IDLE_AT_NODE] = "STATE_IDLE_AT_NODE";
            stateMap[STATE_AT_ENEMY] = "STATE_AT_ENEMY";
            stateMap[STATE_IN_ATTACK] = "STATE_IN_ATTACK";
        }

        public var dbgText:FlxText;

        public function PathFollower(pos:DHPoint) {
            super(pos);
            makeGraphic(10, 10, 0xffff0000);
            this.targetNode = null;
            this._state = STATE_NULL;

            this.dbgText = new FlxText(100, 100, 100, "");
            FlxG.state.add(this.dbgText);
        }

        override public function update():void {
            super.update();
            this.closestEnemy = this.getClosestEnemy();

            this.dbgText.text = stateMap[this._state] + "\n" + this.timeAlive;

            if (this._state == STATE_MOVE_TO_NODE) {
                var disp:DHPoint = this.targetNode.pos.sub(this.pos);
                if (disp._length() < 10) {
                    this._state = STATE_IDLE_AT_NODE;
                } else {
                    this.setPos(disp.normalized().add(this.pos));
                }
            } else if (this._state == STATE_IDLE_AT_NODE) {
                this.moveToNextNode();
            } else if (this._state == STATE_AT_ENEMY) {
                this.attack(this.closestEnemy);
            } else if (this._state == STATE_IN_ATTACK) {
                if (this.timeSinceLastAttack() > 500) {
                    this.makeGraphic(10, 10, 0xffff0000);
                    this.resolveStatePostAttack();
                }
            }



            if (this._state == STATE_IDLE_AT_NODE ||
                this._state == STATE_MOVE_TO_NODE)
            {
                if (this.closestEnemy != null && this.enemyIsInAttackRange(this.closestEnemy)) {
                    this._state = STATE_AT_ENEMY;
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
            return en.pos.sub(this.pos)._length() < 10;
        }

        public function getClosestEnemy():Enemy {
            var shortest:Number = 99999999;
            var ret:Enemy = null;
            var disp:Number;
            var cur:Enemy;
            for (var i:int = 0; i < this._enemies.length(); i++) {
                cur = this._enemies.get_(i);
                disp = cur.pos.sub(this.pos)._length();
                if (disp < shortest) {
                    shortest = disp;
                    ret = cur;
                }
            }
            return ret;
        }

        public function timeSinceLastAttack():Number {
            return this.currentTime - this.lastAttackTime;
        }

        public function canAttack():Boolean {
            return this.timeSinceLastAttack() > 2*MSEC_PER_SEC;
        }

        public function attack(en:Enemy):void {
            if (this.canAttack()) {
                this._state = STATE_IN_ATTACK;
                this.lastAttackTime = this.currentTime;
                this.makeGraphic(10, 10, 0xffffff00);
            }
        }

        public function setPos(pos:DHPoint):void {
            this.pos = pos;
            this.x = pos.x;
            this.y = pos.y;
        }

        public function setPath(path:Path):void {
            this._path = path;
        }

        public function setEnemyGroupReference(_group:EnemyGroup):void {
            this._enemies = _group;
        }

        public function moveToNextNode():void {
            if (this._state == STATE_NULL || this._state == STATE_IDLE_AT_NODE) {
                this._path.advance();
                this.targetNode = this._path.currentNode;
                this._state = STATE_MOVE_TO_NODE;
            }
        }
    }
}
