package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class TeamPowerBar extends Meter {
        protected var _labelText:FlxText;
        protected var _outlines:Array
        private var _curMaxOutline:Number = 2;
        private var _lastOutlineUpdate:Number = -1;
        private var _updatingOutlines:Boolean = true,
                    _outlinesGrowing:Boolean = true;

        public function TeamPowerBar(maxPoints:Number) {
            super(new DHPoint(0, 0), maxPoints, 250, 30);

            this._labelText = new FlxText(0, 0, 200, "TEAM POWER");
            this._labelText.setFormat("NexaBold-Regular", 18, 0xff7c6e6a, "left");
            this._labelText.scrollFactor = new DHPoint(0, 0);

            this._barFrame.scrollFactor = new DHPoint(0, 0);
            this._innerBar.scrollFactor = new DHPoint(0, 0);
            this._changeText.setFormat("NexaBold-Regular", 25, 0xff7c6e6a,
                                       "left");
            this._changeText.scrollFactor = new DHPoint(0, 0);

            this._outlines = new Array();
            var curOutline:GameObject;
            var outlineColors:Array = [0xff968B88, 0xffBEB6B4, 0xffE5E2E1];
            for (var i:int = 2; i >= 0; i--) {
                curOutline = new GameObject(new DHPoint(0, 0));
                curOutline.makeGraphic(this._outerWidth + ((i + 1) * 8),
                                       this._outerHeight + ((i + 1) * 8),
                                       outlineColors[i]);
                curOutline.scrollFactor = new DHPoint(0, 0);
                curOutline.visible = true;
                this._outlines.push(curOutline);
            }

            this.setVisible(true);
        }

        override public function setPos(pos:DHPoint):void {
            var basePos:DHPoint = new DHPoint(50 + (this._outerWidth / 2), 400);
            super.setPos(basePos);
            var outerPos:DHPoint = basePos.sub(new DHPoint(
                this._outerWidth / 2, 0));
            this._labelText.x = outerPos.x;
            this._labelText.y = outerPos.y + this._outerHeight / 2 + 30;

            for (var i:int = 0; i < this._outlines.length; i++) {
                this._outlines[i].setPos(outerPos.add(new DHPoint(
                    (this._outlines[i].width - this._outerWidth) / -2,
                    (this._outlines[i].height - this._outerHeight) / -2
                )));
            }
        }

        override public function addVisibleObjects():void {
            for (var i:int = 0; i < this._outlines.length; i++) {
                FlxG.state.add(this._outlines[i]);
            }
            super.addVisibleObjects();
            FlxG.state.add(this._labelText);
        }

        override public function setVisible(v:Boolean):void {
            super.setVisible(v);
            this._labelText.visible = true;
        }

        override public function update():void {
            super.update();

            if (this._updatingOutlines) {
                if (this.timeAlive - this._lastOutlineUpdate >=
                    .2 * GameSound.MSEC_PER_SEC)
                {
                    this._lastOutlineUpdate = this.timeAlive;
                    this._outlines[this._curMaxOutline].visible = this._outlinesGrowing;
                    if (this._outlinesGrowing) {
                        if (this._curMaxOutline > 0) {
                            this._curMaxOutline -= 1;
                        } else {
                            this._outlinesGrowing = false;
                        }
                    } else {
                        if (this._curMaxOutline < this._outlines.length - 1) {
                            this._curMaxOutline += 1;
                        } else {
                            this._outlinesGrowing = true;
                        }
                    }
                }
            }
        }
    }
}
