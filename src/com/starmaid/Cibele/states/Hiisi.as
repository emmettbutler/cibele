package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.Emote;
    import com.starmaid.Cibele.states.BlankScreen;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    import flash.events.*;

    public class Hiisi extends LevelMapState {
        [Embed(source="/../assets/audio/music/bgm_euryale_intro.mp3")] private var EUBGMIntro:Class;
        [Embed(source="/../assets/audio/music/bgm_euryale_loop.mp3")] private var EUBGMLoop:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_morning.mp3")] private var Convo1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_westcoast.mp3")] private var Convo2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_whatifwemet.mp3")] private var Convo3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_whatdoyouthink.mp3")] private var Convo4:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_youtoldme.mp3")] private var Convo5:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_weshouldmeet.mp3")] private var Convo6:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_ifwemet.mp3")] private var Convo7:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_thinkabout.mp3")] private var Convo8:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_superhot.mp3")] private var Convo9:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_itcouldhappen.mp3")] private var Convo10:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_nervous.mp3")] private var Convo11:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_beingwithyou.mp3")] private var Convo12:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_illcome.mp3")] private var Convo13:Class;
        [Embed(source="/../assets/audio/voiceover/voc_hiisi_doingthis.mp3")] private var Convo14:Class;

        public static var BGM:String = "hiisi bgm loop";
        public static const CONVO_1_HALL:String = "blahhhahshshd";
        public static const CONVO_2_HALL:String = "blajfhkjsdhfksjh";
        public static const SHOW_FIRST_POPUP:String = "yeaahhhahahjsdkah";

        public function Hiisi() {
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_HI;

            //currently no bit dialogue is playing in this act. may want to change later.
            this.bitDialogueLock = true;
            PopUpManager.GAME_ACTIVE = true;

            GlobalTimer.getInstance().deleteMark(BOSS_MARK);

            this.conversationCounter = -1;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "audio": Convo3, "len": 25*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: showBlakeSelfie
                },
                {
                    "audio": Convo4, "len": 61*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: showBeccaEmail
                },
                {
                    "audio": Convo5, "len": 21*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 7*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo6, "len": 21*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 7*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo7, "len": 37*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 7*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo8, "len": 58*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo9, "len": 11*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: showProfEmail
                },
                {
                    "audio": Convo10, "len": 59*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo11, "len": 23*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 7*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo12, "len": 42*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: startBoss, "ends_with_popup": false
                },
                {
                    "audio": null, "len": 35*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": killBoss, "ends_with_popup": false
                },
                {
                    "audio": null, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo13, "len": 27*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo14, "len": 43*GameSound.MSEC_PER_SEC,
                    "delay": 0
                }
            ];

            this.filename = "data/ikuturso_path.txt";
            this.graph_filename = "data/ikuturso_graph.txt";
            this.mapTilePrefix = "ikuturso";
            this.tileGridDimensions = new DHPoint(10, 5);
            this.estTileDimensions = new DHPoint(1359, 818);
            this.playerStartPos = new DHPoint(4600, 7565);
            this.colliderScaleFactor = 8.65;
            this.enemyDirMultiplier = 2.5;
        }

        override public function create():void {
            this.registerPopupCallback();
            super.create();

            function _bgmCallback():void {
                SoundManager.getInstance().playSound(
                    EUBGMLoop, 0, null, true, .07, GameSound.BGM, Hiisi.BGM,
                    false, false
                );
            }
            SoundManager.getInstance().playSound(
                EUBGMIntro, 2.6*GameSound.MSEC_PER_SEC, _bgmCallback, false,
                .07, Math.random()*928+298, Hiisi.BGM, false, false, true
            );

            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {
                SoundManager.getInstance().playSound(
                        Convo1, GameState.SHORT_DIALOGUE ? 1 : 20*GameSound.MSEC_PER_SEC, delayFirstConvoPartTwo, false, 1, GameSound.VOCAL,
                        CONVO_1_HALL
                    );
            }
        }

        public function delayFirstConvoPartTwo():void {
            GlobalTimer.getInstance().setMark("delay convo 1 pt 2", GameState.SHORT_DIALOGUE ? 1 : 5*GameSound.MSEC_PER_SEC, this.firstConvoPartTwo);
        }

        public function firstConvoPartTwo():void {
            SoundManager.getInstance().playSound(
                    Convo2, GameState.SHORT_DIALOGUE ? 1 : 25*GameSound.MSEC_PER_SEC, this.delayFlightEmail, false, 1, GameSound.VOCAL,
                    CONVO_2_HALL
                );
        }

        public function delayFlightEmail():void {
            GlobalTimer.getInstance().setMark(SHOW_FIRST_POPUP, GameState.SHORT_DIALOGUE ? 1 : 5*GameSound.MSEC_PER_SEC, this.showFlightEmail);
        }

        public function showFlightEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.HI_EMAIL_1);
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

        public function startBoss():void {
            GlobalTimer.getInstance().setMark(BOSS_MARK, 1*GameSound.MSEC_PER_SEC);
        }

        public function killBoss():void {
            if(this.boss != null) {
                this.boss.die();
            }
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
                GlobalTimer.getInstance().setMark("1st Convo Emote", 9*GameSound.MSEC_PER_SEC, this.ichiMadEmote);
            }
        }

        override public function finalConvoDone():void {
            GlobalTimer.getInstance().setMark("hi end", 1*GameSound.MSEC_PER_SEC, this.playEndFilm);
        }

        public function playMeetupV1():void {
            PopUpManager.GAME_ACTIVE = false;
            FlxG.switchState(new PlayVideoState("/../assets/video/4.1 Meetup_v1.mp4",
                        playHallways)
            );
        }

        public function playHallways():void {
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
            FlxG.switchState(new PlayVideoState("/../assets/video/4.4 Goodbye_v1.mp4",
                playBlankScreen3)
            );
        }

        public function playBlankScreen3():void {
            FlxG.switchState(new BlankScreen(10*GameSound.MSEC_PER_SEC,
                playEnd)
            );
        }

        public function playEnd():void {
            FlxG.switchState(new PlayVideoState("/../assets/video/4.5 Turn off_v1.mp4",
                playBlankScreen4)
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
            //SoundManager.getInstance().playSound(VidBGMLoop, 0, null,
                    //false, 1, GameSound.BGM);
            FlxG.switchState(new BlankScreen(7*GameSound.MSEC_PER_SEC,
                playMeetupV1
            ));
        }
    }
}
