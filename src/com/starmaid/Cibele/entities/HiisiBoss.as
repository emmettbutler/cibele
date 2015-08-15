package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.states.LevelMapState;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;
    import com.starmaid.Cibele.management.SoundManager;

    import org.flixel.*;

    public class HiisiBoss extends BossEnemy {
        [Embed(source="/../assets/images/characters/boss1.png")] private var ImgBoss:Class;
        [Embed(source="/../assets/audio/effects/medusa_boss.mp3")] private var SndCall:Class;

        private var tentacles:Array;
        private const NUM_TENTACLES:Number = 6;

        public function HiisiBoss(pos:DHPoint) {
            super(pos);
        }

        override public function setupSprites():void {
            this.loadGraphic(ImgBoss, false, false, 5613/11, 600);
            this.addAnimation("run",
                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1],
                12, true);
            this.play("run");

            super.setupSprites();
        }

        override protected function playCallSound():void {
            super.playCallSound();
            SoundManager.getInstance().playSound(
                SndCall, 3 * GameSound.MSEC_PER_SEC, null, false, .6
            );
        }
    }
}
