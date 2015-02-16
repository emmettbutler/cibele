package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.utils.Dictionary;

    public class PopupHierarchies {
        [Embed(source="/../assets/images/ui/popups/files/bday_icon.png")] private static var ImgBdayIcon:Class;
        [Embed(source="/../assets/images/ui/popups/files/it_bday.png")] private static var ImgBday:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/bulldoghell_icon.png")] private static var ImgBHIcon:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/bulldoghell.png")] private static var ImgBH:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/ichiselfie1.png")] private static var ImgIchiSelfie1:Class;
        [Embed(source="/../assets/images/ui/popups/it_email/ichiselfieicon1.png")] private static var ImgIchiSelfie1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/files/camera1disconnecticon.png")] private static var ImgCibCamDisconnectIcon:Class;
        [Embed(source="/../assets/images/ui/popups/files/camera1selfie.png")] private static var ImgCibCam1:Class;
        [Embed(source="/../assets/images/ui/popups/files/camera1selfieicon.png")] private static var ImgCibCam1Icon:Class;
        [Embed(source="/../assets/images/ui/popups/ichidownloads.png")] private static var ImgCibSelfieFolder:Class;
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

        public static function build():Dictionary {
            var struc:Dictionary = new Dictionary();
            struc[PopUpManager.ICHI_DL_2] = { "contents": [
                {
                    "name": "friends_1",
                    "icon": ImgFriends1Icon,
                    "icon_dim": new DHPoint(70, 84),
                    "icon_pos": new DHPoint(28, 35),
                    "dim": new DHPoint(338, 451),
                    "contents": ImgFriends1
                },
                {
                    "name": "bday",
                    "icon": ImgBdayIcon,
                    "icon_dim": new DHPoint(100, 93),
                    "icon_pos": new DHPoint(108, 35),
                    "dim": new DHPoint(631, 356),
                    "contents": ImgBday
                },
                {
                    "name": "friend_selfie1",
                    "icon": ImgFriendSelfie1Icon,
                    "icon_dim": new DHPoint(75, 86),
                    "icon_pos": new DHPoint(220, 35),
                    "dim": new DHPoint(512, 356),
                    "contents": ImgFriendSelfie1
                },
                {
                    "name": "friends_2",
                    "icon": ImgFriends2Icon,
                    "icon_dim": new DHPoint(70, 85),
                    "icon_pos": new DHPoint(320, 35),
                    "dim": new DHPoint(512, 356),
                    "contents": ImgFriends2
                },
                {
                    "name": "home_1",
                    "icon": ImgHome1Icon,
                    "icon_dim": new DHPoint(117, 86),
                    "icon_pos": new DHPoint(400, 35),
                    "dim": new DHPoint(512, 356),
                    "contents": ImgHome1
                },
                {
                    "name": "pretty",
                    "icon": ImgPrettyIcon,
                    "icon_dim": new DHPoint(70, 85),
                    "icon_pos": new DHPoint(28, 135),
                    "dim": new DHPoint(512, 356),
                    "contents": ImgPretty
                }
            ]};
            struc[PopUpManager.ICHI_SELFIE1] = { "contents": [
                {
                    "name": "ichi selfie email 1",
                    "icon": ImgIchiSelfie1Icon,
                    "icon_dim": new DHPoint(70, 86),
                    "icon_pos": new DHPoint(23, 210),
                    "dim": new DHPoint(433, 356),
                    "contents": ImgIchiSelfie1
                },
                {
                    "name": "ichi selfie email sub 1",
                    "icon": ImgIchiSelfieSubLink1,
                    "icon_dim": new DHPoint(325, 22),
                    "icon_pos": new DHPoint(290, 100),
                    "dim": new DHPoint(280, 356),
                    "contents": ImgIchiSelfieSub1
                },
                {
                    "name": "ichi selfie email link",
                    "icon": ImgGuilLink1,
                    "icon_dim": new DHPoint(327, 20),
                    "icon_pos": new DHPoint(290, 126),
                    "folder_dim": new DHPoint(280, 356),
                    "folder_img": ImgGuilSub,
                    "contents": [
                        {
                            "name": "ichi selfie sub bulldog hell",
                            "icon": ImgBHIcon,
                            "icon_dim": new DHPoint(74, 14),
                            "icon_pos": new DHPoint(180, 106),
                            "dim": new DHPoint(1030, 437),
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
                    "dim": new DHPoint(1030, 437),
                    "contents": ImgBH
                }
            ]};
            struc[PopUpManager.GUIL_1] = { "contents": [
                {
                    "name": "guil email link",
                    "icon": ImgGuilLink1,
                    "icon_dim": new DHPoint(327, 20),
                    "icon_pos": new DHPoint(290, 98),
                    "folder_dim": new DHPoint(280, 356),
                    "folder_img": ImgGuilSub,
                    "contents": [
                        {
                            "name": "guil sub bulldog hell",
                            "icon": ImgBHIcon,
                            "icon_dim": new DHPoint(74, 14),
                            "icon_pos": new DHPoint(180, 106),
                            "dim": new DHPoint(1030, 437),
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
                    "folder_img": ImgCibSelfieFolder,
                    "contents": [
                        {
                            "name": "cam selfies",
                            "icon": ImgCibCam1Icon,
                            "icon_dim": new DHPoint(103, 81),
                            "icon_pos": new DHPoint(118, 135),
                            "dim": new DHPoint(530, 356),
                            "contents": ImgCibCam1
                        },
                        {
                            "name": "friends_1",
                            "icon": ImgFriends1Icon,
                            "icon_dim": new DHPoint(70, 84),
                            "icon_pos": new DHPoint(28, 35),
                            "dim": new DHPoint(338, 451),
                            "contents": ImgFriends1
                        },
                        {
                            "name": "bday",
                            "icon": ImgBdayIcon,
                            "icon_dim": new DHPoint(100, 93),
                            "icon_pos": new DHPoint(108, 35),
                            "dim": new DHPoint(631, 356),
                            "contents": ImgBday
                        },
                        {
                            "name": "friend_selfie1",
                            "icon": ImgFriendSelfie1Icon,
                            "icon_dim": new DHPoint(75, 86),
                            "icon_pos": new DHPoint(220, 35),
                            "dim": new DHPoint(512, 356),
                            "contents": ImgFriendSelfie1
                        },
                        {
                            "name": "friends_2",
                            "icon": ImgFriends2Icon,
                            "icon_dim": new DHPoint(70, 85),
                            "icon_pos": new DHPoint(320, 35),
                            "dim": new DHPoint(512, 356),
                            "contents": ImgFriends2
                        },
                        {
                            "name": "home_1",
                            "icon": ImgHome1Icon,
                            "icon_dim": new DHPoint(117, 86),
                            "icon_pos": new DHPoint(400, 35),
                            "dim": new DHPoint(512, 356),
                            "contents": ImgHome1
                        },
                        {
                            "name": "pretty",
                            "icon": ImgPrettyIcon,
                            "icon_dim": new DHPoint(70, 85),
                            "icon_pos": new DHPoint(28, 135),
                            "dim": new DHPoint(512, 356),
                            "contents": ImgPretty
                        }
                    ]
                }
            ]};
            struc[PopUpManager.EU_EMAIL_SELFIE] = { "contents": [
                {
                    "name": "eu email selfie link 1",
                    "icon": ImgEuEmailSelfieLink,
                    "icon_dim": new DHPoint(154, 19),
                    "icon_pos": new DHPoint(18, 186),
                    "dim": new DHPoint(998, 606),
                    "contents": ImgEuEmailSelfieNetThread
                },
                {
                    "name": "eu email selfie link 2",
                    "icon": ImgEuEmail2Link1,
                    "icon_dim": new DHPoint(325, 21),
                    "icon_pos": new DHPoint(293, 102),
                    "dim": new DHPoint(284, 356),
                    "contents": ImgEuEmailSmallEmail1
                }
            ]};
            struc[PopUpManager.EU_EMAIL_2] = { "contents": [
                {
                    "name": "eu email 2 link 1",
                    "icon": ImgEuEmail2Link1,
                    "icon_dim": new DHPoint(325, 21),
                    "icon_pos": new DHPoint(293, 101),
                    "dim": new DHPoint(284, 356),
                    "contents": ImgEuEmailSmallEmail1
                },
                {
                    "name": "eu email 2 link 2",
                    "icon": ImgEuEmail2Link2,
                    "icon_dim": new DHPoint(225, 18),
                    "icon_pos": new DHPoint(20, 219),
                    "dim": new DHPoint(1023, 515),
                    "contents": ImgEuEmail2Flight
                },
                {
                    "name": "eu email 2 link 3",
                    "icon": ImgEuEmailSelfieMiniLink,
                    "icon_dim": new DHPoint(319, 22),
                    "icon_pos": new DHPoint(294, 124),
                    "folder_dim": new DHPoint(284, 356),
                    "folder_img": ImgEuMiniSelfieEmail,
                    "contents": [
                        {
                            "name": "eu mini selfie email",
                            "icon": ImgEuEmailSelfieLink,
                            "icon_dim": new DHPoint(154, 19),
                            "icon_pos": new DHPoint(20, 184),
                            "dim": new DHPoint(998, 606),
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
                    "contents": ImgEuFile1Bed
                },
                {
                    "name": "cutewow pic",
                    "icon": ImgEuFile1BedIcon,
                    "icon_dim": new DHPoint(81, 93),
                    "icon_pos": new DHPoint(118, 33),
                    "dim": new DHPoint(530, 356),
                    "contents": ImgEuFile1CuteWow
                },
                {
                    "name": "old pic",
                    "icon": ImgEuFile1OldIcon,
                    "icon_dim": new DHPoint(80, 93),
                    "icon_pos": new DHPoint(214, 33),
                    "dim": new DHPoint(530, 356),
                    "contents": ImgEuFile1Old
                },
                {
                    "name": "ollld pic",
                    "icon": ImgEuFile1OllldIcon,
                    "icon_dim": new DHPoint(84, 95),
                    "icon_pos": new DHPoint(305, 33),
                    "dim": new DHPoint(530, 356),
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
                    "contents": ImgForCibby
                },
                {
                    "name": "eu selfie 1",
                    "icon": ImgEUSelfie1Icon,
                    "icon_dim": new DHPoint(104, 86),
                    "icon_pos": new DHPoint(120, 32),
                    "dim": new DHPoint(512, 356),
                    "contents": ImgEUSelfie1
                }
            ]};
            return struc;
        }
    }
}
