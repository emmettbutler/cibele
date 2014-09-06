package {
    import org.flixel.*;

    public class Emote extends GameObject {
        [Embed(source="../assets/emote1.png")] private var ImgEmote1:Class;

        public static const STATE_RISE:Number = 938476;
        public static const STATE_HANG:Number = 938477;
        public static const STATE_FADE:Number = 938478;

        public var lastStateChangeTime:Number = -1;

        public function Emote(pos:DHPoint) {
            super(pos);
            this.loadGraphic(ImgEmote1, false, false, 63, 23, true);
            this.alpha = 0;
            FlxG.state.add(this);

            this._state = STATE_RISE;
        }

        override public function update():void {
            super.update();

            if (this._state == STATE_RISE) {
                this.y -= 5;
                this.alpha += .05;
                if (this.timeAlive > .2*1000) {
                    this._state = STATE_HANG;
                    this.lastStateChangeTime = this.timeAlive;
                }
            } else if (this._state == STATE_HANG) {
                if (this.timeAlive - this.lastStateChangeTime > .6*1000) {
                    this._state = STATE_FADE;
                    this.lastStateChangeTime = this.timeAlive;
                }
            } else if (this._state ==  STATE_FADE) {
                this.alpha -= .05;
                if (this.timeAlive - this.lastStateChangeTime > .6*1000) {
                    FlxG.state.remove(this);
                    this.destroy();
                }
            }
        }
    }
}
