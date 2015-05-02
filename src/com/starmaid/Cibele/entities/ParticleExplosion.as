package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    public class ParticleExplosion {
        private var pos:DHPoint;
        private var particleCount:Number, particleSpeed:Number;
        private var particles:Array;
        private var lifespan:Number;

        public function ParticleExplosion(
            pos:DHPoint,
            particleCount:Number=25,
            particleType:Number=PartyMember.PARTICLE_ICHI)
        {
            this.pos = pos;
            this.particleCount = particleCount;
            this.particleSpeed = 15;
            this.particles = new Array();
            this.lifespan = 2 * GameSound.MSEC_PER_SEC;

            var curPart:Particle, speedMul:Number;
            for (var angle:Number = 0;
                 angle < Math.PI * 2;
                 angle += (Math.PI * 2) / this.particleCount)
            {
                curPart = new Particle(this.pos, particleType, this.lifespan);
                speedMul = Math.random() * .5;
                curPart.dir = new DHPoint(
                    Math.cos(angle) * (this.particleSpeed * speedMul),
                    Math.sin(angle) * (this.particleSpeed * speedMul)
                );
                this.particles.push(curPart);
            }
        }

        public function update():void {
            for(var i:int = 0; i < this.particles.length; i++) {
                this.particles[i].dir = this.particles[i].dir.add(
                    new DHPoint(0, .25)
                );
            }
        }
    }
}
