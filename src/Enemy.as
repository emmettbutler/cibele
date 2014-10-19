package
{
    import org.flixel.*;
    import flash.utils.Dictionary;

    public class Enemy extends GameObject {
        [Embed(source="../assets/squid_baby.png")] private var ImgIT1:Class;
        [Embed(source="../assets/Enemy2_sprite.png")] private var ImgIT2:Class;
        [Embed(source="../assets/enemy_highlight.png")] private var ImgActive:Class;
        [Embed(source="../assets/enemy2_highlight.png")] private var ImgActive2:Class;
        public var enemyType:String = "enemy";
        public var hitpoints:Number = 100;
        public var damage:Number = 5;

        public static const STATE_IDLE:Number = 1;
        public static const STATE_DAMAGED:Number = 2;
        public static const STATE_TRACKING:Number = 3;
        public static const STATE_RECOIL:Number = 4;
        public static const STATE_ESCAPE:Number = 5;
        public static const STATE_MOVE_TO_PATH_NODE:Number = 6;
        public var dead:Boolean = false;

        public var player:Player;
        public var recoilPower:Number = 5;
        public var playerDisp:DHPoint;
        public var attackOffset:DHPoint;
        public var disp:DHPoint;
        private var followerDisp:DHPoint;
        private var attackerDisp:DHPoint;
        public var path_follower:PathFollower;
        public var attacker:PartyMember;
        public var _mapnodes:MapNodeContainer;
        public var footPos:DHPoint;
        public var cib_target_sprite:GameObject;
        public var ichi_target_sprite:GameObject;
        public var fade_active:Boolean = false;
        public var fade:Boolean = false;
        public var bar:GameObject;
        public var sightRange:Number = 308;
        public var canEscape:Boolean = false;

        public var _path:Path = null;
        public var targetPathNode:PathNode;
        public var escape_counter:Number = 0;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_IDLE] = "STATE_IDLE";
            stateMap[STATE_DAMAGED] = "STATE_DAMAGED";
            stateMap[STATE_TRACKING] = "STATE_TRACKING";
            stateMap[STATE_RECOIL] = "STATE_RECOIL";
        }

        public function Enemy(pos:DHPoint) {
            super(pos);
            //this._state = STATE_IDLE;

            this.attackOffset = new DHPoint(0, 0);

            var rand:Number = Math.random() * 2;
            if(rand > 1) {
                this.cib_target_sprite = new GameObject(pos);
                this.cib_target_sprite.loadGraphic(ImgActive,false,false,147,24);
                FlxG.state.add(this.cib_target_sprite);
                this.cib_target_sprite.alpha = 0;

                this.ichi_target_sprite = new GameObject(pos);
                this.ichi_target_sprite.loadGraphic(ImgActive,false,false,147,24);
                FlxG.state.add(this.ichi_target_sprite);
                this.ichi_target_sprite.alpha = 0;

                loadGraphic(ImgIT1, false, false, 152, 104);
            } else {
                this.cib_target_sprite = new GameObject(pos);
                this.cib_target_sprite.loadGraphic(ImgActive2,false,false,67,15);
                FlxG.state.add(this.cib_target_sprite);
                this.cib_target_sprite.alpha = 0;

                this.ichi_target_sprite = new GameObject(pos);
                this.ichi_target_sprite.loadGraphic(ImgActive2,false,false,67,15);
                FlxG.state.add(this.ichi_target_sprite);
                this.ichi_target_sprite.alpha = 0;
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
            this.setPos(warpNode.pos);
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
            if(this.fade_active != true) {
                this.fade_active = true;
            }
            this.bar.alpha = 1;
        }

        public function inactiveTarget():void {
            if(this.fade_active != false) {
                this.fade_active = false;
                this.cib_target_sprite.alpha = 0;
                this.ichi_target_sprite.alpha = 0;
            }
            this.bar.alpha = 0;
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
            this.ichi_target_sprite.alpha = 0;
            this.cib_target_sprite.alpha = 0;
            this.bar.alpha = 0;
        }

        public function getAttackPos():DHPoint {
            return this.footPos.add(this.attackOffset);
        }

        public function setPath(path:Path):void {
            this._path = path;
        }

        override public function update():void{
            super.update();

            this.footPos.x = this.x + this.width/2;
            this.footPos.y = this.y + this.height;
            this.basePos.y = this.y + this.height;

            this.cib_target_sprite.x = this.footPos.x - this.cib_target_sprite.width / 2;
            this.cib_target_sprite.y = this.footPos.y - 10;
            this.ichi_target_sprite.x = this.footPos.x - this.ichi_target_sprite.width / 2;
            this.ichi_target_sprite.y = this.footPos.y - 10;

            this.bar.x = this.x + (this.width * .5);
            this.bar.y = this.pos.y-30;

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

            if (this._state == STATE_IDLE) {
                if (this.playerDisp._length() < this.sightRange &&
                    this.playerDisp._length() > 100) {
                    this._state = STATE_TRACKING;
                }
                this.dir = ZERO_POINT;
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
                        this.dir = disp.normalized().mulScl(3);
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

            if(this.hitpoints < 0){
                this.die();
            } else {
                if(fade_active) {
                    if(this.attacker != null) {
                        if(this.attacker.tag == PartyMember.cib) {
                            this.fadeTarget(this.cib_target_sprite);
                        } else if(this.attacker.tag == PartyMember.ichi) {
                            this.fadeTarget(this.ichi_target_sprite, true);
                        }
                    }
                }
            }
        }
    }
}
