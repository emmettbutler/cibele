package com.starmaid.Cibele.states {
    import com.starmaid.Cibele.utils.DataEvent;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameSound;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class Desktop extends GameState {
        [Embed(source="/../assets/images/ui/Screenshot.png")] private var ImgScreenshot:Class;
        [Embed(source="/../assets/audio/effects/sfx_roomtone.mp3")] private var SFXRoomTone:Class;
        [Embed(source="/../assets/images/ui/UI_pink_x.png")] private var ImgInboxXPink:Class;
        //desktop selfi/e folder assets
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/selfies_folder.png")] private var ImgSelfiesFolder:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/pics_icon.png")] private var ImgSelfiesFolderPicsIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/me1_icon.png")] private var ImgSelfiesFolderMe1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/me1.png")] private var ImgSelfiesFolderMe1:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/pictures_folder.png")] private var ImgPicturesFolder:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/forichi_icon.png")] private var ImgPicturesFolderForIchiIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/forum_icon.png")] private var ImgPicturesFolderForumIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/friends_icon.png")] private var ImgPicturesFolderFriendsIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/forichi.png")] private var ImgPicturesFolderForIchi:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/forum.png")] private var ImgPicturesFolderForum:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/friends.png")] private var ImgPicturesFolderFriends:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/untitled.png")] private var ImgUntitledFolder:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/kawaiitxticon.png")] private var ImgUntitledFolderKawaiiIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/partypoem1icon.png")] private var ImgUntitledFolderPartyPoem1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/partypoem1.png")] private var ImgUntitledFolderPartyPoem1:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/kawaii.png")] private var ImgUntitledFolderKawaii:Class;

        public var bg:GameObject, folder_structure:Object, leafPopups:Array;
        public var folder_builder:FolderBuilder;

        public static var ROOMTONE:String = "desktop room tone";

        public function Desktop() {
            super(true, true, false);
            this.showEmoji = false;
        }

        override public function create():void {
            super.create();
            this.ui_color_flag = GameState.UICOLOR_PINK;
            this.use_loading_screen = false;
            FlxG.bgColor = 0x00000000;
            (new BackgroundLoader()).loadSingleTileBG("/../assets/images/ui/UI_Desktop.png");
            ScreenManager.getInstance().setupCamera(null, 1);
            var _screen:ScreenManager = ScreenManager.getInstance();
            this.leafPopups = new Array();

            /*
              Directory tree definition

              folder_img: The container image ("finder window")
              folder_dim: the dimensions of folder_img in pixels
              hitbox_pos: For toplevel folders, the position of the hitbox
                to draw on the screen. The x coordinate is an absolute number,
                and the y coordinate is a value to multiply _screen.screenHeight
                by after load
              name: human-readable name for debugging
              contents: if this node is a folder, an array of nodes representing
                its contents (folders and popups). If this node is a popup,
                the image to show when it is opened
              icon: the folder or popup icon to display for this node
              icon_dim: the dimensions in pixels of the icon
              icon_pos: the position of the icon relative to the folder window sprite
              dim: the dimensions of the full node image
             */
            folder_structure = {"contents": [
                {
                    "folder_img": ImgSelfiesFolder,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .87, _screen.screenHeight * .12),
                    "hitbox_dim": new DHPoint(150, 100),
                    "name": "selfies",
                    "contents": [
                        {
                            "name": "img_me_1",
                            "icon": ImgSelfiesFolderMe1Icon,
                            "icon_dim": new DHPoint(70, 81),
                            "icon_pos": new DHPoint(149, 31),
                            "dim": new DHPoint(530, 356),
                            "contents": ImgSelfiesFolderMe1
                        },
                        {
                            "name": "pics_subfolder",
                            "icon": ImgSelfiesFolderPicsIcon,
                            "icon_dim": new DHPoint(87, 79),
                            "icon_pos": new DHPoint(31, 35),
                            "folder_img": ImgPicturesFolder,
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
                        }
                    ]
                },
                {
                    "name": "screenshot",
                    "folder_img": ImgScreenshot,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .72, _screen.screenHeight * .07),
                    "hitbox_dim": new DHPoint(150, 100),
                    "contents": []
                },
                {
                    "name": "untitled",
                    "folder_img": ImgUntitledFolder,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .84, _screen.screenHeight * .33),
                    "hitbox_dim": new DHPoint(150, 100),
                    "contents": [
                        {
                            "name": "kawaii",
                            "icon": ImgUntitledFolderKawaiiIcon,
                            "icon_dim": new DHPoint(76, 82),
                            "icon_pos": new DHPoint(27, 36),
                            "dim": new DHPoint(631, 356),
                            "contents": ImgUntitledFolderKawaii
                        },
                        {
                            "name": "partypoem1",
                            "icon": ImgUntitledFolderPartyPoem1Icon,
                            "icon_dim": new DHPoint(96, 84),
                            "icon_pos": new DHPoint(129, 36),
                            "dim": new DHPoint(631, 356),
                            "contents": ImgUntitledFolderPartyPoem1
                        },
                    ]
                }
            ]};

            this.folder_builder = new FolderBuilder();
            this.folder_builder.populateFolders(folder_structure);
            this.folder_builder.setUpLeafPopups();

            super.postCreate();

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
                this.folder_builder.resolveClick(this.folder_structure,
                    new FlxRect(FlxG.mouse.x, FlxG.mouse.y));
            }
        }
    }
}
