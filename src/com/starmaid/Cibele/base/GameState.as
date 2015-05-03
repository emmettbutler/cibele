package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.entities.LoadingScreen;
    import com.starmaid.Cibele.entities.PauseScreen;
    import com.starmaid.Cibele.entities.MenuButton;
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
    import flash.events.MouseEvent;

    public class GameState extends FlxState {
        [Embed(source="/../assets/audio/effects/sfx_mouseclick.mp3")] private var SfxClick:Class;
        [Embed(source="/../assets/audio/effects/sfx_mouseclick2.mp3")] private var SfxClick2:Class;

        protected var updateSound:Boolean, updatePopup:Boolean,
                      updateMessages:Boolean, showEmoji:Boolean = true,
                      enable_fade:Boolean = false;
        protected var game_cursor:GameCursor, baseLayer:GameObject;
        protected var pausable:Boolean = true;
        private var fadeLayer:GameObject;
        private var pauseScreen:PauseScreen;
        private var sortedObjects:Array;
        private var postFadeFn:Function;
        private var postFadeWait:Number;
        protected var menuButtons:Array;
        public var loadingScreen:LoadingScreen;
        public var use_loading_screen:Boolean = true;
        public var loading_screen_timer:Number = 3;
        public var fpsCounter:FPSCounter;

        public var ui_color_flag:Number;
        public var fading:Boolean;
        public static const UICOLOR_DEFAULT:Number = 0;
        public static const UICOLOR_PINK:Number = 1;

        public var cursorResetFlag:Boolean = false;

        public static const EVENT_POPUP_CLOSED:String = "popup_closed";
        public static const EVENT_CHAT_RECEIVED:String = "chat_received";
        public static const EVENT_SINGLETILE_BG_LOADED:String = "bg_loaded";

        public function GameState(snd:Boolean=true, popup:Boolean=true,
                                  messages:Boolean=true, fade:Boolean=false){
            this.updateSound = snd;
            this.updatePopup = popup;
            this.updateMessages = messages;
            this.enable_fade = fade;

            this.menuButtons = new Array();

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

            this.pauseScreen = new PauseScreen();

            CONFIG::debug {
                this.fpsCounter = new FPSCounter();
            }

            if (this.enable_fade) {
                this.fadeLayer = new GameObject(new DHPoint(0, 0));
                this.fadeLayer.scrollFactor = new DHPoint(0, 0);
                this.fadeLayer.active = false;
                this.fadeLayer.makeGraphic(
                    ScreenManager.getInstance().screenWidth,
                    ScreenManager.getInstance().screenHeight,
                    0xff000000
                );
                this.fadeLayer.alpha = 0;
            }

            this.game_cursor = new GameCursor();

            FlxG.stage.addEventListener(MouseEvent.CLICK, clickHandler);
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

            if(this.use_loading_screen) {
                this.loadingScreen = new LoadingScreen(loading_screen_timer);
                this.loadingScreen.endCallback = this.loadingScreenEndCallback;
            }

            if (this.enable_fade) {
                this.add(this.fadeLayer);
            }

            if (ScreenManager.getInstance().DEBUG) {
                DebugConsoleManager.getInstance().initTextObjects();
                DebugConsoleManager.getInstance().addVisibleObjects();
            }

            this.game_cursor.addCursorSprites();
        }

        public function loadingScreenEndCallback():void { }

        public function fadeOut(fn:Function, postFadeWait:Number=1):void {
            this.fading = true;
            this.postFadeWait = postFadeWait;
            this.postFadeFn = fn;
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

        public function clickHandler(event:MouseEvent):void {
            if(!this.fading && !(FlxG.state is PlayVideoState)) {
                if (!GlobalTimer.getInstance().isPaused()) {
                    this.playClick();
                }
                this.clickCallback(
                    new DHPoint(FlxG.mouse.screenX, FlxG.mouse.screenY),
                    new DHPoint(FlxG.mouse.x, FlxG.mouse.y)
                );
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
                if (basic != null) {
                    basic.toggleActive();
                    if(basic.active && basic.exists && basic.scale != null) {
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
                DebugConsoleManager.getInstance().trackAttribute("FlxG.state.length", "sprites onscreen");
                DebugConsoleManager.getInstance().trackAttribute("FlxG.mouse.x", "mouse x");
                DebugConsoleManager.getInstance().trackAttribute("FlxG.mouse.y", "mouse y");
            }

            if (!this.containsPauseLayer()) {
                this.pauseScreen.addToState();
            }

            this.updateCursor();

            if (this.fading) {
                if (this.fadeLayer.alpha < 1) {
                    this.fadeLayer.alpha += .01;
                } else {
                    this.fading = false;
                    GlobalTimer.getInstance().setMark("endfade",
                                                      this.postFadeWait,
                                                      this.postFadeFn);
                }
            }

            if (FlxG.keys.justPressed("P")) {
                SoundManager.getInstance().increaseVolume();
            } else if (FlxG.keys.justPressed("O")) {
                SoundManager.getInstance().decreaseVolume();
            } else if (FlxG.keys.justPressed("ESCAPE")) {
                if (GlobalTimer.getInstance().isPaused()) {
                    this.resume();
                } else if (this.pausable){
                    this.pause();
                }
            }
        }

        override public function draw():void {
            var basic:FlxBasic;
            var i:uint = 0;
            while(i < length) {
                basic = members[i++] as FlxBasic;
                if((basic != null) && basic.exists && basic.visible) {
                    basic.draw();
                }
            }
        }

        public function getZIndex(elem:GameObject):int {
            if (elem == null) {
                return -1;
            }
            var idx:int = this.members.indexOf(elem);
            return idx;
        }

        public function containsPauseLayer():Boolean {
            for (var i:int = 0; i < this.members.length; i++) {
                if (this.members[i] == this.pauseScreen.quit_button) {
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
            this.pauseScreen.visible = GlobalTimer.getInstance().isPaused();
        }

        public function resume():void {
            GlobalTimer.getInstance().resume();
            SoundManager.getInstance().resume();
            this.pauseScreen.visible = GlobalTimer.getInstance().isPaused();
        }

        public function addMenuButton(button:MenuButton):void {
            this.menuButtons.push(button);
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {
            if (!GlobalTimer.getInstance().isPaused() && this.updatePopup) {
                PopUpManager.getInstance().clickCallback(screenPos, worldPos);
            }

            var _mouseRect:FlxRect = new FlxRect(screenPos.x, screenPos.y, 1, 1);
            var _curRect:FlxRect;
            var buttonScreenPos:DHPoint = new DHPoint(0, 0);
            for (var i:int = 0; i < this.menuButtons.length; i++) {
                if ((GlobalTimer.getInstance().isPaused() && !this.menuButtons[i].observeGlobalPause) ||
                    !GlobalTimer.getInstance().isPaused())
                {
                    this.menuButtons[i].getScreenXY(buttonScreenPos);
                    _curRect = new FlxRect(buttonScreenPos.x,
                                           buttonScreenPos.y,
                                           this.menuButtons[i].width,
                                           this.menuButtons[i].height);
                    if (_mouseRect.overlaps(_curRect) && this.menuButtons[i].visible) {
                        this.menuButtons[i].clickCallback();
                    }
                }
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
