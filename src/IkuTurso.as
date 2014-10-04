package{
    import org.flixel.*;

    public class IkuTurso extends LevelMapState {
        [Embed(source="../assets/ikuturso_wip.mp3")] private var ITBGMLoop:Class;
        [Embed(source="../assets/sexyselfie_wip.mp3")] private var VidBGMLoop:Class;
        [Embed(source="../assets/voc_ikuturso_bulldog.mp3")] private var Convo1:Class;
        [Embed(source="../assets/voc_ikuturso_photogenic.mp3")] private var Convo2:Class;
        [Embed(source="../assets/voc_ikuturso_attractive.mp3")] private var Convo3:Class;
        [Embed(source="../assets/voc_ikuturso_picture.mp3")] private var Convo4:Class;
        [Embed(source="../assets/voc_ikuturso_whattowear.mp3")] private var Convo5:Class;

        public var bossHasAppeared:Boolean;
        private var convo1Sound:GameSound;
        private var convo1Ready:Boolean;

        private var conversationPieces:Array;
        private var conversationCounter:Number = 1;

        public function IkuTurso() {
            this.bossHasAppeared = false;

            // embedded sound, length in ms, time to wait before playing
            this.conversationPieces = [
                {"audio": Convo1, "len": 132*GameSound.MSEC_PER_SEC, "delay": 0, "endfn": this.showSelfiesWindow},
                {"audio": Convo2, "len": 25*GameSound.MSEC_PER_SEC, "delay": 20*GameSound.MSEC_PER_SEC, "endfn": this.showForumWindow},
                {"audio": Convo3, "len": 107*GameSound.MSEC_PER_SEC, "delay": 20*GameSound.MSEC_PER_SEC, "endfn": null},
                {"audio": Convo4, "len": 15*GameSound.MSEC_PER_SEC, "delay": 20*GameSound.MSEC_PER_SEC, "endfn": null},
                {"audio": Convo5, "len": 30*GameSound.MSEC_PER_SEC, "delay": 20*GameSound.MSEC_PER_SEC, "endfn": null}
            ];
        }

        override public function create():void {
            this.filename = "ikuturso_path.txt";
            super.create();
            SoundManager.getInstance().playSound(ITBGMLoop, 0, null, true,
                                                 .08, GameSound.BGM);
            GlobalTimer.getInstance().setMark(Fern.BOSS_MARK, 319632 - 60 * 1000);
            this.convo1Sound = null;
        }

        public function showSelfiesWindow():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.SELFIES_1);
        }

        public function showForumWindow():void {
            PopUpManager.getInstance().sendPopup(PopUpManager.FORUM_1);
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
                GlobalTimer.getInstance().setMark(
                    Math.random().toString(),
                    nextAudioInfo["delay"],
                    function():void {
                        SoundManager.getInstance().playSound(
                            nextAudioInfo["audio"], nextAudioInfo["len"],
                            that.playNextConvoPiece, false, 1, GameSound.VOCAL
                        );
                    });
            } else {
                SoundManager.getInstance().playSound(VidBGMLoop, 0, null,
                    true, .2, GameSound.BGM);
                FlxG.switchState(
                    new PlayVideoState("../assets/selfie.flv",
                        function():void { FlxG.switchState(new StartScreen()); }
                    )
                );
            }
        }

        public function playFirstConvo():void {
            this.conversationCounter = 0;
            var sndInfo:Object = this.conversationPieces[0];
            this.convo1Sound = SoundManager.getInstance().playSound(
                sndInfo["audio"], sndInfo["len"], this.playNextConvoPiece,
                false, 1, GameSound.VOCAL
            );
        }

        override public function update():void{
            super.update();
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
                this.boss.warpToPlayer();
                this.boss.visible = true;
            }
        }
    }
}
