package
{
    import org.flixel.*;

    public class Enemy extends GameObject {
        [Embed(source="../assets/ikuturso_enemy_1.png")] private var ImgIT1:Class;
        public var hitpoints:Number = 20;
        public var damage:Number = 2;

        public static const STATE_DAMAGED:Number = 2;
        public static const STATE_TRACKING:Number = 3;
        public var debugText:FlxText;
        public var dead:Boolean = false;

        public var player:Player;
        private var playerDisp:DHPoint;

        public function Enemy(pos:DHPoint) {
            super(pos);
            loadGraphic(ImgIT1,false,false,151,104);
            debugText = new FlxText(pos.x, pos.y, 100, "");
            debugText.color = 0xff0000ff;
            FlxG.state.add(debugText);
        }

        public function setPlayerRef(p:Player):void{
            this.player = p;
        }

        public function takeDamage():void{
            hitpoints -= 20;
            if(hitpoints < 0){
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
            debugText.x = pos.x;
            debugText.y = pos.y-10;
            debugText.text = "HP: " + hitpoints;

            this.playerDisp = this.player.pos.sub(this.pos);

            if (this._state == STATE_IDLE) {
                if (this.playerDisp._length() < 208) {
                    this._state = STATE_TRACKING;
                }
            } else if (this._state == STATE_TRACKING) {
                if (this.playerDisp._length() > 208 ||
                    this.playerDisp._length() < 10)
                {
                    this._state = STATE_IDLE;
                }
                var disp:DHPoint = this.player.pos.sub(this.pos);
                this.setPos(disp.normalized().add(this.pos));
            }
        }
    }
}
