package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.Emote;
    import com.starmaid.Cibele.entities.BlankScreen;
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

        public function Hiisi() {
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_HI;

            this.bitDialogueLock = false;
            PopUpManager.GAME_ACTIVE = true;

            GlobalTimer.getInstance().deleteMark(BOSS_MARK);

            this.conversationCounter = -1;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "audio": Convo3, "len": 33*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: showBlakeSelfie
                },
                {
                    "audio": Convo4, "len": 61*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: showBeccaEmail
                },
                {
                    "audio": Convo5, "len": 20*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo6, "len": 21*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo7, "len": 36*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: showFirstSelfie
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
                    "audio": Convo11, "len": 22*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo12, "len": 42*GameSound.MSEC_PER_SEC,
                    "delay": 0, endfn: startBoss, "ends_with_popup": false
                },
                {
                    "audio": null, "len": 20*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": killBoss, "ends_with_popup": false
                },
                {
                    "audio": null, "len": 10*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo13, "len": 27*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo14, "len": 41*GameSound.MSEC_PER_SEC,
                    "delay": 0
                }
            ];

            this.filename = "data/euryale_path.txt";
            this.graph_filename = "data/euryale_graph.txt";
            this.mapTilePrefix = "euryale";
            this.tileGridDimensions = new DHPoint(6, 3);
            this.estTileDimensions = new DHPoint(2266, 1365);
            this.playerStartPos = new DHPoint(3427, 7657);
            this.colliderScaleFactor = 3.54;
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
                        Convo1, 19*GameSound.MSEC_PER_SEC, firstConvoPartTwo, false, 1, GameSound.VOCAL,
                        "hi_convo_1_hall"
                    );
                }
        }

        public function firstConvoPartTwo():void {
            SoundManager.getInstance().playSound(
                    Convo2, 24*GameSound.MSEC_PER_SEC, this.showFlightEmail, false, 1, GameSound.VOCAL,
                    "hi_convo_2_hall"
                );
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
            this.bitDialogueLock = true;
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

        override public function finalConvoDone():void {
            GlobalTimer.getInstance().setMark("eu end", 5*GameSound.MSEC_PER_SEC, this.playEndFilm);
        }

        public function playEndFilm():void {
            //SoundManager.getInstance().playSound(VidBGMLoop, 0, null,
                    //false, 1, GameSound.BGM);
            FlxG.switchState(new BlankScreen(5*GameSound.MSEC_PER_SEC,
                function():void {
                    PopUpManager.GAME_ACTIVE = false;
                    new PlayVideoState("/../assets/video/Phone Talk_v1.mp4",
                        function():void {
                            FlxG.switchState(new StartScreen());
                        }, null
                    )
                }
            ));
        }
    }
}