package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.UIElement;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.entities.XSprite;

    import org.flixel.*;

    import flash.events.Event;
    import flash.utils.Dictionary;

    public class FolderBuilder {
        [Embed(source="/../assets/images/ui/UI_pink_x.png")] private var ImgInboxXPink:Class;
        [Embed(source="/../assets/images/ui/UI_pink_x_hover.png")] private var ImgInboxXPinkHover:Class;
        [Embed(source="/../assets/images/ui/email_link_bg.png")] private static var ImgEmailLinkBg:Class;

        public var leafPopups:Array, allClickableElements:Array;

        public static const HITBOX_TAG:String = "hitbox_sprite";

        public function FolderBuilder() {
            leafPopups = new Array();
            allClickableElements = new Array();
        }

        public function updateFolderPositions(root:Object):void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            var cur:Object, curX:UIElement, spr:GameObject, icon_pos:DHPoint;
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];
                if ("icon" in cur && cur["icon"] != null) {
                    cur["icon_sprite"].setPos(cur["icon_pos"].add(root["folder_sprite"].pos));
                }
                if("hitbox_pos" in cur && "hitbox_dim" in cur) {
                    cur["hitbox_sprite"].updatePos();
                }
                if (cur["contents"] is Array) {
                    cur["folder_sprite"].updatePos();
                    cur["x_sprite"].setPos(new DHPoint(cur["folder_sprite"].x + cur["folder_sprite"].width - 26, cur["folder_sprite"].y - 5));
                    cur["x_hover_sprite"].setPos(new DHPoint(cur["folder_sprite"].x + cur["folder_sprite"].width - 26, cur["folder_sprite"].y - 5));

                    this.updateFolderPositions(cur);
                } else {
                    cur["full_sprite"].updatePos();
                    cur["x_sprite"].setPos(new DHPoint(cur['full_sprite'].x + cur["full_sprite"].width - 26, cur["full_sprite"].y - 5));
                    cur["x_hover_sprite"].setPos(new DHPoint(cur['full_sprite'].x + cur["full_sprite"].width - 26, cur["full_sprite"].y - 5));
                }
            }
        }

        public function removeFolders(root:Object):void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            var cur:Object, recurseSet:Array;
            recurseSet = new Array();
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];
                if ("icon" in cur && cur["icon"] != null) {
                    cur["icon_sprite"].destroy();
                    cur["icon_sprite"] = null;
                    if("email_link_sprite" in cur && cur["email_link_sprite"] != null) {
                        cur["email_link_sprite"].destroy();
                        cur["email_link_sprite"] = null;
                    }
                }
                if("hitbox_pos" in cur && "hitbox_dim" in cur) {
                    cur["hitbox_sprite"].destroy();
                    cur["hitbox_sprite"] = null;
                }
                if (cur["contents"] is Array) {
                    recurseSet.push([cur])
                } else {
                    cur["full_sprite"].destroy();
                    cur["full_sprite"] = null;
                    cur["x_sprite"].destroy();
                    cur["x_sprite"] = null;
                    cur["x_hover_sprite"].destroy();
                    cur["x_hover_sprite"] = null;
                }
            }
            // add all folder sprites at the same time, before recursion
            for (var k:int = 0; k < recurseSet.length; k++) {
                this.removeFolders(recurseSet[k][0]);
            }
            for (k = 0; k < recurseSet.length; k++) {
                recurseSet[k][0]["folder_sprite"].destroy();
                recurseSet[k][0]["folder_sprite"] = null;
                recurseSet[k][0]["x_sprite"].destroy();
                recurseSet[k][0]["x_sprite"] = null;
                recurseSet[k][0]["x_hover_sprite"].destroy();
                recurseSet[k][0]["x_hover_sprite"] = null;
                if(recurseSet[k][0]["email_link_sprite"] != null) {
                    recurseSet[k][0]["email_link_sprite"].destroy();
                    recurseSet[k][0]["email_link_sprite"] = null;
                }
            }
        }

        public function populateFolders(root:Object, elements:Array=null, root_folder:UIElement=null):void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            var cur:Object, curX:UIElement, curXHover:UIElement, curEmailLink:UIElement, spr:GameObject,
                icon_pos:DHPoint, recurseSet:Array;
            if (root_folder != null) {
                root["folder_sprite"] = root_folder;
            }
            recurseSet = new Array();
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];
                if("email_link" in cur && cur["email_link"] == true) {
                    curEmailLink = UIElement.fromPoint(cur["icon_pos"].add(root["folder_sprite"].pos).sub(new DHPoint(7, 4)));
                    curEmailLink.loadGraphic(ImgEmailLinkBg, false, false, 337, 29);
                    curEmailLink.scrollFactor = new DHPoint(0,0);
                    curEmailLink.visible = false;
                    FlxG.state.add(curEmailLink);
                    if(elements != null) {
                        elements.push(curEmailLink);
                    }
                    cur["email_link_sprite"] = curEmailLink;
                    allClickableElements.push(curEmailLink);
                }
                if ("icon" in cur && cur["icon"] != null) {
                    spr = UIElement.fromPoint(cur["icon_pos"].add(root["folder_sprite"].pos));
                    var _icon:Class = cur["icon"];
                    if (cur.hasOwnProperty("commentary_file") && ScreenManager.getInstance().COMMENTARY) {
                        _icon = cur["commentary_icon"];
                    }
                    spr.loadGraphic(_icon, false, false, cur["icon_dim"].x, cur["icon_dim"].y);
                    spr.visible = false;
                    spr.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(spr);
                    allClickableElements.push(spr);
                    if(elements != null) {
                        elements.push(spr);
                    }
                    cur["icon_sprite"] = spr;
                }
                if("hitbox_pos" in cur && "hitbox_dim" in cur) {
                    spr = UIElement.fromPoint(new DHPoint(cur["hitbox_pos"].x, cur["hitbox_pos"].y));
                    spr.makeGraphic(cur["hitbox_dim"].x * ScreenManager.getInstance().calcFullscreenScale(new DHPoint(3000, 1636)), cur["hitbox_dim"].y * ScreenManager.getInstance().calcFullscreenScale(new DHPoint(3000, 1636)), 0x00ff0000);
                    spr.scrollFactor = new DHPoint(0,0);
                    spr.slug = HITBOX_TAG;
                    spr.alpha = 0;
                    FlxG.state.add(spr);
                    allClickableElements.push(spr);
                    if(elements != null) {
                        elements.push(spr);
                    }
                    cur["hitbox_sprite"] = spr;
                }
                if (cur["contents"] is Array) {
                    spr = UIElement.fromPoint(
                        new DHPoint(
                            (_screen.screenWidth - cur["folder_dim"].x) * Math.random(),
                            // extra 80 px to avoid overlapping dock
                            (_screen.screenHeight - cur["folder_dim"].y - 80) * Math.random()
                        )
                    );
                    spr.loadGraphic(cur["folder_img"], false, false, cur["folder_dim"].x, cur["folder_dim"].y);
                    spr.visible = false;
                    spr.scrollFactor = new DHPoint(0,0);
                    var grp:Array = new Array();
                    grp.push(spr);
                    cur["folder_sprite"] = spr;
                    curX = XSprite.fromPoint(new DHPoint(spr.x + spr.width - 26, spr.y - 5));
                    curX.loadGraphic(ImgInboxXPink, false, false, 32, 29);
                    curX.visible = false;
                    curX.scrollFactor = new DHPoint(0,0);
                    grp.push(curX);

                    curXHover = XSprite.fromPoint(new DHPoint(spr.x + spr.width - 26, spr.y - 5));
                    curXHover.loadGraphic(ImgInboxXPinkHover, false, false, 32, 29);
                    curXHover.visible = false;
                    curXHover.scrollFactor = new DHPoint(0,0);
                    grp.push(curXHover);

                    curX.ID = 00000000000001;
                    allClickableElements.push(spr);
                    allClickableElements.push(curX);
                    allClickableElements.push(curXHover);
                    if(elements != null) {
                        elements.push(spr);
                        elements.push(curX);
                        elements.push(curXHover);
                    }
                    cur["x_sprite"] = curX;
                    cur["x_hover_sprite"] = curXHover;

                    recurseSet.push([cur, elements, grp])
                } else {
                    spr = UIElement.fromPoint(
                        new DHPoint(
                            (_screen.screenWidth - cur["dim"].x) * Math.random(),
                            // extra 80 px to avoid overlapping dock
                            (_screen.screenHeight - cur["dim"].y - 80) * Math.random()
                        )
                    );
                    spr.loadGraphic(cur["contents"], false, false, cur["dim"].x, cur["dim"].y);
                    spr.visible = false;
                    if(spr.y - 5 < 0) {
                        spr.y = 0;
                    }
                    curX = XSprite.fromPoint(new DHPoint(spr.x + spr.width - 26, spr.y - 5));
                    curX.loadGraphic(ImgInboxXPink, false, false, 32, 29);
                    curX.visible = false;
                    curXHover = XSprite.fromPoint(new DHPoint(spr.x + spr.width - 26, spr.y - 5));
                    curXHover.loadGraphic(ImgInboxXPinkHover, false, false, 32, 29);
                    curXHover.visible = false;
                    this.leafPopups.push({"sprite": spr, "x": curX, "x_hover": curXHover});
                    allClickableElements.push(spr);
                    allClickableElements.push(curX);
                    allClickableElements.push(curXHover);
                    spr.scrollFactor = new DHPoint(0,0);
                    curX.scrollFactor = new DHPoint(0,0);
                    curXHover.scrollFactor = new DHPoint(0,0);
                    cur["full_sprite"] = spr;
                    cur["x_sprite"] = curX;
                    cur["x_hover_sprite"] = curXHover;
                }
            }
            // add all folder sprites at the same time, before recursion
            for (var k:int = 0; k < recurseSet.length; k++) {
                for (var h:int = 0; h < recurseSet[k][2].length; h++) {
                    FlxG.state.add(recurseSet[k][2][h]);
                }
                this.populateFolders(recurseSet[k][0], recurseSet[k][1]);
            }
        }

        public function addElementsFrom(other:FolderBuilder):void {
            for (var i:int = 0; i < other.allClickableElements.length; i++) {
                this.allClickableElements.push(other.allClickableElements[i]);
            }
        }

        public function getClickedElement(mouse_rect:FlxRect):GameObject {
            var cur:GameObject, curClicked:GameObject, isAbove:Boolean;
            for(var i:int = 0; i < this.allClickableElements.length; i++) {
                cur = this.allClickableElements[i];
                isAbove = (FlxG.state as GameState).getZIndex(cur) >
                          (FlxG.state as GameState).getZIndex(curClicked);
                if (cur.slug == HITBOX_TAG) {
                    isAbove = curClicked == null;
                }
                if(mouse_rect.overlaps(cur._getRect()) && cur.visible &&
                    !((FlxG.state as GameState).isOccluded(cur)))
                {
                    if (isAbove) {
                        curClicked = cur;
                    }
                }
            }
            return curClicked;
        }

        public function resolveClick(root:Object, mouse_rect:FlxRect, clicked:GameObject):void {
            var spr:GameObject, icon_pos:DHPoint, cur:Object, cur_icon:Object,
                propagateClick:Boolean = true;
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];

                if (cur["contents"] is Array) {
                    if (cur["folder_sprite"].visible) {
                        if(mouse_rect.overlaps(cur["x_sprite"]._getRect())) {
                            if(cur["x_sprite"] == clicked || cur["x_hover_sprite"] == clicked) {
                                propagateClick = false;
                                cur["folder_sprite"].visible = false;
                                cur["x_sprite"].visible = false;
                                cur["x_hover_sprite"].visible = false;
                                CommentaryPlayer.getInstance().stop();
                                this.setIconVisibility(cur, false);
                            }
                        }
                    } else if (mouse_rect.overlaps(cur[this.getHitboxKey(cur)]._getRect())) {
                        if(cur[this.getHitboxKey(cur)].visible) {
                            if(this.iconIsNotHidden(cur[this.getHitboxKey(cur)]._getRect(), root, cur)) {
                                if(cur[this.getHitboxKey(cur)] == clicked) {
                                    cur["folder_sprite"].visible = true;
                                    cur["x_sprite"].visible = true;
                                    cur["x_hover_sprite"].visible = true;
                                    this.setIconVisibility(cur, true);
                                    if (cur.hasOwnProperty("commentary_file")) {
                                        CommentaryPlayer.getInstance().playFile(cur["commentary_file"]);
                                    }
                                    propagateClick = false;
                                }
                            }
                        }
                    }
                    if (propagateClick) {
                        this.resolveClick(cur, mouse_rect, clicked);
                    }
                } else {
                    if (cur["full_sprite"].visible && mouse_rect.overlaps(cur["x_sprite"]._getRect())) {
                        if (cur["x_sprite"] == clicked || cur["x_hover_sprite"] == clicked) {
                            cur["full_sprite"].visible = false;
                            cur["x_sprite"].visible = false;
                            cur["x_hover_sprite"].visible = false;
                            CommentaryPlayer.getInstance().stop();
                        }
                    } else if (mouse_rect.overlaps(cur["icon_sprite"]._getRect()) && cur["icon_sprite"].visible) {
                        if (cur["icon_sprite"] == clicked) {
                            cur["full_sprite"].visible = true;
                            cur["x_sprite"].visible = true;
                            cur["x_hover_sprite"].visible = true;
                            if (cur.hasOwnProperty("commentary_file")) {
                                CommentaryPlayer.getInstance().playFile(cur["commentary_file"]);
                            }
                        }
                    }
                }
            }
        }

        public function iconIsNotHidden(hitbox:FlxRect, root:Object, obj:Object):Boolean {
            var cur:Object;
            var i:Number = 0;
            var overlap:Boolean = true;
            for (i = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];

                if (cur["contents"] is Array) {
                    if("folder_sprite" in cur) {
                        if(cur["folder_sprite"].visible && cur["folder_sprite"]._getRect().overlaps(hitbox)) {
                            overlap = false;
                        }
                    }
                    if("full_sprite" in cur) {
                        if(cur["full_sprite"].visible && cur["full_sprite"]._getRect().overlaps(hitbox)) {
                            overlap = false;
                        }
                    }
                } else {
                    if("full_sprite" in cur) {
                        if(cur["full_sprite"].visible && cur["full_sprite"]._getRect().overlaps(hitbox)) {
                            overlap = false;
                        }
                    }
                }
            }
            if(PopUpManager.getInstance().open_popups != null) {
                for(i = 0; i < PopUpManager.getInstance().open_popups.length; i++) {
                    if(PopUpManager.getInstance().open_popups[i] != null) {
                        if(PopUpManager.getInstance().open_popups[i].visible && PopUpManager.getInstance().open_popups[i]._getRect().overlaps(hitbox)) {
                                if(obj["struc"] != PopUpManager.getInstance().open_popups[i].tag) {
                                    overlap = false;
                                }
                        }
                        if(PopUpManager.getInstance().open_popups[i].visible && PopUpManager.getInstance().open_popups[i].x_sprite._getRect().overlaps(hitbox)) {
                                if(obj["struc"] != PopUpManager.getInstance().open_popups[i].tag) {
                                    overlap = false;
                                }
                        }
                    }
                }
            }
            FlxG.log(overlap);
            return overlap;
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
                FlxG.state.add(cur["x_hover"]);
                if(elements != null) {
                    elements.push(cur["sprite"]);
                    elements.push(cur["x"]);
                    elements.push(cur["x_hover"]);
                }
            }
        }

        public function overlapSprites(root:Object):void {
            var cur:Object;
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];
                if (cur["contents"] is Array) {
                    if (cur["folder_sprite"].visible) {
                        if ("x_sprite" in cur) {
                            if((FlxG.state as GameState).cursorOverlaps(cur["x_sprite"]._getRect(), true)) {
                                cur["x_sprite"].visible = false;
                                cur["x_hover_sprite"].visible = true;
                            } else {
                                cur["x_sprite"].visible = true;
                                cur["x_hover_sprite"].visible = false;
                            }
                        }
                        this.overlapSprites(cur);
                    }
                    if("email_link_sprite" in cur) {
                        if((FlxG.state as GameState).cursorOverlaps(cur["email_link_sprite"]._getRect(), true)) {
                            if(cur["icon_sprite"].visible) {
                                cur["email_link_sprite"].visible = true;
                            }
                        } else {
                            cur["email_link_sprite"].visible = false;
                        }
                    }
                } else {
                    if(cur["full_sprite"].visible) {
                        if ("x_sprite" in cur) {
                            if ((FlxG.state as GameState).cursorOverlaps(cur["x_sprite"]._getRect(), true)) {
                                cur["x_sprite"].visible = false;
                                cur["x_hover_sprite"].visible = true;
                            } else {
                                cur["x_sprite"].visible = true;
                                cur["x_hover_sprite"].visible = false;
                            }
                        }
                    }
                    if("email_link_sprite" in cur) {
                        if((FlxG.state as GameState).cursorOverlaps(cur["email_link_sprite"]._getRect(), true)) {
                            if(cur["icon_sprite"].visible) {
                                cur["email_link_sprite"].visible = true;
                            }
                        } else {
                            cur["email_link_sprite"].visible = false;
                        }
                    }
                }
            }
        }
    }
}
