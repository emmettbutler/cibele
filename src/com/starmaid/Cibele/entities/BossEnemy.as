package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.management.DebugConsoleManager;

    import org.flixel.*;

    public class BossEnemy extends Enemy {
        public var bossHasAppeared:Boolean = false;

        public static const STATE_ESCAPE:Number = 5948573;
        public static const STATE_MOVE_TO_PATH_NODE:Number = 693857487;

        {
            stateMap[STATE_ESCAPE] = "STATE_ESCAPE";
            stateMap[STATE_MOVE_TO_PATH_NODE] = "STATE_MOVE_TO_PATH_NODE";
        }

        public function BossEnemy(pos:DHPoint) {
            super(pos);
            this._enemyType = Enemy.TYPE_BOSS;
            this.hitPoints = 600;
            this.sightRange = 750;
            this.hitDamage = .5;
            this.recoilPower = 0;

            this.alpha = 0;

            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.boss.getStateString", "boss.state");
        }

        public function addVisibleObjects():void {}

        override public function toggleActive():void {
            if (!this.active) {
                this.active = true;
            }
        }

        override public function update():void{
            super.update();

            if (this.hitPoints < 10) {
                this.hitPoints = 200;
            } else if(this._state != STATE_DEAD && this.alpha < 1 && this.bossHasAppeared) {
                this.alpha += .01;
            }

            switch(this._state) {
                case STATE_ESCAPE:
                    if(this.targetPathNode == null) {
                        this._path.setCurrentNode(_path.getClosestNode(this.footPos));
                        this._state = STATE_MOVE_TO_PATH_NODE;
                    } else {
                        disp = this.targetPathNode.pos.sub(this.footPos);
                        if (disp._length() < 10) {
                            this._state = STATE_MOVE_TO_PATH_NODE;
                        } else {
                            this.dir = disp.normalized().mulScl(1.5);
                        }
                    }
                    break;

                case STATE_MOVE_TO_PATH_NODE:
                    this.escape_counter += 1;
                    this._path.advance();
                    this.targetPathNode = this._path.currentNode;
                    if(this.escape_counter <= 10) {
                        this._state = STATE_ESCAPE;
                    } else {
                        this.startTracking();
                        this.escape_counter = 0;
                    }
                    break;
            }
        }

        override public function startTracking():void {
            this._state = STATE_TRACKING;
        }

        public function bossFollowPlayer():void {
            if(!this.inViewOfPlayer() && this.bossHasAppeared) {
                this.warpToPlayer();
            }
        }

        public function warpToPlayer():void {
            var targetPoint:DHPoint = this.playerRef.pos.add(this.playerRef.dir.normalized().mulScl(1000));
            var warpNode:MapNode = this._mapnodes.getClosestNode(targetPoint);
            var headFootDisp:DHPoint = this.pos.sub(this.footPos);
            this.setPos(warpNode.pos.add(headFootDisp));
            this.startTracking();
        }

        override public function takeDamage(p:PartyMember):void{
            this.hitPoints -= this.hitDamage;
            this.bar.scale.x = this.hitPoints;
            if (!this.isEscaping()) {
                if(this.hitPoints % 100 == 0) {
                    this._state = STATE_ESCAPE;
                } else {
                    this._state = STATE_RECOIL;
                    this.dir = this.closestPartyMemberDisp.normalized().mulScl(this.recoilPower).reflectX();
                }
            }
        }

        private function isEscaping():Boolean {
            return this._state == STATE_MOVE_TO_PATH_NODE || this._state == STATE_ESCAPE;
        }

        override public function doState__IDLE():void {
            this.dir = ZERO_POINT;
            this.bossFollowPlayer();
            if (this.closestPartyMemberIsInTrackingRange()) {
                this.startTracking();
            }
        }

        override public function die():void {
            this._state = STATE_DEAD;
            if(this.alpha > 0) {
                this.alpha -= .01;
            } else {
                this.alpha = 0;
            }
        }
    }
}
