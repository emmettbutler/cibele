package {
    import org.flixel.*;

    public class PartyMember extends GameObject {
        [Embed(source="../assets/Nexa Bold.otf", fontFamily="NexaBold-Regular", embedAsCFF="false")] public var GameFont:String;

        public static const STATE_IN_ATTACK:Number = 1;
        public static const STATE_MOVE_TO_ENEMY:Number = 34987651333;
        public static const STATE_AT_ENEMY:Number = 91823419673;

        public var lastAttackTime:Number = 0;
        public var footsteps:FootstepTrail = null;
        public var footstepOffset:DHPoint;
        public var attackRange:Number = 50;
        public var nameText:FlxText;
        public var text_facing:String = "up";

        public function PartyMember(pos:DHPoint) {
            super(pos);
            this.nameText = new FlxText(pos.x, pos.y, 500, "My Name");
            this.nameText.setFormat("NexaBold-Regular",16,0xff000000,"left");
        }

        public function initFootsteps():void {
            this.footsteps = new FootstepTrail(this);
        }

        public function addVisibleObjects():void { }

        override public function update():void {
            super.update();
            if (this.footsteps != null) {
                this.footsteps.update();
            }

            if(this.text_facing == "up" || this.text_facing == "down"){
                this.nameText.x = this.pos.x+50;
            } else if(this.text_facing == "left") {
                this.nameText.x = this.pos.x+75;
            } else if(this.text_facing == "right") {
                this.nameText.x = this.pos.x+20;
            }

            this.nameText.y = this.pos.y-30;
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
            return en.pos.center(en, true).sub(this.pos.center(this, true))._length() < this.attackRange;
        }

        public function enemyIsInMoveTowardsRange(en:Enemy):Boolean{
            if (en == null) { return false; }
            return en.pos.sub(this.pos)._length() < 280;
        }

        public function resolveStatePostAttack():void {}
    }
}
