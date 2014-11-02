package {
    import org.flixel.*;

    public class Footstep extends GameObject {
        [Embed(source="../assets/blue_steps.png")] private var ImgFeetBlue:Class;
        [Embed(source="../assets/purple-steps.png")] private var ImgFeetPurple:Class;

        public var age:Number = 0;
        public var drawn:Boolean;
        public var fadeFrames:Number = 200;
        public static const PURPLE:Number = 1;
        public static const BLUE:Number = 2;

        public function Footstep(type:Number) {
            super(ZERO_POINT);

            if(type == PURPLE) {
                this.loadGraphic(ImgFeetPurple, false, false, 19, 47);
            } else if(type == BLUE) {
                this.loadGraphic(ImgFeetBlue, false, false, 19, 47);
            }
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
