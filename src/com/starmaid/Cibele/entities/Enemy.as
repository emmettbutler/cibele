package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.states.LevelMapState;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class Enemy extends GameObject {
        protected static const TYPE_SMALL:String = "enemy";
        protected static const TYPE_BOSS:String = "boss";
        protected var _enemyType:String = TYPE_SMALL;

        private static const MARK_RESPAWN:String = "mrespawn";
        public static const PARTICLE_SMOKE:Number = 2458720394857;

        protected var hitPoints:Number,
                      hitDamage:Number = 10,
                      recoilPower:Number = 3,
                      sightRange:Number = 308,
                      maxHitPoints:Number,
                      recoilTrackingThreshold:Number = 120;
        protected var pathFollowerRef:PathFollower;
        protected var playerRef:Player;
        protected var disp:DHPoint;
        protected var _healthBar:HealthBar;
        protected var closestPartyMemberDisp:DHPoint;
        protected var takeDamageEventSlug:String;
        protected var partyMemberTrackingOffset:DHPoint;
        protected var partyMemberTrackingRadius:Number = 200;
        private var closestPartyMember:PartyMember;
        private var originalPos:DHPoint;
        protected var damageLockMap:Dictionary;
        protected var smoke:ParticleExplosion;
        public var footPos:DHPoint, footPosOffset:DHPoint, basePosOffset:DHPoint;
        protected var lastTrackingDirUpdateTime:Number = -1;
        protected var flipFacing:Boolean = false;

        public static const STATE_IDLE:Number = 1;
        public static const STATE_TRACKING:Number = 3;
        public static const STATE_RECOIL:Number = 4;
        public static const STATE_DEAD:Number = 7;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_IDLE] = "STATE_IDLE";
            stateMap[STATE_TRACKING] = "STATE_TRACKING";
            stateMap[STATE_RECOIL] = "STATE_RECOIL";
            stateMap[STATE_DEAD] = "STATE_DEAD";
        }

        public function Enemy(pos:DHPoint, hitPoints:Number=100) {
            super(pos);

            this.slug = "enemy_" + Math.random() * 100000;
            this.hitPoints = hitPoints;
            this.originalPos = pos;
            this.maxHitPoints = this.hitPoints;
            this._state = STATE_IDLE;
            this.footPos = new DHPoint(0, 0);
            this.disp = new DHPoint(0, 0);
            this.zSorted = true;
            this.basePos = new DHPoint(this.x, this.y + this.height);
            this.takeDamageEventSlug = "damaged" + (Math.random() * 100000000);
            this.damageLockMap = new Dictionary();
            var angle:Number = Math.random() * (Math.PI * 2);
            this.partyMemberTrackingOffset = new DHPoint(
                this.partyMemberTrackingRadius * Math.cos(angle),
                this.partyMemberTrackingRadius * Math.sin(angle));

            this.setupSprites();
            this.setupSmoke();
            this.inactiveTarget();

            // this stuff should be before setupSprites, but it relies on width
            // and height. thus, these null checks are necessary to avoid
            // clobbering subclass settings
            if (this.footPosOffset == null) {
                this.footPosOffset = new DHPoint(this.width / 2, this.height);
            }
            if (this.basePosOffset == null) {
                this.basePosOffset = new DHPoint(0, this.height);
            }
            this.loopCallSound();
        }

        public function isDead():Boolean {
            return this._state == STATE_DEAD;
        }

        public function get healthBar():HealthBar {
            return this._healthBar;
        }

        public function addVisibleObjects():void {
            this._healthBar.addVisibleObjects();
            if (ScreenManager.getInstance().DEBUG) {
                FlxG.state.add(this.debugText);
            }
        }

        public function setupSprites():void {
            this.visible = true;
            this._healthBar = new HealthBar(new DHPoint(pos.x, pos.y),
                                            this.hitPoints);
        }

        protected function setupSmoke():void {
            this.smoke = new ParticleExplosion(7, Enemy.PARTICLE_SMOKE, 3, .8,
                                               7, 5, .3, this, 4);
            this.smoke.addVisibleObjects();
        }

        public function get enemyType():String {
            return this._enemyType;
        }

        public function targetable():Boolean {
            return !this.isDead();
        }

        public function isBoss():Boolean {
            if(this.enemyType == TYPE_BOSS) {
                return true;
            } else {
                return false;
            }
        }

        public function isSmall():Boolean {
            if(this.enemyType == TYPE_SMALL) {
                return true;
            } else {
                return false;
            }
        }

        public function get smallType():String {
            return Enemy.TYPE_SMALL;
        }

        public function getStateString():String {
            return Enemy.stateMap[this._state] == null ? "unknown" : Enemy.stateMap[this._state];
        }

        public function startTracking():void {
            this._state = STATE_TRACKING;
            this.visible = false;
        }

        public function setPlayerRef(p:Player):void{
            this.playerRef = p;
        }

        public function setFollowerRef(f:PathFollower):void {
            this.pathFollowerRef = f;
        }

        public function takeDamage(p:PartyMember):void{
            if (this.isDead()) {
                return;
            }
            if (this.damageLockMap[p.slug] == true) {
                return;
            }
            this.damageLockMap[p.slug] = true;
            GlobalTimer.getInstance().setMark(this.takeDamageEventSlug + p.slug,
                                              1 * GameSound.MSEC_PER_SEC,
                                              function():void {
                                                if(!(FlxG.state is LevelMapState)) {
                                                    return;
                                                }
                                                damageLockMap[p.slug] = false;
                                              }, true);
            this._state = STATE_RECOIL;
            if (this.closestPartyMemberDisp != null) {
                this.dir = this.closestPartyMemberDisp.normalized().mulScl(this.recoilPower).reflectX();
            }
            this.hitPoints -= Math.floor(this.hitDamage * p.teamPowerDamageMul);
            this._healthBar.setPoints(this.hitPoints);
            p.runParticles(this.getMiddlePos().sub(new DHPoint(0, this.height/3)));
            if(this.hitPoints <= 0){
                this.die(p);
            }
        }

        public function activeTarget():void {
            if (this._healthBar == null || this.isDead()) {
                return;
            }
            this._healthBar.setVisible(true);
        }

        public function inactiveTarget():void {
            if (this._healthBar == null) {
                return;
            }
            this._healthBar.setVisible(false);
        }

        override public function destroy():void {
            this.smoke.destroy();
            this._healthBar.destroy();
            super.destroy();
        }

        public function die(p:PartyMember):void {
            /*
             * :param p: The PartyMember instance that hit this enemy for lethal
             *      damage
             */
            if (this._state == STATE_DEAD) {
                return;
            }
            // don't destroy() or state.remove() here. doing so breaks z-sorting
            this.visible = true;
            this._healthBar.setVisible(false);
            this._state = STATE_DEAD;
            this.dir = new DHPoint(0,0);
            this.inactiveTarget();
            this.smoke.run(this.getMiddlePos());
            FlxG.stage.dispatchEvent(
                new DataEvent(GameState.EVENT_ENEMY_DIED,
                              {'damaged_by': p}));
            GlobalTimer.getInstance().setMark(
                MARK_RESPAWN + Math.random() * 200,
                20 * GameSound.MSEC_PER_SEC, this.respawn, true
            );
        }

        public function respawn():void {
            if (!(FlxG.state is LevelMapState)) {
                return;
            }
            this.setPos(originalPos);
            if(!this.inViewOfPlayer()) {
                this.hitPoints = this.maxHitPoints;
                this._healthBar.setPoints(this.hitPoints);
                this.visible = true;
                this.alpha = 1;
                this._state = STATE_IDLE;
            } else {
                GlobalTimer.getInstance().setMark(
                    MARK_RESPAWN + Math.random() * 200,
                    10 * GameSound.MSEC_PER_SEC, this.respawn, true
                );
            }
        }

        public function getAttackPos():DHPoint {
            return this.footPos;
        }

        public function inViewOfPlayer():Boolean {
            return this.isOnscreen();
        }

        public function getClosestPartyMember():PartyMember {
            var playerDisp:DHPoint = this.playerRef.pos.sub(this.getAttackPos());
            var followerDisp:DHPoint = this.pathFollowerRef.pos.sub(this.getAttackPos());
            if (playerDisp._length() > followerDisp._length()) {
                return this.pathFollowerRef;
            }
            return this.playerRef;
        }

        public function setAuxPositions():void {
            this.footPos.x = this.x + this.footPosOffset.x;
            this.footPos.y = this.y + this.footPosOffset.y;
            this.basePos.y = this.y + this.basePosOffset.y;

            this._healthBar.setPos(new DHPoint(this.x + (this.width * .5),
                                               this.pos.y - 30));
        }

        public function closestPartyMemberIsInTrackingRange():Boolean {
            return this.closestPartyMemberDisp._length() < this.sightRange;
        }

        public function closestPartyMemberIsAboveRecoilTrackingThreshold():Boolean {
            return this.closestPartyMemberDisp._length() > this.recoilTrackingThreshold;
        }

        override public function toggleActive():void {
            this.active = this.isOnscreen();
        }

        public function doState__IDLE():void {
            this.dir = ZERO_POINT;
            if (this.closestPartyMemberIsInTrackingRange()) {
                this.startTracking();
            }
        }

        public function doState__TRACKING():void {
            if (this.timeAlive - this.lastTrackingDirUpdateTime > 1300) {
                this.lastTrackingDirUpdateTime = this.timeAlive;
                var mul:Number = (FlxG.state as LevelMapState).enemyDirMultiplier;
                if (mul != 1) {
                    this.dir = this.closestPartyMemberDisp.normalized().mulScl(mul);
                } else {
                    this.dir = this.closestPartyMemberDisp.normalized();
                }
            }
            if (!this.closestPartyMemberIsInTrackingRange()) {
                this.enterIdleState();
            }
        }

        public function enterIdleState():void {
            this._state = STATE_IDLE;
            this.visible = true;
        }

        private function loopCallSound():void {
            if (!(FlxG.state is LevelMapState)) {
                return;
            }
            if (this.canPlayCall()) {
                this.playCallSound();
            }
            var that:Enemy = this;
            GlobalTimer.getInstance().setMark(
                "enemy_call_" + this.slug,
                (5 + (Math.random() * 2)) * GameSound.MSEC_PER_SEC,
                function():void {
                    if (!(FlxG.state is LevelMapState)) {
                        return;
                    }
                    that.loopCallSound();
                },
                true
            );
        }

        protected function canPlayCall():Boolean {
            return this.isOnscreen() && this._state == STATE_TRACKING;
        }

        protected function playCallSound():void {
        }

        override public function update():void{
            super.update();

            if (ScreenManager.getInstance().DEBUG) {
                this.debugText.text = this.getStateString();
            }

            if (this._state == STATE_DEAD && this.visible == false) {
                return;
            }

            this.closestPartyMember = this.getClosestPartyMember();
            this.closestPartyMemberDisp = this.closestPartyMember.footPos
                .add(this.partyMemberTrackingOffset).sub(this.getAttackPos());
            this.hitPoints = Math.max(0, this.hitPoints);
            this.setAuxPositions();

            if (this.smoke != null) {
                this.smoke.update();
            }

            this.scale.x = (this.dir.x >= 0 ? 1 : -1) * (this.flipFacing ? -1 : 1);

            switch(this._state) {
                case STATE_IDLE:
                    this.doState__IDLE();
                    break;

                case STATE_TRACKING:
                    this.doState__TRACKING();
                    break;

                case STATE_RECOIL:
                    if (this.closestPartyMemberIsAboveRecoilTrackingThreshold()
                        && this.closestPartyMemberIsInTrackingRange())
                    {
                        this.startTracking();
                    }
                    break;

                case STATE_DEAD:
                    if(this.alpha > 0) {
                        this.alpha -= .03;
                    } else {
                        this.visible = false;
                    }
                    break;
            }
        }
    }
}
