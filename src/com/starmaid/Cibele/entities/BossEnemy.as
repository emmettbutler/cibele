package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;

    import org.flixel.*;

    public class BossEnemy extends Enemy {
        private var debug_hasWarpedToPlayer:Boolean = false,
                    debug_testBoss:Boolean = false;

        public function BossEnemy(pos:DHPoint) {
            super(pos);
            enemyType = "boss";
            hitpoints = 600;
            sightRange = 750;
            damage = .5;
            use_active_highlighter = false;
            this.canEscape = true;
            //this.attackOffset = new DHPoint(-200, -1 * (this.height / 3));
            this.attackOffset = new DHPoint(0,0);
            this.recoilPower = 0;
            this.alpha = 0;
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.boss.getStateString", "boss.state");
        }

        public function addVisibleObjects():void {}

        override public function update():void{
            super.update();

            if (debug_testBoss && !debug_hasWarpedToPlayer) {
                debug_hasWarpedToPlayer = true;
                warpToPlayer();
                visible = true;
                this.alpha = 1;
            }

            if(this.dead) {
                this.die();
            } else if (this.hitpoints < 10) {
                this.hitpoints = 200;
            } else if(!this.dead && this.alpha < 1 && this.bossHasAppeared) {
                this.alpha += .01;
            }
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
