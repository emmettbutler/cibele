package
{
    import org.flixel.*;

    public class PathFollower extends GameObject
    {
        public var _path:Path;
        public var _enemies:EnemyGroup;
        public var targetNode:PathNode;

        public var _state:Number;
        public static const STATE_NULL:Number = 0;
        public static const STATE_MOVE_TO_NODE:Number = 1;
        public static const STATE_IDLE_AT_NODE:Number = 2;
        public static const STATE_AT_ENEMY:Number = 3;

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
            if (this._state == STATE_MOVE_TO_NODE) {
                var disp:DHPoint = this.targetNode.pos.sub(this.pos);
                if (disp._length() < 10) {
                    this._state = STATE_IDLE_AT_NODE;
                } else {
                    this.setPos(disp.normalized().add(this.pos));
                }
            }
            if (this._state == STATE_IDLE_AT_NODE) {
                this.moveToNextNode();
            }
            if (this._state == STATE_AT_ENEMY) {

            }



            if (this._state == STATE_IDLE_AT_NODE ||
                this._state == STATE_MOVE_TO_NODE)
            {
                if (this.dispToClosestEnemy() < 10) {
                    this._state = STATE_AT_ENEMY;
                }
            }
        }

        public function dispToClosestEnemy():Number {
            var ret:Number = 99999999;
            var disp:Number;
            var cur:Enemy;
            for (var i:int = 0; i < this._enemies.length(); i++) {
                cur = this._enemies.get_(i);
                disp = cur.pos.sub(this.pos)._length();
                if (disp < ret) {
                    ret = disp;
                }
            }
            return ret;
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
