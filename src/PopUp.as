package{
    import org.flixel.*;

    public class PopUp extends FlxSprite {
        public var timer:Number;
        public var shown:Boolean = false;

        public function PopUp(img:Class, w:Number, h:Number, time:Number) {
            timer = time;
            var _screen:ScreenManager = ScreenManager.getInstance();
            super(_screen.screenWidth * .1, _screen.screenHeight * .1);
            this.loadGraphic(img,false,false,w,h);
            FlxG.state.add(this);
            this.alpha = 0;
        }
    }
}