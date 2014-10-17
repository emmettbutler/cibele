package{
    import org.flixel.*;

    public class Desktop extends GameState {
        [Embed(source="../assets/selfiedesktop.png")] private var ImgSelfies:Class;
        [Embed(source="../assets/untitledfolder.png")] private var ImgFolder:Class;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:GameObject;

        public var img_height:Number = 357;

        public var selfie_folder:GameObject;
        public var untitled_folder:GameObject;

        public function Desktop() {
            super(true, true, false);
            this.showEmoji = false;
        }

        override public function create():void {
            super.create();
            FlxG.bgColor = 0x00000000;
            (new BackgroundLoader()).loadSingleTileBG("../assets/UI_Desktop.png");
            ScreenManager.getInstance().setupCamera(null, 1);
            var _screen:ScreenManager = ScreenManager.getInstance();

            debugText = new FlxText(0,0,100,"");
            add(debugText);

            super.postCreate();

            this.untitled_folder = new GameObject(new DHPoint(_screen.screenWidth * .2, _screen.screenHeight * .1));
            this.untitled_folder.loadGraphic(ImgFolder,false,false,765,407);
            FlxG.state.add(this.untitled_folder);
            this.untitled_folder.alpha = 0;

            this.selfie_folder = new GameObject(new DHPoint(_screen.screenWidth * .2, _screen.screenHeight * .1));
            this.selfie_folder.loadGraphic(ImgSelfies,false,false,769,411);
            FlxG.state.add(this.selfie_folder);
            this.selfie_folder.alpha = 0;
        }

        override public function update():void{
            super.update();

            if(FlxG.mouse.justPressed()) {
                var _screen:ScreenManager = ScreenManager.getInstance();
                var untitled_folder_rect:FlxRect = new FlxRect(_screen.screenWidth * .85, _screen.screenHeight * .31, 100, 80);
                var selfie_folder_rect:FlxRect = new FlxRect(_screen.screenWidth * .88, _screen.screenHeight * .09, 100, 80);
                var mouse_rect:FlxRect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y);

                if(mouse_rect.overlaps(untitled_folder_rect)) {
                    selfie_folder.alpha = 0;
                    if(untitled_folder.alpha == 1){
                        untitled_folder.alpha = 0;
                    } else {
                        untitled_folder.alpha = 1;
                    }
                } else if(mouse_rect.overlaps(selfie_folder_rect)) {
                    untitled_folder.alpha = 0;
                    if(selfie_folder.alpha == 1) {
                        selfie_folder.alpha = 0;
                    } else {
                        selfie_folder.alpha = 1;
                    }
                } else {
                    untitled_folder.alpha = 0;
                    selfie_folder.alpha = 0;
                }
            }

            timeFrame++;

            if(timeFrame%30 == 0){
                timer++;
            }
        }
    }
}
