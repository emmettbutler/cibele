package {
    import org.flixel.*;

    public class Footstep extends GameObject {
        [Embed(source="../assets/feet.png")] private var ImgFeet:Class;

        public var age:Number = 0;
        public var fadeFrames:Number = 350;

        public function Footstep() {
            super(ZERO_POINT);

            this.loadGraphic(ImgFeet, false, false, 17, 12);
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
