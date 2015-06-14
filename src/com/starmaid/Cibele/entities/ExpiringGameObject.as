package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class ExpiringGameObject extends GameObject {
        [Embed(source="/../assets/images/characters/blue_steps.png")] private var ImgFeetBlue:Class;
        [Embed(source="/../assets/images/characters/purple-steps.png")] private var ImgFeetPurple:Class;

        public var age:Number = 0;
        public var drawn:Boolean;
        public var fadeFrames:Number = 200;
        public static const PURPLE:Number = 1;
        public static const BLUE:Number = 2;

        public function ExpiringGameObject() {
            super(ZERO_POINT);
            this.alpha = 0;
            FlxG.state.add(this);
        }

        override public function update():void {
            super.update();
            this.age++;
            this.alpha = (this.fadeFrames - this.age) / this.fadeFrames;
        }

        public function place(pos:DHPoint):void {
            this.setPos(pos);
            this.age = 0;
        }
    }
}
