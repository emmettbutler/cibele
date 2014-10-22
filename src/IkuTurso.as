package{
    import org.flixel.*;

    import flash.events.*;

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

        public var bossHasAppeared:Boolean;
        private var convo1Sound:GameSound;
        private var convo1Ready:Boolean;

        private var conversationPieces:Array;
        private var conversationCounter:Number = 0;

        public static var BGM:String = "ikuturso bgm loop";

        public function IkuTurso() {
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
                    "endfn": this.showForumWindow
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
            SoundManager.getInstance().playSound(ITBGMIntro, 3.6*GameSound.MSEC_PER_SEC, _bgmCallback, false, .08, Math.random()*928+298, IkuTurso.BGM);
            GlobalTimer.getInstance().setMark(Fern.BOSS_MARK, 319632 - 60 * 1000);
            this.convo1Sound = null;
        }

        public function showSelfiesWindow():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.SELFIES_1);
        }

        public function showForumWindow():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.FORUM_1);
        }

        public function showIchiDownloadWindow():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.ICHI_DOWNLOAD);
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
                    function():void {
                        SoundManager.getInstance().playSound(
                            nextAudioInfo["audio"], nextAudioInfo["len"],
                            that.playNextConvoPiece, false, 1, GameSound.VOCAL
                        );
                        FlxG.stage.removeEventListener(GameState.EVENT_POPUP_CLOSED,
                                                       arguments.callee);
                    });
            } else {
                SoundManager.getInstance().playSound(VidBGMLoop, 0, null,
                    false, 1, GameSound.BGM);
                FlxG.switchState(
                    new PlayVideoState("../assets/sexy_selfie.flv",
                        function():void { FlxG.switchState(new StartScreen()); }, SoundManager.getInstance().getSoundByName(BGM)
                    )
                );
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

        override public function update():void{
            super.update();
            if(SoundManager.getInstance().getSoundByName(HallwayToFern.BGM) != null) {
                SoundManager.getInstance().getSoundByName(HallwayToFern.BGM).fadeOutSound();
            }

            this.boss.update();
            if (this.convo1Sound == null) {
                if (!SoundManager.getInstance().soundOfTypeIsPlaying(GameSound.VOCAL))
                {
                    this.playFirstConvo();
                }
            }

            if (GlobalTimer.getInstance().hasPassed(Fern.BOSS_MARK) &&
                !this.bossHasAppeared && FlxG.state.ID == LevelMapState.LEVEL_ID)
            {
                this.bossHasAppeared = true;
                this.boss.hasAppeared = true;
                this.boss.warpToPlayer();
                this.boss.visible = true;
            }
        }
    }
}
