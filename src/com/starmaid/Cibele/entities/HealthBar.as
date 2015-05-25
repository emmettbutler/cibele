package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class HealthBar extends GameObject {
        private var _innerBar:GameObject, _barFrame:GameObject;
        private var _maxPoints:Number;

        public function HealthBar(pos:DHPoint, maxPoints:Number) {
            super(pos);

            this._maxPoints = maxPoints;

            this._barFrame = new GameObject(pos);
            this._barFrame.makeGraphic(1, 8, 0xffe2678e);
            this._barFrame.scale.x = maxPoints;

            this._innerBar = new GameObject(pos);
            this._innerBar.makeGraphic(1, 8, 0xffff0000);
            this._innerBar.scale.x = maxPoints;
        }

        public function setPoints(points:Number):void {
            this._innerBar.scale.x = points;
        }

        override public function setPos(pos:DHPoint):void {
            this._innerBar.setPos(pos);
            this._barFrame.setPos(pos);
        }

        public function setVisible(v:Boolean):void {
            this._barFrame.visible = v;
            this._innerBar.visible = v;
        }

        public function addVisibleObjects():void {
            FlxG.state.add(this._barFrame);
            FlxG.state.add(this._innerBar);
        }
    }
}
