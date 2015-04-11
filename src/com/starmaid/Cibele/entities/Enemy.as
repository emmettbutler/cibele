package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class Enemy extends GameObject {
        protected static const TYPE_SMALL:String = "enemy";
        protected static const TYPE_BOSS:String = "boss";
        protected var _enemyType:String = TYPE_SMALL;

        protected var hitPoints:Number = 100,
                      hitDamage:Number = 3,
                      recoilPower:Number = 3,
                      sightRange:Number = 308,
                      recoilTrackingThreshold:Number = 120;
        protected var pathFollowerRef:PathFollower;
        protected var playerRef:Player;
        protected var disp:DHPoint;
        protected var bar:GameObject;
        protected var closestPartyMemberDisp:DHPoint;
        private var closestPartyMember:PartyMember;
        private var originalPos:DHPoint;
        public var footPos:DHPoint;

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

        public function Enemy(pos:DHPoint) {
            super(pos);

            this.originalPos = pos;
            this._state = STATE_IDLE;
            this.footPos = new DHPoint(0, 0);
            this.disp = new DHPoint(0, 0);
            this.zSorted = true;
            this.basePos = new DHPoint(this.x, this.y + this.height);

            this.setupSprites();
        }

        public function isDead():Boolean {
            return this._state == STATE_DEAD;
        }

        public function get healthBar():GameObject {
            return this.bar;
        }

        public function setupSprites():void {
            this.visible = true;

            this.bar = new GameObject(new DHPoint(pos.x,pos.y));
            this.bar.makeGraphic(1,8,0xffe2678e);
            this.bar.scale.x = this.hitPoints;
        }

        public function get enemyType():String {
            return this._enemyType;
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
            this._state = STATE_RECOIL;
            this.dir = this.closestPartyMemberDisp.normalized().mulScl(this.recoilPower).reflectX();
            this.hitPoints -= this.hitDamage;
            this.bar.scale.x = this.hitPoints;
        }

        public function activeTarget():void {
            if (this.bar == null) {
                return;
            }
            this.bar.visible = true;
        }

        public function inactiveTarget():void {
            if (this.bar == null) {
                return;
            }
            this.bar.visible = false;
        }

        public function die():void {
            if (this._state == STATE_DEAD) {
                return;
            }
            // don't destroy() or state.remove() here. doing so breaks z-sorting
            this.visible = false;
            this.bar.visible = false;
            this._state = STATE_DEAD;
            this.dir = new DHPoint(0,0);
            GlobalTimer.getInstance().setMark("respawn timer" + Math.random()*200, 30*GameSound.MSEC_PER_SEC, this.respawn, true);
        }

        public function respawn():void {
            if(!this.inViewOfPlayer()) {
                this.hitPoints = 100;
                this.visible = true;
                this._state = STATE_IDLE;
                this.x = originalPos.x;
                this.y = originalPos.y;
            } else {
                GlobalTimer.getInstance().setMark("respawn timer" + Math.random()*200, 10*GameSound.MSEC_PER_SEC, this.respawn, true);
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
            this.footPos.x = this.x + this.width/2;
            this.footPos.y = this.y + this.height;
            this.basePos.y = this.y + this.height;

            this.bar.x = this.x + (this.width * .5);
            this.bar.y = this.pos.y-30;
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

        override public function update():void{
            super.update();

            if (this._state == STATE_DEAD) {
                return;
            }

            this.closestPartyMember = this.getClosestPartyMember();
            this.closestPartyMemberDisp = this.closestPartyMember.footPos.sub(this.getAttackPos());
            // TODO - cap hitPoints at some reasonable value
            this.hitPoints = Math.max(0, this.hitPoints);
            this.setAuxPositions();
            if(this.hitPoints == 0){
                this.die();
            }

            switch(this._state) {
                case STATE_IDLE:
                    this.doState__IDLE();
                    break;

                case STATE_TRACKING:
                    this.dir = this.closestPartyMemberDisp.normalized();
                    if (!this.closestPartyMemberIsInTrackingRange()) {
                        this._state = STATE_IDLE;
                    }
                    break;

                case STATE_RECOIL:
                    if (this.closestPartyMemberIsAboveRecoilTrackingThreshold()
                        && this.closestPartyMemberIsInTrackingRange())
                    {
                        this.startTracking();
                    }
                    break;
            }
        }
    }
}
