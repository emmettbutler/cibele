package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.management.DebugConsoleManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.utils.MapNodeContainer;
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.management.Path;

    import org.flixel.*;

    public class BossEnemy extends Enemy {
        [Embed(source="/../assets/audio/effects/sfx_die_big.mp3")] private var SfxBossDeath:Class;
        public var _mapnodes:MapNodeContainer;
        private var _path:Path = null;
        private var targetPathNode:PathNode;
        private var escape_counter:Number = 0;
        private var damagedByPartyMember:PartyMember;
        private var damageThreshold:Array;
        private var _spawnCounter:Number = 0;
        private var _started:Boolean = false;
        private var canDie:Boolean = false;
        private var _notificationText:FlxText;


        public static const STATE_PRE_APPEAR:Number = 39485723987;
        public static const STATE_ESCAPE:Number = 5948573;
        public static const STATE_MOVE_TO_PATH_NODE:Number = 693857487;
        public static const STATE_DESPAWN:Number = 01298308;
        public static const STATE_INACTIVE:Number = 109281029840348;

        {
            stateMap[STATE_PRE_APPEAR] = "STATE_PRE_APPEAR";
            stateMap[STATE_ESCAPE] = "STATE_ESCAPE";
            stateMap[STATE_MOVE_TO_PATH_NODE] = "STATE_MOVE_TO_PATH_NODE";
            stateMap[STATE_DESPAWN] = "STATE_DESPAWN";
            stateMap[STATE_INACTIVE] = "STATE_INACTIVE";
        }

        public function BossEnemy(pos:DHPoint) {
            super(pos, 600);
            this.damageThreshold = [500, 300, 200];
            this._enemyType = Enemy.TYPE_BOSS;
            this.sightRange = 750;
            this.hitDamage = 10;
            this.recoilPower = 0;

            this.alpha = 0;

            this._state = STATE_PRE_APPEAR;
            this.visible = false;

            this._notificationText = new FlxText(ScreenManager.getInstance().screenWidth * .15, ScreenManager.getInstance().screenHeight * .6, ScreenManager.getInstance().screenWidth, "");
            this._notificationText.setFormat("NexaBold-Regular", 24, 0xffe2678e, "left");
            this._notificationText.scrollFactor = new DHPoint(0,0);

            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.boss.getStateString", "boss.state");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.boss.pos", "boss.pos");
            DebugConsoleManager.getInstance().trackAttribute("FlxG.state.boss.footPos", "boss.footPos");
        }

        public function setPath(path:Path):void {
            this._path = path;
        }

        public function startDespawn():void {
            this._state = STATE_DESPAWN;
        }

        public function get started():Boolean {
            return _started;
        }

        public function get spawnCounter():Number {
            return this._spawnCounter;
        }

        public function set started(v:Boolean):void {
            this._started = v;
        }

        public function appear():void {
            this._started = true;
            this.footPosOffset = new DHPoint(this.width / 2, this.height);
            this.basePosOffset = new DHPoint(0, this.height);

            this._state = STATE_IDLE;
            this.visible = true;
            this._healthBar.setVisible(true);
            this.warpToPlayer();

            this._notificationText.text = "Boss has appeared!";
            this._notificationText.visible = true;
            GlobalTimer.getInstance().setMark("boss escape" + Math.random().toString(), 5*GameSound.MSEC_PER_SEC, this.hideNotificationText);
        }

        public function setActive():void {
            if(this._spawnCounter >= this.damageThreshold.length - 1) {
                this.canDie = true;
            }
            if (this._spawnCounter < this.damageThreshold.length) {
                this._spawnCounter += 1;
            }
            this.visible = true;
            this._healthBar.setVisible(true);
            this.warpToPlayer();

            this._notificationText.text = "Boss has appeared!";
            this.showNotificationText();
            GlobalTimer.getInstance().setMark("boss escape" + Math.random().toString(), 5*GameSound.MSEC_PER_SEC, this.hideNotificationText);
        }

        public function hasAppeared():Boolean {
            return this._state != STATE_PRE_APPEAR;
        }

        override public function toggleActive():void {
            if (!this.active) {
                this.active = true;
            }
        }

        override public function update():void{
            super.update();

            if(this.hitPoints > 0 && this._state != STATE_DEAD &&
               this.alpha < 1 && this.hasAppeared() &&
               this._state != STATE_INACTIVE &&
               this._state != STATE_DESPAWN)
            {
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
                    trace("esc" + Math.random().toString);
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
                    trace("move" + Math.random().toString);
                    break;

                case STATE_DEAD:
                    if(this.alpha > 0) {
                        this.alpha -= .01;
                    } else {
                        this.alpha = 0;
                    }
                    trace("dead" + Math.random().toString);
                    break;

                case STATE_DESPAWN:
                    if(this.targetPathNode == null) {
                        this._path.setCurrentNode(_path.getClosestNode(this.footPos));
                        this.targetPathNode = this._path.currentNode;
                    }
                    this.targetPathNode = this._path.currentNode;
                    disp = this.targetPathNode.pos.sub(this.footPos);
                    this._path.advance();
                    this.dir = disp.normalized().mulScl(10);
                    trace("despawn" + Math.random().toString());

                    if (!this.inViewOfPlayer()) {
                        this.setInactive();
                    }
                    break;
            }
        }

        public function setInactive():void {
            this._state = STATE_INACTIVE;
            this.visible = false;
            this._healthBar.setVisible(false);
            this._notificationText.text = "Boss has escaped!";
            this.showNotificationText();
            GlobalTimer.getInstance().setMark("boss escape" + Math.random().toString(), 5*GameSound.MSEC_PER_SEC, this.hideNotificationText);
        }

        public function hideNotificationText():void {
            this._notificationText.visible = false;
        }

        public function showNotificationText():void {
            this._notificationText.visible = true;
        }

        override public function startTracking():void {
            this._state = STATE_TRACKING;
        }

        public function bossFollowPlayer():void {
            if(!this.inViewOfPlayer() && this.hasAppeared()) {
                this.warpToPlayer();
            }
        }

        public function warpToPlayer():void {
            var dir:DHPoint = new DHPoint(this.playerRef.dir.x,
                                          this.playerRef.dir.y);
            if (dir.x == 0 && dir.y == 0) {
                dir.y = -1;
            }
            var targetPoint:DHPoint = this.playerRef.pos.add(
                dir.normalized().mulScl(ScreenManager.getInstance().screenWidth));
            var warpNode:MapNode = this._mapnodes.getClosestNode(targetPoint, false);
            var headFootDisp:DHPoint = this.pos.sub(this.footPos);
            this.setPos(warpNode.pos.add(headFootDisp));
            this.startTracking();
        }

        override public function takeDamage(p:PartyMember):void{
            this.damagedByPartyMember = p;
            if(this._state == STATE_DESPAWN && !this.canDie) {
                return;
            }
            if (this.isDead()) {
                return;
            }
            if (this.hitPoints <= 0) {
                this.die(this.damagedByPartyMember);
                return;
            }
            if (!this.isEscaping()) {
                if(this.hitPoints % 100 == 0) {
                    this._state = STATE_ESCAPE;
                } else {
                    this._state = STATE_RECOIL;
                    this.dir = this.closestPartyMemberDisp.normalized().mulScl(this.recoilPower).reflectX();
                }
            }
            if (this.damageLockMap[p.slug] == true) {
                return;
            }
            this.damageLockMap[p.slug] = true;
            this.hitPoints -= this.hitDamage;
            this.hitPoints = Math.max(this.hitPoints, 0);
            this._healthBar.setPoints(this.hitPoints);
            GlobalTimer.getInstance().setMark(this.takeDamageEventSlug + p.slug,
                                              1 * GameSound.MSEC_PER_SEC,
                                              function():void {
                                                damageLockMap[p.slug] = false;
                                              }, true);
            p.runParticles(this.footPos.add(new DHPoint(0, -20)));
            if(this.hitPoints <= this.damageThreshold[this._spawnCounter] &&
               !this.canDie)
            {
                this.startDespawn();
                return;
            }
        }

        private function isEscaping():Boolean {
            return this._state == STATE_MOVE_TO_PATH_NODE || this._state == STATE_ESCAPE;
        }

        override public function setupSprites():void {
            this.visible = true;
            this._healthBar = new BossHealthBar(this.hitPoints);
        }

        override protected function setupSmoke():void {
            this.smoke = new ParticleExplosion(30, Enemy.PARTICLE_SMOKE, 3, .8,
                                               7, 8, .3, this);
            this.smoke.addVisibleObjects();
        }

        override public function doState__IDLE():void {
            this.dir = ZERO_POINT;
            this.bossFollowPlayer();
            if (this.closestPartyMemberIsInTrackingRange()) {
                this.startTracking();
            }
        }

        override protected function canPlayCall():Boolean {
            return this.isOnscreen() && !this.isDead() && this.visible;
        }

        override public function die(p:PartyMember):void {
            this._state = STATE_DEAD;
            this.smoke.run(this.getMiddlePos());
            FlxG.stage.dispatchEvent(
                new DataEvent(GameState.EVENT_BOSS_DIED, {'killed_by': p}));
            SoundManager.getInstance().playSound(
                SfxBossDeath, 5*GameSound.MSEC_PER_SEC, null, false, .6
            );
        }

        override public function activeTarget():void { }

        override public function inactiveTarget():void { }

        override public function addVisibleObjects():void {
            FlxG.state.add(this.debugText);
            FlxG.state.add(this._notificationText);
        }

        public function addHealthBarVisibleObjects():void {
            this._healthBar.addVisibleObjects();
        }
    }
}
