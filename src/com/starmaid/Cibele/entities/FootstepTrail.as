package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class FootstepTrail extends FadingTrail {
        public function FootstepTrail(tar:PartyMember) {
            super(tar);
        }

        override public function setupSprites():void {
            var spr:Footstep;
            for (var i:int = 0; i < this.count; i++) {
                if(this.target_ is Player) {
                    spr = new Footstep(Footstep.BLUE);
                } else {
                    spr = new Footstep(Footstep.PURPLE);
                }
                this.sprites.push(spr);
            }
        }

        override public function getNextPos():DHPoint {
            return this.target_.pos.add((this.target_ as PartyMember).footstepOffset);
        }
    }
}
