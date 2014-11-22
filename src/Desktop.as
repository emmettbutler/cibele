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

        public var bg:GameObject, folder_structure:Object;

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
                },
                {
                    "name": "screenshot",
                    "folder_img": ImgScreenshot,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .72, .09),
                    "hitbox_dim": new DHPoint(150, 100),
                    "contents": []
                },
                {
                    "name": "untitled",
                    "folder_img": ImgSelfiesFolder,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .84, .35),
                    "hitbox_dim": new DHPoint(150, 100),
                    "contents": []
                }
            ]};

            super.postCreate();

            this.populateFolders(folder_structure);

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

        public function getHitboxKey(obj:Object):String {
            if ("icon_sprite" in obj) {
                return "icon_sprite";
            }
            return "hitbox_sprite";
        }

        public function setIconVisibility(node:Object, vis:Boolean):void {
            var cur_icon:Object;
            for (var k:int = 0; k < node["contents"].length; k++) {
                cur_icon = node["contents"][k];
                if ("icon_sprite" in cur_icon) {
                    cur_icon["icon_sprite"].visible = vis;
                }
            }
        }

        public function resolveClick(root:Object, mouse_rect:FlxRect, parent:Object=null):void {
            var spr:GameObject, icon_pos:DHPoint, full_rect:FlxRect, hitbox_key:String;
            var hitbox_rect:FlxRect, folder_rect:FlxRect, cur:Object, cur_icon:Object;
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];

                if (cur["contents"] is Array) {
                    hitbox_key = this.getHitboxKey(cur);
                    hitbox_rect = cur[hitbox_key]._getRect();
                    if (cur["folder_sprite"].visible) {
                        if (!mouse_rect.overlaps(cur["folder_sprite"]._getRect()) &&
                            !mouse_rect.overlaps(hitbox_rect))
                        {
                            cur["folder_sprite"].visible = false;
                            this.setIconVisibility(cur, false);
                        }
                        this.resolveClick(cur, mouse_rect);
                    } else if (mouse_rect.overlaps(hitbox_rect)){
                        this.setIconVisibility(root, false);
                        cur["folder_sprite"].visible = true;
                        this.setIconVisibility(cur, true);
                    }
                } else {
                    full_rect = cur["full_sprite"]._getRect();
                    // clicking on a leaf or its icon - show it
                    if ((cur["full_sprite"].visible && mouse_rect.overlaps(full_rect)) ||
                        (mouse_rect.overlaps(cur["icon_sprite"]._getRect()) &&
                        cur["icon_sprite"].visible))
                    {
                        this.setIconVisibility(root, false);
                        cur["full_sprite"].visible = true;
                    // clicking not on a leaf or its icon
                    } else {
                        folder_rect = root["folder_sprite"]._getRect();
                        if (cur["full_sprite"].visible && !mouse_rect.overlaps(full_rect)) {
                            if(root["folder_sprite"].visible) {
                                this.setIconVisibility(root, mouse_rect.overlaps(folder_rect));
                            }
                        }
                        cur["full_sprite"].visible = false;
                    }
                }
            }
        }

        override public function update():void{
            super.update();

            if(FlxG.mouse.justPressed()) {
                var _screen:ScreenManager = ScreenManager.getInstance();
                var mouse_rect:FlxRect = new FlxRect(FlxG.mouse.x, FlxG.mouse.y);

                this.resolveClick(this.folder_structure, mouse_rect);
            }
        }

        public function populateFolders(root:Object):void {
            var _screen:ScreenManager = ScreenManager.getInstance();
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
                    spr.makeGraphic(cur["hitbox_dim"].x, cur["hitbox_dim"].y, 0x00ff0000);
                    FlxG.state.add(spr);
                    cur["hitbox_sprite"] = spr;
                }
                if (cur["contents"] is Array) {
                    spr = new GameObject(new DHPoint(_screen.screenWidth * .3, _screen.screenHeight * .2));
                    spr.loadGraphic(cur["folder_img"], false, false, cur["folder_dim"].x, cur["folder_dim"].y);
                    spr.visible = false;
                    FlxG.state.add(spr);
                    cur["folder_sprite"] = spr;

                    this.populateFolders(cur);
                } else {
                    spr = new GameObject(new DHPoint(_screen.screenWidth * .3, _screen.screenHeight * .2));
                    spr.loadGraphic(cur["contents"], false, false, cur["dim"].x, cur["dim"].y);
                    spr.visible = false;
                    FlxG.state.add(spr);
                    cur["full_sprite"] = spr;
                }
            }
        }
    }
}
