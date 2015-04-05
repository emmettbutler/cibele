package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;

    import org.flixel.*;

    public class BossEnemy extends Enemy {
        public function BossEnemy(pos:DHPoint) {
            super(pos);
            this._enemyType = Enemy.TYPE_BOSS;
            this.hitPoints = 600;
            this.sightRange = 750;
            this.hitDamage = .5;
            this.recoilPower = 0;

            this.use_active_highlighter = false;
            this.alpha = 0;

            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.boss.getStateString", "boss.state");
        }

        public function addVisibleObjects():void {}

        override public function update():void{
            super.update();

            if(this.dead) {
                this.die();
            } else if (this.hitPoints < 10) {
                this.hitPoints = 200;
            } else if(!this.dead && this.alpha < 1 && this.bossHasAppeared) {
                this.alpha += .01;
            }
        }

        override public function startTracking():void {
            this._state = STATE_TRACKING;
        }

        override public function die():void {
            if(this.alpha > 0) {
                this.alpha -= .01;
            } else {
                this.alpha = 0;
            }
        }
    }
}
