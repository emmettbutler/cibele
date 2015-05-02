package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class Particle extends GameObject {
        private var lifespan:Number;

        public function Particle(pos:DHPoint, t:Number) {
            super(pos);
            var rand:Number = Math.random() * 3;
            var col:uint = 0;
            switch (t) {
                case PartyMember.PARTICLE_ICHI:
                    col = 0xffff0000;
                    break;
                case PartyMember.PARTICLE_CIBELE:
                    col = 0xff0000ff;
                    break;
            }
            this.buildDefaultSprite(new DHPoint(3 + rand, 3 + rand), col);
            this.lifespan = .5 * GameSound.MSEC_PER_SEC;
            (FlxG.state as GameState).add(this);
        }

        override public function update():void {
            super.update();

            if (this.timeAlive > this.lifespan) {
                FlxG.state.remove(this);
            }
        }
    }
}
