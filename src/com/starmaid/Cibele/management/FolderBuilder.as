package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.UIElement;
    import com.starmaid.Cibele.entities.XSprite;

    import org.flixel.*;

    import flash.events.Event;
    import flash.utils.Dictionary;

    public class FolderBuilder {
        [Embed(source="/../assets/images/ui/UI_pink_x.png")] private var ImgInboxXPink:Class;
        [Embed(source="/../assets/images/ui/UI_pink_x_hover.png")] private var ImgInboxXPinkHover:Class;

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
                    cur["x_sprite"].setPos(new DHPoint(cur["folder_sprite"].x + cur["folder_sprite"].width - 23 - 2, cur["folder_sprite"].y + 2));
                    cur["x_hover_sprite"].setPos(new DHPoint(cur["folder_sprite"].x + cur["folder_sprite"].width - 23 - 2, cur["folder_sprite"].y + 2));

                    this.updateFolderPositions(cur);
                } else {
                    cur["full_sprite"].updatePos();
                    cur["x_sprite"].setPos(new DHPoint(cur['full_sprite'].x + cur["full_sprite"].width - 23 - 2, cur["full_sprite"].y + 2));
                    cur["x_hover_sprite"].setPos(new DHPoint(cur['full_sprite'].x + cur["full_sprite"].width - 23 - 2, cur["full_sprite"].y + 2));
                }
            }
        }

        public function populateFolders(root:Object, elements:Array=null, root_folder:UIElement=null):void {
            var _screen:ScreenManager = ScreenManager.getInstance();
            var cur:Object, curX:UIElement, curXHover:UIElement, spr:GameObject, icon_pos:DHPoint;
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
                    allClickableElements.push(spr);
                    if(elements != null) {
                        elements.push(spr);
                    }
                    cur["icon_sprite"] = spr;
                }
                if("hitbox_pos" in cur && "hitbox_dim" in cur) {
                    spr = UIElement.fromPoint(new DHPoint(cur["hitbox_pos"].x, cur["hitbox_pos"].y));
                    spr.makeGraphic(cur["hitbox_dim"].x, cur["hitbox_dim"].y, 0x00ff0000);
                    spr.scrollFactor = new DHPoint(0,0);
                    spr.slug = HITBOX_TAG;
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
                            (_screen.screenHeight - cur["folder_dim"].y) * Math.random()
                        )
                    );
                    spr.loadGraphic(cur["folder_img"], false, false, cur["folder_dim"].x, cur["folder_dim"].y);
                    spr.visible = false;
                    spr.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(spr);
                    cur["folder_sprite"] = spr;
                    curX = XSprite.fromPoint(new DHPoint(spr.x + spr.width - 23 - 2, spr.y + 2));
                    curX.loadGraphic(ImgInboxXPink, false, false, 23, 18);
                    curX.visible = false;
                    curX.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(curX);

                    curXHover = XSprite.fromPoint(new DHPoint(spr.x + spr.width - 23 - 2, spr.y + 2));
                    curXHover.loadGraphic(ImgInboxXPinkHover, false, false, 23, 18);
                    curXHover.visible = false;
                    curXHover.scrollFactor = new DHPoint(0,0);
                    FlxG.state.add(curXHover);

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

                    this.populateFolders(cur, elements);
                } else {
                    spr = UIElement.fromPoint(new DHPoint((_screen.screenWidth - cur["dim"].x) * Math.random(), (_screen.screenHeight - cur["dim"].y) * Math.random()));
                    spr.loadGraphic(cur["contents"], false, false, cur["dim"].x, cur["dim"].y);
                    spr.visible = false;
                    curX = XSprite.fromPoint(new DHPoint(spr.x + spr.width - 23 - 2, spr.y + 2));
                    curX.loadGraphic(ImgInboxXPink, false, false, 23, 18);
                    curX.visible = false;
                    curXHover = XSprite.fromPoint(new DHPoint(spr.x + spr.width - 23 - 2, spr.y + 2));
                    curXHover.loadGraphic(ImgInboxXPinkHover, false, false, 23, 18);
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
                if(mouse_rect.overlaps(cur._getRect()) && cur.visible) {
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
                        }
                    } else if (mouse_rect.overlaps(cur["icon_sprite"]._getRect()) && cur["icon_sprite"].visible) {
                        if (cur["icon_sprite"] == clicked) {
                            cur["full_sprite"].visible = true;
                            cur["x_sprite"].visible = true;
                            cur["x_hover_sprite"].visible = true;
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

        public function overlapXSprite(root:Object):void {
            var cur:Object;
            for (var i:int = 0; i < root["contents"].length; i++) {
                cur = root["contents"][i];
                if (cur["contents"] is Array) {
                    if (cur["folder_sprite"].visible) {
                        if((FlxG.state as GameState).cursorOverlaps(cur["x_sprite"]._getRect(), true)) {
                            cur["x_sprite"].visible = false;
                            cur["x_hover_sprite"].visible = true;
                        } else {
                            cur["x_sprite"].visible = true;
                            cur["x_hover_sprite"].visible = false;
                        }
                    }
                    this.overlapXSprite(cur);
                } else {
                    if(cur["full_sprite"].visible) {
                        if ((FlxG.state as GameState).cursorOverlaps(cur["x_sprite"]._getRect(), true)) {
                            cur["x_sprite"].visible = false;
                            cur["x_hover_sprite"].visible = true;
                        } else {
                            cur["x_sprite"].visible = true;
                            cur["x_hover_sprite"].visible = false;
                        }
                    }
                }
            }
        }
    }
}
