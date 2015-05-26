package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class HealthBar extends GameObject {
        private var _innerBar:GameObject, _barFrame:GameObject;
        private var _changeText:FlxText;
        private var _maxPoints:Number, _outerWidth:Number = 100,
                    _outerHeight:Number, _curPoints:Number;

        public function HealthBar(pos:DHPoint, maxPoints:Number) {
            super(pos);

            this.slug = "healthBar" + (Math.random() * 1000000);

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

            this._changeText = new FlxText(pos.x, pos.y, 200, "");
            this._changeText.setFormat("NexaBold-Regular", 18, 0xff7c6e6a, "center");
        }

        public function setPoints(points:Number):void {
            if (this._curPoints == points) {
                return;
            }
            var diff:Number = this._curPoints - points;
            this._curPoints = points;
            this._innerBar.scale.x = points;
            this._innerBar.offset.x = -1 * (this._maxPoints / 2 - (this._maxPoints - this._curPoints));

            if (this.isVisible()){
                this._changeText.text = (diff < 0 ? "" : "-") + diff;
                GlobalTimer.getInstance().setMark(this.slug + "showChange",
                                                1 * GameSound.MSEC_PER_SEC,
                                                function():void {
                                                    _changeText.text = "";
                                                },
                                                true);
            }
        }

        override public function setPos(pos:DHPoint):void {
            var innerPos:DHPoint = pos.sub(new DHPoint(this._curPoints / 2, 0));
            this._innerBar.setPos(innerPos);
            var outerPos:DHPoint = pos.sub(new DHPoint(this._maxPoints / 2, 0));
            this._barFrame.setPos(outerPos);

            this._changeText.x = outerPos.x - this._barFrame.width;
            this._changeText.y = outerPos.y - 20;
        }

        public function setVisible(v:Boolean):void {
            this._barFrame.visible = v;
            this._innerBar.visible = v;
            this._changeText.text = "";
        }

        public function isVisible():Boolean {
            return this._barFrame.visible;
        }

        public function addVisibleObjects():void {
            FlxG.state.add(this._barFrame);
            FlxG.state.add(this._innerBar);
            FlxG.state.add(this._changeText);
        }
    }
}
