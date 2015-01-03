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
            return struc;
        }
    }
}