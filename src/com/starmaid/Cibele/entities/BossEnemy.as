package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;

    import org.flixel.*;

    public class BossEnemy extends Enemy {
        [Embed(source="/../assets/images/characters/boss1.png")] private var ImgBoss:Class;

        private var debug_hasWarpedToPlayer:Boolean = false,
                    debug_testBoss:Boolean = false;
        private var tentacles:Array;

        private const NUM_TENTACLES:Number = 6;

        public function BossEnemy(pos:DHPoint) {
            super(pos);
            loadGraphic(ImgBoss, false, false, 5613/11, 600);
            enemyType = "boss";
            hitpoints = 600;
            sightRange = 750;
            damage = .5;
            use_active_highlighter = false;
            this.canEscape = true;
            //this.attackOffset = new DHPoint(-200, -1 * (this.height / 3));
            this.attackOffset = new DHPoint(0,0);
            this.recoilPower = 0;
            this.alpha = 0;
            this.tentacles = new Array();

            addAnimation("run_boss", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1], 12, true);
            play("run_boss");

            var tentacle:IkuTursoBossTentacle;
            for (var i:int = 0; i < NUM_TENTACLES; i++) {
                tentacle = new IkuTursoBossTentacle(this.pos)
                this.tentacles.push(tentacle);
            }

            GlobalTimer.getInstance().setMark(
                "tentacle", 3*GameSound.MSEC_PER_SEC, this.addTentacles
            );

            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.boss.getStateString", "boss.state");
        }

        public function addVisibleObjects():void {
            for (var i:int = 0; i < this.tentacles.length; i++) {
                FlxG.state.add(this.tentacles[i]);
                FlxG.state.add(this.tentacles[i].debugText);
            }
        }

        override public function update():void{
            super.update();

            if (debug_testBoss && !debug_hasWarpedToPlayer) {
                debug_hasWarpedToPlayer = true;
                warpToPlayer();
                visible = true;
                this.alpha = 1;
            }

            if(this.dead) {
                this.die();
            } else if (this.hitpoints < 10) {
                this.hitpoints = 200;
            } else if(!this.dead && this.alpha < 1 && this.bossHasAppeared) {
                this.alpha += .01;
            }
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

        override public function die():void {
            if(this.alpha > 0) {
                this.alpha -= .01;
            } else {
                this.alpha = 0;
            }
        }
    }
}
