package{
    import org.flixel.*;

    public class MenuScreen extends FlxState {
        [Embed(source="../assets/login.png")] private var ImgLogin:Class;
        [Embed(source="../assets/quit.png")] private var ImgQuit:Class;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:FlxSprite;
        public var login:FlxSprite;
        public var quit:FlxSprite;
        public var login_rect:FlxRect;
        public var quit_rect:FlxRect;
        public var mouse_rect:FlxRect;

        public var img_height:Number = 357;

        override public function create():void {
            FlxG.bgColor = 0x00000000;
            FlxG.mouse.show();
            (new BackgroundLoader()).loadSingleTileBG("../assets/menuscreen.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            var _screen:ScreenManager = ScreenManager.getInstance();
            login = new FlxSprite(_screen.screenWidth * .45, _screen.screenHeight * .55);
            login.loadGraphic(ImgLogin,false,false,121,17);
            add(login);
            login_rect = new FlxRect(login.x,login.y,login.width,login.height);

            quit = new FlxSprite(_screen.screenWidth * .45, _screen.screenHeight * .65);
            quit.loadGraphic(ImgQuit,false,false,121,17);
            add(quit);
            quit_rect = new FlxRect(quit.x,quit.y,quit.width,quit.height);

            mouse_rect = new FlxRect(FlxG.mouse.x,FlxG.mouse.y,1,1);

            debugText = new FlxText(0,0,100,"");
            add(debugText);
        }

        override public function update():void{
            super.update();
            mouse_rect.x = FlxG.mouse.x;
            mouse_rect.y = FlxG.mouse.y;
            if(FlxG.mouse.justPressed()){
                if (mouse_rect.overlaps(login_rect)){
                    FlxG.switchState(new HallwayToFern());
                }
                if (mouse_rect.overlaps(quit_rect)){
                    FlxG.switchState(new Desktop());
                }
            }

            timeFrame++;
            debugText.x = FlxG.mouse.x;
            debugText.y = FlxG.mouse.y;

            debugText.text = "MenuScreen";

            if(timeFrame%30 == 0){
                timer++;
            }
        }
    }
}