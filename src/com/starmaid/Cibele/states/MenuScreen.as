package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.FernBackgroundLoader;
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.entities.BouncingText;
    import com.starmaid.Cibele.states.Desktop;
    import com.starmaid.Cibele.states.IkuTursoDesktop;
    import com.starmaid.Cibele.states.EuryaleDesktop;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    public class MenuScreen extends GameState {
        [Embed(source="/../assets/images/ui/charselect_small.png")] private var ImgChar:Class;
        [Embed(source="/../assets/audio/music/bgm_menu_intro.mp3")] private var MenuBGMIntro:Class;
        [Embed(source="/../assets/audio/music/bgm_menu_loop.mp3")] private var MenuBGMLoop:Class;
        [Embed(source="/../assets/images/ui/Crystal-icon-large.png")] private var ImgXtal:Class;

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
        private var has_initiated_switch:Boolean = false;
        private var bgLoader:FernBackgroundLoader;

        public var crystal_icon:GameObject;

        public var play_screen:Boolean = false;

        public var img_height:Number = 357;

        public static var BGM:String = "menu bgm";

        public function MenuScreen() {
            super(true, true, false);
            this.showEmoji = false;
            this.enable_fade = true;
        }

        override public function create():void {
            PopUpManager.GAME_ACTIVE = true;
            super.create();

            this.use_loading_screen = true;
            FlxG.bgColor = 0x00000000;
            var _screen:ScreenManager = ScreenManager.getInstance();

            this.bgLoader = new FernBackgroundLoader();
            this.bgLoader.load();

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
            char_select.visible = false;
            add(char_select);

            login = new BouncingText(char_select.x + 110,
                                     char_select.y + char_select.height + 50,
                                     170, "> login <");
            login.setFormat("NexaBold-Regular", 46, 0xff709daa);
            add(login);
            login.visible = false;
            login_rect = new FlxRect(login.x, login.y, 100, 30)

            char_info = new FlxText(char_select.x,
                                    char_select.y + char_select.height + 0,
                                    _screen.screenWidth,
                                    "Name: Cibele | Server: Medusa");
            char_info.setFormat("NexaBold-Regular", 26, 0xffce8494);
            add(char_info);
            char_info.visible = false;

            mouse_rect = new FlxRect(FlxG.mouse.x,FlxG.mouse.y,1,1);

            debugText = new FlxText(0,0,100,"");
            add(debugText);

            super.postCreate();
        }

        override public function loadingScreenEndCallback():void {
            SoundManager.getInstance().playSound(MenuBGMIntro,
                    7.9*GameSound.MSEC_PER_SEC, musicCallback, false, 1,
                    GameSound.SFX, MenuScreen.BGM, false, false, false, true);
        }

        public function musicCallback():void {
            if (FlxG.state is MenuScreen && has_initiated_switch == false) {
                SoundManager.getInstance().playSound(MenuBGMLoop, 0, null,
                    true, 1, GameSound.BGM, MenuScreen.BGM, false, false, false, true);
            }
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

            if (this.fading) {
                if(SoundManager.getInstance().getSoundByName(MenuScreen.BGM) != null) {
                    // this fade needs to be quite fast. if it's too slow,
                    // it's possible that it will be abruptly stopped by other
                    // logic before it's fully faded
                    SoundManager.getInstance().getSoundByName(MenuScreen.BGM).fadeOutSound(.1);
                }
            }
        }

        override public function clickCallback(screenPos:DHPoint,
                                               worldPos:DHPoint):void {
            super.clickCallback(screenPos, worldPos);
            if(mouse_rect.overlaps(play_game_rect) && !play_screen){
                ScreenManager.getInstance().setupCamera(null, 1);
                play_game.kill();
                quit.kill();
                play_game_rect.x = login.x;
                play_game_rect.y = login.y;
                play_game_rect.width = 300;
                play_game_rect.height = 200;
                char_select.visible = true;
                char_info.visible = true;
                play_screen = true;
                login.visible = true;
                title_text.visible = false;
                crystal_icon.visible = false;
            }
            if (this.has_initiated_switch == false && mouse_rect.overlaps(play_game_rect) && play_screen){
                this.has_initiated_switch = true;
                this.startStateSwitch();
            }
            if (this.has_initiated_switch == false && mouse_rect.overlaps(quit_rect) && !play_screen){
                PopUpManager.GAME_ACTIVE = false;
                if(ScreenManager.getInstance().levelTracker.it()) {
                    FlxG.switchState(new IkuTursoDesktop());
                } else if(ScreenManager.getInstance().levelTracker.eu()) {
                    FlxG.switchState(new EuryaleDesktop());
                } else if(ScreenManager.getInstance().levelTracker.hi()) {
                    FlxG.switchState(new HiisiDesktop());
                }
            }
        }

        public function startStateSwitch():void {
            this.fadeOut(
                function():void {
                    if(ScreenManager.getInstance().levelTracker.it()) {
                        FlxG.switchState(new IkuTursoHallway());
                    } else if(ScreenManager.getInstance().levelTracker.eu()) {
                        FlxG.switchState(new EuryaleHallway());
                    } else if(ScreenManager.getInstance().levelTracker.hi()) {
                        FlxG.switchState(new HiisiHallway());
                    }
                },
                1 * GameSound.MSEC_PER_SEC
            );
        }

        override public function destroy():void {
            this.bgLoader.unload();
            super.destroy();
        }
    }
}
