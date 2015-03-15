package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.Emote;
    import com.starmaid.Cibele.entities.BlankScreen;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    import flash.events.*;

    public class Euryale extends LevelMapState {
        [Embed(source="/../assets/audio/music/bgm_euryale_intro.mp3")] private var EUBGMIntro:Class;
        [Embed(source="/../assets/audio/music/bgm_euryale_loop.mp3")] private var EUBGMLoop:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_hey.mp3")] private var Convo1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_teleport.mp3")] private var Convo1_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_breakups.mp3")] private var Convo2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_nada.mp3")] private var Convo2_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_crush.mp3")] private var Convo3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_callmeblake.mp3")] private var Convo3_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_closer.mp3")] private var Convo4:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_meetup.mp3")] private var Convo4_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_parents.mp3")] private var Convo4_3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_dredge.mp3")] private var Convo5:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_canicallyou.mp3")] private var Convo5_2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_euryale_cibyeah.mp3")] private var Convo5_3:Class;

        public static var BGM:String = "euryale bgm loop";

        public function Euryale() {
            if(GameState.cur_level != GameState.LVL_EU) {
                GameState.cur_level = GameState.LVL_EU;
            }

            PopUpManager.GAME_ACTIVE = true;

            GlobalTimer.getInstance().deleteMark(BOSS_MARK);
            this.bossHasAppeared = false;

            this.conversationCounter = -1;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "audio": Convo2, "len": 40*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo2_2, "len": 25*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showSelfiePostEmail
                },
                {
                    "audio": Convo3, "len": 30*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo3_2, "len": 50*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showFriendEmail2
                },
                {
                    "audio": Convo4, "len": 15*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo4_2, "len": 72*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo4_3, "len": 51*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": showDredgeSelfie
                },
                {
                    "audio": Convo5, "len": 92*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo5_2, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": Convo5_3, "len": 5*GameSound.MSEC_PER_SEC,
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
                    EUBGMLoop, 0, null, true, .07, GameSound.BGM, Euryale.BGM,
                    false, false
                );
            }
            SoundManager.getInstance().playSound(
                EUBGMIntro, 2.6*GameSound.MSEC_PER_SEC, _bgmCallback, false,
                .07, Math.random()*928+298, Euryale.BGM, false, false, true
            );

            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {
                SoundManager.getInstance().playSound(
                        Convo1, 12*GameSound.MSEC_PER_SEC, firstConvoPartTwo, false, 1, GameSound.VOCAL,
                        "eu_convo_1_hall"
                    );
                }
        }

        public function firstConvoPartTwo():void {
            SoundManager.getInstance().playSound(
                    Convo1_2, 27*GameSound.MSEC_PER_SEC, this.showFriendEmail, false, 1, GameSound.VOCAL,
                    "eu_convo_1_2_hall"
                );
        }

        public function showFriendEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_1);
        }

        public function showSelfiePostEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_SELFIE);
        }

        public function showFriendEmail2():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_EMAIL_2);
        }

        public function showDredgeSelfie():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.EU_DREDGE);
            GlobalTimer.getInstance().setMark(BOSS_MARK, 50*GameSound.MSEC_PER_SEC);
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
                    new PlayVideoState("/../assets/video/Phone Talk_v1.mp4",
                        function():void {
                            FlxG.switchState(new StartScreen());
                            PopUpManager.GAME_ACTIVE = false;
                        }, null
                    )
                }
            ));
        }
    }
}
