package {
    import org.flixel.*;

    public class GameState extends FlxState {
        private var updateSound:Boolean, updatePopup:Boolean,
                    updateMessages:Boolean;
        protected var game_cursor:GameCursor;

        public function GameState(snd:Boolean=true, popup:Boolean=true,
                                  messages:Boolean=true){
            this.updateSound = snd;
            this.updatePopup = popup;
            this.updateMessages = messages;
        }

        override public function create():void {
            super.create();
        }

        public function postCreate():void {
            this.game_cursor = new GameCursor();
        }

        public function updateCursor():void {
            if (this.game_cursor != null) {
                this.game_cursor.update();
            }
        }

        override public function update():void {
            super.update();

            this.updateCursor();

            if (this.updateSound) {
                SoundManager.getInstance().update();
            }
            if (this.updatePopup) {
                PopUpManager.getInstance().update();
            }
            if (this.updateMessages) {
                MessageManager.getInstance().update();
            }

            if (FlxG.keys.justPressed("P")) {
                SoundManager.getInstance().increaseVolume();
            } else if (FlxG.keys.justPressed("O")) {
                SoundManager.getInstance().decreaseVolume();
            }
        }
    }
}
