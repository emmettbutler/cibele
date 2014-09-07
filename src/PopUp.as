package{
    import org.flixel.*;

    public class PopUp extends FlxSprite {
        public var timer:Number;
        public var shown:Boolean = false;
        public var bornTime:Number = -1;
        public var timeAlive:Number = -1;
        public var currentTime:Number = -1;

        public static const ARROW_THROUGH:Number = 1;
        public var _state:Number = 0;
        public var cur_anim:Number = 0;

        public function PopUp(img:Class, w:Number, h:Number, time:Number, functionality:Number = 0) {
            timer = time;
            this.bornTime = new Date().valueOf();
            this.timeAlive = 0;
            var _screen:ScreenManager = ScreenManager.getInstance();
            super(_screen.screenWidth * .1, _screen.screenHeight * .1);
            this._state = functionality;

            if(this._state == ARROW_THROUGH) {
                this.loadGraphic(img,true,false,w,h);
                this.addAnimation("one",[0],1,false);
                this.addAnimation("two",[1],1,false);
                this.addAnimation("three",[2],1,false);
                this.cur_anim = 1;
                this.play("two");
            } else {
                this.loadGraphic(img,false,false,w,h);
            }
            this.alpha = 0;
            this.scrollFactor.x = 0;
            this.scrollFactor.y = 0;

        }

        override public function update():void {
            this.currentTime = new Date().valueOf();
            this.timeAlive = this.currentTime - this.bornTime;

            if(this._state == ARROW_THROUGH) {
                if(FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("RIGHT") ||
                    FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("DOWN")) {
                    if(this.cur_anim == 1) {
                        this.cur_anim = 2;
                        play("two");
                    } else if(this.cur_anim == 2) {
                        this.cur_anim = 3;
                        play("three");
                    } else if(this.cur_anim == 3) {
                        this.cur_anim = 1;
                        play("one");
                    }
                }
            }
        }

        override public function destroy():void {

        }
    }
}