package {
    import org.flixel.*;

    public class Emote extends GameObject {
        [Embed(source="../assets/images/ui/UI_happy face_blue.png")] private var ImgEmojiHappy:Class;
        [Embed(source="../assets/images/ui/UI_Sad Face_blue.png")] private var ImgEmojiSad:Class;
        [Embed(source="../assets/images/ui/UI_Angry face_blue.png")] private var ImgEmojiAngry:Class;
        [Embed(source="../assets/images/ui/UI_happy_face_pink.png")] private var ImgEmojiHappyPink:Class;
        [Embed(source="../assets/images/ui/UI_sad_face_pink.png")] private var ImgEmojiSadPink:Class;
        [Embed(source="../assets/images/ui/UI_Angry_face_pink.png")] private var ImgEmojiAngryPink:Class;

        public static const STATE_RISE:Number = 938476;
        public static const STATE_HANG:Number = 938477;
        public static const STATE_FADE:Number = 938478;
        public static const HAPPY:Number = 111;
        public static const SAD:Number = 112;
        public static const ANGRY:Number = 113;

        public var lastStateChangeTime:Number = -1;

        public function Emote(pos:DHPoint,mood:Number,col:Number=GameState.UICOLOR_DEFAULT) {
            super(pos);
            if(col == GameState.UICOLOR_DEFAULT) {
                if(mood == HAPPY) {
                    this.loadGraphic(ImgEmojiHappy, false, false, 96, 98, true);
                } else if(mood == SAD) {
                    this.loadGraphic(ImgEmojiSad, false, false, 94, 99, true);
                } else if(mood == ANGRY) {
                    this.loadGraphic(ImgEmojiAngry, false, false, 100, 99, true);
                }
            } else if(col == GameState.UICOLOR_PINK) {
                if(mood == HAPPY) {
                    this.loadGraphic(ImgEmojiHappyPink, false, false, 100, 99, true);
                } else if(mood == SAD) {
                    this.loadGraphic(ImgEmojiSadPink, false, false, 100, 99, true);
                } else if(mood == ANGRY) {
                    this.loadGraphic(ImgEmojiAngryPink, false, false, 100, 99, true);
                }
            }
            this.scale.x = .5;
            this.scale.y = .5;
            this.alpha = 0;
            FlxG.state.add(this);

            this._state = STATE_RISE;
        }

        override public function update():void {
            super.update();

            if (this._state == STATE_RISE) {
                this.y -= 5;
                this.alpha += .2;
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
