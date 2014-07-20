package
{
    import org.flixel.*;

    public class GameObject extends FlxSprite {
        public var pos:DHPoint;
        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;

        public static const MSEC_PER_SEC:Number = 1000;

        public function GameObject(pos:DHPoint) {
            super(pos.x, pos.y);
            this.pos = pos;
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;
        }

        override public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            this.pos.x = this.x;
            this.pos.y = this.y;
        }

        public function setPos(pos:DHPoint):void {
            this.pos = pos;
            this.x = pos.x;
            this.y = pos.y;
        }
    }
}
