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
        public var footPos:DHPoint;

        public var tag:String;
        public static const cib:String = "cibelelele";
        public static const ichi:String = "ichichichi";

        public function PartyMember(pos:DHPoint) {
            super(pos);
            this.nameText = new FlxText(pos.x, pos.y, 500, "My Name");
            this.nameText.setFormat("NexaBold-Regular",16,0xff616161,"left");
            this.footPos = new DHPoint(0, 0);
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

            this.footPos.x = this.x + this.width/2;
            this.footPos.y = this.y + this.height;
        }

        public function isAttacking():Boolean{
            return this._state == STATE_IN_ATTACK;
        }

        public function directionToObj(obj:DHPoint):DHPoint {
            return obj.sub(this.pos);
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
            var disp:Number = en.pos.center(en, true).sub(this.footPos)._length();
            if (this.attackRange == 50) {
                FlxG.log("disp: " + disp + "\nrange: " + this.attackRange + "\n" + new Date().valueOf());
            }
            return disp < this.attackRange;
        }

        public function enemyIsInMoveTowardsRange(en:Enemy):Boolean{
            if (en == null) { return false; }
            return en.pos.sub(this.pos)._length() < 280;
        }

        public function resolveStatePostAttack():void {}
    }
}
