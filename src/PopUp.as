package{
    import org.flixel.*;

    public class PopUp extends UIElement {
        public static const ARROW_THROUGH:Number = 1;
        public var cur_anim:Number = 0;
        public var timer_key:String;

        public function PopUp(img:Class, w:Number, h:Number,
                              functionality:Number=0) {
            this.timer_key = Math.random() + "";

            var _screen:ScreenManager = ScreenManager.getInstance();
            super(_screen.screenWidth * .1, _screen.screenHeight * .1);
            this._state = functionality;

            if(this._state == ARROW_THROUGH) {
                this.loadGraphic(img,true,false,w,h);
                for (var i:int = 0; i < 3; i++) {
                    this.addAnimation(i.toString(),[i],1,false);
                }
                this.cur_anim = 1;
                this.play("2");
            } else {
                this.loadGraphic(img,false,false,w,h);
            }
            this.visible = false;
            this.scrollFactor.x = 0;
            this.scrollFactor.y = 0;
        }

        override public function update():void {
            if(this._state == ARROW_THROUGH) {
                //TODO change this it won't work with point and click
                if(FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("RIGHT") ||
                   FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("DOWN")) {
                    if(this.cur_anim == 1) {
                        this.cur_anim = 2;
                    } else if(this.cur_anim == 2) {
                        this.cur_anim = 3;
                    } else if(this.cur_anim == 3) {
                        this.cur_anim = 1;
                    }
                    this.play((this.cur_anim - 1).toString());
                }
            }
        }

        override public function destroy():void { }
    }
}
