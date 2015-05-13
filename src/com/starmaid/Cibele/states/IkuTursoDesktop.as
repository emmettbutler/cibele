package com.starmaid.Cibele.states {
    import org.flixel.*;
    import com.starmaid.Cibele.base.GameState;
    import flash.utils.Dictionary;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.FolderBuilder;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;

    public class IkuTursoDesktop extends Desktop {
        [Embed(source="/../assets/images/ui/Screenshot.png")] private var ImgScreenshot:Class;
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
        [Embed(source="/../assets/images/ui/popups/eu_files/hsfolder.png")] private var ImgHSFolderIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/highschool.png")] private var ImgHSFolder:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bed_icon.png")] private var ImgBedIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bed.png")] private var ImgBed:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/cutewow.png")] private var ImgCuteWow:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/cutewow_icon.png")] private var ImgCuteWowIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/old_icon.png")] private var ImgOldIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/old.png")] private var ImgOld:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/ollld_icon.png")] private var ImgOllldIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/ollld.png")] private var ImgOllld:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/tired.png")] private var ImgTired:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/tired_icon.png")] private var ImgTiredIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/winterlooks.png")] private var ImgWinterLooks:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/winterlooks_icon.png")] private var ImgWinterLooksIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/mom.png")] private var ImgMom:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/mom_icon.png")] private var ImgMomIcon:Class;

        public function IkuTursoDesktop() {
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_IT;
        }

        override public function create():void {
            super.create();
            ScreenManager.getInstance().setupCamera(null, 1);
            var _screen:ScreenManager = ScreenManager.getInstance();

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
                    "name": "selfies folder stuff",
                    "contents": [
                        {
                            "name": "forichi",
                            "icon": ImgPicturesFolderForIchiIcon,
                            "icon_dim": new DHPoint(70, 84),
                            "icon_pos": new DHPoint(144, 32),
                            "dim": new DHPoint(530, 356),
                            "contents": ImgPicturesFolderForIchi
                        },
                        {
                            "name": "winterlooks",
                            "icon": ImgWinterLooksIcon,
                            "icon_dim": new DHPoint(70, 84),
                            "icon_pos": new DHPoint(230, 32),
                            "dim": new DHPoint(512, 356),
                            "contents": ImgWinterLooks
                        },
                        {
                            "name": "tired",
                            "icon": ImgTiredIcon,
                            "icon_dim": new DHPoint(70, 84),
                            "icon_pos": new DHPoint(320, 32),
                            "dim": new DHPoint(530, 356),
                            "contents": ImgTired
                        },
                        {
                            "name": "mom",
                            "icon": ImgMomIcon,
                            "icon_dim": new DHPoint(70, 81),
                            "icon_pos": new DHPoint(410, 32),
                            "dim": new DHPoint(456, 356),
                            "contents": ImgMom
                        },
                        {
                            "name": "hs_subfolder",
                            "icon": ImgHSFolderIcon,
                            "icon_dim": new DHPoint(87, 79),
                            "icon_pos": new DHPoint(31, 35),
                            "folder_img": ImgHSFolder,
                            "folder_dim": new DHPoint(631, 356),
                            "contents": [
                                {
                                    "name": "cutewow",
                                    "icon": ImgCuteWowIcon,
                                    "icon_dim": new DHPoint(81, 93),
                                    "icon_pos": new DHPoint(120, 33),
                                    "dim": new DHPoint(530, 356),
                                    "contents": ImgCuteWow
                                },
                                {
                                    "name": "bed",
                                    "icon": ImgBedIcon,
                                    "icon_dim": new DHPoint(77, 94),
                                    "icon_pos": new DHPoint(30, 33),
                                    "dim": new DHPoint(530, 356),
                                    "contents": ImgBed
                                },
                                {
                                    "name": "old",
                                    "icon": ImgOldIcon,
                                    "icon_dim": new DHPoint(80, 93),
                                    "icon_pos": new DHPoint(213, 33),
                                    "dim": new DHPoint(530, 356),
                                    "contents": ImgOld
                                },
                                {
                                    "name": "ollld",
                                    "icon": ImgOllldIcon,
                                    "icon_dim": new DHPoint(84, 95),
                                    "icon_pos": new DHPoint(306, 33),
                                    "dim": new DHPoint(530, 356),
                                    "contents": ImgOllld
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

        }

        override public function update():void{
            super.update();
        }
    }
}
