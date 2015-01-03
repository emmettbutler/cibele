package {
    import org.flixel.*;
    import flash.utils.Dictionary;

    public class PopupHierarchies {
        [Embed(source="../assets/popups/test/marmlink1.png")] private static var ImgMarmaladeLink1:Class;
        [Embed(source="../assets/popups/test/marmlink2.png")] private static var ImgMarmaladeLink2:Class;
        [Embed(source="../assets/popups/test/marm1.jpg")] private static var ImgMarmalade1:Class;
        [Embed(source="../assets/popups/test/marm2.jpg")] private static var ImgMarmalade2:Class;
        [Embed(source="../assets/popups/test/ichiicon.png")] private static var ImgIchiIcon:Class;
        [Embed(source="../assets/popups/test/emmy.jpg")] private static var ImgIchiDL1:Class;
        [Embed(source="../assets/popups/it_email/bulldoghell_icon.png")] private static var ImgBHIcon:Class;
        [Embed(source="../assets/popups/it_email/bulldoghell.png")] private static var ImgBH:Class;
        [Embed(source="../assets/popups/it_email/ichiselfie1.png")] private static var ImgIchiSelfie1:Class;
        [Embed(source="../assets/popups/it_email/ichiselfieicon1.png")] private static var ImgIchiSelfie1Icon:Class;
        [Embed(source="../assets/popups/files/camera1disconnecticon.png")] private static var ImgCibCamDisconnectIcon:Class;
        [Embed(source="../assets/popups/files/camera1selfie.png")] private static var ImgCibCam1:Class;
        [Embed(source="../assets/popups/files/camera1selfieicon.png")] private static var ImgCibCam1Icon:Class;
        [Embed(source="../assets/popups/files/camera1.png")] private static var ImgCibSelfieFolder:Class;

        public static function build():Dictionary {
            var struc:Dictionary = new Dictionary();

            struc[PopUpManager.MARMALADE] = { "contents": [
                {
                    "name": "marmalade_link_1",
                    "icon": ImgMarmaladeLink1,
                    "icon_dim": new DHPoint(90, 95),
                    "icon_pos": new DHPoint(449, 93),
                    "dim": new DHPoint(614, 461),
                    "contents": ImgMarmalade1
                },
                {
                    "name": "marmalade_link_2",
                    "icon": ImgMarmaladeLink2,
                    "icon_dim": new DHPoint(203, 185),
                    "icon_pos": new DHPoint(558, 317),
                    "dim": new DHPoint(593, 421),
                    "contents": ImgMarmalade2
                }
            ]};
            struc[PopUpManager.ICHI_DL_2] = { "contents": [
                {
                    "name": "ichi dl 2 link",
                    "icon": ImgIchiIcon,
                    "icon_dim": new DHPoint(70, 81),
                    "icon_pos": new DHPoint(148, 35),
                    "dim": new DHPoint(480, 640),
                    "contents": ImgIchiDL1
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
            struc[PopUpManager.ICHI_SELFIE1] = { "contents": [
                {
                    "name": "ichi selfie email 1",
                    "icon": ImgIchiSelfie1Icon,
                    "icon_dim": new DHPoint(70, 86),
                    "icon_pos": new DHPoint(23, 210),
                    "dim": new DHPoint(433, 356),
                    "contents": ImgIchiSelfie1
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
            return struc;
        }
    }
}