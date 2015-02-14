package com.starmaid.Cibele.entities {
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.utils.MapNodeContainer;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class Enemy extends GameObject {
        [Embed(source="/../assets/images/characters/squid_baby.png")] private var ImgIT1:Class;
        [Embed(source="/../assets/images/characters/Enemy2_sprite.png")] private var ImgIT2:Class;
        [Embed(source="/../assets/images/ui/enemy_highlight.png")] private var ImgActive:Class;
        [Embed(source="/../assets/images/ui/enemy2_highlight.png")] private var ImgActive2:Class;
        public var enemyType:String = "enemy";
        public var hitpoints:Number = 100;
        public var damage:Number = 3;

        public static const STATE_IDLE:Number = 1;
        public static const STATE_DAMAGED:Number = 2;
        public static const STATE_TRACKING:Number = 3;
        public static const STATE_RECOIL:Number = 4;
        public static const STATE_ESCAPE:Number = 5;
        public static const STATE_MOVE_TO_PATH_NODE:Number = 6;
        public static const STATE_DEAD:Number = 7;
        public var dead:Boolean = false;

        public var player:Player;
        public var recoilPower:Number = 3;
        public var playerDisp:DHPoint;
        public var attackOffset:DHPoint;
        public var disp:DHPoint;
        private var followerDisp:DHPoint;
        private var attackerDisp:DHPoint;
        public var path_follower:PathFollower;
        public var attacker:PartyMember;
        public var _mapnodes:MapNodeContainer;
        public var footPos:DHPoint;
        public var target_sprite:GameObject;
        public var fade_active:Boolean = false;
        public var fade:Boolean = false;
        public var bar:GameObject;
        public var sightRange:Number = 308;
        public var canEscape:Boolean = false;
        public var original_pos:DHPoint;

        public var _path:Path = null;
        public var targetPathNode:PathNode;
        public var escape_counter:Number = 0;

        public var bossHasAppeared:Boolean = false;

        public var use_active_highlighter:Boolean = true;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_IDLE] = "STATE_IDLE";
            stateMap[STATE_DAMAGED] = "STATE_DAMAGED";
            stateMap[STATE_TRACKING] = "STATE_TRACKING";
            stateMap[STATE_RECOIL] = "STATE_RECOIL";
            stateMap[STATE_DEAD] = "STATE_DEAD";
            stateMap[STATE_ESCAPE] = "STATE_ESCAPE";
            stateMap[STATE_MOVE_TO_PATH_NODE] = "STATE_MOVE_TO_PATH_NODE";
        }

        public function Enemy(pos:DHPoint) {
            super(pos);
            this.original_pos = pos;
            this._state = STATE_IDLE;

            this.attackOffset = new DHPoint(0, 0);

            var rand:Number = Math.random() * 2;
            if(rand > 1) {
                this.target_sprite = new GameObject(pos);
                this.target_sprite.loadGraphic(ImgActive,false,false,147,24);
                FlxG.state.add(this.target_sprite);
                this.target_sprite.visible = false;

                loadGraphic(ImgIT1, false, false, 152, 104);
            } else {
                this.target_sprite = new GameObject(pos);
                this.target_sprite.loadGraphic(ImgActive2,false,false,67,15);
                FlxG.state.add(this.target_sprite);
                this.target_sprite.visible = false;

                loadGraphic(ImgIT2, false, false, 70, 160);
            }
            addAnimation("run", [0, 1, 2, 3, 4, 5], 12, true);
            play("run");
            disp = new DHPoint(0, 0);
            footPos = new DHPoint(0, 0);
            this.zSorted = true;
            this.basePos = new DHPoint(this.x, this.y + this.height);

            this.bar = new GameObject(new DHPoint(pos.x,pos.y));
            this.bar.makeGraphic(1,8,0xffe2678e);
            this.bar.scale.x = this.hitpoints;
        }

        public function warpToPlayer():void {
            var targetPoint:DHPoint = this.player.pos.add(this.player.dir.normalized().mulScl(1000));
            var warpNode:MapNode = this._mapnodes.getClosestNode(targetPoint);
            var headFootDisp:DHPoint = this.pos.sub(this.footPos);
            this.setPos(warpNode.pos.add(headFootDisp));
            this._state = STATE_TRACKING;
        }

        public function bossFollowPlayer():void {
            if(!inViewOfPlayer() && this.enemyType == "boss" && this.bossHasAppeared) {
                this.warpToPlayer();
            }
        }

        public function setPlayerRef(p:Player):void{
            this.player = p;
        }

        public function setFollowerRef(f:PathFollower):void{
            this.path_follower = f;
        }

        public function takeDamage(p:PartyMember):void{
            this.attacker = p;
            if (this._state != STATE_MOVE_TO_PATH_NODE && this._state != STATE_ESCAPE) {
                this._state = STATE_RECOIL;
                this.disp = this.attacker.footPos.sub(this.getAttackPos());
                this.dir = this.disp.normalized().mulScl(this.recoilPower).reflectX();
            }
            this.hitpoints -= damage;
            if(this.hitpoints%100 == 0) {
                if (this._state != STATE_MOVE_TO_PATH_NODE && this._state != STATE_ESCAPE) {
                    this._state = STATE_ESCAPE;
                }
            }
            this.bar.scale.x = this.hitpoints;
        }

        public function setIdle():void {
            this._state = STATE_IDLE;
        }

        public function isFollowing():Boolean {
            return this._state == STATE_TRACKING;
        }

        public function activeTarget():void {
            if(this.fade_active != true && use_active_highlighter) {
                this.fade_active = true;
                this.target_sprite.visible = true;
            }
            this.bar.visible = true;
        }

        public function inactiveTarget():void {
            if(this.fade_active != false) {
                this.fade_active = false;
                this.target_sprite.visible = false;
            }
            this.bar.visible = false;
        }

        public function fadeTarget(obj:GameObject, soften:Boolean=false):void {
            if(!soften) {
                if(obj.alpha == 1) {
                    this.fade = true;
                } else if(obj.alpha == 0) {
                    this.fade = false;
                }
            } else {
                if(obj.alpha == .6) {
                    this.fade = true;
                } else if(obj.alpha == 0) {
                    this.fade = false;
                }
            }

            if(this.fade) {
                obj.alpha -= .1;
            } else {
                obj.alpha += .1;
            }
        }

        public function die():void {
            // don't destroy() or state.remove() here. doing so breaks z-sorting
            this.dead = true;
            this.visible = false;
            this.target_sprite.visible = false;
            this.bar.visible = false;
            this._state = STATE_DEAD;
            this.dir = new DHPoint(0,0);
            GlobalTimer.getInstance().setMark("respawn timer" + Math.random()*200, 30*GameSound.MSEC_PER_SEC, this.respawn, true);
        }

        public function respawn():void {
            if(!this.inViewOfPlayer()) {
                this.hitpoints = 100;
                this.dead = false;
                this.visible = true;
                this.setIdle();
                this.x = original_pos.x;
                this.y = original_pos.y;
            } else {
                GlobalTimer.getInstance().setMark("respawn timer" + Math.random()*200, 10*GameSound.MSEC_PER_SEC, this.respawn, true);
            }
        }

        public function getAttackPos():DHPoint {
            return this.footPos.add(this.attackOffset);
        }

        public function setPath(path:Path):void {
            this._path = path;
        }

        public function inViewOfPlayer():Boolean {
            return !(this.player.pos.sub(this.pos)._length() >
                    ScreenManager.getInstance().screenWidth / 2);
        }

        override public function update():void{
            super.update();

            this.footPos.x = this.x + this.width/2;
            this.footPos.y = this.y + this.height;
            this.basePos.y = this.y + this.height;

            this.target_sprite.x = this.footPos.x - this.target_sprite.width / 2;
            this.target_sprite.y = this.footPos.y - 10;

            this.bar.x = this.x + (this.width * .5);
            this.bar.y = this.pos.y-30;

            if(this._state != STATE_DEAD) {
                if (this.player == null) {
                    this.playerDisp = new DHPoint(0, 0);
                } else {
                    this.playerDisp = this.player.footPos.sub(this.getAttackPos());
                }

                if(this.attacker != null){
                    if (this.attacker == this.player) {
                        this.attackerDisp = this.playerDisp;
                    } else if (this.attacker == this.path_follower) {
                        this.attackerDisp = this.path_follower.footPos.sub(this.getAttackPos());
                    }
                }

                if(this.hitpoints <= 0){
                    this.die();
                } else {
                    if(fade_active && use_active_highlighter) {
                        if(this.attacker != null) {
                            this.fadeTarget(this.target_sprite);
                        }
                    }
                }
            } else {
                this.visible = false;
                this.target_sprite.visible = false;
                this.bar.visible = false;
            }

            if(this.hitpoints <= 0){
                this.hitpoints = 0;
            }

            if (this._state == STATE_IDLE) {
                if (this.playerDisp._length() < this.sightRange &&
                    this.playerDisp._length() > 100) {
                    this._state = STATE_TRACKING;
                }
                this.dir = ZERO_POINT;
                this.bossFollowPlayer();
            } else if (this._state == STATE_TRACKING) {
                if (this.playerDisp._length() > this.sightRange - 100 ||
                    this.playerDisp._length() < 10)
                {
                    this._state = STATE_IDLE;
                }
                this.disp = this.player.footPos.sub(this.getAttackPos());
                this.dir = disp.normalized();
            } else if (this._state == STATE_RECOIL) {
                if (this.attackerDisp._length() > 120) {
                    this._state = STATE_TRACKING;
                }
            } else if (this._state == STATE_ESCAPE) {
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
            } else if (this._state == STATE_MOVE_TO_PATH_NODE) {
                this.escape_counter += 1;
                this._path.advance();
                this.targetPathNode = this._path.currentNode;
                if(this.escape_counter <= 10) {
                    this._state = STATE_ESCAPE;
                } else {
                    this._state = STATE_TRACKING;
                    this.escape_counter = 0;
                }
            }
        }
    }
}
