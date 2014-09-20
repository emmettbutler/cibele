package{
    import org.flixel.*;

    public class StartScreen extends GameState {
        [Embed(source="../assets/sexyselfie_wip.mp3")] private var VidBGMLoop:Class;
        [Embed(source="../assets/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public var startText:FlxText;

        override public function create():void {
            FlxG.bgColor = 0xff000000;

            startText = new FlxText(100,100,500,"Cibele // This build ends after the first world.\n\nCLICK to move and interact with objects.\nMake sure your sound is on.\n\nSPACE to start.");
            add(startText);
            startText.setFormat("NexaBold-Regular",16,0xffffffff,"left");

            ScreenManager.getInstance();
        }

        public function startGame():void {
            function _innerCallback():void {
                FlxG.switchState(new Desktop());
            }
            FlxG.switchState(new PlayVideoState("../assets/test_video.flv",
                                                _innerCallback));
        }

        override public function update():void{
            super.update();
            if(FlxG.keys.SPACE) {
                SoundManager.getInstance().playSound(VidBGMLoop, 0, null, true, .2, GameSound.BGM);
                startGame();
            }
        }
    }
}
