package {
    import org.flixel.*;

    import flash.events.Event;

    public class GameState extends FlxState {
        protected var updateSound:Boolean, updatePopup:Boolean,
                      updateMessages:Boolean, showEmoji:Boolean = true;
        protected var game_cursor:GameCursor;
        private var pauseLayer:GameObject;
        private var sortedObjects:Array;

        public var ui_color_flag:Number;
        public static const UICOLOR_DEFAULT:Number = 0;
        public static const UICOLOR_PINK:Number = 1;

        public var cursorResetFlag:Boolean = false;

        public static const EVENT_POPUP_CLOSED:String = "popup_closed";
        public static const EVENT_CHAT_RECEIVED:String = "chat_received";

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

            this.pauseLayer = new GameObject(new DHPoint(0, 0));
            this.pauseLayer.scrollFactor = new DHPoint(0, 0);
            this.pauseLayer.active = false;
            this.pauseLayer.makeGraphic(
                ScreenManager.getInstance().screenWidth,
                ScreenManager.getInstance().screenHeight,
                0xaa000000
            );
            this.pauseLayer.visible = GlobalTimer.getInstance().isPaused();
        }

        public function postCreate():void {
            if (this.updatePopup) {
                PopUpManager.getInstance().showEmoji = this.showEmoji;
            }
            if (this.updateMessages) {
                MessageManager.getInstance();
            }
            this.game_cursor = new GameCursor();
            FlxG.state.add(this.pauseLayer);
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
            this.sortedObjects.length = 0;
            var basic:GameObject, i:uint = 0;
            while(i < length) {
                // maintain a list of GameObjects to be z-sorted by their foot position
                if (members[i] is GameObject && (members[i] as GameObject).zSorted) {
                    this.sortedObjects.push(members[i]);
                }
                basic = members[i++] as GameObject;
                if((basic != null) && basic.exists && basic.active) {
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
                PopUpManager.getInstance().showEmoji = this.showEmoji;
                PopUpManager.getInstance().update();
            }
            if (this.updateMessages) {
                MessageManager.getInstance().update();
            }

            this.updateCursor();

            if(FlxG.mouse.justPressed()) {
                this.clickCallback(
                    new DHPoint(FlxG.mouse.screenX, FlxG.mouse.screenY),
                    new DHPoint(FlxG.mouse.x, FlxG.mouse.y)
                );
            }

            if (FlxG.keys.justPressed("P")) {
                SoundManager.getInstance().increaseVolume();
            } else if (FlxG.keys.justPressed("O")) {
                SoundManager.getInstance().decreaseVolume();
            } else if (FlxG.keys.justPressed("S")) {
                this.pause();
            }
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
