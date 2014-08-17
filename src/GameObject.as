package
{
    import org.flixel.*;

    public class GameObject extends FlxSprite {
        public var pos:DHPoint;
        public var dir:DHPoint;
        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;
        public var debugText:FlxText;
        {
            public static var ZERO_POINT:DHPoint = new DHPoint(0, 0);
        }

        public static const STATE_NULL:Number = -1;
        public static const STATE_IDLE:Number = 0;
        public var _state:Number;

        public static const MSEC_PER_SEC:Number = 1000;

        public function GameObject(pos:DHPoint) {
            super(pos.x, pos.y);
            this.pos = pos;
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;
            this.dir = new DHPoint(0, 0);
            this.debugText = new FlxText(0, 0, 400, "");
        }

        override public function update():void {
            super.update();
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            this.pos.x = this.x;
            this.pos.y = this.y;
            this.setPos(this.pos.add(this.dir));

            this.debugText.x = this.pos.x;
            this.debugText.y = this.pos.y;
        }

        public function setPos(pos:DHPoint):void {
            this.pos = pos;
            this.x = pos.x;
            this.y = pos.y;
        }
    }
}
