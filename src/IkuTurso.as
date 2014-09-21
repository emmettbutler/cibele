package{
    import org.flixel.*;

    public class IkuTurso extends LevelMapState {
        [Embed(source="../assets/ikuturso_wip.mp3")] private var ITBGMLoop:Class;
        [Embed(source="../assets/voc_ikuturso_bulldog.mp3")] private var Convo1:Class;

        public var bossHasAppeared:Boolean;
        private var convo1Sound:GameSound;
        private var convo1Ready:Boolean;

        public function IkuTurso() {
            this.bossHasAppeared = false;
        }

        override public function create():void {
            this.filename = "ikuturso_path.txt";
            super.create();
            SoundManager.getInstance().playSound(ITBGMLoop, 0, null, true,
                                                 .08, GameSound.BGM);
            GlobalTimer.getInstance().setMark(Fern.BOSS_MARK, 319632 - 60 * 1000);
            this.convo1Sound = null;
        }

        public function playFirstConvo():void {
            this.convo1Sound = SoundManager.getInstance().playSound(
                Convo1, 132000, null, false, 1, GameSound.VOCAL
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
