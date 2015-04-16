package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameObject;

    import org.flixel.*;

    import flash.display.StageDisplayState;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.geom.Rectangle;
    import flash.events.*;
    import flash.ui.Keyboard;

    public class ScreenManager {
        public static const DEFAULT_ASPECT:Number = 640/360;
        public var cam:FlxCamera;
        public var screenWidth:Number, screenHeight:Number, aspect_ratio:Number;
        public var applet_dimensions:FlxPoint, letterbox_dimensions:FlxPoint, zero_point:FlxPoint;

        // global debug flag
        public var DEBUG:Boolean = false;
        public var MUTE:Boolean = false;
        public var SAVES:Boolean = true;
        public var RELEASE:Boolean = true;

        public var levelTracker:LevelTracker;

        public var letterbox1:FlxSprite = null, letterbox2:FlxSprite = null, letterbox3:FlxSprite = null, letterbox4:FlxSprite = null;

        public static var _instance:ScreenManager = null;

        public function ScreenManager() {
            CONFIG::debug {
                this.DEBUG = true;
                this.RELEASE = false;
            }
            CONFIG::mute {
                this.MUTE = true;
            }
            CONFIG::disable_saves {
                this.SAVES = false;
            }
            CONFIG::test {
                this.RELEASE = false;
            }

            FlxG.stage.frameRate = 60;
            //this needs to be set in order to scale using gpu instead of in the software

            //needs to be set before put in full screen
            screenWidth = FlxG.stage.fullScreenWidth;
            screenHeight = FlxG.stage.fullScreenHeight;
            FlxG.stage.fullScreenSourceRect = new Rectangle(0,0,screenWidth,screenHeight); //fix these dimensions
            FlxG.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

            FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,
                function(e:KeyboardEvent):void {
                    if (e.keyCode == Keyboard.ESCAPE) {
                        e.preventDefault();
                    }
                });

            FlxG.stage.addEventListener(Event.DEACTIVATE, this.onFocusLost);
            FlxG.stage.addEventListener(Event.ACTIVATE, this.onFocus);

            applet_dimensions = new FlxPoint(640/2, 480/2);
            trace("SCREEN DIMENSIONS: " + screenWidth + "x" + screenHeight);
            FlxG.width = screenWidth;
            FlxG.height = screenHeight;
            aspect_ratio = applet_dimensions.x/applet_dimensions.y;
            letterbox_dimensions = new FlxPoint((screenWidth - screenWidth/aspect_ratio) / 2,
                (screenHeight - screenHeight/aspect_ratio) / 2);
            zero_point = new FlxPoint((letterbox_dimensions.x),
                                      (letterbox_dimensions.y));

            this.levelTracker = new LevelTracker();
        }

        public function calcFullscreenDimensions(aspect:Number=DEFAULT_ASPECT):DHPoint {
            return new DHPoint(screenHeight * aspect, screenWidth / aspect);
        }

        public function calcFullscreenDimensionsAlt(dim:DHPoint):DHPoint {
            var aspect:Number = dim.x / dim.y;
            if (dim.x > dim.y) {
                return new DHPoint(screenWidth, screenWidth / aspect);
            } else {
                return new DHPoint(screenHeight * aspect, screenHeight);
            }
        }

        public function calcFullscreenScale(dim:DHPoint):Number {
            var factor:Number;
            if (dim.x > dim.y) {
                factor = screenWidth / dim.x;
            } else {
                factor = screenHeight / dim.y;
            }
            return factor;
        }

        public function calcFullscreenOrigin(dim:DHPoint):DHPoint {
            return new DHPoint((screenWidth - dim.x) / 2, (screenHeight - dim.y) / 2);
        }

        public function setupCamera(playerCamera:GameObject, zoomFactor:Number=1.2):void {
            cam = new FlxCamera(0, 0, screenWidth, screenHeight);
            FlxG.resetCameras(cam);
            if (playerCamera != null) {
                cam.target = playerCamera;
            }
        }

        public function addLetterbox():void {
            var _color:uint = 0xff000000;

            letterbox1 = new FlxSprite(0, 0);
            letterbox1.makeGraphic(screenWidth+500, zero_point.y, _color);
            FlxG.state.add(letterbox1);

            letterbox2 = new FlxSprite(0, zero_point.y + applet_dimensions.y);
            letterbox2.makeGraphic(screenWidth, screenHeight - (zero_point.y + applet_dimensions.y), _color);
            FlxG.state.add(letterbox2);

            letterbox3 = new FlxSprite(0, 0);
            letterbox3.makeGraphic(zero_point.x, screenHeight, _color);
            FlxG.state.add(letterbox3);

            letterbox4 = new FlxSprite(zero_point.x + applet_dimensions.x, 0);
            letterbox4.makeGraphic(screenWidth - (zero_point.x + applet_dimensions.x), screenHeight, _color);
            FlxG.state.add(letterbox4);
        }

        public function onFocus(e:Event):void {
            (FlxG.state as GameState).pause();
        }

        public function onFocusLost(e:Event):void {
            (FlxG.state as GameState).pause();
        }

        public static function getInstance():ScreenManager {
            if (_instance == null) {
                _instance = new ScreenManager();
            }
            return _instance;
        }
    }
}
