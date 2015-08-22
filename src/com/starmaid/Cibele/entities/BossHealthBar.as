package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.LevelTracker;

    import org.flixel.*;

    public class BossHealthBar extends HealthBar {
        private var name_text:FlxText;
        private var cur_name:String;

        public function BossHealthBar(maxPoints:Number) {
            var text_color:Number = 0xff7c6e6a;
            if(ScreenManager.getInstance().levelTracker.level == LevelTracker.LVL_IT) {
                this.cur_name = "AKKA";
            } else if(ScreenManager.getInstance().levelTracker.level == LevelTracker.LVL_EU) {
                this.cur_name = "SAMPSA";
            } else if(ScreenManager.getInstance().levelTracker.level == LevelTracker.LVL_HI) {
                this.cur_name = "KUU";
                text_color = 0xffffffff;
            }

            super(new DHPoint(0, 0),
                  maxPoints,
                  ScreenManager.getInstance().screenWidth * .7,
                  10
            );
            this._barFrame.scrollFactor = new DHPoint(0, 0);
            this._attackIcon.scrollFactor = new DHPoint(0, 0);
            this._innerBar.scrollFactor = new DHPoint(0, 0);
            this._changeText.setFormat("NexaBold-Regular", 25, text_color,
                                       "left");
            this._changeText.scrollFactor = new DHPoint(0, 0);
            this.name_text = new FlxText(0,0,500,this.cur_name);
            this.name_text.scrollFactor = new DHPoint(0,0);
            this.name_text.setFormat("NexaBold-Regular", 18, text_color,
                                       "left");

            this.setVisible(false);
        }

        override public function setVisible(v:Boolean):void {
            super.setVisible(v);
            this.name_text.visible = v;
        }

        override public function addVisibleObjects():void {
            super.addVisibleObjects();
            FlxG.state.add(this.name_text);
        }

        override public function setPos(pos:DHPoint):void {
            var screenPos:DHPoint = new DHPoint(
                ScreenManager.getInstance().screenWidth / 2,
                ScreenManager.getInstance().screenHeight - 150
            );
            this.name_text.x = this._attackIcon.x + 25;
            this.name_text.y = this._attackIcon.y - 15;
            super.setPos(screenPos);
        }
    }
}
