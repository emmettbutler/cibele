package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.UIElement;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;

    import org.flixel.*;

    public class TeamPowerBar extends Meter {
        [Embed(source="/../assets/audio/effects/sfx_energy.mp3")] private var SfxEnergy:Class;
        [Embed(source="/../assets/images/ui/pactbar.png")] private var UIBar:Class;

        private var _animatingBar:Boolean = false;
        private var _topFrame:UIElement;
        private var _helpText:FlxText;
        public var elements:Array;

        public function TeamPowerBar(maxPoints:Number) {
            super(new DHPoint(0, 0), maxPoints, 205, 20);

            this.elements = new Array();

            this._barFrame.scrollFactor = new DHPoint(0, 0);
            this._barFrame.fill(0xffffc8d7);
            this._innerBar.scrollFactor = new DHPoint(0, 0);
            this._innerBar.fill(0xfffff5dd);
            this._changeText.setFormat("NexaBold-Regular", 25, 0xff7c6e6a,
                                       "left");
            this._changeText.scrollFactor = new DHPoint(0, 0);
            this._topFrame = new UIElement(0, 0);
            this._topFrame.loadGraphic(UIBar, true, false, 300, 94);
            this._topFrame.addAnimation("play", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26], 12, true);
            this._topFrame.addAnimation("stop", [0], 12, false);
            this._topFrame.scrollFactor = new DHPoint(0, 0);
            this._topFrame.slug = "teampowerbar_frame";
            this.elements.push(this._topFrame);
            this.setVisible(true);

            this._helpText = new FlxText(0, 0, 250, "Attack enemies as a team to lure the boss out!");
            this._helpText.setFormat("NexaBold-Regular", 18, 0xffffffff);
            this._helpText.scrollFactor = new DHPoint(0,0);
        }

        override public function setPoints(points:Number):void {
            super.setPoints(points);
            if (points != 0) {
                SoundManager.getInstance().playSound(
                    SfxEnergy, 1*GameSound.MSEC_PER_SEC, null, false, 1
                );
            }
        }

        public function setHighlight(v:Boolean):void {
            if (this._animatingBar != v) {
                this._animatingBar = v;
                if (v) {
                    this._topFrame.play("play");
                } else {
                    this._topFrame.play("stop");
                }
            }
        }

        override public function setPos(pos:DHPoint):void {
            var basePos:DHPoint = new DHPoint(
                ScreenManager.getInstance().screenWidth - this._outerWidth / 2 - 65,
                30
            );
            super.setPos(basePos);
            this._topFrame.setPos(basePos.sub(new DHPoint(this._outerWidth / 2 + 47, 18)));
            this._helpText.x = basePos.x - 130;
            this._helpText.y = basePos.y + 70;
        }

        override public function addVisibleObjects():void {
            super.addVisibleObjects();
            FlxG.state.add(this._topFrame);
            FlxG.state.add(this._helpText);
            this.hideHelpText();
        }

        override public function setVisible(v:Boolean):void {
            super.setVisible(v);
            this._topFrame.visible = v;
        }

        public function showHelpText():void {
            this._helpText.visible = true;
        }

        public function hideHelpText():void {
            this._helpText.visible = false;
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            var mouseScreenRect:FlxRect = new FlxRect(screenPos.x, screenPos.y,
                                                      5, 5);
            if(mouseScreenRect.overlaps(this._topFrame._getRect())) {
                this.showHelpText();
            } else {
                this.hideHelpText();
            }
        }
    }
}
