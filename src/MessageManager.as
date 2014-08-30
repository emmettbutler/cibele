package{
    import org.flixel.*;

    public class MessageManager extends FlxSprite {
        [Embed(source="../assets/messages.png")] private var ImgMsg:Class;
        public var img_msg:FlxSprite;

        public function MessageManager():void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            img_msg = new FlxSprite(_screen.screenWidth * .001, _screen.screenHeight * .9)
            img_msg.loadGraphic(ImgMsg,false,false,132,28);
            FlxG.state.add(img_msg);
        }
    }
}
