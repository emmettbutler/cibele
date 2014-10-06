package{
    import org.flixel.*;

    public class Desktop extends GameState {
        [Embed(source="../assets/valtameri_icon.png")] private var ImgIcon:Class;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:GameObject;
        public var valtameri:FlxRect;
        public var valtameri_icon:GameObject;
        public var mouse_rect:FlxRect;

        public var img_height:Number = 357;

        public function Desktop() {
            super(true, true, false);
            this.showEmoji = false;
        }

        override public function create():void {
            FlxG.bgColor = 0x00000000;
            (new BackgroundLoader()).loadSingleTileBG("../assets/UI_Desktop.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            var _screen:ScreenManager = ScreenManager.getInstance();
            valtameri_icon = new GameObject(new DHPoint(_screen.screenWidth * .7, _screen.screenHeight * .4));
            valtameri_icon.loadGraphic(ImgIcon,false,false,64,57);
            add(valtameri_icon);
            valtameri = new FlxRect(valtameri_icon.x,valtameri_icon.y,valtameri_icon.width,valtameri_icon.height);

            mouse_rect = new FlxRect(FlxG.mouse.x,FlxG.mouse.y,50,50);

            debugText = new FlxText(0,0,100,"");
            add(debugText);

            super.postCreate();
        }

        override public function update():void{
            super.update();
            mouse_rect.x = FlxG.mouse.x;
            mouse_rect.y = FlxG.mouse.y;
            FlxG.collide();
            if (mouse_rect.overlaps(valtameri) && FlxG.mouse.justPressed()){
                FlxG.switchState(new MenuScreen());
            }

            timeFrame++;

            if(timeFrame%30 == 0){
                timer++;
            }
        }
    }
}
