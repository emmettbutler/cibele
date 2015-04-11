package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;

    import org.flixel.*;

    public class BossEnemy extends Enemy {
        public var bossHasAppeared:Boolean = false;

        public function BossEnemy(pos:DHPoint) {
            super(pos);
            this._enemyType = Enemy.TYPE_BOSS;
            this.hitPoints = 600;
            this.sightRange = 750;
            this.hitDamage = .5;
            this.recoilPower = 0;

            this.alpha = 0;

            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.boss.getStateString", "boss.state");
        }

        public function addVisibleObjects():void {}

        override public function toggleActive():void {
            if (!this.active) {
                this.active = true;
            }
        }

        override public function update():void{
            super.update();

            if (this.hitPoints < 10) {
                this.hitPoints = 200;
            } else if(this._state != STATE_DEAD && this.alpha < 1 && this.bossHasAppeared) {
                this.alpha += .01;
            }
        }

        override public function startTracking():void {
            this._state = STATE_TRACKING;
        }

        public function bossFollowPlayer():void {
            if(!this.inViewOfPlayer() && this.bossHasAppeared) {
                this.warpToPlayer();
            }
        }

        override public function doState__IDLE():void {
            this.dir = ZERO_POINT;
            this.bossFollowPlayer();
            if (this.closestPartyMemberIsInTrackingRange()) {
                this.startTracking();
            }
        }

        override public function die():void {
            this._state = STATE_DEAD;
            if(this.alpha > 0) {
                this.alpha -= .01;
            } else {
                this.alpha = 0;
            }
        }
    }
}
