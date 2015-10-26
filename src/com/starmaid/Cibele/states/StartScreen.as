package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.DialoguePlayer;
    import com.starmaid.Cibele.states.IkuTursoDesktop;
    import com.starmaid.Cibele.management.BackgroundLoader;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.states.EuryaleDesktop;
    import com.starmaid.Cibele.states.HiisiDesktop;
    import com.starmaid.Cibele.entities.MenuButton;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.desktop.NativeApplication;

    public class StartScreen extends GameState {
        [Embed(source="/../assets/audio/music/vid_intro.mp3")] private var VidBGMLoop:Class;
        [Embed(source="/../assets/audio/music/bgm_cibele.mp3")] private var SndBGM:Class;
        [Embed(source="/../assets/fonts/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public static const BGM:String = "start-screen-bgm";
        private var _startButton:MenuButton, _loadButton:MenuButton,
                    _quitButton:MenuButton, _subtitlesButton:MenuButton;

        override public function create():void {
            this.enable_fade = true;
            this.pausable = false;
            super.create();
            FlxG.bgColor = 0xffffffff;
            var bgFile:String = "startscreen_bg.png";
            if(ScreenManager.getInstance().screenWidth < 1300) {
                bgFile = "startscreen_bg_1280x720.png";
            }
            (new BackgroundLoader()).loadSingleTileBG("/../assets/async/images/ui/" + bgFile);

            ScreenManager.getInstance();

            this.updatePopup = false;
            this.updateMessages = false;
            this.use_loading_screen = false;

            var _startButtonWidth:Number = 200;

            this._startButton = new MenuButton(
                new DHPoint(
                    ScreenManager.getInstance().screenWidth * .22,
                    -1000
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
                        -1000
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
                    -1000
                ),
                new DHPoint(_startButtonWidth, 30),
                "Exit",
                function ():void { NativeApplication.nativeApplication.exit(); }
            );
            this.menuButtons.push(this._quitButton);
            this._quitButton.addToState();

            this._subtitlesButton = new MenuButton(
                new DHPoint(
                    (ScreenManager.getInstance().screenWidth * .5 - _startButtonWidth / 2),
                    -1000
                ),
                new DHPoint(_startButtonWidth, 30),
                "Subtitles: " + (DialoguePlayer.getInstance().subtitles_enabled ? "On" : "Off"),
                this.toggleSubtitles
            );
            this.menuButtons.push(this._subtitlesButton);
            this._subtitlesButton.addToState();

            var that:StartScreen = this;
            this.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    if (that._loadButton != null) {
                        that._loadButton.setPos(new DHPoint(
                            that._loadButton.x,
                            event.userData['bg'].y + event.userData['bg'].height * .84
                        ));
                    }
                    that._quitButton.setPos(new DHPoint(
                        that._quitButton.x,
                        event.userData['bg'].y + event.userData['bg'].height * .84
                    ));
                    that._startButton.setPos(new DHPoint(
                        that._startButton.x,
                        event.userData['bg'].y + event.userData['bg'].height * .84
                    ));
                    var subY:Number = event.userData['bg'].y + event.userData['bg'].height * .84
                    if (fileLevel != LevelTracker.LVL_IT) {
                        subY = event.userData['bg'].y + event.userData['bg'].height * .9
                    }
                    that._subtitlesButton.setPos(new DHPoint(
                        that._subtitlesButton.x,
                        subY
                    ));
                    FlxG.stage.removeEventListener(
                        GameState.EVENT_SINGLETILE_BG_LOADED,
                        arguments.callee
                    );
                });

            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.BGM)) {
                SoundManager.getInstance().playSound(
                    SndBGM, 116 * GameSound.MSEC_PER_SEC, null, true,
                    .4, GameSound.BGM, StartScreen.BGM, false, false, false,
                    true);
            }

            super.postCreate();
        }

        public function toggleSubtitles():void {
            DialoguePlayer.getInstance().toggle_subtitles_enabled();
            this._subtitlesButton.text = "Subtitles " +
                (DialoguePlayer.getInstance().subtitles_enabled ? "On" : "Off");
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
                                    "/../assets/async/video/computer_open.mp4",
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

            this.fadeOut(fn, 4 * GameSound.MSEC_PER_SEC, StartScreen.BGM);
        }
    }
}
