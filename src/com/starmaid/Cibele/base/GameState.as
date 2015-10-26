package com.starmaid.Cibele.base {
    import com.starmaid.Cibele.entities.LoadingScreen;
    import com.starmaid.Cibele.entities.PauseScreen;
    import com.starmaid.Cibele.entities.MenuButton;
    import com.starmaid.Cibele.management.DebugConsoleManager;
    import com.starmaid.Cibele.management.SoundManager;
    import com.starmaid.Cibele.management.DialoguePlayer;
    import com.starmaid.Cibele.management.MessageManager;
    import com.starmaid.Cibele.management.ScreenManager;
    import com.starmaid.Cibele.management.PopUpManager;
    import com.starmaid.Cibele.states.PlayVideoState;
    import com.starmaid.Cibele.utils.DHPoint;
    import com.starmaid.Cibele.utils.FPSCounter;
    import com.starmaid.Cibele.utils.GlobalTimer;

    import org.flixel.*;
    import flash.events.Event;
    import flash.events.UncaughtErrorEvent;
    import flash.events.MouseEvent;

    public class GameState extends FlxState {
        [Embed(source="/../assets/audio/effects/sfx_mouseclick.mp3")] private var SfxClick:Class;
        [Embed(source="/../assets/audio/effects/sfx_mouseclick2.mp3")] private var SfxClick2:Class;

        public var updateSound:Boolean, updatePopup:Boolean,
                      updateMessages:Boolean, showEmoji:Boolean = true,
                      enable_fade:Boolean = false;
        protected var game_cursor:GameCursor, baseLayer:GameObject;
        protected var pausable:Boolean = true;
        protected var fadeLayer:GameObject;
        private var pauseScreen:PauseScreen;
        private var callbackRefs:Array;
        private var sortedObjects:Array;
        private var postFadeFn:Function;
        private var postFadeWait:Number;
        protected var menuButtons:Array;
        public var loadingScreen:LoadingScreen;
        public var use_loading_screen:Boolean = true;
        public var enable_cursor:Boolean = true,
                   hide_cursor_on_unpause:Boolean = false;
        public var loading_screen_timer:Number = 3;
        public var play_loading_dialogue:Boolean = true;
        public var fpsCounter:FPSCounter;
        private var slug:String;
        private var fadeSoundName:String;
        public var load_screen_text:String;
        public var notificationTextColor:uint;
        private var framesAlive:Number = 0;
        public var soundFadeRate:Number = 1;

        public var ui_color_flag:Number;
        public var fading:Boolean;
        public static const UICOLOR_DEFAULT:Number = 0;
        public static const UICOLOR_PINK:Number = 1;

        public var cursorResetFlag:Boolean = false;

        public static const EVENT_POPUP_CLOSED:String = "popup_closed";
        public static const EVENT_SINGLETILE_BG_LOADED:String = "bg_loaded";
        public static const EVENT_ENEMY_DIED:String = "enemy_died";
        public static const EVENT_BOSS_DIED:String = "boss_died";
        public static const EVENT_TEAM_POWER_INCREASED:String = "team_power_increased";

        public function GameState(snd:Boolean=true, popup:Boolean=true,
                                  messages:Boolean=true, fade:Boolean=false){
            this.updateSound = snd;
            this.updatePopup = popup;
            this.updateMessages = messages;
            this.enable_fade = fade;
            this.slug = "" + (Math.random() * 1000000);
            this.callbackRefs = new Array();
            this.notificationTextColor = 0xffffffff;

            this.ui_color_flag = UICOLOR_DEFAULT;

            this.sortedObjects = new Array();
        }

        public static function get SHORT_DIALOGUE():Boolean {
            return ScreenManager.getInstance().SHORT_DIALOGUE;
        }

        override public function create():void {
            super.create();

            this.menuButtons = new Array();

            FlxG.bgColor = 0xff000000;
            FlxG.clearCameraBuffer = false;

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

            FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, clickHandler);
            DialoguePlayer.getInstance();
        }

        override public function destroy():void {
            FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, clickHandler);
            this.callbackRefs.length = 0;
            this.callbackRefs = null;
            if (this.enable_fade) {
                this.fadeLayer.destroy();
                this.fadeLayer = null;
            }
            this.baseLayer.destroy();
            this.baseLayer = null;
            this.pauseScreen.destroy();
            this.pauseScreen = null;
            super.destroy();
        }

        public function postCreate():void {
            if (this.updatePopup && this.showEmoji) {
                PopUpManager.getInstance().loadEmoji();
            }
            if (this.updateMessages) {
                MessageManager.getInstance().reloadPersistentObjects();
                MessageManager.getInstance().setCurrentThreads();
            }
            if (this.updatePopup) {
                PopUpManager.getInstance().loadPopUps();
            }

            if(this.use_loading_screen) {
                this.loadingScreen = new LoadingScreen(this.loading_screen_timer,
                                                       this.play_loading_dialogue,
                                                       this.load_screen_text);
                this.loadingScreen.endCallback = this.loadingScreenEndCallback;
            }

            if (this.enable_fade) {
                this.add(this.fadeLayer);
            }

            if (ScreenManager.getInstance().DEBUG) {
                DebugConsoleManager.getInstance().initTextObjects();
                DebugConsoleManager.getInstance().addVisibleObjects();
            }

            if (this.enable_cursor) {
                this.game_cursor.addCursorSprites();
            }
        }

        public function loadingScreenVisible():Boolean {
            if (this.loadingScreen == null) {
                return false;
            }
            return this.loadingScreen.showing;
        }

        public function loadingScreenEndCallback():void { }

        public function fadeOut(fn:Function, postFadeWait:Number=1,
                                soundName:String=null):void
        {
            if (this.fading) {
                return;
            }
            this.fading = true;
            this.fadeSoundName = soundName;
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

        public function isOccluded(obj:GameObject):Boolean {
            var objZ:Number = this.getZIndex(obj);
            for (var i:int = objZ + 1; i < this.members.length; i++) {
                if (this.members[i] != undefined) {
                    if (!this.game_cursor.isCursorSprite(this.members[i]) && this.members[i].visible) {
                        if (obj._getRect().overlaps(this.members[i]._getRect())) {
                            return true;
                        }
                    }
                }
            }
            return false;
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
                if (!this.loadingScreenVisible()) {
                    this.clickCallback(
                        new DHPoint(FlxG.mouse.screenX, FlxG.mouse.screenY),
                        new DHPoint(FlxG.mouse.x, FlxG.mouse.y)
                    );
                }
            }
        }

        override public function update():void {
            // DO NOT call super here, since that breaks pausing
            // the following loop is copypasta from FlxGroup update, altered to
            // support pausing

            this.framesAlive++;

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
                DebugConsoleManager.getInstance().trackAttribute("FlxG.state.teamPower", "Team Power");
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
                    GlobalTimer.getInstance().setMark(
                        "endfade" + this.slug,
                        this.postFadeWait,
                        this.postFadeFn
                    );
                }
                if (this.framesAlive % this.soundFadeRate == 0) {
                    var snd:GameSound = SoundManager.getInstance().getSoundByName(this.fadeSoundName);
                    if(snd != null) {
                        snd.fadeOutSound();
                    }
                }
            }

            if (FlxG.keys.justPressed("ESCAPE")) {
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
            DialoguePlayer.getInstance().pause();
            this.pauseScreen.visible = GlobalTimer.getInstance().isPaused();
            this.game_cursor.show();
        }

        public function resume():void {
            GlobalTimer.getInstance().resume();
            SoundManager.getInstance().resume();
            DialoguePlayer.getInstance().resume();
            this.pauseScreen.visible = GlobalTimer.getInstance().isPaused();
            if (this.hide_cursor_on_unpause) {
                this.game_cursor.hide();
            }
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
            if (callbackRefs != null) {
                callbackRefs.push(callback);
                FlxG.stage.addEventListener(event, callback, false, 0, true);
            }
        }

        public function removeEventListener(event:String, callback:Function):void {
            FlxG.stage.removeEventListener(event, callback);
        }

        public function dispatchEvent(event:String):void {
            FlxG.stage.dispatchEvent(new Event(event, true, true));
        }
    }
}
