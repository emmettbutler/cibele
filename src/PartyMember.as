package {
    import org.flixel.*;

    public class PartyMember extends GameObject {
        [Embed(source="../assets/feet.png")] private var ImgFeet:Class;
        public static const STATE_IN_ATTACK:Number = 1;

        public var lastAttackTime:Number = 0;
        public var footstepGroup:FlxGroup;

        public function PartyMember(pos:DHPoint) {
            super(pos);
        }

        override public function update():void {
            super.update();
            //var footstep:FlxSprite = new FlxSprite(pos.x, pos.y);
            //footstep.loadGraphic(ImgFeet,false,false,17,12)
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
