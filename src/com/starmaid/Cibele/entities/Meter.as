package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.states.LevelMapState;

    import org.flixel.*;

    public class Meter extends GameObject {
        protected var _innerBar:GameObject, _barFrame:GameObject;
        protected var _changeText:FlxText;
        protected var _maxPoints:Number, _outerWidth:Number = 100,
                      _outerHeight:Number, _curPoints:Number,
                      _curDiff:Number = 0;

        public function Meter(pos:DHPoint,
                              maxPoints:Number,
                              outerWidth:Number=100,
                              outerHeight:Number=6)
        {
            super(pos);

            this._maxPoints = maxPoints;
            this._curPoints = maxPoints;
            this._curDiff = 0;
            this._outerWidth = outerWidth;
            this._outerHeight = outerHeight;

            this._barFrame = new GameObject(pos);
            this._barFrame.makeGraphic(this._outerWidth, this._outerHeight, 0xff7c6e6a);

            this._innerBar = new GameObject(pos);
            this._innerBar.makeGraphic(1, this._outerHeight - 1, 0xffe2678e);
            this._innerBar.scale.x = this._outerWidth * (maxPoints / this._maxPoints);
            this._innerBar.offset.x = -1 * (this._innerBar.scale.x / 2);

            this._changeText = new FlxText(pos.x, pos.y, 200, "");
            this._changeText.setFormat("NexaBold-Regular", 18, 0xff7c6e6a, "left");

            if(ScreenManager.getInstance().levelTracker.level == LevelTracker.LVL_HI) {
                this._changeText.color = 0xffffffff;
            }
        }

        public function setPoints(points:Number):void {
            if (this._curPoints == points) {
                return;
            }
            this._curDiff = (this._curPoints - points) + this._curDiff;
            this._curPoints = points;
            this._innerBar.scale.x = Math.min(this._outerWidth * (points / this._maxPoints), this._outerWidth);
            this._innerBar.offset.x = -1 * (this._innerBar.scale.x / 2);

            if (this.isVisible()){
                this._changeText.text = (this._curDiff <= 0 ? "+" : "") +
                    this._curDiff * -1;
                GlobalTimer.getInstance().setMark(this.slug + "showChange",
                                                .7 * GameSound.MSEC_PER_SEC,
                                                function():void {
                                                    if(!(FlxG.state is LevelMapState)) {
                                                        return;
                                                    }
                                                    _changeText.text = "";
                                                    _curDiff = 0;
                                                },
                                                true);
            } else {
                this._curDiff = 0;
            }
        }

        override public function setPos(pos:DHPoint):void {
            var outerPos:DHPoint = pos.sub(new DHPoint(this._outerWidth / 2, 0));
            this._innerBar.setPos(outerPos);
            this._barFrame.setPos(outerPos);

            this._changeText.x = outerPos.x;
            this._changeText.y = outerPos.y - this._outerHeight / 2 - 20;
        }

        public function getPos():DHPoint {
            return this._barFrame.pos;
        }

        public function setVisible(v:Boolean):void {
            if(this._barFrame != null && this._innerBar != null && this._changeText != null) {
                this._barFrame.visible = v;
                this._innerBar.visible = v;
                this._changeText.text = "";
            }
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
