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
                    "folder_img": ImgMarmaladeLink1,
                    "folder_dim": new DHPoint(90, 95),
                    "hitbox_pos": new DHPoint(449, 93),
                    "hitbox_dim": new DHPoint(90, 95),
                    "contents": ImgMarmalade1
                },
                {
                    "name": "marmalade_link_2",
                    "folder_img": ImgMarmaladeLink2,
                    "folder_dim": new DHPoint(203, 185),
                    "hitbox_pos": new DHPoint(558, 317),
                    "hitbox_dim": new DHPoint(203, 185),
                    "contents": ImgMarmalade2
                }
            ]};
            struc[PopUpManager.BULLDOG_HELL] = {};
            return struc;
        }
    }
}