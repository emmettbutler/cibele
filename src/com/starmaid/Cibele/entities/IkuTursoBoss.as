package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.states.LevelMapState;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;

    import org.flixel.*;

    public class IkuTursoBoss extends BossEnemy {
        [Embed(source="/../assets/images/characters/boss1.png")] private var ImgBoss:Class;

        private var tentacles:Array;
        private const NUM_TENTACLES:Number = 6;

        public function IkuTursoBoss(pos:DHPoint) {
            super(pos);
            GlobalTimer.getInstance().setMark(
                "tentacle", 3*GameSound.MSEC_PER_SEC, this.addTentacles
            );
        }

        override public function setupSprites():void {
            this.loadGraphic(ImgBoss, false, false, 5613/11, 600);
            this.addAnimation("run",
                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1],
                12, true);
            this.play("run");

            this.tentacles = new Array();
            var tentacle:IkuTursoBossTentacle;
            for (var i:int = 0; i < NUM_TENTACLES; i++) {
                tentacle = new IkuTursoBossTentacle(this.pos)
                this.tentacles.push(tentacle);
            }

            super.setupSprites();
        }

        override public function addVisibleObjects():void {
            for (var i:int = 0; i < this.tentacles.length; i++) {
                FlxG.state.add(this.tentacles[i]);
                FlxG.state.add(this.tentacles[i].debugText);
            }
        }

        override public function update():void{
            super.update();
        }

        public function getAvailableTentacle():IkuTursoBossTentacle {
            for (var i:int = 0; i < this.tentacles.length; i++) {
                if (this.tentacles[i]._state == STATE_NULL) {
                    return this.tentacles[i];
                }
            }
            return null;
        }

        public function addTentacle():void {
            var tentacle:IkuTursoBossTentacle;
            tentacle = this.getAvailableTentacle();
            if (tentacle != null) {
                tentacle.appear();
                tentacle.setPos(this.footPos.add(new DHPoint(
                    Math.random()*500-250,
                    Math.random()*100-75 - tentacle.height
                )));
            }
        }

        public function addTentacles():void {
            if (!FlxG.state is LevelMapState) {
                return;
            }
            var rand:Number = Math.random()*1000000;
            for (var i:int = 0; i < Math.random()*NUM_TENTACLES; i++) {
                GlobalTimer.getInstance().setMark(
                    "tentacle_sprouts_" + rand.toString() + "_" + i.toString(),
                    Math.random()*1*GameSound.MSEC_PER_SEC,
                    this.addTentacle
                );
            }

            GlobalTimer.getInstance().setMark(
                "tentacle_" + new Date().valueOf(),
                (Math.random()*10+3)*GameSound.MSEC_PER_SEC,
                this.addTentacles
            );
        }
    }
}
