package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class Particle extends GameObject {
        [Embed(source="/../assets/images/misc/cibele_particle_1.png")] private var ImgCibParticle1:Class;
        [Embed(source="/../assets/images/misc/cibele_particle_2.png")] private var ImgCibParticle2:Class;
        [Embed(source="/../assets/images/misc/ichi_particle_1.png")] private var ImgIchiParticle1:Class;
        [Embed(source="/../assets/images/misc/ichi_particle_2.png")] private var ImgIchiParticle2:Class;
        [Embed(source="/../assets/images/misc/Enemy_Smoke_01.png")] private var ImgSmoke1:Class;
        [Embed(source="/../assets/images/misc/Enemy_Smoke_02.png")] private var ImgSmoke2:Class;

        private var lifespan:Number, shrinkFactor:Number, shrinkRateFrames:Number;
        private var framesAlive:Number, baseScale:Number;

        public function Particle(t:Number,
                                 lifespan:Number,
                                 shrinkFactor:Number=.6,
                                 shrinkRateFrames=15,
                                 baseScale=.7)
        {
            super(new DHPoint(0, 0));
            this.framesAlive = 0;
            this.slug = "particle" + (Math.random() * 1000000);
            this.lifespan = lifespan;
            this.shrinkFactor = shrinkFactor;
            this.shrinkRateFrames = shrinkRateFrames;
            this.baseScale = baseScale;
            this.zSorted = true;
            var randParticle:Number = Math.floor(Math.random() * 2),
                partImage:Class, partDim:DHPoint = new DHPoint(10, 10);
            switch (t) {
                case PartyMember.PARTICLE_ICHI:
                    if (randParticle == 0) {
                        partImage = ImgIchiParticle1;
                    } else {
                        partImage = ImgIchiParticle2;
                    }
                    break;
                case PartyMember.PARTICLE_CIBELE:
                    if (randParticle == 0) {
                        partImage = ImgCibParticle1;
                    } else {
                        partImage = ImgCibParticle2;
                    }
                    break;
                case Enemy.PARTICLE_SMOKE:
                    if (randParticle == 0) {
                        partImage = ImgSmoke1;
                        partDim = new DHPoint(246, 238);
                    } else {
                        partImage = ImgSmoke1;
                        partDim = new DHPoint(246, 238);
                    }
                    break;
            }
            this.loadGraphic(partImage, false, false, partDim.x, partDim.y);
            this.zSorted = false;
            this.visible = false;
            this.active = false;
        }

        public function makeAlive():void {
            this.visible = true;
            this.active = true;
            this.framesAlive = 0;
            var rand:Number = Math.random() * .3;
            this.scale.x = this.baseScale + rand;
            this.scale.y = this.baseScale + rand;
            GlobalTimer.getInstance().setMark(this.slug, this.lifespan,
                                              function():void {
                                                visible = false;
                                                active = false;
                                              }, true);
        }

        override public function update():void {
            super.update();
            this.framesAlive++;
            this.basePos = this.pos;
            if (this.framesAlive % this.shrinkRateFrames == 0) {
                this.scale.x *= this.shrinkFactor;
                this.scale.y *= this.shrinkFactor;
            }
        }
    }
}
