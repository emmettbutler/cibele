package {

    import flash.events.Event;
    import flash.utils.getTimer;

    import org.flixel.*;

    public class FPSCounter extends FlxText {
        public var startTime:Number, framesNumber:Number = 0;

        public function FPSCounter() {
            super(50, 50, 400, "");
            this.scrollFactor.x = 0;
            this.scrollFactor.y = 0;
            this.size = 20;
            this.color = 0xff0000ff;
            FlxG.state.add(this);

            startTime = getTimer();
            FlxG.stage.addEventListener(Event.ENTER_FRAME, checkFPS);
        }

        public function checkFPS(e:Event):void {
            var currentTime:Number = (getTimer() - startTime) / 1000;
            framesNumber++;
            var _fps:Number = Math.floor((framesNumber / currentTime) * 10000.0) / 10000.0;
            if (currentTime > 1) {
                this.text = " FPS: " + _fps;
                startTime = getTimer();
                framesNumber = 0;
            }
        }
    }
}
