package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class PopupHierarchies {
        [Embed(source="/../assets/images/ui/popups/files/bday_icon.png")] private static var ImgBdayIcon:Class;
        [Embed(source="/../assets/images/ui/popups/files/it_bday.png")] private static var ImgBday:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/bulldoghell_icon.png")] private static var ImgBHIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/lastnight_icon.png")] private static var ImgLastNightIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/lastnight_small.png")] private static var ImgLastNightSmall:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/bulldoghell.png")] private static var ImgBH:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/ichiselfie1.png")] private static var ImgIchiSelfie1:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/ichiselfieicon1.png")] private static var ImgIchiSelfie1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/files/camera1disconnecticon.png")] private static var ImgCibCamDisconnectIcon:Class;
        [Embed(source="/../assets/images/ui/popups/files/camera1selfie.png")] private static var ImgCibCam1:Class;
        [Embed(source="/../assets/images/ui/popups/files/camera1selfieicon.png")] private static var ImgCibCam1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/guil1_sub1link.png")] private static var ImgGuilLink1:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/guil1_sub1.png")] private static var ImgGuilSub:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/ichiselfieemail_sub1.png")] private static var ImgIchiSelfieSub1:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/ichiselfieemail_link1.png")] private static var ImgIchiSelfieSubLink1:Class;
        [Embed(source="/../assets/images/ui/popups/files/friend_selfie1.png")] private static var ImgFriendSelfie1:Class;
        [Embed(source="/../assets/images/ui/popups/files/friend_selfie1_icon.png")] private static var ImgFriendSelfie1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/files/friends_1_icon.png")] private static var ImgFriends1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/files/friends_1.png")] private static var ImgFriends1:Class;
        [Embed(source="/../assets/images/ui/popups/files/friends_2_icon.png")] private static var ImgFriends2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/files/friends_2.png")] private static var ImgFriends2:Class;
        [Embed(source="/../assets/images/ui/popups/files/home1.png")] private static var ImgHome1:Class;
        [Embed(source="/../assets/images/ui/popups/files/home1_icon.png")] private static var ImgHome1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/files/pretty.png")] private static var ImgPretty:Class;
        [Embed(source="/../assets/images/ui/popups/files/pretty_icon.png")] private static var ImgPrettyIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/ichi.png")] private static var ImgIchi:Class;
        [Embed(source="/../assets/images/ui/popups/it_files/ichi_icon.png")] private static var ImgIchiIcon:Class;

        //euryale
        [Embed(source="/../assets/images/ui/popups/eu_email/email2_link1.png")] private static var ImgEuEmail2Link1:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/email2_link2.png")] private static var ImgEuEmail2Link2:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/email2_flight.png")] private static var ImgEuEmail2Flight:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/small_email1.png")] private static var ImgEuEmailSmallEmail1:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bed_icon.png")] private static var ImgEuFile1BedIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/bed.png")] private static var ImgEuFile1Bed:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/cutewow_icon.png")] private static var ImgEuFile1CuteWowIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/cutewow.png")] private static var ImgEuFile1CuteWow:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/old_icon.png")] private static var ImgEuFile1OldIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/old.png")] private static var ImgEuFile1Old:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/ollld.png")] private static var ImgEuFile1Ollld:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/ollld_icon.png")] private static var ImgEuFile1OllldIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/emailselfie_link.png")] private static var ImgEuEmailSelfieLink:Class;
        [Embed(source="/../assets/images/ui/popups/eu_net/ichiselfiethread.png")] private static var ImgEuEmailSelfieNetThread:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/miniemailselfie_link.png")] private static var ImgEuEmailSelfieMiniLink:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/small_emailselfie.png")] private static var ImgEuMiniSelfieEmail:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/forcibby.png")] private static var ImgForCibby:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/forcibby_icon.png")] private static var ImgForCibbyIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/selfie1.png")] private static var ImgEUSelfie1:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/selfie1_icon.png")] private static var ImgEUSelfie1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/house.png")] private static var ImgHouse:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/house_icon.png")] private static var ImgHouseIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/home_folder.png")] private static var ImgHomeFolder:Class;
        [Embed(source="/../assets/images/ui/popups/selfiedesktop/pictures_folder.png")] private static var ImgPicturesFolder:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/loldad_icon.png")] private static var ImgLolDadIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/loldad.png")] private static var ImgLolDad:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/email_ichi_small.png")] private static var ImgEuEmailIchiSmall:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/email_ichi_small_icon.png")] private static var ImgEuEmailIchiSmallIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/lingerie_email_small.png")] private static var ImgEuEmailLingSmall:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/lingerie_email_link.png")] private static var ImgEuEmailLingIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/poemedits_email_link.png")] private static var ImgEuPoemEditLinkIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/poemedits_email.png")] private static var ImgEuPoemEditEmail:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/poemedits_icon.png")] private static var ImgEuPoemEditIcon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/poemedits.png")] private static var ImgEuPoemEdit:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/fanart1_icon.png")] private static var ImgFanart1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/fanart1.png")] private static var ImgFanart1:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/fanart2_icon.png")] private static var ImgFanart2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/fanart2.png")] private static var ImgFanart2:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/fanart3_icon.png")] private static var ImgFanart3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/fanart3.png")] private static var ImgFanart3:Class;
        [Embed(source="/../assets/images/ui/popups/eu_files/fanartfolder_icon.png")] private static var ImgFanartFolderIcon:Class;

        //hiisi
        [Embed(source="/../assets/images/ui/popups/hi_email/flight_link.png")] private static var ImgHiFlightLink:Class;
        [Embed(source="/../assets/images/ui/popups/hi_email/flight_expired.png")] private static var ImgHiFlightExpired:Class;
        [Embed(source="/../assets/images/ui/popups/hi_email/mini_flight_email_link.png")] private static var ImgHiMiniFlightLink:Class;
        [Embed(source="/../assets/images/ui/popups/hi_email/mini_flight_email.png")] private static var ImgHiMiniFlight:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/friend_1.png")] private static var ImgHiFriend1:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/friend_1_icon.png")] private static var ImgHiFriend1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/friend_2.png")] private static var ImgHiFriend2:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/friend_2_icon.png")] private static var ImgHiFriend2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/friend_3.png")] private static var ImgHiFriend3:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/friend_3_icon.png")] private static var ImgHiFriend3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/selfie_1.png")] private static var ImgHiSelfie1:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/selfie_1_icon.png")] private static var ImgHiSelfie1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/selfie_2.png")] private static var ImgHiSelfie2:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/selfie_2_icon.png")] private static var ImgHiSelfie2Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/selfie_3.png")] private static var ImgHiSelfie3:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/selfie_3_icon.png")] private static var ImgHiSelfie3Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_email/thermal_icon.png")] private static var ImgHiThermalIcon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_email/thermal_poem.png")] private static var ImgHiThermalPoem:Class;
        [Embed(source="/../assets/images/ui/popups/hi_email/mini_class_email.png")] private static var ImgHiMiniClassEmail:Class;
        [Embed(source="/../assets/images/ui/popups/hi_email/mini_class_email_link.png")] private static var ImgHiMiniClassEmailLink:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/email_ichi_pic.png")] private static var ImgEuEmailIchiPic:Class;
        [Embed(source="/../assets/images/ui/popups/eu_email/email_ichi_pic_icon.png")] private static var ImgEuEmailIchiIcon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/friend_4_icon.png")] private static var ImgFriend4Icon:Class;
        [Embed(source="/../assets/images/ui/popups/hi_files/friend_4.png")] private static var ImgFriend4:Class;

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
        public static function build():Dictionary {
            var struc:Dictionary = new Dictionary();
            struc[PopUpManager.ICHI_DL_2] = { "contents": [
                {
                    "name": "friends_1",
                    "icon": ImgFriends1Icon,
                    "icon_dim": new DHPoint(70, 84),
                    "icon_pos": new DHPoint(28, 35),
                    "dim": new DHPoint(338, 451),
                    "struc": PopUpManager.ICHI_DL_2,
                    "contents": ImgFriends1
                },
                {
                    "name": "bday",
                    "icon": ImgBdayIcon,
                    "icon_dim": new DHPoint(100, 93),
                    "icon_pos": new DHPoint(108, 35),
                    "dim": new DHPoint(631, 356),
                    "struc": PopUpManager.ICHI_DL_2,
                    "contents": ImgBday
                },
                {
                    "name": "friend_selfie1",
                    "icon": ImgFriendSelfie1Icon,
                    "icon_dim": new DHPoint(75, 86),
                    "icon_pos": new DHPoint(220, 35),
                    "dim": new DHPoint(512, 356),
                    "struc": PopUpManager.ICHI_DL_2,
                    "contents": ImgFriendSelfie1
                },
                {
                    "name": "friends_2",
                    "icon": ImgFriends2Icon,
                    "icon_dim": new DHPoint(70, 85),
                    "icon_pos": new DHPoint(320, 35),
                    "dim": new DHPoint(512, 356),
                    "struc": PopUpManager.ICHI_DL_2,
                    "contents": ImgFriends2
                },
                {
                    "name": "home_1",
                    "icon": ImgHome1Icon,
                    "icon_dim": new DHPoint(117, 86),
                    "icon_pos": new DHPoint(400, 35),
                    "dim": new DHPoint(512, 356),
                    "struc": PopUpManager.ICHI_DL_2,
                    "contents": ImgHome1
                },
                {
                    "name": "pretty",
                    "icon": ImgPrettyIcon,
                    "icon_dim": new DHPoint(70, 85),
                    "icon_pos": new DHPoint(28, 135),
                    "dim": new DHPoint(512, 356),
                    "struc": PopUpManager.ICHI_DL_2,
                    "contents": ImgPretty
                },
                {
                    "name": "ichi",
                    "icon": ImgIchiIcon,
                    "icon_dim": new DHPoint(78, 96),
                    "icon_pos": new DHPoint(112, 133),
                    "dim": new DHPoint(452, 356),
                    "struc": PopUpManager.ICHI_DL_2,
                    "contents": ImgIchi
                }
            ]};
            struc[PopUpManager.ICHI_SELFIE1] = { "contents": [
                {
                    "name": "ichi selfie email 1",
                    "icon": ImgIchiSelfie1Icon,
                    "icon_dim": new DHPoint(70, 86),
                    "icon_pos": new DHPoint(23, 210),
                    "dim": new DHPoint(433, 356),
                    "struc": PopUpManager.ICHI_SELFIE1,
                    "contents": ImgIchiSelfie1
                },
                {
                    "name": "last night small",
                    "icon": ImgLastNightIcon,
                    "icon_dim": new DHPoint(322, 22),
                    "icon_pos": new DHPoint(293, 102),
                    "dim": new DHPoint(284, 356),
                    "struc": PopUpManager.ICHI_SELFIE1,
                    "contents": ImgLastNightSmall
                },
                {
                    "name": "ichi selfie email sub 1",
                    "icon": ImgIchiSelfieSubLink1,
                    "icon_dim": new DHPoint(325, 22),
                    "icon_pos": new DHPoint(290, 125),
                    "dim": new DHPoint(280, 356),
                    "struc": PopUpManager.ICHI_SELFIE1,
                    "contents": ImgIchiSelfieSub1
                },
                {
                    "name": "ichi selfie email link",
                    "icon": ImgGuilLink1,
                    "icon_dim": new DHPoint(327, 20),
                    "icon_pos": new DHPoint(290, 149),
                    "folder_dim": new DHPoint(280, 356),
                    "struc": PopUpManager.ICHI_SELFIE1,
                    "folder_img": ImgGuilSub,
                    "contents": [
                        {
                            "name": "ichi selfie sub bulldog hell",
                            "icon": ImgBHIcon,
                            "icon_dim": new DHPoint(74, 14),
                            "icon_pos": new DHPoint(180, 106),
                            "dim": new DHPoint(970, 437),
                            "struc": PopUpManager.ICHI_SELFIE1,
                            "contents": ImgBH
                        }]
                }
            ]};
            struc[PopUpManager.BULLDOG_HELL] = { "contents": [
                {
                    "name": "bulldog hell",
                    "icon": ImgBHIcon,
                    "icon_dim": new DHPoint(74, 14),
                    "icon_pos": new DHPoint(179, 101),
                    "dim": new DHPoint(970, 437),
                    "struc": PopUpManager.BULLDOG_HELL,
                    "contents": ImgBH
                },
                {
                    "name": "last night small",
                    "icon": ImgLastNightIcon,
                    "icon_dim": new DHPoint(322, 22),
                    "icon_pos": new DHPoint(293, 100),
                    "dim": new DHPoint(284, 356),
                    "struc": PopUpManager.BULLDOG_HELL,
                    "contents": ImgLastNightSmall
                }
            ]};
            struc[PopUpManager.GUIL_1] = { "contents": [
                {
                    "name": "last night small",
                    "icon": ImgLastNightIcon,
                    "icon_dim": new DHPoint(322, 22),
                    "icon_pos": new DHPoint(292, 100),
                    "dim": new DHPoint(284, 356),
                    "struc": PopUpManager.GUIL_1,
                    "contents": ImgLastNightSmall
                },
                {
                    "name": "guil email link",
                    "icon": ImgGuilLink1,
                    "icon_dim": new DHPoint(327, 20),
                    "icon_pos": new DHPoint(290, 125),
                    "folder_dim": new DHPoint(280, 356),
                    "struc": PopUpManager.GUIL_1,
                    "folder_img": ImgGuilSub,
                    "contents": [
                        {
                            "name": "guil sub bulldog hell",
                            "icon": ImgBHIcon,
                            "icon_dim": new DHPoint(74, 14),
                            "icon_pos": new DHPoint(180, 106),
                            "dim": new DHPoint(970, 437),
                            "struc": PopUpManager.GUIL_1,
                            "contents": ImgBH
                        }]
                }
            ]};
            struc[PopUpManager.CIB_SELFIE_FOLDER] = { "contents": [
                {
                    "name": "cib camera selfies 1",
                    "icon": ImgCibCamDisconnectIcon,
                    "icon_dim": new DHPoint(204, 34),
                    "icon_pos": new DHPoint(43, 124),
                    "folder_dim": new DHPoint(631, 356),
                    "struc": PopUpManager.CIB_SELFIE_FOLDER,
                    "folder_img": ImgPicturesFolder,
                    "contents": [
                        {
                            "name": "cam selfies",
                            "icon": ImgCibCam1Icon,
                            "icon_dim": new DHPoint(103, 81),
                            "icon_pos": new DHPoint(213, 135),
                            "dim": new DHPoint(530, 356),
                            "struc": PopUpManager.CIB_SELFIE_FOLDER,
                            "contents": ImgCibCam1
                        },
                        {
                            "name": "friends_1",
                            "icon": ImgFriends1Icon,
                            "icon_dim": new DHPoint(70, 84),
                            "icon_pos": new DHPoint(28, 35),
                            "dim": new DHPoint(338, 451),
                            "struc": PopUpManager.CIB_SELFIE_FOLDER,
                            "contents": ImgFriends1
                        },
                        {
                            "name": "bday",
                            "icon": ImgBdayIcon,
                            "icon_dim": new DHPoint(100, 93),
                            "icon_pos": new DHPoint(108, 35),
                            "dim": new DHPoint(631, 356),
                            "struc": PopUpManager.CIB_SELFIE_FOLDER,
                            "contents": ImgBday
                        },
                        {
                            "name": "friend_selfie1",
                            "icon": ImgFriendSelfie1Icon,
                            "icon_dim": new DHPoint(75, 86),
                            "icon_pos": new DHPoint(220, 35),
                            "dim": new DHPoint(512, 356),
                            "struc": PopUpManager.CIB_SELFIE_FOLDER,
                            "contents": ImgFriendSelfie1
                        },
                        {
                            "name": "friends_2",
                            "icon": ImgFriends2Icon,
                            "icon_dim": new DHPoint(70, 85),
                            "icon_pos": new DHPoint(320, 35),
                            "dim": new DHPoint(512, 356),
                            "struc": PopUpManager.CIB_SELFIE_FOLDER,
                            "contents": ImgFriends2
                        },
                        {
                            "name": "home_1",
                            "icon": ImgHome1Icon,
                            "icon_dim": new DHPoint(117, 86),
                            "icon_pos": new DHPoint(400, 35),
                            "dim": new DHPoint(512, 356),
                            "struc": PopUpManager.CIB_SELFIE_FOLDER,
                            "contents": ImgHome1
                        },
                        {
                            "name": "pretty",
                            "icon": ImgPrettyIcon,
                            "icon_dim": new DHPoint(70, 85),
                            "icon_pos": new DHPoint(28, 135),
                            "dim": new DHPoint(512, 356),
                            "struc": PopUpManager.CIB_SELFIE_FOLDER,
                            "contents": ImgPretty
                        },
                        {
                            "name": "ichi",
                            "icon": ImgIchiIcon,
                            "icon_dim": new DHPoint(78, 96),
                            "icon_pos": new DHPoint(112, 133),
                            "dim": new DHPoint(452, 356),
                            "struc": PopUpManager.ICHI_DL_2,
                            "contents": ImgIchi
                        }
                    ]
                }
            ]};
            struc[PopUpManager.EU_EMAIL_LINGERIE] = { "contents": [
                    {
                        "name": "eu ling 1",
                        "icon": ImgEuPoemEditLinkIcon,
                        "icon_dim": new DHPoint(322, 24),
                        "icon_pos": new DHPoint(293, 102),
                        "folder_dim": new DHPoint(283, 356),
                        "struc": PopUpManager.EU_EMAIL_LINGERIE,
                        "folder_img": ImgEuPoemEditEmail,
                        "contents": [
                            {
                                "name": "eu ling 1 popup",
                                "icon": ImgEuPoemEditIcon,
                                "icon_dim": new DHPoint(76, 89),
                                "icon_pos": new DHPoint(20, 245),
                                "dim": new DHPoint(528, 426),
                                "struc": PopUpManager.EU_EMAIL_LINGERIE,
                                "contents": ImgEuPoemEdit
                            }]
                    }
            ]};
            struc[PopUpManager.EU_EMAIL_1] = { "contents": [
                {
                    "name": "eu email ling",
                    "icon": ImgEuEmailLingIcon,
                    "icon_dim": new DHPoint(326, 23),
                    "icon_pos": new DHPoint(290, 98),
                    "dim": new DHPoint(284, 356),
                    "struc": PopUpManager.EU_EMAIL_1,
                    "contents": ImgEuEmailLingSmall
                },
                {
                        "name": "eu ling 1",
                        "icon": ImgEuPoemEditLinkIcon,
                        "icon_dim": new DHPoint(322, 24),
                        "icon_pos": new DHPoint(291, 118),
                        "folder_dim": new DHPoint(283, 356),
                        "struc": PopUpManager.EU_EMAIL_1,
                        "folder_img": ImgEuPoemEditEmail,
                        "contents": [
                            {
                                "name": "eu ling 1 popup",
                                "icon": ImgEuPoemEditIcon,
                                "icon_dim": new DHPoint(76, 89),
                                "icon_pos": new DHPoint(20, 245),
                                "dim": new DHPoint(528, 426),
                                "struc": PopUpManager.EU_EMAIL_1,
                                "contents": ImgEuPoemEdit
                            }]
                    }
            ]};
            struc[PopUpManager.EU_EMAIL_SELFIE] = { "contents": [
                {
                    "name": "eu email selfie link 1",
                    "icon": ImgEuEmailSelfieLink,
                    "icon_dim": new DHPoint(154, 19),
                    "icon_pos": new DHPoint(18, 186),
                    "dim": new DHPoint(1030,437),
                    "struc": PopUpManager.EU_EMAIL_SELFIE,
                    "contents": ImgEuEmailSelfieNetThread
                },
                {
                    "name": "eu email ling",
                    "icon": ImgEuEmailLingIcon,
                    "icon_dim": new DHPoint(326, 23),
                    "icon_pos": new DHPoint(290, 98),
                    "dim": new DHPoint(284, 356),
                    "struc": PopUpManager.EU_EMAIL_SELFIE,
                    "contents": ImgEuEmailLingSmall
                },
                {
                        "name": "eu ling 1",
                        "icon": ImgEuPoemEditLinkIcon,
                        "icon_dim": new DHPoint(322, 24),
                        "icon_pos": new DHPoint(291, 118),
                        "folder_dim": new DHPoint(283, 356),
                        "struc": PopUpManager.EU_EMAIL_SELFIE,
                        "folder_img": ImgEuPoemEditEmail,
                        "contents": [
                            {
                                "name": "eu ling 1 popup",
                                "icon": ImgEuPoemEditIcon,
                                "icon_dim": new DHPoint(76, 89),
                                "icon_pos": new DHPoint(20, 245),
                                "dim": new DHPoint(528, 426),
                                "struc": PopUpManager.EU_EMAIL_SELFIE,
                                "contents": ImgEuPoemEdit
                            }]
                },
                {
                    "name": "eu email selfie link 2",
                    "icon": ImgEuEmail2Link1,
                    "icon_dim": new DHPoint(322, 24),
                    "icon_pos": new DHPoint(291, 140),
                    "dim": new DHPoint(284, 356),
                    "struc": PopUpManager.EU_EMAIL_SELFIE,
                    "contents": ImgEuEmailSmallEmail1
                }
            ]};
            struc[PopUpManager.EU_EMAIL_2] = { "contents": [
                {
                    "name": "eu email 2 link 2",
                    "icon": ImgEuEmail2Link2,
                    "icon_dim": new DHPoint(225, 18),
                    "icon_pos": new DHPoint(20, 219),
                    "dim": new DHPoint(834, 437),
                    "struc": PopUpManager.EU_EMAIL_2,
                    "contents": ImgEuEmail2Flight
                },
                {
                    "name": "eu email ling",
                    "icon": ImgEuEmailLingIcon,
                    "icon_dim": new DHPoint(326, 23),
                    "icon_pos": new DHPoint(290, 98),
                    "dim": new DHPoint(284, 356),
                    "struc": PopUpManager.EU_EMAIL_2,
                    "contents": ImgEuEmailLingSmall
                },
                {
                        "name": "eu ling 1",
                        "icon": ImgEuPoemEditLinkIcon,
                        "icon_dim": new DHPoint(322, 24),
                        "icon_pos": new DHPoint(292, 118),
                        "folder_dim": new DHPoint(283, 356),
                        "struc": PopUpManager.EU_EMAIL_2,
                        "folder_img": ImgEuPoemEditEmail,
                        "contents": [
                            {
                                "name": "eu ling 1 popup",
                                "icon": ImgEuPoemEditIcon,
                                "icon_dim": new DHPoint(76, 89),
                                "icon_pos": new DHPoint(20, 245),
                                "dim": new DHPoint(528, 426),
                                "struc": PopUpManager.EU_EMAIL_2,
                                "contents": ImgEuPoemEdit
                            }]
                },
                {
                    "name": "eu email 2 link 1daf",
                    "icon": ImgEuEmail2Link1,
                    "icon_dim": new DHPoint(322, 24),
                    "icon_pos": new DHPoint(292, 140),
                    "dim": new DHPoint(284, 356),
                    "struc": PopUpManager.EU_EMAIL_2,
                    "contents": ImgEuEmailSmallEmail1
                },
                {
                    "name": "eu email 2 link 3",
                    "icon": ImgEuEmailSelfieMiniLink,
                    "icon_dim": new DHPoint(322, 24),
                    "icon_pos": new DHPoint(292, 160),
                    "folder_dim": new DHPoint(284, 356),
                    "struc": PopUpManager.EU_EMAIL_2,
                    "folder_img": ImgEuMiniSelfieEmail,
                    "contents": [
                        {
                            "name": "eu mini selfie email",
                            "icon": ImgEuEmailSelfieLink,
                            "icon_dim": new DHPoint(154, 19),
                            "icon_pos": new DHPoint(20, 184),
                            "dim": new DHPoint(1030,437),
                            "struc": PopUpManager.EU_EMAIL_2,
                            "contents": ImgEuEmailSelfieNetThread
                        }]
                }
            ]};
            struc[PopUpManager.EU_HIGHSCHOOL] = { "contents": [
                {
                    "name": "bed pic",
                    "icon": ImgEuFile1BedIcon,
                    "icon_dim": new DHPoint(77, 94),
                    "icon_pos": new DHPoint(28, 33),
                    "dim": new DHPoint(530, 356),
                    "struc": PopUpManager.EU_HIGHSCHOOL,
                    "contents": ImgEuFile1Bed
                },
                {
                    "name": "cutewow pic",
                    "icon": ImgEuFile1BedIcon,
                    "icon_dim": new DHPoint(81, 93),
                    "icon_pos": new DHPoint(118, 33),
                    "dim": new DHPoint(530, 356),
                    "struc": PopUpManager.EU_HIGHSCHOOL,
                    "contents": ImgEuFile1CuteWow
                },
                {
                    "name": "old pic",
                    "icon": ImgEuFile1OldIcon,
                    "icon_dim": new DHPoint(80, 93),
                    "icon_pos": new DHPoint(214, 33),
                    "dim": new DHPoint(530, 356),
                    "struc": PopUpManager.EU_HIGHSCHOOL,
                    "contents": ImgEuFile1Old
                },
                {
                    "name": "ollld pic",
                    "icon": ImgEuFile1OllldIcon,
                    "icon_dim": new DHPoint(84, 95),
                    "icon_pos": new DHPoint(305, 33),
                    "dim": new DHPoint(530, 356),
                    "struc": PopUpManager.EU_HIGHSCHOOL,
                    "contents": ImgEuFile1Ollld
                }
            ]};
            struc[PopUpManager.EU_DOWNLOADS] = { "contents": [
                {
                    "name": "forcibby",
                    "icon": ImgForCibbyIcon,
                    "icon_dim": new DHPoint(70, 85),
                    "icon_pos": new DHPoint(18, 32),
                    "dim": new DHPoint(512, 356),
                    "struc": PopUpManager.EU_DOWNLOADS,
                    "contents": ImgForCibby
                },
                {
                    "name": "eu selfie 1",
                    "icon": ImgEUSelfie1Icon,
                    "icon_dim": new DHPoint(104, 86),
                    "icon_pos": new DHPoint(120, 32),
                    "dim": new DHPoint(512, 356),
                    "struc": PopUpManager.EU_DOWNLOADS,
                    "contents": ImgEUSelfie1
                },
                {
                    "name": "home folder",
                    "icon": ImgHomeFolder,
                    "icon_dim": new DHPoint(101, 92),
                    "icon_pos": new DHPoint(240, 30),
                    "folder_dim": new DHPoint(631, 356),
                    "struc": PopUpManager.EU_DOWNLOADS,
                    "folder_img": ImgPicturesFolder,
                    "contents": [
                        {
                            "name": "house",
                            "icon": ImgHouseIcon,
                            "icon_dim": new DHPoint(80, 91),
                            "icon_pos": new DHPoint(30, 30),
                            "dim": new DHPoint(648, 484),
                            "struc": PopUpManager.EU_DOWNLOADS,
                            "contents": ImgHouse
                        },
                        {
                            "name": "loldad",
                            "icon": ImgLolDadIcon,
                            "icon_dim": new DHPoint(79, 91),
                            "icon_pos": new DHPoint(130, 30),
                            "dim": new DHPoint(648, 484),
                            "struc": PopUpManager.EU_DOWNLOADS,
                            "contents": ImgLolDad
                        },
                        {
                            "name": "fanart folder",
                            "icon": ImgFanartFolderIcon,
                            "icon_dim": new DHPoint(114, 87),
                            "icon_pos": new DHPoint(30, 130),
                            "folder_dim": new DHPoint(631, 356),
                            "struc": PopUpManager.EU_DOWNLOADS,
                            "folder_img": ImgPicturesFolder,
                            "contents": [
                                {
                                    "name": "fanart 1",
                                    "icon": ImgFanart1Icon,
                                    "icon_dim": new DHPoint(87, 95),
                                    "icon_pos": new DHPoint(30, 30),
                                    "dim": new DHPoint(609, 637),
                                    "struc": PopUpManager.EU_DOWNLOADS,
                                    "contents": ImgFanart1
                                },
                                {
                                    "name": "fanart 2",
                                    "icon": ImgFanart2Icon,
                                    "icon_dim": new DHPoint(87, 91),
                                    "icon_pos": new DHPoint(130, 32),
                                    "dim": new DHPoint(534, 637),
                                    "struc": PopUpManager.EU_DOWNLOADS,
                                    "contents": ImgFanart2
                                },
                                {
                                    "name": "fanart 3",
                                    "icon": ImgFanart3Icon,
                                    "icon_dim": new DHPoint(77, 91),
                                    "icon_pos": new DHPoint(230, 30),
                                    "dim": new DHPoint(694, 562),
                                    "struc": PopUpManager.EU_DOWNLOADS,
                                    "contents": ImgFanart3
                                }
                            ]
                        }
                    ]
                }
            ]};
            struc[PopUpManager.HI_EMAIL_ICHI] = { "contents": [
                {
                    "name": "eu email ichi",
                    "icon": ImgEuEmailIchiIcon,
                    "icon_dim": new DHPoint(78, 92),
                    "icon_pos": new DHPoint(18, 240),
                    "dim": new DHPoint(653, 490),
                    "struc": PopUpManager.HI_EMAIL_ICHI,
                    "contents": ImgEuEmailIchiPic
                }
            ]};
            struc[PopUpManager.HI_EMAIL_1] = { "contents": [
                {
                    "name": "link to expired flight",
                    "icon": ImgHiFlightLink,
                    "icon_dim": new DHPoint(225, 18),
                    "icon_pos": new DHPoint(23, 218),
                    "dim": new DHPoint(945, 437),
                    "struc": PopUpManager.HI_EMAIL_1,
                    "contents": ImgHiFlightExpired
                },
                {
                    "name": "hi emailichi",
                    "icon": ImgEuEmailIchiSmallIcon,
                    "icon_dim": new DHPoint(321, 22),
                    "icon_pos": new DHPoint(290, 100),
                    "folder_img": ImgEuEmailIchiSmall,
                    "folder_dim": new DHPoint(284, 356),
                    "struc": PopUpManager.HI_EMAIL_1,
                    "contents": [
                        {
                            "name": "hi email small ichi",
                            "icon": ImgEuEmailIchiIcon,
                            "icon_dim": new DHPoint(78, 92),
                            "icon_pos": new DHPoint(18, 240),
                            "dim": new DHPoint(653, 490),
                            "struc": PopUpManager.HI_EMAIL_1,
                            "contents": ImgEuEmailIchiPic
                        }
                    ]
                }
            ]};
            struc[PopUpManager.HI_EMAIL_2] = { "contents": [
                {
                    "name": "hi email ichisfdf",
                    "icon": ImgEuEmailIchiSmallIcon,
                    "icon_dim": new DHPoint(321, 22),
                    "icon_pos": new DHPoint(291, 100),
                    "folder_img": ImgEuEmailIchiSmall,
                    "folder_dim": new DHPoint(284, 356),
                    "struc": PopUpManager.HI_EMAIL_2,
                    "contents": [
                        {
                            "name": "hi email 1 small ichiefsf",
                            "icon": ImgEuEmailIchiIcon,
                            "icon_dim": new DHPoint(78, 92),
                            "icon_pos": new DHPoint(18, 240),
                            "dim": new DHPoint(653, 490),
                            "struc": PopUpManager.HI_EMAIL_2,
                            "contents": ImgEuEmailIchiPic
                        }
                    ]
                },
                {
                    "name": "hi link to email 1",
                    "icon": ImgHiMiniFlightLink,
                    "icon_dim": new DHPoint(323, 22),
                    "icon_pos": new DHPoint(292, 121),
                    "folder_dim": new DHPoint(284, 356),
                    "struc": PopUpManager.HI_EMAIL_2,
                    "folder_img": ImgHiMiniFlight,
                    "contents": [
                        {
                            "name": "mini link to expired flight in email 2",
                            "icon": ImgHiFlightLink,
                            "icon_dim": new DHPoint(225,18),
                            "icon_pos": new DHPoint(23, 218),
                            "dim": new DHPoint(945, 437),
                            "struc": PopUpManager.HI_EMAIL_2,
                            "contents": ImgHiFlightExpired
                        }]
                }
            ]};
            struc[PopUpManager.HI_SELFIE_DC] = { "contents": [
                {
                    "name": "hi friend 1",
                    "icon": ImgHiFriend1Icon,
                    "icon_dim": new DHPoint(70, 81),
                    "icon_pos": new DHPoint(28, 135),
                    "dim": new DHPoint(464, 356),
                    "struc": PopUpManager.HI_SELFIE_DC,
                    "contents": ImgHiFriend1
                },
                {
                    "name": "hi friend 2",
                    "icon": ImgHiFriend2Icon,
                    "icon_dim": new DHPoint(72, 79),
                    "icon_pos": new DHPoint(28, 35),
                    "dim": new DHPoint(464, 356),
                    "struc": PopUpManager.HI_SELFIE_DC,
                    "contents": ImgHiFriend2
                },
                {
                    "name": "hi friend 3",
                    "icon": ImgHiFriend3Icon,
                    "icon_dim": new DHPoint(70, 82),
                    "icon_pos": new DHPoint(108, 35),
                    "dim": new DHPoint(464, 356),
                    "struc": PopUpManager.HI_SELFIE_DC,
                    "contents": ImgHiFriend3
                },
                {
                    "name": "hi selfie 1",
                    "icon": ImgHiSelfie1Icon,
                    "icon_dim": new DHPoint(70, 80),
                    "icon_pos": new DHPoint(200, 35),
                    "dim": new DHPoint(464, 356),
                    "struc": PopUpManager.HI_SELFIE_DC,
                    "contents": ImgHiSelfie1
                },
                {
                    "name": "hi selfie 2",
                    "icon": ImgHiSelfie2Icon,
                    "icon_dim": new DHPoint(70, 81),
                    "icon_pos": new DHPoint(285, 35),
                    "dim": new DHPoint(336, 448),
                    "struc": PopUpManager.HI_SELFIE_DC,
                    "contents": ImgHiSelfie2
                },
                {
                    "name": "hi selfie 3",
                    "icon": ImgHiSelfie3Icon,
                    "icon_dim": new DHPoint(102, 82),
                    "icon_pos": new DHPoint(371, 35),
                    "dim": new DHPoint(336, 448),
                    "struc": PopUpManager.HI_SELFIE_DC,
                    "contents": ImgHiSelfie3
                },
                {
                    "name": "hi friend 4",
                    "icon": ImgFriend4Icon,
                    "icon_dim": new DHPoint(79, 92),
                    "icon_pos": new DHPoint(105, 131),
                    "dim": new DHPoint(720, 540),
                    "struc": PopUpManager.HI_SELFIE_DC,
                    "contents": ImgFriend4
                }
            ]};
            struc[PopUpManager.HI_EMAIL_3] = { "contents": [
                {
                    "name": "hi link to thermal",
                    "icon": ImgHiThermalIcon,
                    "icon_dim": new DHPoint(76, 82),
                    "icon_pos": new DHPoint(23, 230),
                    "dim": new DHPoint(631, 531),
                    "struc": PopUpManager.HI_EMAIL_3,
                    "contents": ImgHiThermalPoem
                },
                {
                    "name": "hi small ichi email",
                    "icon": ImgEuEmailIchiSmallIcon,
                    "icon_dim": new DHPoint(321, 22),
                    "icon_pos": new DHPoint(289, 100),
                    "folder_img": ImgEuEmailIchiSmall,
                    "folder_dim": new DHPoint(284, 356),
                    "struc": PopUpManager.HI_EMAIL_3,
                    "contents": [
                        {
                            "name": "hi email 1 small ichidffg",
                            "icon": ImgEuEmailIchiIcon,
                            "icon_dim": new DHPoint(78, 92),
                            "icon_pos": new DHPoint(18, 240),
                            "dim": new DHPoint(653, 490),
                            "struc": PopUpManager.HI_EMAIL_3,
                            "contents": ImgEuEmailIchiPic
                        }
                    ]
                },
                {
                    "name": "hi link to email 2 in 3",
                    "icon": ImgHiMiniClassEmailLink,
                    "icon_dim": new DHPoint(323, 22),
                    "icon_pos": new DHPoint(290, 120),
                    "dim": new DHPoint(284, 356),
                    "struc": PopUpManager.HI_EMAIL_3,
                    "contents": ImgHiMiniClassEmail
                },
                {
                    "name": "hi link to email 1 in 3",
                    "icon": ImgHiMiniFlightLink,
                    "icon_dim": new DHPoint(323, 22),
                    "icon_pos": new DHPoint(290, 143),
                    "folder_dim": new DHPoint(284, 356),
                    "struc": PopUpManager.HI_EMAIL_3,
                    "folder_img": ImgHiMiniFlight,
                    "contents": [
                        {
                            "name": "mini link to expired flight in email 2",
                            "icon": ImgHiFlightLink,
                            "icon_dim": new DHPoint(225,18),
                            "icon_pos": new DHPoint(23, 218),
                            "dim": new DHPoint(945, 437),
                            "struc": PopUpManager.HI_EMAIL_3,
                            "contents": ImgHiFlightExpired
                        }]
                }
            ]};
            return struc;
        }
    }
}
