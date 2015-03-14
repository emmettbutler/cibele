package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.Player;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class GameObject extends FlxExtSprite {
        public var pos:DHPoint;
        public var dir:DHPoint;
        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;
        public var debugText:FlxText;
        // if true, this object will be z-indexed according to y position
        public var zSorted:Boolean = false;
        // the "foot position" of this object. used for z-index sorting
        public var basePos:DHPoint = null;
        public var slug:String;
        public var observeGlobalPause:Boolean = true;
        {
            public static var ZERO_POINT:DHPoint = new DHPoint(0, 0);
        }

        public static const STATE_NULL:Number = -1;
        public static const STATE_IDLE:Number = 0;
        public var _state:Number = STATE_NULL;

        public static const MSEC_PER_SEC:Number = 1000;

        public function GameObject(pos:DHPoint) {
            super(pos.x, pos.y);
            this.pos = pos;
            this.slug = "";
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;
            this.dir = new DHPoint(0, 0);
            this.debugText = new FlxText(0, 0, 400, "");
            this.debugText.color = 0xff444444;
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

        public function toggleActive(player:Player):void {
            var disp:DHPoint = this.pos.sub(player.pos);
            this.active = disp._length() < ScreenManager.getInstance().screenWidth/2;
        }

        public function setPos(pos:DHPoint):void {
            this.pos = pos;
            this.x = pos.x;
            this.y = pos.y;
        }

        public function _getRect():FlxRect {
            return new FlxRect(this.x, this.y, this.width, this.height);
        }
    }
}
