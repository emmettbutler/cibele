package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;
    import com.starmaid.Cibele.management.SoundManager;

    import org.flixel.*;

    public class EuryaleBoss extends BossEnemy {
        [Embed(source="/../assets/images/characters/boss2.png")] private var ImgBoss:Class;
        [Embed(source="/../assets/audio/effects/mask_boss.mp3")] private var SndCall:Class;

        public function EuryaleBoss(pos:DHPoint) {
            this.notificationTextColor = 0xff7c6e6a;
            this._name = "SAMPSA";
            super(pos);
            loadGraphic(ImgBoss, false, false, 632, 800);

            addAnimation("run_boss",
                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 10, 9, 8, 7, 6, 5, 4, 3,
                 2, 1, 0], 12, true);
            play("run_boss");

        }

        override protected function playCallSound():void {
            super.playCallSound();
            SoundManager.getInstance().playSound(
                SndCall, 3 * GameSound.MSEC_PER_SEC, null, false, .6
            );
        }
    }
}
