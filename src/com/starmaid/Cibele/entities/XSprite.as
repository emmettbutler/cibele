package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.UIElement;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class XSprite extends UIElement {
        public function XSprite(x:Number, y:Number) {
            super(x, y);
        }

        public static function fromPoint(pos:DHPoint):UIElement {
            return new XSprite(pos.x, pos.y);
        }

        override public function _getRect():FlxRect {
            return new FlxRect(this.x - 10, this.y - 10, this.width + 20,
                               this.height + 20);
        }

        override public function _getScreenRect():FlxRect {
            var curScreenPos:DHPoint = new DHPoint(0, 0);
            this.getScreenXY(curScreenPos);
            return new FlxRect(curScreenPos.x - 10,
                               curScreenPos.y - 10,
                               this.width + 20,
                               this.height + 20);
        }
    }
}
