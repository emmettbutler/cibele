package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.states.IkuTursoDesktop;
    import com.starmaid.Cibele.management.BackgroundLoader;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.states.EuryaleDesktop;
    import com.starmaid.Cibele.states.HiisiDesktop;
    import com.starmaid.Cibele.entities.MenuButton;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.desktop.NativeApplication;

    public class StartScreen extends GameState {
        [Embed(source="/../assets/audio/music/vid_intro.mp3")] private var VidBGMLoop:Class;
        [Embed(source="/../assets/audio/music/bgm_cibele.mp3")] private var BGM:Class;
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="/../assets/images/ui/Crystal-icon-large-title.png")] private var ImgXtal:Class;

        public var startText:FlxText, startText2:FlxText, startText3:FlxText;
        private var _startButton:MenuButton, _loadButton:MenuButton,
                    _quitButton:MenuButton, crystalIcon:GameObject, bgLayer:GameObject;

        override public function create():void {
            this.enable_fade = true;
            this.pausable = false;
            super.create();
            FlxG.bgColor = 0xffffffff;
            //(new BackgroundLoader()).loadSingleTileBG("/../assets/images/ui/UI_Startscreen_Background.png");

            this.bgLayer = new GameObject(new DHPoint(0, 0));
            this.bgLayer.scrollFactor = new DHPoint(0, 0);
            this.bgLayer.active = false;
            this.bgLayer.makeGraphic(
                ScreenManager.getInstance().screenWidth,
                ScreenManager.getInstance().screenHeight,
                0xffffffff
            );
            this.add(this.bgLayer);

            ScreenManager.getInstance();

            this.crystalIcon = new GameObject(new DHPoint((ScreenManager.getInstance().screenWidth * .5) - 314/2,
                (ScreenManager.getInstance().screenHeight * .5) - 500/2 - 70));
            this.crystalIcon.loadGraphic(ImgXtal, false, false, 314, 500);
            add(this.crystalIcon);

            startText = new FlxText(ScreenManager.getInstance().screenWidth * .22, this.crystalIcon.y + (this.crystalIcon.height + 30),1000,"CLICK to move and interact with objects.\nMake sure your sound is on.");
            add(startText);
            startText.setFormat("NexaBold-Regular",16,0xffea98a9,"left");

            startText2 = new FlxText(ScreenManager.getInstance().screenWidth * .57, this.crystalIcon.y + (this.crystalIcon.height + 30),1000,"COMMAND+Q or Alt+F4 to Quit.\nESC to pause.");
            add(startText2);
            startText2.setFormat("NexaBold-Regular",16,0xffea98a9,"left");

            startText3 = new FlxText(ScreenManager.getInstance().screenWidth * .22, this.crystalIcon.y + (this.crystalIcon.height + 75),1000,"This build contains the full game. Please note that it is, however, still in development.\nPlease do not share this build with anyone.");
            add(startText3);
            startText3.setFormat("NexaBold-Regular",16,0xff8d8d8d,"left");

            this.updatePopup = false;
            this.updateMessages = false;
            this.use_loading_screen = false;

            var _startButtonWidth:Number = 200;

            this._startButton = new MenuButton(
                new DHPoint(
                    ScreenManager.getInstance().screenWidth * .22,
                    this.crystalIcon.y + (this.crystalIcon.height + 130)
                ),
                new DHPoint(_startButtonWidth, 30),
                "New Game",
                function ():void { startGame(); }
            );
            this.menuButtons.push(this._startButton);
            this._startButton.addToState();

            var fileLevel:String = ScreenManager.getInstance().levelTracker.peekSaveFile();
            if (fileLevel != LevelTracker.LVL_IT) {
                this._loadButton = new MenuButton(
                    new DHPoint(
                        ScreenManager.getInstance().screenWidth * .5 - _startButtonWidth/2,
                        this.crystalIcon.y + (this.crystalIcon.height + 130)
                    ),
                    new DHPoint(_startButtonWidth, 30),
                    "Continue",
                    function ():void { startGame(true); }
                );
                this.menuButtons.push(this._loadButton);
                this._loadButton.addToState();
            }

            this._quitButton = new MenuButton(
                new DHPoint(
                    ((ScreenManager.getInstance().screenWidth * .5 - _startButtonWidth/2) - (ScreenManager.getInstance().screenWidth * .22 + _startButtonWidth)) + ScreenManager.getInstance().screenWidth * .5 + _startButtonWidth/2,
                    this.crystalIcon.y + (this.crystalIcon.height + 130)
                ),
                new DHPoint(_startButtonWidth, 30),
                "Exit",
                function ():void { NativeApplication.nativeApplication.exit(); }
            );
            this.menuButtons.push(this._quitButton);
            this._quitButton.addToState();

            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.BGM)) {
                SoundManager.getInstance().playSound(
                    BGM, 116 * GameSound.MSEC_PER_SEC, null, true,
                    .4, GameSound.BGM, CreditsState.BGM, false, false, false
                );
            }

            super.postCreate();
        }

        public function startGame(shouldLoad:Boolean=false):void {
            if (shouldLoad) {
                ScreenManager.getInstance().levelTracker.loadProgress();
            }

            var fn:Function;

            if(!shouldLoad || ScreenManager.getInstance().levelTracker.it()) {
                fn = function ():void {
                    FlxG.switchState(new TextScreen(6 * GameSound.MSEC_PER_SEC,
                        function():void {
                            SoundManager.getInstance().playSound(VidBGMLoop, 24*GameSound.MSEC_PER_SEC, null, false, 1, Math.random()*5000+100);
                            FlxG.switchState(
                                new PlayVideoState(
                                    "/../assets/async/video/computer_open.flv",
                                    function ():void {
                                        FlxG.switchState(new IkuTursoDesktop());
                                    }
                                ));
                        }, "February 18th, 2009"));
                }
            } else if(shouldLoad && ScreenManager.getInstance().levelTracker.eu()) {
                fn = function():void {
                    FlxG.switchState(new EuryaleDesktop());
                }
            } else if(shouldLoad && ScreenManager.getInstance().levelTracker.hi()) {
                fn = function():void {
                    FlxG.switchState(new HiisiDesktop());
                }
            }

            this.fadeOut(fn, 4 * GameSound.MSEC_PER_SEC, CreditsState.BGM);
        }
    }
}
