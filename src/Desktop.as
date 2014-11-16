package{
    import org.flixel.*;
    import flash.utils.Dictionary;

    public class Desktop extends GameState {
        [Embed(source="../assets/untitledfolder.png")] private var ImgFolder:Class;
        [Embed(source="../assets/Screenshot.png")] private var ImgScreenshot:Class;
        [Embed(source="../assets/sfx_roomtone.mp3")] private var SFXRoomTone:Class;
        //desktop selfie folder assets
        [Embed(source="../assets/popups/selfiedesktop/selfies_folder.png")] private var ImgSelfiesFolder:Class;
        [Embed(source="../assets/popups/selfiedesktop/pics_icon.png")] private var ImgSelfiesFolderPicsIcon:Class;
        [Embed(source="../assets/popups/selfiedesktop/me1_icon.png")] private var ImgSelfiesFolderMe1Icon:Class;
        [Embed(source="../assets/popups/selfiedesktop/me1.png")] private var ImgSelfiesFolderMe1:Class;
        [Embed(source="../assets/popups/selfiedesktop/pictures_folder.png")] private var ImgPicturesFolder:Class;
        [Embed(source="../assets/popups/selfiedesktop/forichi_icon.png")] private var ImgPicturesFolderForIchiIcon:Class;
        [Embed(source="../assets/popups/selfiedesktop/forum_icon.png")] private var ImgPicturesFolderForumIcon:Class;
        [Embed(source="../assets/popups/selfiedesktop/friends_icon.png")] private var ImgPicturesFolderFriendsIcon:Class;
        [Embed(source="../assets/popups/selfiedesktop/forichi.png")] private var ImgPicturesFolderForIchi:Class;
        [Embed(source="../assets/popups/selfiedesktop/forum.png")] private var ImgPicturesFolderForum:Class;
        [Embed(source="../assets/popups/selfiedesktop/friends.png")] private var ImgPicturesFolderFriends:Class;

        public var bg:GameObject;
        public var img_height:Number = 357;
        public var selfie_folder:GameObject, untitled_folder:GameObject,
                   screenshot_popup:GameObject, selfie_folder_hitbox:GameObject;

        public var folder_structure:Object,
                   untitled_folder_sprite:GameObject,
                   screenshot_popup_hitbox:GameObject;

        public static const FOLDER:Number = -1;
        public static const FOLDER_SIZE_AND_POS:Number = -2;
        public static const ICONS:Number = 0;
        public static const ICONS_POS:Number = 1;
        public static const ICONS_SIZE:Number = 5;
        public static const ICONS_OPEN:Number = 7;
        public static const FOLDER_GAME_OBJECT:Number = 10;

        public static const SUBFOLDER:Number = 2;
        public static const SUBFOLDER_SIZE_AND_POS:Number = -3;
        public static const SUBFOLDER_ICONS:Number = 3;
        public static const SUBFOLDER_ICONS_POS:Number = 4;
        public static const SUBFOLDER_ICONS_SIZE:Number = 6;
        public static const SUBFOLDER_ICONS_OPEN:Number = 8;
        public static const SUBFOLDER_GAME_OBJECT:Number = 11;

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

            folder_structure = {"contents": [
                {
                    "icon": ImgSelfiesFolder,
                    "name": "selfies",
                    "icon_dim": new DHPoint(631, 356),
                    "icon_pos": new DHPoint(_screen.screenWidth * .88, _screen.screenHeight * .09),
                    "contents": [
                        {
                            "name": "pics_subfolder",
                            "icon": ImgSelfiesFolderPicsIcon,
                            "icon_dim": new DHPoint(87, 79),
                            "icon_pos": new DHPoint(31, 35),
                            "contents": [
                                {
                                    "name": "forum",
                                    "icon": ImgPicturesFolderForumIcon,
                                    "icon_dim": new DHPoint(70, 85),
                                    "icon_pos": new DHPoint(30, 32),
                                    "dim": new DHPoint(530, 356),
                                    "contents": ImgPicturesFolderForum
                                },
                                {
                                    "name": "forichi",
                                    "icon": ImgPicturesFolderForIchiIcon,
                                    "icon_dim": new DHPoint(70, 84),
                                    "icon_pos": new DHPoint(124, 32),
                                    "dim": new DHPoint(530, 356),
                                    "contents": ImgPicturesFolderForIchi
                                },
                                {
                                    "name": "friends",
                                    "icon": ImgPicturesFolderFriendsIcon,
                                    "icon_dim": new DHPoint(70, 85),
                                    "icon_pos": new DHPoint(225, 32),
                                    "dim": new DHPoint(488, 356),
                                    "contents": ImgPicturesFolderFriends
                                }
                            ]
                        },
                        {
                            "name": "img_me_1",
                            "icon": ImgSelfiesFolderMe1Icon,
                            "icon_dim": new DHPoint(70, 81),
                            "icon_pos": new DHPoint(149, 31),
                            "dim": new DHPoint(530, 356),
                            "contents": ImgSelfiesFolderMe1
                        }
                    ]
                }
            ]};

            super.postCreate();

            this.populateFolders(folder_structure);

            this.untitled_folder = new GameObject(new DHPoint(_screen.screenWidth * .2, _screen.screenHeight * .1));
            this.untitled_folder.loadGraphic(ImgFolder,false,false,631,356);
            FlxG.state.add(this.untitled_folder);
            this.untitled_folder.visible = false;

            this.screenshot_popup = new GameObject(new DHPoint(_screen.screenWidth * .2, _screen.screenHeight * .1));
            this.screenshot_popup.loadGraphic(ImgScreenshot,false,false,631,356);
            FlxG.state.add(this.screenshot_popup);
            this.screenshot_popup.visible = false;

            this.selfie_folder_hitbox = new GameObject(new DHPoint(_screen.screenWidth * .87, 0));
            this.selfie_folder_hitbox.makeGraphic(150, 100, 0x00ff0000);
            add(this.selfie_folder_hitbox);

            this.untitled_folder_sprite = new GameObject(new DHPoint(_screen.screenWidth * .84, _screen.screenHeight * .09));
            this.untitled_folder_sprite.makeGraphic(150, 100, 0x00ff0000);
            add(this.untitled_folder_sprite);

            this.screenshot_popup_hitbox = new GameObject(new DHPoint(_screen.screenWidth * .72, _screen.screenHeight * .09));
            this.screenshot_popup_hitbox.makeGraphic(150, 100, 0x00ff0000);
            add(this.screenshot_popup_hitbox);

            var that:Desktop = this;
            this.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    that.selfie_folder_hitbox.y = event.userData['bg'].height * .15;
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
                    this.selfie_folder_hitbox.x, this.selfie_folder_hitbox.y,
                    this.selfie_folder_hitbox.width,
                    this.selfie_folder_hitbox.height);
                var screenshot_popup_rect:FlxRect = new FlxRect(
                    this.screenshot_popup_hitbox.x, this.screenshot_popup_hitbox.y,
                    this.screenshot_popup_hitbox.width,
                    this.screenshot_popup_hitbox.height);
                var mouse_rect:FlxRect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y);

                if (selfie_folder_hitbox.visible) {
                } else if (untitled_folder.visible) {
                } else if (screenshot_popup.visible) {
                }

                if(mouse_rect.overlaps(untitled_folder_rect)) {
                    screenshot_popup.visible = false;
                    selfie_folder_hitbox.visible = false;
                    untitled_folder.visible = !untitled_folder.visible;
                } else if(mouse_rect.overlaps(selfie_folder_rect)) {
                    untitled_folder.visible = false;
                    screenshot_popup.visible = false;
                    selfie_folder_hitbox.visible = !selfie_folder.visible;
                } else if(mouse_rect.overlaps(screenshot_popup_rect)) {
                    untitled_folder.visible = false;
                    selfie_folder_hitbox.visible = false;
                    screenshot_popup.visible = !screenshot_popup.visible;
                } else {
                    if(!clickIn(untitled_folder) &&
                        !clickIn(selfie_folder_hitbox) &&
                        !clickIn(screenshot_popup))
                    {
                        untitled_folder.visible = false;
                        selfie_folder_hitbox.visible = false;
                        screenshot_popup.visible = false;
                    }
                }
            }
        }

        public function clickIn(spr:GameObject):Boolean {
            var rect:FlxRect = new FlxRect(spr.x, spr.y, spr.width, spr.height);
            var mouse_rect:FlxRect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y);
            return spr.visible && mouse_rect.overlaps(rect);
        }

        public function populateFolders(root:Object):void {
            var cur:Object, spr:GameObject;
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];
                spr = new GameObject(new DHPoint(0, 0));
                spr.loadGraphic(cur["icon"], false, false, cur["icon_dim"].x, cur["icon_dim"].y);
                spr.visible = false;
                FlxG.state.add(spr);
                cur["icon_sprite"] = spr;
                if (cur["contents"] is Array) {
                    this.populateFolders(cur);
                } else {
                    spr = new GameObject(new DHPoint(0, 0));
                    spr.loadGraphic(cur["contents"], false, false, cur["dim"].x, cur["dim"].y);
                    spr.visible = false;
                    FlxG.state.add(spr);
                    cur["full_sprite"] = spr;
                }
            }
        }
    }
}
