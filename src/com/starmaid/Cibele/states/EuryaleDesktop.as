package com.starmaid.Cibele.states {
    //DATE CARD: April 13th, 2009
    import org.flixel.*;
    import com.starmaid.Cibele.base.GameState;
    import flash.utils.Dictionary;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.management.FolderBuilder;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.LevelTracker;
    import com.starmaid.Cibele.management.PopUpManager;

    public class EuryaleDesktop extends Desktop {
        [Embed(source="/../assets/images/ui/popups/euryale/photocollage.png")] private var ImgScreenshot:Class;
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
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/cosmo.png")] private var ImgCosmo:Class;
        [Embed(source="/../assets/images/ui/popups/files/blog1draft.png")] private var ImgBlog1Draft:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/cosmo_icon.png")] private var ImgCosmoIcon:Class;
        [Embed(source="/../assets/images/ui/popups/files/blog1draft_icon.png")] private var ImgBlog1DraftIcon:Class;
        [Embed(source="/../assets/images/ui/popups/files/blog7draft.png")] private var ImgBlog7Draft:Class;
        [Embed(source="/../assets/images/ui/popups/files/blog7draft_icon.png")] private var ImgBlog7DraftIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/partypoem1icon.png")] private var ImgUntitledFolderPartyPoem1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/partypoem1.png")] private var ImgUntitledFolderPartyPoem1:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/kawaii.png")] private var ImgUntitledFolderKawaii:Class;


        //old website stuff
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

        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/websitefolder_icon.png")] private var ImgWebsiteFolderIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/aboutme_icon.png")] private var ImgIndexIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/aboutme.png")] private var ImgIndex:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/animemanga_icon.png")] private var ImgAnimeMangaIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/animemanga.png")] private var ImgAnimeManga:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/interests_icon.png")] private var ImgInterestsIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/interests.png")] private var ImgInterests:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/layout_icon.png")] private var ImgEuLayoutIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/layout.png")] private var ImgEuLayout:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/life_icon.png")] private var ImgLifeIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/life.png")] private var ImgLife:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/profile_icon.png")] private var ImgEuProfileIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldwebsite/profile.png")] private var ImgEuProfile:Class;


        [Embed(source="/../assets/images/ui/popups/eu_files/hsfolder.png")] private var ImgHSFolderIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bed_icon.png")] private var ImgBedIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bed.png")] private var ImgBed:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/cutewow.png")] private var ImgCuteWow:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/cutewow_icon.png")] private var ImgCuteWowIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/old_icon.png")] private var ImgOldIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/old.png")] private var ImgOld:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/ollld_icon.png")] private var ImgOllldIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/ollld.png")] private var ImgOllld:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/shots.png")] private var ImgShots:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/shots_icon.png")] private var ImgShotsIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/oldroom.png")] private var ImgOldRoom:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/oldroom_icon.png")] private var ImgOldRoomIcon:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/home.png")] private var ImgHome:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/home_icon.png")] private var ImgHomeIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/sexy1.png")] private var ImgSexy1:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/sexy1_icon.png")] private var ImgSexy1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/oldflashdrive_icon.png")] private var ImgOldFlashdriveIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/sexy2.png")] private var ImgSexy2:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/sexy2_icon.png")] private var ImgSexy2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/selfie2.png")] private var ImgSelfie2:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/selfie2_icon.png")] private var ImgSelfie2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/poem1.png")] private var ImgPoem1:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/poem1_icon.png")] private var ImgPoem1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/sendtomom_icon.png")] private var ImgMomFolderIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bday1.png")] private var ImgBday1:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bday1_icon.png")] private var ImgBday1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bday2.png")] private var ImgBday2:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bday2_icon.png")] private var ImgBday2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bday3.png")] private var ImgBday3:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bday3_icon.png")] private var ImgBday3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bday4.png")] private var ImgBday4:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bday4_icon.png")] private var ImgBday4Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/selfie3.png")] private var ImgSelfie3:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/selfie3_icon.png")] private var ImgSelfie3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/285aug_icon.png")] private var Img285AugIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/285aug.png")] private var Img285Aug:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/myrtle_icon.png")] private var ImgMyrtleIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/myrtle.png")] private var ImgMyrtle:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/river_icon.png")] private var ImgRiverIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/river.png")] private var ImgRiver:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/selfie4.png")] private var ImgSelfie4:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/selfie4_icon.png")] private var ImgSelfie4Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/sexy3.png")] private var ImgSexy3:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/sexy3_icon.png")] private var ImgSexy3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/old_folder.png")] private var ImgOldFolder:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/desk_icon.png")] private var ImgDeskIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/desk.png")] private var ImgDesk:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/chatlog_apr.png")] private var ImgChatlogFolder:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/chatlog_1_icon.png")] private var ImgChatlog1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/chatlog_1.png")] private var ImgChatlog1:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/chatlog_2_icon.png")] private var ImgChatlog2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/chatlog_2.png")] private var ImgChatlog2:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/chatlog_3_icon.png")] private var ImgChatlog3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/chatlog_3.png")]
            private var ImgChatlog3:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/chatlog_4_icon.png")] private var ImgChatlog4Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/chatlog_4.png")]
        private var ImgChatlog4:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/swimsuit.png")] private var ImgSwimsuit:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/swimsuit_icon.png")] private var ImgSwimsuitIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/forichi.png")] private var ImgForIchiIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/better_icon.png")] private var ImgSwimsuitBetterIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/better.png")] private var ImgSwimsuitBetter:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/forichipic_icon.png")] private var ImgForIchiPicIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/forichipic.png")] private var ImgForIchiPic:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/test_icon.png")] private var ImgBWTestIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/test.png")] private var ImgBWTest:Class;

        public function EuryaleDesktop() {
            ScreenManager.getInstance().levelTracker.level = LevelTracker.LVL_EU;
        }

        override public function create():void {
            super.create();
            ScreenManager.getInstance().setupCamera(null, 1);
            var _screen:ScreenManager = ScreenManager.getInstance();

            PopUpManager.getInstance().setOpeningPopups(PopUpManager.EMPTY_INBOX, PopUpManager.EU_DOWNLOADS, PopUpManager.EU_PICLY_1);

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
                            "name": "selfie 3",
                            "icon": ImgSelfie3Icon,
                            "icon_dim": new DHPoint(76, 92),
                            "icon_pos": new DHPoint(249, 29),
                            "dim": new DHPoint(480, 480),
                            "contents": ImgSelfie3
                        },
                        {
                            "name": "hs_subfolder",
                            "icon": ImgHSFolderIcon,
                            "icon_dim": new DHPoint(87, 79),
                            "icon_pos": new DHPoint(31, 135),
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
                                    "name": "home",
                                    "icon": ImgHomeIcon,
                                    "icon_dim": new DHPoint(80, 90),
                                    "icon_pos": new DHPoint(228, 130),
                                    "dim": new DHPoint(646, 430),
                                    "contents": ImgHome
                                },
                                {
                                    "name": "oldflashdrive",
                                    "icon": ImgOldFlashdriveIcon,
                                    "icon_dim": new DHPoint(102, 92),
                                    "icon_pos": new DHPoint(330, 230),
                                    "folder_img": ImgPicturesFolder,
                                    "folder_dim": new DHPoint(631, 356),
                                    "contents": [
                                        {
                                            "name": "sexy1",
                                            "icon": ImgSexy1Icon,
                                            "icon_dim": new DHPoint(79, 92),
                                            "icon_pos": new DHPoint(30, 50),
                                            "dim": new DHPoint(518, 350),
                                            "contents": ImgSexy1
                                        },
                                        {
                                            "name": "sexy2",
                                            "icon": ImgSexy2Icon,
                                            "icon_dim": new DHPoint(73, 89),
                                            "icon_pos": new DHPoint(150, 50),
                                            "dim": new DHPoint(336, 483),
                                            "contents": ImgSexy2
                                        },
                                        {
                                            "name": "selfie2",
                                            "icon": ImgSelfie2Icon,
                                            "icon_dim": new DHPoint(82, 94),
                                            "icon_pos": new DHPoint(260, 50),
                                            "dim": new DHPoint(345, 495),
                                            "contents": ImgSelfie2
                                        },
                                        {
                                            "name": "poem1",
                                            "icon": ImgPoem1Icon,
                                            "icon_dim": new DHPoint(70, 92),
                                            "icon_pos": new DHPoint(30, 150),
                                            "dim": new DHPoint(631, 356),
                                            "contents": ImgPoem1
                                        }
                                    ]
                                }
                            ]
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
                                },
                                {
                                    "name": "river",
                                    "icon": ImgRiverIcon,
                                    "icon_dim": new DHPoint(78, 91),
                                    "icon_pos": new DHPoint(30, 132),
                                    "dim": new DHPoint(568, 426),
                                    "contents": ImgRiver
                                },
                                {
                                    "name": "old subfolder",
                                    "icon": ImgOldFolder,
                                    "icon_dim": new DHPoint(92, 85),
                                    "icon_pos": new DHPoint(132, 132),
                                    "folder_img": ImgPicturesFolder,
                                    "folder_dim": new DHPoint(631, 356),
                                    "contents": [
                                        {
                                            "name": "selfie4",
                                            "icon": ImgSelfie4Icon,
                                            "icon_dim": new DHPoint(79, 90),
                                            "icon_pos": new DHPoint(30, 30),
                                            "dim": new DHPoint(480, 590),
                                            "contents": ImgSelfie4
                                        },
                                        {
                                            "name": "sexy 3",
                                            "icon": ImgSexy3Icon,
                                            "icon_dim": new DHPoint(78, 92),
                                            "icon_pos": new DHPoint(130, 30),
                                            "dim": new DHPoint(436, 590),
                                            "contents": ImgSexy3
                                        },
                                        {
                                            "name": "desk",
                                            "icon": ImgDeskIcon,
                                            "icon_dim": new DHPoint(82, 93),
                                            "icon_pos": new DHPoint(230, 30),
                                            "dim": new DHPoint(622, 415),
                                            "contents": ImgDesk
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "name": "forichi",
                            "icon": ImgForIchiIcon,
                            "icon_dim": new DHPoint(96, 91),
                            "icon_pos": new DHPoint(200, 130),
                            "folder_img": ImgPicturesFolder,
                            "folder_dim": new DHPoint(631, 356),
                            "contents": [
                                {
                                    "name": "swimsuit",
                                    "icon": ImgSwimsuitIcon,
                                    "icon_dim": new DHPoint(91, 98),
                                    "icon_pos": new DHPoint(30, 30),
                                    "dim": new DHPoint(480, 536),
                                    "contents": ImgSwimsuit
                                },
                                {
                                    "name": "swimsuit better",
                                    "icon": ImgSwimsuitBetterIcon,
                                    "icon_dim": new DHPoint(80, 93),
                                    "icon_pos": new DHPoint(130, 30),
                                    "dim": new DHPoint(480, 536),
                                    "contents": ImgSwimsuitBetter
                                },
                                {
                                    "name": "for ichi pic",
                                    "icon": ImgForIchiPicIcon,
                                    "icon_dim": new DHPoint(78, 93),
                                    "icon_pos": new DHPoint(220, 30),
                                    "dim": new DHPoint(300, 653),
                                    "contents": ImgForIchiPic
                                },
                                {
                                    "name": "bw test",
                                    "icon": ImgBWTestIcon,
                                    "icon_dim": new DHPoint(81, 96),
                                    "icon_pos": new DHPoint(310, 30),
                                    "dim": new DHPoint(376, 653),
                                    "contents": ImgBWTest
                                }
                            ]
                        }
                    ]
                },
                {
                    "name": "screenshot",
                    "folder_img": ImgScreenshot,
                    "folder_dim": new DHPoint(528, 426),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .72, _screen.screenHeight * .03),
                    "hitbox_dim": new DHPoint(150, 105),
                    "contents": []
                },
                {
                    "name": "untitled",
                    "folder_img": ImgPicturesFolder,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .84, _screen.screenHeight * .3),
                    "hitbox_dim": new DHPoint(150, 115),
                    "contents": [
                        {
                            "name": "cosmo",
                            "icon": ImgCosmoIcon,
                            "icon_dim": new DHPoint(61, 84),
                            "icon_pos": new DHPoint(27, 36),
                            "dim": new DHPoint(631, 356),
                            "contents": ImgCosmo
                        },
                        {
                            "name": "blog1",
                            "icon": ImgBlog1DraftIcon,
                            "icon_dim": new DHPoint(115, 93),
                            "icon_pos": new DHPoint(129, 36),
                            "dim": new DHPoint(631, 356),
                            "contents": ImgBlog1Draft
                        },
                        {
                            "name": "blog7",
                            "icon": ImgBlog7DraftIcon,
                            "icon_dim": new DHPoint(115, 93),
                            "icon_pos": new DHPoint(250, 36),
                            "dim": new DHPoint(631, 356),
                            "contents": ImgBlog7Draft
                        },
                        {
                            "name": "285aug",
                            "icon": Img285AugIcon,
                            "icon_dim": new DHPoint(78, 94),
                            "icon_pos": new DHPoint(143, 135),
                            "dim": new DHPoint(381, 386),
                            "contents": Img285Aug
                        },
                        {
                            "name": "myrtle",
                            "icon": ImgMyrtleIcon,
                            "icon_dim": new DHPoint(84, 92),
                            "icon_pos": new DHPoint(243, 135),
                            "dim": new DHPoint(480, 480),
                            "contents": ImgMyrtle
                        },
                        {
                            "name": "chatlogs",
                            "icon": ImgChatlogFolder,
                            "icon_dim": new DHPoint(96, 90),
                            "icon_pos": new DHPoint(232, 132),
                            "folder_img": ImgPicturesFolder,
                            "folder_dim": new DHPoint(631, 356),
                            "contents": [
                                {
                                    "name": "chatlog1",
                                    "icon": ImgChatlog1Icon,
                                    "icon_dim": new DHPoint(122, 92),
                                    "icon_pos": new DHPoint(25, 30),
                                    "dim": new DHPoint(631, 568),
                                    "contents": ImgChatlog1
                                },
                                {
                                    "name": "chatlog2",
                                    "icon": ImgChatlog2Icon,
                                    "icon_dim": new DHPoint(126, 90),
                                    "icon_pos": new DHPoint(150, 30),
                                    "dim": new DHPoint(631, 568),
                                    "contents": ImgChatlog2
                                },
                                {
                                    "name": "chatlog3",
                                    "icon": ImgChatlog3Icon,
                                    "icon_dim": new DHPoint(126, 90),
                                    "icon_pos": new DHPoint(270, 30),
                                    "dim": new DHPoint(631, 605),
                                    "contents": ImgChatlog3
                                },
                                {
                                    "name": "chatlog4",
                                    "icon": ImgChatlog4Icon,
                                    "icon_dim": new DHPoint(135, 92),
                                    "icon_pos": new DHPoint(400, 30),
                                    "dim": new DHPoint(631, 409),
                                    "contents": ImgChatlog4
                                }
                            ]
                        },
                        {
                            "name": "sendtomom_subfolder",
                            "icon": ImgMomFolderIcon,
                            "icon_dim": new DHPoint(97, 91),
                            "icon_pos": new DHPoint(28, 135),
                            "folder_img": ImgPicturesFolder,
                            "folder_dim": new DHPoint(631, 356),
                            "contents": [
                                {
                                    "name": "bday1",
                                    "icon": ImgBday1Icon,
                                    "icon_dim": new DHPoint(79, 100),
                                    "icon_pos": new DHPoint(30, 30),
                                    "dim": new DHPoint(682, 511),
                                    "contents": ImgBday1
                                },
                                {
                                    "name": "bday2",
                                    "icon": ImgBday2Icon,
                                    "icon_dim": new DHPoint(84, 97),
                                    "icon_pos": new DHPoint(140, 32),
                                    "dim": new DHPoint(568, 426),
                                    "contents": ImgBday2
                                },
                                {
                                    "name": "bday3",
                                    "icon": ImgBday3Icon,
                                    "icon_dim": new DHPoint(86, 99),
                                    "icon_pos": new DHPoint(250, 30),
                                    "dim": new DHPoint(568, 426),
                                    "contents": ImgBday3
                                },
                                {
                                    "name": "bday4",
                                    "icon": ImgBday4Icon,
                                    "icon_dim": new DHPoint(80, 90),
                                    "icon_pos": new DHPoint(30, 140),
                                    "dim": new DHPoint(568, 426),
                                    "contents": ImgBday4
                                }
                            ]
                        }
                    ]
                },
                {
                    "folder_img": ImgPicturesFolder,
                    "folder_dim": new DHPoint(631, 356),
                    "hitbox_pos": new DHPoint(_screen.screenWidth * .7, _screen.screenHeight * .32),
                    "hitbox_dim": new DHPoint(150, 100),
                    "name": "old site folder stuff",
                    "contents": [
                        {
                            "name": "old site 2 icon",
                            "icon": ImgWebsiteFolderIcon,
                            "icon_dim": new DHPoint(115, 85),
                            "icon_pos": new DHPoint(250, 32),
                            "folder_img": ImgPicturesFolder,
                            "folder_dim": new DHPoint(631, 356),
                            "contents": [
                                {
                                    "name": "old about me",
                                    "icon": ImgIndexIcon,
                                    "icon_dim": new DHPoint(134, 91),
                                    "icon_pos": new DHPoint(20, 36),
                                    "dim": new DHPoint(694, 344),
                                    "contents": ImgIndex
                                },
                                {
                                    "name": "old interests",
                                    "icon": ImgInterestsIcon,
                                    "icon_dim": new DHPoint(151, 89),
                                    "icon_pos": new DHPoint(170, 42),
                                    "dim": new DHPoint(694, 516),
                                    "contents": ImgInterests
                                },
                                {
                                    "name": "old anime manga",
                                    "icon": ImgAnimeMangaIcon,
                                    "icon_dim": new DHPoint(138, 99),
                                    "icon_pos": new DHPoint(330, 36),
                                    "dim": new DHPoint(694, 414),
                                    "contents": ImgAnimeManga
                                },
                                {
                                    "name": "old eu layout",
                                    "icon": ImgEuLayoutIcon,
                                    "icon_dim": new DHPoint(79, 100),
                                    "icon_pos": new DHPoint(500, 36),
                                    "dim": new DHPoint(600, 356),
                                    "contents": ImgEuLayout
                                },
                                {
                                    "name": "old life",
                                    "icon": ImgLifeIcon,
                                    "icon_dim": new DHPoint(113, 87),
                                    "icon_pos": new DHPoint(20, 136),
                                    "dim": new DHPoint(763, 497),
                                    "contents": ImgLife
                                },
                                {
                                    "name": "old profile",
                                    "icon": ImgEuProfileIcon,
                                    "icon_dim": new DHPoint(139, 93),
                                    "icon_pos": new DHPoint(180, 136),
                                    "dim": new DHPoint(694, 434),
                                    "contents": ImgEuProfile
                                }
                            ]
                        },
                        {
                            "name": "old site icon",
                            "icon": ImgOldSiteFolder,
                            "icon_dim": new DHPoint(90, 85),
                            "icon_pos": new DHPoint(100, 32),
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
                                    "icon_pos": new DHPoint(300, 36),
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
