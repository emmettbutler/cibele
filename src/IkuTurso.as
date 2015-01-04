package{
    import org.flixel.*;

    public class IkuTurso extends LevelMapState {
        [Embed(source="../assets/bgm_ikuturso_intro.mp3")] private var ITBGMIntro:Class;
        [Embed(source="../assets/bgm_ikuturso_loop.mp3")] private var ITBGMLoop:Class;
        [Embed(source="../assets/vid_sexyselfie.mp3")] private var VidBGMLoop:Class;
        [Embed(source="../assets/voc_ikuturso_bulldog.mp3")] private var Convo1:Class;
        [Embed(source="../assets/voc_ikuturso_ampule.mp3")] private var Convo2:Class;
        [Embed(source="../assets/voc_ikuturso_photogenic.mp3")] private var Convo3:Class;
        [Embed(source="../assets/voc_ikuturso_attractive.mp3")] private var Convo4:Class;
        [Embed(source="../assets/voc_ikuturso_picture.mp3")] private var Convo5:Class;
        [Embed(source="../assets/voc_ikuturso_whattowear.mp3")] private var Convo6:Class;
        [Embed(source="../assets/voc_extra_ichilasthit.mp3")] private var IchiBossKill:Class;
        [Embed(source="../assets/voc_extra_yeahsorry.mp3")] private var SndYeahSorry:Class;
        [Embed(source="../assets/voc_extra_areyoucoming.mp3")] private var SndRUComing:Class;

        public var bossHasAppeared:Boolean;
        private var convo1Sound:GameSound;
        private var convo1Ready:Boolean;

        private var conversationPieces:Array;
        private var conversationCounter:Number = 0;

        public static var BGM:String = "ikuturso bgm loop";
        public static const BOSS_MARK:String = "boss_iku_turso";

        public function IkuTurso() {
            PopUpManager.GAME_ACTIVE = true;
            this.bossHasAppeared = false;
            this.ui_color_flag = GameState.UICOLOR_PINK;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {
                    "audio": Convo1, "len": 56*GameSound.MSEC_PER_SEC,
                    "delay": 0, "endfn": this.showIchiDownloadWindow
                },
                {
                    "audio": Convo2, "len": 76*GameSound.MSEC_PER_SEC,
                    "delay": 20*GameSound.MSEC_PER_SEC,
                    "endfn": this.showSelfiesWindow
                },
                {
                    "audio": Convo3, "len": 25*GameSound.MSEC_PER_SEC,
                    "delay": 20*GameSound.MSEC_PER_SEC,
                    "endfn": this.showGuilEmail
                },
                {
                    "audio": Convo4, "len": 107*GameSound.MSEC_PER_SEC,
                    "delay": 20*GameSound.MSEC_PER_SEC,
                    "endfn": this.showIchiSelfie1
                },
                {
                    "audio": Convo5, "len": 15*GameSound.MSEC_PER_SEC,
                    "delay": 20*GameSound.MSEC_PER_SEC,
                    "endfn": this.showCibSelfieFolder
                },
                {
                    "audio": Convo6, "len": 30*GameSound.MSEC_PER_SEC,
                    "delay": 20*GameSound.MSEC_PER_SEC, "endfn": null
                }
            ];
        }

        override public function create():void {
            this.filename = "ikuturso_path.txt";
            super.create();
            function _bgmCallback():void {
                SoundManager.getInstance().playSound(ITBGMLoop, 0, null, true, .08, GameSound.BGM, IkuTurso.BGM, false, false);
            }
            SoundManager.getInstance().playSound(ITBGMIntro, 3.6*GameSound.MSEC_PER_SEC, _bgmCallback, false, .08, Math.random()*928+298, IkuTurso.BGM, false, false, true);
            if(!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL)) {
                GlobalTimer.getInstance().setMark("First Convo", 2*GameSound.MSEC_PER_SEC, this.bulldogHellPopup);
            }
            this.convo1Sound = null;
        }

        public function bulldogHellPopup():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.BULLDOG_HELL);
            GlobalTimer.getInstance().setMark("First Emote", 5*GameSound.MSEC_PER_SEC, this.ichiStartEmote);
            var that:IkuTurso = this;
            this.addEventListener(GameState.EVENT_POPUP_CLOSED,
                    function(event:DataEvent):void {
                        if(event.userData['tag'] == PopUpManager.BULLDOG_HELL) {
                            that.playRUComing();
                        }
                        FlxG.stage.removeEventListener(GameState.EVENT_POPUP_CLOSED,
                                                       arguments.callee);
                    });
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
            GlobalTimer.getInstance().setMark(BOSS_MARK, 50*GameSound.MSEC_PER_SEC);
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

        public function playNextConvoPiece():void {
            var thisAudioInfo:Object = this.conversationPieces[this.conversationCounter];
            if (thisAudioInfo["endfn"] != null) {
                thisAudioInfo["endfn"]();
            }
            this.conversationCounter += 1;
            var that:IkuTurso = this;
            var nextAudioInfo:Object = this.conversationPieces[this.conversationCounter];
            if (nextAudioInfo != null) {
                this.addEventListener(GameState.EVENT_POPUP_CLOSED,
                    function(event:DataEvent):void {
                        SoundManager.getInstance().playSound(
                            nextAudioInfo["audio"], nextAudioInfo["len"],
                            that.playNextConvoPiece, false, 1, GameSound.VOCAL
                        );
                        that.playTimedEmotes(that.conversationCounter);
                        if(that.conversationPieces.length == that.conversationCounter + 1) {
                            that.last_convo_playing = true;
                        }
                        FlxG.stage.removeEventListener(GameState.EVENT_POPUP_CLOSED,
                                                       arguments.callee);
                    });
            } else {
                GlobalTimer.getInstance().setMark("Boss Kill", 5*GameSound.MSEC_PER_SEC, this.ichiBossKill);
            }
        }

        public function ichiBossKill():void {
            //TODO play no other bit dialogue during this time
            SoundManager.getInstance().playSound(
                IchiBossKill, 3*GameSound.MSEC_PER_SEC, this.playEndFilm,
                false, 1, GameSound.VOCAL
            );
            if(this.boss != null) {
                this.boss.dead = true;
            }
        }

        public function playEndFilm():void {
            SoundManager.getInstance().playSound(VidBGMLoop, 0, null,
                    false, 1, GameSound.BGM);
                FlxG.switchState(
                    new PlayVideoState("../assets/sexy_selfie.flv",
                        function():void {
                            FlxG.switchState(new StartScreen());
                            PopUpManager.GAME_ACTIVE = false;
                        }, SoundManager.getInstance().getSoundByName(BGM)
                    )
                );
        }

        public function playTimedEmotes(convoNum:Number):void {
            if(convoNum == 1) {
                GlobalTimer.getInstance().setMark("2nd Convo Emote", 11*GameSound.MSEC_PER_SEC, this.ichiMadEmote);
            }
            if(convoNum == 2) {
                GlobalTimer.getInstance().setMark("3rd Convo Emote", 7*GameSound.MSEC_PER_SEC, this.ichiSadEmote);
            }
            if(convoNum == 3) {
                GlobalTimer.getInstance().setMark("4th Convo Emote", 20*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
            if(convoNum == 4) {
                GlobalTimer.getInstance().setMark("5th Convo Emote", 5*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
            if(convoNum == 5) {
                GlobalTimer.getInstance().setMark("6th Convo Emote", 12*GameSound.MSEC_PER_SEC, this.ichiHappyEmote);
            }
        }

        public function playFirstConvo():void {
            this.conversationCounter = 0;
            var sndInfo:Object = this.conversationPieces[this.conversationCounter];
            this.convo1Sound = SoundManager.getInstance().playSound(
                sndInfo["audio"], sndInfo["len"], this.playNextConvoPiece,
                false, 1, GameSound.VOCAL
            );
            this.bitDialogueLock = false;
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
            var snd:GameSound = SoundManager.getInstance().getSoundByName(HallwayToFern.BGM);
            if(snd != null) {
                snd.fadeOutSound();
                snd.fading = true;
            }

            this.boss.update();

            if (GlobalTimer.getInstance().hasPassed(BOSS_MARK) &&
                !this.bossHasAppeared && FlxG.state.ID == LevelMapState.LEVEL_ID)
            {
                this.bossHasAppeared = true;
                this.boss.bossHasAppeared = true;
                this.boss.warpToPlayer();
                this.boss.visible = true;
            }
        }
    }
}
