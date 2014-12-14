package {
    import org.flixel.*;
    import flash.utils.Dictionary;

    public class PopupHierarchies {
        [Embed(source="../assets/popups/test/marmlink1.png")] private static var ImgMarmaladeLink1:Class;
        [Embed(source="../assets/popups/test/marmlink2.png")] private static var ImgMarmaladeLink2:Class;
        [Embed(source="../assets/popups/test/marm1.jpg")] private static var ImgMarmalade1:Class;
        [Embed(source="../assets/popups/test/marm2.jpg")] private static var ImgMarmalade2:Class;

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
            //struc[PopUpManager.BULLDOG_HELL] = {};
            return struc;
        }
    }
}