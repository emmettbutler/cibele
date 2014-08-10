package {
    import org.flixel.*;

    public class PartyMember extends GameObject {
        public static const STATE_IN_ATTACK:Number = 1;

        public var dir:DHPoint;
        public var lastAttackTime:Number = 0;
        public var footsteps:FootstepTrail = null;
        public var footstepOffset:DHPoint;

        public function PartyMember(pos:DHPoint) {
            super(pos);
            this.dir = new DHPoint(0, 0);
        }

        public function initFootsteps():void {
            this.footsteps = new FootstepTrail(this);
        }

        override public function update():void {
            super.update();
            if (this.footsteps != null) {
                this.footsteps.update();
            }
            this.setPos(this.pos.add(this.dir));
        }

        public function isAttacking():Boolean{
            return this._state == STATE_IN_ATTACK;
        }

        public function attack():void {
            if (this.canAttack()) {
                this._state = STATE_IN_ATTACK;
                this.lastAttackTime = this.currentTime;
            }
        }

        public function timeSinceLastAttack():Number {
            return this.currentTime - this.lastAttackTime;
        }

        public function canAttack():Boolean {
            return this.timeSinceLastAttack() > 2*MSEC_PER_SEC;
        }
    }
}
