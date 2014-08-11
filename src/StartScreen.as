package{
    import org.flixel.*;

    public class StartScreen extends FlxState {
        public var startText:FlxText;

        override public function create():void {
            FlxG.bgColor = 0xff000000;

            startText = new FlxText(100,100,500,"Cibele // This build ends after the first world.\n\nARROWS to move.\nSPACE to attack.\nMake sure your sound is on.\n\nSPACE to start.");
            add(startText);
            startText.size = 16;
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