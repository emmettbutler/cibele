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
            particleCount:Number=25,
            particleType:Number=2)
        {
            this.particleCount = particleCount;
            this.particleSpeed = 13;
            this.particles = new Array();
            this.lifespan = 2 * GameSound.MSEC_PER_SEC;

            var curPart:Particle, speedMul:Number;
            for (var i:int = 0; i < this.particleCount; i++) {
                curPart = new Particle(particleType, this.lifespan);
                this.particles.push(curPart);
            }
        }

        public function addVisibleObjects():void {
            for (var i:int = 0; i < this.particleCount; i++) {
                FlxG.state.add(this.particles[i]);
            }
        }

        public function run(pos:DHPoint):void {
            this.pos = pos;
            var speedMul:Number, angle:Number = 0;
            for(var i:int = 0; i < this.particles.length; i++) {
                this.particles[i].makeAlive();
                this.particles[i].setPos(this.pos);
                speedMul = Math.random() * .5;
                this.particles[i].dir = new DHPoint(
                    Math.cos(angle) * (this.particleSpeed * speedMul),
                    Math.sin(angle) * (this.particleSpeed * speedMul)
                );
                angle += (Math.PI * 2) / this.particleCount;
            }
        }

        public function update():void {
            for(var i:int = 0; i < this.particles.length; i++) {
                if (this.particles[i].active) {
                    this.particles[i].dir = this.particles[i].dir.add(
                        new DHPoint(0, .25)
                    );
                }
            }
        }
    }
}
