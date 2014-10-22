package{
    import org.flixel.*;

    public class Desktop extends GameState {
        [Embed(source="../assets/selfiedesktop.png")] private var ImgSelfies:Class;
        [Embed(source="../assets/untitledfolder.png")] private var ImgFolder:Class;
        [Embed(source="../assets/sfx_roomtone.mp3")] private var SFXRoomTone:Class;

        public var bg:GameObject;
        public var img_height:Number = 357;
        public var selfie_folder:GameObject;
        public var untitled_folder:GameObject;

        public var selfie_folder_sprite:GameObject,
                   untitled_folder_sprite:GameObject;

        public static var ROOMTONE:String = "desktop room tone";

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

            super.postCreate();

            this.untitled_folder = new GameObject(new DHPoint(_screen.screenWidth * .2, _screen.screenHeight * .1));
            this.untitled_folder.loadGraphic(ImgFolder,false,false,765,407);
            FlxG.state.add(this.untitled_folder);
            this.untitled_folder.alpha = 0;

            this.selfie_folder = new GameObject(new DHPoint(_screen.screenWidth * .2, _screen.screenHeight * .1));
            this.selfie_folder.loadGraphic(ImgSelfies,false,false,769,411);
            FlxG.state.add(this.selfie_folder);
            this.selfie_folder.alpha = 0;

            this.selfie_folder_sprite = new GameObject(new DHPoint(_screen.screenWidth * .88, _screen.screenHeight * .09));
            this.selfie_folder_sprite.makeGraphic(150, 100, 0x00ff0000);
            add(this.selfie_folder_sprite);

            this.untitled_folder_sprite = new GameObject(new DHPoint(_screen.screenWidth * .84, _screen.screenHeight * .09));
            this.untitled_folder_sprite.makeGraphic(150, 100, 0x00ff0000);
            add(this.untitled_folder_sprite);

            var that:Desktop = this;
            this.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    that.selfie_folder_sprite.y = event.userData['bg'].height * .15;
                    that.untitled_folder_sprite.y = event.userData['bg'].height * .35;
                    FlxG.stage.removeEventListener(
                        GameState.EVENT_SINGLETILE_BG_LOADED,
                        arguments.callee
                    );
                });


            SoundManager.getInstance().playSound(SFXRoomTone, 0, null, true, 1, Math.random()*2938+93082, Desktop.ROOMTONE);
        }

        override public function update():void{
            super.update();

            if(FlxG.mouse.justPressed()) {
                var _screen:ScreenManager = ScreenManager.getInstance();
                var untitled_folder_rect:FlxRect = new FlxRect(
                    this.untitled_folder_sprite.x, this.untitled_folder_sprite.y,
                    this.untitled_folder_sprite.width,
                    this.untitled_folder_sprite.height);
                var selfie_folder_rect:FlxRect = new FlxRect(
                    this.selfie_folder_sprite.x, this.selfie_folder_sprite.y,
                    this.selfie_folder_sprite.width,
                    this.selfie_folder_sprite.height);
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
        }
    }
}
