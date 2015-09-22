package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    public class Particle extends GameObject {
        [Embed(source="/../assets/images/misc/cibele_particle_1.png")] private var ImgCibParticle1:Class;
        [Embed(source="/../assets/images/misc/ichi_particle_1.png")] private var ImgIchiParticle1:Class;
        [Embed(source="/../assets/images/misc/Enemy_Smoke_01.png")] private var ImgSmoke1:Class;
        [Embed(source="/../assets/images/misc/Enemy_Smoke_02.png")] private var ImgSmoke2:Class;

        private var lifespan:Number, shrinkFactor:Number, shrinkRateFrames:Number;
        private var framesAlive:Number, baseScale:Number;
        public var parent:GameObject;

        public function Particle(t:Number,
                                 lifespan:Number,
                                 shrinkFactor:Number=.6,
                                 shrinkRateFrames=12,
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
                partImage:Class, partDim:DHPoint = new DHPoint(20, 40);
            switch (t) {
                case PartyMember.PARTICLE_ICHI:
                    partImage = ImgIchiParticle1;
                    break;
                case PartyMember.PARTICLE_CIBELE:
                    partImage = ImgCibParticle1;
                    break;
                case Enemy.PARTICLE_SMOKE:
                    if (randParticle == 0) {
                        partImage = ImgSmoke1;
                        partDim = new DHPoint(246, 238);
                    } else {
                        partImage = ImgSmoke2;
                        partDim = new DHPoint(246, 238);
                    }
                    break;
            }
            this.loadGraphic(partImage, false, false, partDim.x, partDim.y);
            if(t == PartyMember.PARTICLE_ICHI || t == PartyMember.PARTICLE_CIBELE) {
                this.addAnimation("play", [0,1,2,3,4,5,6,7], 12, true);
                this.play("play");
            }
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
            if (this.parent != null) {
                this.basePos = this.parent.basePos;
                this.basePos.y += 1;
            }
            if (this.framesAlive % this.shrinkRateFrames == 0) {
                this.scale.x *= this.shrinkFactor;
                this.scale.y *= this.shrinkFactor;
            }
        }
    }
}
