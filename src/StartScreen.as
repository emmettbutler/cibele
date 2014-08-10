package{
    import org.flixel.*;

    public class StartScreen extends FlxState {
        public var startText:FlxText;

        override public function create():void {
            FlxG.bgColor = 0xff000000;

            startText = new FlxText(0,0,100,"Cibele // SPACE to start");
            add(startText);
        }

        public function startGame():void {
            function _innerCallback():void {
                FlxG.switchState(new HallwayToFern());
            }
            FlxG.switchState(new PlayVideoState("../assets/test_video.flv",
                                                _innerCallback));
        }

        override public function update():void{
            super.update();
            if(FlxG.keys.SPACE) {
                startGame();
            }
        }
    }
}