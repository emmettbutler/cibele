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

        private var lifespan:Number;

        public function Particle(t:Number, lifespan:Number) {
            super(new DHPoint(0, 0));
            this.slug = "particle" + (Math.random() * 1000000);
            this.lifespan = lifespan;
            var randParticle:Number = Math.floor(Math.random() * 2),
                partImage:Class;
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
            }
            this.loadGraphic(partImage, false, false, 10, 10);
            this.visible = false;
            this.active = false;
        }

        public function makeAlive():void {
            this.visible = true;
            this.active = true;
            var rand:Number = Math.random();
            this.scale.x = .2 + rand;
            this.scale.y = .2 + rand;
            GlobalTimer.getInstance().setMark(this.slug, this.lifespan,
                                              function():void {
                                                visible = false;
                                                active = false;
                                              }, true);
        }

        override public function update():void {
            super.update();

            if (Math.floor(this.timeAlive) % 20 == 0) {
                this.scale.x *= .3;
                this.scale.y *= .3;
            }
        }
    }
}
