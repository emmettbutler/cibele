package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class HealthBar extends GameObject {
        private var _innerBar:GameObject, _barFrame:GameObject;
        private var _maxPoints:Number, _outerWidth:Number = 100,
                    _outerHeight:Number, _curPoints:Number;

        public function HealthBar(pos:DHPoint, maxPoints:Number) {
            super(pos);

            this._maxPoints = maxPoints;
            this._curPoints = maxPoints;
            this._outerWidth = 100;
            this._outerHeight = 6;

            this._barFrame = new GameObject(pos);
            this._barFrame.makeGraphic(this._outerWidth, this._outerHeight, 0xff7c6e6a);

            this._innerBar = new GameObject(pos);
            this._innerBar.makeGraphic(1, this._outerHeight - 1, 0xffe2678e);
            this._innerBar.scale.x = maxPoints;
            this._innerBar.offset.x = -1 * (maxPoints / 2);
        }

        public function setPoints(points:Number):void {
            this._curPoints = points;
            this._innerBar.scale.x = points;
            this._innerBar.offset.x = -1 * (this._maxPoints / 2 - (this._maxPoints - this._curPoints));
        }

        override public function setPos(pos:DHPoint):void {
            if (!this.isVisible()) {
                return;
            }
            var innerPos:DHPoint = pos.sub(new DHPoint(this._curPoints / 2, 0));
            this._innerBar.setPos(innerPos);
            var outerPos:DHPoint = pos.sub(new DHPoint(this._maxPoints / 2, 0));
            this._barFrame.setPos(outerPos);
        }

        public function setVisible(v:Boolean):void {
            this._barFrame.visible = v;
            this._innerBar.visible = v;
        }

        public function isVisible():Boolean {
            return this._barFrame.visible;
        }

        public function addVisibleObjects():void {
            FlxG.state.add(this._barFrame);
            FlxG.state.add(this._innerBar);
        }
    }
}
