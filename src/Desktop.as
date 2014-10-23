package{
    import org.flixel.*;

    public class Desktop extends GameState {
        [Embed(source="../assets/selfiedesktop.png")] private var ImgSelfies:Class;
        [Embed(source="../assets/untitledfolder.png")] private var ImgFolder:Class;
        [Embed(source="../assets/Screenshot.png")] private var ImgScreenshot:Class;
        [Embed(source="../assets/sfx_roomtone.mp3")] private var SFXRoomTone:Class;

        public var bg:GameObject;
        public var img_height:Number = 357;
        public var selfie_folder:GameObject, untitled_folder:GameObject,
                   screenshot_popup:GameObject;

        public var selfie_folder_sprite:GameObject,
                   untitled_folder_sprite:GameObject,
                   screenshot_popup_hitbox:GameObject;

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
            this.untitled_folder.loadGraphic(ImgFolder,false,false,631,356);
            FlxG.state.add(this.untitled_folder);
            this.untitled_folder.visible = false;

            this.selfie_folder = new GameObject(new DHPoint(_screen.screenWidth * .2, _screen.screenHeight * .1));
            this.selfie_folder.loadGraphic(ImgSelfies,false,false,631,356);
            FlxG.state.add(this.selfie_folder);
            this.selfie_folder.visible = false;

            this.screenshot_popup = new GameObject(new DHPoint(_screen.screenWidth * .2, _screen.screenHeight * .1));
            this.screenshot_popup.loadGraphic(ImgScreenshot,false,false,631,356);
            FlxG.state.add(this.screenshot_popup);
            this.screenshot_popup.visible = false;

            this.selfie_folder_sprite = new GameObject(new DHPoint(_screen.screenWidth * .88, _screen.screenHeight * .09));
            this.selfie_folder_sprite.makeGraphic(150, 100, 0x00ff0000);
            add(this.selfie_folder_sprite);

            this.untitled_folder_sprite = new GameObject(new DHPoint(_screen.screenWidth * .84, _screen.screenHeight * .09));
            this.untitled_folder_sprite.makeGraphic(150, 100, 0x00ff0000);
            add(this.untitled_folder_sprite);

            this.screenshot_popup_hitbox = new GameObject(new DHPoint(_screen.screenWidth * .72, _screen.screenHeight * .09));
            this.screenshot_popup_hitbox.makeGraphic(150, 100, 0x00ff0000);
            add(this.screenshot_popup_hitbox);

            var that:Desktop = this;
            this.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    that.selfie_folder_sprite.y = event.userData['bg'].height * .15;
                    that.untitled_folder_sprite.y = event.userData['bg'].height * .35;
                    that.screenshot_popup_hitbox.y = event.userData['bg'].height * .1;
                    FlxG.stage.removeEventListener(
                        GameState.EVENT_SINGLETILE_BG_LOADED,
                        arguments.callee
                    );
                });

            SoundManager.getInstance().clearSoundsByType(GameSound.BGM);
            SoundManager.getInstance().clearSoundsByType(GameSound.SFX);
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
                var screenshot_popup_rect:FlxRect = new FlxRect(
                    this.screenshot_popup_hitbox.x, this.screenshot_popup_hitbox.y,
                    this.screenshot_popup_hitbox.width,
                    this.screenshot_popup_hitbox.height);
                var mouse_rect:FlxRect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y);

                if(mouse_rect.overlaps(untitled_folder_rect)) {
                    screenshot_popup.visible = false;
                    selfie_folder.visible = false;
                    untitled_folder.visible = !untitled_folder.visible;
                } else if(mouse_rect.overlaps(selfie_folder_rect)) {
                    untitled_folder.visible = false;
                    screenshot_popup.visible = false;
                    selfie_folder.visible = !selfie_folder.visible;
                } else if(mouse_rect.overlaps(screenshot_popup_rect)) {
                    untitled_folder.visible = false;
                    selfie_folder.visible = false;
                    screenshot_popup.visible = !screenshot_popup.visible;
                } else {
                    untitled_folder.visible = false;
                    selfie_folder.visible = false;
                    screenshot_popup.visible = false;
                }
            }
        }
    }
}
