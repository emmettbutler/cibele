package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class TeamPowerParticleTrail extends FadingTrail {
        private var _partyMember:PartyMember;

        public function TeamPowerParticleTrail(tar:GameObject, pm:PartyMember) {
            this._partyMember = pm;
            this.interval = 40;
            super(tar);
        }

        override public function setupSprites():void {
            var spr:TeamPowerParticle;
            for (var i:int = 0; i < this.count; i++) {
                if(this._partyMember is Player) {
                    spr = new TeamPowerParticle(TeamPowerParticle.BLUE);
                } else {
                    spr = new TeamPowerParticle(TeamPowerParticle.RED);
                }
                this.sprites.push(spr);
            }
        }
    }
}
