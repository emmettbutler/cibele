package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;

    import org.flixel.*;

    public class HealthBar extends Meter {
        [Embed(source="/../assets/images/ui/attack_cursor_small.png")] private var ImgIcon:Class;

        protected var _attackIcon:GameObject;
        public var _activeText:FlxText;

        public function HealthBar(pos:DHPoint, maxPoints:Number,
                                  outerWidth:Number=100,
                                  outerHeight:Number=6) {
            super(pos, maxPoints, outerWidth, outerHeight);

            this.slug = "healthBar" + (Math.random() * 1000000);

            this._attackIcon = new GameObject(pos);
            this._attackIcon.loadGraphic(ImgIcon, false, false, 15, 34);
            this._attackIcon.visible = false;

            this._activeText = new FlxText(pos.x, pos.y, 200, "Active Target");
            this._activeText.setFormat("NexaBold-Regular", 12, 0xff7c6e6a, "left");

            if(ScreenManager.getInstance().levelTracker.level == LevelTracker.LVL_HI) {
                this._activeText.color = 0xffffffff;
            }
        }

        override public function setPos(pos:DHPoint):void {
            super.setPos(pos);
            var outerPos:DHPoint = pos.sub(new DHPoint(this._outerWidth / 2, 0));
            this._attackIcon.setPos(outerPos.sub(new DHPoint(25, 18)));

            this._activeText.x = outerPos.x;
            this._activeText.y = outerPos.y + 5;
        }

        override public function setVisible(v:Boolean):void {
            super.setVisible(v);
            this._attackIcon.visible = v;
            this._activeText.visible = v;
        }

        override public function addVisibleObjects():void {
            super.addVisibleObjects();
            FlxG.state.add(this._attackIcon);
            FlxG.state.add(this._activeText);
        }
    }
}
