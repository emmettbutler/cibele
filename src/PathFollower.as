package
{
    import org.flixel.*;

    public class PathFollower extends FlxSprite
    {
        public var _path:Path;
        public var targetNode:PathNode;
        public var pos:DHPoint;

        public var _state:Number;
        public static const STATE_NULL:Number = 0;
        public static const STATE_MOVE_TO_NODE:Number = 1;
        public static const STATE_IDLE:Number = 2;

        public var dbgText:FlxText;

        public function PathFollower(pos:DHPoint) {
            super(pos.x, pos.y);
            makeGraphic(10, 10, 0xffff0000);
            this.pos = pos;
            this.targetNode = null;
            this._state = STATE_NULL;

            this.dbgText = new FlxText(100, 100, 100, "");
            FlxG.state.add(this.dbgText);
        }

        override public function update():void {
            if (this._state == STATE_MOVE_TO_NODE) {
                var disp:DHPoint = this.targetNode.pos.sub(this.pos);
                if (disp._length() < 10) {
                    this._state = STATE_IDLE;
                } else {
                    this.setPos(disp.normalized().add(this.pos));
                }
            } else if (this._state == STATE_IDLE) {
                this.moveToNextNode();
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

        public function moveToNextNode():void {
            if (this._state == STATE_NULL || this._state == STATE_IDLE) {
                this._path.advance();
                this.targetNode = this._path.currentNode;
                this._state = STATE_MOVE_TO_NODE;
            }
        }
    }
}
