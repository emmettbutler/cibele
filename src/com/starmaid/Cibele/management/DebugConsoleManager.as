package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.base.GameState;

    import org.flixel.*;

    public class DebugConsoleManager {
        private static const MAX_ATTRS:Number = 50;
        private static var _instance:DebugConsoleManager = null;
        private var trackedAttributes:Object;

        public var consoleBackground:GameObject;
        public var textObjects:Array;

        public function DebugConsoleManager() {
            this.trackedAttributes = {};
            if (ScreenManager.getInstance().DEBUG) {
                this.initTextObjects();
            }
        }

        public function initTextObjects():void {
            var bgWidth:Number = ScreenManager.getInstance().screenWidth/3;
            this.consoleBackground = new GameObject(
                new DHPoint(ScreenManager.getInstance().screenWidth - bgWidth, 0)
            );
            this.consoleBackground.scrollFactor = new DHPoint(0, 0);
            this.consoleBackground.active = false;
            this.consoleBackground.makeGraphic(
                bgWidth,
                ScreenManager.getInstance().screenHeight,
                0x77333333
            );

            this.textObjects = new Array();
            var curText:FlxText;
            for (var i:int = 0; i < MAX_ATTRS; i++) {
                curText = new FlxText(
                    this.consoleBackground.pos.x + 10, 20*i,
                    this.consoleBackground.width, ""
                );
                curText.size = 14;
                curText.scrollFactor = new DHPoint(0, 0);
                curText.color = 0xffffffff;
                this.textObjects.push(curText);
            }

            for (var k:Object in this.trackedAttributes) {
                var attr:Object = this.trackedAttributes[k];
                attr['text'] = this.getTextObject();
            }
        }

        private function getTextObject():FlxText {
            var cur:FlxText;
            for(var i:int = 0; i < this.textObjects.length; i++) {
                cur = this.textObjects[i];
                if (cur._textField != null && cur.text == "") {
                    cur.text = "-";
                    return cur;
                }
            }
            return null;
        }

        public function addVisibleObjects():void {
            FlxG.state.add(this.consoleBackground, true);
            for (var i:int = 0; i < this.textObjects.length; i++) {
                FlxG.state.add(this.textObjects[i], true);
            }
        }

        public function trackAttribute(attrName:String, displayName:String=""):void {
            CONFIG::debug {
                if (attrName in this.trackedAttributes) {
                    return;
                }
                var attr:Object = {
                    'name': attrName,
                    'display_name': displayName == "" ? attrName : displayName,
                    'text': this.getTextObject(),
                    'val': this.resolveTrackedAttribute(attrName)
                };
                this.trackedAttributes[attrName] = attr;
            }
        }

        public function update():void {
            var attr:Object;
            for(var k:String in this.trackedAttributes) {
                attr = this.trackedAttributes[k];
                attr['val'] = this.resolveTrackedAttribute(attr['name']);
                attr['text'].text = attr['display_name'] + ": " + attr['val'];
            }
        }

        private function resolveTrackedAttribute(attrName:String):String {
            var parts:Array = attrName.split('.');
            var curPart:String, curAttr:Object;

            for (var i:int = 0; i < parts.length; i++) {
                curPart = parts[i];

                if (curAttr != null) {
                    //trace(curAttr + ".hasOwnProperty(" + curPart + "): " + curAttr.hasOwnProperty(curPart));
                }

                if (curPart == "FlxG") {
                    curAttr = FlxG;
                } else if (curPart == "ScreenManager") {
                    curAttr = ScreenManager;
                } else if (curAttr != null && (curPart in curAttr || curAttr.hasOwnProperty(curPart))) {
                    if (curAttr[curPart] is Function) {
                        curAttr = curAttr[curPart]();
                    } else {
                        curAttr = curAttr[curPart];
                    }
                } else {
                    return null;
                }
            }

            var ret:String;
            if (curAttr is DHPoint) {
                ret = curAttr.x.toFixed(2) + "x" + curAttr.y.toFixed(2);
            } else if (curAttr is Number) {
                ret = curAttr.toFixed(2).toString();
            } else if (curAttr is Boolean) {
                ret = curAttr ? "true" : "false";
            } else {
                ret = curAttr as String;
            }
            return ret;
        }

        public static function getInstance():DebugConsoleManager {
            if (_instance == null) {
                _instance = new DebugConsoleManager();
            }
            return _instance;
        }
    }
}
