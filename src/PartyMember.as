package {
    import org.flixel.*;

    public class PartyMember extends GameObject {
        public static const STATE_IN_ATTACK:Number = 1;

        public function PartyMember(pos:DHPoint) {
            super(pos);
        }

        public function isAttacking():Boolean{
            return this._state == STATE_IN_ATTACK;
        }
    }
}
