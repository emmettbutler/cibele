package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.Player;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class GameObject extends FlxExtSprite {
        public var pos:DHPoint;
        public var dir:DHPoint;
        protected var bornTime:Number = -1;
        // should only be used for periodic actions that don't need to be pausable
        // for most time-based actions (those for which timing is noticed by
        // the player), GlobalTimer.setMark should be used
        protected var timeAlive:Number = -1;
        protected var currentTime:Number = -1;
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
            this.solid = false;
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;
            this.dir = new DHPoint(0, 0);
            if (ScreenManager.getInstance().DEBUG) {
                this.debugText = new FlxText(0, 0, 400, "");
                this.debugText.color = 0xff444444;
            }
        }

        public function buildDefaultSprite(dim:DHPoint, col:uint=0xffff0000):void {
            this.makeGraphic(dim.x, dim.y, col);
        }

        override public function update():void {
            super.update();
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;
            this.pos.x = this.x;
            this.pos.y = this.y;
            this.setPos(this.pos.add(this.dir));

            if (ScreenManager.getInstance().DEBUG) {
                this.debugText.x = this.pos.x;
                this.debugText.y = this.pos.y;
            }
        }

        public function toggleActive():void {
            this.active = this.isOnscreen();
        }

        public function setPos(pos:DHPoint):void {
            this.pos = pos;
            this.x = pos.x;
            this.y = pos.y;
        }

        public function _getRect():FlxRect {
            return new FlxRect(this.x, this.y, this.width, this.height);
        }

        public function _getScreenRect():FlxRect {
            var curScreenPos:DHPoint = new DHPoint(0, 0);
            this.getScreenXY(curScreenPos);
            return new FlxRect(curScreenPos.x, curScreenPos.y,
                               this.width, this.height);
        }

        public function occludedBy(obj:GameObject):Boolean {
            return obj._getScreenRect().overlaps(this._getScreenRect());
        }

        public function getMiddlePos():DHPoint {
            return new DHPoint(
                this.pos.x + this.width / 2,
                this.pos.y + this.height / 2
            );
        }

        public function getScreenPos():DHPoint {
            var pos:DHPoint = new DHPoint(0, 0);
            this.getScreenXY(pos);
            return pos;
        }

        public function isOnscreen():Boolean {
            var screenPos:DHPoint = new DHPoint(0, 0);
            var _screen:ScreenManager = ScreenManager.getInstance();
            this.getScreenXY(screenPos);
            return (
                screenPos.x < _screen.screenWidth + this.width &&
                screenPos.x > 0 - this.width && screenPos.y > 0 - this.height &&
                screenPos.y < _screen.screenHeight + this.height
            );
        }
    }
}
