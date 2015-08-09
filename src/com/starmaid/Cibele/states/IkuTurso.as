package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.entities.Emote;
    import com.starmaid.Cibele.entities.IkuTursoBoss;
    import com.starmaid.Cibele.states.BlankScreen;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    public class IkuTurso extends LevelMapState {
        [Embed(source="/../assets/audio/music/bgm_ikuturso_intro.mp3")] private var ITBGMIntro:Class;
        [Embed(source="/../assets/audio/music/bgm_ikuturso_loop.mp3")] private var ITBGMLoop:Class;
        [Embed(source="/../assets/audio/music/vid_sexyselfie.mp3")] private var VidBGMLoop:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_bulldog.mp3")] private var Convo1:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_ampule.mp3")] private var Convo2:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_photogenic.mp3")] private var Convo3:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_attractive.mp3")] private var Convo4:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_picture.mp3")] private var Convo5:Class;
        [Embed(source="/../assets/audio/voiceover/voc_ikuturso_whattowear.mp3")] private var Convo6:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_ichilasthit.mp3")] private var IchiBossKill:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_yeahsorry.mp3")] private var SndYeahSorry:Class;
        [Embed(source="/../assets/audio/voiceover/voc_extra_areyoucoming.mp3")] private var SndRUComing:Class;

        private var convo1Sound:GameSound;
        private var convo1Ready:Boolean;

        public static var BGM:String = "ikuturso bgm loop";

        public function IkuTurso() {
            PopUpManager.GAME_ACTIVE = true;
            this.ui_color_flag = GameState.UICOLOR_PINK;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "audio": Convo1, "len": 59*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 4*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showIchiDownloadWindow, "min_team_power": 5
                },
                {
                    "audio": Convo2, "len": 80*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 4*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showSelfiesWindow, "min_team_power": 10
                },
                {
                    "audio": Convo3, "len": 27*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 5*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showGuilEmail
                },
                {
                    "audio": Convo4, "len": 108*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 2*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showIchiSelfie1, "min_team_power": 30
                },
                {
                    "audio": Convo5, "len": 16*GameSound.MSEC_PER_SEC,
                    "delay": 0
                },
                {
                    "audio": null, "len": 8*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showCibSelfieFolder, "min_team_power": 15
                },
                {
                    "audio": Convo6, "len": 30*GameSound.MSEC_PER_SEC, "delay": 0,
                    "endfn": this.startBoss, "ends_with_popup": false, "min_team_power": 20
                },
                {
                    "audio": null, "len": 1*GameSound.MSEC_PER_SEC,
                    "delay": 0, "boss_gate": true
                },
                {
                    "audio": null, "len": 10*GameSound.MSEC_PER_SEC, "endfn": playEndDialogue
                }
            ];
        }

        override public function create():void {
            this.filename = "data/ikuturso_path.txt";
            this.graph_filename = "data/ikuturso_graph.txt";
            this.mapTilePrefix = "ikuturso";
            this.tileGridDimensions = new DHPoint(10, 5);
            this.estTileDimensions = new DHPoint(1359, 818);
            this.playerStartPos = new DHPoint(4600, 7565);
            this.colliderScaleFactor = 8.65;
            this.enemyDirMultiplier = 1;
            this.maxTeamPower = 20;

            super.create();
            function _bgmCallback():void {
                SoundManager.getInstance().playSound(ITBGMLoop, 0, null, true, .08, GameSound.BGM, IkuTurso.BGM, false, false);
            }
            SoundManager.getInstance().playSound(ITBGMIntro, 3.6*GameSound.MSEC_PER_SEC, _bgmCallback, false, .08, Math.random()*928+298, IkuTurso.BGM, false, false, true);
            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {
                GlobalTimer.getInstance().setMark("First Convo", GameState.SHORT_DIALOGUE ? 1 : 7*GameSound.MSEC_PER_SEC, this.bulldogHellPopup);
            }
            this.convo1Sound = null;
        }

        public function bulldogHellPopup():void {
            var that:IkuTurso = this;
            this.doIfMinTeamPower(function():void {
                PopUpManager.getInstance().sendPopup(PopUpManager.BULLDOG_HELL);
                GlobalTimer.getInstance().setMark("First Emote", 5*GameSound.MSEC_PER_SEC, that.ichiStartEmote);
                that.addEventListener(GameState.EVENT_POPUP_CLOSED,
                        function(event:DataEvent):void {
                            if(event.userData['tag'] == PopUpManager.BULLDOG_HELL) {
                                that.playRUComing();
                            }
                            FlxG.stage.removeEventListener(GameState.EVENT_POPUP_CLOSED,
                                                           arguments.callee);
                    });
            }, 1);
        }

        public function ichiStartEmote():void {
            if(pathWalker.inViewOfPlayer()) {
                PopUpManager.getInstance().emote(new FlxRect(0,0), this.pathWalker, true, Emote.HAPPY);
            } else {
                GlobalTimer.getInstance().setMark("First Emote", 3*GameSound.MSEC_PER_SEC, this.ichiStartEmote, true);
            }
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

        public function showSelfiesWindow():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.SELFIES_1);
        }

        public function showGuilEmail():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.GUIL_1);
        }

        public function showIchiDownloadWindow():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.ICHI_PICLY_1);
        }

        public function showIchiSelfie1():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.ICHI_SELFIE1);
        }

        public function showCibSelfieFolder():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.CIB_SELFIE_FOLDER);
        }

        public function playEndDialogue():void {
            SoundManager.getInstance().playSound(
                IchiBossKill, 3*GameSound.MSEC_PER_SEC, this.playEndFilm,
                false, 1, GameSound.VOCAL);
        }

        public function playEndFilm():void {
            this.fadeOut(
                function():void {
                    SoundManager.getInstance().playSound(VidBGMLoop, 0, null,
                        false, 1, GameSound.BGM);
                    FlxG.switchState(
                        new PlayVideoState("/../assets/video/sexy_selfie.flv",
                            function():void {
                                PopUpManager.GAME_ACTIVE = false;
                                FlxG.switchState(new BlankScreen(
                                    4*GameSound.MSEC_PER_SEC,
                                    function():void {
                                        FlxG.switchState(new TextScreen(5*GameSound.MSEC_PER_SEC,
                                        function():void {
                                            FlxG.switchState(new EuryaleDesktop());
                                        }, "April 13th, 2009"
                                        ));
                                    }
                                ));
                            }, SoundManager.getInstance().getSoundByName(BGM)
                        )
                    );
                },
                1 * GameSound.MSEC_PER_SEC
            );
        }

        override public function playTimedEmotes(convoNum:Number):void {
            if(convoNum == 1) {
                GlobalTimer.getInstance().setMark("2nd Convo Emote", 13*GameSound.MSEC_PER_SEC, this.ichiMadEmote);
            }
            if(convoNum == 2) {
                GlobalTimer.getInstance().setMark("3rd Convo Emote", 9*GameSound.MSEC_PER_SEC, this.ichiSadEmote);
            }
            if(convoNum == 3) {
                GlobalTimer.getInstance().setMark("4th Convo Emote", 22*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
            if(convoNum == 4) {
                GlobalTimer.getInstance().setMark("5th Convo Emote", 7*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
            if(convoNum == 5) {
                GlobalTimer.getInstance().setMark("6th Convo Emote", 14*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
        }

        public function playRUComing():void {
            SoundManager.getInstance().playSound(
                SndRUComing, GameSound.MSEC_PER_SEC * 3, this.playYeahSorry,
                false, 1, GameSound.VOCAL
            );
        }

        public function playYeahSorry():void {
            SoundManager.getInstance().playSound(
                SndYeahSorry, GameSound.MSEC_PER_SEC * 2, this.playFirstConvo,
                false, 1, GameSound.VOCAL
            );
        }

        override public function update():void{
            super.update();
            var snd:GameSound = SoundManager.getInstance().getSoundByName(Hallway.BGM);
            if(snd != null) {
                snd.fadeOutSound();
                snd.fading = true;
            }
        }
    }
}
