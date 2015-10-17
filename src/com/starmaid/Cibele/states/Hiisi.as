package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.DialoguePlayer;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.Emote;
    import com.starmaid.Cibele.states.BlankScreen;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.entities.FallingObject;

    import org.flixel.*;

    import flash.events.*;

    public class Hiisi extends LevelMapState {
        [Embed(source="/../assets/audio/music/bgm_hiisi_intro.mp3")] private var BGMIntro:Class;
        [Embed(source="/../assets/audio/music/bgm_hiisi_loop.mp3")] private var BGMLoop:Class;
        [Embed(source="/../assets/audio/music/vid_turnoff.mp3")] private var BGMTurnoff:Class;
        [Embed(source="/../assets/audio/music/vid_meetup.mp3")] private var BGMMeetup:Class;
        [Embed(source="/../assets/audio/music/vid_sex.mp3")] private var BGMSex:Class;
        [Embed(source="/../assets/audio/music/vid_hallway.mp3")] private var BGMHallway:Class;
        [Embed(source="/../assets/images/worlds/steam.png")] private var ImgSteam:Class;
        [Embed(source="/../assets/images/worlds/lava_bubble.png")] private var ImgBubble:Class;
        [Embed(source="/../assets/images/worlds/rock.png")] private var ImgRock:Class;

        public static var BGM:String = "hiisi bgm loop";
        public static const CONVO_1_HALL:String = "blahhhahshshd";
        public static const CONVO_2_HALL:String = "blajfhkjsdhfksjh";
        public static const SHOW_FIRST_POPUP:String = "yeaahhhahahjsdkah";

        public static const STEAMS_COUNT:Number = 23;
        public static const BUBBLES_COUNT:Number = 22;
        public static const ROCKS_COUNT:Number = 6;

        private var steams:Array, rocks:Array, bubbles:Array;

        public function Hiisi() {
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_HI;

            //currently no bit dialogue is playing in this act. may want to change later.
            this.bitDialogueLock = true;
            this.load_screen_text = "Hiisi";
            this.notificationTextColor = 0xffffffff;
            this.ui_color_flag = GameState.UICOLOR_PINK;
            if (ScreenManager.getInstance().SHORT_DIALOGUE) {
                this.teamPowerBossThresholds = [1, 3];
            } else {
                this.teamPowerBossThresholds = [6, 15];
            }
            PopUpManager.GAME_ACTIVE = true;

            GlobalTimer.getInstance().deleteMark(BOSS_MARK);

            this.conversationCounter = -1;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "len": 25*GameSound.MSEC_PER_SEC,
                    "delay": 0, "audio_name": "voc_hiisi_whatifwemet"
                },
                {
                    "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: showBlakeSelfie, "min_team_power": 5
                },
                {
                    "len": 61*GameSound.MSEC_PER_SEC,
                    "delay": 0, "audio_name": "voc_hiisi_whatdoyouthink"
                },
                {
                    "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: showBeccaEmail, "min_team_power": 7
                },
                {
                    "len": 21*GameSound.MSEC_PER_SEC,
                    "delay": 0, "audio_name": "voc_hiisi_youtoldme"
                },
                {
                    "len": 7*GameSound.MSEC_PER_SEC,
                    "delay": 0, "min_team_power": 9
                },
                {
                    "len": 22*GameSound.MSEC_PER_SEC,
                    "delay": 0, "audio_name": "voc_hiisi_weshouldmeet"
                },
                {
                    "len": 3*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "len": 37*GameSound.MSEC_PER_SEC,
                    "delay": 0, "audio_name": "voc_hiisi_ifwemet"
                },
                {
                    "len": 3*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "len": 61*GameSound.MSEC_PER_SEC,
                    "delay": 0, "audio_name": "voc_hiisi_thinkabout"
                },
                {
                    "len": 11*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: showProfEmail, "min_team_power": 15,
                    "audio_name": "voc_hiisi_superhot"
                },
                {
                    "len": 59*GameSound.MSEC_PER_SEC,
                    "delay": 0, "audio_name": "voc_hiisi_itcouldhappen"
                },
                {
                    "len": 23*GameSound.MSEC_PER_SEC,
                    "delay": 0, "audio_name": "voc_hiisi_nervous"
                },
                {
                    "len": 3*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "len": 42*GameSound.MSEC_PER_SEC,
                    "delay": 0, "ends_with_popup": false,
                    "audio_name": "voc_hiisi_beingwithyou"
                },
                {
                    "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0, "min_team_power": 20
                },
                {
                    "len": 27*GameSound.MSEC_PER_SEC,
                    "delay": 0, "min_team_power": 22,
                    "audio_name": "voc_hiisi_illcome"
                },
                {
                    "len": 28*GameSound.MSEC_PER_SEC,
                    "delay": 0, "audio_name": "voc_hiisi_doingthis"
                },
                {
                    "len": 3*GameSound.MSEC_PER_SEC,
                    "delay": 0, "boss_gate": true
                },
                {
                    "len": 15*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": playEndFilm,
                    "audio_name": "voc_hiisi_iloveyou"
                }
            ];

            this.filename = "data/hiisi_path.txt";
            this.graph_filename = "data/hiisi_graph.txt";
            this.mapTilePrefix = "hiisi";
            this.tileGridDimensions = new DHPoint(10, 5);
            this.estTileDimensions = new DHPoint(1359, 816);
            this.playerStartPos = new DHPoint(1527, 6347);
            this.colliderScaleFactor = 8.05;
            this.enemyDirMultiplier = 2.5;
            this.maxTeamPower = 22;
        }

        override public function create():void {
            this.registerPopupCallback();
            super.create();

            function _bgmCallback():void {
                SoundManager.getInstance().playSound(
                    BGMLoop, 0, null, true, .2, GameSound.BGM, Hiisi.BGM,
                    false, false
                );
            }
            SoundManager.getInstance().playSound(
                BGMIntro, 5.647 * GameSound.MSEC_PER_SEC, _bgmCallback, false,
                .2, Math.random()*928+298, Hiisi.BGM, false, false, true
            );

            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {
                DialoguePlayer.getInstance().playFile(
                    "voc_hiisi_morning",
                    GameState.SHORT_DIALOGUE ? 1 : 20*GameSound.MSEC_PER_SEC,
                    delayFirstConvoPartTwo, 1, GameSound.VOCAL,
                    CONVO_1_HALL
                );
            }

            if (ScreenManager.getInstance().QUICK_LEVELS) {
                GlobalTimer.getInstance().setMark(
                    "end_level_hi",
                    10 * GameSound.MSEC_PER_SEC,
                    this.playEndFilm
                )
            }
        }

        override public function destroy():void {
            this.steams = null;
            this.rocks = null;
            this.bubbles = null;
            super.destroy();
        }

        override public function addEnvironmentDetails():void {
            this.setupSteam();
            this.setupBubbles();
        }

        override public function addScreenspaceDetails():void {
            this.setupRocks();
        }

        private function setupRocks():void {
            this.rocks = new Array();
            var rock:GameObject;
            var rockDimensions:DHPoint = new DHPoint(90, 148);
            for (var i:int = 0; i < ROCKS_COUNT; i++) {
                rock = new FallingObject(new DHPoint(
                    Math.random() * (ScreenManager.getInstance().screenWidth - rockDimensions.x),
                    -1 * rockDimensions.y
                ));
                rock.loadGraphic(ImgRock, false, false,
                                 rockDimensions.x, rockDimensions.y);
                rock.addAnimation("run",
                    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 13, true);
                FlxG.state.add(rock);
                rock.play("run");
                this.rocks.push(rock);
            }
        }

        private function setupSteam():void {
            this.steams = new Array();
            var steam:GameObject;
            var steamDimensions:DHPoint = new DHPoint(200, 347);
            for (var i:int = 0; i < STEAMS_COUNT; i++) {
                steam = new GameObject(new DHPoint(
                    Math.random() * (this.levelDimensions.x - steamDimensions.x),
                    Math.random() * (this.levelDimensions.y - steamDimensions.y)
                ));
                steam.loadGraphic(ImgSteam, false, false,
                                   steamDimensions.x, steamDimensions.y);
                steam.addAnimation("run",
                    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28], 18, true);
                steam.zSorted = true;
                steam.basePos = new DHPoint(steam.x, steam.y + steam.height);
                FlxG.state.add(steam);
                steam.play("run");
                this.steams.push(steam);
            }
        }

        private function setupBubbles():void {
            this.bubbles = new Array();
            var bubble:GameObject;
            var bubbleDimensions:DHPoint = new DHPoint(90, 55);
            var frames:Array;
            for (var i:int = 0; i < STEAMS_COUNT; i++) {
                frames = new Array();
                bubble = new GameObject(new DHPoint(
                    Math.random() * (this.levelDimensions.x - bubbleDimensions.x),
                    Math.random() * (this.levelDimensions.y - bubbleDimensions.y)
                ));
                bubble.loadGraphic(ImgBubble, false, false,
                                   bubbleDimensions.x, bubbleDimensions.y);
                for (var k:int = 0; k < 21; k++) {
                    frames.push(k);
                }
                var limit:Number = 5 + Math.floor(Math.random() * 10);
                for (k = 0; k < 10; k++) {
                    frames.push(0);
                }
                bubble.addAnimation("run", frames, 18, true);
                bubble.zSorted = true;
                bubble.basePos = new DHPoint(bubble.x, bubble.y + bubble.height);
                FlxG.state.add(bubble);
                bubble.play("run");
                this.bubbles.push(bubble);
            }
        }

        public function delayFirstConvoPartTwo():void {
            GlobalTimer.getInstance().setMark(
                "delay convo 1 pt 2",
                GameState.SHORT_DIALOGUE ? 1 : 5*GameSound.MSEC_PER_SEC,
                this.firstConvoPartTwo);
        }

        public function firstConvoPartTwo():void {
            DialoguePlayer.getInstance().playFile(
                "voc_hiisi_westcoast",
                GameState.SHORT_DIALOGUE ? 1 : 25*GameSound.MSEC_PER_SEC,
                this.delayFlightEmail, 1, GameSound.VOCAL,
                CONVO_2_HALL
            );
        }

        public function delayFlightEmail():void {
            GlobalTimer.getInstance().setMark(
                SHOW_FIRST_POPUP,
                GameState.SHORT_DIALOGUE ? 1 : 5*GameSound.MSEC_PER_SEC,
                this.showFlightEmail);
        }

        public function showFlightEmail():void {
            this.doIfMinTeamPower(function():void {
                PopUpManager.getInstance().sendPopup(PopUpManager.HI_EMAIL_1);
            }, 1);
        }

        public function showBlakeSelfie():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.HI_PICLY_1);
        }

        public function showBeccaEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.HI_EMAIL_2);
        }

        public function showFirstSelfie():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.HI_SELFIE_DC);
        }

        public function showProfEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.HI_EMAIL_3);
        }

        override public function update():void{
            super.update();
        }

        public function ichiMadEmote():void {
            PopUpManager.getInstance().emote(new FlxRect(0,0), this.pathWalker, true, Emote.ANGRY);
        }

        public function ichiSadEmote():void {
            PopUpManager.getInstance().emote(new FlxRect(0,0), this.pathWalker, true, Emote.SAD);
        }

        public function ichiHappyEmote():void {
            PopUpManager.getInstance().emote(new FlxRect(0,0), this.pathWalker, true, Emote.HAPPY);
        }

        override public function playTimedEmotes(convoNum:Number):void {
            if(convoNum == 6) {
                GlobalTimer.getInstance().setMark("1st Convo Emote", 11*GameSound.MSEC_PER_SEC, this.ichiMadEmote);
            }
        }

        public function playMeetupV1():void {
            PopUpManager.GAME_ACTIVE = false;
            FlxG.switchState(new TextScreen(6 * GameSound.MSEC_PER_SEC,
                function():void {
                    SoundManager.getInstance().playSound(
                        BGMMeetup,
                        7 * GameSound.MSEC_PER_SEC,
                        null, false, 1, GameSound.BGM
                    );
                    FlxG.switchState(
                        new PlayVideoState(
                            "/../assets/video/4.1 Meetup_v1.mp4",
                            playHallways
                        )
                    );
                }, "1 Month Later\nSeptember 18th, 2009"));
        }

        public function playHallways():void {
            SoundManager.getInstance().playSound(
                        BGMHallway,
                        19 * GameSound.MSEC_PER_SEC,
                        null, false, 1, GameSound.BGM
                    );
            FlxG.switchState(new PlayVideoState("/../assets/video/4.2 Hallways_v1.mp4",
                playBlankScreen1)
            );
        }

        public function playBlankScreen1():void {
            FlxG.switchState(new BlankScreen(6*GameSound.MSEC_PER_SEC,
                playSexFilm)
            );
        }

        public function playSexFilm():void {
            SoundManager.getInstance().playSound(
                BGMSex,
                69 * GameSound.MSEC_PER_SEC,
                null, false, 1, GameSound.BGM
            );
            FlxG.switchState(new PlayVideoState("/../assets/video/4.3 Sex_v1.mp4",
                playBlankScreen2)
            );
        }

        public function playBlankScreen2():void {
            FlxG.switchState(new BlankScreen(10*GameSound.MSEC_PER_SEC,
                playGoodbye)
            );
        }

        public function playGoodbye():void {
            DialoguePlayer.getInstance().playFile(
                "vid_goodbye", 46 * GameSound.MSEC_PER_SEC, null, 1,
                GameSound.BGM
            );
            FlxG.switchState(new PlayVideoState("/../assets/video/4.4 Goodbye_v1.mp4",
                playBlankScreen3)
            );
        }

        public function playBlankScreen3():void {
            FlxG.switchState(new BlankScreen(19 * GameSound.MSEC_PER_SEC,
                playEnd)
            );
        }

        public function playEnd():void {
            SoundManager.getInstance().playSound(
                BGMTurnoff,
                14 * GameSound.MSEC_PER_SEC,
                null, false, 1, GameSound.BGM
            );
            FlxG.switchState(new PlayVideoState("/../assets/video/4.5 Turn off_v1.mp4",
                playBlankScreen4, null, true)
            );
        }

        public function playBlankScreen4():void {
            FlxG.switchState(new BlankScreen(10*GameSound.MSEC_PER_SEC,
                playCredits)
            );
        }

        public function playCredits():void {
            FlxG.switchState(new CreditsState());
        }

        public function playEndFilm():void {
            this.fadeOut(
                function():void {
                    FlxG.switchState(new BlankScreen(7*GameSound.MSEC_PER_SEC,
                        playMeetupV1
                    ));
                },
                1 * GameSound.MSEC_PER_SEC,
                Hiisi.BGM
            );
        }
    }
}
