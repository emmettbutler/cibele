package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.states.IkuTursoDesktop;
    import com.starmaid.Cibele.management.BackgroundLoader;
    import com.starmaid.Cibele.states.EuryaleDesktop;
    import com.starmaid.Cibele.entities.MenuButton;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.desktop.NativeApplication;

    public class StartScreen extends GameState {
        [Embed(source="/../assets/audio/music/vid_intro.mp3")] private var VidBGMLoop:Class;
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public var startText:FlxText;
        private var _startButton:MenuButton, _loadButton:MenuButton,
                    _quitButton:MenuButton;

        override public function create():void {
            this.enable_fade = true;
            this.pausable = false;
            super.create();
            FlxG.bgColor = 0xff000000;
            (new BackgroundLoader()).loadSingleTileBG("/../assets/images/ui/UI_Startscreen_Background.png");

            startText = new FlxText(100,100,500,"Cibele\n\nCLICK to move and interact with objects.\nMake sure your sound is on.\n\nCOMMAND+Q or Alt+F4 to Quit.\n\nESC to pause.");
            add(startText);
            startText.setFormat("NexaBold-Regular",16,0xffffffff,"left");

            ScreenManager.getInstance();

            this.updatePopup = false;
            this.updateMessages = false;
            this.use_loading_screen = false;

            var _startButtonWidth:Number = 200;

            this._startButton = new MenuButton(
                new DHPoint(
                    ScreenManager.getInstance().screenWidth / 2 - _startButtonWidth / 2,
                    ScreenManager.getInstance().screenHeight - 120
                ),
                new DHPoint(_startButtonWidth, 30),
                "New Game",
                function ():void { startGame(); }
            );
            this.menuButtons.push(this._startButton);
            this._startButton.addToState();

            this._loadButton = new MenuButton(
                new DHPoint(
                    ScreenManager.getInstance().screenWidth / 2 - _startButtonWidth / 2,
                    ScreenManager.getInstance().screenHeight - 80
                ),
                new DHPoint(_startButtonWidth, 30),
                "Continue",
                function ():void { startGame(true); }
            );
            this.menuButtons.push(this._loadButton);
            this._loadButton.addToState();

            this._quitButton = new MenuButton(
                new DHPoint(
                    ScreenManager.getInstance().screenWidth / 2 - _startButtonWidth / 2,
                    ScreenManager.getInstance().screenHeight - 40
                ),
                new DHPoint(_startButtonWidth, 30),
                "Exit",
                function ():void { NativeApplication.nativeApplication.exit(); }
            );
            this.menuButtons.push(this._quitButton);
            this._quitButton.addToState();

            super.postCreate();
        }

        public function startGame(shouldLoad:Boolean=false):void {
            if (shouldLoad) {
                ScreenManager.getInstance().levelTracker.loadProgress();
            }

            var fn:Function;

            if(!shouldLoad || ScreenManager.getInstance().levelTracker.it()) {
                fn = function ():void {
                    SoundManager.getInstance().playSound(VidBGMLoop, 24*GameSound.MSEC_PER_SEC, null, false, 1, Math.random()*5000+100);
                    FlxG.switchState(
                        new PlayVideoState(
                            "/../assets/video/computer_open.flv",
                            function ():void {
                                FlxG.switchState(new IkuTursoDesktop());
                            }
                        ));
                }
            } else if(shouldLoad && ScreenManager.getInstance().levelTracker.eu()) {
                fn = function():void {
                    FlxG.switchState(new EuryaleDesktop());
                }
            } else if(shouldLoad && ScreenManager.getInstance().levelTracker.hi()) {
            }

            this.fadeOut(fn, 4 * GameSound.MSEC_PER_SEC);
        }
    }
}
