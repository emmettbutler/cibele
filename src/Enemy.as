package
{
    import org.flixel.*;
    import flash.utils.Dictionary;

    public class Enemy extends GameObject {
        [Embed(source="../assets/ikuturso_enemy_1.png")] private var ImgIT1:Class;
        public var enemyType:String = "enemy";
        public var hitpoints:Number = 100;
        public var damage:Number = 5;

        public static const STATE_IDLE:Number = 1;
        public static const STATE_DAMAGED:Number = 2;
        public static const STATE_TRACKING:Number = 3;
        public static const STATE_RECOIL:Number = 4;
        public var debugText:FlxText;
        public var dead:Boolean = false;

        public var player:Player;
        private var playerDisp:DHPoint;
        private var disp:DHPoint;
        private var followerDisp:DHPoint;
        private var attackerDisp:DHPoint;
        public var path_follower:PathFollower;
        public var attacker:PartyMember;

        {
            public static var stateMap:Dictionary = new Dictionary();
            stateMap[STATE_IDLE] = "STATE_IDLE";
            stateMap[STATE_DAMAGED] = "STATE_DAMAGED";
            stateMap[STATE_TRACKING] = "STATE_TRACKING";
            stateMap[STATE_RECOIL] = "STATE_RECOIL";
        }

        public function Enemy(pos:DHPoint) {
            super(pos);
            this._state = STATE_IDLE;
            loadGraphic(ImgIT1,false,false,151,104);
            debugText = new FlxText(pos.x, pos.y, 100, "");
            debugText.color = 0xff0000ff;
            FlxG.state.add(debugText);
            disp = new DHPoint(0, 0);
            followerDisp = new DHPoint(0, 0);
        }

        public function setPlayerRef(p:Player):void{
            this.player = p;
        }

        public function setFollowerRef(f:PathFollower):void{
            this.path_follower = f;
        }

        public function takeDamage(p:PartyMember):void{
            this.attacker = p;
            this._state = STATE_RECOIL;
            this.hitpoints -= damage;
            if(this.hitpoints < 0){
                FlxG.state.remove(this);
                FlxG.state.remove(this.debugText);
                this.dead = true;
                this.destroy();
            }
        }

        public function setIdle():void {
            this._state = STATE_IDLE;
        }

        public function isFollowing():Boolean {
            return this._state == STATE_TRACKING;
        }

        override public function update():void{
            this.playerDisp = this.player.pos.sub(this.pos);
            this.followerDisp = this.path_follower.pos.sub(this.pos);
            if(this.attacker != null){
                this.attackerDisp = this.attacker.pos.sub(this.pos);
            }

            debugText.x = pos.x;
            debugText.y = pos.y-10;
            var str:String = stateMap[this._state] + "\n" + hitpoints;
            if (str != null) {
                debugText.text = str;
            }

            if (this._state == STATE_IDLE) {
                if (this.playerDisp._length() < 308 &&
                    this.playerDisp._length() > 100) {
                    this._state = STATE_TRACKING;
                }
            } else if (this._state == STATE_TRACKING) {
                if (this.playerDisp._length() > 208 ||
                    this.playerDisp._length() < 10)
                {
                    this._state = STATE_IDLE;
                }
                this.disp = this.player.pos.sub(this.pos);
                this.setPos(disp.normalized().add(this.pos));
            } else if (this._state == STATE_RECOIL) {
                if (this.attackerDisp._length() > 120)
                {
                    this._state = STATE_TRACKING;
                }
                this.disp = this.attacker.pos.sub(this.pos);
                this.setPos(disp.normalized().mulScl(7).reverse().add(this.pos));
            }
        }
    }
}
