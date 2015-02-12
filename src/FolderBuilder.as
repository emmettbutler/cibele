package{
    import com.starmaid.Cibele.utils.DHPoint;

    import org.flixel.*;

    import flash.events.Event;
    import flash.utils.Dictionary;

    public class FolderBuilder {
        [Embed(source="../assets/images/ui/UI_pink_x.png")] private var ImgInboxXPink:Class;

        public var leafPopups:Array;

        public function FolderBuilder() {
            leafPopups = new Array();
        }

        public function populateFolders(root:Object, elements:Array=null, root_folder:UIElement=null):void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            var cur:Object, curX:UIElement, spr:GameObject, icon_pos:DHPoint;
            if (root_folder != null) {
                root["folder_sprite"] = root_folder;
            }
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];
                if ("icon" in cur && cur["icon"] != null) {
                    spr = UIElement.fromPoint(cur["icon_pos"].add(root["folder_sprite"].pos));
                    spr.loadGraphic(cur["icon"], false, false, cur["icon_dim"].x, cur["icon_dim"].y);
                    spr.visible = false;
                    spr.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(spr);
                    if(elements != null) {
                        elements.push(spr);
                    }
                    cur["icon_sprite"] = spr;
                }
                if("hitbox_pos" in cur && "hitbox_dim" in cur) {
                    spr = UIElement.fromPoint(new DHPoint(cur["hitbox_pos"].x, cur["hitbox_pos"].y));
                    spr.makeGraphic(cur["hitbox_dim"].x, cur["hitbox_dim"].y, 0x00ff0000);
                    spr.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(spr);
                    if(elements != null) {
                        elements.push(spr);
                    }
                    cur["hitbox_sprite"] = spr;
                }
                if (cur["contents"] is Array) {
                    spr = UIElement.fromPoint(new DHPoint((_screen.screenWidth - cur["folder_dim"].x) * Math.random(), (_screen.screenHeight - cur["folder_dim"].y) * Math.random()));
                    spr.loadGraphic(cur["folder_img"], false, false, cur["folder_dim"].x, cur["folder_dim"].y);
                    spr.visible = false;
                    spr.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(spr);
                    cur["folder_sprite"] = spr;
                    curX = UIElement.fromPoint(new DHPoint(spr.x + spr.width - 23 - 2, spr.y + 2));
                    curX.loadGraphic(ImgInboxXPink, false, false, 23, 18);
                    curX.visible = false;
                    curX.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(curX);
                    curX.ID = 00000000000001;
                    if(elements != null) {
                        elements.push(spr);
                        elements.push(curX);
                    }
                    cur["x_sprite"] = curX;

                    this.populateFolders(cur, elements);
                } else {
                    spr = UIElement.fromPoint(new DHPoint((_screen.screenWidth - cur["dim"].x) * Math.random(), (_screen.screenHeight - cur["dim"].y) * Math.random()));
                    spr.loadGraphic(cur["contents"], false, false, cur["dim"].x, cur["dim"].y);
                    spr.visible = false;
                    curX = UIElement.fromPoint(new DHPoint(spr.x + spr.width - 23 - 2, spr.y + 2));
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
                        if(cur[this.getHitboxKey(cur)].visible) {
                            //checkForVisiblePopups needs fixing bc
                            //when this is uncommented some subfolders
                            //wont open TODO
                            //if(this.checkForVisiblePopups(cur[this.getHitboxKey(cur)]._getRect(), root)) {
                                cur["folder_sprite"].visible = true;
                                cur["x_sprite"].visible = true;
                                this.setIconVisibility(cur, true);
                                propagateClick = false;
                            //}
                        }
                    }
                    if (propagateClick) {
                        this.resolveClick(cur, mouse_rect);
                    }
                } else {
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

        public function checkForVisiblePopups(hitbox:FlxRect, root:Object):Boolean {
            var cur:Object;
            var i:Number = 0;
            for (i = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];

                if (cur["contents"] is Array) {
                    if("folder_sprite" in cur) {
                        if(cur["folder_sprite"].visible && cur["folder_sprite"]._getRect().overlaps(hitbox)) {
                            return false;
                        }
                    }
                }
            }
            if(PopUpManager.getInstance().open_popups != null) {
                for(i = 0; i < PopUpManager.getInstance().open_popups.length; i++) {
                    if(PopUpManager.getInstance().open_popups[i] != null) {
                        if(PopUpManager.getInstance().open_popups[i].visible && PopUpManager.getInstance().open_popups[i]._getRect().overlaps(hitbox)) {
                            return false;
                        }
                    }
                }
            }
            return true;
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

        public function setUpLeafPopups(elements:Array=null):void {
            var cur:Object;
            for (var k:int = 0; k < this.leafPopups.length; k++) {
                cur = this.leafPopups[k];
                FlxG.state.add(cur["sprite"]);
                FlxG.state.add(cur["x"]);
                if(elements != null) {
                    elements.push(cur["sprite"]);
                    elements.push(cur["x"]);
                }
            }
        }
    }
}
