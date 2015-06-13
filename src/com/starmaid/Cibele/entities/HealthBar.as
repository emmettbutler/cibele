package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class HealthBar extends Meter {
        [Embed(source="/../assets/images/ui/attack_cursor_small.png")] private var ImgIcon:Class;

        protected var _attackIcon:GameObject;
        public function HealthBar(pos:DHPoint, maxPoints:Number,
                                  outerWidth:Number=100,
                                  outerHeight:Number=6) {
            super(pos, maxPoints, outerWidth, outerHeight);

            this.slug = "healthBar" + (Math.random() * 1000000);

            this._attackIcon = new GameObject(pos);
            this._attackIcon.loadGraphic(ImgIcon, false, false, 15, 34);
            this._attackIcon.visible = false;
        }

        override public function setPos(pos:DHPoint):void {
            super.setPos(pos);
            var outerPos:DHPoint = pos.sub(new DHPoint(this._outerWidth / 2, 0));
            this._attackIcon.setPos(outerPos.sub(new DHPoint(25, 18)));
        }

        override public function setVisible(v:Boolean):void {
            super.setVisible(v);
            this._attackIcon.visible = v;
        }

        override public function addVisibleObjects():void {
            super.addVisibleObjects();
            FlxG.state.add(this._attackIcon);
        }
    }
}
