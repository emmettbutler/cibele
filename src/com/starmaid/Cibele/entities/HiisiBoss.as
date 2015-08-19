package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.states.LevelMapState;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;
    import com.starmaid.Cibele.management.SoundManager;

    import org.flixel.*;

    public class HiisiBoss extends BossEnemy {
        [Embed(source="/../assets/images/characters/boss3.png")] private var ImgBoss:Class;
        [Embed(source="/../assets/audio/effects/medusa_boss.mp3")] private var SndCall:Class;

        private var tentacles:Array;

        public function HiisiBoss(pos:DHPoint) {
            super(pos);
        }

        override public function setupSprites():void {
            this.loadGraphic(ImgBoss, false, false, 404, 400);
            this.addAnimation("run",
                [0, 1, 2, 3, 4, 5], 12, true);
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
