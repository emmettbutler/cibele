package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class HealthBar extends GameObject {
        private var _innerBar:GameObject;
        private var _maxPoints:Number;

        public function HealthBar(pos:DHPoint, maxPoints:Number) {
            super(pos);

            this._maxPoints = maxPoints;
            this._innerBar = new GameObject(pos);
            this._innerBar.makeGraphic(1, 8, 0xffe2678e);
            this._innerBar.scale.x = maxPoints;
        }

        public function setPoints(points:Number):void {
            this._innerBar.scale.x = points;
        }

        override public function setPos(pos:DHPoint):void {
            this._innerBar.setPos(pos);
        }

        public function setVisible(v:Boolean):void {
            this._innerBar.visible = v;
        }

        public function addVisibleObjects():void {
            FlxG.state.add(this._innerBar);
        }
    }
}
