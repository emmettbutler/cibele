package com.starmaid.Cibele.states {
    import org.flixel.*;
    import com.starmaid.Cibele.base.GameState;
    import flash.utils.Dictionary;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.FolderBuilder;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.ScreenManager;

    public class IkuTursoDesktop extends Desktop {
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/photocollage.png")] private var ImgScreenshot:Class;
        [Embed(source="/../assets/images/ui/UI_pink_x.png")] private var ImgInboxXPink:Class;
        //desktop selfi/e folder assets
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
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/kawaiitxticon.png")] private var ImgUntitledFolderKawaiiIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/partypoem1icon.png")] private var ImgUntitledFolderPartyPoem1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/partypoem1.png")] private var ImgUntitledFolderPartyPoem1:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/kawaii.png")] private var ImgUntitledFolderKawaii:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/hsfolder.png")] private var ImgHSFolderIcon:Class;
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
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/shots.png")] private var ImgShots:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/shots_icon.png")] private var ImgShotsIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/oldroom.png")] private var ImgOldRoom:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/oldroom_icon.png")] private var ImgOldRoomIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/home.png")] private var ImgHome:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/home_icon.png")] private var ImgHomeIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/prom.png")] private var ImgProm:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/prom_icon.png")] private var ImgPromIcon:Class;

        //old website stuff
        [Embed(source="/../assets/images/ui/popups/it_files/fanart1_icon.png")] private var ImgFanart1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/fanart1.png")] private var ImgFanart1:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/fanart2_icon.png")] private var ImgFanart2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/fanart2.png")] private var ImgFanart2:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/fanart3_icon.png")] private var ImgFanart3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/fanart3.png")] private var ImgFanart3:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/cur_blog_fanart_icon.png")] private var ImgFanartUpdateIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/cur_blog_fanart.png")] private var ImgFanartUpdate:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog1_icon.png")] private var ImgBlog1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog1.png")] private var ImgBlog1:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog5_icon.png")] private var ImgBlog2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog5.png")] private var ImgBlog2:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog4_icon.png")] private var ImgBlog3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog4.png")] private var ImgBlog3:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog2_icon.png")] private var ImgBlog4Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog2.png")] private var ImgBlog4:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog3_icon.png")] private var ImgBlog5Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/blog3.png")] private var ImgBlog5:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/profile_icon.png")] private var ImgProfileIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/profile.png")] private var ImgProfile:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/weblayout_icon.png")] private var ImgLayoutIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/weblayout.png")] private var ImgLayout:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/oldsitefolder_icon.png")] private var ImgOldSiteFolder:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/posts_icon.png")] private var ImgPostsIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/cur_blog_bio.png")] private var ImgHiatus:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/cur_blog_bio_icon.png")] private var ImgHiatusIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/home_folder.png")] private var ImgHomeFolderIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/russelorchard_icon.png")] private var ImgRussellOrchIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/russelorchard.png")] private var ImgRussellOrch:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/cotillion_icon.png")] private var ImgCotillionIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/cotillion.png")] private var ImgCotillion:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/hs_1_icon.png")] private var ImgHS1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/hs_1.png")] private var ImgHS1:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/mycar_icon.png")] private var ImgOldCarIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/mycar.png")] private var ImgOldCar:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/nyc1_icon.png")] private var ImgNYC1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/nyc1.png")] private var ImgNYC1:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/1stday_icon.png")] private var Img1stDayIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/1stday.png")] private var Img1stDay:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/nyc_folder_icon.png")] private var ImgNYCFolderIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/liberty_icon.png")] private var ImgLibertyIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/liberty.png")] private var ImgLiberty:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/newhair_icon.png")] private var ImgNewHairIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/newhair.png")] private var ImgNewHair:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/selfie_5_icon.png")] private var ImgSelfie5Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/selfie_5.png")] private var ImgSelfie5:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/chatlog_feb.png")] private var ImgChatlogFolder:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/chatlog1_icon.png")] private var ImgChatlog1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/chatlog1.png")] private var ImgChatlog1:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/chatlog2_icon.png")] private var ImgChatlog2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/chatlog2.png")] private var ImgChatlog2:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/chatlog3_icon.png")] private var ImgChatlog3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/chatlog3.png")] private var ImgChatlog3:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/desktop_icon.png")] private var ImgDesktopIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/desktop.png")] private var ImgDesktop:Class;

        public function IkuTursoDesktop() {
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_IT;
        }

        override public function create():void {
            this.bgImageName = "UI_Desktop";
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
                    "folder_img": ImgPicturesFolder,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .87, _screen.screenHeight * .08),
                    "hitbox_dim": new DHPoint(300, 250),
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
                            "name": "new hair",
                            "icon": ImgNewHairIcon,
                            "icon_dim": new DHPoint(77, 93),
                            "icon_pos": new DHPoint(31, 145),
                            "dim": new DHPoint(568, 426),
                            "contents": ImgNewHair
                        },
                        {
                            "name": "hs_subfolder",
                            "icon": ImgHSFolderIcon,
                            "icon_dim": new DHPoint(87, 79),
                            "icon_pos": new DHPoint(31, 35),
                            "folder_img": ImgPicturesFolder,
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
                                },
                                {
                                    "name": "shots",
                                    "icon": ImgShotsIcon,
                                    "icon_dim": new DHPoint(83, 89),
                                    "icon_pos": new DHPoint(28, 130),
                                    "dim": new DHPoint(522, 392),
                                    "contents": ImgShots
                                },
                                {
                                    "name": "oldroom",
                                    "icon": ImgOldRoomIcon,
                                    "icon_dim": new DHPoint(79, 92),
                                    "icon_pos": new DHPoint(128, 130),
                                    "dim": new DHPoint(522, 392),
                                    "contents": ImgOldRoom
                                },
                                {
                                    "name": "hs 1",
                                    "icon": ImgHS1Icon,
                                    "icon_dim": new DHPoint(78, 93),
                                    "icon_pos": new DHPoint(228, 132),
                                    "dim": new DHPoint(563, 422),
                                    "contents": ImgHS1
                                }
                            ]
                        }
                    ]
                },
                {
                    "name": "screenshot",
                    "folder_img": ImgScreenshot,
                    "folder_dim": new DHPoint(651, 426),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .72, _screen.screenHeight * .05),
                    "hitbox_dim": new DHPoint(300, 250),
                    "contents": []
                },
                {
                    "name": "untitled",
                    "folder_img": ImgPicturesFolder,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .84, _screen.screenHeight * .3),
                    "hitbox_dim": new DHPoint(300, 270),
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
                        {
                            "name": "prom",
                            "icon": ImgPromIcon,
                            "icon_dim": new DHPoint(78, 93),
                            "icon_pos": new DHPoint(239, 36),
                            "dim": new DHPoint(576, 432),
                            "contents": ImgProm
                        },
                        {
                            "name": "cotillion",
                            "icon": ImgCotillionIcon,
                            "icon_dim": new DHPoint(80, 95),
                            "icon_pos": new DHPoint(135, 140),
                            "dim": new DHPoint(591, 444),
                            "contents": ImgCotillion
                        },
                        {
                            "name": "chatlogs",
                            "icon": ImgChatlogFolder,
                            "icon_dim": new DHPoint(95, 91),
                            "icon_pos": new DHPoint(30, 232),
                            "folder_img": ImgPicturesFolder,
                            "folder_dim": new DHPoint(631, 356),
                            "contents": [
                                {
                                    "name": "chatlog1",
                                    "icon": ImgChatlog1Icon,
                                    "icon_dim": new DHPoint(120, 95),
                                    "icon_pos": new DHPoint(30, 30),
                                    "dim": new DHPoint(631, 491),
                                    "contents": ImgChatlog1
                                },
                                {
                                    "name": "chatlog2",
                                    "icon": ImgChatlog2Icon,
                                    "icon_dim": new DHPoint(137, 93),
                                    "icon_pos": new DHPoint(150, 30),
                                    "dim": new DHPoint(631, 409),
                                    "contents": ImgChatlog2
                                },
                                {
                                    "name": "chatlog3",
                                    "icon": ImgChatlog3Icon,
                                    "icon_dim": new DHPoint(119, 91),
                                    "icon_pos": new DHPoint(290, 30),
                                    "dim": new DHPoint(631, 409),
                                    "contents": ImgChatlog3
                                }
                            ]
                        },
                        {
                            "name": "nyc folder",
                            "icon": ImgNYCFolderIcon,
                            "icon_dim": new DHPoint(97, 96),
                            "icon_pos": new DHPoint(240, 140),
                            "folder_dim": new DHPoint(631, 356),
                            "folder_img": ImgPicturesFolder,
                            "contents": [
                                {
                                    "name": "nyc 1",
                                    "icon": ImgNYC1Icon,
                                    "icon_dim": new DHPoint(81, 90),
                                    "icon_pos": new DHPoint(30, 30),
                                    "dim": new DHPoint(583, 389),
                                    "contents": ImgNYC1
                                },
                                {
                                    "name": "1st day",
                                    "icon": Img1stDayIcon,
                                    "icon_dim": new DHPoint(77, 89),
                                    "icon_pos": new DHPoint(140, 30),
                                    "dim": new DHPoint(387, 518),
                                    "contents": Img1stDay
                                },
                                {
                                    "name": "liberty",
                                    "icon": ImgLibertyIcon,
                                    "icon_dim": new DHPoint(76, 96),
                                    "icon_pos": new DHPoint(240, 24),
                                    "dim": new DHPoint(568, 426),
                                    "contents": ImgLiberty
                                },
                                {
                                    "name": "selfie 5",
                                    "icon": ImgSelfie5Icon,
                                    "icon_dim": new DHPoint(74, 90),
                                    "icon_pos": new DHPoint(30, 128),
                                    "dim": new DHPoint(377, 396),
                                    "contents": ImgSelfie5
                                }
                            ]
                        },
                        {
                            "name": "home folder",
                            "icon": ImgHomeFolderIcon,
                            "icon_dim": new DHPoint(95, 87),
                            "icon_pos": new DHPoint(25, 140),
                            "folder_dim": new DHPoint(631, 356),
                            "folder_img": ImgPicturesFolder,
                            "contents": [
                                {
                                    "name": "home",
                                    "icon": ImgHomeIcon,
                                    "icon_dim": new DHPoint(80, 90),
                                    "icon_pos": new DHPoint(30, 30),
                                    "dim": new DHPoint(646, 430),
                                    "contents": ImgHome
                                },
                                {
                                    "name": "russell",
                                    "icon": ImgRussellOrchIcon,
                                    "icon_dim": new DHPoint(107, 91),
                                    "icon_pos": new DHPoint(130, 30),
                                    "dim": new DHPoint(397, 530),
                                    "contents": ImgRussellOrch
                                },
                                {
                                    "name": "car",
                                    "icon": ImgOldCarIcon,
                                    "icon_dim": new DHPoint(74, 88),
                                    "icon_pos": new DHPoint(245, 31),
                                    "dim": new DHPoint(560, 420),
                                    "contents": ImgOldCar
                                }
                            ]
                        }
                    ]
                },
                {
                    "folder_img": ImgPicturesFolder,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .71, _screen.screenHeight * .32),
                    "hitbox_dim": new DHPoint(300, 250),
                    "name": "old site folder stuff",
                    "contents": [
                        {
                            "name": "hiatus",
                            "icon": ImgHiatusIcon,
                            "icon_dim": new DHPoint(105, 92),
                            "icon_pos": new DHPoint(30, 35),
                            "dim": new DHPoint(631, 356),
                            "contents": ImgHiatus
                        },
                        {
                            "name": "fanart update",
                            "icon": ImgFanartUpdateIcon,
                            "icon_dim": new DHPoint(87, 94),
                            "icon_pos": new DHPoint(140, 32),
                            "dim": new DHPoint(631, 409),
                            "contents": ImgFanartUpdate
                        },
                        {
                            "name": "fanart1",
                            "icon": ImgFanart1Icon,
                            "icon_dim": new DHPoint(85, 94),
                            "icon_pos": new DHPoint(242, 32),
                            "dim": new DHPoint(702, 509),
                            "contents": ImgFanart1
                        },
                        {
                            "name": "fanart2",
                            "icon": ImgFanart2Icon,
                            "icon_dim": new DHPoint(86, 91),
                            "icon_pos": new DHPoint(342, 32),
                            "dim": new DHPoint(702, 509),
                            "contents": ImgFanart2
                        },
                        {
                            "name": "fanart3",
                            "icon": ImgFanart3Icon,
                            "icon_dim": new DHPoint(90, 97),
                            "icon_pos": new DHPoint(440, 28),
                            "dim": new DHPoint(702, 509),
                            "contents": ImgFanart3
                        },
                        {
                            "name": "old site icon",
                            "icon": ImgOldSiteFolder,
                            "icon_dim": new DHPoint(90, 85),
                            "icon_pos": new DHPoint(30, 135),
                            "folder_img": ImgPicturesFolder,
                            "folder_dim": new DHPoint(631, 356),
                            "contents": [
                                {
                                    "name": "old web layout",
                                    "icon": ImgLayoutIcon,
                                    "icon_dim": new DHPoint(76, 90),
                                    "icon_pos": new DHPoint(27, 36),
                                    "dim": new DHPoint(700, 400),
                                    "contents": ImgLayout
                                },
                                {
                                    "name": "old desktop",
                                    "icon": ImgDesktopIcon,
                                    "icon_dim": new DHPoint(87, 97),
                                    "icon_pos": new DHPoint(27, 136),
                                    "dim": new DHPoint(700, 500),
                                    "contents": ImgDesktop
                                },
                                {
                                    "name": "old web profile",
                                    "icon": ImgProfileIcon,
                                    "icon_dim": new DHPoint(106, 89),
                                    "icon_pos": new DHPoint(129, 36),
                                    "dim": new DHPoint(694, 357),
                                    "contents": ImgProfile
                                },
                                {
                                    "name": "old posts",
                                    "icon": ImgPostsIcon,
                                    "icon_dim": new DHPoint(88, 91),
                                    "icon_pos": new DHPoint(250, 36),
                                    "folder_img": ImgPicturesFolder,
                                    "folder_dim": new DHPoint(631, 356),
                                    "contents": [
                                        {
                                            "name": "old post 1",
                                            "icon": ImgBlog1Icon,
                                            "icon_dim": new DHPoint(109, 95),
                                            "icon_pos": new DHPoint(27, 36),
                                            "dim": new DHPoint(631, 356),
                                            "contents": ImgBlog1
                                        },
                                        {
                                            "name": "old post 2",
                                            "icon": ImgBlog2Icon,
                                            "icon_dim": new DHPoint(108, 87),
                                            "icon_pos": new DHPoint(147, 42),
                                            "dim": new DHPoint(694, 431),
                                            "contents": ImgBlog2
                                        },
                                        {
                                            "name": "old post 3",
                                            "icon": ImgBlog3Icon,
                                            "icon_dim": new DHPoint(107, 88),
                                            "icon_pos": new DHPoint(267, 42),
                                            "dim": new DHPoint(694, 392),
                                            "contents": ImgBlog3
                                        },
                                        {
                                            "name": "old post 4",
                                            "icon": ImgBlog4Icon,
                                            "icon_dim": new DHPoint(110, 90),
                                            "icon_pos": new DHPoint(27, 200),
                                            "dim": new DHPoint(694, 392),
                                            "contents": ImgBlog4
                                        },
                                        {
                                            "name": "old post 5",
                                            "icon": ImgBlog5Icon,
                                            "icon_dim": new DHPoint(111, 93),
                                            "icon_pos": new DHPoint(147, 195),
                                            "dim": new DHPoint(631, 356),
                                            "contents": ImgBlog5
                                        }
                                    ]
                                }
                            ]
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
