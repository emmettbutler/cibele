package{
    import org.flixel.*;

    public class Desktop extends GameState {
        [Embed(source="../assets/selfiedesktop.png")] private var ImgSelfies:Class;
        [Embed(source="../assets/untitledfolder.png")] private var ImgFolder:Class;
        public var timeFrame:Number = 0;
        public var timer:Number = 0;
        public var debugText:FlxText;

        public var bg:GameObject;
        public var mouse_rect:FlxRect;

        public var img_height:Number = 357;

        public var selfie_folder:PopUp;
        public var untitled_folder:PopUp;

        public function Desktop() {
            super(true, true, false);
            this.showEmoji = false;
            this.untitled_folder = new PopUp(ImgFolder,765,407,0,"untitled_folder");
            this.selfie_folder = new PopUp(ImgSelfies,769,411,0,"selfie_folder");
        }

        override public function create():void {
            FlxG.bgColor = 0x00000000;
            (new BackgroundLoader()).loadSingleTileBG("../assets/UI_Desktop.png");
            ScreenManager.getInstance().setupCamera(null, 1);

            mouse_rect = new FlxRect(FlxG.mouse.x,FlxG.mouse.y,50,50);

            debugText = new FlxText(0,0,100,"");
            add(debugText);

            super.postCreate();
        }

        override public function update():void{
            super.update();
            mouse_rect.x = FlxG.mouse.x;
            mouse_rect.y = FlxG.mouse.y;

            timeFrame++;

            if(timeFrame%30 == 0){
                timer++;
            }
        }
    }
}
