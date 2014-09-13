package {
    import org.flixel.*;

    public class PartyMember extends GameObject {
        public static const STATE_IN_ATTACK:Number = 1;
        public static const STATE_MOVE_TO_ENEMY:Number = 34987651333;
        public static const STATE_AT_ENEMY:Number = 91823419673;

        public var lastAttackTime:Number = 0;
        public var footsteps:FootstepTrail = null;
        public var footstepOffset:DHPoint;
        public var attackRange:Number = 150;

        public function PartyMember(pos:DHPoint) {
            super(pos);
        }

        public function initFootsteps():void {
            this.footsteps = new FootstepTrail(this);
        }

        override public function update():void {
            super.update();
            if (this.footsteps != null) {
                this.footsteps.update();
            }
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

        public function enemyIsInAttackRange(en:Enemy):Boolean {
            if (en == null) { return false; }
            return en.pos.sub(this.pos)._length() < this.attackRange;
        }

        public function enemyIsInMoveTowardsRange(en:Enemy):Boolean{
            if (en == null) { return false; }
            return en.pos.sub(this.pos)._length() < 280;
        }

        public function resolveStatePostAttack():void {}
    }
}
