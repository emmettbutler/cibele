package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    public class ParticleExplosion {
        private var pos:DHPoint;
        private var particleCount:Number, particleSpeed:Number;
        private var particles:Array;
        private var lifespan:Number;
        private var particleGravity:DHPoint;
        private var particleBaseScale:Number;
        private var particleShrinkFactor:Number;
        private var particleShrinkRateFrames:Number;

        public function ParticleExplosion(
            particleCount:Number=25,
            particleType:Number=2,
            lifespanSec:Number=2,
            particleShrinkFactor:Number=.6,
            particleShrinkRateFrames:Number=15,
            particleSpeed:Number=13,
            particleBaseScale:Number=.7)
        {
            this.particleCount = particleCount;
            this.particleSpeed = particleSpeed;
            this.particles = new Array();
            this.lifespan = lifespanSec * GameSound.MSEC_PER_SEC;
            this.particleGravity = new DHPoint(0, 0);
            this.particleShrinkFactor = particleShrinkFactor;
            this.particleShrinkRateFrames = particleShrinkRateFrames;
            this.particleBaseScale = particleBaseScale;

            var curPart:Particle, speedMul:Number;
            for (var i:int = 0; i < this.particleCount; i++) {
                curPart = new Particle(particleType,
                                       this.lifespan,
                                       this.particleShrinkFactor,
                                       this.particleShrinkRateFrames,
                                       this.particleBaseScale);
                this.particles.push(curPart);
            }
        }

        public function set gravity(g:DHPoint):void {
            this.particleGravity.x = g.x;
            this.particleGravity.y = g.y;
        }

        public function addVisibleObjects():void {
            for (var i:int = 0; i < this.particleCount; i++) {
                FlxG.state.add(this.particles[i]);
            }
        }

        public function run(pos:DHPoint):void {
            this.pos = pos;
            var speedMul:Number, angle:Number = 2;
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
                        this.particleGravity
                    );
                    this.particles[i].angle += 4;
                }
            }
        }
    }
}
