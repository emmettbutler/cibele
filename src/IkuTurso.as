package{
    import org.flixel.*;

    public class IkuTurso extends LevelMapState {
        public var runningSound:GameSound;
        public var bossHasAppeared:Boolean;

        public function IkuTurso(runningSound:GameSound=null) {
            this.runningSound = runningSound;
            this.bossHasAppeared = false;
        }

        override public function create():void {
            this.filename = "ikuturso_path.txt";

            super.create();

            debugText = new FlxText(0,0,100,"");
            debugText.color = 0xff000000;
            add(debugText);
        }

        override public function update():void{
            super.update();
            MessageManager.getInstance().update();
            this.boss.update();

            if (this.runningSound != null && this.runningSound.timeRemaining < 40*1000 &&
                !this.bossHasAppeared && FlxG.state.ID == LevelMapState.LEVEL_ID)
            {
                this.bossHasAppeared = true;
                this.boss.warpToPlayer();
                this.boss.visible = true;
            }
        }
    }
}
