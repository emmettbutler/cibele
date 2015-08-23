package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    public class TeamPowerParticle extends ExpiringGameObject {
        [Embed(source="/../assets/images/misc/ichi_team.png")] private var ImgParticleRed:Class;
        [Embed(source="/../assets/images/misc/cibele_team.png")] private var ImgParticleBlue:Class;

        public static const RED:Number = 1;
        public static const BLUE:Number = 2;

        public function TeamPowerParticle(type:Number) {
            super();
            this.fadeFrames = 100;
            if(type == RED) {
                this.loadGraphic(ImgParticleRed, true, false, 30, 50);
            } else if(type == BLUE) {
                this.loadGraphic(ImgParticleBlue, true, false, 30, 50);
            }
            this.addAnimation("play", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14], 12, true);
            this.play("play");
            this.scrollFactor = new DHPoint(0, 0);
        }
    }
}
