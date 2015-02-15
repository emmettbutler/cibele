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

            this.trackedAttributes = {};
            this.textObjects = new Array();
            var curText:FlxText;
            for (var i:int = 0; i < MAX_ATTRS; i++) {
                curText = new FlxText(
                    this.consoleBackground.pos.x + 10, 20,
                    this.consoleBackground.width, ""
                );
                curText.size = 14;
                curText.scrollFactor = new DHPoint(0, 0);
                curText.color = 0xffffffff;
                this.textObjects.push(curText);
            }
        }

        private function getTextObject():FlxText {
            for(var i:int = 0; i < this.textObjects.length; i++) {
                if (this.textObjects[i].text == "") {
                    return this.textObjects[i];
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

        public function trackAttribute(attrName:String):void {
            if (attrName in this.trackedAttributes) {
                return;
            }
            trace("starting");
            var attr:Object = {
                'name': attrName,
                'text': this.getTextObject(),
                'val': this.resolveTrackedAttribute(attrName)
            };
            this.trackedAttributes[attrName] = attr;
        }

        public function update():void {
            var attr:Object;
            for(var k:String in this.trackedAttributes) {
                attr = this.trackedAttributes[k];
                attr['text'].text = "";

                attr['val'] = this.resolveTrackedAttribute(attr['name']);
                attr['text'].text = attr['name'] + ": " + attr['val'];
            }
        }

        private function resolveTrackedAttribute(attrName:String):String {
            var parts:Array = attrName.split('.');
            var curPart:String, curAttr:Object;
            for (var i:int = 0; i < parts.length; i++) {
                curPart = parts[i];

                if (curPart == 'state') {
                    curAttr = FlxG.state as GameState;
                } else {
                    if (curAttr.hasOwnProperty(curPart)) {
                        if (curAttr[curPart] is Function) {
                            curAttr = curAttr[curPart]();
                        } else {
                            curAttr = curAttr[curPart];
                        }
                    } else {
                        return null;
                    }
                }
            }
            var ret:String;
            if (curAttr is DHPoint) {
                ret = curAttr.x.toFixed(2) + "x" + curAttr.y.toFixed(2);
            } else if (curAttr is Number) {
                ret = curAttr.toFixed(2).toString();
            } else if (curAttr.hasOwnProperty('toString')) {
                ret = curAttr.toString();
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
