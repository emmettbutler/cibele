package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class TeamPowerParticle extends ExpiringGameObject {
        [Embed(source="/../assets/images/misc/ichi_particle_2.png")] private var ImgParticleRed:Class;
        [Embed(source="/../assets/images/misc/cibele_particle_2.png")] private var ImgParticleBlue:Class;

        public static const RED:Number = 1;
        public static const BLUE:Number = 2;

        public function TeamPowerParticle(type:Number) {
            super();

            if(type == RED) {
                this.loadGraphic(ImgParticleRed, false, false, 10, 10);
            } else if(type == BLUE) {
                this.loadGraphic(ImgParticleBlue, false, false, 10, 10);
            }
            this.scrollFactor = new DHPoint(0, 0);
        }
    }
}
