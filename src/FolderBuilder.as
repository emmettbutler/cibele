package{
    import org.flixel.*;

    import flash.events.Event;
    import flash.utils.Dictionary;

    public class FolderBuilder {
        [Embed(source="../assets/UI_pink_x.png")] private var ImgInboxXPink:Class;

        public var leafPopups:Array;

        public function FolderBuilder() {
            leafPopups = new Array();
        }

        public function populateFolders(root:Object, root_folder:UIElement=null):void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            var cur:Object, curX:GameObject, spr:GameObject, icon_pos:DHPoint;
            if (root_folder != null) {
                root["folder_sprite"] = root_folder;
            }
            for (var i:int = 0; i < root["contents"].length; i++) {
                var mult:DHPoint = new DHPoint(Math.random() * .6, Math.random() * .6);
                cur = root["contents"][i];
                if ("icon" in cur && cur["icon"] != null) {
                    spr = new GameObject(cur["icon_pos"].add(root["folder_sprite"].pos));
                    spr.loadGraphic(cur["icon"], false, false, cur["icon_dim"].x, cur["icon_dim"].y);
                    spr.visible = false;
                    spr.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(spr);
                    cur["icon_sprite"] = spr;
                }
                if("hitbox_pos" in cur && "hitbox_dim" in cur) {
                    spr = new GameObject(new DHPoint(cur["hitbox_pos"].x, cur["hitbox_pos"].y));
                    spr.makeGraphic(cur["hitbox_dim"].x, cur["hitbox_dim"].y, 0x00ff0000);
                    spr.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(spr);
                    cur["hitbox_sprite"] = spr;
                }
                if (cur["contents"] is Array) {
                    spr = new GameObject(new DHPoint(_screen.screenWidth * mult.x, _screen.screenHeight * mult.y));
                    spr.loadGraphic(cur["folder_img"], false, false, cur["folder_dim"].x, cur["folder_dim"].y);
                    spr.visible = false;
                    spr.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(spr);
                    cur["folder_sprite"] = spr;
                    curX = new GameObject(new DHPoint(spr.x + spr.width - 23 - 2, spr.y + 2));
                    curX.loadGraphic(ImgInboxXPink, false, false, 23, 18);
                    curX.visible = false;
                    curX.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(curX);
                    cur["x_sprite"] = curX;

                    this.populateFolders(cur);
                } else {
                    spr = new GameObject(new DHPoint(_screen.screenWidth * mult.x, _screen.screenHeight * mult.y));
                    spr.loadGraphic(cur["contents"], false, false, cur["dim"].x, cur["dim"].y);
                    spr.visible = false;
                    curX = new GameObject(new DHPoint(spr.x + spr.width - 23 - 2, spr.y + 2));
                    curX.loadGraphic(ImgInboxXPink, false, false, 23, 18);
                    curX.visible = false;
                    this.leafPopups.push({"sprite": spr, "x": curX});
                    spr.scrollFactor = new DHPoint(0,0);
                    curX.scrollFactor = new DHPoint(0,0);
                    cur["full_sprite"] = spr;
                    cur["x_sprite"] = curX;
                }
            }
        }

        public function resolveClick(root:Object, mouse_rect:FlxRect):void {
            var spr:GameObject, icon_pos:DHPoint, cur:Object, cur_icon:Object,
                propagateClick:Boolean = true;
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];

                if (cur["contents"] is Array) {
                    if (cur["folder_sprite"].visible) {
                        if(mouse_rect.overlaps(cur["x_sprite"]._getRect())) {
                            propagateClick = false;
                            cur["folder_sprite"].visible = false;
                            cur["x_sprite"].visible = false;
                            this.setIconVisibility(cur, false);
                        }
                    } else if (mouse_rect.overlaps(cur[this.getHitboxKey(cur)]._getRect())) {
                        cur["folder_sprite"].visible = true;
                        cur["x_sprite"].visible = true;
                        this.setIconVisibility(cur, true);
                        propagateClick = false;
                    }
                    if (propagateClick) {
                        this.resolveClick(cur, mouse_rect);
                    }
                } else {
                    FlxG.log(mouse_rect.overlaps(cur["icon_sprite"]._getRect()));
                    if (mouse_rect.overlaps(cur["icon_sprite"]._getRect()) && cur["icon_sprite"].visible)
                    {
                        cur["full_sprite"].visible = true;
                        cur["x_sprite"].visible = true;
                    }
                    if (cur["x_sprite"].visible && mouse_rect.overlaps(cur["x_sprite"]._getRect())){
                        cur["full_sprite"].visible = false;
                        cur["x_sprite"].visible = false;
                    }
                }
            }
        }

        public function getHitboxKey(obj:Object):String {
            if ("icon_sprite" in obj) {
                return "icon_sprite";
            }
            return "hitbox_sprite";
        }

        public function setIconVisibility(node:Object, vis:Boolean):void {
            var cur_icon:Object;
            for (var k:int = 0; k < node["contents"].length; k++) {
                cur_icon = node["contents"][k];
                if ("icon_sprite" in cur_icon) {
                    cur_icon["icon_sprite"].visible = vis;
                }
            }
        }

        public function setUpLeafPopups():void {
            var cur:Object;
            for (var k:int = 0; k < this.leafPopups.length; k++) {
                cur = this.leafPopups[k];
                FlxG.state.add(cur["sprite"]);
                FlxG.state.add(cur["x"]);
            }
        }
    }
}