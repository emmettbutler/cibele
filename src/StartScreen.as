package{
    import org.flixel.*;

    public class StartScreen extends GameState {
        [Embed(source="../assets/vid_intro.mp3")] private var VidBGMLoop:Class;
        [Embed(source="../assets/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public var startText:FlxText;

        override public function create():void {
            super.create();
            FlxG.bgColor = 0xff000000;

            startText = new FlxText(100,100,500,"Cibele // This build ends after the first world.\n\nCLICK to move and interact with objects.\nMake sure your sound is on.\n\nSPACE to start.\n\n COMMAND+Q or Alt+F4 to Quit.");
            add(startText);
            startText.setFormat("NexaBold-Regular",16,0xffffffff,"left");

            ScreenManager.getInstance();

            this.updatePopup = false;
            this.updateMessages = false;
        }

        public function startGame():void {
            function _innerCallback():void {
                FlxG.switchState(new Desktop());
            }
            FlxG.switchState(new PlayVideoState("../assets/computer_open.flv",
                                                _innerCallback));
        }

        override public function update():void{
            super.update();
            if(FlxG.keys.SPACE) {
                SoundManager.getInstance().playSound(VidBGMLoop, 24*GameSound.MSEC_PER_SEC, null, false, 1, Math.random()*5000+100);
                startGame();
            }
        }
    }
}
