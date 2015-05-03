package com.starmaid.Cibele.states {
    import org.flixel.*;
    import com.starmaid.Cibele.base.GameState;
    import flash.utils.Dictionary;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.FolderBuilder;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.PopUpManager;

    public class HiisiDesktop extends Desktop {
        [Embed(source="/../assets/images/ui/Screenshot.png")] private var ImgScreenshot:Class;
        [Embed(source="/../assets/images/ui/UI_pink_x.png")] private var ImgInboxXPink:Class;
        //desktop selfi/e folder assets
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/selfies_folder.png")] private var ImgSelfiesFolder:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/pics_icon.png")] private var ImgSelfiesFolderPicsIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/pictures_folder.png")] private var ImgPicturesFolder:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/untitled.png")] private var ImgUntitledFolder:Class;

        [Embed(source="/../assets/images/ui/popups/hi_desktop/blake_beach.png")] private var ImgBlakeBeach:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/blake_beach_icon.png")] private var ImgBlakeBeachIcon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/blake1.png")] private var ImgBlake1:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/blake1_icon.png")] private var ImgBlake1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/blake2.png")] private var ImgBlake2:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/blake2_icon.png")] private var ImgBlake2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/blake3.png")] private var ImgBlake3:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/blake3_icon.png")] private var ImgBlake3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/puppy.png")] private var ImgPuppy:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/puppy_icon.png")] private var ImgPuppyIcon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/hw1.png")] private var ImgHW1:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/hw1_icon.png")] private var ImgHW1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina1.png")] private var ImgNina1:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina1_icon.png")] private var ImgNina1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/blog_draft_21.png")] private var ImgBlogDraft21:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/blog_draft_21_icon.png")] private var ImgBlogDraft21Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/bow.png")] private var ImgBow:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/bow_icon.png")] private var ImgBowIcon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina2.png")] private var ImgNina2:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina2_icon.png")] private var ImgNina2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina3.png")] private var ImgNina3:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina3_icon.png")] private var ImgNina3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina4.png")] private var ImgNina4:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina4_icon.png")] private var ImgNina4Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina5.png")] private var ImgNina5:Class;
        [Embed(source="/../assets/images/ui/popups/hi_desktop/nina5_icon.png")] private var ImgNina5Icon:Class;

        public function HiisiDesktop() {
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_HI;
        }

        override public function create():void {
            super.create();
            ScreenManager.getInstance().setupCamera(null, 1);
            var _screen:ScreenManager = ScreenManager.getInstance();

            PopUpManager.getInstance().setOpeningPopups(PopUpManager.EMPTY_INBOX, PopUpManager.HI_SELFIE_DC, PopUpManager.HI_PICLY_DEF);

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
                            "name": "nina1",
                            "icon": ImgNina1Icon,
                            "icon_dim": new DHPoint(70, 82),
                            "icon_pos": new DHPoint(149, 31),
                            "dim": new DHPoint(479, 356),
                            "contents": ImgNina1
                        },
                        {
                            "name": "nina2",
                            "icon": ImgNina2Icon,
                            "icon_dim": new DHPoint(70, 84),
                            "icon_pos": new DHPoint(239, 31),
                            "dim": new DHPoint(384, 310),
                            "contents": ImgNina2
                        },
                        {
                            "name": "nina3",
                            "icon": ImgNina3Icon,
                            "icon_dim": new DHPoint(70, 82),
                            "icon_pos": new DHPoint(327, 31),
                            "dim": new DHPoint(336, 448),
                            "contents": ImgNina3
                        },
                        {
                            "name": "nina4",
                            "icon": ImgNina4Icon,
                            "icon_dim": new DHPoint(78, 82),
                            "icon_pos": new DHPoint(410, 31),
                            "dim": new DHPoint(336, 448),
                            "contents": ImgNina4
                        },
                        {
                            "name": "nina5",
                            "icon": ImgNina5Icon,
                            "icon_dim": new DHPoint(70, 81),
                            "icon_pos": new DHPoint(31, 130),
                            "dim": new DHPoint(384, 310),
                            "contents": ImgNina5
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
                                    "name": "blake beach",
                                    "icon": ImgBlakeBeachIcon,
                                    "icon_dim": new DHPoint(73, 82),
                                    "icon_pos": new DHPoint(30, 32),
                                    "dim": new DHPoint(512, 327),
                                    "contents": ImgBlakeBeach
                                },
                                {
                                    "name": "blake1",
                                    "icon": ImgBlake1Icon,
                                    "icon_dim": new DHPoint(70, 81),
                                    "icon_pos": new DHPoint(124, 32),
                                    "dim": new DHPoint(479, 356),
                                    "contents": ImgBlake1
                                },
                                {
                                    "name": "blake2",
                                    "icon": ImgBlake2Icon,
                                    "icon_dim": new DHPoint(70, 84),
                                    "icon_pos": new DHPoint(225, 32),
                                    "dim": new DHPoint(479, 356),
                                    "contents": ImgBlake2
                                },
                                {
                                    "name": "blake3",
                                    "icon": ImgBlake3Icon,
                                    "icon_dim": new DHPoint(76, 84),
                                    "icon_pos": new DHPoint(124, 132),
                                    "dim": new DHPoint(384, 310),
                                    "contents": ImgBlake3
                                },
                                {
                                    "name": "puppy",
                                    "icon": ImgPuppyIcon,
                                    "icon_dim": new DHPoint(70, 83),
                                    "icon_pos": new DHPoint(30, 132),
                                    "dim": new DHPoint(512, 356),
                                    "contents": ImgPuppy
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
                            "name": "hw1",
                            "icon": ImgHW1Icon,
                            "icon_dim": new DHPoint(70, 83),
                            "icon_pos": new DHPoint(27, 36),
                            "dim": new DHPoint(594, 453),
                            "contents": ImgHW1
                        },
                        {
                            "name": "blog draft 21",
                            "icon": ImgBlogDraft21Icon,
                            "icon_dim": new DHPoint(100, 93),
                            "icon_pos": new DHPoint(115, 36),
                            "dim": new DHPoint(631, 356),
                            "contents": ImgBlogDraft21
                        },
                        {
                            "name": "bow",
                            "icon": ImgBowIcon,
                            "icon_dim": new DHPoint(70, 81),
                            "icon_pos": new DHPoint(220, 36),
                            "dim": new DHPoint(384, 310),
                            "contents": ImgBow
                        }
                    ]
                }
            ]};

            this.folder_builder = new FolderBuilder();
            this.folder_builder.populateFolders(folder_structure);
            this.folder_builder.setUpLeafPopups();

        }

        override public function update():void{
            super.update();
        }
    }
}