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
                    "folder_img": ImgSelfiesFolder,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .87, .15),
                    "hitbox_dim": new DHPoint(150, 100),
                    "name": "selfies",
                    "contents": [
                        {
                            "name": "pics_subfolder",
                            "icon": ImgSelfiesFolderPicsIcon,
                            "icon_dim": new DHPoint(87, 79),
                            "icon_pos": new DHPoint(31, 35),
                            "folder_img": ImgSelfiesFolder,
                            "folder_dim": new DHPoint(631, 356),
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

            var that:Desktop = this;
            this.addEventListener(GameState.EVENT_SINGLETILE_BG_LOADED,
                function(event:DataEvent):void {
                    var cur:Object;
                    for (var i:int = 0; i < that.folder_structure["contents"].length; i++) {
                        cur = that.folder_structure["contents"][i];
                        cur["hitbox_sprite"].y = event.userData['bg'].height * cur["hitbox_pos"].y;
                    }
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
                var mouse_rect:FlxRect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y);

                var hitbox_rect:FlxRect, folder_rect:FlxRect, cur:Object;
                for (var i:int = 0; i < this.folder_structure["contents"].length; i++) {
                    cur = this.folder_structure["contents"][i];
                    hitbox_rect = new FlxRect(cur["hitbox_sprite"].x, cur["hitbox_sprite"].y,
                                              cur["hitbox_sprite"].width, cur["hitbox_sprite"].height);
                    folder_rect = new FlxRect(cur["folder_sprite"].x, cur["folder_sprite"].y,
                                              cur["folder_sprite"].width, cur["folder_sprite"].height);
                    if ((cur["folder_sprite"].visible && mouse_rect.overlaps(folder_rect)) ||
                        mouse_rect.overlaps(hitbox_rect))
                    {
                        cur["folder_sprite"].visible = true;
                    } else {
                        cur["folder_sprite"].visible = false;
                    }
                }
            }
        }

        public function populateFolders(root:Object):void {
            var cur:Object, spr:GameObject, icon_pos:DHPoint;
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];
                if ("icon" in cur && cur["icon"] != null) {
                    spr = new GameObject(cur["icon_pos"].add(root["folder_sprite"].pos));
                    spr.loadGraphic(cur["icon"], false, false, cur["icon_dim"].x, cur["icon_dim"].y);
                    spr.visible = false;
                    FlxG.state.add(spr);
                    cur["icon_sprite"] = spr;
                }
                if("hitbox_pos" in cur && "hitbox_dim" in cur) {
                    spr = new GameObject(new DHPoint(cur["hitbox_pos"].x, 0));
                    spr.makeGraphic(cur["hitbox_dim"].x, cur["hitbox_dim"].y, 0xaaff0000);
                    FlxG.state.add(spr);
                    cur["hitbox_sprite"] = spr;
                }
                if (cur["contents"] is Array) {
                    spr = new GameObject(new DHPoint(0, 0));
                    spr.loadGraphic(cur["folder_img"], false, false, cur["folder_dim"].x, cur["folder_dim"].y);
                    spr.visible = false;
                    FlxG.state.add(spr);
                    cur["folder_sprite"] = spr;

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
