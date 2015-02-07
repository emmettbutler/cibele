package{
    import org.flixel.*;

    public class MenuScreen extends GameState {
        [Embed(source="../assets/charselect_small.png")] private var ImgChar:Class;
        [Embed(source="../assets/audio/music/bgm_menu_intro.mp3")] private var MenuBGMIntro:Class;
        [Embed(source="../assets/audio/music/bgm_menu_loop.mp3")] private var MenuBGMLoop:Class;
        [Embed(source="../assets/images/ui/Crystal-icon-large.png")] private var ImgXtal:Class;

        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:GameObject;
        public var login:BouncingText;
        public var quit:BouncingText;
        public var play_game:BouncingText;
        public var char_select:GameObject;
        public var title_text:FlxText;
        public var char_info:FlxText;

        public var play_game_rect:FlxRect;
        public var login_rect:FlxRect;
        public var quit_rect:FlxRect;
        public var mouse_rect:FlxRect;

        public var crystal_icon:GameObject;

        public var play_screen:Boolean = false;

        public var img_height:Number = 357;

        public static var BGM:String = "menu bgm";

        public function MenuScreen() {
            super(true, true, false);
            this.showEmoji = false;
        }

        override public function create():void {
            PopUpManager.GAME_ACTIVE = true;
            super.create();

            this.use_loading_screen = false;
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

            this.crystal_icon = new GameObject(
                new DHPoint(_screen.screenWidth * .5, _screen.screenHeight * .5)
            );
            this.crystal_icon.loadGraphic(ImgXtal, false, false, 314, 500);
            this.crystal_icon.x -= this.crystal_icon.width/2;
            this.crystal_icon.y -= this.crystal_icon.height/2;
            add(this.crystal_icon);

            this.title_text = new FlxText(0, _screen.screenHeight * .5,
                _screen.screenWidth, "VALTAMERI");
            this.title_text.setFormat("NexaBold-Regular", 146, 0xffce8494, "center");
            this.title_text.scrollFactor = new FlxPoint(0, 0);
            this.title_text.active = false;
            this.title_text.y -= this.title_text.height/2;
            add(this.title_text);

            play_game = new BouncingText(this.title_text.x + _screen.screenWidth * .32,
                                         this.title_text.y + 150,
                                         _screen.screenWidth, "play");
            play_game.setFormat("NexaBold-Regular", 46, 0xff709daa);
            add(play_game);
            play_game_rect = new FlxRect(play_game.x,play_game.y, 120, 50);

            quit = new BouncingText(this.title_text.x + _screen.screenWidth * .62,
                                    this.title_text.y + 150,
                                    _screen.screenWidth, "quit");
            quit.setFormat("NexaBold-Regular", 46, 0xff709daa);
            add(quit);
            quit_rect = new FlxRect(quit.x, quit.y, 120, 50);

            char_select = new GameObject(new DHPoint(_screen.screenWidth * .5,
                                                     _screen.screenHeight * .4));
            char_select.loadGraphic(ImgChar,false,false,400,494);
            char_select.x -= char_select.width/2;
            char_select.y -= char_select.height/2;

            login = new BouncingText(char_select.x + 110,
                                     char_select.y + char_select.height + 50,
                                     170, "> login <");
            login.setFormat("NexaBold-Regular", 46, 0xff709daa);
            login_rect = new FlxRect(login.x, login.y, 100, 30)

            char_info = new FlxText(char_select.x,
                                    char_select.y + char_select.height + 0,
                                    _screen.screenWidth,
                                    "Name: Cibele | Server: Medusa");
            char_info.setFormat("NexaBold-Regular", 26, 0xffce8494);

            mouse_rect = new FlxRect(FlxG.mouse.x,FlxG.mouse.y,1,1);

            debugText = new FlxText(0,0,100,"");
            add(debugText);

            //todo this should probs not trigger every time if there's other music playing
            function _musicCallback():void {
                if(!(FlxG.state is HallwayToFern)) {
                    SoundManager.getInstance().playSound(MenuBGMLoop, 0, null,
                        true, 1, GameSound.BGM, MenuScreen.BGM);
                }
            }
            SoundManager.getInstance().playSound(MenuBGMIntro,
                7.9*GameSound.MSEC_PER_SEC, _musicCallback, false, 1,
                GameSound.SFX, MenuScreen.BGM);

            super.postCreate();
        }

        override public function update():void{
            super.update();

            play_game.update();
            login.update();
            quit.update();

            if(SoundManager.getInstance().getSoundByName(Desktop.ROOMTONE) != null) {
                SoundManager.getInstance().getSoundByName(Desktop.ROOMTONE).fadeOutSound();
            }

            if(mouse_rect.overlaps(play_game_rect)) {
                play_game.alertOn();
            } else {
                play_game.alertOff();
            }
            if(mouse_rect.overlaps(play_game_rect)) {
                login.alertOn();
            } else {
                login.alertOff();
            }
            if(mouse_rect.overlaps(quit_rect)) {
                quit.alertOn();
            } else {
                quit.alertOff();
            }

            mouse_rect.x = FlxG.mouse.x;
            mouse_rect.y = FlxG.mouse.y;
            if(FlxG.mouse.justPressed()){
                if(mouse_rect.overlaps(play_game_rect) && !play_screen){
                    ScreenManager.getInstance().setupCamera(null, 1);
                    play_game.kill();
                    quit.kill();
                    play_game_rect.x = login.x;
                    play_game_rect.y = login.y;
                    play_game_rect.width = 300;
                    play_game_rect.height = 200;
                    add(char_select);
                    add(login);
                    add(char_info);
                    play_screen = true;
                    login.alpha = 1;
                    title_text.alpha = 0;
                    crystal_icon.alpha = 0;
                }
                if (mouse_rect.overlaps(play_game_rect) && play_screen){
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
