package {
    import org.flixel.*;

    public class GameState extends FlxState {
        private var updateSound:Boolean, updatePopup:Boolean,
                    updateMessages:Boolean;
        protected var game_cursor:GameCursor;
        private var pauseLayer:GameObject;

        public var newAudioLock:Boolean = true;
        public var cursorResetFlag:Boolean = false;

        public function GameState(snd:Boolean=true, popup:Boolean=true,
                                  messages:Boolean=true){
            this.updateSound = snd;
            this.updatePopup = popup;
            this.updateMessages = messages;
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
            PopUpManager.getInstance();
            MessageManager.getInstance();
            this.game_cursor = new GameCursor();
            FlxG.state.add(this.pauseLayer);
        }

        public function updateCursor():void {
            if (this.game_cursor != null) {
                this.game_cursor.update();
                if(!this.cursorResetFlag &&
                    PopUpManager.getInstance().ui_loaded &&
                    MessageManager.getInstance().ui_loaded)
                {
                    this.game_cursor.resetCursor();
                    this.cursorResetFlag = true;
                }
            }
        }

        override public function update():void {
            // DO NOT call super here, since that breaks pausing
            // the following loop is copypasta from FlxGroup update, altered to
            // support pausing
            var basic:GameObject, i:uint = 0;
            while(i < length) {
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

            this.updateCursor();

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
                GlobalTimer.getInstance().pause();
                SoundManager.getInstance().pause();
                this.pauseLayer.visible = GlobalTimer.getInstance().isPaused();
            }
        }

        public function clickCallback(screenPos:DHPoint, worldPos:DHPoint):void {}
    }
}
