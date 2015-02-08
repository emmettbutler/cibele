package {
    import org.flixel.*;
    import flash.utils.Dictionary;

    public class PopupHierarchies {
        [Embed(source="../assets/images/ui/popups/ichiicon.png")] private static var ImgIchiIcon:Class;
        [Embed(source="../assets/images/ui/popups/files/ichiselfie1.png")] private static var ImgIchiDL1:Class;
        [Embed(source="../assets/images/ui/popups/it_email/bulldoghell_icon.png")] private static var ImgBHIcon:Class;
        [Embed(source="../assets/images/ui/popups/it_email/bulldoghell.png")] private static var ImgBH:Class;
        [Embed(source="../assets/images/ui/popups/it_email/ichiselfie1.png")] private static var ImgIchiSelfie1:Class;
        [Embed(source="../assets/images/ui/popups/it_email/ichiselfieicon1.png")] private static var ImgIchiSelfie1Icon:Class;
        [Embed(source="../assets/images/ui/popups/files/camera1disconnecticon.png")] private static var ImgCibCamDisconnectIcon:Class;
        [Embed(source="../assets/images/ui/popups/files/camera1selfie.png")] private static var ImgCibCam1:Class;
        [Embed(source="../assets/images/ui/popups/files/camera1selfieicon.png")] private static var ImgCibCam1Icon:Class;
        [Embed(source="../assets/images/ui/popups/files/camera1.png")] private static var ImgCibSelfieFolder:Class;
        [Embed(source="../assets/images/ui/popups/it_email/guil1_sub1link.png")] private static var ImgGuilLink1:Class;
        [Embed(source="../assets/images/ui/popups/it_email/guil1_sub1.png")] private static var ImgGuilSub:Class;
        [Embed(source="../assets/images/ui/popups/it_email/ichiselfieemail_sub1.png")] private static var ImgIchiSelfieSub1:Class;
        [Embed(source="../assets/images/ui/popups/it_email/ichiselfieemail_link1.png")] private static var ImgIchiSelfieSubLink1:Class;

        //euryale
        [Embed(source="../assets/images/ui/popups/eu_email/email2_link1.png")] private static var ImgEuEmail2Link1:Class;
        [Embed(source="../assets/images/ui/popups/eu_email/email2_link2.png")] private static var ImgEuEmail2Link2:Class;
        [Embed(source="../assets/images/ui/popups/eu_email/email2_flight.png")] private static var ImgEuEmail2Flight:Class;
        [Embed(source="../assets/images/ui/popups/eu_email/small_email1.png")] private static var ImgEuEmailSmallEmail1:Class;
        [Embed(source="../assets/images/ui/popups/eu_files/bed_icon.png")] private static var ImgEuFile1BedIcon:Class;
        [Embed(source="../assets/images/ui/popups/eu_files/bed.png")] private static var ImgEuFile1Bed:Class;
        [Embed(source="../assets/images/ui/popups/eu_files/cutewow_icon.png")] private static var ImgEuFile1CuteWowIcon:Class;
        [Embed(source="../assets/images/ui/popups/eu_files/cutewow.png")] private static var ImgEuFile1CuteWow:Class;
        [Embed(source="../assets/images/ui/popups/eu_files/old_icon.png")] private static var ImgEuFile1OldIcon:Class;
        [Embed(source="../assets/images/ui/popups/eu_files/old.png")] private static var ImgEuFile1Old:Class;
        [Embed(source="../assets/images/ui/popups/eu_files/ollld.png")] private static var ImgEuFile1Ollld:Class;
        [Embed(source="../assets/images/ui/popups/eu_files/ollld_icon.png")] private static var ImgEuFile1OllldIcon:Class;
        [Embed(source="../assets/images/ui/popups/eu_email/emailselfie_link.png")] private static var ImgEuEmailSelfieLink:Class;
        [Embed(source="../assets/images/ui/popups/eu_net/ichiselfiethread.png")] private static var ImgEuEmailSelfieNetThread:Class;
        [Embed(source="../assets/images/ui/popups/eu_email/miniemailselfie_link.png")] private static var ImgEuEmailSelfieMiniLink:Class;
        [Embed(source="../assets/images/ui/popups/eu_email/small_emailselfie.png")] private static var ImgEuMiniSelfieEmail:Class;

        public static function build():Dictionary {
            var struc:Dictionary = new Dictionary();
            struc[PopUpManager.ICHI_DL_2] = { "contents": [
                {
                    "name": "ichi dl 2 link",
                    "icon": ImgIchiIcon,
                    "icon_dim": new DHPoint(70, 81),
                    "icon_pos": new DHPoint(148, 35),
                    "dim": new DHPoint(336, 448),
                    "contents": ImgIchiDL1
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
                            "dim": new DHPoint(1030, 510),
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
                    "dim": new DHPoint(1030, 510),
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
                            "dim": new DHPoint(1030, 510),
                            "contents": ImgBH
                        }]
                }
            ]};
            struc[PopUpManager.CIB_SELFIE_FOLDER] = { "contents": [
                {
                    "name": "cib camera selfies 1",
                    "icon": ImgCibCamDisconnectIcon,
                    "icon_dim": new DHPoint(215, 21),
                    "icon_pos": new DHPoint(25, 65),
                    "folder_dim": new DHPoint(631, 356),
                    "folder_img": ImgCibSelfieFolder,
                    "contents": [
                        {
                            "name": "cam selfies",
                            "icon": ImgCibCam1Icon,
                            "icon_dim": new DHPoint(70, 81),
                            "icon_pos": new DHPoint(69, 84),
                            "dim": new DHPoint(530, 356),
                            "contents": ImgCibCam1
                        }]
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
            return struc;
        }
    }
}
