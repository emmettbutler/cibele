package{
    import org.flixel.*;

    public class MenuScreen extends GameState {
        [Embed(source="../assets/login.png")] private var ImgLogin:Class;
        [Embed(source="../assets/quit.png")] private var ImgQuit:Class;
        [Embed(source="../assets/play.png")] private var ImgPlay:Class;
        [Embed(source="../assets/charselect_small.png")] private var ImgChar:Class;
        [Embed(source="../assets/bgm_fern_intro.mp3")] private var FernBGMIntro:Class;
        [Embed(source="../assets/bgm_fern_loop.mp3")] private var FernBGMLoop:Class;

        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:GameObject;
        public var login:GameObject;
        public var quit:GameObject;
        public var play_game:GameObject;
        public var char_select:GameObject;
        public var title_text:FlxText;

        public var play_game_rect:FlxRect;
        public var login_rect:FlxRect;
        public var quit_rect:FlxRect;
        public var mouse_rect:FlxRect;

        public var play_screen:Boolean = false;

        public var img_height:Number = 357;

        public function MenuScreen() {
            super(true, true, false);
            this.showEmoji = false;
        }

        override public function create():void {
            super.create();

            FlxG.bgColor = 0x00000000;
            var _screen:ScreenManager = ScreenManager.getInstance();

            new FernBackgroundLoader().load();

            var smoke:GameObject = new GameObject(new DHPoint(0, 0));
            smoke.active = false;
            add(smoke);
            this.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    smoke.y = event.userData['bg'].y;
                    smoke.makeGraphic(_screen.screenWidth, event.userData['bg'].height, 0xaaffffff);
                    FlxG.stage.removeEventListener(
                        GameState.EVENT_SINGLETILE_BG_LOADED,
                        arguments.callee
                    );
                });

            play_game = new GameObject(new DHPoint(_screen.screenWidth * .45, _screen.screenHeight * .55));
            play_game.loadGraphic(ImgPlay,false,false,121,17);
            add(play_game);
            play_game_rect = new FlxRect(play_game.x,play_game.y,play_game.width,play_game.height);

            quit = new GameObject(new DHPoint(_screen.screenWidth * .45, _screen.screenHeight * .65));
            quit.loadGraphic(ImgQuit,false,false,121,17);
            add(quit);
            quit_rect = new FlxRect(quit.x,quit.y,quit.width,quit.height);

            this.title_text = new FlxText(0, _screen.screenHeight * .2,
                _screen.screenWidth, "VALTAMERI");
            this.title_text.setFormat("NexaBold-Regular", 146, 0xff616161, "center");
            this.title_text.scrollFactor = new FlxPoint(0, 0);
            this.title_text.active = false;
            add(this.title_text);

//
            login = new GameObject(new DHPoint(_screen.screenWidth * .45, _screen.screenHeight * .93));
            login.loadGraphic(ImgLogin,false,false,121,17);

            char_select = new GameObject(new DHPoint(_screen.screenWidth * .35, _screen.screenHeight * .15));
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
        }

        override public function update():void{
            super.update();
            mouse_rect.x = FlxG.mouse.x;
            mouse_rect.y = FlxG.mouse.y;
            if(FlxG.mouse.justPressed()){
                if(mouse_rect.overlaps(play_game_rect) && !play_screen){
                    (new BackgroundLoader()).loadSingleTileBG("../assets/charselectbg.png");
                    ScreenManager.getInstance().setupCamera(null, 1);
                    play_game.kill();
                    quit.kill();
                    play_game_rect.x = login.x;
                    play_game_rect.y = login.y;
                    play_game_rect.width = login.width;
                    play_game_rect.height = login.height;
                    quit_rect.x = login.x;
                    quit_rect.y = login.y
                    quit_rect.width = login.width;
                    quit_rect.height = login.height;
                    add(login);
                    add(char_select);
                    play_screen = true;
                }
                if (mouse_rect.overlaps(quit_rect || play_game_rect) && play_screen){
                    FlxG.switchState(new HallwayToFern());
                }
                if (mouse_rect.overlaps(quit_rect) && !play_screen){
                    PopUpManager.GAME_ACTIVE = false;
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
