package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.entities.LoadingScreen;
    import com.starmaid.Cibele.management.DebugConsoleManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.states.PlayVideoState;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.FPSCounter;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;
    import flash.events.Event;

    public class GameState extends FlxState {
        [Embed(source="/../assets/audio/effects/sfx_mouseclick.mp3")] private var SfxClick:Class;
        [Embed(source="/../assets/audio/effects/sfx_mouseclick2.mp3")] private var SfxClick2:Class;
        [Embed(source="/../assets/images/ui/incomingcall.png")] private var ImgCall:Class;

        protected var updateSound:Boolean, updatePopup:Boolean,
                      updateMessages:Boolean, showEmoji:Boolean = true;
        protected var game_cursor:GameCursor, baseLayer:GameObject;
        private var pauseLayer:GameObject;
        private var sortedObjects:Array;
        public var loadingScreen:LoadingScreen;
        public var use_loading_screen:Boolean = true;
        public var call_button:GameObject;
        public var fpsCounter:FPSCounter;

        public var ui_color_flag:Number;
        public static const UICOLOR_DEFAULT:Number = 0;
        public static const UICOLOR_PINK:Number = 1;

        public var cursorResetFlag:Boolean = false;

        public static const EVENT_POPUP_CLOSED:String = "popup_closed";
        public static const EVENT_CHAT_RECEIVED:String = "chat_received";
        public static const EVENT_SINGLETILE_BG_LOADED:String = "bg_loaded";

        public static const LVL_IT:String = "it";
        public static const LVL_EU:String = "eu";
        public static const LVL_HI:String = "hi";
        public static var cur_level:String = GameState.LVL_IT;

        public function GameState(snd:Boolean=true, popup:Boolean=true,
                                  messages:Boolean=true){
            this.updateSound = snd;
            this.updatePopup = popup;
            this.updateMessages = messages;

            this.ui_color_flag = UICOLOR_DEFAULT;

            this.sortedObjects = new Array();
        }

        override public function create():void {
            super.create();

            FlxG.bgColor = 0xff000000;

            var baseLayerColor:uint = 0xff000000;
            if (ScreenManager.getInstance().DEBUG) {
                baseLayerColor = 0xffffffff;
            }

            this.baseLayer = new GameObject(new DHPoint(0, 0));
            this.baseLayer.scrollFactor = new DHPoint(0, 0);
            this.baseLayer.active = false;
            this.baseLayer.makeGraphic(
                ScreenManager.getInstance().screenWidth,
                ScreenManager.getInstance().screenHeight,
                baseLayerColor
            );
            this.add(this.baseLayer);

            this.pauseLayer = new GameObject(new DHPoint(0, 0));
            this.pauseLayer.scrollFactor = new DHPoint(0, 0);
            this.pauseLayer.active = false;
            this.pauseLayer.makeGraphic(
                ScreenManager.getInstance().screenWidth,
                ScreenManager.getInstance().screenHeight,
                0xaa000000
            );
            this.pauseLayer.visible = GlobalTimer.getInstance().isPaused();

            CONFIG::debug {
                this.fpsCounter = new FPSCounter();
            }
        }

        public function postCreate():void {
            if (this.updatePopup && this.showEmoji) {
                PopUpManager.getInstance().loadEmoji();
            }
            if (this.updateMessages) {
                MessageManager.getInstance().reloadPersistentObjects();
            }
            if (this.updatePopup) {
                PopUpManager.getInstance().loadPopUps();
            }

            var _screen:ScreenManager = ScreenManager.getInstance();
            call_button = new GameObject(new DHPoint(_screen.screenWidth * .35, _screen.screenHeight * .3));
            call_button.loadGraphic(ImgCall,false,false,406,260);
            call_button.scrollFactor = new DHPoint(0, 0);
            FlxG.state.add(call_button);
            call_button.visible = false;

            if(this.use_loading_screen) {
                this.loadingScreen = new LoadingScreen();
            }

            if (ScreenManager.getInstance().DEBUG) {
                DebugConsoleManager.getInstance().addVisibleObjects();
            }

            this.game_cursor = new GameCursor();
        }

        public function updateCursor():void {
            if (this.game_cursor != null) {
                this.game_cursor.update();
                if(!this.cursorResetFlag) {
                    this.game_cursor.resetCursor();
                    this.cursorResetFlag = true;
                }
            }
        }

        private function sortByBasePos(a:GameObject, b:GameObject):Number {
            var aY:Number = a.basePos != null ? a.basePos.y : a.y;
            var bY:Number = b.basePos != null ? b.basePos.y : b.y;

            if (aY > bY) {
                return 1;
            }
            if (aY < bY) {
                return -1;
            }
            return 0;
        }

        /*
         * Loop over sorted objects and insert them at appropriate positions in
         * members array. This maintains z-indexing based on y position
         */
        private function insertSortedObjects():void {
            var sortedObjectsCounter:int = 0;
            var cur:GameObject;
            for (var i:int = 0; i < this.members.length; i++) {
                if (this.members[i] != null && this.members[i] is GameObject){
                    cur = this.members[i] as GameObject;
                    if (cur.zSorted) {
                        this.members[i] = this.sortedObjects[sortedObjectsCounter++];
                    }
                }
            }
        }

        override public function update():void {
            // DO NOT call super here, since that breaks pausing
            // the following loop is copypasta from FlxGroup update, altered to
            // support pausing
            if(this.use_loading_screen) {
                if(this.loadingScreen != null) {
                    this.loadingScreen.update();
                }
            }

            this.sortedObjects.length = 0;
            var basic:GameObject, i:uint = 0;
            while(i < length) {
                // maintain a list of GameObjects to be z-sorted by their foot position
                if (members[i] is GameObject && (members[i] as GameObject).zSorted) {
                    this.sortedObjects.push(members[i]);
                }
                basic = members[i++] as GameObject;
                if(basic != null && basic.scale != null && basic.exists && basic.active) {
                    if ((GlobalTimer.getInstance().isPaused() &&
                         !basic.observeGlobalPause) ||
                        !GlobalTimer.getInstance().isPaused())
                    {
                        basic.preUpdate();
                        basic.update();
                        basic.postUpdate();
                    }
                }
            }

            this.sortedObjects.sort(sortByBasePos);
            this.insertSortedObjects();

            GlobalTimer.getInstance().update();

            if (this.updateSound) {
                SoundManager.getInstance().update();
            }
            if (this.updatePopup) {
                PopUpManager.getInstance().update();
            }
            if (this.updateMessages) {
                MessageManager.getInstance().update();
            }
            if (ScreenManager.getInstance().DEBUG) {
                DebugConsoleManager.getInstance().update();
                DebugConsoleManager.getInstance().trackAttribute("FlxG.state.fpsCounter._fps", "FPS");
            }

            if (!this.containsPauseLayer()) {
                FlxG.state.add(this.pauseLayer);
            }

            this.updateCursor();

            if(FlxG.mouse.justReleased() && !(FlxG.state is PlayVideoState)) {
                this.playClick();
                this.clickCallback(
                    new DHPoint(FlxG.mouse.screenX, FlxG.mouse.screenY),
                    new DHPoint(FlxG.mouse.x, FlxG.mouse.y)
                );
            }

            if (FlxG.keys.justPressed("P")) {
                SoundManager.getInstance().increaseVolume();
            } else if (FlxG.keys.justPressed("O")) {
                SoundManager.getInstance().decreaseVolume();
            } else if (FlxG.keys.justPressed("ESCAPE")) {
                this.pause();
            }
        }

        public function containsPauseLayer():Boolean {
            for (var i:int = 0; i < this.members.length; i++) {
                if (this.members[i] == this.pauseLayer) {
                    return true;
                }
            }
            return false;
        }

        public function playClick():void {
            var rand:Number = Math.random() * 2;
            if(rand > 1) {
                SoundManager.getInstance().playSound(
                    SfxClick, 1*GameSound.MSEC_PER_SEC, null, false, .1, GameSound.SFX,
                    "" + Math.random()
                );
            } else {
                SoundManager.getInstance().playSound(
                    SfxClick2, 200, null, false, .1, GameSound.SFX,
                    "" + Math.random()
                );
            }
        }

        public function cursorOverlaps(cur_rect:FlxRect, screen_space:Boolean):Boolean {
            var overlap:Boolean;
            if(screen_space) {
                overlap = this.game_cursor.mouse_screen_rect.overlaps(cur_rect);
            } else if(!screen_space) {
                overlap = this.game_cursor.mouse_rect.overlaps(cur_rect);
            }
            return overlap;
        }

        public function pause():void {
            GlobalTimer.getInstance().pause();
            SoundManager.getInstance().pause();
            this.pauseLayer.visible = GlobalTimer.getInstance().isPaused();
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            if (this.updatePopup) {
                PopUpManager.getInstance().clickCallback(screenPos, worldPos);
            }
        }

        public function addEventListener(event:String, callback:Function):void {
            FlxG.stage.addEventListener(event, callback);
        }

        public function dispatchEvent(event:String):void {
            FlxG.stage.dispatchEvent(new Event(event, true, true));
        }
    }
}