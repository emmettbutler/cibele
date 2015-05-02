package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class ParticleExplosion {
        private var pos:DHPoint;
        private var particleCount:Number, particleSpeed:Number;
        private var particles:Array;

        public function ParticleExplosion(
            pos:DHPoint,
            particleCount:Number=25,
            particleType:Number=PartyMember.PARTICLE_ICHI)
        {
            this.pos = pos;
            this.particleCount = particleCount;
            this.particleSpeed = 13;
            this.particles = new Array();

            var curPart:Particle, speedMul:Number;
            for (var angle:Number = 0;
                 angle < Math.PI * 2;
                 angle += (Math.PI * 2) / this.particleCount)
            {
                curPart = new Particle(this.pos, particleType);
                speedMul = Math.random() * .5;
                curPart.dir = new DHPoint(
                    Math.cos(angle) * (this.particleSpeed * speedMul),
                    Math.sin(angle) * (this.particleSpeed * speedMul)
                );
                this.particles.push(curPart);
            }
        }
    }
}
