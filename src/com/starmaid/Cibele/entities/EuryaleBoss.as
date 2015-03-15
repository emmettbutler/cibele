package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;

    import org.flixel.*;

    public class EuryaleBoss extends BossEnemy {
        [Embed(source="/../assets/images/characters/boss1.png")] private var ImgBoss:Class;

        public function EuryaleBoss(pos:DHPoint) {
            super(pos);
            loadGraphic(ImgBoss, false, false, 5613/11, 600);

            addAnimation("run_boss", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1], 12, true);
            play("run_boss");

        }

        override public function update():void{
            super.update();
        }
    }
}