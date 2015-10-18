package com.starmaid.Cibele.management {
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.GlobalTimer;
    import com.starmaid.Cibele.base.GameState;
    import com.starmaid.Cibele.base.GameCursor;
    import com.starmaid.Cibele.base.GameObject;
    import com.starmaid.Cibele.states.StartScreen;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.PopUpManager;

    import org.flixel.*;

    import flash.display.StageDisplayState;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.geom.Rectangle;
    import flash.events.*;
    import flash.ui.Keyboard;
    import flash.utils.Timer;

    public class ScreenManager {
        public static const DEFAULT_ASPECT:Number = 640/360;
        public var cam:FlxCamera;
        public var screenWidth:Number, screenHeight:Number;

        // global debug flag
        public var DEBUG:Boolean = false;
        public var MUTE:Boolean = false;
        public var SAVES:Boolean = true;
        public var SHORT_DIALOGUE:Boolean = false;
        public var QUICK_LEVELS:Boolean = false;
        public var WINDOWED:Boolean = false;
        public var RELEASE:Boolean = true;

        private var resizeTimer:Timer;
        private var resizeInterval:Number = 50;

        public var levelTracker:LevelTracker;
        private var fullscreen:Boolean = true;

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
            CONFIG::windowed {
                this.WINDOWED = true;
            }
            CONFIG::test {
                this.RELEASE = false;
            }
            CONFIG::short_dialogue {
                this.SHORT_DIALOGUE = true;
            }
            CONFIG::quick_levels {
                this.QUICK_LEVELS = true;
            }

            FlxG.stage.frameRate = 60;

            if (this.WINDOWED) {
                this.setupWindowedMode();
            } else {
                this.setupFullscreenMode();
            }

            resizeTimer = new Timer(resizeInterval);
            resizeTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            FlxG.stage.addEventListener(Event.RESIZE, resizeHandler);

            var that:ScreenManager = this;
            FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,
                function(e:KeyboardEvent):void {
                    if (e.keyCode == Keyboard.ESCAPE) {
                        e.preventDefault();
                    } else if (!that.RELEASE && e.keyCode == Keyboard.F) {
                        that.toggleFullscreen();
                    }
                });

            FlxG.stage.addEventListener(Event.DEACTIVATE, this.onFocusLost);
            FlxG.stage.addEventListener(Event.ACTIVATE, this.onFocus);

            trace("SCREEN DIMENSIONS: " + screenWidth + "x" + screenHeight);
            this.levelTracker = new LevelTracker();
        }

        private function toggleFullscreen():void {
            if (this.fullscreen) {
                this.fullscreen = false;
                this.setupWindowedMode();
            } else {
                this.fullscreen = true;
                this.setupFullscreenMode();
            }
        }

        private function setupFullscreenMode():void {
            screenWidth = FlxG.stage.fullScreenWidth;
            screenHeight = FlxG.stage.fullScreenHeight;
            FlxG.width = screenWidth;
            FlxG.height = screenHeight;
            FlxG.stage.fullScreenSourceRect = new Rectangle(0, 0, screenWidth,
                                                            screenHeight);
            FlxG.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            this.setupCamera(cam != null ? cam.target as GameObject : null);
            FlxG.stage.nativeWindow.orderToBack();
        }

        private function setupWindowedMode():void {
            FlxG.stage.displayState = StageDisplayState.NORMAL;
            FlxG.stage.nativeWindow.width = FlxG.stage.fullScreenWidth;
            FlxG.stage.nativeWindow.height = FlxG.stage.fullScreenHeight - 100;
            FlxG.stage.nativeWindow.x = 0;
            FlxG.stage.nativeWindow.y = 0;
            screenWidth = FlxG.stage.nativeWindow.width;
            screenHeight = FlxG.stage.nativeWindow.height;
            FlxG.width = screenWidth;
            FlxG.height = screenHeight;
            this.setupCamera(cam != null ? cam.target as GameObject : null);
        }

        private function resizeHandler(e:Event):void {
            if (this.resizeTimer.running) {
                this.resizeTimer.reset();
            }
            this.resizeTimer.start();
        }

        private function timerHandler(e:Event):void {
            this.resizeTimer.stop();
            this.resizeCompletehandler();
        }

        private function resizeCompletehandler():void {
            screenWidth = FlxG.stage.nativeWindow.width;
            screenHeight = FlxG.stage.nativeWindow.height;
            FlxG.width = screenWidth;
            FlxG.height = screenHeight;
            this.setupCamera(cam.target as GameObject);
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

        public function calcFullscreenScale(dim:DHPoint=null):Number {
            if (dim == null) {
                // if no value is given, default to the size of a 15" macbook pro
                dim = new DHPoint(1440, 878);
            }
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

        public function onFocus(e:Event):void {
            GameCursor.hideSystemMouse();
            (FlxG.state as GameState).resume();
        }

        public function onFocusLost(e:Event):void {
            (FlxG.state as GameState).pause();
        }

        public function resetSingletons():void {
            SoundManager.getInstance().resetAll();
            GlobalTimer.resetInstance();
            MessageManager.resetInstance();
            PopUpManager.resetInstance();
        }

        public function resetGame():void {
            PopUpManager.GAME_ACTIVE = false;
            this.resetSingletons();
            (FlxG.state as GameState).resume();
            FlxG.switchState(new StartScreen());
        }

        public static function getInstance():ScreenManager {
            if (_instance == null) {
                _instance = new ScreenManager();
            }
            return _instance;
        }
    }
}
