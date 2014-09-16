package{
    import org.flixel.*;

    public class MenuScreen extends GameState {
        [Embed(source="../assets/login.png")] private var ImgLogin:Class;
        [Embed(source="../assets/quit.png")] private var ImgQuit:Class;
        [Embed(source="../assets/play.png")] private var ImgPlay:Class;
        [Embed(source="../assets/charselect.png")] private var ImgChar:Class;
        [Embed(source="../assets/bgm_fern_intro.mp3")] private var FernBGMIntro:Class;
        [Embed(source="../assets/bgm_fern_loop.mp3")] private var FernBGMLoop:Class;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:FlxSprite;
        public var login:FlxSprite;
        public var quit:FlxSprite;
        public var play_game:FlxSprite;
        public var char_select:FlxSprite;

        public var play_game_rect:FlxRect;
        public var login_rect:FlxRect;
        public var quit_rect:FlxRect;
        public var mouse_rect:FlxRect;

        public var img_height:Number = 357;

        public function MenuScreen() {
            super(true, false, false);
        }

        override public function create():void {
            FlxG.bgColor = 0x00000000;

            (new BackgroundLoader()).loadSingleTileBG("../assets/menuscreen.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            var _screen:ScreenManager = ScreenManager.getInstance();
            play_game = new FlxSprite(_screen.screenWidth * .45, _screen.screenHeight * .55);
            play_game.loadGraphic(ImgPlay,false,false,121,17);
            add(play_game);
            play_game_rect = new FlxRect(play_game.x,play_game.y,play_game.width,play_game.height);

            quit = new FlxSprite(_screen.screenWidth * .45, _screen.screenHeight * .65);
            quit.loadGraphic(ImgQuit,false,false,121,17);
            add(quit);
            quit_rect = new FlxRect(quit.x,quit.y,quit.width,quit.height);

            login = new FlxSprite(_screen.screenWidth * .45, _screen.screenHeight * .93);
            login.loadGraphic(ImgLogin,false,false,121,17);
            login_rect = new FlxRect(login.x,login.y,login.width,login.height);

            char_select = new FlxSprite(_screen.screenWidth * .35, _screen.screenHeight * .15)
            char_select.loadGraphic(ImgChar,false,false,400,494);

            mouse_rect = new FlxRect(FlxG.mouse.x,FlxG.mouse.y,1,1);

            debugText = new FlxText(0,0,100,"");
            add(debugText);

            //todo this should probs not trigger every time if there's other music playing
            function _musicCallback():void {
                SoundManager.getInstance().playSound(FernBGMLoop, 0, null, true, .05, GameSound.BGM);
            }
            SoundManager.getInstance().playSound(FernBGMIntro, 12631, _musicCallback, false, .1, GameSound.BGM);

            super.postCreate();
            this.game_cursor.setGameMouse();
        }

        override public function update():void{
            super.update();
            mouse_rect.x = FlxG.mouse.x;
            mouse_rect.y = FlxG.mouse.y;
            if(FlxG.mouse.justPressed()){
                if(mouse_rect.overlaps(play_game_rect)){
                    (new BackgroundLoader()).loadSingleTileBG("../assets/charselectbg.png");
                    ScreenManager.getInstance().setupCamera(null, 1);
                    play_game.kill();
                    quit.kill();
                    add(login);
                    add(char_select);
                    super.postCreate();
                    this.game_cursor.setGameMouse();
                }
                if (mouse_rect.overlaps(login_rect)){
                    FlxG.switchState(new HallwayToFern());
                }
                if (mouse_rect.overlaps(quit_rect)){
                    FlxG.switchState(new Desktop());
                }
            }

            timeFrame++;
            debugText.x = FlxG.mouse.x;
            debugText.y = FlxG.mouse.y;

            //debugText.text = "MenuScreen";

            if(timeFrame%30 == 0){
                timer++;
            }
        }
    }
}
