package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;

    import org.flixel.*;

    public class TeamPowerBar extends Meter {
        [Embed(source="/../assets/audio/effects/sfx_energy.mp3")] private var SfxEnergy:Class;

        protected var _labelText:FlxText, _bossText:FlxText;
        protected var _outlines:Array
        private var _curMaxOutline:Number, _numOutlines:Number = 3;
        private var _lastOutlineUpdate:Number = -1;
        private var _updatingOutlines:Boolean = false,
                    _outlinesGrowing:Boolean = true;

        public function TeamPowerBar(maxPoints:Number) {
            super(new DHPoint(0, 0), maxPoints, 300, 20);

            this._labelText = new FlxText(0, 0, 200, "TEAM POWER");
            this._labelText.setFormat("NexaBold-Regular", 18, 0xff7c6e6a, "left");
            this._labelText.scrollFactor = new DHPoint(0, 0);

            this._bossText = new FlxText(0, 0, 200, "BOSS");
            this._bossText.setFormat("NexaBold-Regular", 13, 0xff7c6e6a, "left");
            this._bossText.scrollFactor = new DHPoint(0, 0);

            this._barFrame.scrollFactor = new DHPoint(0, 0);
            this._innerBar.scrollFactor = new DHPoint(0, 0);
            this._changeText.setFormat("NexaBold-Regular", 25, 0xff7c6e6a,
                                       "left");
            this._changeText.scrollFactor = new DHPoint(0, 0);

            this._curMaxOutline = this._numOutlines - 1;
            this._outlines = new Array();
            var curOutline:GameObject;
            var outlineColors:Array = [0xff968B88, 0xffBEB6B4, 0xffE5E2E1];
            for (var i:int = this._numOutlines - 1; i >= 0; i--) {
                curOutline = new GameObject(new DHPoint(0, 0));
                curOutline.makeGraphic(this._outerWidth + ((i + 1) * 8),
                                       this._outerHeight + ((i + 1) * 8),
                                       outlineColors[i]);
                curOutline.scrollFactor = new DHPoint(0, 0);
                curOutline.visible = false;
                this._outlines.push(curOutline);
            }

            this.setVisible(true);
        }

        override public function setPoints(points:Number):void {
            super.setPoints(points);
            SoundManager.getInstance().playSound(
                SfxEnergy, 1*GameSound.MSEC_PER_SEC, null, false, 1, GameSound.SFX,
                "" + Math.random()
            );
        }

        public function setHighlight(v:Boolean):void {
            if (this._updatingOutlines != v) {
                this._updatingOutlines = v;
                if (v) {
                    this._curMaxOutline = this._numOutlines - 1;
                } else {
                    for (var i:int = 0; i < this._outlines.length; i++) {
                        this._outlines[i].visible = false;
                    }
                }
            }
        }

        override public function setPos(pos:DHPoint):void {
            var basePos:DHPoint = new DHPoint(
                ScreenManager.getInstance().screenWidth - this._outerWidth / 2 - 50,
                35
            );
            super.setPos(basePos);
            var outerPos:DHPoint = basePos.sub(new DHPoint(
                this._outerWidth / 2, 0));
            this._labelText.x = outerPos.x;
            this._labelText.y = outerPos.y + this._outerHeight / 2 + 30;

            this._bossText.x = outerPos.x + this._outerWidth;
            this._bossText.y = outerPos.y;

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
            FlxG.state.add(this._bossText);
        }

        override public function setVisible(v:Boolean):void {
            super.setVisible(v);
            this._labelText.visible = true;
            this._bossText.visible = true;
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
