package{
    import org.flixel.*;

    public class IkuTurso extends LevelMapState {
        [Embed(source="../assets/ikuturso_wip.mp3")] private var ITBGMLoop:Class;
        public var bossHasAppeared:Boolean;

        public function IkuTurso() {
            this.bossHasAppeared = false;
        }

        override public function create():void {
            this.filename = "ikuturso_path.txt";

            super.create();
            SoundManager.getInstance().playSound(ITBGMLoop, 0, null, true,
                                                 .08, GameSound.BGM);

            GlobalTimer.getInstance().setMark(Fern.BOSS_MARK, 319632 - 60 * 1000);

            debugText = new FlxText(0,0,100,"");
            debugText.color = 0xff000000;
            add(debugText);
        }

        override public function update():void{
            super.update();
            this.boss.update();

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
